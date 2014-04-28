From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [ulogd PATCH 11/13] nfct/ipfix: introduce new vendor id
Date: Mon, 28 Apr 2014 20:54:49 +0900
Message-ID: <20140428115449.GL12523@gmail.com>
References: <20140308010344.GA4415@gmail.com>
 <20140428113936.GA12523@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:53805 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbaD1Lyz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2014 07:54:55 -0400
Received: by mail-pd0-f182.google.com with SMTP id v10so1362307pde.13
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Apr 2014 04:54:55 -0700 (PDT)
Received: from gmail.com (softbank220009032006.bbtec.net. [220.9.32.6])
        by mx.google.com with ESMTPSA id op3sm34565372pbc.40.2014.04.28.04.54.52
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Mon, 28 Apr 2014 04:54:53 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140428113936.GA12523@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

IPFIX_VENDOR_REVERSE, defined in RFC 5103 6.1 Reverse Information Element
Private Enterprise Number. And use it at counter in nfct.

Signed-off-by Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 include/ulogd/ipfix_protocol.h  | 3 +++
 input/flow/ulogd_inpflow_NFCT.c | 4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/ulogd/ipfix_protocol.h b/include/ulogd/ipfix_protocol.h
index 266897e..86a0e84 100644
--- a/include/ulogd/ipfix_protocol.h
+++ b/include/ulogd/ipfix_protocol.h
@@ -9,6 +9,9 @@
 /* defined in http://www.iana.org/assignments/enterprise-numbers */
 #define IPFIX_VENDOR_NETFILTER	21373	/* FIXME: htonl? */
 
+/* defined in RFC 5103 IPFIX Biflow Export */
+#define IPFIX_VENDOR_REVERSE	29305
+
 /* Section 3.1 */
 struct ipfix_msg_hdr {
 	u_int16_t	version;
diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index 0b64a45..4f4301e 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -309,7 +309,7 @@ static struct ulogd_key nfct_okeys[] = {
 		.flags	= ULOGD_RETF_NONE,
 		.name	= "reply.raw.pktlen",
 		.ipfix	= {
-			.vendor 	= IPFIX_VENDOR_IETF,
+			.vendor 	= IPFIX_VENDOR_REVERSE,
 			.field_id 	= IPFIX_octetTotalCount,
 			/* FIXME: this could also be octetDeltaCount */
 		},
@@ -319,7 +319,7 @@ static struct ulogd_key nfct_okeys[] = {
 		.flags	= ULOGD_RETF_NONE,
 		.name	= "reply.raw.pktcount",
 		.ipfix	= {
-			.vendor 	= IPFIX_VENDOR_IETF,
+			.vendor 	= IPFIX_VENDOR_REVERSE,
 			.field_id 	= IPFIX_packetTotalCount,
 			/* FIXME: this could also be packetDeltaCount */
 		},
-- 
1.9.1

