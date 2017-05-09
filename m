From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 02/10] src: ipv6: switch implicit dependencies to meta l4proto
Date: Tue,  9 May 2017 17:51:14 +0200
Message-ID: <20170509155122.26356-3-fw@strlen.de>
References: <20170509155122.26356-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:44548 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755769AbdEIPvV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 May 2017 11:51:21 -0400
In-Reply-To: <20170509155122.26356-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

when using rule like

ip6 filter input tcp dport 22
nft generates:
  [ payload load 1b @ network header + 6 => reg 1 ]
  [ cmp eq reg 1 0x00000006 ]
  [ payload load 2b @ transport header + 2 => reg 1 ]
  [ cmp eq reg 1 0x00001600 ]

which is: ip6 filter input ip6 nexthdr tcp dport 22
IOW, such a rule won't match if e.g. a fragment header is in place.

This changes ip6_proto to use 'meta l4proto' which is the protocol header
found by exthdr walk.

A side effect is that for bridge we get a shorter dependency chain as it
no longer needs to prepend 'ether proto ipv6' for old 'ip6 nexthdr' dep.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/proto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/proto.c b/src/proto.c
index fcdfbe73c735..3b20a5fd35b1 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -707,7 +707,6 @@ const struct proto_desc proto_icmp6 = {
 const struct proto_desc proto_ip6 = {
 	.name		= "ip6",
 	.base		= PROTO_BASE_NETWORK_HDR,
-	.protocol_key	= IP6HDR_NEXTHDR,
 	.protocols	= {
 		PROTO_LINK(IPPROTO_ESP,		&proto_esp),
 		PROTO_LINK(IPPROTO_AH,		&proto_ah),
@@ -720,6 +719,7 @@ const struct proto_desc proto_ip6 = {
 		PROTO_LINK(IPPROTO_ICMPV6,	&proto_icmp6),
 	},
 	.templates	= {
+		[0]	= PROTO_META_TEMPLATE("l4proto", &inet_protocol_type, NFT_META_L4PROTO, 8),
 		[IP6HDR_VERSION]	= HDR_BITFIELD("version", &integer_type, 0, 4),
 		[IP6HDR_DSCP]		= HDR_BITFIELD("dscp", &dscp_type, 4, 6),
 		[IP6HDR_ECN]		= HDR_BITFIELD("ecn", &ecn_type, 10, 2),
-- 
2.10.2

