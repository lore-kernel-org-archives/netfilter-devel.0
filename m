From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [iptables-nftables PATCH 3/5] nft: nft_xtables_config_load()
 called only in nft_init()
Date: Tue, 30 Jul 2013 10:05:05 +0300
Message-ID: <51F765A1.4040909@linux.intel.com>
References: <1374836719-27596-1-git-send-email-giuseppelng@gmail.com> <1374836719-27596-3-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:29520 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127Ab3G3HFJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Jul 2013 03:05:09 -0400
In-Reply-To: <1374836719-27596-3-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Giuseppe,

> +	/* If built-in chains don't exist for this table, create them */
> +	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0) {
> +		int i;
> +
> +		for (i = 0; i < TABLES_MAX; i++)
> +			nft_chain_builtin_init(h, h->tables[i].name,
> +					       NULL, NF_ACCEPT);

There is a bug here. While testing your arpatbles bootstrap: arp own 
only filter talbe, so here you should check if h->tables[i].name is not 
NULL.
Keep in mind that the loop should continue, one might not have a MANGLE 
table but still own a RAW table for instance.

Fix this, and resend the patches 3-4-5  (take the patch 4 I sent yesterday)

Tomasz
