Return-Path: <SRS0=LXG+=DT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B01FCC433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Oct 2020 12:02:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8627C2065D
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Oct 2020 12:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388437AbgJLMCg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 08:02:36 -0400
Received: from correo.us.es ([193.147.175.20]:38258 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388334AbgJLMCg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 08:02:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 18D8CD2DA06
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Oct 2020 14:02:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 08C2BDA78C
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Oct 2020 14:02:34 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F2925DA73F; Mon, 12 Oct 2020 14:02:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 07195DA730;
        Mon, 12 Oct 2020 14:02:32 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 12 Oct 2020 14:02:32 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id DAC7C42EE38E;
        Mon, 12 Oct 2020 14:02:31 +0200 (CEST)
Date:   Mon, 12 Oct 2020 14:02:31 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v2 03/10] nft: cache: Introduce
 nft_cache_add_chain()
Message-ID: <20201012120231.GC26845@salvia>
References: <20200923174849.5773-1-phil@nwl.cc>
 <20200923174849.5773-4-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200923174849.5773-4-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 23, 2020 at 07:48:42PM +0200, Phil Sutter wrote:
> This is a convenience function for adding a chain to cache, for now just
> a simple wrapper around nftnl_chain_list_add_tail().
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Changes since v1:
> - Use the function in nft_chain_builtin_add() as well.
> ---
>  iptables/nft-cache.c | 12 +++++++++---
>  iptables/nft-cache.h |  3 +++
>  iptables/nft.c       | 16 +++++++---------
>  3 files changed, 19 insertions(+), 12 deletions(-)
> 
> diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
> index b94766a751db4..a22e693320451 100644
> --- a/iptables/nft-cache.c
> +++ b/iptables/nft-cache.c
> @@ -165,6 +165,13 @@ static int fetch_table_cache(struct nft_handle *h)
>  	return 1;
>  }
>  
> +int nft_cache_add_chain(struct nft_handle *h, const struct builtin_table *t,
> +			struct nftnl_chain *c)
> +{
> +	nftnl_chain_list_add_tail(c, h->cache->table[t->type].chains);
> +	return 0;
> +}

This wrapper LGTM.

>  struct nftnl_chain_list_cb_data {
>  	struct nft_handle *h;
>  	const struct builtin_table *t;
> @@ -174,7 +181,6 @@ static int nftnl_chain_list_cb(const struct nlmsghdr *nlh, void *data)
>  {
>  	struct nftnl_chain_list_cb_data *d = data;
>  	const struct builtin_table *t = d->t;
> -	struct nftnl_chain_list *list;
>  	struct nft_handle *h = d->h;
>  	struct nftnl_chain *c;
>  	const char *tname;
> @@ -196,8 +202,8 @@ static int nftnl_chain_list_cb(const struct nlmsghdr *nlh, void *data)
>  		goto out;
>  	}
>  
> -	list = h->cache->table[t->type].chains;
> -	nftnl_chain_list_add_tail(c, list);
> +	if (nft_cache_add_chain(h, t, c))
> +		goto out;
>  
>  	return MNL_CB_OK;
>  out:
> diff --git a/iptables/nft-cache.h b/iptables/nft-cache.h
> index 76f9fbb6c8ccc..d97f8de255f02 100644
> --- a/iptables/nft-cache.h
> +++ b/iptables/nft-cache.h
> @@ -3,6 +3,7 @@
>  
>  struct nft_handle;
>  struct nft_cmd;
> +struct builtin_table;
>  
>  void nft_cache_level_set(struct nft_handle *h, int level,
>  			 const struct nft_cmd *cmd);
> @@ -12,6 +13,8 @@ void flush_chain_cache(struct nft_handle *h, const char *tablename);
>  int flush_rule_cache(struct nft_handle *h, const char *table,
>  		     struct nftnl_chain *c);
>  void nft_cache_build(struct nft_handle *h);
> +int nft_cache_add_chain(struct nft_handle *h, const struct builtin_table *t,
> +			struct nftnl_chain *c);
>  
>  struct nftnl_chain_list *
>  nft_chain_list_get(struct nft_handle *h, const char *table, const char *chain);
> diff --git a/iptables/nft.c b/iptables/nft.c
> index 4f40be2e60252..8e1a33ba69bf1 100644
> --- a/iptables/nft.c
> +++ b/iptables/nft.c
> @@ -695,7 +695,7 @@ static void nft_chain_builtin_add(struct nft_handle *h,
>  		return;
>  
>  	batch_chain_add(h, NFT_COMPAT_CHAIN_ADD, c);
> -	nftnl_chain_list_add_tail(c, h->cache->table[table->type].chains);
> +	nft_cache_add_chain(h, table, c);
>  }
>  
>  /* find if built-in table already exists */
> @@ -1696,7 +1696,7 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
>  
>  int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *table)
>  {
> -	struct nftnl_chain_list *list;
> +	const struct builtin_table *t;
>  	struct nftnl_chain *c;
>  	int ret;
>  
> @@ -1720,9 +1720,8 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
>  
>  	ret = batch_chain_add(h, NFT_COMPAT_CHAIN_USER_ADD, c);
>  
> -	list = nft_chain_list_get(h, table, chain);
> -	if (list)
> -		nftnl_chain_list_add(c, list);
> +	t = nft_table_builtin_find(h, table);

I'd add here:

        assert(t);

just in case this is ever crashing here, let's make it nice.
