From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 014/103] netfilter: xtables: remove unneeded gotos in
 table error paths
Date: Mon, 10 Aug 2009 10:48:11 +0200
Message-ID: <4A7FDECB.1020304@trash.net>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de> <1249370787-17583-15-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59090 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbZHJIsP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2009 04:48:15 -0400
In-Reply-To: <1249370787-17583-15-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  net/ipv4/netfilter/arptable_filter.c   |    6 +-----
>  net/ipv4/netfilter/iptable_filter.c    |    6 +-----
>  net/ipv4/netfilter/iptable_mangle.c    |    6 +-----
>  net/ipv4/netfilter/iptable_raw.c       |    6 +-----
>  net/ipv4/netfilter/iptable_security.c  |    6 +-----
>  net/ipv6/netfilter/ip6table_filter.c   |    6 +-----
>  net/ipv6/netfilter/ip6table_mangle.c   |    6 +-----
>  net/ipv6/netfilter/ip6table_raw.c      |    6 +-----
>  net/ipv6/netfilter/ip6table_security.c |    6 +-----
>  9 files changed, 9 insertions(+), 45 deletions(-)
> 
> diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
> index 6ecfdae..87ecd3e 100644
> --- a/net/ipv4/netfilter/arptable_filter.c
> +++ b/net/ipv4/netfilter/arptable_filter.c
> @@ -127,11 +127,7 @@ static int __init arptable_filter_init(void)
>  
>  	ret = nf_register_hooks(arpt_ops, ARRAY_SIZE(arpt_ops));
>  	if (ret < 0)
> -		goto cleanup_table;
> -	return ret;
> -
> -cleanup_table:
> -	unregister_pernet_subsys(&arptable_filter_net_ops);
> +		unregister_pernet_subsys(&arptable_filter_net_ops);
>  	return ret;
>  }

This is pointless, anyone adding something to the init path
will have to undo your change. I'm not applying this.
