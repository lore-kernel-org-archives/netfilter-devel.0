Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC19C48B37B
	for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2026 14:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779114088; cv=none; b=uT+MiHp+oBFTcYReNnZzoAsmZSprl+ZxXefXXgA8Cl/FrG2Zfgd+A/7uKK+Rn4smtX+Y3bp57s+qbcZT8B2u3QY0/3iap1e8Jr3TzpB3z4UBYJruOGkFaB5VoQac1ntWXpL1ZfmiB9zaSWde7/QONJNFLJG2IxI2/DAgbNB6jrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779114088; c=relaxed/simple;
	bh=ViOooZ5q6HLjbn4PmRfwA6YbFDqGs3bxZJ7jJDAirp4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RPkFkkzf5+iH2QeL5cZNx8s+ziPJyxe72Ba63K0KQSk1XrhvKtFLbUaUvq380NTT0VTCGrChHs7yWWy6G65fiBOvEuTMbrlfu3jP6tXMQW6ZEQOkrENwtrB6d9+aLr9/NsP7qV58M1iLdyMdvqFkO0L3D7oclKfvgb1ZqEp3OJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hpNf0cNi; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hpNf0cNi"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-44e5624c053so1357983f8f.2
        for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2026 07:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779114083; x=1779718883; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EYFr7XXcKEsZj+Bv1UNXpfsZHaxqcET1cNdw3E5KQ6o=;
        b=hpNf0cNigPpXw9DykFa6IzN5idA/nkAFGlX77z4gmiktlupdS+NvYA293YJl/UyhX9
         QVJh0DLrqKNAxMZ1YqiW92drtZZcx8zCwaS4BIysSLKp0R2IshQAbpcLiVhNm6SSRB80
         tHjgNex6fZKg2y2caMDnNx5xlQqEOJLltG+/VHBUf8tHF5WVom4Qp5ORpdguND6ywqCS
         +DiPpp5DVDNRgP6iz+SFa4fwAduZDZKRSKMiOI7TYMYCRFd0xM3k8THTJBSem9u0Hau8
         1ZddxKq98msBx9Gf2+jXNHcxihO+uSH7vyUuKpauUBPl9Z9RosFCkWFuYbqbUfwco+dR
         BCRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779114083; x=1779718883;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EYFr7XXcKEsZj+Bv1UNXpfsZHaxqcET1cNdw3E5KQ6o=;
        b=YGuaEZ5DvSsLRt8o9O24tICI/vlrdGi0kI4Hbb77w8bedM2LL2rmv5LPPJGuJCAmLP
         2TRGtm7Y1yM3dX5Nga8YiGc7wzRVmp43o081hmHdSxwwRzShxAPyEEx0dMpTIZAnR8s0
         mya+9VY6Nu76uXmsJqR2gTmYAz559g0CjKXq6PUY1FmI0kQ9Fq9G91HEXrd/6V/2kms/
         CH/CtAa3gTzn+uMcxWlOqnOKyB4CI/EDKNvIHwG2qa4V/oq3akwGeDHYjjH3gHCpSnoL
         joM+zOU5h6iqSpvT5YATZl/65EfumSS5NXodsoJauxJOglPSmKyZ2ToJ3LW9fDOwHFdq
         nSaA==
X-Forwarded-Encrypted: i=1; AFNElJ9ZOW88wUU97vA2GsA/IQ8HxokfhMoqTtpR4avRafYFDLBM/Vd4lCOerbwHfjNxYOEle6QKu0Gefm0rnidvxDQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTsy3KQjUiSyg9zeZUCppPWCZ4QRTiKUfG2MEb1RMJqsnHDuA7
	81m+W51MymhVHYOPEsx02PLstsVOmv0YaSf5VyDF7xRNylHzrm0ihAit
X-Gm-Gg: Acq92OFlGkmuJ8d/FODpfojz1JAJL1v3PV+NvK1Lvj5ztUTs+T91MLURoew3ojs+1qo
	JqQv/e+uktslmo80pdJcYhP1T3sWqUAccGy/I/BR4SPVo3JkNAixQ9zBF+/8eQrIFpMPd8sVkjD
	wpWrcrCBJG/31gU23TLuIl52xZ4yS4M+KkO3aacoHNWSvnL0fvg/O61OU2wuoOB1CBz0zSy93sF
	kS1sMN+xXbCRZTlZ2Q4U0vBrSBwndicbVUrtgdfP9GQeHxv0OcmwaxDveTuXRokcI+jJ6gN6TZC
	w0tdc1uH4VMBc5kia4DJEkkyoUVXkapbHtOCD16ezmG/E9TGd+kh+aN4OsYNCEPqcCYyKgPUgKu
	HqlNqyAlcsprsV3juuspcEH77syUJL338qM4EhV56WxlxRxDFtJbqa/m9265MlIJZCuzi9czp4D
	ShXfFrvDg0ObVsY6iNz9978PiepxThgF82VajC4EO9FC7FdAi/ihvVgby4QrR4EqO6Qw==
