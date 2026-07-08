Received: from mx.ssi.bg (mx.ssi.bg [193.238.174.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94285439333
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2026 15:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.238.174.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783524700; cv=none; b=rHZECGkdXH4pV2yD29Gi60G+5YfVACHIVFsvhQmdLrIbVLWU51GMRFO7CW/WhUNi+0jXWxP65fQZ/F5ttuBWHTeI20aEQ8CBvZ1ZSB9dW57Ayz8RrcXWKiKorGc8hYtQd5c6dNZ1d1U844h5+KL2UuhQoROpY93rq64UK7ASKss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783524700; c=relaxed/simple;
	bh=1naup4kM+BryAZ3N72PUsHjiOXGWpCwD4ogm7TAxqWU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=qPx9cJxkTaYq/Uw86IVVyoMOeJ9Ps4NbY7yRJmutN56tbeU/AXUDGpMAQpN5KzKUYXlgSxL5cgze77grz9Mr/DntzSIVqUeMgL5u2OvvSv0Ia99hCL6RuFH9I40yOgAbdk1zzxlHYifXKeXuBiPRbL/lYybSHn37OY4WCQlH3dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg; spf=pass smtp.mailfrom=ssi.bg; dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b=wM6SEzP2; arc=none smtp.client-ip=193.238.174.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ssi.bg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b="wM6SEzP2"
Received: from mx.ssi.bg (localhost [127.0.0.1])
	by mx.ssi.bg (Potsfix) with ESMTP id E2A6F20252;
	Wed, 08 Jul 2026 18:31:32 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ssi.bg; h=cc:cc
	:content-type:content-type:date:from:from:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=ssi;
	 bh=zNpdPqpr+j919EHEMWCrS7Fps+R6KK9Jbi2PtUAt+KY=; b=wM6SEzP2hbDh
	xtPfkQ4HOMp9OCx6bs+JqGINx2ppeHLa+ROzA/YyL4CdTB9xtJbCfjmpFu6kbdfk
	9zbqEcMcz2UPADfP2iUJCGWdK07WLaAKjFYCo8h25JWcQOXzqrwtCIUtQ23nEnOL
	TQu9x/YdICL/49LSeI812WAKKIS5dOjCgJ8a0uTXzM6OoPBRZTXRcKDFOdp96kf7
	KGXrbLOAO/eX6XyvU60RFgKKTL9Xn1zmd06QM5kjeoHdrb4Va6NET5Z6On5RFv4f
	e4C3dgjZ2M3LdvBYFIGauDgPpUot5qDMhsJzTvH1wLyyTI9Y1EXvpwTCDIaWP2ln
	icsbWT2i597zmd6UA5uvrdb/hWxTT0r9dKmeXIrSPdiUROeMJF770aQCSNNzCjVT
	lVdmCEQsyY8wSCHRdBPFOpD7THdfyPz33qDKJtFYoG72I+wUnMsnci/+zaOPWyOx
	GbUemNFoQAAun+mhXbrt8H5Aaw0MQ2Lz7X267YyuOHFS5W3jeX4uOaevnNr+GYCh
	qIMsgb/zRuhXRXPpgqjgDhssoPd/uSdsr6OKO78CmXVrV3N3yti0EHdjy+qkOk5E
	4X4Nn6Vi1UTsBiVVCgksTLwNzt8B2cW1RVboMyP6qxxb0XzdzJrFm0ymgPNrvLwg
	bnDUqP25h/IiRl2O3wOS311DRv5H6vI=
Received: from box.ssi.bg (box.ssi.bg [193.238.174.46])
	by mx.ssi.bg (Potsfix) with ESMTPS;
	Wed, 08 Jul 2026 18:31:32 +0300 (EEST)
Received: from ja.ssi.bg (unknown [213.16.62.126])
	by box.ssi.bg (Potsfix) with ESMTPSA id 0CD6D61B81;
	Wed,  8 Jul 2026 18:31:32 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by ja.ssi.bg (8.18.2/8.18.2) with ESMTP id 668FVUMS062825;
	Wed, 8 Jul 2026 18:31:30 +0300
Date: Wed, 8 Jul 2026 18:31:30 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
To: Florian Westphal <fw@strlen.de>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] ipvs: reload ip header after head reallocation
In-Reply-To: <20260708142811.2660-1-fw@strlen.de>
Message-ID: <95f5a3bf-ef67-248b-44aa-432376ec1f36@ssi.bg>
References: <20260708142811.2660-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


	Hello,

On Wed, 8 Jul 2026, Florian Westphal wrote:

> __ip_vs_get_out_rt() might realloc skb->head due to ttl decrement.
> 
> Fixes: 8d8e20e2d7bb ("ipvs: Decrement ttl")
> Assisted-by: Claude:claude-sonnet-4-6
> Signed-off-by: Florian Westphal <fw@strlen.de>

	Looks good to me, thanks!

Acked-by: Julian Anastasov <ja@ssi.bg>

> ---
>  LLM assisted find, no real-world bug report behind this.
> 
>  net/netfilter/ipvs/ip_vs_xmit.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
> index ce542ed4b013..9fef4335da13 100644
> --- a/net/netfilter/ipvs/ip_vs_xmit.c
> +++ b/net/netfilter/ipvs/ip_vs_xmit.c
> @@ -736,13 +736,11 @@ int
>  ip_vs_bypass_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
>  		  struct ip_vs_protocol *pp, struct ip_vs_iphdr *ipvsh)
>  {
> -	struct iphdr  *iph = ip_hdr(skb);
> -
> -	if (__ip_vs_get_out_rt(cp->ipvs, cp->af, skb, NULL, iph->daddr,
> +	if (__ip_vs_get_out_rt(cp->ipvs, cp->af, skb, NULL, ip_hdr(skb)->daddr,
>  			       IP_VS_RT_MODE_NON_LOCAL, NULL, ipvsh) < 0)
>  		goto tx_error;
>  
> -	ip_send_check(iph);
> +	ip_send_check(ip_hdr(skb));
>  
>  	/* Another hack: avoid icmp_send in ip_fragment */
>  	skb->ignore_df = 1;
> -- 
> 2.54.0

Regards

--
Julian Anastasov <ja@ssi.bg>

