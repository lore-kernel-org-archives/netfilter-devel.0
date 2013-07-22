From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [xtables-arptables PATCH 3/4] nft: nft_xtables_config_load()
 called only in nft_init()
Date: Mon, 22 Jul 2013 18:41:12 +0300
Message-ID: <51ED5298.1090501@linux.intel.com>
References: <20130716222925.13253.93123.stgit@nftables> <20130716223053.13253.90159.stgit@nftables>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:64180 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755829Ab3GVPlh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Jul 2013 11:41:37 -0400
In-Reply-To: <20130716223053.13253.90159.stgit@nftables>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Giuseppe,

I forgot to mention:

> 	h->tables = tables;

Provide tables as a parameter. Here you always take nft.c one. This 
won't work for arptables.

>   
> +	/* If built-in chains don't exist for this table, create them */
> +	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0) {
> +		int i;
> +

Then do the for loop if only h->tables != NULL :

> +		for (i=0; i<TABLES_MAX; i++)
> +			if (h->tables[i].name != NULL)
> +				nft_chain_builtin_init(h, h->tables[i].name, NULL, NF_ACCEPT);

