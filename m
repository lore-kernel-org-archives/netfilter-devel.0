Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8653630FC03
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Apr 2026 01:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775783376; cv=none; b=oLjISQlQB/zqzcCO1aIswH2D4uone0WMJGSoZMRQVpGWU4B2tZxqX9umfhWQDnHNk7hXpckRU1HMyfAJqn68bQVhP/0y2IZmgFMboNk44+TMB8jTVw5gKt5ndPbZdhGm+Y6MFvkOPdLrFPY9FYzae+cMekfiFM1l8aNPZUDjHIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775783376; c=relaxed/simple;
	bh=rEKxY158qoVYZaWkRY/EKl9Bx9A48OWusyfBE+owUQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M4pBCUwwhJFz0Tx+MK8TyAalu82ulXLPL2V5UuRiD/gJ6wVha5s5B2E4DVP70opGnZBoU6EdNgMt6DX8uZfUDUJWUzR4XduvaUKlOrpqxZd5doBY2ZUXW2QSMVII6HEYBIa0EsdBeAW5OX6vdeYnGOSassci8sIMgcXqdJvzpZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=HPIGTQnP; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="HPIGTQnP"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 3E4A260181;
	Fri, 10 Apr 2026 03:09:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1775783372;
	bh=NeWisyVl9RT6U8OhDZN5PaRyyQPrHBmQOPPV7n5f9qk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HPIGTQnPLaJ3Uq9XH/MO762T0pV8Oux+IN1mqmBbVJNpCcEjfb2X1Qsvr9+QIv+l4
	 X6u+LVLWeQ8QQU8frWfHZeBGq8RsDEczq4RVjuQWnNeT1riZ5J11R8YSxu5iIDqtq+
	 XsLX+Gi3cdgX/aXIRss6FgL5vf0WT1TayZmRuXgMNyMHGqCf/10hekEFqBj0yzz+Ig
	 pRRlJQMDCRHKe/jUfbX5q4XWhqbZ++3kgwJvU/N5SFIvNm+f87u4SaJCnB3F9nMX4k
	 QJ0gGx7pwPIMYfaXPP1tsPKXTw1S3ROWNXhsJyHCw1DkTWHZrx9SGmQJvVauq5jkvR
	 QMQMokl2PSOiw==
Date: Fri, 10 Apr 2026 03:09:29 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, phil@nwl.cc,
	fw@strlen.de
Subject: Re: [PATCH nf-next] netfilter: Kconfig: make NF_FLOW_TABLE_INET
 depend on NF_TABLES_INET
Message-ID: <adhNyRO3j4Fw5_ml@chamomile>
References: <20260326144246.4430-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260326144246.4430-1-fmancera@suse.de>

On Thu, Mar 26, 2026 at 03:42:46PM +0100, Fernando Fernandez Mancera wrote:
> As it is not possible to create an inet flowtable without a parent table
> on inet family, it makes sense that Kconfig NF_FLOW_TABLE_INET symbol
> depends on NF_TABLES_INET. This reduces the kernel image size a bit when
> compiling the kernel with CONFIG_IPV6=n.

The nf_flow_table_inet.c file also defines ipv4 and ipv6:

static struct nf_flowtable_type flowtable_ipv4 = {
        .family         = NFPROTO_IPV4,
        .init           = nf_flow_table_init,
        .setup          = nf_flow_table_offload_setup,
        .action         = nf_flow_rule_route_ipv4,
        .free           = nf_flow_table_free,
        .hook           = nf_flow_offload_ip_hook,
        .owner          = THIS_MODULE,
};

static struct nf_flowtable_type flowtable_ipv6 = {
        .family         = NFPROTO_IPV6,
        .init           = nf_flow_table_init,
        .setup          = nf_flow_table_offload_setup,
        .action         = nf_flow_rule_route_ipv6,
        .free           = nf_flow_table_free,
        .hook           = nf_flow_offload_ipv6_hook,
        .owner          = THIS_MODULE,
};

The file name is a bit misleading, someone decide to squash ipv4, ipv6
and _inet_ into the same file.

> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> ---
>  net/netfilter/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> index 6cdc994fdc8a..c50f2ad67b51 100644
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -717,6 +717,7 @@ endif # NF_TABLES
>  config NF_FLOW_TABLE_INET
>  	tristate "Netfilter flow table mixed IPv4/IPv6 module"
>  	depends on NF_FLOW_TABLE
> +	depends on NF_TABLES_INET
>  	help
>  	  This option adds the flow table mixed IPv4/IPv6 support.
>  
> -- 
> 2.53.0
> 
