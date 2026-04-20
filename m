Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625B43A1681
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 13:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776690450; cv=none; b=Xy2yu+y7CfsYVC57uMDmIPhHsyfxK973Cy+AdjbecuL2+4BNIIQlMbWqHtwskgDhxsl6Y0mKOS9FC3RNR45O3WgBALKC8AFocbgz6gLAzcvls+qop0G23++V+g8Bz2sZrtx+YzQGdKS1b4+5bRHtAslmKJUBtZz+r1Y6GbjbgyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776690450; c=relaxed/simple;
	bh=JLX0QIE+ZaB7zS+4hzCYPPCnUIvUgu+mL5VLldlw4/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XYG8lQ+MbNgMRG+h6IXtrtBNstrKWk8kLCGSSkWnXQT4Vwvw83JUzi9JMGyKd+JUrf6nRAH8H2IbKnF+vTYmuZQJ3mOreHKTgqrHPm+HKOaaSd2UGfJJZRDb87ukqFPL5leWPdrlJ+1si6OxMhGuBn3ysn7aZNGDwcXDcQhc/QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZmsK9UBN; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZmsK9UBN"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-43d7badbd7dso1405172f8f.2
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 06:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776690445; x=1777295245; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/Ag56mmJk7Zmpm+f5Y09lyaEBE2YSArv7z93rWOQIdM=;
        b=ZmsK9UBNEhonMgwHlY7RquBbKesfSJLglYPS0BN5a/HFrZzYxe+8PuUh4/t3/GwDeG
         U2qXfV2DGAdQ5k+/6c6Cybp+rK8OKQWgXh5BjCPE2zIJ5JvEaIkXBjnovWB07due+OX6
         NQLsFmQeK3JRKi1Ok6+GqM5H+45fahWB82mdzIEliC2MwqpOzttmvim3XoG7yuzvsc4o
         WKCR28PLeNN0Jwvh/wW/L0/x9jY3C3bOFmhToRREM1MP0hoE0GMO1uGjH2E7RGmLn87T
         H2SbmU7TH30b1nFfPyu/IgVr2MD32U7aycsE8+aMVCUDxgfiIY9FCWyiWIDzAh+XmG3N
         iowg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776690445; x=1777295245;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Ag56mmJk7Zmpm+f5Y09lyaEBE2YSArv7z93rWOQIdM=;
        b=gUICqXyaOvIKt5bpJ89Zu86+Jn6TGmfllU0R5VhbNIBvmSOUfzNwr3Msm2rqpk7lAN
         u1j8aCyoUrZWs0ZI4fKSk3hexFVpmyH+VTs1l4ZqwQgl4zoC4RsOM5k25f2tbXfpf5ov
         S1xzSmr7J1Z1KcE3oZU83uX//fdR2UvMHk/JkXmnUpt2WqvdSG7KKpnY6oAmhlTIluVT
         fMTG7Ll6GHRKTOht+HAOs2CXiD/BGpcHDy+1Y2Z8Atue0y/OL5cjW6FuTMyPPYrJYJaX
         bwmu3d0lQeWd3I2dfoJtt99jt5oB/SMwIQ6jNnSEZ1rOyRCQe8s/KSJbXkf4W0kbydpn
         V1Vg==
X-Forwarded-Encrypted: i=1; AFNElJ85k+xRjeVyrHLjzr63NF17yg3Vm13thcsBD/h0bjDqIV3tFrZfU+AHSONlQPSYORVulPFOMKT7ajh1nYLIKkk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6UCXm6e1oi7KEj2/5cgqIuRZMyj6iVFSGIQfiRuzcQS+r7NfY
	eu9B9Blz2n8dYpkIIx6A0NdrB4hMibr0HiZGinZBZGCl11SJDtL9r25w
X-Gm-Gg: AeBDieuB1KkABJh12EL8Ad5HHV2HK9ySYuda1fT50Huri1Z0X5jXWJb1oTY6nyVIsHy
	pC27drGHG2XwyO0z+RpiBS7o8E5nx4jx52vNkq2qFFAXGb+I23Zds2zeim8+zV1+rzPnD90wHys
	IgBC6gjp9if5s7vXiVauApxym0m5QZjsBU2kERTzX63vY4/6lYNxfpUkSMeix1lnWtr9EZ+RWU7
	Lf0g57+VmF2hMJxYOW6MLfaz5g4VCdIUSG/kZXiVDHDX/ZbH2UaHMPWtxJzHGCx6lXCM5tiAj+M
	MeiVdTh8vTs1vGLa858wXt//gQOtXtCJsf9JMKg/5dw7p+HRDSGQkmFVA2yw9rFSNVjP6rtJtdu
	KnrqU0Xo5Mh8vA3C0tm5dtfhkk3wzHFjlFR9PDqaZIKMpbtNqDZRZ4mi9NSYm+1muA8AH8epAA9
	5lVK4/6q1WBPM2TnAKLgbcXSwoqvKJwSY4uo2KkLxW+zFge4MF8TvKHBRFp2mgqI0pCw==
