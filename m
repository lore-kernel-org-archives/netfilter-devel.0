From: Eric Leblond <eric@regit.org>
Subject: [PATCH 5/5] nfacct: add timestamp option
Date: Wed,  1 Aug 2012 23:27:16 +0200
Message-ID: <1343856436-11129-6-git-send-email-eric@regit.org>
References: <1343856436-11129-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:49520 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605Ab2HAV2g (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Aug 2012 17:28:36 -0400
In-Reply-To: <1343856436-11129-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a timestamp option to the nfacct plugin.
If activated, nfacct output a timestamp which is computed just
after sending the nfacct request.
---
 input/sum/ulogd_inpflow_NFACCT.c |   35 ++++++++++++++++++++++++++++++++++-
 ulogd.conf.in                    |    2 ++
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/input/sum/ulogd_inpflow_NFACCT.c b/input/sum/ulogd_inpflow_NFACCT.c
index a3bcc72..66e9f78 100644
--- a/input/sum/ulogd_inpflow_NFACCT.c
+++ b/input/sum/ulogd_inpflow_NFACCT.c
@@ -30,6 +30,7 @@ struct nfacct_pluginstance {
 	uint32_t		seq;
 	struct ulogd_fd		ufd;
 	struct ulogd_timer	timer;
+	struct timeval tv;
 };
 
 static struct config_keyset nfacct_kset = {
@@ -45,18 +46,27 @@ static struct config_keyset nfacct_kset = {
 			.type	 = CONFIG_TYPE_INT,
 			.options = CONFIG_OPT_NONE,
 			.u.value = 1,
+		},
+		{
+			.key	 = "timestamp",
+			.type	 = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u.value = 0,
 		}
 	},
-	.num_ces = 2,
+	.num_ces = 3,
 };
 #define pollint_ce(x)	(x->ces[0])
 #define zerocounter_ce(x) (x->ces[1])
+#define timestamp_ce(x) (x->ces[2])
 
 enum ulogd_nfacct_keys {
 	ULOGD_NFACCT_NAME,
 	ULOGD_NFACCT_PKTS,
 	ULOGD_NFACCT_BYTES,
 	ULOGD_NFACCT_RAW,
+	ULOGD_NFACCT_TIME_SEC,
+	ULOGD_NFACCT_TIME_USEC,
 };
 
 static struct ulogd_key nfacct_okeys[] = {
@@ -80,12 +90,27 @@ static struct ulogd_key nfacct_okeys[] = {
 		.flags	= ULOGD_RETF_NONE,
 		.name	= "sum",
 	},
+	[ULOGD_NFACCT_TIME_SEC] = {
+		.type = ULOGD_RET_UINT32,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.time.sec",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = 22
+		},
+	},
+	[ULOGD_NFACCT_TIME_USEC] = {
+		.type = ULOGD_RET_UINT32,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.time.usec",
+	},
 };
 
 static void
 propagate_nfacct(struct ulogd_pluginstance *upi, struct nfacct *nfacct)
 {
 	struct ulogd_key *ret = upi->output.keys;
+	struct nfacct_pluginstance *cpi = (struct nfacct_pluginstance *) upi->private;
 
 	okey_set_ptr(&ret[ULOGD_NFACCT_NAME],
 			(void *)nfacct_attr_get_str(nfacct, NFACCT_ATTR_NAME));
@@ -94,6 +119,10 @@ propagate_nfacct(struct ulogd_pluginstance *upi, struct nfacct *nfacct)
 	okey_set_u64(&ret[ULOGD_NFACCT_BYTES],
 			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES));
 	okey_set_ptr(&ret[ULOGD_NFACCT_RAW], nfacct);
+	if (timestamp_ce(upi->config_kset).u.value != 0) {
+		okey_set_u32(&ret[ULOGD_NFACCT_TIME_SEC], cpi->tv.tv_sec);
+		okey_set_u32(&ret[ULOGD_NFACCT_TIME_USEC], cpi->tv.tv_usec);
+	}
 
 	ulogd_propagate_results(upi);
 }
@@ -174,6 +203,10 @@ static int nfacct_send_request(struct ulogd_pluginstance *upi)
 		ulogd_log(ULOGD_ERROR, "Cannot send netlink message\n");
 		return -1;
 	}
+	if (timestamp_ce(upi->config_kset).u.value != 0) {
+		/* Compute time of query */
+		gettimeofday(&cpi->tv, NULL);
+	}
 	return 0;
 }
 
diff --git a/ulogd.conf.in b/ulogd.conf.in
index 0e45714..e99212f 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -273,3 +273,5 @@ mark = 1
 pollinterval = 2
 # Set to zero to avoid zeroing counters after read
 #zerocounter = 0
+# Output timestamp if set to 1 (default 0)
+#timestamp = 1
-- 
1.7.10.4

