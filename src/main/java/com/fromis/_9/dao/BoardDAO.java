package com.fromis._9.dao;

import java.sql.Date;
import java.util.HashMap;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.cursor.Cursor;
import org.apache.ibatis.session.ResultHandler;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.web.servlet.ModelAndView;

import com.fromis._9.dto.BasketDTO;
import com.fromis._9.dto.BoardDTO;
import com.fromis._9.dto.BoardPicDTO;
import com.fromis._9.dto.CommentsDTO;
import com.fromis._9.dto.CommentsLikeDTO;
import com.fromis._9.dto.CommentsReplyDTO;
import com.fromis._9.dto.ProductDTO;
import com.fromis._9.dto.ReportDTO;
import com.fromis._9.page.CommentsPaging;
import com.fromis._9.page.Paging;

@Repository
public class BoardDAO {

	@Autowired
	private SqlSessionTemplate sql;

	@Autowired
	private Map<String, Object> map;

	public List<BoardDTO> selectBoard(Paging paging) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("paging", paging);
		return sql.selectList("Board.selectBoard", map);
	}

	public int countBoard() {
		return sql.selectOne("Board.countBoard");
	}

	public List<CommentsDTO> selectComments(CommentsPaging commentsPaging, int bnum) {
		Map<String, Object> commentsMap = new HashMap<String, Object>();
		commentsMap.put("commentsPaging", commentsPaging);
		commentsMap.put("bnum", bnum);
		return sql.selectList("Board.selectComments", commentsMap);
	}

	public int boardWrite(BoardDTO board) {
		return sql.insert("Board.boardWrite", board);
	}

	public void createLike(BoardDTO board) {
		sql.insert("Board.createLike", board);
	}

	public void boardPic(BoardDTO board) {
		sql.insert("Board.boardPic", board);
	}

	public String reportCheck(int bnum) {
		return sql.selectOne("Board.reportCheck", bnum);
	}

	public BoardDTO viewPost(int bnum) {
		return sql.selectOne("Board.viewPost", bnum);
	}

	public int updateHits(int bnum) {
		return sql.update("Board.updateHits", bnum);
	}

	public List<BoardDTO> viewPostPic(int bnum) {
		return sql.selectList("Board.viewPostPic", bnum);
	}

	public int writeComments(CommentsDTO comments) {
		return sql.insert("Board.writeComments", comments);
	}

	public int modifyComments(CommentsDTO comments) {
		return sql.insert("Board.modifyComments", comments);
	}

	public int deleteComments(int cnum) {
		return sql.update("Board.deleteComments", cnum);
	}

	public List<BoardDTO> bestPost() {
		return sql.selectList("Board.bestPost");
	}

	public BoardDTO callPostForm(int bnum) {
		return sql.selectOne("Board.callPostForm", bnum);
	}

	public int updatePost(BoardDTO board) {
		return sql.update("Board.updatePost", board);
	}

	public void updatePic(BoardDTO board) {
		sql.insert("Board.updatePic", board);
	}

	public void deletePic(BoardDTO board) {
		sql.delete("Board.deletePic", board);
	}

	public int deletePost(int bnum) {
		return sql.delete("Board.deletePost", bnum);
	}

	public List<BoardDTO> search(String kind, String contents, Paging paging) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("kind", kind);
		map.put("contents", contents);
		map.put("paging", paging);
		return sql.selectList("Board.search", map);
	}

	public int searchCountBoard(String kind, String contents) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("kind", kind);
		map.put("contents", contents);
		return sql.selectOne("Board.searchCountBoard", map);
	}

	public int reportPost(ReportDTO report) {
		return sql.insert("Board.reportPost", report);
	}

	public int bwCount(String id) {
		return sql.selectOne("Board.bwCount", id);
	}

	public List<BoardDTO> boardWrittenByMe(Paging paging, String id) {
		map = new HashMap<String, Object>();
		map.put("paging", paging);
		map.put("id", id);
		return sql.selectList("Board.boardWrittenByMe", map);
	}

	public int cwCount(String id) {
		return sql.selectOne("Board.cwCount", id);
	}

	public List<CommentsDTO> commentsWrittenByMe(Paging paging, String id) {
		map = new HashMap<String, Object>();
		map.put("paging", paging);
		map.put("id", id);
		return sql.selectList("Board.commentsWrittenByMe", map);
	}

	public int reportCount() {
		return sql.selectOne("Board.reportCount");
	}

	public List<ReportDTO> selectReport(Paging paging) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("paging", paging);
		return sql.selectList("Board.selectReport", map);
	}

	public ReportDTO selectReportPost(int repnum) {
		return sql.selectOne("Board.selectReportPost", repnum);
	}

	public int acceptReport(int repnum) {
		Map<String, Object> map = new HashMap<String, Object>();
		int amount = 60 * 10;
		Date limit = new Date(System.currentTimeMillis() + (1000 * amount));
		map.put("limit", limit);
		map.put("repnum", repnum);
		String postId = sql.selectOne("Board.searchPostId", repnum);
		map.put("id", postId);
		sql.update("Board.loginban", map);
		return sql.update("Board.acceptReport", repnum);

	}

	public List<BoardDTO> popularPost() {
		return sql.selectList("Board.popularPost");
	}

	public List<BoardPicDTO> selectBoardPic() {
		return sql.selectList("Board.selectBoardPic");
	}

	public List<BoardDTO> boardListPagingByPhoto(Paging paging) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("paging", paging);
		return sql.selectList("Board.boardListPagingByPhoto", map);
	}

	public int countBoardByPhoto() {
		return sql.selectOne("Board.countBoardByPhoto");
	}

	public Integer getBpnum(int bnum) {
		return sql.selectOne("Board.getBpnum", bnum);
	}

	public BoardDTO boardListByPhoto(int bpnum) {
		return sql.selectOne("Board.boardListByPhoto", bpnum);
	}

	public List<CommentsReplyDTO> selectCommentsReplyList(int bnum) {
		return sql.selectList("Board.selectCommentsReplyList", bnum);
	}

	public int writeCommentsReply(CommentsReplyDTO commentsReply) {
		return sql.insert("Board.writeCommentsReply", commentsReply);
	}

	public int countComments(int bnum) {
		return sql.selectOne("Board.countComments", bnum);
	}

	public int selectCommentsLike(CommentsLikeDTO commentsLike) {
		return sql.selectOne("Board.selectCommentsLike", commentsLike);
	}

	public void deleteCommentsLike(CommentsLikeDTO commentsLike) {
		// commentslike 테이블에서 삭제
		sql.delete("Board.deleteCommentsLike", commentsLike);
	}

	public void resetCommentsLike(CommentsLikeDTO commentsLike) {
		sql.update("Board.resetCommentsLike", commentsLike);
	}

	public void insertCommentsLike(CommentsLikeDTO commentsLike) {
		sql.insert("Board.insertCommentsLike", commentsLike);
	}

	public void commentsLike(CommentsLikeDTO commentsLike) {
		sql.update("Board.commentsLike", commentsLike);
	}

	public int verifyBestComments(int bnum) {
		return sql.selectOne("Board.verifyBestComments", bnum);
	}

	public void bestComments(int cnum) {
		sql.update("Board.bestComments", cnum);
	}

	public void resetPreviousBestComments(int bnum) {
		sql.update("Board.resetPreviousBestComments", bnum);
	}

	public List<CommentsDTO> selectCommentsNotPaging(int bnum) {
		return sql.selectList("Board.selectCommentsNotPaging", bnum);
	}

	public int registerProduct(ProductDTO product) {
		return sql.insert("Board.registerProduct", product);
	}

	public int countProduct() {
		return sql.selectOne("Board.countProduct");
	}

	public List<ProductDTO> selectProduct(Paging paging) {
		return sql.selectList("Board.selectProduct", paging);
	}

	public List<BasketDTO> selectBasket(String id) {
		return sql.selectList("Board.selectBasket", id);
	}

	public int containBasket(ProductDTO product, String id) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("product", product);
		map.put("id", id);
		return sql.insert("Board.containBasket", map);
	}

	public int isContainThatProduct(ProductDTO product, String id) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("product", product);
		map.put("id", id);
		return sql.selectOne("Board.isContainThatProduct", map);
	}

	public int updateBasket(ProductDTO product, String id) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("product", product);
		map.put("id", id);
		return sql.update("Board.updateBasket", map);
	}

	public int deleteThatProduct(ProductDTO product, String id) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("product", product);
		map.put("id", id);
		return sql.delete("Board.deleteThatProduct", map);
	}

	public int changeAmount(BasketDTO basket) {
		return sql.update("Board.changeAmount", basket);
	}

	public Integer selectBasketSum(BasketDTO basket) {
		return sql.selectOne("Board.selectBasketSum", basket);
	}

	public int removeThatProduct(BasketDTO basket) {
		return sql.delete("Board.removeThatProduct", basket);
	}

	public BasketDTO paymentUserInfo(BasketDTO basket) {
		return sql.selectOne("Board.paymentUserInfo", basket);
	}

	public int deleteBasket(BasketDTO basket) {
		return sql.delete("Board.deleteBasket", basket);
	}

	public List<ProductDTO> subProduct() {
		return sql.selectList("Board.subProduct");
	}

	public int insertProduct(ProductDTO productDTO) {
		return sql.update("Board.insertProduct", productDTO);
	}

	public int deleteProduct(int pnum) {
		return sql.delete("Board.deleteProduct",pnum);
	}

}
