Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2743A168B
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 13:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776690302; cv=none; b=sUGWvzZQbxmrcJn3akhIPNIyMPyeouOIiDWsqVpABnQ0hW1lnxJA9zFJpm4a35k+yC7Lk7VpwibvBw0AAoX7XRTJKhanELkL/FeOVp2Kh622gSWEOSHCFsSLEDA4ZYjtmAF8N6Hz3054zh8kbYt0KQuqso6U0PAKiCg5A4tD5Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776690302; c=relaxed/simple;
	bh=fVzxhqZXK6Qwiio7PBsf0pdv4mmkoZ3a6cA74QPhfCQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mKfLeTxuFbG+/6iEV34k/YXAfYK7JJAhPFIFkpIfFM6HrIu57JyxMRyY+i9NZmceBEesl0oWWbKPO8Ar2TacfXeCRKjIslImykz4H+QlCkkd6kTo9Qxxk5ilsknfkH5uSlcYssmzqBZtqtEfCwLVZGS3K08YTw8WTOWgwkkiRJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rnMPR1IF; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rnMPR1IF"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-488b3f8fa2bso35206815e9.1
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 06:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776690295; x=1777295095; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mZ7NBcfywwnvJcmvihRMyw1jnkfoOgzM6bLzAxo7IkU=;
        b=rnMPR1IF9vK5oPLN0KOk3F6mca9FlkG3A4z5HzcQT8CTMBENTiFHCZvoYHD3gNNSQ4
         zKSqnWQc/zebYxSFfsWmSxHRwwix3jwuIjrtzvuFUR8qSqFstCmfGb9HZ6bIWe1G9qWH
         OyOjKt2iU95uHym1c5f/P6E0yV1UJDtps4TY6xx9VQAWmxn82CGFVQ5/8xR5l+VFWOxJ
         xdje+fnm3U+O6/ZrFpGHJ1Jh99NLRVE8Dz+WNoPdog6tijS2ItP0p9Xpfk218PbcRPG/
         E7jmhledcZFKP9dOLvkUrvm3CbHs3TgImmCswWr6zi3M2Thdq6ZUoLVDEqT262QwGSha
         k19Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776690295; x=1777295095;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mZ7NBcfywwnvJcmvihRMyw1jnkfoOgzM6bLzAxo7IkU=;
        b=Hc+gWcoeRovOu6ZjjcHmjSjQrB3ojE6OZeql1QfBsDZ2amFPkei71GgvsxM9O61APM
         OrfdYq+O92ZYy3z43Xbp4IOUCNU25mklgvaY9WPbboFNecaba+GQ2OEG73aNp8QHY+uP
         Kpo5L+oYSGKa+cf8Ueih7eXE4KgRln2daFrwVIf5ktNtwocWH4bBZiEHrz0TPLE1BALN
         pJCGOirzK+luMDcMEczTAm9ipgoxfxta/NqB2P8+c9Axj3luqKevb4Osahog1QgXj0GU
         CbdCAIPwkIYJya3t89DvewlNMmRTAT0DoqZh31p3FVE9csNdC4WBeNjO/KURUrowoddm
         QHcw==
X-Forwarded-Encrypted: i=1; AFNElJ8zDiHgQaqh+XS+yOjXOwUS9lThSctKzq2OU8QzCK3BBBigZe6xuEIdNjgqxJaAAEuInyDyTaj4lSXqkkzmbhI=@vger.kernel.org
X-Gm-Message-State: AOJu0YySwJ+Kz5yIT2ogaNQ3o29EaqwNDQBwvPCK/JBVVpg0miHNgqCP
	KiuxqroSewaYBUqpZ9Jy04d9+jH2wKwKV3KoSLJ8kj0/0pf90cRHQImxt3OBmm9SzbZfdw==
X-Gm-Gg: AeBDiethiAIHdxE88fewHUJXlFZV7x51jdmbFkYxls9aDRy7wirbgSgUjP55mie8DXu
	+RosFQFSItCHVJaB3Kep5IP3vDIWmLJU4FuWkX9SsdXc91UHAEZiOEVcptP4qT9PyRZbxMRVkdp
	WgHR8we0q3TN5OpomaCv9EBNa+9oSpCWP8ZJGfiYHme3cEsC/L0FHzN3X+N7o9BumnH3/JDj6XP
	XVPbVA7OGKyNuB8GwL00Jf+dWWAJJ/CFg60FpAlTRA1Sgtgra0uMOOkhEY0WhEAFbKlc52V77vO
	D69MaFaHiSTMETXK0+o50cxgo6KF1r/Ds4k1I2OdfGosxfsJc79r1WlOk7+syd4eQO9ndCasEVk
	LD3A1sP+/edbUKrgRU2SNi8/ohdzliGuvDfO9M2VeuAdj4yK+IsBDwwMwKucIhX/Z5goitULw2n
	CAiah1LIgJMbZt3Ne4KWp36EDEJYtr/HAb3SQU/2CGRkuwmOXIyjAaTklvTWoCbwZGDg==
