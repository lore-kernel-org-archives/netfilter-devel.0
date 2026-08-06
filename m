Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A873A75A8
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Aug 2026 10:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786012243; cv=none; b=dgeqozMytAPPzir+hLnsshI5Q6nJ78UNeEVaKpc/G8bcPor+DWjtwXS6yj+aHzgf2D4rUXBoj6n7zefJQBFXzCPeHQfFF65nvzKfnaltKX5N5POjlC52VjZgkwy3Q8J8NHEgZC/NPSJSa+eg2HAZvrQn2rep8iymrhv5kHlXZ+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786012243; c=relaxed/simple;
	bh=x7CMKwemhHdTTVQqGLNNZ4UDumbNzoqVLDLA1n90ycs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gfM9rYDj808j6TJrne7a0KIriSSeCp7HCMKl3pwFd2sw5mNWr2p53ngNEwVPdI/k0ENSohCGZBCBMG0n8AcDs1+qkk2U0UBhUnwyAI378SzUZgqMw+L3cUr0dCiqm35NwI761uLdGxWtoR+96dfVlduQmGc4Lqbbc/gyZ69GgUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZwEbC+QC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8VbiqY/4; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sJft2AnX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=hCRAHlig; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZwEbC+QC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8VbiqY/4";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sJft2AnX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="hCRAHlig"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F0AC77FFB1;
	Thu,  6 Aug 2026 10:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786012236; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rLj/mNR31mtZDmcNpF5A+oTj1Kvh/maFviFNrSNj2rY=;
	b=ZwEbC+QCU002FLRDV68Ac2TPZ/fc/76azqxD4zn1UCptn+eOAUpIOkirWbGiLIdOctPw52
	sCmomSQTMV9m2+psx3tDmBnpD+VQT58UC4ycdI6P/kfgpGtIvXoMDLIsSzjd1uUQmQdJK/
	eJfZpLoJb3BowMuDHsgTd7chXjOI+BA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786012236;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rLj/mNR31mtZDmcNpF5A+oTj1Kvh/maFviFNrSNj2rY=;
	b=8VbiqY/4wsEa/1l7WVJSyPk1DnksBVILlUA/Ns+XF2ULSAQ+SEFvp2hd2FlcHW7tcoy+/H
	guVFv4IXyMnqaVCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786012231; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rLj/mNR31mtZDmcNpF5A+oTj1Kvh/maFviFNrSNj2rY=;
	b=sJft2AnXryHza8BZJSy6dOn7ykRjeZlrR+TwBDpkrZYjCkfI+pkNJHY8OciT5/YYW+5DbC
	f49iGBY7X46VNb/hp+95JrU/jJX5hHfnoqrc9NOOxdn9BWekIjFi0v7ktgAA3PVJPa1HYX
	1WHBOszazoMILtl7ib0YAzLX6wCnOA0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786012231;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rLj/mNR31mtZDmcNpF5A+oTj1Kvh/maFviFNrSNj2rY=;
	b=hCRAHligF3nX0fd5wGOcqngS0V56SjX1GvCMGBtthbYJHiq4nkFAI8ZhUW4StXbZp8KJj6
	rX7xT4ok/4tqTRCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C9412779B6;
	Thu,  6 Aug 2026 10:30:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QspdLkdidGocaAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 06 Aug 2026 10:30:31 +0000
Message-ID: <e57417f4-b586-400c-97ad-fce9f0b6d0aa@suse.de>
Date: Thu, 6 Aug 2026 12:30:14 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf,v2 2/2] netfilter: nf_tables: call set ops .commit when
 building new ruleset
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
References: <20260805171115.250749-1-pablo@netfilter.org>
 <20260805171115.250749-2-pablo@netfilter.org>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260805171115.250749-2-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,netfilter.org:email,suse.de:mid]

