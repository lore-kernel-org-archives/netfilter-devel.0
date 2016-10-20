From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/1] netlink: fix monitor trace crash with netdev family
Date: Fri, 21 Oct 2016 01:13:38 +0200
Message-ID: <1477005218-25510-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:35396 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757846AbcJTXNV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Oct 2016 19:13:21 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft monitor trace crashes on first packet with:

table netdev filter {
  chain foobar {
    type filter hook ingress device eth0 priority 0;
    udp sport 53 meta nftrace set 1
  }
}

We did not handle netdev family and thus generated bogus payload
statements without data types.

Netfilter Bugzilla: http://bugzilla.netfilter.org/show_bug.cgi?id=1092
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index f8da2a6b4fbb..f8e600ff6f81 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -2340,6 +2340,7 @@ next:
 static void trace_print_packet(const struct nftnl_trace *nlt)
 {
 	struct list_head stmts = LIST_HEAD_INIT(stmts);
+	const struct proto_desc *ll_desc;
 	struct payload_dep_ctx pctx = {};
 	struct proto_ctx ctx;
 	uint16_t dev_type;
@@ -2359,12 +2360,14 @@ static void trace_print_packet(const struct nftnl_trace *nlt)
 						 NFT_META_OIF));
 
 	proto_ctx_init(&ctx, nftnl_trace_get_u32(nlt, NFTNL_TRACE_FAMILY));
-	if (ctx.protocol[PROTO_BASE_LL_HDR].desc == &proto_inet &&
+	ll_desc = ctx.protocol[PROTO_BASE_LL_HDR].desc;
+	if ((ll_desc == &proto_inet || ll_desc  == &proto_netdev) &&
 	    nftnl_trace_is_set(nlt, NFTNL_TRACE_NFPROTO)) {
 		nfproto = nftnl_trace_get_u32(nlt, NFTNL_TRACE_NFPROTO);
+
 		proto_ctx_update(&ctx, PROTO_BASE_LL_HDR, &netlink_location, NULL);
 		proto_ctx_update(&ctx, PROTO_BASE_NETWORK_HDR, &netlink_location,
-				 proto_find_upper(&proto_inet, nfproto));
+				 proto_find_upper(ll_desc, nfproto));
 	}
 	if (ctx.protocol[PROTO_BASE_LL_HDR].desc == NULL &&
 	    nftnl_trace_is_set(nlt, NFTNL_TRACE_IIFTYPE)) {
-- 
2.7.3

