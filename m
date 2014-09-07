From: Alexey Perevalov <alexey.perevalov@hotmail.com>
Subject: [PATCH V2] nfacct: add filter in to the list operation
Date: Sun, 7 Sep 2014 10:33:00 +0400
Message-ID: <BLU436-SMTP19377748888AA7E421BE168DC00@phx.gbl>
References: <1410071580-24491-1-git-send-email-a.perevalov@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Alexey Perevalov <a.perevalov@samsung.com>,
	kyungmin.park@samsung.com, hs81.go@samsung.com,
	netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from blu004-omc1s12.hotmail.com ([65.55.116.23]:51422 "EHLO
	BLU004-OMC1S12.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751903AbaIGGdn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Sep 2014 02:33:43 -0400
In-Reply-To: <1410071580-24491-1-git-send-email-a.perevalov@samsung.com>
In-Reply-To: <20140826194501.GA4789@salvia>
References: <20140826194501.GA4789@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Filter feature is working through NFACCT_FILTER netlink attribute.
If kernel doesn't support it, client will not get an error
and silently will work as before.

This patch adds following command line arguments: counters, overquota,
quota-byte, quota-packet. Which could be used with list operation.
Combination of these command line options isn't allowed. If user specified
several filter options in current implementation, latest of the mentioned above
option will be chosen.

For example.
#nfacct list counters
will show counters without byte/packet based quota
#nfacct list reset overquota
will reset value for overquoted counters only

Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
---
 include/linux/netfilter/nfnetlink_acct.h |    8 ++++
 src/nfacct.c                             |   63 ++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+)

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
index 091a5c9..344a88b 100644
--- a/src/nfacct.c
+++ b/src/nfacct.c
@@ -19,6 +19,7 @@
 #include <unistd.h>
 #include <time.h>
 #include <errno.h>
+#include <arpa/inet.h>
 
 #include <libmnl/libmnl.h>
 #include <libnetfilter_acct/libnetfilter_acct.h>
@@ -166,6 +167,49 @@ err:
 	return MNL_CB_OK;
 }
 
+enum filter_selection {
+	NFACCT_SELECTION_UNSPEC,
+	NFACCT_SELECTION_COUNTERS,
+	NFACCT_SELECTION_QUOTA_BYTES,
+	NFACCT_SELECTION_QUOTA_PACKETS,
+	NFACCT_SELECTION_OVERQUOTA,
+};
+
+#define NFACCT_F_QUOTAS (NFACCT_F_QUOTA_BYTES | NFACCT_F_QUOTA_PKTS)
+
+static void nlmsg_build_filter_payload(enum filter_selection selection,
+					 struct nlmsghdr *nlh)
+{
+	struct nlattr *nest;
+	uint32_t mask = 0, value = 0;
+
+	if (selection == NFACCT_SELECTION_UNSPEC)
+		return;
+
+	nest = mnl_attr_nest_start(nlh, NFACCT_FILTER);
+	if (nest == NULL)
+		return;
+
+	if (selection == NFACCT_SELECTION_QUOTA_BYTES) {
+		mask = NFACCT_F_QUOTA_BYTES;
+		value = NFACCT_F_QUOTA_BYTES;
+	} else if (selection == NFACCT_SELECTION_QUOTA_PACKETS) {
+		mask = NFACCT_F_QUOTA_PKTS;
+		value = NFACCT_F_QUOTA_PKTS;
+	} else if (selection == NFACCT_SELECTION_COUNTERS) {
+		mask = NFACCT_F_QUOTAS;
+		value = 0; /* counters isn't quotas */
+	} else if (selection == NFACCT_SELECTION_OVERQUOTA) {
+		mask = NFACCT_F_OVERQUOTA;
+		value = NFACCT_F_OVERQUOTA;
+	}
+
+	mnl_attr_put_u32(nlh, NFACCT_FILTER_MASK, htonl(mask));
+	mnl_attr_put_u32(nlh, NFACCT_FILTER_VALUE, htonl(value));
+
+	mnl_attr_nest_end(nlh, nest);
+}
+
 static int nfacct_cmd_list(int argc, char *argv[])
 {
 	bool zeroctr = false, xml = false;
@@ -174,12 +218,30 @@ static int nfacct_cmd_list(int argc, char *argv[])
 	struct nlmsghdr *nlh;
 	unsigned int seq, portid;
 	int ret, i;
+	enum filter_selection selection = NFACCT_SELECTION_UNSPEC;
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
+			selection = NFACCT_SELECTION_COUNTERS;
+		} else if (strncmp(argv[i], "quota-byte", strlen(argv[i]))
+			   == 0) {
+			selection = NFACCT_SELECTION_QUOTA_BYTES;
+		} else if (strncmp(argv[i], "quota-packet", strlen(argv[i]))
+			   == 0) {
+			selection = NFACCT_SELECTION_QUOTA_PACKETS;
+		} else if (strncmp(argv[i], "overquota", strlen(argv[i]))
+			   == 0) {
+			selection = NFACCT_SELECTION_OVERQUOTA;
 		} else {
 			nfacct_perror("unknown argument");
 			return -1;
@@ -192,6 +254,7 @@ static int nfacct_cmd_list(int argc, char *argv[])
 					NFNL_MSG_ACCT_GET,
 				     NLM_F_DUMP, seq);
 
+	nlmsg_build_filter_payload(selection, nlh);
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
 		nfacct_perror("mnl_socket_open");
-- 
1.7.9.5

