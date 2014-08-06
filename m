From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH] nfacct: add filter in to the list operation
Date: Wed, 06 Aug 2014 14:53:04 +0400
Message-ID: <1407322384-4655-2-git-send-email-a.perevalov@samsung.com>
References: <1407322384-4655-1-git-send-email-a.perevalov@samsung.com>
Cc: Alexey Perevalov <a.perevalov@samsung.com>,
	alexey.perevalov@hotmail.com, mathieu.poirier@linaro.org,
	netfilter-devel@vger.kernel.org, kyungmin.park@samsung.com,
	hs81.go@samsung.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39205 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634AbaHFKxK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Aug 2014 06:53:10 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9V00HL0SWEKYB0@mailout1.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Wed, 06 Aug 2014 11:53:02 +0100 (BST)
In-reply-to: <1407322384-4655-1-git-send-email-a.perevalov@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Filter feature is working through NFACCT_FILTER netlink attribute.
If kernel doesn't support it, client will not get an error
and silently will work as before.

Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
---
 include/linux/netfilter/nfnetlink_acct.h |    8 ++++
 src/nfacct.c                             |   62 ++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
index 44dcd17..7542c70 100644
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
+	NFACCT_FILTER_ATTR_UNSPEC,
+	NFACCT_FILTER_ATTR_MASK,
+	NFACCT_FILTER_ATTR_VALUE,
+	__NFACCT_FILTER_ATTR_MAX
+};
+
 #ifdef __KERNEL__
 
 struct nf_acct;
diff --git a/src/nfacct.c b/src/nfacct.c
index 091a5c9..860436d 100644
--- a/src/nfacct.c
+++ b/src/nfacct.c
@@ -166,6 +166,49 @@ err:
 	return MNL_CB_OK;
 }
 
+enum filter_selection {
+	NFACCT_FILTER_UNSPEC,
+	NFACCT_FILTER_COUNTERS,
+	NFACCT_FILTER_QUOTA_BYTES,
+	NFACCT_FILTER_QUOTA_PACKETS,
+	NFACCT_FILTER_OVERQUOTA,
+};
+
+#define NFACCT_F_QUOTAS (NFACCT_F_QUOTA_BYTES | NFACCT_F_QUOTA_PKTS)
+
+static void nlmsg_build_filter_payload(enum filter_selection *selection,
+					 struct nlmsghdr *nlh)
+{
+	struct nlattr *nest;
+	uint32_t mask = 0, value = 0;
+
+	if (!selection || *selection == NFACCT_FILTER_UNSPEC)
+		return;
+
+	nest = mnl_attr_nest_start(nlh, NFACCT_FILTER);
+	if (nest == NULL)
+		return;
+
+	if (*selection == NFACCT_FILTER_QUOTA_BYTES) {
+		mask = NFACCT_F_QUOTA_BYTES;
+		value = NFACCT_F_QUOTA_BYTES;
+	} else if (*selection == NFACCT_FILTER_QUOTA_PACKETS) {
+		mask = NFACCT_F_QUOTA_PKTS;
+		value = NFACCT_F_QUOTA_PKTS;
+	} else if (*selection == NFACCT_FILTER_COUNTERS) {
+		mask = NFACCT_F_QUOTAS;
+		value = 0; /* counters isn't quotas */
+	} else if (*selection == NFACCT_FILTER_OVERQUOTA) {
+		mask = NFACCT_F_OVERQUOTA;
+		value = NFACCT_F_OVERQUOTA;
+	}
+
+	mnl_attr_put_u32(nlh, NFACCT_FILTER_ATTR_MASK, mask);
+	mnl_attr_put_u32(nlh, NFACCT_FILTER_ATTR_VALUE, value);
+
+	mnl_attr_nest_end(nlh, nest);
+}
+
 static int nfacct_cmd_list(int argc, char *argv[])
 {
 	bool zeroctr = false, xml = false;
@@ -174,12 +217,30 @@ static int nfacct_cmd_list(int argc, char *argv[])
 	struct nlmsghdr *nlh;
 	unsigned int seq, portid;
 	int ret, i;
+	enum filter_selection selection = NFACCT_FILTER_UNSPEC;
+	struct nfacct *nfacct = nfacct_alloc();
+
+	if (nfacct == NULL) {
+		nfacct_perror("OOM");
+		return -1;
+	}
 
 	for (i=2; i<argc; i++) {
 		if (strncmp(argv[i], "reset", strlen(argv[i])) == 0) {
 			zeroctr = true;
 		} else if (strncmp(argv[i], "xml", strlen(argv[i])) == 0) {
 			xml = true;
+		} else if (strncmp(argv[i], "counters", strlen(argv[i])) == 0) {
+			selection = NFACCT_FILTER_COUNTERS;
+		} else if (strncmp(argv[i], "byte_quotas", strlen(argv[i]))
+			   == 0) {
+			selection = NFACCT_FILTER_QUOTA_BYTES;
+		} else if (strncmp(argv[i], "packet_quotas", strlen(argv[i]))
+			   == 0) {
+			selection = NFACCT_FILTER_QUOTA_PACKETS;
+		} else if (strncmp(argv[i], "overquota", strlen(argv[i]))
+			   == 0) {
+			selection = NFACCT_FILTER_OVERQUOTA;
 		} else {
 			nfacct_perror("unknown argument");
 			return -1;
@@ -192,6 +253,7 @@ static int nfacct_cmd_list(int argc, char *argv[])
 					NFNL_MSG_ACCT_GET,
 				     NLM_F_DUMP, seq);
 
+	nlmsg_build_filter_payload(&selection, nlh);
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
 		nfacct_perror("mnl_socket_open");
-- 
1.7.9.5

