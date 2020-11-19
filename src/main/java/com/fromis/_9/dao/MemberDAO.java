package com.fromis._9.dao;

import java.io.File;

import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.fromis._9.dto.BoardLikeDTO;
import com.fromis._9.dto.MemberDTO;
import com.fromis._9.page.Paging;

@Repository
public class MemberDAO {

	@Autowired
	private SqlSessionTemplate sql;

	public boolean checkId(String id) {
		int count=sql.selectOne("Member.checkId", id);
		if(count>0) {
			return false;
		}
		return true;
	}

	public boolean checkEmail(String email) {
		System.out.println(email);
		int count=sql.selectOne("Member.checkEmail", email);
		if(count>0) {
			return true;
		}
		return false;
	}

	public boolean createMember(MemberDTO member) {
		System.out.println(member);
		int result=sql.insert("Member.createMember",member);
		if(result>0) {
			return true;
		}
		return false;
	}

	public MemberDTO login(MemberDTO member) {
		return sql.selectOne("Member.login",member);
	}
	
	public boolean searchID(MemberDTO member) {
		String id=sql.selectOne("Member.searchID", member);
		if(id!=null) {
			member.setId(id);
			return true;
		}
		else {
			return false;
		}
	}

	public boolean searchPW(MemberDTO member) {
		String password=sql.selectOne("Member.searchPW", member);
		if(password!=null) {
			member.setPassword(password);
			return true;
		}
		else {
			return false;
		}
	}

	public void searchKind(MemberDTO member) {
		String kind=sql.selectOne("Member.searchKind", member);
		member.setKind(kind);
	}

	public int countMember() {
		int count=sql.selectOne("Member.countMember");
		return count;
	}

	public boolean emailUpdate(MemberDTO member) {
		int result=sql.update("Member.emailUpdate", member);
		if(result>0) {
			return true;
		}
		else {
			return false;
		}
	}
	
	public String currentEmail(String id) {
		return sql.selectOne("Member.currentEmail", id);
	}

    public void keepLogin(String uid, String sessionId, Date next){
        Map<String, Object> map =new HashMap<String,Object>();
        map.put("userId", uid);
        map.put("sessionId", sessionId);
        map.put("next", next);
        sql.update("Member.keepLogin",map);
    }
 
    // 이전에 로그인한 적이 있는지, 즉 유효시간이 넘지 않은 세션을 가지고 있는지 체크한다.
    public MemberDTO checkUserWithSessionKey(String sessionId){
        // 유효시간이 남아있고(>now()) 전달받은 세션 id와 일치하는 사용자 정보를 꺼낸다.
        return sql.selectOne("Member.checkUserWithSessionKey",sessionId);
     
    }

	public boolean checkperiod(MemberDTO member) {
		int count=sql.selectOne("Member.checkperiod", member);
		if(count>0) {
			return true;
		}
		else {
			return false;
		}
	}

	public String usersEmail(String id) {
		return sql.selectOne("Member.usersEmail", id);
	}

	public MemberDTO miForm(String id) {
		return sql.selectOne("Member.miForm", id);
	}

	public int modifyMI(MemberDTO member) {
		return sql.insert("Member.modifyMI",member);
	}

	public int memberWithdrawal(MemberDTO member) {
		return sql.delete("Member.memberWithdrawal",member);
	}

	public BoardLikeDTO selectBoardLike(BoardLikeDTO boardLike) {
		return sql.selectOne("Member.selectBoardLike",boardLike);
	}

	public int like(BoardLikeDTO boardLike) {
		return sql.update("Member.like",boardLike);
	}
	public int dislike(BoardLikeDTO boardLike) {
		return sql.update("Member.dislike",boardLike);
	}
	public BoardLikeDTO searchLikeUser(BoardLikeDTO boardLike) {
		return sql.selectOne("Member.searchLikeUser",boardLike);
	}
	public int deleteLike(String me) {
		return sql.delete("Member.deleteLike",me);
	}
	public int deleteDislike(String me) {
		return sql.delete("Member.deleteDislike",me);
	}

	public int like2(BoardLikeDTO boardLike) {
		return sql.update("Member.like2",boardLike);
	}
	public int dislike2(BoardLikeDTO boardLike) {
		return sql.update("Member.dislike2",boardLike);
	}

	
	public void returnLike(String me) {
		sql.update("Member.returnLike",me);
	}
	public void returnDislike(String me) {
		sql.update("Member.returnDislike",me);
	}

	//관리자용
	public int memberCount() {
		return sql.selectOne("Member.memberCount");
	}

	public List<MemberDTO> selectMember(Paging paging) {
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("paging",paging);
		return sql.selectList("Member.selectMember",map);
	}
	
}
