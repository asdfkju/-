package com.fromis._9.dto;

import java.util.Date;

import lombok.Data;

@Data
public class BoardDTO {

	private int bnum;
	private String id;
	private String title;
	private String contents;
	private int hits;
	private String report;
    private String filename;
    private String orifilename;
    private Date writedate;
	private int mkey;
	private String wd;
	
	//수정할 때 구분
	private String distinct;
	//검색할 때
	private String kind; 

}
