Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C37172BDD;
	Fri, 21 Jun 2024 11:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718970246; cv=none; b=QTZ+lOClmQ+Y0XvaU5qrX53CJhMjaQIFPujxCKMzL6MBrBOsVWjdHXPEmQzzEhevlxJU1J/uosZw69Npzb8XVjX+r4YrwJrF5ZbSMEWByJW0LiYioMjmmNrdkhbZqRDneXlCWi4rRhAHql1lZhI7XpDGHM3z9g54PrABOJehgUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718970246; c=relaxed/simple;
	bh=5U/twcyxaoe03rH0mYq7ye7EeNzyf5UN/ga7u1iBxQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RLBIdU1hMioAsWa+jy8iIvZyrJZLT7d4E5co1A0c+DhlUvWBjNMyMi1QZzMbE+oBCzQiZ7uPnFPq0An+jPE/SL3R4hY31HaehPmCGFBhotwIKwXKSFRR1tDoPH9Kgc1uA9OX3vMbUPg8/TxClebmlPyxd3fhG8G6a0+CCYE35B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=45678 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sKcgC-000OiP-Nz; Fri, 21 Jun 2024 13:43:47 +0200
Date: Fri, 21 Jun 2024 13:43:42 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jianguo Wu <wujianguo106@163.com>
Cc: LKML <linux-kernel@vger.kernel.org>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: fix undefined reference to
 'netfilter_lwtunnel_*' when CONFIG_SYSCTL=n
Message-ID: <ZnVnbv9sBtmflZj-@calendula>
References: <24ac3144-c6bc-4fd9-b592-d1a88505e65a@163.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <24ac3144-c6bc-4fd9-b592-d1a88505e65a@163.com>
X-Spam-Score: -1.9 (-)

Cc'ing netfilter-devel

On Fri, Jun 21, 2024 at 10:41:13AM +0800, Jianguo Wu wrote:
> From: Jianguo Wu <wujianguo@chinatelecom.cn>
> 
> if CONFIG_SYSFS is not enabled in config, we get the below compile error,
> 
> All errors (new ones prefixed by >>):
> 
>    csky-linux-ld: net/netfilter/core.o: in function `netfilter_init':
>    core.c:(.init.text+0x42): undefined reference to `netfilter_lwtunnel_init'
> >> csky-linux-ld: core.c:(.init.text+0x56): undefined reference to `netfilter_lwtunnel_fini'
> >> csky-linux-ld: core.c:(.init.text+0x70): undefined reference to `netfilter_lwtunnel_init'
>    csky-linux-ld: core.c:(.init.text+0x78): undefined reference to `netfilter_lwtunnel_fini'
> 
> Fixes: a2225e0250c5 ("netfilter: move the sysctl nf_hooks_lwtunnel into the netfilter core")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202406210511.8vbByYj3-lkp@intel.com/
> Closes: https://lore.kernel.org/oe-kbuild-all/202406210520.6HmrUaA2-lkp@intel.com/
> Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
> ---
>  net/netfilter/nf_hooks_lwtunnel.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/netfilter/nf_hooks_lwtunnel.c b/net/netfilter/nf_hooks_lwtunnel.c
> index 7cdb59bb4459..d8ebebc9775d 100644
> --- a/net/netfilter/nf_hooks_lwtunnel.c
> +++ b/net/netfilter/nf_hooks_lwtunnel.c
> @@ -117,4 +117,7 @@ void netfilter_lwtunnel_fini(void)
>  {
>  	unregister_pernet_subsys(&nf_lwtunnel_net_ops);
>  }
> +#else
> +int __init netfilter_lwtunnel_init(void) { return 0; }
> +void netfilter_lwtunnel_fini(void) {}
>  #endif /* CONFIG_SYSCTL */
> -- 
> 1.8.3.1
> 
