Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DA9CC433FE
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Dec 2020 11:25:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 446F723A22
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Dec 2020 11:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730675AbgLILZd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 06:25:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730484AbgLILZc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 06:25:32 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6022AC0613CF
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2020 03:24:52 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kmxaU-0003c8-8J; Wed, 09 Dec 2020 12:24:50 +0100
Date:   Wed, 9 Dec 2020 12:24:50 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v2 03/10] nft: cache: Introduce
 nft_cache_add_chain()
Message-ID: <20201209112450.GB4647@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200923174849.5773-1-phil@nwl.cc>
 <20200923174849.5773-4-phil@nwl.cc>
 <20201012120231.GC26845@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012120231.GC26845@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Oct 12, 2020 at 02:02:31PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 23, 2020 at 07:48:42PM +0200, Phil Sutter wrote:
> > This is a convenience function for adding a chain to cache, for now just
> > a simple wrapper around nftnl_chain_list_add_tail().
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> > Changes since v1:
> > - Use the function in nft_chain_builtin_add() as well.
> > ---
> >  iptables/nft-cache.c | 12 +++++++++---
> >  iptables/nft-cache.h |  3 +++
> >  iptables/nft.c       | 16 +++++++---------
> >  3 files changed, 19 insertions(+), 12 deletions(-)
> > 
> > diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
> > index b94766a751db4..a22e693320451 100644
> > --- a/iptables/nft-cache.c
> > +++ b/iptables/nft-cache.c
> > @@ -165,6 +165,13 @@ static int fetch_table_cache(struct nft_handle *h)
> >  	return 1;
> >  }
> >  
> > +int nft_cache_add_chain(struct nft_handle *h, const struct builtin_table *t,
> > +			struct nftnl_chain *c)
> > +{
> > +	nftnl_chain_list_add_tail(c, h->cache->table[t->type].chains);
> > +	return 0;
> > +}
> 
> This wrapper LGTM.
> 
> >  struct nftnl_chain_list_cb_data {
> >  	struct nft_handle *h;
> >  	const struct builtin_table *t;
> > @@ -174,7 +181,6 @@ static int nftnl_chain_list_cb(const struct nlmsghdr *nlh, void *data)
> >  {
> >  	struct nftnl_chain_list_cb_data *d = data;
> >  	const struct builtin_table *t = d->t;
> > -	struct nftnl_chain_list *list;
> >  	struct nft_handle *h = d->h;
> >  	struct nftnl_chain *c;
> >  	const char *tname;
> > @@ -196,8 +202,8 @@ static int nftnl_chain_list_cb(const struct nlmsghdr *nlh, void *data)
> >  		goto out;
> >  	}
> >  
> > -	list = h->cache->table[t->type].chains;
> > -	nftnl_chain_list_add_tail(c, list);
> > +	if (nft_cache_add_chain(h, t, c))
> > +		goto out;
> >  
> >  	return MNL_CB_OK;
> >  out:
> > diff --git a/iptables/nft-cache.h b/iptables/nft-cache.h
> > index 76f9fbb6c8ccc..d97f8de255f02 100644
> > --- a/iptables/nft-cache.h
> > +++ b/iptables/nft-cache.h
> > @@ -3,6 +3,7 @@
> >  
> >  struct nft_handle;
> >  struct nft_cmd;
> > +struct builtin_table;
> >  
> >  void nft_cache_level_set(struct nft_handle *h, int level,
> >  			 const struct nft_cmd *cmd);
> > @@ -12,6 +13,8 @@ void flush_chain_cache(struct nft_handle *h, const char *tablename);
> >  int flush_rule_cache(struct nft_handle *h, const char *table,
> >  		     struct nftnl_chain *c);
> >  void nft_cache_build(struct nft_handle *h);
> > +int nft_cache_add_chain(struct nft_handle *h, const struct builtin_table *t,
> > +			struct nftnl_chain *c);
> >  
> >  struct nftnl_chain_list *
> >  nft_chain_list_get(struct nft_handle *h, const char *table, const char *chain);
> > diff --git a/iptables/nft.c b/iptables/nft.c
> > index 4f40be2e60252..8e1a33ba69bf1 100644
> > --- a/iptables/nft.c
> > +++ b/iptables/nft.c
> > @@ -695,7 +695,7 @@ static void nft_chain_builtin_add(struct nft_handle *h,
> >  		return;
> >  
> >  	batch_chain_add(h, NFT_COMPAT_CHAIN_ADD, c);
> > -	nftnl_chain_list_add_tail(c, h->cache->table[table->type].chains);
> > +	nft_cache_add_chain(h, table, c);
> >  }
> >  
> >  /* find if built-in table already exists */
> > @@ -1696,7 +1696,7 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
> >  
> >  int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *table)
> >  {
> > -	struct nftnl_chain_list *list;
> > +	const struct builtin_table *t;
> >  	struct nftnl_chain *c;
> >  	int ret;
> >  
> > @@ -1720,9 +1720,8 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
> >  
> >  	ret = batch_chain_add(h, NFT_COMPAT_CHAIN_USER_ADD, c);
> >  
> > -	list = nft_chain_list_get(h, table, chain);
> > -	if (list)
> > -		nftnl_chain_list_add(c, list);
> > +	t = nft_table_builtin_find(h, table);
> 
> I'd add here:
> 
>         assert(t);
> 
> just in case this is ever crashing here, let's make it nice.

It is not needed: In nft_chain_user_add(), there is a call to
nft_chain_exists() earlier which implicitly checks that
nft_table_builtin_find() succeeds with given table name.

The other two places the wrapper is used are fine, too:

In nft_chain_builtin_add(), the builtin_table pointer was passed via
parameters from nft_xt_builtin_init() which itself does a NULL-pointer
check.

In nft_chain_restore(), the table's name is passed from state->curtable
pointer in xtables_restore_parse_line() which in turn was acquired via
nft_table_builtin_find(). (I actually plan to pass this builtin_table
pointer around instead of the table name at some point.)

Cheers, Phil
