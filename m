From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH ulogd 3/7] nfct/ipfix: introduce NAT entries
Date: Wed, 10 Feb 2016 11:00:57 +0900
Message-ID: <20160210020057.GD17470@gmail.com>
References: <20160206104249.GA19349@gmail.com>
 <a53f427c-6b04-4d3b-898e-ba63fc949f5a@email.android.com>
 <20160210015358.GA17470@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:35654 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203AbcBJCBB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Feb 2016 21:01:01 -0500
Received: by mail-pa0-f68.google.com with SMTP id fl4so240587pad.2
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Feb 2016 18:01:01 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20160210015358.GA17470@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 include/ulogd/ipfix_protocol.h  | 10 ++++++++++
 input/flow/ulogd_inpflow_NFCT.c | 17 ++++++++---------
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/include/ulogd/ipfix_protocol.h b/include/ulogd/ipfix_protocol.h
index 330f0ea..23fa440 100644
--- a/include/ulogd/ipfix_protocol.h
+++ b/include/ulogd/ipfix_protocol.h
@@ -219,6 +219,16 @@ enum {
 	/* reserved */
 	IPFIX_headerLengthIPv4		= 213,
 	IPFIX_mplsPayloadLength		= 214,
+
+	/* select usefuls from:
+	 * http://www.iana.org/assignments/ipfix/ipfix.txt */
+	IPFIX_postNATSourceIPv4Address		= 225,
+	IPFIX_postNATDestinationIPv4Address	= 226,
+	IPFIX_postNAPTSourceTransportPort	= 227,
+	IPFIX_postNAPTDestinationTransportPort	= 228,
+	IPFIX_firewallEvent			= 233,
+	IPFIX_postNATSourceIPv6Address		= 281,
+	IPFIX_postNATDestinationIPv6Address	= 282,
 };
 
 /* Information elements of the netfilter vendor id */
diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index 0b3b339..8f9492a 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -265,7 +265,7 @@ static struct ulogd_key nfct_okeys[] = {
 		.name	= "reply.ip.saddr",
 		.ipfix	= {
 			.vendor = IPFIX_VENDOR_IETF,
-			.field_id = IPFIX_sourceIPv4Address,
+			.field_id = IPFIX_postNATSourceIPv4Address,
 		},
 	},
 	{
@@ -274,7 +274,7 @@ static struct ulogd_key nfct_okeys[] = {
 		.name	= "reply.ip.daddr",
 		.ipfix	= {
 			.vendor = IPFIX_VENDOR_IETF,
-			.field_id = IPFIX_destinationIPv4Address,
+			.field_id = IPFIX_postNATDestinationIPv4Address,
 		},
 	},
 	{
@@ -292,7 +292,7 @@ static struct ulogd_key nfct_okeys[] = {
 		.name	= "reply.l4.sport",
 		.ipfix	= {
 			.vendor 	= IPFIX_VENDOR_IETF,
-			.field_id 	= IPFIX_sourceTransportPort,
+			.field_id 	= IPFIX_postNAPTSourceTransportPort,
 		},
 	},
 	{
@@ -301,7 +301,7 @@ static struct ulogd_key nfct_okeys[] = {
 		.name	= "reply.l4.dport",
 		.ipfix	= {
 			.vendor 	= IPFIX_VENDOR_IETF,
-			.field_id 	= IPFIX_destinationTransportPort,
+			.field_id 	= IPFIX_postNAPTDestinationTransportPort,
 		},
 	},
 	{
-- 
2.1.4
