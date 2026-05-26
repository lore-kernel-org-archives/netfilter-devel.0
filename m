Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D179B3B4EB3
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 22:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779832933; cv=none; b=UEsKl6xC4/f2DbJBcZ26quAJzKL62I1vM2uWe9W6AFtbCPmlGqtlrH7gTMayMI4Ba0x29npVKwwjtUSNgcovTFCU8A5MzfptxsnyESXy/zcNVLYhWeMkKMfd/Zuhdvu1jOefxHqK9Pc1REkOjW1+10r0l/14r5Xc/YKM1u6gUz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779832933; c=relaxed/simple;
	bh=2gZSsUwgvpEuu68Nln92VStnzIRxNN9p/M65k1xVsnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FQ9ociKdjL75iJhsgokL8UzpU2p8wlOq2uLyHeCqE9Zvj8/lErtrn8m+JJ5TbAEGnxgL3xX6Lwear8DhKgHXsNDZkCiaXvjAdt/17NTgDGiaCEXF6+G0MFarAbkVOnQiRHkrEvmdNJSEE96GtyIx45juxQk/cfou6NwOIt3MIIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fM/XkBt3; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fM/XkBt3"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-48d146705b4so117060665e9.3
        for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 15:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779832928; x=1780437728; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JONhVJIHBrqEc2wK9dNkb6aggYmrKKMETySXPUvxh4I=;
        b=fM/XkBt3Fon6de/767QzGbY0ucEMKH2u/mfsF7vF6Yw5esO4k2Jz/VRPzPCIt4FQuP
         SRX5nTAHowngJ6rdkmEjOi9iWWc1Rxo9Bo3R/FPoCNq48uwzNA+yzgB8+ZY5J/XAEaW2
         3NlvYyk6U+VacjDM+CVylFYEz1jMAgseQIgoIwjWMlWTYhZPwWcsMBTERfoe5gFUisMQ
         OvgGaRdPxxDPEMQ3ioGPTMxz7AXqBSJFjIkctIzAUERdAB4UTfrhyeBil+//N7OEJTvI
         fbForjLWnvdCcly4sqLhrTj6wZjNyLb89O68AjxznQTXSgRlYRXacGff6noHK5B+qIDG
         DECA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779832928; x=1780437728;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JONhVJIHBrqEc2wK9dNkb6aggYmrKKMETySXPUvxh4I=;
        b=NOp2YgvaxMR9xc3pRiKJ7IzaCeIw8GlSpKNQQB5ai7ajjaRXC65ekO3clGQseEAHaO
         bpJ8RYChER2mYSI401TMizTUQczKQhxKtaoONKtohxDGbJTCjVSdSDD2n55T0VsRBr7w
         P+8Z4eauXuE0tpAJ2f6h40es9pobXcKbeWaaO6pnJ/40jqJTZrQ6fEEnbQFRAg2f43NM
         3NHhpD34wT6miejtopDv8/G1N4J3mt8I8nHqm5yhsMAAh7vxSlipBVSBDPsulpIzUuCT
         RdTN+xIT1D0AOhBmMJXA4077Y33CbNC3R8f1/WW4Be533ENGqiHYGkKYxHIRG3JrWwN2
         xPGw==
X-Forwarded-Encrypted: i=1; AFNElJ9/dMigf/42gtzI8V8sOavxdyiTM+biQ3nnQ5YPzHbaV5BgegnL8Q6IFqKFatthGdzz+uszVmxS3ntYq9gS6IE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzOe6rzvAciFxFenMbhu53Kgy+qjPu96wVEqnexjyQ3vAKAFAg
	UhMxz5TbCD+LN13bh2NEQ2pxOGahGLLPaAh2HzVLIxcB2X7AK6pxdTt+
X-Gm-Gg: Acq92OFC1eXXchJMh/KxtUBdg0vs9UK+014jrNnzWsJT+cP39LojGK0GBx6c5cTjq20
	19MFo7Nb5E3ojbusWblw+J7dQVl/lnmIqloJMbnSpskaA2GnbwyQXkyqSdwot59TqkGuOT65dh7
	gH+IqyXsZMj1srNEw1SfE0bZSUjc9QnpV44kDCFCYgW3OPdgywFkjOqwCROOIkLRHG+7ygsAD4X
	t6Cv+pom90bFvHe82QVWhzOf+DYSyY1LE1Api7E4RvPufaVjJmpGvTIaJrm3z14vr7O24ctKatQ
	mZzsX4oa8rnE1enSaznEYyW109rFEt0L2dsx4BeSZCLPQrj03UcUg+9yw0MoKPprtk8na2XXq5H
	p+oWoeMJejCUAyXw0mRIeOBHZIOGRAYabHalgCNy83FwfWPKWmWeMb/NTv1nlyC1GpD2rCwSSPN
	/dabjycY75YHIIaVq+mvNXnToHBP2QxArrBsN9zW4=
X-Received: by 2002:a05:600c:a49:b0:490:6889:202 with SMTP id 5b1f17b1804b1-4906889026emr157273705e9.29.1779832927993;
        Tue, 26 May 2026 15:02:07 -0700 (PDT)
