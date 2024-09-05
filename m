Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBB4153838;
	Thu,  5 Sep 2024 23:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725577324; cv=none; b=Kpowg77lxpMm2SKu2Z8gXkA21CsFiN/bv5Qwens7XS/hgpLeMYF2SCU9QAEh9B4Qyv79SkJ5ns0jC05yx4T7QrrS3YKAP3RqRiTfqreoEw+uSxW2f7LNO3ML6oD98rwu06FgUHw+ytcn/TohgfVqtxUrDIK3YcaYwHgkT0lK1mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725577324; c=relaxed/simple;
	bh=RNL6LHz2DxOzk/csE9S0QFF8BOlAyPNbBvo+l4Mnnmg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t4dLE0brWfDIzqHfHO3F6rlkwkHYupz9BXTwgtxKu40vKvj41tgPMavcVzaOFH7RLt5JTza34qWgJ5RfPdAHW63fOuWc+XugDOEelcpE81MANElttsuQXfFH6CklG2N2VCCnlRHv/VgILvHvYW41P1V9LDcEVYlteSdRg7Tn09I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [31.221.194.34] (port=25764 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1smLU4-00EAIh-88; Fri, 06 Sep 2024 01:01:50 +0200
Date: Fri, 6 Sep 2024 01:01:46 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Breno Leitao <leitao@debian.org>
Cc: fw@strlen.de, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, Jozsef Kadlecsik <kadlec@netfilter.org>,
	David Ahern <dsahern@kernel.org>, rbc@meta.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	"open list:NETFILTER" <coreteam@netfilter.org>
Subject: Re: [PATCH nf-next v4 1/2] netfilter: Make IP6_NF_IPTABLES_LEGACY
 selectable
Message-ID: <Zto4WmXldf6KzeQO@calendula>
References: <20240829161656.832208-1-leitao@debian.org>
 <20240829161656.832208-2-leitao@debian.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240829161656.832208-2-leitao@debian.org>
X-Spam-Score: -1.9 (-)

Hi,

On Thu, Aug 29, 2024 at 09:16:54AM -0700, Breno Leitao wrote:
> This option makes IP6_NF_IPTABLES_LEGACY user selectable, giving
> users the option to configure iptables without enabling any other
> config.

IUC this is to allow to compile iptables core built-in while allowing
extensions to be compiled as module? What is exactly the combination
you are trying to achieve which is not possible with the current
toggle?

Florian's motivation to add this knob is to allow to compile kernels
without iptables-legacy support.

One more comment below.

> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  net/ipv6/netfilter/Kconfig | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
> index f3c8e2d918e1..cbe88cc5b897 100644
> --- a/net/ipv6/netfilter/Kconfig
> +++ b/net/ipv6/netfilter/Kconfig
> @@ -8,7 +8,13 @@ menu "IPv6: Netfilter Configuration"
>  
>  # old sockopt interface and eval loop
>  config IP6_NF_IPTABLES_LEGACY
> -	tristate
> +	tristate "Legacy IP6 tables support"
> +	depends on INET && IPV6
> +	select NETFILTER_XTABLES
> +	default n
> +	help
> +	  ip6tables is a general, extensible packet identification legacy framework.

"packet classification" is generally the more appropriate and widely
used term for firewalls.

Maybe simply reword this description to ...

	  ip6tables is a legacy packet classification.

> +	  This is not needed if you are using iptables over nftables (iptables-nft).
>  
>  config NF_SOCKET_IPV6
>  	tristate "IPv6 socket lookup support"
> -- 
> 2.43.5
> 
