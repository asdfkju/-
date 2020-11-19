package com.fromis._9.dto;

import java.util.Date;

import lombok.Data;

@Data
public class CommentsReplyDTO {
	private int crnum;
	private int cnum;
	private int bnum;
	private String orifilename;
	private String filename;
	private Date writedate;
	private String contents;
	private String id;
    private String expic;
    private String wd;
    private String del;
	
}
