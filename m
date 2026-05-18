Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4D63F9A05
	for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2026 14:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779114380; cv=none; b=b72FhEhemPgEf2JRi2fB2Wu8xXmRCzDEIxYZiOUVkwzThchuo2swLSMagohtvL3dpsRC6kbN/C/1AEDI8LqOrGeWO5ebX28B/RJIHnwzpHwF56OsQmB3MQXzSeoTqFnVBBUtOqFDhCk+ATbJ+00WZfJTQac+eDHZcximEzg56Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779114380; c=relaxed/simple;
	bh=89I3dsEQmgvGzJ6RM/nLpu3C1uHMvEPGKm+69HVlElQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XdPfeVMn56o8+Av+WEMk/RKX0fjP/dF2fRWLT8+BOaraXGKO/lTkq9HtPmCQGQmFZZujpWX3mUGcc0GygYtOsglseLKLyVcIs8gclPABEgIvUIgEVBU+B4w3CMp4ty5KLBBZveGPBImFg0PS410OCGa9GdtfHO4B+d0Mafbzf8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U1dr2xy9; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U1dr2xy9"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-48ff4f8ef0dso27012965e9.3
        for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2026 07:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779114375; x=1779719175; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NUmc/2eFwDyPu288j7GDElCwP6ZQHTGou0nPfUDNu+s=;
        b=U1dr2xy92aSTrdsYmr2TFg4pVx/efpAlwGG+i0zi5cFK/HlJeQWtEet9mJKTzdnL1g
         21w2oo8rTau6NH21XXbMUxTge5HQPsEBwb7DmFnRqWyIiSdPJgHuPm/6c4coqyvWa1i9
         QhSKQUhBmHRZintfdmAZa9s9R0cnVyzxZ/Hea3YWjOjSbAGDncy9cYsKtlyk/aj17z5L
         96czrSppm8nZxvpNc2y3lVNXnq4adNSZH1W0BTY26M2nmDNzOLWbjcp4vxVtrXXie7gg
         PVVEhQviT+ul71hiQJqaRZvBK9Z9FvERWOOhCRjDccnaBd/PEPeLtPMIa4pRY7HSNgob
         xekQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779114375; x=1779719175;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NUmc/2eFwDyPu288j7GDElCwP6ZQHTGou0nPfUDNu+s=;
        b=dw1Y3qGaCY4KoTNF3m4+E5mvF/Kryoa3OocWuU9yvMEqL+JKrC+bK1S5KfFfzvhZ2x
         YQ/lQQifY+ymcpdFz3Rj6HEaJXiA1F4oVlzaC8F9jcCfuBppvqKjc7C4pOhYWmLx9X9s
         L+vWQ2R1b+eMKdkAaF7sdNnqqI+TDXd/nd6O71+rvOs+bgKWh/ycBjcQ7PM0DjvcT07/
         DSuD3dNmBueuuel6Q+xjNeUZ011C0+fwlRPE0ZDJLnikYl0SEWTx51sZhHabtBRp2D/k
         WLnTyrFhYFR01o5n6hu8WJGuCmD6egbr5oT7Dtj0gMA4oloTzTOb037sJ3DKHv5vxKby
         Ty1w==
X-Forwarded-Encrypted: i=1; AFNElJ/klmBIBuLxuKPxUImQliGPxBsEGswk86oOFNxs32G/YiupRPIWbcNg/YQkeSwUwGQuO/SsPjZPG+tMYYPxQ0w=@vger.kernel.org
X-Gm-Message-State: AOJu0YyoZXXSL/eBr+NTCgWo/0caxWXe7EOyaKmfKbE+9cXsrlt5rmRY
	5hgIXLheSrET6abCSHJOaAYOBN/n/MMT2Ixz77pGSnoKRwHU0UgkYfDp
X-Gm-Gg: Acq92OHjYuYEW1UZH7JXjJu8oXqgXF0ytwLSpBiCQ50Gnrc6LtYdn6A/5yq2b4l+vbG
	buBmxHvKRNwtYUP9VK/FrXcg390iKtUkPHpnRIxkbLNBnrpygcv7UAFzn9HwYLkCgFFpzjUgc1P
	EvsQwmgsgYT6f6RYnSmGYBRklFomvqSKu0lhjXHxKUXX/O1BMp75GdSbL+J7hPznD6ZjMLf7OQq
	0iw93uzhPqXVeOFCHxb+z7Ss20mo2IQ+Ob1JqLFEN7Aw5EzSuTns6wk/1Ea0WQH3JA1lpqAHlGW
	wqrk32lwUbDajPfIevM0z7ythe0TR2jaEZBMvlUm9Wlq5cHSKLJrVLxFxTeMsq14wvx4+AcFhy+
	C7YT7uq9niSxl6BbeIKDX+9CbrwgsdVzBf9nagN5WMcMNQ7IuKb/2+GZOdBP5QEZJeqGYhCNKzm
	ZdlOTPGHHCS37u3cQI9cZAT1PY9YB6ttGYQf63+6H0GnqV1GQE+NIihJQ=
X-Received: by 2002:a05:600c:c087:b0:48a:7b55:12a6 with SMTP id 5b1f17b1804b1-48fe5cb36aamr188849425e9.0.1779114375254;
        Mon, 18 May 2026 07:26:15 -0700 (PDT)
