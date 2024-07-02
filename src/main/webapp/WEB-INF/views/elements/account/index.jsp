<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>

<div class="account container-fluid mt-4" style="width:40%;">
	<c:if test="${not empty gvNoAccount}">
		<form action="account/create.htm" method="post">
			<div class="mb-3">
				<label>Login name: </label>
				<input name="loginname" class="form-control" required />
			</div>
			<div class="mb-3">
				<label>Password: </label>
				<input name="pass" class="form-control" required />
			</div>
			<div class="mb-3">
				<label>Mã giáo viên: </label>
				<select class="form-select" name="magv">
					<c:forEach var="gv" items="${gvNoAccount}">
						<option value="${gv[0]}" ${gv[0]==magv ? 'selected' : '' }>
							${gv[0]} (${gv[1]})
						</option>
					</c:forEach>
				</select>
			</div>
			<div class="mb-3">
				<label>Vai trò: </label>
				<c:if test="${role_al == 'TRUONG'}">
					<input name="role" value="Trường" class="form-control" disabled />
					<input name="role" value="TRUONG" class="form-control" hidden />
				</c:if>
				<c:if test="${role_al == 'COSO'}">
					<select class="form-select" name="role">
						<option value="COSO">Cơ sở</option>
						<option value="GIANGVIEN">Giảng viên</option>
					</select>
				</c:if>
			</div>
			<button class="btn btn-primary mt-2" type="button" onclick="submitClosestForm(this)">Tạo tài khoản</button>
		</form>
	</c:if>
	<c:if test="${empty gvNoAccount}"><h5>Tất cả giáo viên ở cơ sở này đã có tài khoản!</h5></c:if>
</div>
