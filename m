From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [ulogd PATCH 12/13] nfct: introduce new out keys for ipfix timestamp
Date: Mon, 28 Apr 2014 20:56:21 +0900
Message-ID: <20140428115621.GM12523@gmail.com>
References: <20140308010344.GA4415@gmail.com>
 <20140428113936.GA12523@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:53653 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbaD1L42 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2014 07:56:28 -0400
Received: by mail-pa0-f42.google.com with SMTP id bj1so2457787pad.1
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Apr 2014 04:56:27 -0700 (PDT)
Received: from gmail.com (softbank220009032006.bbtec.net. [220.9.32.6])
        by mx.google.com with ESMTPSA id qx11sm90425464pab.35.2014.04.28.04.56.25
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Mon, 28 Apr 2014 04:56:26 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140428113936.GA12523@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 input/flow/ulogd_inpflow_NFCT.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index 4f4301e..b31c46f 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -186,8 +186,10 @@ enum nfct_keys {
 	NFCT_CT_EVENT,
 	NFCT_FLOW_START_SEC,
 	NFCT_FLOW_START_USEC,
+	NFCT_FLOW_START_MCSEC,
 	NFCT_FLOW_END_SEC,
 	NFCT_FLOW_END_USEC,
+	NFCT_FLOW_END_MCSEC,
 	NFCT_OOB_FAMILY,
 	NFCT_OOB_PROTOCOL,
 	NFCT_CT,
@@ -379,6 +381,11 @@ static struct ulogd_key nfct_okeys[] = {
 		.type 	= ULOGD_RET_UINT32,
 		.flags 	= ULOGD_RETF_NONE,
 		.name	= "flow.start.usec",
+	},
+	{
+		.type 	= ULOGD_RET_UINT64,
+		.flags 	= ULOGD_RETF_NONE,
+		.name	= "flow.start.mcsec",
 		.ipfix	= {
 			.vendor		= IPFIX_VENDOR_IETF,
 			.field_id	= IPFIX_flowStartMicroSeconds,
@@ -397,6 +404,11 @@ static struct ulogd_key nfct_okeys[] = {
 		.type	= ULOGD_RET_UINT32,
 		.flags	= ULOGD_RETF_NONE,
 		.name	= "flow.end.usec",
+	},
+	{
+		.type	= ULOGD_RET_UINT64,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "flow.end.mcsec",
 		.ipfix	= {
 			.vendor		= IPFIX_VENDOR_IETF,
 			.field_id	= IPFIX_flowEndMicroSeconds,
@@ -485,6 +497,13 @@ static int compare(const void *data1, const void *data2)
 	return nfct_cmp(u1->ct, ct, NFCT_CMP_ORIG | NFCT_CMP_REPL);
 }
 
+static inline uint64_t tv2ntp(const struct timeval t)
+{
+	/* RFC7101 - 6.1.10. dateTimeNanoseconds */
+	return (uint64_t) (t.tv_sec << 32)
+		+ (t.tv_usec << 32) / (NSEC_PER_SEC / 1000);
+}
+
 /* only the main_upi plugin instance contains the correct private data. */
 static int propagate_ct(struct ulogd_pluginstance *main_upi,
 			struct ulogd_pluginstance *upi,
@@ -579,12 +598,16 @@ static int propagate_ct(struct ulogd_pluginstance *main_upi,
 				     ts->time[START].tv_sec);
 			okey_set_u32(&ret[NFCT_FLOW_START_USEC],
 				     ts->time[START].tv_usec);
+			okey_set_u64(&ret[NFCT_FLOW_START_MCSEC],
+				     tv2ntp(ts->time[START]));
 		}
 		if (ts->time[STOP].tv_sec) {
 			okey_set_u32(&ret[NFCT_FLOW_END_SEC],
 				     ts->time[STOP].tv_sec);
 			okey_set_u32(&ret[NFCT_FLOW_END_USEC],
 				     ts->time[STOP].tv_usec);
+			okey_set_u64(&ret[NFCT_FLOW_END_MCSEC],
+				     tv2ntp(ts->time[STOP]));
 		}
 	}
 	okey_set_ptr(&ret[NFCT_CT], cpi->ct);
-- 
1.9.1

