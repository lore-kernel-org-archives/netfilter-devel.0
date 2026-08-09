Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D50D220F2D
	for <netfilter-devel@vger.kernel.org>; Sun,  9 Aug 2026 12:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786280314; cv=none; b=pQA1aav7LbHAQ8IWgVYphyKBaEwZUnB/LTAuwO9Y98NjWuj1IWIzjrr9WmTfHcHjXAzawCBEOzCV7NJhcBQySenkFtZn8y4r0l93aD+1tfXqoiWfsIVCeVby5NL9AZQsWP5+GC5bNYm3XM3DRe63I9ZnGrjWRs4OrDw8Jvi80LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786280314; c=relaxed/simple;
	bh=YWDlbev1xpqV9m4df/tPZSC9h6n0GHjphjW2R6ooOps=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=rEB/XrisE8vwL3rP71tHKoPX5yJmvMuMoFn3WuqTqHYjfkOl5qsbJ9picPP4C+zGvCbNHSghr6mIZPYovYDnVpZcQdIDiO3dvt6UTfdOLk8Z+Aqvd5CBMqL1Fqn/WGjSYWCwasoNvF0s/uBTYOn32ASvrxRzDVvDZIQjTQVYRgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4hHycQ2JWzzGFDCM;
	Sun, 09 Aug 2026 14:58:30 +0200 (CEST)
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id pQCpi5gUHAiH; Sun,  9 Aug 2026 14:58:28 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (78-131-74-220.pool.digikabel.hu [78.131.74.220])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp1.kfki.hu (Postfix) with ESMTPSA id 4hHycN0lXyzGFDCJ;
	Sun, 09 Aug 2026 14:58:28 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id D3E3D140E07; Sun,  9 Aug 2026 14:58:27 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id CB144140986;
	Sun,  9 Aug 2026 14:58:27 +0200 (CEST)
Date: Sun, 9 Aug 2026 14:58:27 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Florian Westphal <fw@strlen.de>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: ipset: fix list type element drift bug
In-Reply-To: <20260806135341.8896-1-fw@strlen.de>
Message-ID: <6082ea3a-15d3-650a-98a0-403b1bab7b5d@netfilter.org>
References: <20260806135341.8896-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Thu, 6 Aug 2026, Florian Westphal wrote:

> If list_set_uadd() calls list_set_replace() to swap an expired entry,
> the element count remains the same, therefore the increment must be elided.

Yes, well-spotted!

Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>

> Fixes: 702b71e7c666 ("netfilter: ipset: Add element count to all set types header")
> Link: https://sashiko.dev/#/patchset/20260806101947.2802-1-fw%40strlen.de
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/ipset/ip_set_list_set.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
> index ca3ef9479e83..56626f4943a9 100644
> --- a/net/netfilter/ipset/ip_set_list_set.c
> +++ b/net/netfilter/ipset/ip_set_list_set.c
> @@ -301,8 +301,11 @@ list_set_uadd(struct ip_set *set, void *value, const struct ip_set_ext *ext,
>  	e->set = set;
>  	INIT_LIST_HEAD(&e->list);
>  	list_set_init_extensions(set, ext, e);
> -	if (n)
> +	if (n) {
>  		list_set_replace(set, e, n);
> +		return 0;
> +	}
> +
>  	else if (next)
>  		list_add_tail_rcu(&e->list, &next->list);
>  	else if (prev)
> -- 
> 2.54.0
> 
> 

-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
