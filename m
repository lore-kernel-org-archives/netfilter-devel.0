From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC PATCH nf] netfilter: bridge: fix IPv6 packets not being
 bridged with CONFIG_IPV6=n
Date: Sun, 5 Jul 2015 23:53:34 +0200
Message-ID: <20150705215334.GA16864@breakpoint.cc>
References: <1436130933-17639-1-git-send-email-bernhard.thaler@wvnet.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, kadlec@blackhole.kfki.hu,
	netfilter-devel@vger.kernel.org
To: Bernhard Thaler <bernhard.thaler@wvnet.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57640 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752918AbbGEVxn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jul 2015 17:53:43 -0400
Content-Disposition: inline
In-Reply-To: <1436130933-17639-1-git-send-email-bernhard.thaler@wvnet.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bernhard Thaler <bernhard.thaler@wvnet.at> wrote:
> /sys/class/net/brXXX/bridge/nf_call_ip6tables and
> /proc/sys/net/bridge/bridge-nf-call-ip6tables can be set to 1 with
> CONFIG_IPV6=n. But br_nf_pre_routing_ipv6() is not available and
> ip6tables would not be usable as well.
> 
> Do not allow to set both flags to 1 with CONFIG_IPV6=n.
> 
> Change return value of placeholder for br_validate_ipv6() as it is
> used in br_nf_forward_ip() even with CONFIG_IPV6=n.
> 
> Fixes: 230ac490f7fba ("netfilter: bridge: split ipv6 code into separated file")
> Signed-off-by: Bernhard Thaler <bernhard.thaler@wvnet.at>
> ---
>  static inline unsigned int
> diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
> index d89f4fa..db0d038 100644
> --- a/net/bridge/br_netfilter_hooks.c
> +++ b/net/bridge/br_netfilter_hooks.c
> @@ -47,14 +47,22 @@
>  #ifdef CONFIG_SYSCTL
>  static struct ctl_table_header *brnf_sysctl_header;
>  static int brnf_call_iptables __read_mostly = 1;
> +#if IS_ENABLED(CONFIG_IPV6)

IS_ENABLED(IP6_NF_IPTABLES) ?

>  static struct ctl_table brnf_table[] = {
>  	{
>  		.procname	= "bridge-nf-call-arptables",
> @@ -985,7 +1004,7 @@ static struct ctl_table brnf_table[] = {
>  		.data		= &brnf_call_ip6tables,
>  		.maxlen		= sizeof(int),
>  		.mode		= 0644,
> -		.proc_handler	= brnf_sysctl_call_tables,
> +		.proc_handler	= brnf_sysctl_call_ip6tables,
>  	},

Might also make sense to not create the sysctl and sysfs entry in the
first place if no ip6tables is available.
