From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH v3 nfacct 8/29] add 2 new options: "replace" and "flush"
Date: Wed, 10 Jul 2013 19:25:06 +0100
Message-ID: <1373480727-11254-9-git-send-email-michael.zintakis@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:64004 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab3GJSZz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:25:55 -0400
Received: by mail-lb0-f178.google.com with SMTP id y6so5928739lbh.9
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 11:25:54 -0700 (PDT)
In-Reply-To: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* add "replace" option to the "add" command, allowing nfacct object to be
replaced even if it is used by the kernel/iptables;

* add "replace" and "flush" options to the "restore" command, allowing nfacct
objects to be replaced even if used by the kernel/iptables and also allow the
entire nfacct object list to be deleted, when permissable, prior to "restore"
being executed;

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 src/nfacct.c | 99 +++++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 74 insertions(+), 25 deletions(-)

diff --git a/src/nfacct.c b/src/nfacct.c
index fbf9aa6..7808ebb 100644
--- a/src/nfacct.c
+++ b/src/nfacct.c
@@ -214,29 +214,21 @@ static int nfacct_cmd_list(int argc, char *argv[])
 	return 0;
 }
 
-static int _nfacct_cmd_add(char *name, uint64_t pkts, uint64_t bytes)
+static int _nfacct_cmd_add(struct nfacct *nfacct, bool replace)
 {
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 	uint32_t portid, seq;
-	struct nfacct *nfacct;
 	int ret;
 
-	nfacct = nfacct_alloc();
-	if (nfacct == NULL) {
-		nfacct_perror("OOM");
+	if (nfacct == NULL)
 		return -1;
-	}
-
-	nfacct_attr_set(nfacct, NFACCT_ATTR_NAME, name);
-
-	nfacct_attr_set_u64(nfacct, NFACCT_ATTR_PKTS, pkts);
-	nfacct_attr_set_u64(nfacct, NFACCT_ATTR_BYTES, bytes);
 
 	seq = time(NULL);
 	nlh = nfacct_nlmsg_build_hdr(buf, NFNL_MSG_ACCT_NEW,
-				     NLM_F_CREATE | NLM_F_ACK, seq);
+				     NLM_F_CREATE | NLM_F_ACK |
+				     (replace ? NLM_F_REPLACE : 0), seq);
 	nfacct_nlmsg_build_payload(nlh, nfacct);
 
 	nfacct_free(nfacct);
@@ -278,15 +270,41 @@ static int _nfacct_cmd_add(char *name, uint64_t pkts, uint64_t bytes)
 
 static int nfacct_cmd_add(int argc, char *argv[])
 {
+	int ret = -1;
+	bool replace = false;
+	char *name;
+	struct nfacct *nfacct;
+
 	if (argc < 1 || strlen(argv[0]) == 0) {
 		nfacct_perror("missing object name");
 		return -1;
-	} else if (argc > 1) {
-		nfacct_perror("too many arguments");
+	}
+	name = strdup(argv[0]);
+	if (!name) {
+		nfacct_perror("OOM");
 		return -1;
 	}
+	NFACCT_NEXT_ARG();
+	while (argc > 0) {
+		if (!replace && nfacct_matches(argv[0],"replace")) {
+			replace = true;
+		} else {
+			NFACCT_RET_ARG_ERR();
+		}
+		argc--; argv++;
+	}
 
-	return _nfacct_cmd_add(argv[0], 0, 0);
+	nfacct = nfacct_alloc();
+	if (nfacct == NULL) {
+		NFACCT_RET_ERR("OOM");
+	}
+
+	nfacct_attr_set(nfacct, NFACCT_ATTR_NAME, name);
+	ret = _nfacct_cmd_add(nfacct, replace);
+
+err:
+	free(name);
+	return ret;
 }
 
 static int nfacct_cmd_delete(int argc, char *argv[])
@@ -509,14 +527,14 @@ static const char help_msg[] =
 	"infrastructure\n"
 	"Usage: nfacct command [parameters]...\n\n"
 	"Commands:\n"
-	"  list [reset]\t\tList the accounting object table (and reset)\n"
-	"  add object-name\tAdd new accounting object to table\n"
-	"  delete object-name\tDelete existing accounting object\n"
-	"  get object-name\tGet existing accounting object\n"
+	"  list [reset]\t\t\tList the accounting object table (and reset)\n"
+	"  add object-name [replace]\tAdd new accounting object to table\n"
+	"  delete object-name\t\tDelete existing accounting object\n"
+	"  get object-name\t\tGet existing accounting object\n"
 	"  flush\t\t\tFlush accounting object table\n"
-	"  restore\t\tRestore accounting object table reading 'list' output from stdin\n"
-	"  version\t\tDisplay version and disclaimer\n"
-	"  help\t\t\tDisplay this help message\n";
+	"  restore [flush] [replace]\tRestore accounting object table reading 'list' output from stdin\n"
+	"  version\t\t\tDisplay version and disclaimer\n"
+	"  help\t\t\t\tDisplay this help message\n";
 
 static int nfacct_cmd_help(int argc, char *argv[])
 {
@@ -530,11 +548,30 @@ static int nfacct_cmd_restore(int argc, char *argv[])
 	char name[512];
 	char buffer[512];
 	int ret;
+	bool replace = false, flush = false;
+	struct nfacct *nfacct;
 
-	if (argc > 0) {
+	if (argc > 2) {
 		nfacct_perror("too many arguments");
 		return -1;
 	}
+	while (argc > 0) {
+		if (!replace && nfacct_matches(argv[0],"replace")) {
+			replace = true;
+		} else if (!flush && nfacct_matches(argv[0],"flush")) {
+			flush = true;
+		} else {
+			NFACCT_RET_ARG_ERR();
+		}
+		argc--; argv++;
+	}
+
+	if (flush) {
+		ret = nfacct_cmd_flush(0, NULL);
+		if (ret == -1) {
+			NFACCT_RET_ERR("flush not successful");
+		}
+	}
 
 	while (fgets(buffer, sizeof(buffer), stdin)) {
 		char *semicolon = strchr(buffer, ';');
@@ -550,9 +587,21 @@ static int nfacct_cmd_restore(int argc, char *argv[])
 			nfacct_perror("error reading input");
 			return -1;
 		}
-		if ((ret = _nfacct_cmd_add(name, pkts, bytes)) != 0)
-			return ret;
+		nfacct = nfacct_alloc();
+		if (nfacct == NULL) {
+			NFACCT_RET_ERR("OOM error");
+		}
+		nfacct_attr_set(nfacct, NFACCT_ATTR_NAME, name);
+		nfacct_attr_set_u64(nfacct, NFACCT_ATTR_PKTS, pkts);
+		nfacct_attr_set_u64(nfacct, NFACCT_ATTR_BYTES, bytes);
+		ret = _nfacct_cmd_add(nfacct, replace);
+		if (ret != 0) {
+			NFACCT_RET_ERR("error during add");
+		}
 
 	}
 	return 0;
+
+err:
+	return -1;
 }
-- 
1.8.3.1

