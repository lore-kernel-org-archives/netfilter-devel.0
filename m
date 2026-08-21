Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D985B3B19A0;
	Fri, 21 Aug 2026 13:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787319779; cv=none; b=jTbu6hHeSH89Ub+gED00evDe4j2V1Aa/P+ohTZIQbISq3xUNnoVJW4nsq4xeZOU9pLxvMVcEn4mYKNnEAOGz2zVJDzSa1P1ZRGvMxNE8D23UXBFnQjnlvLcplgc6d/D4HB78pozA73VvUnpMYSRnok1tM3B0GcMeo62ql8B5gME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787319779; c=relaxed/simple;
	bh=Vtr/AME7bqSs8l6XgDgP3asMbVIBSojJl6gtu57j2uQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZuWEHkuTAOZK3zVILQRDyVRpVtLuLpue5vkbMmTaaxl8Tg8cGkN62wjQFInWTjlck1kasYWB4MfMVZdRdNSr/BPHBZsw9vOBLJM8iu+ECFYmNllIa2VwQSeMq5G9llWQ7DHne42nEZ+zw/u9wpFmbxH9NvgqHa6b6BNQOZ4Zhzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tiQovgVv; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tiQovgVv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787319768;
	bh=CdNOh3OTKrRnxjFkGuwoM6wDkGD+fUjLsk2ZX6r4pUU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tiQovgVvGA4juqTN+no18Gi+2KdRjg6kKVinvVWBBnDjiV4dB5lkL80rzklSan/TI
	 3+by/thnu4RDdQnGsET4530m9zFaVvSJV40juHEW8cGJ3lHrryY4bR/+x7oy1qjOm6
	 mRoFKwbKgqdnyNOo2xbrbPYudM+jGjKOMsh1LvKYmO0P4j5w2iz6E6x8+V5D6Fgzzc
	 X1SNxXCX412TKEvYAVEHoNkffkkCFFBSc/7EilChNoGNEoMHI1c6Oz3PQefS0eVcCU
	 ZwfTEcPCVVB8sCgjWCQqaRvIamUreioMXJko3o7LGEzcJiprrjxBggAWxC+Lkn1t1D
	 4yutwIWrZaWzg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 08E466021B;
	Fri, 21 Aug 2026 15:42:48 +0200 (CEST)
Date: Fri, 21 Aug 2026 15:42:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: David Lee <david.lee@trailofbits.com>
Cc: fw@strlen.de, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, Kyle Zeng <kylebot@openai.com>,
	Dominik 'Disconnect3d' Czarnota <dominik.czarnota@trailofbits.com>,
	phil@nwl.cc, horms@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH nf v2] netfilter: nf_reject: initialize IPCB at inet
 ingress
Message-ID: <aohV0xIb23Pvs7yt@chamomile>
References: <20260810160703.861885-1-david.lee@trailofbits.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260810160703.861885-1-david.lee@trailofbits.com>

