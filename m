Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3D944998C
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jul 2026 07:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783669532; cv=none; b=TI3yvA6so720HyhdugT3XLDdBCEOrjNgiJuFko/qZcGpPl31uAL7ed4zbjoVSgQT1Vs70/pu/23SDrSYkA6CRlopsiSpJ8KoxBJ4vtZzIjtBGa/it84J4Tis9NNOv61Be2Ax2tsT+LZUs7gpY4BP2JZ3AfaXTLsh8S7KJ8Md9IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783669532; c=relaxed/simple;
	bh=tYvv6GaYa/1T9nOw4sz6htArtzUT9XKn36fNOOwu7/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=apiEwgKEiV7aW1vVnRLOYfuQVnbcUq0wUG1LBjvelkR+f/tdddqMNMIGh0Fmm4irihUo7Egb+bFe53k4MnK4UVAmShahSdTaky+aGjn8AxFSvoUjuCcoy9mQP8+Ktlwoe8/S6tYFS0uEmX5HyFCcyLAiTejxJ/31hfURVCttmSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cIPo8aQL; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cIPo8aQL"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 9FEE860576;
	Fri, 10 Jul 2026 09:45:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783669527;
	bh=sAYbvaln1HmLru5+IUkvYftfvrukdxr7mE0e0V9wMBo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cIPo8aQLIzzJ+6kikkCM0n5ZSQtP1ZL/xIIOd3eEbejs7/ig8ZCJ8O76cnYYhppel
	 +uIKe7p0u1CwrDTNAqAFPO7hXp7Y1vtYkMjKc0/vQtvecmcYe3m9lF0lekeK5IFwf7
	 QKh9epkHoaQ2qTI0H3+GR8RL0KsGHDXThvbAyPOhoigpgnDbOhFc2T1ji94Z4NcQXJ
	 GjihiZHHQK7vZQjS1+xIZct0r1RyCkBwHmi+JGeSrangZwwoNtZIG1WsVrkmHR9kQS
	 SRpyZEVQOkcVBQ27JguMDwnENsLb8SFQkunVMRMNzq2QHFPZMxj5bO1oKBEhFmCci4
	 WamMQONBD5nag==
Date: Fri, 10 Jul 2026 09:45:24 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: anzaki@gmail.com
Subject: Re: [PATCH nf-next] netfilter: flowtable: tear down flow entries
 with stale dst from GC
Message-ID: <alCjFNcjbTZpibjv@chamomile>
References: <20260710073610.1352167-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260710073610.1352167-1-pablo@netfilter.org>

On Fri, Jul 10, 2026 at 09:36:10AM +0200, Pablo Neira Ayuso wrote:
> In case of route updates, tear down flow entries with stale dst to give
> them a chance to obtain a fresh route.
> 
> This is specifically useful for hardware offloaded entries, where the
> flowtable software dataplane sees no packet, where the existing check
> for stale dst entries does not help.

Scratch this, I posted the wrong patch. Sending a v2.

> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_flow_table_core.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 99c5b9d671a0..61ab27de79fa 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -561,6 +561,14 @@ static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
>  	nf_ct_put(ct);
>  }
>  
> +static bool nf_flow_check_dst(struct flow_offload *flow,
> +			      enum flow_offload_tuple_dir dir)
> +{
> +	struct flow_offload_tuple *tuple = &flow->tuplehash[dir].tuple;
> +
> +	return tuple->dst_cache && dst_check(tuple->dst_cache, tuple->dst_cookie);
> +}
> +
>  static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
>  				    struct flow_offload *flow, void *data)
>  {
> @@ -568,6 +576,8 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
>  
>  	if (nf_flow_has_expired(flow) ||
>  	    nf_ct_is_dying(flow->ct) ||
> +	    nf_flow_check_dst(flow, FLOW_OFFLOAD_DIR_ORIGINAL) ||
> +	    nf_flow_check_dst(flow, FLOW_OFFLOAD_DIR_REPLY) ||
>  	    nf_flow_custom_gc(flow_table, flow)) {
>  		flow_offload_teardown(flow);
>  		teardown = true;
> -- 
> 2.47.3
> 
> 
