From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] iptables/nft-shared.c: kill add_*() invflags
 parameter
Date: Tue, 11 Nov 2014 20:47:39 +0100
Message-ID: <20141111194739.GA6293@salvia>
References: <20141111183028.5708.94480.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, giuseppelng@gmail.com
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59680 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbaKKTpz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Nov 2014 14:45:55 -0500
Content-Disposition: inline
In-Reply-To: <20141111183028.5708.94480.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 11, 2014 at 07:30:28PM +0100, Arturo Borrero Gonzalez wrote:
> diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
> index 468da5c..4872226 100644
> --- a/iptables/nft-shared.h
> +++ b/iptables/nft-shared.h
> @@ -38,6 +38,12 @@
>  
>  struct xtables_args;
>  
> +#define NFT_INVFLAGS2CMP(op, invflags, flag)	\
> +	if (invflags & flag)			\
> +		op = NFT_CMP_NEQ;		\
> +	else					\
> +		op = NFT_CMP_EQ;		\

No macros please, use a function instead and place it in iptables/nft.c