Received: from gmail.com (deskosmtp.auranext.com. [195.134.167.217])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe4c833fcsm259037795e9.2.2026.05.18.07.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 07:26:14 -0700 (PDT)
Date: Mon, 18 May 2026 16:26:12 +0200
From: Mahe Tardy <mahe.tardy@gmail.com>
To: bot+bpf-ci@kernel.org
Cc: bpf@vger.kernel.org, martin.lau@linux.dev, daniel@iogearbox.net,
	john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org,
	yonghong.song@linux.dev, jordan@jrife.io, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, martin.lau@kernel.org,
	eddyz87@gmail.com, clm@meta.com, ihor.solodrai@linux.dev
Subject: Re: [PATCH bpf-next v6 3/6] bpf: add bpf_icmp_send kfunc
Message-ID: <agshhAKrNWKG8cpa@gmail.com>
References: <20260518122842.218522-4-mahe.tardy@gmail.com>
 <dc63930101e50f36995ef7b487096c6580e7eaa75594ab083ff6e0bc28eeb046@mail.kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc63930101e50f36995ef7b487096c6580e7eaa75594ab083ff6e0bc28eeb046@mail.kernel.org>

On Mon, May 18, 2026 at 01:34:48PM +0000, bot+bpf-ci@kernel.org wrote:
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 9590877b0714..843fa775596b 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> 
> [ ... ]
> 
> > @@ -12464,6 +12466,110 @@ __bpf_kfunc int bpf_xdp_pull_data(struct xdp_md *x, u32 len)
> >  	return 0;
> >  }
> >
> > +static DEFINE_PER_CPU(bool, bpf_icmp_send_in_progress);
> > +
> > +/**
> > + * bpf_icmp_send - Send an ICMP control message
> > + * @skb_ctx: Packet that triggered the control message
> > + * @type: ICMP type (only ICMP_DEST_UNREACH/ICMPV6_DEST_UNREACH supported)
> > + * @code: ICMP code (0-15 for IPv4, 0-6 for IPv6)
> > + *
> > + * Sends an ICMP control message in response to the packet. The original packet
> > + * is cloned before sending the ICMP message, so the BPF program can still let
> > + * the packet pass if desired.
> > + *
> > + * Currently only ICMP_DEST_UNREACH (IPv4) and ICMPV6_DEST_UNREACH (IPv6) are
> > + * supported.
> > + *
> > + * Recursion protection: If called from a context that would trigger recursion
> > + * (e.g., root cgroup processing its own ICMP packets), returns -EBUSY on
> > + * re-entry.
> > + *
> > + * Return: 0 on success, negative error code on failure:
> > + *         -EINVAL: Invalid code parameter
> > + *         -EBADMSG: Packet too short or malformed
> > + *         -ENOMEM: Memory allocation failed
> > + *         -EBUSY: Recursion detected
> > + *         -EHOSTUNREACH: Routing failed
> > + *         -EPROTONOSUPPORT: Non-IP protocol
> > + *         -EOPNOTSUPP: Unsupported ICMP type
> > + */
> > +__bpf_kfunc int bpf_icmp_send(struct __sk_buff *skb_ctx, int type, int code)
> > +{
> > +	struct sk_buff *skb = (struct sk_buff *)skb_ctx;
> > +	struct sk_buff *nskb;
> > +	bool *in_progress;
> > +
> > +	in_progress = this_cpu_ptr(&bpf_icmp_send_in_progress);
> > +	if (*in_progress)
> > +		return -EBUSY;
> 
> Is the per-CPU recursion protection flag safe without disabling
> preemption or bottom-halves?
> 
> Since cgroup_skb egress programs execute in process context, they can be
> interrupted by network RX softirqs on the same CPU. If a task sets
> *in_progress to true and is immediately preempted by a softirq that runs a
> TC ingress program calling bpf_icmp_send(), it will read the same per-CPU
> flag and spuriously fail with -EBUSY.
> 
> This was raised in v5 by the Sashiko AI bot:
> 
>     Since cgroup_skb egress programs execute in process context, they can be
>     interrupted by network RX softirqs on the same CPU.
> 
>     If a task sets *in_progress to true and is immediately preempted by a
>     softirq that runs a TC ingress program calling bpf_icmp_send(), will it
>     read the same per-CPU flag and spuriously fail with -EBUSY?
> 
>     Does this critical section need to run with bottom-halves disabled?
> 
> https://lore.kernel.org/bpf/20260515202358.20252C2BCB0@smtp.kernel.org/
> 
> Would using two separate per-CPU flags (one for softirq context, one for
> process context) or disabling bottom-halves around the critical section
> address this race condition?
> 
> [ ... ]

I've replied on the v5: the race should be acceptable as it will fail
close with EBUSY, if we want to avoid this we might want two PER_CPU
in_progress flags, one for softirq and one for the process context. In
any case, what we want to prevent is recursion (the kfunc triggering
itself), so softirq interruption from process should be okay as it
should concern another packet.

> 
> 
> ---
> AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
> See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md
> 
> CI run summary: https://github.com/kernel-patches/bpf/actions/runs/26034287312

