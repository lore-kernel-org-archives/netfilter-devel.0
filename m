From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Fix for ulogd2-SIGHUP crash (and a few questions)
Date: Fri, 06 Jun 2008 01:29:25 +0200
Message-ID: <484876D5.2010706@netfilter.org>
References: <200802221554.36799.Hugo.Mildenberger@t-online.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060501030101040407010409"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Hugo Mildenberger <Hugo.Mildenberger@t-online.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40167 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754341AbYFEX3b (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jun 2008 19:29:31 -0400
In-Reply-To: <200802221554.36799.Hugo.Mildenberger@t-online.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060501030101040407010409
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Hugo,

I've been spining around my email box today and I found this. Please,
next time cc: netfilter-devel.

Hugo Mildenberger wrote:
> Pablo,
> 
> thanks for checking in timer.h.  Attached you'll find a 
> patch which fixes the logfile-reopen problem after 
> sending a SIGHUP to ulogd. The reason was that 
> config_parse_file() stuffed a stack-allocated string 
> named 'args' (stemming from wordbuf) to logfile_open  
> which in turn got assigned to a global variable 
> named 'ulogd_logfile'. 

I have applied the following patch based on yours, the credits are
stored in git changelog so IMO there's no need to keep it in the C file.

> There is reason to  assume that there are more issues 
> like this during module configuration. Currently I have 
> not yet understood which modules might be affected.
> 
> 
> Some other issues:
> 
> 1.) Perhaps using inotify instead of (or in addition to) 
> SIGUSR1?

I don't think that we need such thing, I prefer that the sysadmin have
to explicitly order a reload of the configuration file.

> 2.) grepping through kernel modules, I found in 
> nfnetlink_log.c:470 that beneath socket's fuid also 
> fgid is transmitted, while ulogd_inppkt_NFLOG.c
> and printpkt.c only want to know about uid.

I think that Eric has fixed this a one of his patchsets.

> 3.) For some reasons, I would be happy to see also the 
> pid of the socket owning process appearing at least in 
> a mysql table. I know that the somehow related "owner 
> match"  is marked "broken on SMP", but the code for 
> non-smp machines is still in place. Could you just give 
> me a hint, what the problem on smp regarding pid/owner 
> match really is, and if there are reason not to 
> transmit this information via nfnetlink_log.c.

See patch: "Remove tasklist_lock abuse in ipt{,6}owner" from Patrick
McHardy. The owner match in linux kernel <= 2.6.14 gets semaphore in a
BH which can produce a deadlock in SMP.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers


--------------060501030101040407010409
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/src/ulogd.c b/src/ulogd.c
index 3a1e3d9..8c8dc14 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -75,8 +75,8 @@
 
 /* global variables */
 static FILE *logfile = NULL;		/* logfile pointer */
-static char *ulogd_configfile = ULOGD_CONFIGFILE;
-static char *ulogd_logfile = ULOGD_LOGFILE_DEFAULT;
+static char *ulogd_logfile = NULL;
+static const char *ulogd_configfile = ULOGD_CONFIGFILE;
 static FILE syslog_dummy;
 
 static int info_mode = 0;
@@ -880,8 +880,10 @@ static void ulogd_main_loop(void)
 /* open the logfile */
 static int logfile_open(const char *name)
 {
-	if (name)
-		ulogd_logfile = name;
+	if (name) {
+	        free(ulogd_logfile);
+		ulogd_logfile = strdup(name);
+	}
 
 	if (!strcmp(name, "stdout")) {
 		logfile = stdout;
@@ -891,12 +893,12 @@ static int logfile_open(const char *name)
 	} else {
 		logfile = fopen(ulogd_logfile, "a");
 		if (!logfile) {
-			fprintf(stderr, "ERROR: can't open logfile %s: %s\n", 
+			fprintf(stderr, "ERROR: can't open logfile '%s': %s\n", 
 				name, strerror(errno));
 			exit(2);
 		}
 	}
-	ulogd_log(ULOGD_INFO, "ulogd Version %s starting\n", ULOGD_VERSION);
+	ulogd_log(ULOGD_INFO, "ulogd Version %s (re-)starting\n", ULOGD_VERSION);
 	return 0;
 }
 
@@ -959,8 +961,10 @@ static void sigterm_handler(int signal)
 
 	deliver_signal_pluginstances(signal);
 
-	if (logfile != stdout)
+	if (logfile != NULL  && logfile != stdout) {
 		fclose(logfile);
+		logfile = NULL;
+	}
 
 	exit(0);
 }
@@ -975,8 +979,13 @@ static void signal_handler(int signal)
 		if (logfile != stdout && logfile != &syslog_dummy) {
 			fclose(logfile);
 			logfile = fopen(ulogd_logfile, "a");
-			if (!logfile)
+ 			if (!logfile) {
+				fprintf(stderr, 
+					"ERROR: can't open logfile %s: %s\n", 
+					ulogd_logfile, strerror(errno));
 				sigterm_handler(signal);
+			}
+	
 		}
 		break;
 	default:
@@ -1021,6 +1030,7 @@ int main(int argc, char* argv[])
 	uid_t uid = 0;
 	gid_t gid = 0;
 
+	ulogd_logfile = strdup(ULOGD_LOGFILE_DEFAULT);
 
 	while ((argch = getopt_long(argc, argv, "c:dh::Vu:i:", opts, NULL)) != -1) {
 		switch (argch) {


--------------060501030101040407010409--
