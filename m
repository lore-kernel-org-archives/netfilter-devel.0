From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [PATCH] netfilter: nf_tables: replace built-in tables by chain
 types
Date: Mon, 05 Nov 2012 14:57:16 +0200
Message-ID: <5097B7AC.3010206@linux.intel.com>
References: <1352054018-4648-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56724 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281Ab2KEM5S (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Nov 2012 07:57:18 -0500
In-Reply-To: <1352054018-4648-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Don't know why, but git cannot apply properly the patch at once. Though, 
nothing seems to prevent such thing.
Anyway:

> @@ -1807,6 +1793,10 @@ static int __init nf_tables_module_init(void)
>   	if (err<  0)
>   		goto err2;
>
> +	nft_register_chain_type(&filter_ipv4);
> +	nft_register_chain_type(&filter_ipv6);
> +	nft_register_chain_type(&filter_bridge);
> +
>   	pr_info("nf_tables: (c) 2007-2009 Patrick McHardy<kaber@trash.net>\n");
>   	return 0;
>
> @@ -1818,6 +1808,9 @@ err1:
>
>   static void __exit nf_tables_module_exit(void)
>   {
> +	nft_unregister_chain_type(&filter_ipv4);
> +	nft_unregister_chain_type(&filter_ipv6);
> +	nft_unregister_chain_type(&filter_bridge);
>   	nfnetlink_subsys_unregister(&nf_tables_subsys);
>   	nf_tables_core_module_exit();
>   }
> -- 

filter_bridge declaration is missing.

Tomasz