On 8/5/26 7:11 PM, Pablo Neira Ayuso wrote:
> The rbtree set only builds the b-search array after the new ruleset has
> been exposed through set ops .commit.
> 
> This is currently needed by pipapo because it purges the elements from
> the clone after the transactions are handled, therefore, pipapo still
> needs the delayed set ops .commit call after the transaction handling.
> 
> Allow the rbtree to call .commit before the transaction handling which
> purges the stale elements from the frontend rbtree datastructure.
> 
> Update rbtree .commit to skip deactivated and expired elements when
> building the new b-search array.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> sashiko: there is a timestamp that prevents elements from expiring while
> handling the transaction.
> 
> v2: - use NFT_GENMASK_ANY for GC scan, theoretically no new element in
>        this transaction can expire while handling the transaction but
>        let's just skip either new element or deactivated elements from
>        the GC scan.
>      - remove incorrect reset of previous rbe when performing GC scan.
> 
>   net/netfilter/nf_tables_api.c  |  9 ++++++--
>   net/netfilter/nft_set_rbtree.c | 38 ++++++++++++++++++++++++++++------
>   2 files changed, 39 insertions(+), 8 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 90a379533e08..a7006725c307 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -10853,11 +10853,14 @@ static void nf_tables_commit_audit_log(struct list_head *adl, u32 generation)
>   	}
>   }
>   
> -static void nft_set_commit_update(struct nftables_pernet *nft_net)
> +static void nft_set_commit_update(struct nftables_pernet *nft_net, bool early_commit)
>   {
>   	struct nft_set *set, *next;
>   
>   	list_for_each_entry_safe(set, next, &nft_net->set_update_list, pending_update) {
> +		if (set->ops->abort_skip_removal && early_commit)
> +			continue;
> +

Hi Pablo,

wouldn't it be better to add the early_commit flag to set->ops? This way 
we don't need to check abort_skip_removal flag.

I could foresee problems in the future using the same flag for this skip..

What about creating a nft_commit_phase enum:

enum nft_commit_phase {
	NFT_COMMIT_PHASE_EARLY,
	NFT_COMMIT_PHASE_DELAYED,
};

and then we can use it in nft_set_commit_update() as argument, something 
like:

static void nft_set_commit_update(struct nftables_pernet *nft_net,
                                   enum nft_commit_phase phase)

This way, early_commit makes sense on set->ops..

What do you think? I am trying to think in a way to make the code more 
readable.

Thanks!
Fernando.

>   		list_del_init(&set->pending_update);
>   
>   		if (!set->ops->commit || set->dead)
> @@ -10964,6 +10967,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
>   	}
>   
>   	/* step 2.  Make rules_gen_X visible to packet path */
> +	nft_set_commit_update(nft_net, true);
> +
>   	list_for_each_entry(table, &nft_net->tables, list) {
>   		list_for_each_entry(chain, &table->chains, list)
>   			nf_tables_commit_chain(net, chain);
> @@ -11170,7 +11175,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
>   		}
>   	}
>   
> -	nft_set_commit_update(nft_net);
> +	nft_set_commit_update(nft_net, false);
>   
>   	nft_commit_notify(net, NETLINK_CB(skb).portid);
>   	nf_tables_gen_notify(net, skb, NFT_MSG_NEWGEN);
> diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
> index 6222e9bb57bc..d908b94540ef 100644
> --- a/net/netfilter/nft_set_rbtree.c
> +++ b/net/netfilter/nft_set_rbtree.c
> @@ -901,6 +901,8 @@ static void nft_rbtree_gc_scan(struct nft_set *set)
>   		next = rb_next(node);
>   
>   		rbe = rb_entry(node, struct nft_rbtree_elem, node);
> +		if (!nft_set_elem_active(&rbe->ext, NFT_GENMASK_ANY))
> +			continue;
>   
>   		/* elements are reversed in the rbtree for historical reasons,
>   		 * from highest to lowest value, that is why end element is
> @@ -1036,10 +1038,32 @@ static void nft_array_free_rcu(struct rcu_head *rcu_head)
>   	__nft_array_free(array);
>   }
>   
> +static struct nft_rbtree_elem *
> +__nft_rbtree_prev_active(struct rb_node **pnode, u8 genmask)
> +{
> +	struct nft_rbtree_elem *prev_rbe;
> +	struct rb_node *node = *pnode;
> +
> +	while (node) {
> +		prev_rbe = rb_entry(node, struct nft_rbtree_elem, node);
> +		if (!nft_set_elem_active(&prev_rbe->ext, genmask)) {
> +			node = rb_prev(node);
> +			continue;
> +		}
> +
> +		*pnode = node;
> +		return prev_rbe;
> +	}
> +
> +	return NULL;
> +}
> +
>   static void nft_rbtree_commit(struct nft_set *set)
>   {
>   	struct nft_rbtree *priv = nft_set_priv(set);
>   	struct nft_rbtree_elem *rbe, *prev_rbe;
> +	struct net *net = read_pnet(&set->net);
> +	u8 genmask = nft_genmask_next(net);
>   	struct nft_array *old;
>   	u32 num_intervals = 0;
>   	struct rb_node *node;
> @@ -1061,12 +1085,12 @@ static void nft_rbtree_commit(struct nft_set *set)
>   
>   	/* Reverse walk to create an array from smaller to largest interval. */
>   	node = rb_last(&priv->root);
> -	if (node)
> -		prev_rbe = rb_entry(node, struct nft_rbtree_elem, node);
> -	else
> -		prev_rbe = NULL;
>   
> -	while (prev_rbe) {
> +	while (node) {
> +		prev_rbe = __nft_rbtree_prev_active(&node, genmask);
> +		if (!prev_rbe)
> +			break;
> +
>   		rbe = prev_rbe;
>   
>   		if (nft_rbtree_interval_start(rbe))
> @@ -1083,7 +1107,9 @@ static void nft_rbtree_commit(struct nft_set *set)
>   		if (!node)
>   			break;
>   
> -		prev_rbe = rb_entry(node, struct nft_rbtree_elem, node);
> +		prev_rbe = __nft_rbtree_prev_active(&node, genmask);
> +		if (!prev_rbe)
> +			break;
>   
>   		/* For anonymous sets, when adjacent ranges are found,
>   		 * the end element is not added to the set to pack the set

