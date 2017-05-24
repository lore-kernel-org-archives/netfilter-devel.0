From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 8/9] netfilter: nft_set_hash: add non-resizable
 hashtable implementation
Date: Wed, 24 May 2017 12:14:52 +0200
Message-ID: <20170524101452.GA23010@salvia>
References: <1495619453-22307-1-git-send-email-pablo@netfilter.org>
 <1495619453-22307-9-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58314 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968310AbdEXKPQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 May 2017 06:15:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6A6051EF5E5
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 12:14:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5CDFDA0AAC
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 12:14:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D0146100A46
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 12:14:46 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1495619453-22307-9-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 24, 2017 at 11:50:52AM +0200, Pablo Neira Ayuso wrote:
> +static bool nft_hash_lookup(const struct net *net, const struct nft_set *set,
> +			    const u32 *key, const struct nft_set_ext **ext)
> +{
> +	struct nft_hash *priv = nft_set_priv(set);
> +	u8 genmask = nft_genmask_cur(net);
> +	const struct nft_hash_elem *he;
> +	u32 hash;
> +
> +	hash = jhash(key, set->klen, priv->seed);
> +	hash = reciprocal_scale(hash, priv->buckets);
> +	hlist_for_each_entry(he, &priv->table[hash], node) {

Hm. I just noticed _rcu is missing here and everywhere in this code.
Will send a v2.

> +		if (!memcmp(nft_set_ext_key(&he->ext), key, set->klen) &&
> +		    nft_set_elem_active(&he->ext, genmask)) {
> +			*ext = &he->ext;
> +			return true;
> +		}
> +	}
> +	return false;
> +}
