From: Patrick McHardy <kaber@trash.net>
Subject: [RFC PATCH nft] proto: add missing fields for ARP with IPv4/Ethernet
Date: Thu, 26 Nov 2015 12:43:16 +0000
Message-ID: <1448541796-23535-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:35360 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751014AbbKZMnV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 07:43:21 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/headers.h  | 14 ++++++++++++++
 include/proto.h    |  4 ++++
 src/parser_bison.y |  8 ++++++++
 src/proto.c        |  8 ++++++++
 src/scanner.l      |  4 ++++
 5 files changed, 38 insertions(+)

I've added the missing fields for ARP using IPv4 and ethernet. The question
is if we really want to do this. Sure, Linux only supports this, but at least
on ingress with different media types we might at least theoretically see
other ARP types I guess.

The alternative would be to describe ARP as a layered protocol, the fixed
part and the protocol specific part depending on ar_hrd. I think we're
currently missing some infrastructure to express this properly.

I *think* we should be able to change this in the future in a compatible way
if necessary  since the tokens for IPv4 actually contain "ip" and the sha/tha
can be parsed during evaluation.

If we agree to do it like this for now, what about naming? I don't like the
token names very much, but I also want to avoid excessively long tokens.
If someone has a nice reasonable suggestion please let me know.

Cheers,
Patrick

diff --git a/include/headers.h b/include/headers.h
index 469d674..15e3002 100644
--- a/include/headers.h
+++ b/include/headers.h
@@ -5,6 +5,20 @@
 # define IPPROTO_UDPLITE	136
 #endif
 
+#include <linux/if_ether.h>
+
+struct arp_ip_hdr {
+	uint16_t	ar_hrd;
+	uint16_t	ar_pro;
+	uint8_t		ar_hln;
+	uint8_t		ar_pln;
+	uint16_t	ar_op;
+	uint8_t		ar_sha[ETH_ALEN];
+	uint8_t		ar_sip[4];
+	uint8_t		ar_tha[ETH_ALEN];
+	uint8_t		ar_tip[4];
+};
+
 enum tcp_hdr_flags {
 	TCP_FLAG_FIN	= 0x01,
 	TCP_FLAG_SYN	= 0x02,
diff --git a/include/proto.h b/include/proto.h
index 974116f..b6a84d3 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -172,6 +172,10 @@ enum arp_hdr_fields {
 	ARPHDR_HLN,
 	ARPHDR_PLN,
 	ARPHDR_OP,
+	ARPHDR_SHA,
+	ARPHDR_SIP,
+	ARPHDR_THA,
+	ARPHDR_TIP,
 };
 
 enum ip_hdr_fields {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index fbfe7ea..e87b4a2 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -242,6 +242,10 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token HLEN			"hlen"
 %token PLEN			"plen"
 %token OPERATION		"operation"
+%token SHA			"sha"
+%token SIP			"sip"
+%token THA			"tha"
+%token TIP			"tip"
 
 %token IP			"ip"
 %token HDRVERSION		"version"
@@ -2155,6 +2159,10 @@ arp_hdr_field		:	HTYPE		{ $$ = ARPHDR_HRD; }
 			|	HLEN		{ $$ = ARPHDR_HLN; }
 			|	PLEN		{ $$ = ARPHDR_PLN; }
 			|	OPERATION	{ $$ = ARPHDR_OP; }
+			|	SHA		{ $$ = ARPHDR_SHA; }
+			|	SIP		{ $$ = ARPHDR_SIP; }
+			|	THA		{ $$ = ARPHDR_THA; }
+			|	TIP		{ $$ = ARPHDR_TIP; }
 			;
 
 ip_hdr_expr		:	IP	ip_hdr_field
diff --git a/src/proto.c b/src/proto.c
index 0fe0b88..202c323 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -693,6 +693,10 @@ static const struct datatype arpop_type = {
 	HDR_TYPE(__name, __type, struct arphdr, __member)
 #define ARPHDR_FIELD(__name, __member) \
 	HDR_FIELD(__name, struct arphdr, __member)
+#define ARPHDR_ETH_ADDR(__name, __member) \
+	HDR_TYPE(__name, &etheraddr_type, struct arp_ip_hdr, __member)
+#define ARPHDR_IP_ADDR(__name, __member) \
+	HDR_TYPE(__name, &ipaddr_type, struct arp_ip_hdr, __member)
 
 const struct proto_desc proto_arp = {
 	.name		= "arp",
@@ -703,6 +707,10 @@ const struct proto_desc proto_arp = {
 		[ARPHDR_HLN]		= ARPHDR_FIELD("hlen", ar_hln),
 		[ARPHDR_PLN]		= ARPHDR_FIELD("plen", ar_pln),
 		[ARPHDR_OP]		= ARPHDR_TYPE("operation", &arpop_type, ar_op),
+		[ARPHDR_SHA]		= ARPHDR_ETH_ADDR("sha", ar_sha),
+		[ARPHDR_SIP]		= ARPHDR_IP_ADDR("sip", ar_sip),
+		[ARPHDR_THA]		= ARPHDR_ETH_ADDR("tha", ar_tha),
+		[ARPHDR_TIP]		= ARPHDR_IP_ADDR("tip", ar_tip),
 	},
 };
 
diff --git a/src/scanner.l b/src/scanner.l
index a98e7b6..b0f93cb 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -357,6 +357,10 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "hlen"			{ return HLEN; }
 "plen"			{ return PLEN; }
 "operation"		{ return OPERATION; }
+"sha"			{ return SHA; }
+"sip"			{ return SIP; }
+"tha"			{ return THA; }
+"tip"			{ return TIP; }
 
 "ip"			{ return IP; }
 "version"		{ return HDRVERSION; }
-- 
2.5.0

