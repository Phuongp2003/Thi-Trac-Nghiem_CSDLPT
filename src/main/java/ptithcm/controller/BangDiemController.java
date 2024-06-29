package ptithcm.controller;

import java.util.List;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import ptithcm.JDBCtemplate.BangDiemJDBCTemplate;
import ptithcm.JDBCtemplate.MonHocJDBCTemplate;
import ptithcm.JDBCtemplate.KhoaLopJDBCTemplate;
import ptithcm.bean.GlobalVariable;
import ptithcm.bean.Lop;
import ptithcm.bean.MonHoc;
import ptithcm.util.DateFM;

@Controller
@RequestMapping("score-list")
public class BangDiemController {
    @Autowired
    private GlobalVariable currentConnection;

    @Autowired
    BangDiemJDBCTemplate bangDiemJDBCTemplate;

    @Autowired
    MonHocJDBCTemplate monHocJDBCTemplate;

    @Autowired
    KhoaLopJDBCTemplate khoaLopJDBCTemplate;

    @RequestMapping(value = "", method = RequestMethod.POST)
    public String list(ModelMap model, @RequestParam("malop") String malop,
            @RequestParam("mamh") String mamh, @RequestParam("lanthi") int lanthi, HttpSession session) {
        GlobalVariable currentConnection = (GlobalVariable) session.getAttribute("currentConnection");
        if (currentConnection != null) {
            bangDiemJDBCTemplate.setDataSource(currentConnection.getSite());
            monHocJDBCTemplate.setDataSource(currentConnection.getSite());
            khoaLopJDBCTemplate.setDataSource(currentConnection.getSite());
            List<List<String>> bangdiems = bangDiemJDBCTemplate.listBangDiem(malop, mamh, lanthi);
            MonHoc monhoc = monHocJDBCTemplate.getMonHoc(mamh);
            Lop lop = khoaLopJDBCTemplate.getLop(malop);
            model.addAttribute("bangdiems", bangdiems);
            model.addAttribute("monhoc", monhoc);
            model.addAttribute("lop", lop);
        } else {
            model.addAttribute("message", "Không có bảng điểm nào!");
        }
        model.addAttribute("role_al", currentConnection.getRoleAlias());
        model.addAttribute("DateFM", new DateFM());
        return "pages/score_subject";
    }
}
