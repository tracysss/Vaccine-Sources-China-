libname vac "D:\Users\Tracy S\Cloud Hands\Vaccine";

filename hubei url "http://news.pharmnet.com.cn/news/2017/10/25/481915.html";

*filename hainan  "D:\Users\Tracy S\Cloud Hands\Vaccine\hainan.html";
data hubei;

infile hubei length=len lrecl=32767;
input line $varying32767. len;

output;

run;
filename hubei clear;



data hubei_results;
	set hubei;
	row=_n_;
	if index(line, "tbody") >0 then tbody=1;else tbody=0;
run;
proc freq data=hubei_results;
	table tbody;
run;
proc print data=hubei_results;
	where tbody=1;
run;
data hubei_results;
	set hubei_results;
	if row>121 and row<4778;
	if index(line,"div")>0;
run;
data hubei_results(drop=tbody);
	set hubei_results;
	row=_n_;
	col=mod(row,12);

run;
proc print data=hubei_results;
	where col=1;
run;
proc print data=hubei_results;
	where row>=348 and row<=374;
run;
data hubei_results;
	set hubei_results;
	where row ne 361 and row ne 362;
run;
data hubei_results;
	set hubei_results;
	row=_n_;
run;

data hubei_results;
	set hubei_results;
	row=_n_;
	col=mod(row,12);
run;

proc print data=hubei_results;
	where row>=1005	 and row<=1033;
run;
data hubei_results;
	set hubei_results;
	where row ne 1021 and row ne 1022;
run;
data hubei_results;
	set hubei_results;
	row=_n_;
run;

data hubei_results;
	set hubei_results;
	row=_n_;
	col=mod(row-1,12);
	new_row=floor((row-1)/12);

run;

data hubei_results1;
	set hubei_results;
	line=tranwrd(line, "</div>", "");
	line=tranwrd(line, "<div>", "");

run;



data hubei_results1;
	set hubei_results1;*(drop=col_name);
	if col=0 then col_name="num              ";
	if col=1 then col_name="vac_type";
	if col=2 then col_name="vac_name";
	if col=3 then col_name="form";
	if col=4 then col_name="composition";
	if col=5 then col_name="packing_unit";
	if col=6 then col_name="prep_unit";
	if col=7 then col_name="conversion_factor";
	if col=8 then col_name="packing_material";
	if col=9 then col_name="approval_number";
	if col=10 then col_name="company_name";
	if col=11 then col_name="price";
	where new_row>0;
	province="hubei";
	record_year=2017;

run;
proc transpose data=hubei_results1 out=vac.hubei_results; 
	by new_row;
 	var line;
 	id col_name;

run; 
data vac.hubei_results; 
	set vac.hubei_results; 
	keep num vac_type vac_name form composition packing_unit conversion_factor packing_material
		approval_number company_name price province record_year;
run;
