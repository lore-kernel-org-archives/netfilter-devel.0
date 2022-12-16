Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1538C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Dec 2022 12:36:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiLPMgN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Dec 2022 07:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLPMgM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Dec 2022 07:36:12 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B7D13CEC
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Dec 2022 04:36:10 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1p69we-0005iN-GM; Fri, 16 Dec 2022 13:36:08 +0100
Date:   Fri, 16 Dec 2022 13:36:08 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH] netfilter: nf_tables: Introduce
 NFTA_RULE_ALT_EXPRESSIONS
Message-ID: <Y5xmOPFp8mYZqzIW@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20221215204302.8378-1-phil@nwl.cc>
 <20221216011641.GA574@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221216011641.GA574@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Fri, Dec 16, 2022 at 02:16:41AM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > With identical content as NFTA_RULE_EXPRESSIONS, data in this attribute
> > is dumped in place of the live expressions, which in turn are dumped as
> > NFTA_RULE_ALT_EXPRESSIONS.
> 
> This name isn't very descriptive.
> 
> Or at least mention that this is for iptables-nft/NFT_COMPAT sake?

I could move it into NFTA_RULE_COMPAT.

> Perhaps its better to use two distinct attributes?
> 
> NFTA_RULE_EXPRESSIONS_COMPAT  (input)
> NFTA_RULE_EXPRESSIONS_ACTUAL  (output)?

With NFTA_RULE_EXPRESSIONS_ACTUAL replacing NFTA_RULE_EXPRESSIONS?

> The switcheroo of ALT (old crap on input, actual live ruleset on output)
> is very unintuitive.

