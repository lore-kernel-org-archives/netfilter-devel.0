From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 01/10] src: allow update of net base w. meta l4proto icmpv6
Date: Tue,  9 May 2017 17:51:13 +0200
Message-ID: <20170509155122.26356-2-fw@strlen.de>
References: <20170509155122.26356-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:44546 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754485AbdEIPvI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 May 2017 11:51:08 -0400
In-Reply-To: <20170509155122.26356-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft add rule ip6 f i meta l4proto ipv6-icmp icmpv6 type nd-router-advert
<cmdline>:1:50-60: Error: conflicting protocols specified: unknown vs. icmpv6

add icmpv6 to nexthdr list so base gets updated correctly.

Reported-by: Thomas Woerner <twoerner@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/proto.c | 1 +
 1 file changed, 1 insertion(+)

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

