Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF6B29AAFA
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Aug 2026 13:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786110647; cv=none; b=cRzCLpI+qSKplI15ecpYYB2XzohM93krYq5rdrcczZ1SMvcHGw4OcEkpD9eeWDEbzCt0aC15DBHEmBcYRv3HiZN77YQE0LgUtLaiIkXkk5nnZPqg83yzai/d8WcPrcqi0CqBS5OZddLRLybocoilaeocAYtajDMKWSdZe8p4NMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786110647; c=relaxed/simple;
	bh=D3qlcQuMiUBE2mCXG8EAiYawakLpRvVhk8i7whABypQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tZGrjeEfUFd0YiLV610LpAFNaKJJpjeg3x9mNCGVQSO8VnjBcpf+/uBeR1nuJ4l59wg8mx1LC7HFLl13/90NjeByKT470CkmZFbbI0+g5mY47k9suD7Jo/1svKwLZpfBSULGUZVTaj/K5VfwyBSPI0fBQ9vWx7sXcVGxoIyE7TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2863D60455; Fri, 07 Aug 2026 15:50:34 +0200 (CEST)
Date: Fri, 7 Aug 2026 15:50:30 +0200
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: [PATCH nf v4] netfilter: ipset: remove need to allocate memory
 on delete operations operations
Message-ID: <anXipjQLvKUmiIYF@strlen.de>
References: <20260807002808.20075-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807002808.20075-1-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> +		write_seqcount_end(&nets->seq);
> +		spin_unlock_bh(&set->lock);
>  	}
>  #endif
>  }
> @@ -1253,31 +1310,41 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
>  #if IPSET_NET_COUNT == 2
>  	struct net_prefixes *nets1;
>  	struct mtype_elem orig = *d;
> +	unsigned int seq1;
>  	int ret, i, j, k;
>  #else
>  	int ret, i, j;
>  #endif
> -	u32 key, multi = 0;
> +	unsigned int seq0;
> +	u32 key, multi;
>  	u8 pos;
>  
>  	pr_debug("test by nets\n");
>  	rcu_read_lock_bh();
> +retry:
> +	multi = 0;
>  	nets0 = rcu_dereference_bh(h->rnets[0]);
> +	seq0 = read_seqcount_begin(&nets0->seq);
[..]
>  unlock:
> +	if (read_seqcount_retry(&nets0->seq, seq0))
> +		goto retry;

Sashiko now says this retry loop causes double-count
on match, yet v3 said not doing this causes possible
miss of a nomatch entry.

I think missing nomatch entry is worse and doublecount
is ok.

The restart is rare enough anyway because write_seqcount_begin()
is only called when set is flushed or a element deletion brings
a cidr count value down to 0.

Another option is to prellocate all possible CIDRs but I'd
like to avoid it, this means checking up to 128 possible CIDRs
in ipv6 case.

Pre-sampling all values into local on-stack array is a non-starter
too due to stack cost.

What one COULD do is to use pcpu stash area for this, needs
local bh / local_lock.

But I think its a bit "too much" for this problem.