Well, providing something that replaces the content of
NFTA_RULE_EXPRESSIONS is the basic concept of this approach. Restricting
it to output only is not possible since old user space uses it for
input. I guess one could make new user space use the *_COMPAT/*_ACTUAL
attributes above but kernel still has to fall back to plain
*_EXPRESSIONS.

Adding the two attributes above and using *_COMPAT for input only and
*_ACTUAL for output only is probably a trivial change though.

[...]
> > diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> > index cfa844da1ce61..2dff92f527429 100644
> > --- a/include/uapi/linux/netfilter/nf_tables.h
> > +++ b/include/uapi/linux/netfilter/nf_tables.h
> > @@ -247,6 +247,8 @@ enum nft_chain_attributes {
> >   * @NFTA_RULE_USERDATA: user data (NLA_BINARY, NFT_USERDATA_MAXLEN)
> >   * @NFTA_RULE_ID: uniquely identifies a rule in a transaction (NLA_U32)
> >   * @NFTA_RULE_POSITION_ID: transaction unique identifier of the previous rule (NLA_U32)
> > + * @NFTA_RULE_CHAIN_ID: add the rule to chain by ID, alternative to @NFTA_RULE_CHAIN (NLA_U32)
> > + * @NFTA_RULE_ALT_EXPRESSIONS: expressions to swap with @NFTA_RULE_EXPRESSIONS for dumps (NLA_NESTED: nft_expr_attributes)
> >   */
> >  enum nft_rule_attributes {
> >  	NFTA_RULE_UNSPEC,
> > @@ -261,6 +263,7 @@ enum nft_rule_attributes {
> >  	NFTA_RULE_ID,
> >  	NFTA_RULE_POSITION_ID,
> >  	NFTA_RULE_CHAIN_ID,
> > +	NFTA_RULE_ALT_EXPRESSIONS,
> 
> You need to update the nla_policy too.

ACK, thanks!

> > +		if (nla_put(skb, NFTA_RULE_EXPRESSIONS,
> > +			    rule->alt_expr->dlen, rule->alt_expr->data) < 0)
> > +			goto nla_put_failure;
> > +	} else {
> > +		list = nla_nest_start_noflag(skb, NFTA_RULE_EXPRESSIONS);
> > +		if (!list)
> >  			goto nla_put_failure;
> > +
> > +		nft_rule_for_each_expr(expr, next, rule) {
> > +			if (nft_expr_dump(skb, NFTA_LIST_ELEM, expr, reset) < 0)
> > +				goto nla_put_failure;
> > +		}
> > +		nla_nest_end(skb, list);
> > +	}
> > +
> > +	if (rule->alt_expr) {
> > +		list = nla_nest_start_noflag(skb, NFTA_RULE_ALT_EXPRESSIONS);
> > +		if (!list)
> > +			goto nla_put_failure;
> > +
> > +		nft_rule_for_each_expr(expr, next, rule) {
> > +			if (nft_expr_dump(skb, NFTA_LIST_ELEM, expr, reset) < 0)
> > +				goto nla_put_failure;
> > +		}
> > +		nla_nest_end(skb, list);
> 
> How does userspace know if NFTA_RULE_EXPRESSIONS is the backward annotated
> kludge or the live/real ruleset?  Check for presence of ALT attribute?

Yes, by presence check. iptables-nft may default to ALT_EXPRESSIONS or
parse both into iptables_command_state objects for comparison.

> > -	nla_nest_end(skb, list);
> >  
> >  	if (rule->udata) {
> >  		struct nft_userdata *udata = nft_userdata(rule);
> > @@ -3366,6 +3385,7 @@ static void nf_tables_rule_destroy(const struct nft_ctx *ctx,
> >  		nf_tables_expr_destroy(ctx, expr);
> >  		expr = next;
> >  	}
> > +	kfree(rule->alt_expr);
> >  	kfree(rule);
> >  }
> >  
> > @@ -3443,6 +3463,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
> >  	struct nft_rule *rule, *old_rule = NULL;
> >  	struct nft_expr_info *expr_info = NULL;
> >  	u8 family = info->nfmsg->nfgen_family;
> > +	struct nft_alt_expr *alt_expr = NULL;
> >  	struct nft_flow_rule *flow = NULL;
> >  	struct net *net = info->net;
> >  	struct nft_userdata *udata;
> > @@ -3556,6 +3577,19 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
> >  	if (size >= 1 << 12)
> >  		goto err_release_expr;
> >  
> > +	if (nla[NFTA_RULE_ALT_EXPRESSIONS]) {
> > +		int dlen = nla_len(nla[NFTA_RULE_ALT_EXPRESSIONS]);
> > +		alt_expr = kvmalloc(sizeof(*alt_expr) + dlen, GFP_KERNEL);
> 
> Once nla_policy provides a maxlen this is fine.

Hmm. I could define this max length as
| NFT_RULE_MAXEXPRS * max(nft_expr_ops::size)
given the currently existing nft_expr_ops instances in kernel. This
isn't pretty accurate though. Or I do a "fake" parsing of the nested
expression list only checking the number of elements? IIUC, this is the
only restriction applied to NFTA_RULE_EXPRESSIONS - at least I don't see
the size of each NFTA_LIST_ELEM being checked against its
nft_expr_ops::size. Or am I missing something?

> > +		nla_memcpy(alt_expr->data,
> > +			   nla[NFTA_RULE_ALT_EXPRESSIONS], dlen);
> 
> Hmm, I wonder if this isn't a problem.
> The kernel will now dump arbitrary data to userspace, whereas without
> this patch the nla data is generated by kernel, i.e. never malformed.
> 
> I wonder if the alt blob needs to go through some type of validation
> too?

Given that the kernel doesn't use the ALT data, I liked the fact that it
may contain expressions it doesn't even support anymore. Upholding this
allows to disable nft_compat in kernel once iptables-nft produces native
expressions for everything.

I get your point about dumping tainted data. Does a shallow syntactic
check suffice, is it required to verify each expression's syntax or even
its semantics?

> Also I think that this attribute should always be ignored for
> NFT_COMPAT=n builds, we should document this kludge is only for
> iptables-nft sake (or rather, incorrect a**umptions by 3rd
> party wrappers of iptables userspace...).

Fine with me. For now, iptables-nft is not usable without NFT_COMPAT
anyway. If so, we could still relax this into ALT_EXPRESSIONS but no
compat interface itself.

Thanks, Phil
