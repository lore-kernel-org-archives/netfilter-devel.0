Received: from mail-yw1-f193.google.com (mail-yw1-f193.google.com [209.85.128.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894A31DC1AB
	for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2026 16:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779121077; cv=none; b=mB4FXeUyvCZiihkeql7sg1kiwRUh3nSjFSP/695xdkpobOONS28B9AClhyCfNaXRglwH0IOTsLLzLnGFV8DxnNXvHFjxReAdtXYKi9DoHc50NB7Pl8teoNrz0nElYAZzd62j6SMu+iF52K3eI1rSRsMcLYl15NEn0xoWZWHcTrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779121077; c=relaxed/simple;
	bh=y/Ck4btyjHM5/jVnV3S2iDN9W4wWxh7IWDvICNTmyaQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AYFB+LUTXKwM5/v2OO5U9O5eiNe4sfWnmi3Rs4/r3j/Gp9RuZ1FOpBTre2i1ldNIVub+9oEM8yxrJb8Q3hbuNHcvxh8WOJn04Gb1wWKJdrSvVffFqaBUltr6jCvC7V/P8dt4qAMi0xRMKuPIK48XsINQThs+Zj94kxzy/K5jIXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ngFbfKCk; arc=none smtp.client-ip=209.85.128.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ngFbfKCk"
Received: by mail-yw1-f193.google.com with SMTP id 00721157ae682-7b6ae2ea4a1so19648737b3.2
        for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2026 09:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779121066; x=1779725866; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v/OH0BRtpRw1M3FuVaNDUvm/zDHm0O0pCgI7eSycbdU=;
        b=ngFbfKCk9AamwXrwmjkloy4KkRyDt8vU26A8zbxwX25PXzlhBnnoexsPWhU5XIyRwd
         +Shr1i5M7HF9IkbXvJXFJGi1nHgQ6elnZDKac4qxmTm8ybZr2qE+eSx0G5gpRc68vhYb
         eqfejstQUzh3lsbWHA/Ohv8/OlRSgI21omEHTxG91tNzvyZXGq1qLwYBRIiK/z2TN3Ji
         Xmn40RX8QOz3FXTGJDR/El404Syn0h3D5x5NaJ5OUfLweWJGhpLdIGHH3hmXfVzx4Dix
         7DC/U8DIcMdGuQ30Edn10IbyK7/6Q9WXqR4gkevoXJtf7ejJe1ryEEO83ie+zOrkUmua
         YmkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779121066; x=1779725866;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v/OH0BRtpRw1M3FuVaNDUvm/zDHm0O0pCgI7eSycbdU=;
        b=OEhJeAG4Gu87GUSiAlWloC4bfdmDA5bujqtxuwFrxobAFtuEonYd+KVZLT+g36k6kj
         7c2q81SESwNIT2ZoFEBYMMDe0zhCxCb1WZQy3OmVltd7vCgNp6ID4sI8NcsR1btAyrNi
         u8U78zH54oXdxTgruN/MDSWqGGBABeMz56xBtBAKgrvcBpnL88oz5CLFmP3yrzB6CHsj
         a1gghpvKOslAKVy2Fi8cnDQme2aqt4m7Aar5Y49A/3QelSsp1SzI2dNMFAktIMdgZAaS
         lcgDEAyh+p6zFCzPksr3BxIxZNbk7TTBw2cf1AZYJTksVNYrKWdNi54rqnN/AVX3teKs
         wk0g==
X-Forwarded-Encrypted: i=1; AFNElJ+SoV9wXFjvOSskYqwpsHDYCBTqU2QaN6L0eIA9Ex6ZtidOT6lqtOmVh9jXusgL6BM+uinqppHuGg1ZT0hv4Wc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGeq5BX2kb5eABjidFYbUF/zPqWkppIhFh+sBjoxbdL8+vlutw
	i/y8eBJRf7eZrb/gFpJqdsSv2dFkRjhBLuUh3jVsoa3cmMp/nNwHk6Rk
X-Gm-Gg: Acq92OF8zvi+HW3zQ7JccZoGB1n/ex9O2S/SZgShIdI9yrLoLK9TdfDeXGJPcHRcdRf
	o1VgxYd3p/ybVAxatcTE13yD73lC2x+1cDpf6bUd7YXHpikpmQ8vbxExu6y3S/cU7odp2DVajeS
	MiPWh/t8ymVDdXn2FC+Dnxa/5w7FLYI5US267e8kzhRhXqBzaNMdGFZ1pfiDgSkqQerxqiafALY
	z5lLlxd9r/bh5nq72TcDG6mtCc9nHjh4PNnqRc6eCnLX8vykNZhwrDNyDiPFZx6ixV8GNpVNPZ4
	l3SLiwjBw2t1/XbhVvKWRkvuMOdQKmPEdZe6VRD+dVxCxLnAGCtZBclcF/ZY76NVYYhtviOC+t4
	itzSr7f/8iuoUilghOHPrtMb4VPDheOLZ0y8Z7xVRZif0m39kU3IFzaJHkRCOXvYjOHYmYQH119
	umOo9DzD6myumR
X-Received: by 2002:a05:690c:6d84:b0:79a:d2ba:3c24 with SMTP id 00721157ae682-7c95cbe8677mr175819657b3.41.1779121066147;
        Mon, 18 May 2026 09:17:46 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7cc9c6cd4f5sm23720227b3.35.2026.05.18.09.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 09:17:45 -0700 (PDT)
Date: Mon, 18 May 2026 09:17:45 -0700
From: Stanislav Fomichev <sdf.kernel@gmail.com>
To: Mahe Tardy <mahe.tardy@gmail.com>
Cc: bpf@vger.kernel.org, martin.lau@linux.dev, daniel@iogearbox.net, 
	john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org, yonghong.song@linux.dev, 
	jordan@jrife.io, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH bpf-next v6 3/6] bpf: add bpf_icmp_send kfunc
Message-ID: <ags3HARTFYwKU8nR@devvm7509.cco0.facebook.com>
References: <20260518122842.218522-1-mahe.tardy@gmail.com>
 <20260518122842.218522-4-mahe.tardy@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260518122842.218522-4-mahe.tardy@gmail.com>

On 05/18, Mahe Tardy wrote:
> This is needed in the context of Tetragon to provide improved feedback
> (in contrast to just dropping packets) to east-west traffic when blocked
> by policies using cgroup_skb programs. We also extend this kfunc to tc
> program as a convenience.
> 
> This reuses concepts from netfilter reject target codepath with the
> differences that:
> * Packets are cloned since the BPF user can still let the packet pass
>   (SK_PASS from the cgroup_skb progs for example) and the current skb
>   need to stay untouched (cgroup_skb hooks only allow read-only skb
>   payload).
> * We protect against recursion since the kfunc, by generating an ICMP
>   error message, could retrigger the BPF prog that invoked it.
> 
> For now, we support cgroup_skb and tc program types. For cgroup_skb and
> tc egress, almost everything should be good. However for tc ingress:
> - packet will not be routed yet: need to set the net device for
>   icmp_send, thus the call to ip[6]_route_reply_fill_dst.
> - fragments could trigger hook: icmp_send will only reply to fragment 0.
> - ensure the ip headers is linearized before processing, and zero out
>   the SKB control block after cloning to prevent icmp_send()/icmpv6_send()
>   from misinterpreting garbage data as IP options.
> 
> Only ICMP_DEST_UNREACH and ICMPV6_DEST_UNREACH are currently supported.
> The interface accepts a type parameter to facilitate future extension to
> other ICMP control message types.
> 
> Signed-off-by: Mahe Tardy <mahe.tardy@gmail.com>
> ---
>  net/core/filter.c | 118 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 118 insertions(+)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 9590877b0714..843fa775596b 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -84,6 +84,8 @@
>  #include <linux/un.h>
>  #include <net/xdp_sock_drv.h>
>  #include <net/inet_dscp.h>
> +#include <linux/icmpv6.h>
> +#include <net/icmp.h>
> 
>  #include "dev.h"
> 
> @@ -12464,6 +12466,110 @@ __bpf_kfunc int bpf_xdp_pull_data(struct xdp_md *x, u32 len)
>  	return 0;
>  }
> 
> +static DEFINE_PER_CPU(bool, bpf_icmp_send_in_progress);
> +
> +/**
> + * bpf_icmp_send - Send an ICMP control message
> + * @skb_ctx: Packet that triggered the control message
> + * @type: ICMP type (only ICMP_DEST_UNREACH/ICMPV6_DEST_UNREACH supported)
> + * @code: ICMP code (0-15 for IPv4, 0-6 for IPv6)
> + *
> + * Sends an ICMP control message in response to the packet. The original packet
> + * is cloned before sending the ICMP message, so the BPF program can still let
> + * the packet pass if desired.
> + *
> + * Currently only ICMP_DEST_UNREACH (IPv4) and ICMPV6_DEST_UNREACH (IPv6) are
> + * supported.
> + *
> + * Recursion protection: If called from a context that would trigger recursion
> + * (e.g., root cgroup processing its own ICMP packets), returns -EBUSY on
> + * re-entry.
> + *
> + * Return: 0 on success, negative error code on failure:
> + *         -EINVAL: Invalid code parameter
> + *         -EBADMSG: Packet too short or malformed
> + *         -ENOMEM: Memory allocation failed
> + *         -EBUSY: Recursion detected
> + *         -EHOSTUNREACH: Routing failed
> + *         -EPROTONOSUPPORT: Non-IP protocol
> + *         -EOPNOTSUPP: Unsupported ICMP type
> + */
> +__bpf_kfunc int bpf_icmp_send(struct __sk_buff *skb_ctx, int type, int code)
> +{
> +	struct sk_buff *skb = (struct sk_buff *)skb_ctx;
> +	struct sk_buff *nskb;
> +	bool *in_progress;
> +
> +	in_progress = this_cpu_ptr(&bpf_icmp_send_in_progress);
> +	if (*in_progress)
> +		return -EBUSY;
> +
> +	switch (skb->protocol) {
> +#if IS_ENABLED(CONFIG_INET)
> +	case htons(ETH_P_IP):
> +		if (type != ICMP_DEST_UNREACH)
> +			return -EOPNOTSUPP;
> +		if (code < 0 || code > NR_ICMP_UNREACH)
> +			return -EINVAL;
> +
> +		nskb = skb_clone(skb, GFP_ATOMIC);
> +		if (!nskb)
> +			return -ENOMEM;
> +
> +		if (!pskb_network_may_pull(nskb, sizeof(struct iphdr))) {
> +			kfree_skb(nskb);
> +			return -EBADMSG;
> +		}
> +
> +		if (!skb_dst(nskb) && ip_route_reply_fill_dst(nskb) < 0) {
> +			kfree_skb(nskb);
> +			return -EHOSTUNREACH;
> +		}
> +
> +		memset(IPCB(nskb), 0, sizeof(struct inet_skb_parm));
> +
> +		*in_progress = true;
> +		icmp_send(nskb, type, code, 0);
> +		*in_progress = false;

[..]

> +		kfree_skb(nskb);

I was going to suggest to use consume_skb here, I think it is a better fit?

But I'm not sure why you do the clone here, I don't see any requirement from
the icmp_send side, can you clarify? Is it because of the pull?
