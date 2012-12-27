From: Eric Leblond <eric@regit.org>
Subject: [nfacct PATCH] Add restore command
Date: Thu, 27 Dec 2012 09:16:33 +0100
Message-ID: <1356596193-2782-1-git-send-email-eric@regit.org>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:45131 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab2L0IRw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Dec 2012 03:17:52 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a 'restore' command to nfacct commands. It takes
the output of 'list' command and use it to restore the counters.
Basically, the user can save the counter with:
 nfacct list >nfacct.dump
And restore them with:
 nfacct restore <nfacct.dump

Signed-off-by: Eric Leblond <eric@regit.org>
---
 nfacct.8     |    4 ++++
 src/nfacct.c |   59 ++++++++++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 53 insertions(+), 10 deletions(-)

diff --git a/nfacct.8 b/nfacct.8
index 96c16c2..554bc3b 100644
--- a/nfacct.8
+++ b/nfacct.8
@@ -17,6 +17,10 @@ specified at any given time.
 .BI "list "
 List the existing accounting object in table.
 .TP
+.BI "restore "
+Restore accounting object table by reading from stdin. Input format is the one used
+as output by the list command.
+.TP
 .BI "add "
 Add new accounting object.
 .TP
diff --git a/src/nfacct.c b/src/nfacct.c
index 8407670..d1f641a 100644
--- a/src/nfacct.c
+++ b/src/nfacct.c
@@ -31,6 +31,7 @@ enum {
 	NFACCT_CMD_FLUSH,
 	NFACCT_CMD_VERSION,
 	NFACCT_CMD_HELP,
+	NFACCT_CMD_RESTORE,
 };
 
 static int nfacct_cmd_list(int argc, char *argv[]);
@@ -40,6 +41,7 @@ static int nfacct_cmd_get(int argc, char *argv[]);
 static int nfacct_cmd_flush(int argc, char *argv[]);
 static int nfacct_cmd_version(int argc, char *argv[]);
 static int nfacct_cmd_help(int argc, char *argv[]);
+static int nfacct_cmd_restore(int argc, char *argv[]);
 
 static void usage(char *argv[])
 {
@@ -79,6 +81,8 @@ int main(int argc, char *argv[])
 		cmd = NFACCT_CMD_VERSION;
 	else if (strncmp(argv[1], "help", strlen(argv[1])) == 0)
 		cmd = NFACCT_CMD_HELP;
+	else if (strncmp(argv[1], "restore", strlen(argv[1])) == 0)
+		cmd = NFACCT_CMD_RESTORE;
 	else {
 		fprintf(stderr, "nfacct v%s: Unknown command: %s\n",
 			VERSION, argv[1]);
@@ -108,6 +112,9 @@ int main(int argc, char *argv[])
 	case NFACCT_CMD_HELP:
 		ret = nfacct_cmd_help(argc, argv);
 		break;
+	case NFACCT_CMD_RESTORE:
+		ret = nfacct_cmd_restore(argc, argv);
+		break;
 	}
 	return ret < 0 ? EXIT_FAILURE : EXIT_SUCCESS;
 }
@@ -211,7 +218,7 @@ static int nfacct_cmd_list(int argc, char *argv[])
 	return 0;
 }
 
-static int nfacct_cmd_add(int argc, char *argv[])
+static int _nfacct_cmd_add(char *name, int pkts, int bytes)
 {
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
@@ -220,21 +227,16 @@ static int nfacct_cmd_add(int argc, char *argv[])
 	struct nfacct *nfacct;
 	int ret;
 
-	if (argc < 3) {
-		nfacct_perror("missing object name");
-		return -1;
-	} else if (argc > 3) {
-		nfacct_perror("too many arguments");
-		return -1;
-	}
-
 	nfacct = nfacct_alloc();
 	if (nfacct == NULL) {
 		nfacct_perror("OOM");
 		return -1;
 	}
 
-	nfacct_attr_set(nfacct, NFACCT_ATTR_NAME, argv[2]);
+	nfacct_attr_set(nfacct, NFACCT_ATTR_NAME, name);
+
+	nfacct_attr_set_u64(nfacct, NFACCT_ATTR_PKTS, pkts);
+	nfacct_attr_set_u64(nfacct, NFACCT_ATTR_BYTES, bytes);
 
 	seq = time(NULL);
 	nlh = nfacct_nlmsg_build_hdr(buf, NFNL_MSG_ACCT_NEW,
@@ -276,6 +278,21 @@ static int nfacct_cmd_add(int argc, char *argv[])
 	return 0;
 }
 
+
+
+static int nfacct_cmd_add(int argc, char *argv[])
+{
+	if (argc < 3) {
+		nfacct_perror("missing object name");
+		return -1;
+	} else if (argc > 3) {
+		nfacct_perror("too many arguments");
+		return -1;
+	}
+
+	return _nfacct_cmd_add(argv[2], 0, 0);
+}
+
 static int nfacct_cmd_delete(int argc, char *argv[])
 {
 	struct mnl_socket *nl;
@@ -496,6 +513,7 @@ static const char help_msg[] =
 	"  delete object-name\tDelete existing accounting object\n"
 	"  get object-name\tGet existing accounting object\n"
 	"  flush\t\t\tFlush accounting object table\n"
+	"  restore\t\tRestore accounting object table reading 'list' output from stdin\n"
 	"  version\t\tDisplay version and disclaimer\n"
 	"  help\t\t\tDisplay this help message\n";
 
@@ -504,3 +522,24 @@ static int nfacct_cmd_help(int argc, char *argv[])
 	printf(help_msg, VERSION, argv[0]);
 	return 0;
 }
+
+static int nfacct_cmd_restore(int argc, char *argv[])
+{
+	uint64_t pkts, bytes;
+	char name[512];
+	char buffer[512];
+	int ret;
+	while (fgets(buffer, sizeof(buffer), stdin)) {
+		char *semicolon = strchr(buffer, ';');
+		if (semicolon == NULL) {
+			return -1;
+		}
+		*semicolon = 0;
+		sscanf(buffer, "{ pkts = %lu, bytes = %lu } = %s",
+		       &pkts, &bytes, name);
+		if ((ret = _nfacct_cmd_add(name, pkts, bytes)) != 0)
+			return ret;
+
+	}
+	return 0;
+}
-- 
1.7.10.4

