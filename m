Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCF02D7DCF
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 01:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779154431; cv=none; b=u6eli59gWxT9LmU0PwbNbPLcpXQaLxy97GZqH6q9YjeMjljGnbGFVXSZhP+bGhWZKF3tfe4BifUZ8FI4xoEdHxiW3lRcb2D/0vPyoce7hvG0lS0tNIzALgaxwLnopjAj6eYfvEuTe9LpQXfIMp3aLtsnueVhlXHAuEw2hK/Wgtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779154431; c=relaxed/simple;
	bh=yfu3HXA6WpN97f2/JLOaEHAfe4Lu3Fr+ei26pjJ6UjE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CkpWz16vNfl6ShgjjxvR81xDQl08G8pi8slNA6hoXa6F2LzsLfPFuTD28yhbay9lC7sqZOPSEY4xPVmMrCfmC0Z8gUJULlFULsxyXoeFZumwgpGBhlXV6Q97LmZ44FtFIFMI9lsOGJz9QxztY6z2dm0WF+LEqUpnpLKs9fGbpIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jrife.io; spf=none smtp.mailfrom=jrife.io; dkim=pass (2048-bit key) header.d=jrife-io.20251104.gappssmtp.com header.i=@jrife-io.20251104.gappssmtp.com header.b=Nl9JUDMZ; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jrife.io
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=jrife.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jrife-io.20251104.gappssmtp.com header.i=@jrife-io.20251104.gappssmtp.com header.b="Nl9JUDMZ"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2bd5b3f8a98so6179965ad.2
        for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2026 18:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jrife-io.20251104.gappssmtp.com; s=20251104; t=1779154428; x=1779759228; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PMUulh6qid06yp999kMZYRmV0VRKarV0DjzjDNUvDFI=;
        b=Nl9JUDMZSi2Y7h5AOqoLvz7XV7wbX66yP8vU6ojg+DRPPGuANXRxW1KkDVpB0McFzW
         NNVJRZZe90ACPhbIIGTQ8rahvxpR28Ml3Z4t5vXMlAGAnUqR8c78lfnrWZZ7E2H+AxE9
         12cy5sX1yiFVnrqt3iIbnl500nRYseapg4RGYhvm/N8iRe0heT0vCWO7itB+qAuSKkWM
         nhbHw5sdYaWnuvVLxiUaIcXYF/jS6kdq5QcYcVHp5oRFoBl8XfcfEF4sZLlplzlCayw4
         vbLto2R7/e2b88bdePQPLqLRKX9TJctORZt/HizMRugAFV5QpkTbbjG6ugMVBa8OjSXh
         UL9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779154428; x=1779759228;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PMUulh6qid06yp999kMZYRmV0VRKarV0DjzjDNUvDFI=;
        b=fCwISfrZyJ8ZnReEDK83O+dMSh6lov4saXe2CWUvoUuFuZMUGVkZMtFR+jtjNflGi5
         C98LZWngyShiEi1Uut3M2d8f7fMoBdhYTybCmHv54zYoeWXuZ/z+x9jxP1VZqzGjSYg2
         RmCaq7dlnBlIpZmwX++7zmKlqnrWD+cVJHkdW02gSTGULpro9j7Gs8bbcTZE2pvDT1nm
         9TJXJ1GjmAZHR1o37Pl0jHu5mc7O/NagSs0tDn2yr9eDfv8MrF8c1mwj/NjyQzmV5A4N
         ASeh4luxTsLbuXtUpXcP1adnB/hwq3xtA7aivLILSsVXCzPatcJwjDsvf6M7Kzr29fQN
         F5XA==
X-Forwarded-Encrypted: i=1; AFNElJ+Rd1CAJiJx+elbqHPkAh/QUUXXOsmf7TJv5irrYbgDJgUJicwxWydjMD1ghuW8P5dlC/CcrdCDR5o7YaDqSvU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwX493eUAe9yromgSx+1grCEkQ3IcJ9rmJB/+CmGcFbXFXQQDs
	01mVKxNVfkicBbK7ClxwclLx7xPECgNjzsgTNM9s7bUGWuM8l26l360Ze2FAL/Qgtr8=
X-Gm-Gg: Acq92OHxR8ogS3sFxKdeuJMOqeDDT19NqQTG1ynRXmzskQalA2vS4dnwFYcAHD5E6Md
	Lxc2zvD74ehFrL0Aod9i6Vv5sa7rSrnCME/I2s8J6u2f3UFvVSgO7GnOqqa9rxC12AHRbTHUTFe
	/w5HCVIy5OqtSICbNhOjX9lbT7eUjcEoJv33rRVmrWO91TOOvO2LID5F/HEiVFArkkUH9oEe6xy
	XYaXTE3YaeVaU305BMNd88GHNS/z80T3HqXYEZXGOp694aRkUqFLjecKMdp6rBu9UEgkQmhZk3V
	jAsORSGsvxYMd5MFp1w8aZNuzQ+pHYlly15xrzH2EjYXMgvDgespJKNXfwaSLKWgrjFRS1o7k1b
	358XAST5j9WAz4alnBT2XNc3VpAney5j1ie4hSUiC0QjF79HqVkXRQ9qJz5Pb5uYH5QsozGbqKE
	8sm9NtPIbfPKBVR/vCTx3zUtDI
