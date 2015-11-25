From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft]: fix some bugs of return value
Date: Wed, 25 Nov 2015 14:03:39 +0100
Message-ID: <20151125130339.GA17224@salvia>
References: <0A900C78B9F2324AB7F4F7A51D1A2F8577977E97@szxema505-mbs.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Linmujia <linmujia@huawei.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40491 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbbKYNDr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 08:03:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 4FA111324CB
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 14:03:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3E9B7DA7FF
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 14:03:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C9756DA7E0
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 14:03:40 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <0A900C78B9F2324AB7F4F7A51D1A2F8577977E97@szxema505-mbs.china.huawei.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 24, 2015 at 09:00:21AM +0000, Linmujia wrote:
> 
> linmujia - Nov. 24, 2015, 04:03 p.m.
> 
> Signed-off-by: linmujia <linmujia@huawei.com>
> ---
> hello ,i reviewed nftables code and found some bugs of return value.
> 
> Thanks!
> 
> 
> 
> Patch
> 
> diff --git a/src/netlink.c b/src/netlink.c
> index 974afb1..c555621 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -307,6 +307,8 @@ static void netlink_gen_verdict(const struct expr *expr,
>  		strncpy(data->chain, expr->chain, NFT_CHAIN_MAXNAMELEN);
>  		data->chain[NFT_CHAIN_MAXNAMELEN-1] = '\0';
>  		break;
> +	default:
> +		BUG("invalid verdict value %u\n", expr->verdict);
>  	}
>  }
>  
> @@ -467,7 +469,7 @@ static int list_rule_cb(struct nftnl_rule *nlr, void *arg)
>  	if (h->family != family ||
>  	    strcmp(table, h->table) != 0 ||
>  	    (h->chain && strcmp(chain, h->chain) != 0))
> -		return 0;
> +		return -1;

I'm not sure I understand your intention, but this is not OK.

The iteration stops if we return -1, if we return 0 we keep iterating
over the list of objects to find a matching.

