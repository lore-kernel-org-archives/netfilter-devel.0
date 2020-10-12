Return-Path: <SRS0=LXG+=DT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C05C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Oct 2020 12:03:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F12B21655
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Oct 2020 12:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388281AbgJLMDq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 08:03:46 -0400
Received: from correo.us.es ([193.147.175.20]:38562 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388209AbgJLMDq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 08:03:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 48557D2DA0D
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Oct 2020 14:03:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 36681DA73F
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Oct 2020 14:03:44 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2BD0BDA730; Mon, 12 Oct 2020 14:03:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 37C7EDA78C;
        Mon, 12 Oct 2020 14:03:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 12 Oct 2020 14:03:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1A06A42EE38E;
        Mon, 12 Oct 2020 14:03:42 +0200 (CEST)
Date:   Mon, 12 Oct 2020 14:03:41 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v2 04/10] nft: Eliminate nft_chain_list_get()
Message-ID: <20201012120341.GD26845@salvia>
References: <20200923174849.5773-1-phil@nwl.cc>
 <20200923174849.5773-5-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200923174849.5773-5-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 23, 2020 at 07:48:43PM +0200, Phil Sutter wrote:
> Since introduction of nft_cache_add_chain(), there is merely a single
> user of nft_chain_list_get() left. Hence fold the function into its
> caller.

Why this last update regarding nft_chain_list_get() and not in 02/10 ?

> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  iptables/nft-cache.c | 13 -------------
>  iptables/nft-cache.h |  2 --
>  iptables/nft.c       |  8 +++++---
>  3 files changed, 5 insertions(+), 18 deletions(-)
> 
> diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
> index a22e693320451..109524c3fbc79 100644
> --- a/iptables/nft-cache.c
> +++ b/iptables/nft-cache.c
> @@ -684,16 +684,3 @@ nft_set_list_get(struct nft_handle *h, const char *table, const char *set)
>  
>  	return h->cache->table[t->type].sets;
>  }
> -
> -struct nftnl_chain_list *
> -nft_chain_list_get(struct nft_handle *h, const char *table, const char *chain)
> -{
> -	const struct builtin_table *t;
> -
> -	t = nft_table_builtin_find(h, table);
> -	if (!t)
> -		return NULL;
> -
> -	return h->cache->table[t->type].chains;
> -}
> -
> diff --git a/iptables/nft-cache.h b/iptables/nft-cache.h
> index d97f8de255f02..52ad2d396199e 100644
> --- a/iptables/nft-cache.h
> +++ b/iptables/nft-cache.h
> @@ -16,8 +16,6 @@ void nft_cache_build(struct nft_handle *h);
>  int nft_cache_add_chain(struct nft_handle *h, const struct builtin_table *t,
>  			struct nftnl_chain *c);
>  
> -struct nftnl_chain_list *
> -nft_chain_list_get(struct nft_handle *h, const char *table, const char *chain);
>  struct nftnl_set_list *
>  nft_set_list_get(struct nft_handle *h, const char *table, const char *set);
>  
> diff --git a/iptables/nft.c b/iptables/nft.c
> index 8e1a33ba69bf1..5967d36038953 100644
> --- a/iptables/nft.c
> +++ b/iptables/nft.c
> @@ -1837,13 +1837,15 @@ out:
>  static struct nftnl_chain *
>  nft_chain_find(struct nft_handle *h, const char *table, const char *chain)
>  {
> +	const struct builtin_table *t;
>  	struct nftnl_chain_list *list;
>  
> -	list = nft_chain_list_get(h, table, chain);
> -	if (list == NULL)
> +	t = nft_table_builtin_find(h, table);
> +	if (!t)
>  		return NULL;
>  
> -	return nftnl_chain_list_lookup_byname(list, chain);
> +	list = h->cache->table[t->type].chains;
> +	return list ? nftnl_chain_list_lookup_byname(list, chain) : NULL;
>  }
>  
>  bool nft_chain_exists(struct nft_handle *h,
> -- 
> 2.28.0
> 
