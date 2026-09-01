Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DB7351C27
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Sep 2026 21:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788299747; cv=none; b=j6QFI+ey8acQJX2eqyoSzatpWBpma7/d3oneiXKoSIXPanJdwNSqKAbwAM1Vb3VuM9uv/chv74vkAEB7CcRi5k8tWp0ZWfWNlRcwnt+ySgOE3sNLOoy2wRpzXkrDX74LlnTKp9hLXakhenyPAM0YSwaFeSBIqM/HGgr+fB283EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788299747; c=relaxed/simple;
	bh=qyjYbO1iAM2QBCqnjIgXvx1xweLuWcGAfcsIfxmx66E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CVaM0bGlk7sybCZW+3FkcU/WT/l9GZm/6yoInvum27mVwWok2H51fLWepAt5KrqgddmPhCYYXPE24LbXw52cbqpCSNx9Za/6mKLbS5iAXu9zqR2yzc3rtzu3/TSaEwNojubhmPFMmlI4acZDzWBusW5OoK7+3NiozSyf8kq8iF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LFpEDwLC; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LFpEDwLC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788299742;
	bh=gwuzn8mAzXuC2W27xXJy3pQm92C4NbHCT0cgzHPofbI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LFpEDwLCwAoicBuFAJUNtvVlJXMquviWd2DnXvt/yrF8xotDYKaj1L04HXRnQ+M5U
	 sHlaW7OBcQ1nEVetatkrKtTf5rfi6xmhRrnu7LzHxhEuFGM6Qm44hOF3bnRPXnKdTK
	 olb8BBWdPNqZtK4ambTNO2EgVpdjm4emyWa4gYWDD8QjTpLVYyMMScNtcB8M9r3UUG
	 4g1/DfVmcqovcCkop1yYkSUndm2poOBaLidd6y3a2hgrWFfAxc8KeFUdlAvsjtgboB
	 lu5aM6C491Rym89vPfQK8dxurIbaeDtqeH70eDeA72Y2qqSnRNeKRtTvJHyBvzm6u+
	 VBbEgkBPtD0RQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id A74616007A;
	Tue,  1 Sep 2026 23:55:42 +0200 (CEST)
Date: Tue, 1 Sep 2026 23:55:39 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: Re: [PATCH nf] netfilter: nf_nat: unregister and release hooks on
 error
Message-ID: <apdJ27G-YYAkr7fa@chamomile>
References: <20260901213519.945074-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260901213519.945074-1-pablo@netfilter.org>

On Tue, Sep 01, 2026 at 11:35:19PM +0200, Pablo Neira Ayuso wrote:
> After the base nat hooks are registered, the first nested nat hook is
> added through nf_hook_entries_insert_raw() and ->users is bumped.
> 
> However, sashiko reports that nf_hook_entries_insert_raw() fails, then
> ->users count remains at zero and nf_nat_unregister_fn() could hit
> WARN_ON() since base nat hooks with no users is unexpected in the
> unregistration path.

Too fast, this is botched. I'll provide v2.

> Fixes: 1cd472bf036c ("netfilter: nf_nat: add nat hook register functions to nf_nat")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_nat_core.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> index 8ac326e1eb5b..71027754b5ab 100644
> --- a/net/netfilter/nf_nat_core.c
> +++ b/net/netfilter/nf_nat_core.c
> @@ -1240,15 +1240,25 @@ int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
>  	nat_ops = nat_proto_net->nat_hook_ops;
>  	priv = nat_ops[hooknum].priv;
>  	if (WARN_ON_ONCE(!priv)) {
> -		mutex_unlock(&nf_nat_proto_mutex);
> -		return -EOPNOTSUPP;
> +		ret = -EOPNOTSUPP;
> +		goto err_out;
>  	}
>  
>  	ret = nf_hook_entries_insert_raw(&priv->entries, ops);
> -	if (ret == 0)
> -		nat_proto_net->users++;
> +	if (ret)
> +		goto err_out;
>  
> +	nat_proto_net->users++;
>  	mutex_unlock(&nf_nat_proto_mutex);
> +
> +	return 0;
> +err_out:
> +	if (nat_proto_net->users == 0) {
> +		nf_unregister_net_hooks(net, nat_ops, ops_count);
> +		mutex_unlock(&nf_nat_proto_mutex);
> +		kfree_rcu(nat_ops, rcu);
> +	}
> +
>  	return ret;
>  }
>  
> -- 
> 2.47.3
> 
> 
