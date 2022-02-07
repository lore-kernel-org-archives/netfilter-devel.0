Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89542C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Feb 2022 18:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236058AbiBGSCc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Feb 2022 13:02:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243143AbiBGR75 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Feb 2022 12:59:57 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 04061C0401DF
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Feb 2022 09:59:56 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 45E35601C0;
        Mon,  7 Feb 2022 18:59:52 +0100 (CET)
Date:   Mon, 7 Feb 2022 18:59:54 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 1/4] nft: Set NFTNL_CHAIN_FAMILY in new chains
Message-ID: <YgFeGpsoHO4wjGU0@salvia>
References: <20220204170001.27198-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220204170001.27198-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Series LGTM, thanks

On Fri, Feb 04, 2022 at 05:59:58PM +0100, Phil Sutter wrote:
> Kernel doesn't need it, but debug output improves significantly. Before
> this patch:
> 
> | # iptables-nft -vv -A INPUT
> | [...]
> | unknown filter INPUT use 0 type filter hook unknown prio 0 policy accept packets 0 bytes 0
> | [...]
> 
> and after:
> 
> | # iptables-nft -vv -A INPUT
> | [...]
> | ip filter INPUT use 0 type filter hook input prio 0 policy accept packets 0 bytes 0
> | [...]
> 
> While being at it, make nft_chain_builtin_alloc() take only the builtin
> table's name as parameter - it's the only field it accesses.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  iptables/nft.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/iptables/nft.c b/iptables/nft.c
> index 7cc6ca5258150..301d6c342f982 100644
> --- a/iptables/nft.c
> +++ b/iptables/nft.c
> @@ -665,7 +665,7 @@ static int nft_table_builtin_add(struct nft_handle *h,
>  }
>  
>  static struct nftnl_chain *
> -nft_chain_builtin_alloc(const struct builtin_table *table,
> +nft_chain_builtin_alloc(int family, const char *tname,
>  			const struct builtin_chain *chain, int policy)
>  {
>  	struct nftnl_chain *c;
> @@ -674,7 +674,8 @@ nft_chain_builtin_alloc(const struct builtin_table *table,
>  	if (c == NULL)
>  		return NULL;
>  
> -	nftnl_chain_set_str(c, NFTNL_CHAIN_TABLE, table->name);
> +	nftnl_chain_set_u32(c, NFTNL_CHAIN_FAMILY, family);
> +	nftnl_chain_set_str(c, NFTNL_CHAIN_TABLE, tname);
>  	nftnl_chain_set_str(c, NFTNL_CHAIN_NAME, chain->name);
>  	nftnl_chain_set_u32(c, NFTNL_CHAIN_HOOKNUM, chain->hook);
>  	nftnl_chain_set_u32(c, NFTNL_CHAIN_PRIO, chain->prio);
> @@ -693,7 +694,7 @@ static void nft_chain_builtin_add(struct nft_handle *h,
>  {
>  	struct nftnl_chain *c;
>  
> -	c = nft_chain_builtin_alloc(table, chain, NF_ACCEPT);
> +	c = nft_chain_builtin_alloc(h->family, table->name, chain, NF_ACCEPT);
>  	if (c == NULL)
>  		return;
>  
> @@ -959,7 +960,7 @@ static struct nftnl_chain *nft_chain_new(struct nft_handle *h,
>  	_c = nft_chain_builtin_find(_t, chain);
>  	if (_c != NULL) {
>  		/* This is a built-in chain */
> -		c = nft_chain_builtin_alloc(_t, _c, policy);
> +		c = nft_chain_builtin_alloc(h->family, _t->name, _c, policy);
>  		if (c == NULL)
>  			return NULL;
>  	} else {
> @@ -1999,6 +2000,7 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
>  	if (c == NULL)
>  		return 0;
>  
> +	nftnl_chain_set_u32(c, NFTNL_CHAIN_FAMILY, h->family);
>  	nftnl_chain_set_str(c, NFTNL_CHAIN_TABLE, table);
>  	nftnl_chain_set_str(c, NFTNL_CHAIN_NAME, chain);
>  	if (h->family == NFPROTO_BRIDGE)
> @@ -2029,6 +2031,7 @@ int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table
>  		if (!c)
>  			return 0;
>  
> +		nftnl_chain_set_u32(c, NFTNL_CHAIN_FAMILY, h->family);
>  		nftnl_chain_set_str(c, NFTNL_CHAIN_TABLE, table);
>  		nftnl_chain_set_str(c, NFTNL_CHAIN_NAME, chain);
>  		created = true;
> @@ -2190,6 +2193,7 @@ int nft_chain_user_rename(struct nft_handle *h,const char *chain,
>  	if (c == NULL)
>  		return 0;
>  
> +	nftnl_chain_set_u32(c, NFTNL_CHAIN_FAMILY, h->family);
>  	nftnl_chain_set_str(c, NFTNL_CHAIN_TABLE, table);
>  	nftnl_chain_set_str(c, NFTNL_CHAIN_NAME, newname);
>  	nftnl_chain_set_u64(c, NFTNL_CHAIN_HANDLE, handle);
> -- 
> 2.34.1
> 
