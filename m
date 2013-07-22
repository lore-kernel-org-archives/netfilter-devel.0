From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [xtables-arptables PATCH 0/4] nft changes for xtables-arptables
Date: Mon, 22 Jul 2013 18:43:36 +0300
Message-ID: <51ED5328.90405@linux.intel.com>
References: <20130716222925.13253.93123.stgit@nftables>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5920 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932155Ab3GVPnk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Jul 2013 11:43:40 -0400
In-Reply-To: <20130716222925.13253.93123.stgit@nftables>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Giuseppe,

You need to rework patch 3 so it will fit with your future arptables 
bootstrap.

Patch 1, 2 and 4 are fine.

Cheers,

Tomasz

> The following series implements changes in nft code that permit
> to reuse some functions in other tool (like xtables-arptables).
>
> I changed nft.h, now struct nft_handle gets a struct builtin_table
> pointer used in functions to works with a properly tables and not
> with tables declared in nft.c.
>
> ---
>
> Giuseppe Longo (4):
>        nft: add builtin_table pointer
>        nft: search builtin tables via nft_handle tables pointer
>        nft: nft_xtables_config_load() called only in nft_init()
>        nft: make functions public
>
>
>
>   iptables/nft.c |   77 ++++++++++++++++++--------------------------------------
>   iptables/nft.h |   42 +++++++++++++++++++++++++++++++
>   2 files changed, 67 insertions(+), 52 deletions(-)
>
> --
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

