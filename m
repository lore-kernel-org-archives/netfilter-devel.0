Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9617F273FC;
	Wed, 11 Sep 2024 22:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726092731; cv=none; b=epcTlO+4DWwSI+aK9WhPMx3Az1d0P1WnMUsKa5t2CgoW9ZpvRXSxqZxW/ZIFEBRFrpPLsMJVQWGXa/Tl6aJRamuqXdEzwe6R04doUTVwGItqSzY8myIi1pB0CIqNmDWPEppJ2EhDTmFMqY2/FpZWn3+ie/yPyHeGegqzE4dcw1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726092731; c=relaxed/simple;
	bh=LHtNGOAmFIWxYkxjD253kuCAv0qxI1a/lzyf2ztRBUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ADXppTvubB+X3oSr1Ce0SeEaGBzkUyC9A8lSGoyAoqvkFYDzqD06ANiSKFfbQirq9ba5oL+XYCBIW+AVH5dPddk4jBIl1sDgbPStjP4kmoji87UMJrXrYWbFxcO4CxyKSGnz28tBqDAfScsYgCNKVhTMsf+2i23Hn86AfN/NWPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=51382 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1soVZC-007Wnn-Gg; Thu, 12 Sep 2024 00:12:04 +0200
Date: Thu, 12 Sep 2024 00:12:01 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Breno Leitao <leitao@debian.org>
Cc: fw@strlen.de, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, Jozsef Kadlecsik <kadlec@netfilter.org>,
	David Ahern <dsahern@kernel.org>, rbc@meta.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	"open list:NETFILTER" <coreteam@netfilter.org>
Subject: Re: [PATCH nf-next v5 1/2] netfilter: Make IP6_NF_IPTABLES_LEGACY
 selectable
Message-ID: <ZuIVsZ813wxD6Y3Q@calendula>
References: <20240909084620.3155679-1-leitao@debian.org>
 <20240909084620.3155679-2-leitao@debian.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240909084620.3155679-2-leitao@debian.org>
X-Spam-Score: -1.9 (-)

One more question below.

On Mon, Sep 09, 2024 at 01:46:18AM -0700, Breno Leitao wrote:
> This option makes IP6_NF_IPTABLES_LEGACY user selectable, giving
> users the option to configure iptables without enabling any other
> config.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  net/ipv6/netfilter/Kconfig | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
> index f3c8e2d918e1..425cb7a3571b 100644
> --- a/net/ipv6/netfilter/Kconfig
> +++ b/net/ipv6/netfilter/Kconfig
> @@ -8,7 +8,14 @@ menu "IPv6: Netfilter Configuration"
>  
>  # old sockopt interface and eval loop
>  config IP6_NF_IPTABLES_LEGACY
> -	tristate
> +	tristate "Legacy IP6 tables support"
> +	depends on INET && IPV6
> +	select NETFILTER_XTABLES
> +	default n
> +	help
> +	  ip6tables is a legacy packet classification.

                                Is "packet classifier" the right term?

I can mangle this patch before applying, no need to send one more.

Thanks.

> +	  This is not needed if you are using iptables over nftables
> +	  (iptables-nft).
>  
>  config NF_SOCKET_IPV6
>  	tristate "IPv6 socket lookup support"
> -- 
> 2.43.5
> 
