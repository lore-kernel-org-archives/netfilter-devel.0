Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E288740242E
	for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2026 18:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302923; cv=none; b=UNyOMHeNr7xNmnMEQZpWKiet2JEg6EicXA85maPH/FLMk+qW/HsED1TUEr/fR0Hzbb1gRoCB55u4vmT/G57s8G+EL74OlcTg+PVgqsXuwy/04YOldnGw33qdxkXCRfkvse27pIIUn5aLdjO6g3dxisRNqpbwiumq3DFslK7vIm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302923; c=relaxed/simple;
	bh=+8/Erynk4MZt8ofJCHgv8LLJ6eah4GjJA0JiD2n6b0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZoY9wBcNNI3FXnMTLpfrTzwy6690fzcL1dHZQxpMvKfWrBBRMlacTwHC+W9oPoUYu8yvZspB/m6CSJ/F4VxIDqYEAEkyo71d+qwTBV1ICiBLwP4tEgPF10XOIwCJwIzbICfURSHbrPXSyKjdP/N4u/jmf+9jrj+crjy2t/GVtpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TZAESE6/; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TZAESE6/"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4891d7164ddso29610065e9.3
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2026 11:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779302916; x=1779907716; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aPR9vml157T4AFMb0/LQfAP6U5qDsLmLgjLzNQHI+FU=;
        b=TZAESE6/Xgxb8TYn8+/gTIsxXyd3d81qZx9mcMhLsdEQyxO6qyqQRBIudwLxD10PeV
         +/C/SovMbmgAIhe2Fo/34b/JKkyZ49zzzivfHURUa1ECM5EUpWc4C5yDsLki82knLJ62
         ochwZIGtiIr+4Mta+XNK3LABIMgUqE5rpe7FHaPCMoBRZMNTYDyZtteKMFsrt06swbF5
         vxHcGTdnju6tjA/iVcjYdsvBT8DJmLjH6DwaHBbdC0rdkD2zboMWStmBxJxdoquDREps
         9RfBqygRSpiCzyhBLd/dQn2cgYtt0o0YJrbPXo/Y0uoO7GEa/XNKETFlm/BUYVbkTWDi
         5fvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779302916; x=1779907716;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aPR9vml157T4AFMb0/LQfAP6U5qDsLmLgjLzNQHI+FU=;
        b=k/uYp1laCna4PN1BuhKd9RQ7+I7SDtiwQCmIHoZXk0SpUrMgH2EbUcOfpnm89mx6he
         8IKOw+pcC7sKZhMx2loZYVggKhzOHfxPry2yaDXxEZuf3nOUhvkWk11XDfdPYIaR1BX8
         UW27QaPO2qGRJJ2sqicpOJy128Bf2jbMis9cX/gElFfHnVlJ78Ntb9BpWHWtXoi1Xygk
         CONjsgtMxpbxZhpAfPs6ZNycvLoQmob/1+R8kJKzl5tHqfsN9UgTl0Joj0q7govOYaSQ
         T6jd22P0IKmgFptt0afqYww05XnLnNFj1krIyQFOfO/mP1w3EfgL3nCyy1dc0vYvxzqb
         1xcA==
X-Forwarded-Encrypted: i=1; AFNElJ+x/dsaha7P+8Syc/EHSXoO0lRHDA4b3w4R0hDw9oejSlut9Xij+9QM3nxvYm9N8nMt+drH+yUA4eAaRLCbLcs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsSdRCKB3IHmCOKzx4CwfJWzgnJTbXG3NCKawOlZ9DBdHevRP9
	ekK1qiz/a2JLU6nAALE0M1uWxJ+AF1SctzhTvapjUncbo70oPSuZXcfC
X-Gm-Gg: Acq92OGTMxrMcXBSP3UC13heA1QUBZseKUCIVBZpuDN0n5rrYJpw1uP0+2betJ6TnFe
	vv7ozauwQh1vjR1YkUW9ffOW6U/EE+fV8qNXCmZvlnfPcn2rBSwbuYpcrDI1kexypLuLHQ4+8GJ
	48m/1/Ec5rLSZu2eebrvPLcCfKSiJdQVboBcYZepCMELDqhBM7/1mpWfZM+7m5h3/OfurBelrUt
	Ek6a2IEuXlRM8NSzcuTO2MGE5fmv+bE73vmo+ApDd5pFaFhaZdPJBY5Unw+sMjRqAe0jJBeJQNs
	OE98a7injIk9GA+qdv6JsVUX9avN5sBRm2FUYQtWAh7Vg0DcYi6sCKrf6DWfRBfXVYk7goAIlhP
	Fy4g65B9NDPM8flrSst9cg9NMiD6p4qhQwL11qp23RdlPHY7DWfVYrE0cWAHnOE5iXeSaHtdayB
	EBsRDkexke9djz4gGRzNSUiX6z9w6bC3xJZl1XxbrQQONcpwLk8XblyvU=
