From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] src: add support to flush sets
Date: Tue, 6 Dec 2016 12:23:17 +0100
Message-ID: <20161206112317.GB5093@salvia>
References: <1480977425-15015-1-git-send-email-pablo@netfilter.org>
 <1481022817.2725.1@smtp.rezel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Anatole Denis <anatole@rezel.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33690 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752107AbcLFLXX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Dec 2016 06:23:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 69F7A174D0E
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 12:23:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5A32F6D286
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 12:23:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 50D9F6D290
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 12:23:18 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1481022817.2725.1@smtp.rezel.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 06, 2016 at 12:13:37PM +0100, Anatole Denis wrote:
> On lun., déc. 5, 2016 at 11:37 , Pablo Neira Ayuso <pablo@netfilter.org>
> wrote:
> >You can use this new command to remove all existing elements in a set:
> >
> > # nft flush set filter xyz
> >
> >After this command, the set 'xyz' in table 'filter' becomes empty.
> >
> >Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> >---
> > include/netlink.h | 2 ++
> > src/evaluate.c    | 3 +++
> > src/netlink.c     | 9 ++++++++-
> > src/rule.c        | 3 +++
> > 4 files changed, 16 insertions(+), 1 deletion(-)
> >
> >diff --git a/include/netlink.h b/include/netlink.h
> >index 28c11f603ed2..363b5251968f 100644
> >--- a/include/netlink.h
> >+++ b/include/netlink.h
> >@@ -165,6 +165,8 @@ extern int netlink_delete_setelems(struct netlink_ctx
> >*ctx, const struct handle
> > 				   const struct expr *expr);
> > extern int netlink_get_setelems(struct netlink_ctx *ctx, const struct
> >handle *h,
> > 				const struct location *loc, struct set *set);
> >+extern int netlink_flush_setelems(struct netlink_ctx *ctx, const struct
> >handle *h,
> >+				  const struct location *loc);
> >
> > extern void netlink_dump_table(const struct nftnl_table *nlt);
> > extern void netlink_dump_chain(const struct nftnl_chain *nlc);
> >diff --git a/src/evaluate.c b/src/evaluate.c
> >index e11a455a5f53..8a3da54e5b2d 100644
> >--- a/src/evaluate.c
> >+++ b/src/evaluate.c
> >@@ -2857,9 +2857,11 @@ static int cmd_evaluate_list(struct eval_ctx *ctx,
> >struct cmd *cmd)
> > static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
> > {
> > 	int ret;
> >+
> > 	ret = cache_update(cmd->op, ctx->msgs);
> > 	if (ret < 0)
> > 		return ret;
> >+
> > 	switch (cmd->obj) {
> > 	case CMD_OBJ_RULESET:
> > 		cache_flush();
> >@@ -2870,6 +2872,7 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx,
> >struct cmd *cmd)
> > 		 */
> > 	case CMD_OBJ_CHAIN:
> > 		/* Chains don't hold sets */
> >+	case CMD_OBJ_SET:
> > 		break;
> 
> I think you need to empty the cache for said set here, otherwise this will
> lead to the same errors we had earlier with flush ruleset not emptying the
> set cache.

Thanks for spotting this, I'd appreciate if you send me a follow up
patch that I can apply to fix this.

> Example test which fails:
> Running
> ```
> table t{
>  set s { type ipv4_addr; flags interval
>    elements={127.0.0.1/8}
>  }
> }
> ```
> then:
> ```
> flush set t s
> add element t s {
>  127.0.0.1/8,
> }
> ```
> errors out with:
> Error: interval overlaps with an existing one
>  127.0.0.1/8,
>  ^^^^^^^^^^^
> 
> [...]
> 
> Maybe a question for another patch but: if there is support for emptying
> specific sets, maybe flushing a table should empty sets in the table as well
> as the chains ? (currently it only empties the chains and leaves the sets
> intact, which is kind of unintuitive)

That's a good point.

If we follow this approach, main problem is that set flushing is going
to be supported by recent kernels, while older don't. So if nft flush
table also flush sets, then we'll have people experiencing different
behaviours, which is not good.

So I would prefer an explicit 'nft flush sets' to empty elements from
all sets on top of this new 'nft flush set x y', and we document that
table flushing only empties rules.
