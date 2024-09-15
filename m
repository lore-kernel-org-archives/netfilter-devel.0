Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D85823D1;
	Sun, 15 Sep 2024 21:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726435331; cv=none; b=BZykmjQeZm4Bmf8VebBZ6nrlMTOUAoCvFKmHbfYitgMAKhMvvVTQfcQ+8Ksj/KCf2dI54MDNnymrVaEpRmaOHP46rraaM1SeC1Mn/G+PzCX6HMWX0Yy56TsyQx3LrEo2spEKB2qp0sshqZo6pfuvqaoKFDDaBwLuHyUd/X6i3sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726435331; c=relaxed/simple;
	bh=uN8BuTLsECpRPRC4Gw2lbqvGL/TUi8WOUC91AGZ0qFg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hjqpNLDnOzzqW06+haDJToUjiMwHaeMmKDvPyLUbqOgVPpwnyzffuLORHcd2rRF2/xh84M1nAFvDI3uDYphBZ/4xYuYxQT65UP+wt5g8eUAIQWiXmQZYmvkUgh8vKnYzs3s7DZqaApf2tflGVqkvaPqy5k0xpQ9huZhwR1xzDHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=56458 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1spwh1-00EJcG-CH; Sun, 15 Sep 2024 23:22:05 +0200
Date: Sun, 15 Sep 2024 23:22:02 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Simon Horman <horms@kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH net v1 1/1] netfilter: nf_reject: Fix build error when
 CONFIG_BRIDGE_NETFILTER=n
Message-ID: <ZudP-mkhquCJJPXv@calendula>
References: <20240906145513.567781-1-andriy.shevchenko@linux.intel.com>
 <20240907134837.GP2097826@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240907134837.GP2097826@kernel.org>
X-Spam-Score: -1.9 (-)

Hi Simon,

This proposed update to address this compile time warning LGTM.

Would you submit it?

Thanks.

On Sat, Sep 07, 2024 at 02:48:37PM +0100, Simon Horman wrote:
[...]
> diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
> index 04504b2b51df..87fd945a0d27 100644
> --- a/net/ipv4/netfilter/nf_reject_ipv4.c
> +++ b/net/ipv4/netfilter/nf_reject_ipv4.c
> @@ -239,9 +239,8 @@ static int nf_reject_fill_skb_dst(struct sk_buff *skb_in)
>  void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
>  		   int hook)
>  {
> -	struct sk_buff *nskb;
> -	struct iphdr *niph;
>  	const struct tcphdr *oth;
> +	struct sk_buff *nskb;
>  	struct tcphdr _oth;
>  
>  	oth = nf_reject_ip_tcphdr_get(oldskb, &_oth, hook);
> @@ -266,14 +265,12 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
>  	nskb->mark = IP4_REPLY_MARK(net, oldskb->mark);
>  
>  	skb_reserve(nskb, LL_MAX_HEADER);
> -	niph = nf_reject_iphdr_put(nskb, oldskb, IPPROTO_TCP,
> -				   ip4_dst_hoplimit(skb_dst(nskb)));
> +	nf_reject_iphdr_put(nskb, oldskb, IPPROTO_TCP,
> +			    ip4_dst_hoplimit(skb_dst(nskb)));
>  	nf_reject_ip_tcphdr_put(nskb, oldskb, oth);
>  	if (ip_route_me_harder(net, sk, nskb, RTN_UNSPEC))
>  		goto free_nskb;
>  
> -	niph = ip_hdr(nskb);
> -
>  	/* "Never happens" */
>  	if (nskb->len > dst_mtu(skb_dst(nskb)))
>  		goto free_nskb;
> @@ -290,6 +287,7 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
>  	 */
>  	if (nf_bridge_info_exists(oldskb)) {
>  		struct ethhdr *oeth = eth_hdr(oldskb);
> +		struct iphdr *niph = ip_hdr(nskb);
>  		struct net_device *br_indev;
>  
>  		br_indev = nf_bridge_get_physindev(oldskb, net);