X-Received: by 2002:a05:600c:3e11:b0:48f:e230:c3fb with SMTP id 5b1f17b1804b1-48fe6626a8emr375953415e9.33.1779302916153;
        Wed, 20 May 2026 11:48:36 -0700 (PDT)
Received: from gmail.com (deskosmtp.auranext.com. [195.134.167.217])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49033d3514esm11300845e9.3.2026.05.20.11.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 11:48:35 -0700 (PDT)
Date: Wed, 20 May 2026 20:48:33 +0200
From: Mahe Tardy <mahe.tardy@gmail.com>
To: Jordan Rife <jordan@jrife.io>
Cc: bpf@vger.kernel.org, martin.lau@linux.dev, daniel@iogearbox.net,
	john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org,
	yonghong.song@linux.dev, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH bpf-next v6 3/6] bpf: add bpf_icmp_send kfunc
Message-ID: <ag4CAVec9jPCAuD0@gmail.com>
References: <20260518122842.218522-1-mahe.tardy@gmail.com>
 <20260518122842.218522-4-mahe.tardy@gmail.com>
 <onco52d3vpxkcc6hh3s5vuqjxanasucteq7wnqfqgzg4d65alc@q7h22nu3ytjn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <onco52d3vpxkcc6hh3s5vuqjxanasucteq7wnqfqgzg4d65alc@q7h22nu3ytjn>

