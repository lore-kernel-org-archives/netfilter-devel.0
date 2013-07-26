From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [iptables-nftables PATCH] nft: load only the tables of the current
 family.
Date: Fri, 26 Jul 2013 15:04:27 +0300
Message-ID: <51F265CB.2020108@linux.intel.com>
References: <1374838625-29029-1-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5301 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756699Ab3GZMEa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jul 2013 08:04:30 -0400
In-Reply-To: <1374838625-29029-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Giuseppe,

> +	uint8_t table_family, chain_family;

just uint32_t no need to downsize, anyway nft_table_attr_get_u32 gives 
you uint32_t.

Rest is fine.

Tomasz
