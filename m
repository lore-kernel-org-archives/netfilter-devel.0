From: Juan Carlos Castro y Castro <jcastro@vialink.com.br>
Subject: Li'l time match userspace patch o' mine
Date: Sat, 04 Oct 2003 21:25:02 -0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F7F64DE.4070506@vialink.com.br>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010004050500080100060705"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------010004050500080100060705
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This makes --days optional; if user gives only; if user gives only 
--timestart and --timestop the rule will be recorded as if all weekdays 
were specified (intuitive IMHO).

You'll see I accomplished this in a rather ugly fashion (taking 
advantage of the fact there are options that remain mandatory). I'm sure 
there is a better way, but this works and the ugliness is totally 
limited to userspace. Is this acceptable?

--------------010004050500080100060705
Content-Type: text/plain;
 name="time-match-days-optional.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="time-match-days-optional.patch"

--- libipt_time.c.prejuan	2003-10-04 20:48:55.000000000 -0300
+++ libipt_time.c	2003-10-04 21:10:45.000000000 -0300
@@ -17,10 +17,11 @@
 {
 	printf(
 "TIME v%s options:\n"
-" --timestart value --timestop value --days listofdays\n"
-"          timestart value : HH:MM\n"
-"          timestop  value : HH:MM\n"
-"          listofdays value: a list of days to apply -> ie. Mon,Tue,Wed,Thu,Fri. Case sensitive\n",
+" --timestart value --timestop value [ --days listofdays ]\n"
+"          timestart  value : HH:MM\n"
+"          timestop   value : HH:MM\n"
+"          listofdays value : a list of days to apply\n"
+"                             -> ie. Mon,Tue,Wed,Thu,Fri. Case sensitive\n",
 IPTABLES_VERSION);
 }
 
@@ -173,6 +174,7 @@
       unsigned int *nfcache,
       struct ipt_entry_match **match)
 {
+	static int setdaysalready = 0;	/* major cheat! */
 	struct ipt_time_info *timeinfo = (struct ipt_time_info *)(*match)->data;
 	int hours, minutes;
 
@@ -180,6 +182,11 @@
 	{
 		/* timestart */
 	case '1':
+		if (!setdaysalready)
+		{
+			globaldays = 127;	/* All of them if not given */
+			timeinfo->days_match = globaldays;
+		}
 		if (invert)
 			exit_error(PARAMETER_PROBLEM,
                                    "unexpected '!' with --timestart");
@@ -192,6 +199,11 @@
 		break;
 		/* timestop */
 	case '2':
+		if (!setdaysalready)
+		{
+			globaldays = 127;	/* All of them if not given */
+			timeinfo->days_match = globaldays;
+		}
 		if (invert)
 			exit_error(PARAMETER_PROBLEM,
                                    "unexpected '!' with --timestop");
@@ -205,6 +217,7 @@
 
 		/* days */
 	case '3':
+		setdaysalready = 1;
 		if (invert)
 			exit_error(PARAMETER_PROBLEM,
                                    "unexpected '!' with --days");
@@ -225,9 +238,10 @@
 static void
 final_check(unsigned int flags)
 {
-	if (flags != (IPT_TIME_START | IPT_TIME_STOP | IPT_TIME_DAYS))
+	if (flags != (IPT_TIME_START | IPT_TIME_STOP | IPT_TIME_DAYS) &&
+	    flags != (IPT_TIME_START | IPT_TIME_STOP))
 		exit_error(PARAMETER_PROBLEM,
-			   "TIME match: You must specify `--timestart --timestop and --days'");
+			   "TIME match: You must specify `--timestart and --timestop'");
 }
 
 

--------------010004050500080100060705--
