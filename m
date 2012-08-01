From: Eric Leblond <eric@regit.org>
Subject: [PATCH 1/5] nfacct: add variable to not zero counter after read
Date: Wed,  1 Aug 2012 23:27:12 +0200
Message-ID: <1343856436-11129-2-git-send-email-eric@regit.org>
References: <1343856436-11129-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:49515 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421Ab2HAV2c (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Aug 2012 17:28:32 -0400
In-Reply-To: <1343856436-11129-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The default nfacct input plugin zeroes counter after each read. This
is a limitation as other software can't use the counter at the same
time as ulogd2.
This patch adds the zerocounter variable to the NFACCT input plugin.
If set to zero, the counters are not zeroed.
---
 input/sum/ulogd_inpflow_NFACCT.c |   29 +++++++++++++++++++++--------
 ulogd.conf.in                    |    2 ++
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/input/sum/ulogd_inpflow_NFACCT.c b/input/sum/ulogd_inpflow_NFACCT.c
index f3b936f..a3bcc72 100644
--- a/input/sum/ulogd_inpflow_NFACCT.c
+++ b/input/sum/ulogd_inpflow_NFACCT.c
@@ -40,10 +40,17 @@ static struct config_keyset nfacct_kset = {
 			.options = CONFIG_OPT_NONE,
 			.u.value = 0,
 		},
+		{
+			.key	 = "zerocounter",
+			.type	 = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u.value = 1,
+		}
 	},
-	.num_ces = 1,
+	.num_ces = 2,
 };
 #define pollint_ce(x)	(x->ces[0])
+#define zerocounter_ce(x) (x->ces[1])
 
 enum ulogd_nfacct_keys {
 	ULOGD_NFACCT_NAME,
@@ -145,13 +152,22 @@ static int nfacct_read_cb(int fd, unsigned int what, void *param)
 	return ret;
 }
 
-static int nfacct_send_request(struct nfacct_pluginstance *cpi)
+static int nfacct_send_request(struct ulogd_pluginstance *upi)
 {
+
+	struct nfacct_pluginstance *cpi =
+		(struct nfacct_pluginstance *)upi->private;
 	struct nlmsghdr *nlh;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
+	int flushctr;
 
+	if (zerocounter_ce(upi->config_kset).u.value != 0) {
+		flushctr = NFNL_MSG_ACCT_GET_CTRZERO;
+	} else {
+		flushctr = NFNL_MSG_ACCT_GET;
+	}
 	cpi->seq = time(NULL);
-	nlh = nfacct_nlmsg_build_hdr(buf, NFNL_MSG_ACCT_GET_CTRZERO,
+	nlh = nfacct_nlmsg_build_hdr(buf, flushctr,
 				     NLM_F_DUMP, cpi->seq);
 
 	if (mnl_socket_sendto(cpi->nl, nlh, nlh->nlmsg_len) < 0) {
@@ -167,7 +183,7 @@ static void polling_timer_cb(struct ulogd_timer *t, void *data)
 	struct nfacct_pluginstance *cpi =
 		(struct nfacct_pluginstance *)upi->private;
 
-	nfacct_send_request(cpi);
+	nfacct_send_request(upi);
 
 	ulogd_add_timer(&cpi->timer, pollint_ce(upi->config_kset).u.value);
 }
@@ -234,12 +250,9 @@ static int destructor_nfacct(struct ulogd_pluginstance *upi)
 
 static void signal_nfacct(struct ulogd_pluginstance *upi, int signal)
 {
-	struct nfacct_pluginstance *cpi =
-		(struct nfacct_pluginstance *)upi->private;
-
 	switch (signal) {
 	case SIGUSR2:
-		nfacct_send_request(cpi);
+		nfacct_send_request(upi);
 		break;
 	}
 }
diff --git a/ulogd.conf.in b/ulogd.conf.in
index 5f19cae..879ab3c 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -263,3 +263,5 @@ mark = 1
 
 [acct1]
 pollinterval = 2
+# Set to zero to avoid zeroing counters after read
+#zerocounter = 0
-- 
1.7.10.4