Received: from gmail.com ([2a01:e0a:488:3510:15a1:dbd2:86bb:c4e9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490452765f5sm367234965e9.5.2026.05.26.15.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 15:02:06 -0700 (PDT)
Date: Wed, 27 May 2026 00:02:00 +0200
From: Mahe Tardy <mahe.tardy@gmail.com>
To: bot+bpf-ci@kernel.org
Cc: bpf@vger.kernel.org, martin.lau@linux.dev, daniel@iogearbox.net,
	john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org,
	yonghong.song@linux.dev, jordan@jrife.io, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, martin.lau@kernel.org,
	eddyz87@gmail.com, clm@meta.com, ihor.solodrai@linux.dev
Subject: Re: [PATCH bpf-next v7 2/7] net: move netfilter
 nf_reject6_fill_skb_dst to core ipv6
Message-ID: <ahYYWIitPa7zlnSK@gmail.com>
References: <20260526153708.279717-3-mahe.tardy@gmail.com>
 <44848566ea55c9974065bd2aad211662a7b319452ecbc6e2f6cc942cb5b4e8d6@mail.kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44848566ea55c9974065bd2aad211662a7b319452ecbc6e2f6cc942cb5b4e8d6@mail.kernel.org>

On Tue, May 26, 2026 at 04:20:14PM +0000, bot+bpf-ci@kernel.org wrote:
> > diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
> > index 09ffe0f13ce7..eb5a60d3babe 100644
> > --- a/include/net/ip6_route.h
> > +++ b/include/net/ip6_route.h
> > @@ -100,6 +100,8 @@ static inline struct dst_entry *ip6_route_output(struct net *net,
> >  	return ip6_route_output_flags(net, sk, fl6, 0);
> >  }
> >
> > +int ip6_route_reply_fill_dst(struct sk_buff *skb);
> > +
> >  /* Only conditionally release dst if flags indicates
> >   * !RT6_LOOKUP_F_DST_NOREF or dst is in uncached_list.
> >   */
> 
> [ ... ]
> 
> > diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> > index b106e5fef9cb..e72065aa5f5a 100644
> > --- a/net/ipv6/route.c
> > +++ b/net/ipv6/route.c
> > @@ -2725,6 +2725,24 @@ struct dst_entry *ip6_route_output_flags(struct net *net,
> >  }
> >  EXPORT_SYMBOL_GPL(ip6_route_output_flags);
> >
> > +int ip6_route_reply_fill_dst(struct sk_buff *skb)
> > +{
> > +	struct dst_entry *result;
> > +	struct flowi6 fl = {
> > +		.daddr = ipv6_hdr(skb)->saddr
> > +	};
> 
> Could ipv6_hdr(skb)->saddr read out-of-bounds memory if the IPv6 header
> spans paged fragments?
> 
> Since this function is exported as EXPORT_SYMBOL_GPL for use by BPF kfuncs,
> it might be called on packets where the header isn't guaranteed to be in
> the linear data area. If there are no linearization checks like
> pskb_may_pull() before accessing ipv6_hdr(), this could read out-of-bounds
> memory or cause a page fault when processing undersized or fragmented
> packets supplied by BPF programs.
> 
> The v6 cover letter mentions "call pskb_network_may_pull on the cloned
> pkt", but this linearization check is not present in this function.
> 
> While the netfilter caller (nf_send_unreach6) may ensure the header is
> linearized, the exported function itself doesn't validate this condition.
> 
> Reference: https://lore.kernel.org/bpf/1637d7e04ac3c65239ef77709175697bff287250913d1da68e8d4072e0ff34e1@mail.kernel.org/

This is the same remark as on IPv4 on which I already responded, I don't
think that's an actual issue.

> 
> > +	int err;
> > +
> > +	result = ip6_route_output(dev_net(skb->dev), NULL, &fl);
> 
> Can skb->dev be NULL in contexts where this function will be used?
> 
> Since this function is exported as EXPORT_SYMBOL_GPL for use by BPF
> kfuncs, it might be called from program types where the device reference
> is not retained, such as socket filters or tc ingress before device
> assignment. If skb->dev is NULL in these contexts, dev_net(skb->dev)
> would cause a NULL pointer dereference.
> 
> While the netfilter caller (nf_send_unreach6) checks and sets skb->dev
> to loopback_dev if NULL, the exported function itself does not have this
> protection.
> 
> Reference: https://lore.kernel.org/bpf/20260421111321.94393C2BCB0@smtp.kernel.org/

Dito.

> 
> > +	err = result->error;
> > +	if (err)
> > +		dst_release(result);
> > +	else
> > +		skb_dst_set(skb, result);
> > +	return err;
> > +}
> > +EXPORT_SYMBOL_GPL(ip6_route_reply_fill_dst);
> > +
> >  struct dst_entry *ip6_blackhole_route(struct net *net, struct dst_entry *dst_orig)
> >  {
> >  	struct rt6_info *rt, *ort = dst_rt6_info(dst_orig);
> 
> 
> ---
> AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
> See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md
> 
> CI run summary: https://github.com/kernel-patches/bpf/actions/runs/26459248718

