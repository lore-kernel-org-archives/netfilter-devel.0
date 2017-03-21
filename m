From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] src: allow update of net base w. meta l4proto icmpv6
Date: Tue, 21 Mar 2017 19:54:37 +0100
Message-ID: <20170321185437.22959-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:47936 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933131AbdCUSyU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 14:54:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft add rule ip6 f i meta l4proto ipv6-icmp icmpv6 type nd-router-advert
<cmdline>:1:50-60: Error: conflicting protocols specified: unknown vs. icmpv6

add icmpv6 to nexthdr list so base gets updated correctly.

Reported-by: Thomas Woerner <twoerner@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 NB: This is STILL not correct.
 nft add rule ip6 f i meta l4proto ipv6-icmp icmpv6 type nd-router-advert
 gets listed as
  icmpv6 type nd-router-advert

because post processing removes the l3 dependency.

However, "icmpv6 type nd-router-advert" uses dependency
ip6 nexthdr icmpv6
which isn't the same as meta l4proto icmpv6.

I suspect nft should always generate implicit l4 dependencies
via meta in the ipv6 case, what do others think
(and not autoremove 'nexthdr' check)?

diff --git a/src/proto.c b/src/proto.c
index 79e9dbf2b33e..fcdfbe73c735 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -779,6 +779,7 @@ const struct proto_desc proto_inet_service = {
 		PROTO_LINK(IPPROTO_TCP,		&proto_tcp),
 		PROTO_LINK(IPPROTO_DCCP,	&proto_dccp),
 		PROTO_LINK(IPPROTO_SCTP,	&proto_sctp),
+		PROTO_LINK(IPPROTO_ICMPV6,	&proto_icmp6),
 	},
 	.templates	= {
 		[0]	= PROTO_META_TEMPLATE("l4proto", &inet_protocol_type, NFT_META_L4PROTO, 8),
-- 
2.10.2

