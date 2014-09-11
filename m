From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH v3 1/2] nfacct: check cmd line argument for singleness
Date: Thu, 11 Sep 2014 19:50:39 +0400
Message-ID: <1410450640-2414-2-git-send-email-a.perevalov@samsung.com>
References: <1410450640-2414-1-git-send-email-a.perevalov@samsung.com>
Cc: Alexey Perevalov <a.perevalov@samsung.com>,
	alexey.perevalov@hotmail.com, netfilter-devel@vger.kernel.org,
	kyungmin.park@samsung.com, hs81.go@samsung.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:28061 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756693AbaIKPuq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:50:46 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBQ002IZUTECF50@mailout1.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Thu, 11 Sep 2014 16:53:38 +0100 (BST)
In-reply-to: <1410450640-2414-1-git-send-email-a.perevalov@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It was possible to specify several equal options for list operation.

Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
---
 src/nfacct.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/src/nfacct.c b/src/nfacct.c
index 091a5c9..d77a57e 100644
--- a/src/nfacct.c
+++ b/src/nfacct.c
@@ -25,6 +25,13 @@
 #include <linux/netfilter/nfnetlink_acct.h>
 #include <linux/netfilter/nfnetlink.h>
 
+#define CHECK_OPT_PLURARITY(opt_name, msg) \
+	opt_name += 1; \
+	if (opt_name > 1) { \
+		nfacct_perror(msg); \
+		return -1; \
+	}
+
 enum {
 	NFACCT_CMD_NONE = 0,
 	NFACCT_CMD_LIST,
@@ -166,6 +173,8 @@ err:
 	return MNL_CB_OK;
 }
 
+#define NFACCT_F_QUOTAS (NFACCT_F_QUOTA_BYTES | NFACCT_F_QUOTA_PKTS)
+
 static int nfacct_cmd_list(int argc, char *argv[])
 {
 	bool zeroctr = false, xml = false;
@@ -177,8 +186,14 @@ static int nfacct_cmd_list(int argc, char *argv[])
 
 	for (i=2; i<argc; i++) {
 		if (strncmp(argv[i], "reset", strlen(argv[i])) == 0) {
+			static int opt_reset;
+			CHECK_OPT_PLURARITY(opt_reset, "reset couldn't be "
+				            "defined more than once");
 			zeroctr = true;
 		} else if (strncmp(argv[i], "xml", strlen(argv[i])) == 0) {
+			static int opt_xml;
+			CHECK_OPT_PLURARITY(opt_xml, "xml couldn't be defined "
+					    "more than once");
 			xml = true;
 		} else {
 			nfacct_perror("unknown argument");
@@ -191,7 +206,6 @@ static int nfacct_cmd_list(int argc, char *argv[])
 					NFNL_MSG_ACCT_GET_CTRZERO :
 					NFNL_MSG_ACCT_GET,
 				     NLM_F_DUMP, seq);
-
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
 		nfacct_perror("mnl_socket_open");
-- 
1.7.9.5

