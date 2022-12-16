Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 204ACC4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Dec 2022 13:27:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiLPN1B (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Dec 2022 08:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiLPN07 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Dec 2022 08:26:59 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6051133C0E
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Dec 2022 05:26:58 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1p6Ajn-0002xJ-JY; Fri, 16 Dec 2022 14:26:55 +0100
Date:   Fri, 16 Dec 2022 14:26:55 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH] netfilter: nf_tables: Introduce
 NFTA_RULE_ALT_EXPRESSIONS
Message-ID: <20221216132655.GB8767@breakpoint.cc>
References: <20221215204302.8378-1-phil@nwl.cc>
 <20221216011641.GA574@breakpoint.cc>
 <Y5xmOPFp8mYZqzIW@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5xmOPFp8mYZqzIW@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> > Or at least mention that this is for iptables-nft/NFT_COMPAT sake?
> 
> I could move it into NFTA_RULE_COMPAT.

Fine with me.

> > Perhaps its better to use two distinct attributes?
> > 
> > NFTA_RULE_EXPRESSIONS_COMPAT  (input)
> > NFTA_RULE_EXPRESSIONS_ACTUAL  (output)?
> 
> With NFTA_RULE_EXPRESSIONS_ACTUAL replacing NFTA_RULE_EXPRESSIONS?

Yes, NFTA_RULE_EXPRESSIONS is the 'compat kludge',
NFTA_RULE_EXPRESSIONS_ACTUAL the active one.

> > The switcheroo of ALT (old crap on input, actual live ruleset on output)
> > is very unintuitive.
> 
> Well, providing something that replaces the content of
> NFTA_RULE_EXPRESSIONS is the basic concept of this approach. Restricting
> it to output only is not possible since old user space uses it for
> input. I guess one could make new user space use the *_COMPAT/*_ACTUAL
> attributes above but kernel still has to fall back to plain
> *_EXPRESSIONS.

Yep.

> Adding the two attributes above and using *_COMPAT for input only and
> *_ACTUAL for output only is probably a trivial change though.

Right.  I don't mind but its perhaps a bit clearer as to what is going
on.

> [...]
> > > diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> > > index cfa844da1ce61..2dff92f527429 100644
> > > --- a/include/uapi/linux/netfilter/nf_tables.h
> > > +++ b/include/uapi/linux/netfilter/nf_tables.h
> > > @@ -247,6 +247,8 @@ enum nft_chain_attributes {
> > >   * @NFTA_RULE_USERDATA: user data (NLA_BINARY, NFT_USERDATA_MAXLEN)
> > >   * @NFTA_RULE_ID: uniquely identifies a rule in a transaction (NLA_U32)
> > >   * @NFTA_RULE_POSITION_ID: transaction unique identifier of the previous rule (NLA_U32)
> > > + * @NFTA_RULE_CHAIN_ID: add the rule to chain by ID, alternative to @NFTA_RULE_CHAIN (NLA_U32)
> > > + * @NFTA_RULE_ALT_EXPRESSIONS: expressions to swap with @NFTA_RULE_EXPRESSIONS for dumps (NLA_NESTED: nft_expr_attributes)
> > >   */
> > >  enum nft_rule_attributes {
> > >  	NFTA_RULE_UNSPEC,
> > > @@ -261,6 +263,7 @@ enum nft_rule_attributes {
> > >  	NFTA_RULE_ID,
> > >  	NFTA_RULE_POSITION_ID,
> > >  	NFTA_RULE_CHAIN_ID,
> > > +	NFTA_RULE_ALT_EXPRESSIONS,
> > 
> > You need to update the nla_policy too.
> 
> ACK, thanks!

[..]

> > > +	if (nla[NFTA_RULE_ALT_EXPRESSIONS]) {
> > > +		int dlen = nla_len(nla[NFTA_RULE_ALT_EXPRESSIONS]);
> > > +		alt_expr = kvmalloc(sizeof(*alt_expr) + dlen, GFP_KERNEL);
> > 
> > Once nla_policy provides a maxlen this is fine.
> 
> Hmm. I could define this max length as
> | NFT_RULE_MAXEXPRS * max(nft_expr_ops::size)
> given the currently existing nft_expr_ops instances in kernel. This
> isn't pretty accurate though. Or I do a "fake" parsing of the nested
> expression list only checking the number of elements? IIUC, this is the
> only restriction applied to NFTA_RULE_EXPRESSIONS - at least I don't see
> the size of each NFTA_LIST_ELEM being checked against its
> nft_expr_ops::size. Or am I missing something?

Actually you don't need a maxlen at all, sorry.  I saw the nla_len and
thought NLA_BINARY but you could do this:

-       [NFTA_RULE_EXPRESSIONS] = { .type = NLA_NESTED },
+       [NFTA_RULE_EXPRESSIONS] = NLA_POLICY_NESTED_ARRAY(nft_expr_policy),


... and use the same for the COMPAT_EXPRESSIONS (or whatever name
will be chosen).

(This won't do full validation of all attributes because the policy
 for expr 'X' isn't known at compile time).

> > > +		nla_memcpy(alt_expr->data,
> > > +			   nla[NFTA_RULE_ALT_EXPRESSIONS], dlen);
> > 
> > Hmm, I wonder if this isn't a problem.
> > The kernel will now dump arbitrary data to userspace, whereas without
> > this patch the nla data is generated by kernel, i.e. never malformed.
> > 
> > I wonder if the alt blob needs to go through some type of validation
> > too?
> 
> Given that the kernel doesn't use the ALT data, I liked the fact that it
> may contain expressions it doesn't even support anymore. Upholding this
> allows to disable nft_compat in kernel once iptables-nft produces native
> expressions for everything.
>
> I get your point about dumping tainted data. Does a shallow syntactic
> check suffice, is it required to verify each expression's syntax or even
> its semantics?

I was just wondering if we should at least verify that netlink
attributes and sizes match, not that the expressions themselves are
parseable/available.

But its impossible to do so if the expression isn't available because
we then have no policy either.

So perhaps above NLA_POLICY_NESTED_ARRAY() is enough after all.
