Return-Path: <SRS0=fGlf=DU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAD3FC433DF
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Oct 2020 09:57:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D1202078A
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Oct 2020 09:57:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgJMJ5B (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Oct 2020 05:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgJMJ5B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Oct 2020 05:57:01 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A34C0613D0
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Oct 2020 02:57:01 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kSH3D-0007Us-MK; Tue, 13 Oct 2020 11:56:59 +0200
Date:   Tue, 13 Oct 2020 11:56:59 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v2 06/10] nft: Introduce struct nft_chain
Message-ID: <20201013095659.GV13016@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200923174849.5773-1-phil@nwl.cc>
 <20200923174849.5773-7-phil@nwl.cc>
 <20201012120855.GE26845@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012120855.GE26845@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Oct 12, 2020 at 02:08:55PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 23, 2020 at 07:48:45PM +0200, Phil Sutter wrote:
> > Preparing for ordered output of user-defined chains, introduce a local
> > datatype wrapping nftnl_chain. In order to maintain the chain name hash
> > table, introduce nft_chain_list as well and use it instead of
> > nftnl_chain_list.
> > 
> > Put everything into a dedicated source file and provide a bunch of
> > getters for attributes of the embedded libnftnl_chain object.
> [...]
> > diff --git a/iptables/nft-chain.h b/iptables/nft-chain.h
> > new file mode 100644
> > index 0000000000000..818bbf1f4b525
> > --- /dev/null
> > +++ b/iptables/nft-chain.h
> > @@ -0,0 +1,87 @@
> > +#ifndef _NFT_CHAIN_H_
> > +#define _NFT_CHAIN_H_
> > +
> > +#include <libnftnl/chain.h>
> > +#include <libiptc/linux_list.h>
> > +
> > +struct nft_handle;
> > +
> > +struct nft_chain {
> > +	struct list_head	head;
> > +	struct hlist_node	hnode;
> > +	struct nftnl_chain	*nftnl;
> > +};
> > +
> > +#define CHAIN_NAME_HSIZE	512
> > +
> > +struct nft_chain_list {
> > +	struct list_head	list;
> > +	struct hlist_head	names[CHAIN_NAME_HSIZE];
> > +};
> > +
> > +struct nft_chain *nft_chain_alloc(struct nftnl_chain *nftnl);
> > +void nft_chain_free(struct nft_chain *c);
> > +
> > +struct nft_chain_list *nft_chain_list_alloc(void);
> > +void nft_chain_list_free(struct nft_chain_list *list);
> > +void nft_chain_list_del(struct nft_chain *c);
> > +
> > +static inline const char *nft_chain_name(struct nft_chain *c)
> > +{
> > +	return nftnl_chain_get_str(c->nftnl, NFTNL_CHAIN_NAME);
> > +}
> > +
> > +static inline const char *nft_chain_table(struct nft_chain *c)
> > +{
> > +	return nftnl_chain_get_str(c->nftnl, NFTNL_CHAIN_TABLE);
> > +}
> > +
> > +static inline const char *nft_chain_type(struct nft_chain *c)
> > +{
> > +	return nftnl_chain_get_str(c->nftnl, NFTNL_CHAIN_TYPE);
> > +}
> > +
> > +static inline uint32_t nft_chain_prio(struct nft_chain *c)
> > +{
> > +	return nftnl_chain_get_u32(c->nftnl, NFTNL_CHAIN_PRIO);
> > +}
> > +
> > +static inline uint32_t nft_chain_hooknum(struct nft_chain *c)
> > +{
> > +	return nftnl_chain_get_u32(c->nftnl, NFTNL_CHAIN_HOOKNUM);
> > +}
> > +
> > +static inline uint64_t nft_chain_packets(struct nft_chain *c)
> > +{
> > +	return nftnl_chain_get_u64(c->nftnl, NFTNL_CHAIN_PACKETS);
> > +}
> > +
> > +static inline uint64_t nft_chain_bytes(struct nft_chain *c)
> > +{
> > +	return nftnl_chain_get_u64(c->nftnl, NFTNL_CHAIN_BYTES);
> > +}
> > +
> > +static inline bool nft_chain_has_policy(struct nft_chain *c)
> > +{
> > +	return nftnl_chain_is_set(c->nftnl, NFTNL_CHAIN_POLICY);
> > +}
> > +
> > +static inline uint32_t nft_chain_policy(struct nft_chain *c)
> > +{
> > +	return nftnl_chain_get_u32(c->nftnl, NFTNL_CHAIN_POLICY);
> > +}
> > +
> > +static inline uint32_t nft_chain_use(struct nft_chain *c)
> > +{
> > +	return nftnl_chain_get_u32(c->nftnl, NFTNL_CHAIN_USE);
> > +}
> 
> Do you need this wrapper functions now? I mean, the intention is to
> have a native nft_chain structure so nft_chain_use() become:
> 
> static inline uint32_t nft_chain_use(struct nft_chain *c)
> {
> 	return c->use;
> }

Potentially, yes. I played with "pre-extracting" some attributes from
nftnl_chain object once, populating pointers in nft_chain object and
making above getters just return that pointer.

> at some point?
> 
> Sorry but I don't see this is happening in this batch?

I'm not entirely sure it is much use. In fact, we get nftnl_chain
objects when fetching cache from kernel and when pushing changes to
kernel we need nftnl_chain objects again. So unless we're concerned with
memory use in between or we get rid of the need for nftnl_chain objects,
dropping and recreating them is just extra work.

> I remember the original intention was to support for sorting chains,
> so the listing is predictable. But this batch is updating more things
> than that and I don't see a clear connection with the goal.

The nft_chain struct is needed mostly to allow for sorting the chain
list without adding code to libnftnl. This was your request before this
respin, you claimed it is important to keep libnftnl code size small. So
nft_chain is mostly a reimplementation of nftnl_chain_list, including
chain name hash.

The getter introduction is handy as I had many change like:

- nftnl_rule_set_str(rule, NFTNL_RULE_TABLE,
-                    nftnl_chain_get_str(c, NFTNL_CHAIN_TABLE));
+ nftnl_rule_set_str(rule, NFTNL_RULE_TABLE,
+                    nftnl_chain_get_str(c->nftnl, NFTNL_CHAIN_TABLE));

Given that I have to touch those lines anyway, with introducing a getter
things become a bit cleaner also:

- nftnl_rule_set_str(rule, NFTNL_RULE_TABLE,
-                    nftnl_chain_get_str(c, NFTNL_CHAIN_TABLE));
+ nftnl_rule_set_str(rule, NFTNL_RULE_TABLE, nft_chain_table(c));

Thinking about it, I could introduce the getters in a separate, early
patch. This would reduce the nft_chain introduction patch quite a bit.
But since these getters are (in the current form) specific to nft_chain
objects, I find it all belongs together.

Cheers, Phil
