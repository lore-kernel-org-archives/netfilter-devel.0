Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FB51E4A0
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Feb 2024 00:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707350689; cv=none; b=L5W0jfgCywKyWyMECi08Wp6Vlw3ldkYMOBOEDNPw8TVL1P+dXMnTRmd06L8uczS9bJOqlIEm4UR9nfxjySiFzW0CF6s1QY+kxxrpoC2/1zFXBN6LBT3AKOWVzEMDkKt+aK6RtwZSegAhWMZvDDtCGSxw6wZHXExIRRZq6R92UXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707350689; c=relaxed/simple;
	bh=9X8YBnjYzbCgLQaSL09I2YXIs5lGMRgnS0zkU27b3Dg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BwYye3JDpti4IZ3T5T2h5bMJRVZks1u47AjIu8mbBUf99zdMgx+LsI6YgTs57ZMY7HLlF7IoFlujIv4ob70F+eLGoGAZwz1hXk4pPLXxvwDjRZyaExh07k6LpmiXn+6dAubW+EyLisMZhcgQmShcd/OVWj3SZi/03p1cFgkCt8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kwlmJPFM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kwlmJPFM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=7G2+5/tNhua0aN46U6MVwTPeEhpgA5+vSI4xDIUi65U=; b=kwlmJPFMLFnjJqKIaH1PByjgWa
	Q9dL0dTyGUnXP+axxWamcovb9DPKOH8g/Htby+ZvILhAGqEyFxzFMN/BzXbozuO/C8AcD7K+2EyXU
	8XSmawppotUNFWw8X51hr09oBC+tHyU/BZLbTVI0w4hPyjEXrIIwXkB8h1yHl2TTRSUbY4ZqelPlf
	yjrp93O2cav3AwtPJtdi0A8mM4m/C2e65U71SD22Zy4SR1EDd9kcj/UFx/3IgT1mA1mmPrdIJCHNj
	QHN9JhqX93RE/qZKPIo8DCGouVt0CO+a9C4jxLNlZgky4NtC+pLd4HD7o3Brfl2S6oK1bKJXjhabj
	NWIwVmVQ==;
Received: from [50.53.50.0] (helo=[192.168.254.15])
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rXruI-0000000CH2i-0i81;
	Thu, 08 Feb 2024 00:04:46 +0000
Message-ID: <2b617685-3524-4ae8-83fa-b5455c433a53@infradead.org>
Date: Wed, 7 Feb 2024 16:04:43 -0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next] netfilter: xtables: fix up kconfig dependencies
Content-Language: en-US
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc: kernel test robot <lkp@intel.com>
References: <20240206135556.11088-1-fw@strlen.de>
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20240206135556.11088-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/6/24 05:55, Florian Westphal wrote:
> Randy Dunlapt reports arptables build failure:
> arp_tables.c:(.text+0x20): undefined reference to `xt_find_table'
> 
> ... because recent change removed a 'select' on the xtables core.
> Add a "depends" clause on arptables to resolve this.
> 
> Kernel test robot reports another build breakage:
> iptable_nat.c:(.text+0x8): undefined reference to `ipt_unregister_table_exit'
> 
> ... because of a typo, the nat table selected ip6tables.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Fixes: a9525c7f6219 ("netfilter: xtables: allow xtables-nft only builds")
> Fixes: 4654467dc7e1 ("netfilter: arptables: allow xtables-nft only builds")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

Thanks.


> ---
>  net/ipv4/netfilter/Kconfig | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
> index 783523087281..8f6e950163a7 100644
> --- a/net/ipv4/netfilter/Kconfig
> +++ b/net/ipv4/netfilter/Kconfig
> @@ -217,7 +217,7 @@ config IP_NF_NAT
>  	default m if NETFILTER_ADVANCED=n
>  	select NF_NAT
>  	select NETFILTER_XT_NAT
> -	select IP6_NF_IPTABLES_LEGACY
> +	select IP_NF_IPTABLES_LEGACY
>  	help
>  	  This enables the `nat' table in iptables. This allows masquerading,
>  	  port forwarding and other forms of full Network Address Port
> @@ -329,6 +329,7 @@ config NFT_COMPAT_ARP
>  config IP_NF_ARPFILTER
>  	tristate "arptables-legacy packet filtering support"
>  	select IP_NF_ARPTABLES
> +	depends on NETFILTER_XTABLES
>  	help
>  	  ARP packet filtering defines a table `filter', which has a series of
>  	  rules for simple ARP packet filtering at local input and

-- 
#Randy
