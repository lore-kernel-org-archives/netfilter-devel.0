From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2 2/4] netlink_delinearize: Avoid potential null
 pointer deref
Date: Mon, 5 Sep 2016 18:52:43 +0200
Message-ID: <20160905165243.GA17099@salvia>
References: <1472578792-2991-1-git-send-email-phil@nwl.cc>
 <1472578792-2991-3-git-send-email-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="azLHFNyN32YCQGCU"
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50790 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964827AbcIEQwt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Sep 2016 12:52:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AC06523166C
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 18:52:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9BF2E6DB36
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 18:52:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 67A30FA4F4
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 18:52:44 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1472578792-2991-3-git-send-email-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 30, 2016 at 07:39:50PM +0200, Phil Sutter wrote:
> As netlink_get_register() may return NULL, we must not pass the returned
> data unchecked to expr_set_type() as that will dereference it. Since the
> parser has failed at that point anyway, by returning early we can skip
> the useless statement allocation that follows in
> netlink_parse_ct_stmt().

I found a couple more spots, such as the payload stmt that was not
covered by this patch.

Attaching a new one based on this, looks good to you?

Anyway, this is very unlikely to happen: Only if we ever get more
registers in the kernel, given that expl_clone() relies on the
xzalloc() function that just stops execution under OOM.

Actually this brings an interesting issue that is that we need to
provide a way to describe the vm capabilities so we can extend things
in the future without breaking userspace.

--azLHFNyN32YCQGCU
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

commit 098dae9e0cf2237b4cb3cf4c1ee89fbf9f9fb5e9
Author: Phil Sutter <phil@nwl.cc>
Date:   Tue Aug 30 19:39:50 2016 +0200

    netlink_delinearize: Avoid potential null pointer deref
    
    As netlink_get_register() may return NULL, we must not pass the returned
    data unchecked to expr_set_type() as that will dereference it. Since the
    parser has failed at that point anyway, by returning early we can skip
    the useless statement allocation that follows in
    netlink_parse_ct_stmt().
    
    Signed-off-by: Phil Sutter <phil@nwl.cc>
    Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 1a1cfbd..cddbfa6 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -428,6 +428,10 @@ static void netlink_parse_payload_stmt(struct netlink_parse_ctx *ctx,
 
 	sreg = netlink_parse_register(nle, NFTNL_EXPR_PAYLOAD_SREG);
 	val  = netlink_get_register(ctx, loc, sreg);
+	if (val == NULL)
+		return netlink_error(ctx, loc,
+				     "payload statement has no expression");
+
 	stmt = payload_stmt_alloc(loc, expr, val);
 
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
@@ -473,6 +477,9 @@ static void netlink_parse_hash(struct netlink_parse_ctx *ctx,
 
 	sreg = netlink_parse_register(nle, NFTNL_EXPR_HASH_SREG);
 	hexpr = netlink_get_register(ctx, loc, sreg);
+	if (hexpr == NULL)
+		return netlink_error(ctx, loc,
+				     "hash statement has no expression");
 
 	seed = nftnl_expr_get_u32(nle, NFTNL_EXPR_HASH_SEED);
 	mod  = nftnl_expr_get_u32(nle, NFTNL_EXPR_HASH_MODULUS);
@@ -517,6 +524,9 @@ static void netlink_parse_meta_stmt(struct netlink_parse_ctx *ctx,
 
 	sreg = netlink_parse_register(nle, NFTNL_EXPR_META_SREG);
 	expr = netlink_get_register(ctx, loc, sreg);
+	if (expr == NULL)
+		return netlink_error(ctx, loc,
+				     "meta statement has no expression");
 
 	key  = nftnl_expr_get_u32(nle, NFTNL_EXPR_META_KEY);
 	stmt = meta_stmt_alloc(loc, key, expr);
@@ -562,6 +572,9 @@ static void netlink_parse_ct_stmt(struct netlink_parse_ctx *ctx,
 
 	sreg = netlink_parse_register(nle, NFTNL_EXPR_CT_SREG);
 	expr = netlink_get_register(ctx, loc, sreg);
+	if (expr == NULL)
+		return netlink_error(ctx, loc,
+				     "ct statement has no expression");
 
 	key  = nftnl_expr_get_u32(nle, NFTNL_EXPR_CT_KEY);
 	stmt = ct_stmt_alloc(loc, key, expr);

--azLHFNyN32YCQGCU--
