From: Max Kellermann <max@duempel.org>
Subject: [iptables PATCH trunk7285 3/7] use size_t
Date: Sun, 27 Jan 2008 19:25:03 +0100
Message-ID: <20080127182503.15959.46545.stgit@woodpecker.roonstrasse.net>
References: <20080127182421.15959.52088.stgit@woodpecker.roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:56470 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753362AbYA0ShO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Jan 2008 13:37:14 -0500
In-Reply-To: <20080127182421.15959.52088.stgit@woodpecker.roonstrasse.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


---

 extensions/libxt_NFLOG.c |    9 +++++----
 iptables-restore.c       |    2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)


diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index a948237..e96878c 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -45,6 +45,7 @@ static int NFLOG_parse(int c, char **argv, int invert, unsigned int *flags,
 {
 	struct xt_nflog_info *info = (struct xt_nflog_info *)(*target)->data;
 	int n;
+	size_t length;
 
 	switch (c) {
 	case NFLOG_GROUP:
@@ -69,15 +70,15 @@ static int NFLOG_parse(int c, char **argv, int invert, unsigned int *flags,
 			exit_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --nflog-prefix");
 
-		n = strlen(optarg);
-		if (n == 0)
+		length = strlen(optarg);
+		if (length == 0)
 			exit_error(PARAMETER_PROBLEM,
 				   "No prefix specified for --nflog-prefix");
-		if (n >= sizeof(info->prefix))
+		if (length >= sizeof(info->prefix))
 			exit_error(PARAMETER_PROBLEM,
 				   "--nflog-prefix too long, max %Zu characters",
 				   sizeof(info->prefix) - 1);
-		if (n != strlen(strtok(optarg, "\n")))
+		if (length != strlen(strtok(optarg, "\n")))
 			exit_error(PARAMETER_PROBLEM,
 				   "Newlines are not allowed in --nflog-prefix");
 		strcpy(info->prefix, optarg);
diff --git a/iptables-restore.c b/iptables-restore.c
index f328bd8..30746ff 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -320,7 +320,7 @@ main(int argc, char *argv[])
 			/* the parser */
 			char *curchar;
 			int quote_open;
-			int param_len;
+			size_t param_len;
 
 			/* reset the newargv */
 			newargc = 0;


