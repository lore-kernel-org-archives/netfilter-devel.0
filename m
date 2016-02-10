From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH ulogd 2/7] nfct/ipfix: introduce new vendor id
Date: Wed, 10 Feb 2016 10:58:14 +0900
Message-ID: <20160210015814.GC17470@gmail.com>
References: <20160206104249.GA19349@gmail.com>
 <a53f427c-6b04-4d3b-898e-ba63fc949f5a@email.android.com>
 <20160210015358.GA17470@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35880 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097AbcBJB6T (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Feb 2016 20:58:19 -0500
Received: by mail-pf0-f196.google.com with SMTP id e127so253941pfe.3
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Feb 2016 17:58:18 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20160210015358.GA17470@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

IPFIX_VENDOR_REVERSE, defined in RFC 5103 6.1 Reverse Information
Element Private Enterprise Number. And use it at counter in nfct.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 include/ulogd/ipfix_protocol.h  | 3 +++
 input/flow/ulogd_inpflow_NFCT.c | 4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/ulogd/ipfix_protocol.h b/include/ulogd/ipfix_protocol.h
index bff0b5c..330f0ea 100644
--- a/include/ulogd/ipfix_protocol.h
+++ b/include/ulogd/ipfix_protocol.h
@@ -11,6 +11,9 @@
 /* defined in http://www.iana.org/assignments/enterprise-numbers */
 #define IPFIX_VENDOR_NETFILTER	21373	/* FIXME: htonl? */
 
+/* defined in RFC 5103 IPFIX Biflow Export */
+#define IPFIX_VENDOR_REVERSE	29305
+
 /* Section 3.1 */
 struct ipfix_msg_hdr {
 	uint16_t	version;
diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index 899b7e3..0b3b339 100644
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
2.1.4

