package com.fromis._9.dto;

import java.util.Date;
import lombok.Data;

@Data
public class CommentsDTO {

	private int cnum;
	private int bnum;
	private String id;
	private String contents;
	private Date writedate;
    private String wd;
    private String filename;
    private String orifilename;
    private String expic;
    private String del;
    private int likes;
    private String best;
    private int maxlikes;
    
    private String title;


}
