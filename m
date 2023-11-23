Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0ABF25776;
	Thu, 23 Nov 2023 13:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PFlOhtzP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE28C433C7;
	Thu, 23 Nov 2023 13:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700747537;
	bh=g72OabfG6ivHttOZUXpkmt1ooH4gEmTwSkz/5QDX3n0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PFlOhtzPVgMD+qAvsS5wVFJkAPNP7RBdgiXO7ixlKHMgaoXoMQZULk9baBMffNVhx
	 eZYhts3t4bqfNXIagChqG4N6+TWsbfBmIKAee1NaRqCKsnOI0Reg5EKj11PJRvvfPc
	 tVL2s1RD0Tu7yKNvssSfIjav691QMC+7EFdbrN7bdEfPMzlDtkJF0NQcLBkfF8jHxv
	 ns+zR/u9tmmiVd5XYIasR/AT9oUQeWjGHxho3m095Iz94NX8mT4KrXu96pGmkrkGcm
	 K31WL9/YfEkTwhS4zrIG8d/YA5HOrTtBFBClTpJCmdnZS69ZSf1ha+XhbcEXQUSRHa
	 eYEFxo5pLluHA==
Date: Thu, 23 Nov 2023 13:52:13 +0000
From: Simon Horman <horms@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, lorenzo@kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 1/8] netfilter: flowtable: move nf_flowtable out
 of container structures
Message-ID: <20231123135213.GE6339@kernel.org>
References: <20231121122800.13521-1-fw@strlen.de>
 <20231121122800.13521-2-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231121122800.13521-2-fw@strlen.de>

On Tue, Nov 21, 2023 at 01:27:44PM +0100, Florian Westphal wrote:
> struct nf_flowtable is currently wholly embedded in either nft_flowtable
> or tcf_ct_flow_table.
> 
> In order to allow flowtable acceleration via XDP, the XDP program will
> need to map struct net_device to struct nf_flowtable.
> 
> To make this work reliably, make a clear separation of the frontend
> (nft, tc) and backend (nf_flowtable) representation.
> 
> In this first patch, amke it so nft_flowtable and tcf_ct_flow_table
> only store pointers to an nf_flowtable structure.
> 
> The main goal is to have follow patches that allow us to keep the
> nf_flowtable structure around for a bit longer (e.g. until after
> an rcu grace period has elapesed) when the frontend(s) are tearing the
> structures down.
> 
> At this time, things are fine, but when xdp programs might be using
> the nf_flowtable structure as well we will need a way to ensure that
> no such users exist anymore.
> 
> Right now there is inufficient guarantee: nftables only ensures
> that the netfilter hooks are unregistered, and tc only ensures the
> tc actions have been removed.
> 
> Any future kfunc might still be called in parallel from an XDP
> program.  The easies way to resolve this is to let the nf_flowtable
> core handle release and module reference counting itself.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

...

> @@ -312,24 +313,29 @@ static int tcf_ct_flow_table_get(struct net *net, struct tcf_ct_params *params)
>  	if (err)
>  		goto err_insert;
>  
> -	ct_ft->nf_ft.type = &flowtable_ct;
> -	ct_ft->nf_ft.flags |= NF_FLOWTABLE_HW_OFFLOAD |
> -			      NF_FLOWTABLE_COUNTER;
> -	err = nf_flow_table_init(&ct_ft->nf_ft);
> +	ct_ft->nf_ft = kzalloc(sizeof(*ct_ft->nf_ft), GFP_KERNEL);
> +	if (!ct_ft->nf_ft)
> +		goto err_alloc;

Hi Florian,

This branch will cause the function to return err, but err is 0 here.
Perhaps it should be set to a negative error value instead?

Flagged by Smatch.

> +
> +	ct_ft->nf_ft->type = &flowtable_ct;
> +	ct_ft->nf_ft->flags |= NF_FLOWTABLE_HW_OFFLOAD |
> +			       NF_FLOWTABLE_COUNTER;
> +	err = nf_flow_table_init(ct_ft->nf_ft);
>  	if (err)
>  		goto err_init;
> -	write_pnet(&ct_ft->nf_ft.net, net);
> +	write_pnet(&ct_ft->nf_ft->net, net);
>  
>  	__module_get(THIS_MODULE);
>  out_unlock:
>  	params->ct_ft = ct_ft;
> -	params->nf_ft = &ct_ft->nf_ft;
> +	params->nf_ft = ct_ft->nf_ft;
>  	mutex_unlock(&zones_mutex);
>  
>  	return 0;
>  
>  err_init:
>  	rhashtable_remove_fast(&zones_ht, &ct_ft->node, zones_params);
> +	kfree(ct_ft->nf_ft);
>  err_insert:
>  	kfree(ct_ft);
>  err_alloc:

...
