From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH v3 ulogd 11/12] nfct/ipfix: introduce new vendor id
Date: Tue, 3 Jun 2014 19:16:39 +0900
Message-ID: <20140603101639.GL24668@gmail.com>
References: <20140603100130.GA24668@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:42021 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbaFCKQp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:16:45 -0400
Received: by mail-pd0-f176.google.com with SMTP id p10so4514165pdj.21
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Jun 2014 03:16:45 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140603100130.GA24668@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

IPFIX_VENDOR_REVERSE, defined in RFC 5103 6.1 Reverse Information Element
Private Enterprise Number. And use it at counter in nfct.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
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
index 81f5bc3..5912011 100644
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

