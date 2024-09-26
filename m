Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C6A4F21D;
	Thu, 26 Sep 2024 15:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727363889; cv=none; b=LK059DGJ6nCtK9Pp7wPHhtDfsre7oN2ELlWLMOrlZzZUFXFeu6dB0tkBNNnRvi8hsdO4xR+05nnyJSpZ4kSH49VhBLt9l7oN/ZIn4L68j3YpYZvdfbFjc/wQn8caapaj30NC8P7jS5wY+28Mzj3Mb2I/LbQSjFGYwKz+eVMpqG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727363889; c=relaxed/simple;
	bh=TCL06OTau/rgWgOh2hhmMvRSYfdo/Vj+wi/zZJ/ezeM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ki0+JXgWJvSJ+4uEC/ivm2ICcLIgEP1jb6yyWGjP5RVt0/Ep2U6/IzgJJFtACauoBsIc0hGHvvypQxQLvBXtC0K2/30K6oVCjjCQVrHi1NsrBAb1MtdKBhPbPVrxOC3j5wttUxo4WbW+leel3f88qUsRJVITdxIIe/MR1X/9oa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=57678 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1stqFl-001gm6-C9; Thu, 26 Sep 2024 17:18:03 +0200
Date: Thu, 26 Sep 2024 17:18:00 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Breno Leitao <leitao@debian.org>
Cc: fw@strlen.de, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, rbc@meta.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v5 0/2] netfilter: Make IP_NF_IPTABLES_LEGACY
 selectable
Message-ID: <ZvV7KFHXx3V30HEH@calendula>
References: <20240909084620.3155679-1-leitao@debian.org>
 <Zuq12avxPonafdvv@calendula>
 <Zuq3ns-Ai05Hcooj@calendula>
 <ZvVBawvMot9nu2jE@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZvVBawvMot9nu2jE@gmail.com>
X-Spam-Score: -1.9 (-)

On Thu, Sep 26, 2024 at 04:11:39AM -0700, Breno Leitao wrote:
> Hello Pablo,
> 
> On Wed, Sep 18, 2024 at 01:21:02PM +0200, Pablo Neira Ayuso wrote:
> > Single patch to update them all should be fine.
> 
> I am planning to send the following patch, please let me know if you
> have any concern before I send it:
> 
> Author: Breno Leitao <leitao@debian.org>
> Date:   Thu Aug 29 02:51:02 2024 -0700
> 
>     netfilter: Make legacy configs user selectable
>     
>     This option makes legacy Netfilter Kconfig user selectable, giving users
>     the option to configure iptables without enabling any other config.

LGTM, a few cosmetic nitpicks below.

>     Make the following KConfig entries user selectable:
>      * BRIDGE_NF_EBTABLES_LEGACY
>      * IP_NF_ARPTABLES
>      * IP_NF_IPTABLES_LEGACY
>      * IP6_NF_IPTABLES_LEGACY
>     
>     Signed-off-by: Breno Leitao <leitao@debian.org>
> 
> diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
> index 104c0125e32e..b7bdb094f708 100644
> --- a/net/bridge/netfilter/Kconfig
> +++ b/net/bridge/netfilter/Kconfig
> @@ -41,7 +41,13 @@ config NF_CONNTRACK_BRIDGE
>  
>  # old sockopt interface and eval loop
>  config BRIDGE_NF_EBTABLES_LEGACY
> -	tristate
> +	tristate "Legacy EBTABLES support"
> +	depends on BRIDGE && NETFILTER_XTABLES
> +	default n
> +	help
> +	 Legacy ebtable packet/frame classifier.
                ^^^^^^^
                ebtables

> +	 This is not needed if you are using ebtables over nftables
> +	 (iptables-nft).
>  
>  menuconfig BRIDGE_NF_EBTABLES
>  	tristate "Ethernet Bridge tables (ebtables) support"
> diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
> index 1b991b889506..2c4d42b5bed1 100644
> --- a/net/ipv4/netfilter/Kconfig
> +++ b/net/ipv4/netfilter/Kconfig
> @@ -12,7 +12,13 @@ config NF_DEFRAG_IPV4
>  
>  # old sockopt interface and eval loop
>  config IP_NF_IPTABLES_LEGACY
> -	tristate
> +	tristate "Legacy IP tables support"
> +	default	n
> +	select NETFILTER_XTABLES
> +	help
> +	  iptables is a legacy packet classifier.
> +	  This is not needed if you are using iptables over nftables
> +	  (iptables-nft).
>  
>  config NF_SOCKET_IPV4
>  	tristate "IPv4 socket lookup support"
> @@ -318,7 +324,13 @@ endif # IP_NF_IPTABLES
>  
>  # ARP tables
>  config IP_NF_ARPTABLES
> -	tristate
> +	tristate "Legacy ARPTABLE support"
                         ^^^^^^^^
                         ARPTABLES

> +	depends on NETFILTER_XTABLES
> +	default n
> +	help
> +	  arptables is a legacy packet classifier.
> +	  This is not needed if you are using arptables over nftables
> +	  (iptables-nft).
>  
>  config NFT_COMPAT_ARP
>  	tristate
> diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
> index f3c8e2d918e1..e087a8e97ba7 100644
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
> +	  ip6tables is a legacy packet classifier.
> +	  This is not needed if you are using iptables over nftables
> +	  (iptables-nft).
>  
>  config NF_SOCKET_IPV6
>  	tristate "IPv6 socket lookup support"