X-Received: by 2002:a05:6000:4203:b0:43d:242:b9bb with SMTP id ffacd0b85a97d-43fe3dc5c80mr20542019f8f.18.1776690445002;
        Mon, 20 Apr 2026 06:07:25 -0700 (PDT)
Received: from gmail.com (deskosmtp.auranext.com. [195.134.167.217])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e4d525sm28070324f8f.31.2026.04.20.06.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 06:07:24 -0700 (PDT)
Date: Mon, 20 Apr 2026 15:07:22 +0200
From: Mahe Tardy <mahe.tardy@gmail.com>
To: bot+bpf-ci@kernel.org
Cc: alexei.starovoitov@gmail.com, andrii@kernel.org, ast@kernel.org,
	bpf@vger.kernel.org, coreteam@netfilter.org, daniel@iogearbox.net,
	fw@strlen.de, john.fastabend@gmail.com, lkp@intel.com,
	martin.lau@linux.dev, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, oe-kbuild-all@lists.linux.dev,
	pablo@netfilter.org, martin.lau@kernel.org, eddyz87@gmail.com,
	yonghong.song@linux.dev, clm@meta.com, ihor.solodrai@linux.dev
Subject: Re: [PATCH bpf-next v4 3/6] bpf: add bpf_icmp_send_unreach kfunc
Message-ID: <aeYlCswvGdTHiAFp@gmail.com>
References: <20260420105816.72168-4-mahe.tardy@gmail.com>
 <c706a726c2e82dfc6162f96d7c04313301c24d1a4e36af5c421fda7a1c01b1a1@mail.kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c706a726c2e82dfc6162f96d7c04313301c24d1a4e36af5c421fda7a1c01b1a1@mail.kernel.org>

On Mon, Apr 20, 2026 at 11:36:15AM +0000, bot+bpf-ci@kernel.org wrote:
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> 
> [ ... ]
> 
> > +#if IS_ENABLED(CONFIG_IPV6)
> > +	case htons(ETH_P_IPV6):
> > +		if (code < 0 || code > ICMPV6_REJECT_ROUTE)
> > +			return -EINVAL;
> > +
> > +		nskb = skb_clone(skb, GFP_ATOMIC);
> > +		if (!nskb)
> > +			return -ENOMEM;
> > +
> > +		if (!skb_dst(nskb) && ip6_route_reply_fetch_dst(nskb) < 0) {
> > +			kfree_skb(nskb);
> > +			return -EHOSTUNREACH;
> > +		}
> 
> Is the route lookup needed here? Looking at icmpv6_send() in
> net/ipv6/icmp.c, it fills fl6.{daddr,saddr} and passes them to
> icmpv6_route_lookup() which performs its own route lookup. The function
> doesn't appear to use skb_dst() from the original skb:
> 
> icmpv6_send() {
>     ...
>     fl6.daddr = hdr->saddr;
>     fl6.saddr = saddr;
>     ...
>     dst = icmpv6_route_lookup(net, skb, sk, &fl6);
>     ...
> }
> 
> The same applies to the IPv4 path with icmp_send(). Additionally, at
> cgroup/egress the skb->_skb_refdst should already be set, and the same
> should be true for cgroup/ingress for inet proto.
> 
> Does the kfunc work without ip_route_reply_fetch_dst() and
> ip6_route_reply_fetch_dst()? If so, can these calls be removed?
> 
> Reference: Martin KaFai Lau's comment in v3 review
> https://lore.kernel.org/bpf/df4b0996-3e88-4ea4-983b-82866455a6fc@linux.dev/

Same reply as https://lore.kernel.org/bpf/aeYkdKm7B4NQ3BDo@gmail.com/,
too bad the LLM can't access the cover letter.

> 
> > +
> > +		*in_progress = true;
> > +		icmpv6_send(nskb, ICMPV6_DEST_UNREACH, code, 0);
> > +		*in_progress = false;
> > +		kfree_skb(nskb);
> > +		break;
> > +#endif
> > +	default:
> > +		return -EPROTONOSUPPORT;
> > +	}
> > +
> > +	return 0;
> > +}
> 
> [ ... ]
> 
> 
> ---
> AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
> See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md
> 
> CI run summary: https://github.com/kernel-patches/bpf/actions/runs/24663313503