X-Received: by 2002:a05:600c:b96:b0:48a:5339:a46 with SMTP id 5b1f17b1804b1-48a53390f6cmr9778795e9.9.1776690295193;
        Mon, 20 Apr 2026 06:04:55 -0700 (PDT)
Received: from gmail.com (deskosmtp.auranext.com. [195.134.167.217])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc140c82sm262361005e9.12.2026.04.20.06.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 06:04:54 -0700 (PDT)
Date: Mon, 20 Apr 2026 15:04:52 +0200
From: Mahe Tardy <mahe.tardy@gmail.com>
To: bot+bpf-ci@kernel.org
Cc: alexei.starovoitov@gmail.com, andrii@kernel.org, ast@kernel.org,
	bpf@vger.kernel.org, coreteam@netfilter.org, daniel@iogearbox.net,
	fw@strlen.de, john.fastabend@gmail.com, lkp@intel.com,
	martin.lau@linux.dev, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, oe-kbuild-all@lists.linux.dev,
	pablo@netfilter.org, martin.lau@kernel.org, eddyz87@gmail.com,
	yonghong.song@linux.dev, clm@meta.com, ihor.solodrai@linux.dev
Subject: Re: [PATCH bpf-next v4 1/6] net: move netfilter
 nf_reject_fill_skb_dst to core ipv4
Message-ID: <aeYkdKm7B4NQ3BDo@gmail.com>
References: <20260420105816.72168-2-mahe.tardy@gmail.com>
 <c0aa7f264055f44ac4c93aa4718473e89ed13b8bb11de3179ed40d2f88a99257@mail.kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0aa7f264055f44ac4c93aa4718473e89ed13b8bb11de3179ed40d2f88a99257@mail.kernel.org>

On Mon, Apr 20, 2026 at 11:36:12AM +0000, bot+bpf-ci@kernel.org wrote:
> > diff --git a/include/net/route.h b/include/net/route.h
> > index f90106f383c5..ec2466fd0bec 100644
> > --- a/include/net/route.h
> > +++ b/include/net/route.h
> > @@ -173,6 +173,7 @@ struct rtable *ip_route_output_flow(struct net *, struct flowi4 *flp,
> >  				    const struct sock *sk);
> >  struct dst_entry *ipv4_blackhole_route(struct net *net,
> >  				       struct dst_entry *dst_orig);
> > +int ip_route_reply_fetch_dst(struct sk_buff *skb);
> >
> >  static inline struct rtable *ip_route_output_key(struct net *net, struct flowi4 *flp)
> >  {
> 
> [ ... ]
> 
> > diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> > index bc1296f0ea69..7091ef936073 100644
> > --- a/net/ipv4/route.c
> > +++ b/net/ipv4/route.c
> > @@ -2945,6 +2945,21 @@ struct rtable *ip_route_output_flow(struct net *net, struct flowi4 *flp4,
> >  }
> >  EXPORT_SYMBOL_GPL(ip_route_output_flow);
> >
> > +int ip_route_reply_fetch_dst(struct sk_buff *skb)
> > +{
> > +	struct rtable *rt;
> > +	struct flowi4 fl4 = {
> > +		.daddr = ip_hdr(skb)->saddr
> > +	};
> > +
> > +	rt = ip_route_output_key(dev_net(skb->dev), &fl4);
> > +	if (IS_ERR(rt))
> > +		return PTR_ERR(rt);
> > +	skb_dst_set(skb, &rt->dst);
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(ip_route_reply_fetch_dst);
> 
> Is ip_route_reply_fetch_dst() actually needed before calling icmp_send()?
> 
> Martin KaFai Lau raised this question in v3 of the patch series and
> noted that icmpv6_send() does its own route lookup and doesn't use
> skb_dst() of the original skb. He also pointed out that at
> cgroup/egress, skb->_skb_refdst should already be set.
> 
> Looking at icmpv6_send(), the fl6.{daddr,saddr} are filled and passed
> to icmpv6_route_lookup, which performs the reverse/invert route lookup.
> The function doesn't appear to use skb_dst() of the original skb.
> 
> Since this patch moves ip_route_reply_fetch_dst() from netfilter to
> core specifically for the BPF kfunc, can you clarify why this routing
> step is necessary? Does the kfunc not work without
> ip[6]_route_reply_fetch_dst()?
> 
> Reference: https://lore.kernel.org/bpf/df4b0996-3e88-4ea4-983b-82866455a6fc@linux.dev/

Yes I replied to this in the cover letter, let me quote it:

Initially, this kfunc was added only to cgroup_skb programs, Alexei
suggested not creating its own kfunc set and adding it to the more
global bpf_kfunc_set_skb. Now that recursion is handled and I realized,
thanks to Martin, that fetching the dst route might be only useful in
situation in which the packet was not yet routed, I decided to extend
the kfunc to more program types and route the packet only if needed.

So in short, if we decide to go back to cgroup_skb only, we can remove
this, if we expand to other program types like we do, it still makes
sense to do it.

> 
> 
> ---
> AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
> See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md
> 
> CI run summary: https://github.com/kernel-patches/bpf/actions/runs/24663313503