X-Received: by 2002:a05:6000:2083:b0:43e:a9ba:b194 with SMTP id ffacd0b85a97d-45e5c5dd921mr25324601f8f.34.1779114082921;
        Mon, 18 May 2026 07:21:22 -0700 (PDT)
Received: from gmail.com (deskosmtp.auranext.com. [195.134.167.217])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da0a1a22csm36715510f8f.19.2026.05.18.07.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 07:21:22 -0700 (PDT)
Date: Mon, 18 May 2026 16:21:20 +0200
From: Mahe Tardy <mahe.tardy@gmail.com>
To: bot+bpf-ci@kernel.org
Cc: bpf@vger.kernel.org, martin.lau@linux.dev, daniel@iogearbox.net,
	john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org,
	yonghong.song@linux.dev, jordan@jrife.io, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, martin.lau@kernel.org,
	eddyz87@gmail.com, clm@meta.com, ihor.solodrai@linux.dev
Subject: Re: [PATCH bpf-next v6 1/6] net: move netfilter
 nf_reject_fill_skb_dst to core ipv4
Message-ID: <agsgYJsHZzA_0L97@gmail.com>
References: <20260518122842.218522-2-mahe.tardy@gmail.com>
 <af01ada15e1b76da2dfb6cfa749727e0337787f117ddf5724a3cb702513e81dc@mail.kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af01ada15e1b76da2dfb6cfa749727e0337787f117ddf5724a3cb702513e81dc@mail.kernel.org>

On Mon, May 18, 2026 at 01:07:54PM +0000, bot+bpf-ci@kernel.org wrote:
> > diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> > index bc1296f0ea69..1f031c5ef554 100644
> > --- a/net/ipv4/route.c
> > +++ b/net/ipv4/route.c
> > @@ -2945,6 +2945,21 @@ struct rtable *ip_route_output_flow(struct net *net, struct flowi4 *flp4,
> >  }
> >  EXPORT_SYMBOL_GPL(ip_route_output_flow);
> >
> > +int ip_route_reply_fill_dst(struct sk_buff *skb)
> > +{
> > +	struct rtable *rt;
> > +	struct flowi4 fl4 = {
> > +		.daddr = ip_hdr(skb)->saddr
> > +	};
> 
> Can this lead to an out-of-bounds read?
> 
> Now that this is exported for BPF kfuncs, it can be reached from early
> hooks like TC ingress where the IPv4 header might not be linearized yet.
> 
> If a malformed packet contains less than sizeof(struct iphdr) bytes of
> linear data, does accessing ->saddr require validation via pskb_may_pull()
> or similar?
> 
> This concern was raised by sashiko-bot@kernel.org in v4 review:
> https://lore.kernel.org/bpf/20260421111320.D97D9C2BCB0@smtp.kernel.org/

Yes but it should be fine since it's the caller responsability to make
sure the header has been linearized, and we are calling
pskb_network_may_pull.

> > +
> > +	rt = ip_route_output_key(dev_net(skb->dev), &fl4);
> 
> Can skb->dev be NULL here?
> 
> While safe in its original netfilter context, a BPF_PROG_TYPE_NETFILTER
> program attached to the NF_INET_LOCAL_OUT hook will receive locally
> generated SKBs before skb->dev is assigned (e.g., in __ip_local_out before
> ip_output).
> 
> Does dev_net(skb->dev) need a check to prevent a kernel panic when called
> from such contexts?
> 
> This concern was raised by sashiko-bot@kernel.org in v4 review:
> https://lore.kernel.org/bpf/20260421111320.D97D9C2BCB0@smtp.kernel.org/

We can't attach such program as now it's only cgroup_skb and tc,
outdated.

> > +	if (IS_ERR(rt))
> > +		return PTR_ERR(rt);
> > +	skb_dst_set(skb, &rt->dst);
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(ip_route_reply_fill_dst);
> 
> 
> ---
> AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
> See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md
> 
> CI run summary: https://github.com/kernel-patches/bpf/actions/runs/26034287312

