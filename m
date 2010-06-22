From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] net-next-2.6, Complete deprecation of CONFIG_NF_CT_ACCT
Date: Tue, 22 Jun 2010 08:12:42 +0200
Message-ID: <4C20545A.90405@trash.net>
References: <20100618175206.2E1CBF88CE@sepang.rtg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, ole@ans.pl
To: Tim Gardner <timg@tpi.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40776 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab0FVGMp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jun 2010 02:12:45 -0400
In-Reply-To: <20100618175206.2E1CBF88CE@sepang.rtg.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Tim Gardner wrote:
> Hi,
>
> I noticed some noise in my server log, so I thought it might be time to
> finish this deprecation. One concern I have is about xt_connbytes. The
> Kconfig for NETFILTER_XT_MATCH_CONNBYTES used to 'SELECT NF_CT_ACCT'
> which forced nf_conntrack.acct=1. As long as the value of NF_CT_ACCT_DEFAULT
> remains 1, then xt_connbytes should be OK.
>   

Yeah, but we need to take care of the other case anyways. As I've
repeatedly stated, connbytes needs to enable accounting when the
first rule using it is added.

You also don't need to update the defconfigs, architecture maintainers
can take care of that.
> rtg
> ---------------------
>
> >From 2f62effce6406eae74f4089cca322615c5e2a13d Mon Sep 17 00:00:00 2001
> From: Tim Gardner <tim.gardner@canonical.com>
> Date: Fri, 18 Jun 2010 10:40:32 -0600
> Subject: [PATCH] netfilter: Complete the deprecation of CONFIG_NF_CT_ACCT
>
> CONFIG_NF_CT_ACCT has been deprecated for awhile and
> was originally scheduled for removal by 2.6.29.
>
> Removing support for this config option also stops
> this deprecation warning message in the kernel log.
>
> [   61.669627] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
> [   61.669850] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
> [   61.669852] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
> [   61.669853] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
>
> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> index 413ed24..4ec72ee 100644
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -40,27 +40,6 @@ config NF_CONNTRACK
>  
>  if NF_CONNTRACK
>  
> -config NF_CT_ACCT
> -	bool "Connection tracking flow accounting"
> -	depends on NETFILTER_ADVANCED
> -	help
> -	  If this option is enabled, the connection tracking code will
> -	  keep per-flow packet and byte counters.
> -
> -	  Those counters can be used for flow-based accounting or the
> -	  `connbytes' match.
> -
> -	  Please note that currently this option only sets a default state.
> -	  You may change it at boot time with nf_conntrack.acct=0/1 kernel
> -	  parameter or by loading the nf_conntrack module with acct=0/1.
> -
> -	  You may also disable/enable it on a running system with:
> -	   sysctl net.netfilter.nf_conntrack_acct=0/1
> -
> -	  This option will be removed in 2.6.29.
> -
> -	  If unsure, say `N'.
> -
>  config NF_CONNTRACK_MARK
>  	bool  'Connection mark tracking support'
>  	depends on NETFILTER_ADVANCED
> @@ -630,7 +609,6 @@ config NETFILTER_XT_MATCH_CONNBYTES
>  	tristate  '"connbytes" per-connection counter match support'
>  	depends on NF_CONNTRACK
>  	depends on NETFILTER_ADVANCED
> -	select NF_CT_ACCT
>  	help
>  	  This option adds a `connbytes' match, which allows you to match the
>  	  number of bytes and/or packets for each direction within a connection.
> diff --git a/net/netfilter/nf_conntrack_acct.c b/net/netfilter/nf_conntrack_acct.c
> index ab81b38..57059aa 100644
> --- a/net/netfilter/nf_conntrack_acct.c
> +++ b/net/netfilter/nf_conntrack_acct.c
> @@ -17,11 +17,7 @@
>  #include <net/netfilter/nf_conntrack_extend.h>
>  #include <net/netfilter/nf_conntrack_acct.h>
>  
> -#ifdef CONFIG_NF_CT_ACCT
>  #define NF_CT_ACCT_DEFAULT 1
> -#else
> -#define NF_CT_ACCT_DEFAULT 0
> -#endif
>  
>  static int nf_ct_acct __read_mostly = NF_CT_ACCT_DEFAULT;
>  
> @@ -114,12 +110,6 @@ int nf_conntrack_acct_init(struct net *net)
>  	net->ct.sysctl_acct = nf_ct_acct;
>  
>  	if (net_eq(net, &init_net)) {
> -#ifdef CONFIG_NF_CT_ACCT
> -	printk(KERN_WARNING "CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use\n");
> -		printk(KERN_WARNING "nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or\n");
> -		printk(KERN_WARNING "sysctl net.netfilter.nf_conntrack_acct=1 to enable it.\n");
> -#endif
> -
>  		ret = nf_ct_extend_register(&acct_extend);
>  		if (ret < 0) {
>  			printk(KERN_ERR "nf_conntrack_acct: Unable to register extension\n");
>   