On Mon, May 18, 2026 at 06:33:45PM -0700, Jordan Rife wrote:
> On Mon, May 18, 2026 at 12:28:39PM +0000, Mahe Tardy wrote:
> > This is needed in the context of Tetragon to provide improved feedback
> > (in contrast to just dropping packets) to east-west traffic when blocked
> > by policies using cgroup_skb programs. We also extend this kfunc to tc
> > program as a convenience.
> > 
> > This reuses concepts from netfilter reject target codepath with the
> > differences that:
> > * Packets are cloned since the BPF user can still let the packet pass
> >   (SK_PASS from the cgroup_skb progs for example) and the current skb
> >   need to stay untouched (cgroup_skb hooks only allow read-only skb
> >   payload).
> > * We protect against recursion since the kfunc, by generating an ICMP
> >   error message, could retrigger the BPF prog that invoked it.
> > 
> > For now, we support cgroup_skb and tc program types. For cgroup_skb and
> > tc egress, almost everything should be good. However for tc ingress:
> > - packet will not be routed yet: need to set the net device for
> >   icmp_send, thus the call to ip[6]_route_reply_fill_dst.
> > - fragments could trigger hook: icmp_send will only reply to fragment 0.
> > - ensure the ip headers is linearized before processing, and zero out
> >   the SKB control block after cloning to prevent icmp_send()/icmpv6_send()
> >   from misinterpreting garbage data as IP options.
> > 
> > Only ICMP_DEST_UNREACH and ICMPV6_DEST_UNREACH are currently supported.
> > The interface accepts a type parameter to facilitate future extension to
> > other ICMP control message types.
> > 
> > Signed-off-by: Mahe Tardy <mahe.tardy@gmail.com>
> > ---
> >  net/core/filter.c | 118 ++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 118 insertions(+)
> > 
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 9590877b0714..843fa775596b 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -84,6 +84,8 @@
> >  #include <linux/un.h>
> >  #include <net/xdp_sock_drv.h>
> >  #include <net/inet_dscp.h>
> > +#include <linux/icmpv6.h>
> > +#include <net/icmp.h>
> > 
> >  #include "dev.h"
> > 
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
> > +
> > +	switch (skb->protocol) {
> > +#if IS_ENABLED(CONFIG_INET)
> > +	case htons(ETH_P_IP):
> > +		if (type != ICMP_DEST_UNREACH)
> > +			return -EOPNOTSUPP;
> > +		if (code < 0 || code > NR_ICMP_UNREACH)
> > +			return -EINVAL;
> > +
> > +		nskb = skb_clone(skb, GFP_ATOMIC);
> > +		if (!nskb)
> > +			return -ENOMEM;
> > +
> > +		if (!pskb_network_may_pull(nskb, sizeof(struct iphdr))) {
> > +			kfree_skb(nskb);
> > +			return -EBADMSG;
> 
> nit: Instead of having several places where you call kfree_skb, maybe
> consider just cleaning up in once place at the end like:
> 
> out:
> 	if (nskb)
> 		kfree_skb(nskb);
> 	return err;
> 	
> then in places like this do something like:
> 
> 	err = -EBADMSG;
> 	goto out;

Yep yep I see, just if I follow Stanislav recommendation to use consume_skb
in the success path[^1], I think it would be simpler to keep the other error
paths with kfree_skb and returning the error.

[^1]: https://lore.kernel.org/bpf/ags3HARTFYwKU8nR@devvm7509.cco0.facebook.com/

> 
> > +		}
> > +
> > +		if (!skb_dst(nskb) && ip_route_reply_fill_dst(nskb) < 0) {
> > +			kfree_skb(nskb);
> > +			return -EHOSTUNREACH;
> > +		}
> > +
> > +		memset(IPCB(nskb), 0, sizeof(struct inet_skb_parm));
> > +
> > +		*in_progress = true;
> > +		icmp_send(nskb, type, code, 0);
> > +		*in_progress = false;
> > +		kfree_skb(nskb);
> > +		break;
> > +#endif
> > +#if IS_ENABLED(CONFIG_IPV6)
> > +	case htons(ETH_P_IPV6):
> > +		if (type != ICMPV6_DEST_UNREACH)
> > +			return -EOPNOTSUPP;
> > +		if (code < 0 || code > ICMPV6_REJECT_ROUTE)
> > +			return -EINVAL;
> > +
> > +		nskb = skb_clone(skb, GFP_ATOMIC);
> > +		if (!nskb)
> > +			return -ENOMEM;
> > +
> > +		if (!pskb_network_may_pull(nskb, sizeof(struct ipv6hdr))) {
> > +			kfree_skb(nskb);
> > +			return -EBADMSG;
> > +		}
> > +
> > +		if (!skb_dst(nskb) && ip6_route_reply_fill_dst(nskb) < 0) {
> > +			kfree_skb(nskb);
> > +			return -EHOSTUNREACH;
> > +		}
> > +
> > +		memset(IP6CB(nskb), 0, sizeof(struct inet6_skb_parm));
> > +
> > +		*in_progress = true;
> > +		icmpv6_send(nskb, type, code, 0);
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
> > +
> >  __bpf_kfunc_end_defs();
> > 
> >  int bpf_dynptr_from_skb_rdonly(struct __sk_buff *skb, u64 flags,
> > @@ -12506,6 +12612,10 @@ BTF_KFUNCS_START(bpf_kfunc_check_set_sock_ops)
> >  BTF_ID_FLAGS(func, bpf_sock_ops_enable_tx_tstamp)
> >  BTF_KFUNCS_END(bpf_kfunc_check_set_sock_ops)
> > 
> > +BTF_KFUNCS_START(bpf_kfunc_check_set_icmp_send)
> > +BTF_ID_FLAGS(func, bpf_icmp_send)
> > +BTF_KFUNCS_END(bpf_kfunc_check_set_icmp_send)
> > +
> >  static const struct btf_kfunc_id_set bpf_kfunc_set_skb = {
> >  	.owner = THIS_MODULE,
> >  	.set = &bpf_kfunc_check_set_skb,
> > @@ -12536,6 +12646,11 @@ static const struct btf_kfunc_id_set bpf_kfunc_set_sock_ops = {
> >  	.set = &bpf_kfunc_check_set_sock_ops,
> >  };
> > 
> > +static const struct btf_kfunc_id_set bpf_kfunc_set_icmp_send = {
> > +	.owner = THIS_MODULE,
> > +	.set = &bpf_kfunc_check_set_icmp_send,
> > +};
> > +
> >  static int __init bpf_kfunc_init(void)
> >  {
> >  	int ret;
> > @@ -12557,6 +12672,9 @@ static int __init bpf_kfunc_init(void)
> >  	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_CGROUP_SOCK_ADDR,
> >  					       &bpf_kfunc_set_sock_addr);
> >  	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &bpf_kfunc_set_tcp_reqsk);
> > +	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_CGROUP_SKB, &bpf_kfunc_set_icmp_send);
> > +	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &bpf_kfunc_set_icmp_send);
> 
> Thanks, this could come in handy for TC.
> 
> I'm not quite sure yet on using it in lieu of the sock_destroy kfunc for
> the UDP connected socket use case we discussed at LSFMMBPF. For socket
> LB mode in Cilium to make this work you'd need to add at least one new
> map lookup in the fast path to check for backend liveness and this
> partially defeats the performance benefits of socket LB which right
> now avoids service + backend lookups in the fast path for connected UDP.
> Ultimately, it might be better to stick with sock_destroy to kill
> sockets out-of-band for that use case, but still it's good to have this
> option.
> 
> > +	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_ACT, &bpf_kfunc_set_icmp_send);
> >  	return ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SOCK_OPS, &bpf_kfunc_set_sock_ops);
> >  }
> >  late_initcall(bpf_kfunc_init);
> > --
> > 2.34.1
> > 
> 
> Jordan