On Mon, Aug 10, 2026 at 04:07:03PM +0000, David Lee wrote:
> From: Kyle Zeng <kylebot@openai.com>
> 
> The inet ingress hook runs before ip_rcv_core() and ip6_rcv_core(), so
> neither IPCB nor IP6CB has been initialized when nft_reject_inet passes
> a packet to nf_send_unreach() or nf_send_unreach6(). skb->cb can
> therefore retain metadata from an earlier protocol layer.
> 
> For IPv4, icmp_send() treats IPCB(skb)->opt as parsed IPv4 options.
> Stale option offsets can make __ip_options_echo() copy an
> attacker-controlled length into its 40-byte reply option buffer and
> overflow the stack. On an unpatched v7.2-rc5 kernel, the IPv4
> reproducer produced:
> 
>   BUG: KASAN: stack-out-of-bounds in __ip_options_echo()
>   Write of size 255
> 
> For IPv6, icmpv6_send() consumes IP6CB(skb) as parsed IPv6 metadata. It
> always uses iif for source selection and, when MIP6 is enabled, uses
> dsthao as an extension-header offset. These fields must not be stale.
> 
> For NF_INET_INGRESS, clear the address-family-specific control block
> and restore its input interface before constructing the ICMP error.
> This matches the initialization normally performed by ip_rcv_core()
> and ip6_rcv_core().
> 
> Fixes: 117ca1f8920c ("netfilter: nft_reject_inet: allow to use reject from inet ingress")
> Cc: stable@vger.kernel.org
> Assisted-by: Codex:gpt-5.6-sol Codex:gpt-5.5-cyber
> Signed-off-by: Kyle Zeng <kylebot@openai.com>
> Co-developed-by: David Lee <david.lee@trailofbits.com>
> Signed-off-by: David Lee <david.lee@trailofbits.com>
> ---
> Changes in v2:
> - Initialize IP6CB in nf_send_unreach6() for inet ingress.
> - Preserve the IPv6 input interface before constructing the reply dst.
> 
> v1: https://lore.kernel.org/netfilter-devel/20260804095105.715387-1-david.lee@trailofbits.com/
> 
> Bug found and triaged by OpenAI Security Research and
> validated by Trail of Bits.
> 
> Trail of Bits has an IPv4 reproducer for this bug that triggers the
> KASAN stack-out-of-bounds write in __ip_options_echo() and can share it
> if needed. A separate IPv6 test reaches nf_send_unreach6() from inet
> ingress and confirms that an ICMPv6 unreachable is constructed.
> 
>  net/ipv4/netfilter/nf_reject_ipv4.c | 6 ++++++
>  net/ipv6/netfilter/nf_reject_ipv6.c | 9 +++++++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
> index 4626dc46808f..4933f65138d6 100644
> --- a/net/ipv4/netfilter/nf_reject_ipv4.c
> +++ b/net/ipv4/netfilter/nf_reject_ipv4.c
> @@ -355,6 +355,12 @@ void nf_send_unreach(struct sk_buff *skb_in, int code, int hook)
>  	if (!skb_dst(skb_in) && nf_reject_fill_skb_dst(skb_in) < 0)
>  		return;
>  
> +	/* Inet ingress runs before IPv4 initializes IPCB. */
> +	if (hook == NF_INET_INGRESS) {
> +		memset(IPCB(skb_in), 0, sizeof(*IPCB(skb_in)));
> +		IPCB(skb_in)->iif = skb_in->skb_iif;
> +	}
> +
>  	if (skb_csum_unnecessary(skb_in) ||
>  	    !nf_reject_verify_csum(skb_in, dataoff, proto)) {
>  		icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0);
> diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
> index ef5b7e85cffa..c36910b8a95a 100644
> --- a/net/ipv6/netfilter/nf_reject_ipv6.c
> +++ b/net/ipv6/netfilter/nf_reject_ipv6.c
> @@ -9,6 +9,7 @@
>  #include <net/ip6_fib.h>
>  #include <net/ip6_checksum.h>
>  #include <net/netfilter/ipv6/nf_reject.h>
> +#include <net/dst_metadata.h>
>  #include <linux/netfilter_ipv6.h>
>  #include <linux/netfilter_bridge.h>
>  
> @@ -440,6 +441,14 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
>  	if (hooknum == NF_INET_LOCAL_OUT && skb_in->dev == NULL)
>  		skb_in->dev = net->loopback_dev;
>  
> +	/* Inet ingress runs before IPv6 initializes IP6CB. */
> +	if (hooknum == NF_INET_INGRESS) {
> +		memset(IP6CB(skb_in), 0, sizeof(*IP6CB(skb_in)));
> +		IP6CB(skb_in)->iif = skb_valid_dst(skb_in) ?
> +				     ip6_dst_idev(skb_dst(skb_in))->dev->ifindex :
> +				     skb_in->dev->ifindex;

Why do different? Maybe just use:

        IP6CB(skb_in)->iif = skb_in->skb_iif;

like in the IPv4 chunk?

> +	}
> +
>  	if (!skb_dst(skb_in) && nf_reject6_fill_skb_dst(skb_in) < 0)
>  		return;
>  
> -- 
> 2.53.0
> 
