From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4 2/2 nf-next] netfilter: Add the missed return value
 check of nft_register_chain_type
Date: Mon, 12 Sep 2016 19:42:01 +0200
Message-ID: <20160912174201.GB30541@salvia>
References: <1473473070-7062-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41718 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751561AbcILRmG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 13:42:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D493F11E5A6
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 19:42:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C4B23115401
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 19:42:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 87B621150A9
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 19:42:02 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473473070-7062-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Sep 10, 2016 at 10:04:30AM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> There are some codes of netfilter module which did not check the return
> value of nft_register_chain_type. Add the checks now.
> 
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  v4: Cover the net/bridge, ipv4/netfilter, and ipv6/netfilter too;
>  v3: Split return value check of nft_register_chain_type as second patch
>  v2: Add all return value checks in netfilter module
>  v1: Initial patch
> 
>  net/bridge/netfilter/nf_tables_bridge.c | 14 +++++++++++---
>  net/ipv4/netfilter/nf_tables_arp.c      |  5 ++++-
>  net/ipv4/netfilter/nf_tables_ipv4.c     |  5 ++++-
>  net/ipv6/netfilter/nf_tables_ipv6.c     |  5 ++++-
>  net/netfilter/nf_tables_inet.c          |  5 ++++-
>  net/netfilter/nf_tables_netdev.c        | 14 +++++++++-----
>  6 files changed, 36 insertions(+), 12 deletions(-)
> 
> diff --git a/net/bridge/netfilter/nf_tables_bridge.c b/net/bridge/netfilter/nf_tables_bridge.c
> index a78c4e2..d226e8b 100644
> --- a/net/bridge/netfilter/nf_tables_bridge.c
> +++ b/net/bridge/netfilter/nf_tables_bridge.c
> @@ -207,13 +207,21 @@ static int __init nf_tables_bridge_init(void)
>  	int ret;
>  
>  	nf_register_afinfo(&nf_br_afinfo);
> -	nft_register_chain_type(&filter_bridge);
> +	ret = nft_register_chain_type(&filter_bridge);
> +	if (ret < 0)
> +		goto err1;
> +
>  	ret = register_pernet_subsys(&nf_tables_bridge_net_ops);
>  	if (ret < 0) {
> -		nft_unregister_chain_type(&filter_bridge);
> -		nf_unregister_afinfo(&nf_br_afinfo);
> +		goto err2;
>  	}

BTW, I have mangled this doesn't look like:

 	if (ret < 0) {
		goto err2;
 	}



>  	return ret;
> +
> +err2:
> +	nft_unregister_chain_type(&filter_bridge);
> +err1:
> +	nf_unregister_afinfo(&nf_br_afinfo);
> +	return ret;
>  }
>  
>  static void __exit nf_tables_bridge_exit(void)
> diff --git a/net/ipv4/netfilter/nf_tables_arp.c b/net/ipv4/netfilter/nf_tables_arp.c
> index cd84d42..b91ae8f 100644
> --- a/net/ipv4/netfilter/nf_tables_arp.c
> +++ b/net/ipv4/netfilter/nf_tables_arp.c
> @@ -80,7 +80,10 @@ static int __init nf_tables_arp_init(void)
>  {
>  	int ret;
>  
> -	nft_register_chain_type(&filter_arp);
> +	ret = nft_register_chain_type(&filter_arp);
> +	if (ret < 0)
> +		return ret;
> +
>  	ret = register_pernet_subsys(&nf_tables_arp_net_ops);
>  	if (ret < 0)
>  		nft_unregister_chain_type(&filter_arp);
> diff --git a/net/ipv4/netfilter/nf_tables_ipv4.c b/net/ipv4/netfilter/nf_tables_ipv4.c
> index e44ba3b..2840a29 100644
> --- a/net/ipv4/netfilter/nf_tables_ipv4.c
> +++ b/net/ipv4/netfilter/nf_tables_ipv4.c
> @@ -103,7 +103,10 @@ static int __init nf_tables_ipv4_init(void)
>  {
>  	int ret;
>  
> -	nft_register_chain_type(&filter_ipv4);
> +	ret = nft_register_chain_type(&filter_ipv4);
> +	if (ret < 0)
> +		return ret;
> +
>  	ret = register_pernet_subsys(&nf_tables_ipv4_net_ops);
>  	if (ret < 0)
>  		nft_unregister_chain_type(&filter_ipv4);
> diff --git a/net/ipv6/netfilter/nf_tables_ipv6.c b/net/ipv6/netfilter/nf_tables_ipv6.c
> index 30b22f4..340b978 100644
> --- a/net/ipv6/netfilter/nf_tables_ipv6.c
> +++ b/net/ipv6/netfilter/nf_tables_ipv6.c
> @@ -102,7 +102,10 @@ static int __init nf_tables_ipv6_init(void)
>  {
>  	int ret;
>  
> -	nft_register_chain_type(&filter_ipv6);
> +	ret = nft_register_chain_type(&filter_ipv6);
> +	if (ret < 0)
> +		return ret;
> +
>  	ret = register_pernet_subsys(&nf_tables_ipv6_net_ops);
>  	if (ret < 0)
>  		nft_unregister_chain_type(&filter_ipv6);
> diff --git a/net/netfilter/nf_tables_inet.c b/net/netfilter/nf_tables_inet.c
> index 6b5f762..f713cc2 100644
> --- a/net/netfilter/nf_tables_inet.c
> +++ b/net/netfilter/nf_tables_inet.c
> @@ -82,7 +82,10 @@ static int __init nf_tables_inet_init(void)
>  {
>  	int ret;
>  
> -	nft_register_chain_type(&filter_inet);
> +	ret = nft_register_chain_type(&filter_inet);
> +	if (ret < 0)
> +		return ret;
> +
>  	ret = register_pernet_subsys(&nf_tables_inet_net_ops);
>  	if (ret < 0)
>  		nft_unregister_chain_type(&filter_inet);
> diff --git a/net/netfilter/nf_tables_netdev.c b/net/netfilter/nf_tables_netdev.c
> index 673ec5f..2c2a17e 100644
> --- a/net/netfilter/nf_tables_netdev.c
> +++ b/net/netfilter/nf_tables_netdev.c
> @@ -222,21 +222,25 @@ static int __init nf_tables_netdev_init(void)
>  {
>  	int ret;
>  
> -	nft_register_chain_type(&nft_filter_chain_netdev);
> -	ret = register_pernet_subsys(&nf_tables_netdev_net_ops);
> +	ret = nft_register_chain_type(&nft_filter_chain_netdev);
>  	if (ret)
>  		goto err1;

And here, we can simply return ret;

This simplifies the patch. I have applied this with such
modifications.
