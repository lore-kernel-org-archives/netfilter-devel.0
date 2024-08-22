Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932681C9DCD
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Aug 2024 13:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724332828; cv=none; b=oDUzgTRpN2mOAapJ+GrVIec6Umdzv+7lCcLM2cQwOCtTQge8+7q8ZcHE/u6gkOveEavHfcwH/Lle4m6y4dDfUmDeNtlD82GaDP3Q022zBgtR3b+WDLotG/CGd7+Le8wBMm+B4u8P8kyptHPdaF4X5fd87doGKtgWeReQuMXRMZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724332828; c=relaxed/simple;
	bh=G+F8Q7iciumT75PemkmmKXMSdU0RXfQcwnQf6Gww1FA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jC2WAGL/B9s4uBYY12b2mxJR9egaemxqAIkab4qVymWJfSETa1kgIu6fKgjnM1hYcjYeRuJjnEfwNwV/v47aaAoyDChhVNZBk5YcCJYNvqz55iPdLNjnDptS7cnvjzuzX1AbY4NFw7qKSRE1LEt50Xa73yEMVoCcbT8gEPMiQBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sh7ji-0006sA-8X; Thu, 22 Aug 2024 15:20:22 +0200
Date: Thu, 22 Aug 2024 15:20:22 +0200
From: Florian Westphal <fw@strlen.de>
To: Breno Leitao <leitao@debian.org>
Cc: Florian Westphal <fw@strlen.de>, rbc@meta.com,
	netfilter-devel@vger.kernel.org
Subject: Re: netfilter: Kconfig: IP6_NF_IPTABLES_LEGACY old =y behaviour
 question
Message-ID: <20240822132022.GA25665@breakpoint.cc>
References: <Zsb+YHrLklrTCrly@gmail.com>
 <20240822112339.GA21472@breakpoint.cc>
 <Zscy83HM2TlwkSDq@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zscy83HM2TlwkSDq@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Breno Leitao <leitao@debian.org> wrote:
> On Thu, Aug 22, 2024 at 01:23:39PM +0200, Florian Westphal wrote:
> > Breno Leitao <leitao@debian.org> wrote:
> > > Hello Florian,
> > > 
> > > I am rebasing my workflow in into a new kernel, and I have a question
> > > that you might be able to help me. It is related to
> > > IP6_NF_IPTABLES_LEGACY Kconfig, and the change in a9525c7f6219cee9
> > > ("netfilter: xtables: allow xtables-nft only builds").
> > > 
> > > In my kernel before this change, I used to have ip6_tables "module" as
> > > builtin (CONFIG_IP6_NF_IPTABLES=y), and all the other dependencies as
> > > modules, such as IP6_NF_FILTER=m, IP6_NF_MANGLE=m, IP6_NF_RAW=m.
> > > 
> > > After the mentioned commit above, I am not able to have ip6_tables set
> > > as a builtin (=y) anymore, give that it is a "hidden" configuration, and
> > > the only way is to change some of the selectable dependencies
> > > (IP6_NF_RAW for insntance) to be a built-in (=y).
> > > 
> > > That said, do you know if I can keep the ip6_tables as builtin without
> > > changing any of the selectable dependencies configuration. In other
> > > words, is it possible to keep the old behaviour (ip6_table builtin and
> > > the dependenceis as modules) with the new IP6_NF_IPTABLES_LEGACY
> > > configuration?
> > 
> > No.  But why would you need it?
> 
> In certain environments, iptables needs to run, but there is *no*
> permission to load modules.
> 
> For those cases, I have CONFIG_IP6_NF_IPTABLES configured as y in
> previous kernels, and now it becomes a "m", which doesn't work because
> iptables doesn't have permission to load modules, returning:
> 
> 	$ ip6tables -L
> 	modprobe: FATAL: Module ip6_tables not found in directory /lib/modules/....
> 	ip6tables v1.8.10 (legacy): can't initialize ip6tables table `filter': Table does not exist (do you need to insmod?)
> 	Perhaps ip6tables or your kernel needs to be upgraded.

Hmm, but how can that work?  If you can't load modules, you can't load
ip6t_filter either.

And if thats builtin, then IP6_NF_IPTABLES_LEGACY is supposed to become
=y too.

> > You could make a patch for nf-next that exposes those symbols as per description
> > in a9525c7f6219cee9284c0031c5930e8d41384677, i.e. with 'depends on'
> > change.
> 
> Sure, I am happy to do it, but I would like to understand a bit better
> before. Does it mean we make IP_NF_IPTABLES_LEGACY selectable by the
> user, and changes the dependable configs from "selects" to "depends on"?
> Something as the following (not heavily tested)?
> 
> Thanks for the quick answer!
> --breno
> 
> Author: Breno Leitao <leitao@debian.org>
> Date:   Thu Aug 22 05:35:41 2024 -0700
>     netfilter: Make IP_NF_IPTABLES_LEGACY selectable
>     
>     This option makes IP_NF_IPTABLES_LEGACY user selectable, giving
>     users the option to configure iptables without enabling any other
>     config.
>     
>     Suggested-by: Florian Westphal <fw@strlen.de>
>     Signed-off-by: Breno Leitao <leitao@debian.org>
> 
> diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
> index 1b991b889506..b5ff14a5272a 100644
> --- a/net/ipv4/netfilter/Kconfig
> +++ b/net/ipv4/netfilter/Kconfig
> @@ -12,7 +12,11 @@ config NF_DEFRAG_IPV4
>  
>  # old sockopt interface and eval loop
>  config IP_NF_IPTABLES_LEGACY
> -	tristate
> +	tristate "Legacy IP tables support"
> +	default	n
> +	select NETFILTER_XTABLES
> +	help
> +	  iptables is a general, extensible packet identification legacy framework.

I would also add that this isn't needed for iptables-nft (iptables over
nftables api).

Otherwise, yes, something like that.