X-Received: by 2002:a17:903:2302:b0:2bd:e01c:d78 with SMTP id d9443c01a7336-2bde01c0e48mr37358615ad.7.1779154428357;
        Mon, 18 May 2026 18:33:48 -0700 (PDT)
Received: from m2 ([83.171.251.18])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5bd5f291sm170130185ad.15.2026.05.18.18.33.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 18:33:48 -0700 (PDT)
Date: Mon, 18 May 2026 18:33:45 -0700
From: Jordan Rife <jordan@jrife.io>
To: Mahe Tardy <mahe.tardy@gmail.com>
Cc: bpf@vger.kernel.org, martin.lau@linux.dev, daniel@iogearbox.net, 
	john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org, yonghong.song@linux.dev, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH bpf-next v6 3/6] bpf: add bpf_icmp_send kfunc
Message-ID: <onco52d3vpxkcc6hh3s5vuqjxanasucteq7wnqfqgzg4d65alc@q7h22nu3ytjn>
References: <20260518122842.218522-1-mahe.tardy@gmail.com>
 <20260518122842.218522-4-mahe.tardy@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518122842.218522-4-mahe.tardy@gmail.com>

On Mon, May 18, 2026 at 12:28:39PM +0000, Mahe Tardy wrote:
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

nit: Instead of having several places where you call kfree_skb, maybe
consider just cleaning up in once place at the end like:

out:
	if (nskb)
		kfree_skb(nskb);
	return err;
	
then in places like this do something like:

	err = -EBADMSG;
	goto out;

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
> +		kfree_skb(nskb);
> +		break;
> +#endif
> +#if IS_ENABLED(CONFIG_IPV6)
> +	case htons(ETH_P_IPV6):
> +		if (type != ICMPV6_DEST_UNREACH)
> +			return -EOPNOTSUPP;
> +		if (code < 0 || code > ICMPV6_REJECT_ROUTE)
> +			return -EINVAL;
> +
> +		nskb = skb_clone(skb, GFP_ATOMIC);
> +		if (!nskb)
> +			return -ENOMEM;
> +
> +		if (!pskb_network_may_pull(nskb, sizeof(struct ipv6hdr))) {
> +			kfree_skb(nskb);
> +			return -EBADMSG;
> +		}
> +
> +		if (!skb_dst(nskb) && ip6_route_reply_fill_dst(nskb) < 0) {
> +			kfree_skb(nskb);
> +			return -EHOSTUNREACH;
> +		}
> +
> +		memset(IP6CB(nskb), 0, sizeof(struct inet6_skb_parm));
> +
> +		*in_progress = true;
> +		icmpv6_send(nskb, type, code, 0);
> +		*in_progress = false;
> +		kfree_skb(nskb);
> +		break;
> +#endif
> +	default:
> +		return -EPROTONOSUPPORT;
> +	}
> +
> +	return 0;
> +}
> +
>  __bpf_kfunc_end_defs();
> 
>  int bpf_dynptr_from_skb_rdonly(struct __sk_buff *skb, u64 flags,
> @@ -12506,6 +12612,10 @@ BTF_KFUNCS_START(bpf_kfunc_check_set_sock_ops)
>  BTF_ID_FLAGS(func, bpf_sock_ops_enable_tx_tstamp)
>  BTF_KFUNCS_END(bpf_kfunc_check_set_sock_ops)
> 
> +BTF_KFUNCS_START(bpf_kfunc_check_set_icmp_send)
> +BTF_ID_FLAGS(func, bpf_icmp_send)
> +BTF_KFUNCS_END(bpf_kfunc_check_set_icmp_send)
> +
>  static const struct btf_kfunc_id_set bpf_kfunc_set_skb = {
>  	.owner = THIS_MODULE,
>  	.set = &bpf_kfunc_check_set_skb,
> @@ -12536,6 +12646,11 @@ static const struct btf_kfunc_id_set bpf_kfunc_set_sock_ops = {
>  	.set = &bpf_kfunc_check_set_sock_ops,
>  };
> 
> +static const struct btf_kfunc_id_set bpf_kfunc_set_icmp_send = {
> +	.owner = THIS_MODULE,
> +	.set = &bpf_kfunc_check_set_icmp_send,
> +};
> +
>  static int __init bpf_kfunc_init(void)
>  {
>  	int ret;
> @@ -12557,6 +12672,9 @@ static int __init bpf_kfunc_init(void)
>  	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_CGROUP_SOCK_ADDR,
>  					       &bpf_kfunc_set_sock_addr);
>  	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &bpf_kfunc_set_tcp_reqsk);
> +	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_CGROUP_SKB, &bpf_kfunc_set_icmp_send);
> +	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &bpf_kfunc_set_icmp_send);

Thanks, this could come in handy for TC.

I'm not quite sure yet on using it in lieu of the sock_destroy kfunc for
the UDP connected socket use case we discussed at LSFMMBPF. For socket
LB mode in Cilium to make this work you'd need to add at least one new
map lookup in the fast path to check for backend liveness and this
partially defeats the performance benefits of socket LB which right
now avoids service + backend lookups in the fast path for connected UDP.
Ultimately, it might be better to stick with sock_destroy to kill
sockets out-of-band for that use case, but still it's good to have this
option.

> +	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_ACT, &bpf_kfunc_set_icmp_send);
>  	return ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SOCK_OPS, &bpf_kfunc_set_sock_ops);
>  }
>  late_initcall(bpf_kfunc_init);
> --
> 2.34.1
> 

Jordan
