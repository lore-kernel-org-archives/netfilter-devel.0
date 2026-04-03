Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B53F3A16A1
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Apr 2026 14:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775224972; cv=none; b=p34nGGbimR/E2/a4PaynSTjsG4x/nXW5k6DYl7jiC4wPmuHju5evOaNlLeE9tYErbknQ5NWGVDDF+7NvYpGMIlpBpFLb+TvSmkg2YiSijnjvfW0QaUlIblh0H9poRHxBVGC+79rLxOP5z4NcP/6T+cGdb/8+dnYKg12B91fUBtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775224972; c=relaxed/simple;
	bh=Vn/Ft5V/Ag9AZC/Vhc+z2Q8am5/l7wN+gS54LfRTZtc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nRDFNgyQO7yS2G9tDvkstgfGvOVhadzs3nKLgBEff4FzgDEdVPBn8IOLGudggGtu6x7wem3PR3TzAENhGi8OX9LXGrXiCZkVy2hwtHgbtuPllYj+84dktk7HoN0TKmv9QXjXPa5B4+39K0hXwI+RFxGf6JtF8ZoewKlXZFfYlec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cD3RJNFl; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cD3RJNFl"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 20D0560253;
	Fri,  3 Apr 2026 16:02:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1775224968;
	bh=M40QkbEubt89bq6MU9/OJ7e7aB2WkoaDnEG7eVT5cDk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cD3RJNFlyaQBs1M4UIG/vxABNdq8dMtJvkwSgbJfarfpRG+QBq/959gbyKUwvllW7
	 Nu/unH7YcC/tL+JBl5ifyzBGvB82Yo4M2/jKbnOXaCT7uxHPt1FSYIrHwDGOxwN70h
	 N/oDHT9xjZj72EVKxUEXSLA1E9Le+k5Uvlxj14wxZm9yBri7JkABuKeDSHmG/Fq4SJ
	 gsurUjj33upRjkhpYkZY9to1iZcXJYHtGgerCfuHbTsEUXOf3yb7z3IjdTnhsQ+Iah
	 TzeICtLT9soUcyfISTwQi0IVZ8xO7IamH0uFtEw11LcTbkXY+a52GAMJ79yCGc7WZ0
	 WDL/Dqa/O2vrg==
Date: Fri, 3 Apr 2026 16:02:45 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Scott Mitchell <scott.k.mitch1@gmail.com>,
	netfilter-devel@vger.kernel.org
Subject: Re: nfnetlink_queue crashes kernel
Message-ID: <ac_IheNLTM2crhl3@lemonverbena>
References: <ac-w6e33txkgTRJj@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ac-w6e33txkgTRJj@strlen.de>

On Fri, Apr 03, 2026 at 02:22:01PM +0200, Florian Westphal wrote:
> Hello,
> 
> nfnetlink_queue is currently broken in at least two ways.
> 1). kernel will crash under pressure because
>     struct nf_queue_entry is freed via kfree, but parallel
>     cpu can still observe this while walking the (global) rhashtable.
> 
> 2) a4400a5b343d ("netfilter: nfnetlink_queue: nfqnl_instance GFP_ATOMIC -> GFP_KERNEL_ACCOUNT allocation") should have updated the spinlock to use the _bh variant, if the queue exists we risk deadlock via softirq recursion.
> 
> Minimal fix, that I am not a fan of:
> 
> diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
> --- a/include/net/netfilter/nf_queue.h
> +++ b/include/net/netfilter/nf_queue.h
> @@ -24,6 +24,7 @@ struct nf_queue_entry {
>  	bool			nf_ct_is_unconfirmed;
>  	u16			size; /* sizeof(entry) + saved route keys */
>  	u16			queue_num;
> +	struct rcu_head		head;
>  
>  	/* extra space to store route keys */
>  };
> diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
> index 7f12e56e6e52..385d1fe704ae 100644
> --- a/net/netfilter/nf_queue.c
> +++ b/net/netfilter/nf_queue.c
> @@ -74,7 +74,7 @@ static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
>  void nf_queue_entry_free(struct nf_queue_entry *entry)
>  {
>  	nf_queue_entry_release_refs(entry);
> -	kfree(entry);
> +	kfree_rcu(entry, head);
>  }
>  EXPORT_SYMBOL_GPL(nf_queue_entry_free);
>  
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index 47f7f62906e2..fc44ea4e5128 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -190,7 +190,7 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
>  	spin_lock_init(&inst->lock);
>  	INIT_LIST_HEAD(&inst->queue_list);
>  
> -	spin_lock(&q->instances_lock);
> +	spin_lock_bh(&q->instances_lock);
>  	if (instance_lookup(q, queue_num)) {
>  		err = -EEXIST;
>  		goto out_unlock;
> @@ -204,7 +204,7 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
>  	h = instance_hashfn(queue_num);
>  	hlist_add_head_rcu(&inst->hlist, &q->instance_table[h]);
>  
> -	spin_unlock(&q->instances_lock);
> +	spin_unlock_bh(&q->instances_lock);
>  
>  	return inst;
>  
> 
> 
> 
> A probably better fix is to make the rhashtable perqueue, which is
> much more intrusive at this late stage.
> 
> I prefer to revert both changes and not accept a reworked hashtable
> until we have an extension to nft_queue.sh selftest.

+1, then take a bit more time to get this right.
