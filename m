Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1261720E3
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 13:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726147980; cv=none; b=qcLwX5kCoZmvbcgzKi3ou5lfqZZNgwBOf4bWgQKgb9OAu45M4ySQWjZgGGvoM2ENKq9JonbJu1k7jTG+BiUzt3OX5BwTljsmVDOLAndW2cATIKnhdcqm/65gqWIU/bCI7j9C8jh1siCHDtr2sdv330eP9vzpP5unLjbcQ8LMsCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726147980; c=relaxed/simple;
	bh=CAOPbfFORtTpfQ6WxHXPpNLH0LSDMfZTmGIplENNTcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LNmXZP+2Y4ITWFUMY86+Z0OaQR9IHxhHfMXac8WqFWgk2liDzzDhrUuADprAusN5eBhzObp9ucyVwNVcpukDTCDkYOuXj7DFAkNfNwQqdLTbjsCi29KV5yawPOkMbRW5evvBO9s7nSXCy9Mb0H6334z7al9k9heNzV91RYpIZbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sojwN-0001W1-M3; Thu, 12 Sep 2024 15:32:55 +0200
Date: Thu, 12 Sep 2024 15:32:55 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v3 01/16] netfilter: nf_tables: Keep deleted
 flowtable hooks until after RCU
Message-ID: <20240912133255.GB2892@breakpoint.cc>
References: <20240912122148.12159-1-phil@nwl.cc>
 <20240912122148.12159-2-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240912122148.12159-2-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> Documentation of list_del_rcu() warns callers to not immediately free
> the deleted list item. While it seems not necessary to use the
> RCU-variant of list_del() here in the first place, doing so seems to
> require calling kfree_rcu() on the deleted item as well.
> 
> Fixes: 3f0465a9ef02 ("netfilter: nf_tables: dynamically allocate hooks per net_device in flowtables")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  net/netfilter/nf_tables_api.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index b6547fe22bd8..2982f49b6d55 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -9180,7 +9180,7 @@ static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
>  		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
>  					    FLOW_BLOCK_UNBIND);
>  		list_del_rcu(&hook->list);
> -		kfree(hook);
> +		kfree_rcu(hook, rcu);
>  	}
>  	kfree(flowtable->name);
>  	module_put(flowtable->data.type->owner);

AFAICS its safe to use list_del() everywhere, I can't find a single
instance where the hooks are iterated without mutex serialization.

nf_tables_flowtable_destroy() is called after the hook has been
unregisted (detached from nf_hook list) and rcu grace period elapsed.
