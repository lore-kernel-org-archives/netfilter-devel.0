From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft 0/6] ruleset tracing
Date: Mon, 25 Apr 2016 01:23:57 +0100
Message-ID: <20160425002357.GA18237@macbook.localdomain>
References: <1461533440-10605-1-git-send-email-kaber@trash.net>
 <20160424222213.GA28797@breakpoint.cc>
 <20160424225718.GA14306@macbook.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="DocE+STaALJfprDB"
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52665 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbcDYAYE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Apr 2016 20:24:04 -0400
Content-Disposition: inline
In-Reply-To: <20160424225718.GA14306@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 24.04, Patrick McHardy wrote:
> On 25.04, Florian Westphal wrote:
> > Patrick McHardy <kaber@trash.net> wrote:
> > > The following patches contain the latest version of the ruleset tracing
> > > functionality.
> > > I consider this patchset complete. Testing and comments welcome.
> > 
> > Seems it doesn't work with inet table, I get segfault in expr_print
> > (EXPR_VALUE expr with expr->dtype == NULL).
> > 
> > Callchain that produces this expression is:
> > 
> > trace_gen_stmts -> payload_expr_expand -> payload_expr_alloc
> > 
> > desc argument to payload_expr_alloc is the inet one, which
> > has no template for types != 0, so tmpl->dtype that gets passed
> > to expr_alloc is NULL.
> 
> Thanks, I'll look into that.
> 
> > Works fine without inet table. Only "problem" I found is that
> > nft displays the ether addr reversed vs. what 'ip link' shows,
> > i.e. if ip link says 1:2:3:4:5:6 nft shows 6:5:4:3:2:1.
> > 
> > I'll do more tests tomorrow and will double check that its not
> > a kernel bug.
> 
> That's just a missing byte order conversion, I've fixed it locally.

This patch should fix both issues.

--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="x.diff"

diff --git a/src/netlink.c b/src/netlink.c
index 890e9b9..761c7b4 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -2234,6 +2234,8 @@ restart:
 
 		tmp = constant_expr_splice(rhs, lhs->len);
 		expr_set_type(tmp, lhs->dtype, lhs->byteorder);
+		if (tmp->byteorder == BYTEORDER_HOST_ENDIAN)
+			mpz_switch_byteorder(tmp->value, tmp->len / BITS_PER_BYTE);
 
 		/* Skip unknown and filtered expressions */
 		desc = lhs->payload.desc;
@@ -2290,6 +2292,7 @@ static void trace_print_packet(const struct nftnl_trace *nlt)
 	struct list_head stmts = LIST_HEAD_INIT(stmts);
 	struct payload_dep_ctx pctx = {};
 	struct proto_ctx ctx;
+	uint32_t nfproto;
 	uint16_t dev_type;
 	struct stmt *stmt, *next;
 
@@ -2306,6 +2309,13 @@ static void trace_print_packet(const struct nftnl_trace *nlt)
 						 NFT_META_OIF));
 
 	proto_ctx_init(&ctx, nftnl_trace_get_u32(nlt, NFTNL_TRACE_FAMILY));
+	if (ctx.protocol[PROTO_BASE_LL_HDR].desc == &proto_inet &&
+	    nftnl_trace_is_set(nlt, NFTNL_TRACE_NFPROTO)) {
+		nfproto = nftnl_trace_get_u32(nlt, NFTNL_TRACE_NFPROTO);
+		proto_ctx_update(&ctx, PROTO_BASE_LL_HDR, &netlink_location, NULL);
+		proto_ctx_update(&ctx, PROTO_BASE_NETWORK_HDR, &netlink_location,
+				 proto_find_upper(&proto_inet, nfproto));
+	}
 	if (ctx.protocol[PROTO_BASE_LL_HDR].desc == NULL &&
 	    nftnl_trace_is_set(nlt, NFTNL_TRACE_IIFTYPE)) {
 		dev_type = nftnl_trace_get_u16(nlt, NFTNL_TRACE_IIFTYPE);

--DocE+STaALJfprDB--
