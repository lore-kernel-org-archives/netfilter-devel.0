From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH v3 2/2] nfacct: add filter in to the list operation
Date: Thu, 11 Sep 2014 19:50:40 +0400
Message-ID: <1410450640-2414-3-git-send-email-a.perevalov@samsung.com>
References: <1410450640-2414-1-git-send-email-a.perevalov@samsung.com>
Cc: Alexey Perevalov <a.perevalov@samsung.com>,
	alexey.perevalov@hotmail.com, netfilter-devel@vger.kernel.org,
	kyungmin.park@samsung.com, hs81.go@samsung.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:28066 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627AbaIKPuv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:50:51 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBQ00MNVUTKVM50@mailout1.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Thu, 11 Sep 2014 16:53:44 +0100 (BST)
In-reply-to: <1410450640-2414-1-git-send-email-a.perevalov@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Filter feature is working through NFACCT_FILTER netlink attribute.
If kernel doesn't support it, client will not get an error
and silently will work as before.

This patch adds following command line arguments: counters, overquota,
quota-byte, quota-packet. Which could be used with list operation.
Combination of these command line options isn't allowed.

For example.
will show counters without byte/packet based quota
will reset value for overquoted counters only

Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
---
 include/linux/netfilter/nfnetlink_acct.h |    8 ++++++
 src/nfacct.c                             |   44 ++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
index 44dcd17..6c99213 100644
--- a/include/linux/netfilter/nfnetlink_acct.h
+++ b/include/linux/netfilter/nfnetlink_acct.h
@@ -28,10 +28,18 @@ enum nfnl_acct_type {
 	NFACCT_USE,
 	NFACCT_FLAGS,
 	NFACCT_QUOTA,
+	NFACCT_FILTER,
 	__NFACCT_MAX
 };
 #define NFACCT_MAX (__NFACCT_MAX - 1)
 
+enum nfnl_attr_filter_type {
+	NFACCT_FILTER_UNSPEC,
+	NFACCT_FILTER_MASK,
+	NFACCT_FILTER_VALUE,
+	__NFACCT_FILTER_MAX
+};
+
 #ifdef __KERNEL__
 
 struct nf_acct;
diff --git a/src/nfacct.c b/src/nfacct.c
index d77a57e..fbbd189 100644
--- a/src/nfacct.c
+++ b/src/nfacct.c
@@ -19,6 +19,7 @@
 #include <unistd.h>
 #include <time.h>
 #include <errno.h>
+#include <arpa/inet.h>
 
 #include <libmnl/libmnl.h>
 #include <libnetfilter_acct/libnetfilter_acct.h>
@@ -183,6 +184,8 @@ static int nfacct_cmd_list(int argc, char *argv[])
 	struct nlmsghdr *nlh;
 	unsigned int seq, portid;
 	int ret, i;
+	uint32_t mask = 0, value = 0;
+	int opt_quota_cat = 0;
 
 	for (i=2; i<argc; i++) {
 		if (strncmp(argv[i], "reset", strlen(argv[i])) == 0) {
@@ -195,6 +198,41 @@ static int nfacct_cmd_list(int argc, char *argv[])
 			CHECK_OPT_PLURARITY(opt_xml, "xml couldn't be defined "
 					    "more than once");
 			xml = true;
+		} else if (strncmp(argv[i], "counters", strlen(argv[i])) == 0) {
+			static int opt_counters;
+			CHECK_OPT_PLURARITY(opt_counters, "counters couldn't be"
+					    " defined more than once");
+			CHECK_OPT_PLURARITY(opt_quota_cat, "only one option is"
+			" allowed: counters, quota-byte, quota-packet, overquota");
+			mask = NFACCT_F_QUOTAS;
+			value = 0; /* counters isn't quotas */
+		} else if (strncmp(argv[i], "quota-byte", strlen(argv[i]))
+			   == 0) {
+			static int opt_quota_byte;
+			CHECK_OPT_PLURARITY(opt_quota_byte, "quota-byte "
+					    " couldn't be defined more than once");
+			CHECK_OPT_PLURARITY(opt_quota_cat, "only one option is"
+			" allowed: counters, quota-byte, quota-packet, overquota");
+			mask = NFACCT_F_QUOTA_BYTES;
+			value = NFACCT_F_QUOTA_BYTES;
+		} else if (strncmp(argv[i], "quota-packet", strlen(argv[i]))
+			   == 0) {
+			static int opt_quota_packet;
+			CHECK_OPT_PLURARITY(opt_quota_packet, "quota-packet "
+					    " couldn't be defined more than once");
+			CHECK_OPT_PLURARITY(opt_quota_cat, "only one option is"
+			" allowed: counters, quota-byte, quota-packet, overquota");
+			mask = NFACCT_F_QUOTA_PKTS;
+			value = NFACCT_F_QUOTA_PKTS;
+		} else if (strncmp(argv[i], "overquota", strlen(argv[i]))
+			   == 0) {
+			static int opt_overquota;
+			CHECK_OPT_PLURARITY(opt_overquota, "overquota couldn't"
+					    " be defined more than once");
+			CHECK_OPT_PLURARITY(opt_quota_cat, "only one option is"
+			" allowed: counters, quota-byte, quota-packet, overquota");
+			mask = NFACCT_F_OVERQUOTA;
+			value = NFACCT_F_OVERQUOTA;
 		} else {
 			nfacct_perror("unknown argument");
 			return -1;
@@ -206,6 +244,12 @@ static int nfacct_cmd_list(int argc, char *argv[])
 					NFNL_MSG_ACCT_GET_CTRZERO :
 					NFNL_MSG_ACCT_GET,
 				     NLM_F_DUMP, seq);
+	if (mask || value) {
+		struct nlattr *nest = mnl_attr_nest_start(nlh, NFACCT_FILTER);
+		mnl_attr_put_u32(nlh, NFACCT_FILTER_MASK, htonl(mask));
+		mnl_attr_put_u32(nlh, NFACCT_FILTER_VALUE, htonl(value));
+		mnl_attr_nest_end(nlh, nest);
+	}
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
 		nfacct_perror("mnl_socket_open");
-- 
1.7.9.5

