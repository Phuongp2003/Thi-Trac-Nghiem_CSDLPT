package ptithcm.controller;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import ptithcm.JDBCtemplate.SinhVienJDBCTemplate;
import ptithcm.bean.GlobalVariable;
import ptithcm.service.GiaoVienService;
import ptithcm.service.SinhVienService;

@Controller
@RequestMapping("/auth")
public class UserController {
    @Autowired
    private GlobalVariable currentConnection;

    @Autowired
    private JdbcTemplate mainSiteTemplate;

    @Autowired
    private SinhVienService sinhVienService;

    @Autowired
    private GiaoVienService giaoVienService;

    @Autowired
    private DriverManagerDataSource firstSite;

    @Autowired
    private DriverManagerDataSource secondSite;

    @Autowired
    private DriverManagerDataSource reportSite;

    @RequestMapping("/login")
    public String login(Model model, HttpSession session,
            @RequestParam(value = "message", required = false) String message,
            RedirectAttributes redirectAttributes) {
        if (message != null) {
            redirectAttributes.addFlashAttribute("message", message);
            return "redirect:/auth/login.htm";
        }
        model.addAttribute("title", "Đăng nhập");
        model.addAttribute("type", "login");
        return "pages/login";
    }

    @RequestMapping("/logout")
    public String logout(Model model, HttpSession session,
            @RequestParam(value = "message", required = false) String message,
            RedirectAttributes redirectAttributes,
            @CookieValue(value = "username", defaultValue = "") String username,
            HttpServletResponse response) {
        model.addAttribute("title", "Home");
        model.addAttribute("type", "home");
        session.removeAttribute("currentConnection");

        Cookie usernameCookie = new Cookie("username", null);
        usernameCookie.setMaxAge(0);
        usernameCookie.setPath("/");

        response.addCookie(usernameCookie);

        redirectAttributes.addFlashAttribute("message", "logout-success");
        return "redirect:/home.htm";
    }

    @RequestMapping(value = "check-login", method = RequestMethod.POST)
    public String checkLogin(Model model,
            @RequestParam("site") int site,
            @RequestParam("username") String username,
            @RequestParam("password") String password,
            @RequestParam("usertype") String usertype,
            HttpSession session,
            HttpServletResponse response) {
        String svUsername = username;
        String svPassword = password;
        GlobalVariable currentConnection = new GlobalVariable();
        try {
            // Check site
            switch (site) {
                case 1:
                    currentConnection.setSite(firstSite);
                    break;
                case 2:
                    currentConnection.setSite(secondSite);
                    break;
                case 3:
                    currentConnection.setSite(reportSite);
                    break;
                default:
                    throw new Exception("SITE NOT FOUND");
            }

            // Check role
            if (usertype.equals("SV")) {
                currentConnection.setUsername("SV");
                username = "SV";
                password = "SV";
            }

            // Login to sql
            currentConnection.setUsername(username);
            currentConnection.setPassword(password);

            // Check login - Server
            currentConnection.getSite().getConnection();

            // Check login - DB
            if (usertype.equals("SV")) {
                sinhVienService.setDataSource(currentConnection.getSite());
                List<String> sinhVienInfo = sinhVienService.dangNhap(svUsername, svPassword);
                System.out.println(sinhVienInfo);
                currentConnection.setCurrentUser(username, sinhVienInfo.get(0), "Sinh Viên");
            } else {
                giaoVienService.setDataSource(currentConnection.getSite());
                List<String> giaoVienInfo = giaoVienService.dangNhap(username);
                System.out.println(giaoVienInfo);
                currentConnection.setCurrentUser(username, giaoVienInfo.get(1), "GV");
            }

            Cookie usernameCookie = new Cookie("username", currentConnection.getCurrentUser().getUsername());

            usernameCookie.setMaxAge(60 * 60 * 1);
            usernameCookie.setPath("/");
            response.addCookie(usernameCookie);

        } catch (SQLException e) {
            System.out.println("LOGIN FAIL" + e);
            model.addAttribute("type", "login");
            model.addAttribute("message", "Thông tin đăng nhập không chính xác!");
            return "redirect:/auth/login.htm";
        } catch (Exception e) {
            System.out.println("LOGIN FAIL" + e);
            model.addAttribute("type", "login");
            model.addAttribute("message", "Không tồn tại cơ sở!");
            return "redirect:/auth/login.htm";
        }
        session.setAttribute("currentConnection", currentConnection);
        model.addAttribute("title", "PTITHCM Book Shop");
        model.addAttribute("type", "home");
        model.addAttribute("currentConnection", currentConnection);
        model.addAttribute("message", "login-success");
        return "redirect:/home.htm";
    }

    @RequestMapping(value = "user-info", method = RequestMethod.POST)
    public String userInfo(Model model, HttpSession session) {
        GlobalVariable currentConnection = (GlobalVariable) session.getAttribute("currentConnection");
        model.addAttribute("fullname", currentConnection.getCurrentUser().getFullname());
        model.addAttribute("role", currentConnection.getCurrentUser().getRole());
        return "elements/user_info_bar";
    }

    @RequestMapping(value = "test", method = RequestMethod.POST)
    public String test(Model model, HttpSession session) {

        return "pages/home";
    }
}
