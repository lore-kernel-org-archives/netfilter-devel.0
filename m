From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH libnftnl 1/3] expr: add dup expression support
Date: Mon, 17 Aug 2015 14:24:20 +0100
Message-ID: <20150817132417.GA7964@macbook.localdomain>
References: <1439778258-7546-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60982 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbbHQNYb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Aug 2015 09:24:31 -0400
Content-Disposition: inline
In-Reply-To: <1439778258-7546-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 17.08, Pablo Neira Ayuso wrote:
> index a99e6a9..cf4a1ce 100644
> --- a/include/linux/netfilter/nf_tables.h
> +++ b/include/linux/netfilter/nf_tables.h
> @@ -936,6 +936,20 @@ enum nft_redir_attributes {
>  #define NFTA_REDIR_MAX		(__NFTA_REDIR_MAX - 1)
>  
>  /**
> + * enum nft_tee_attributes - nf_tables tee expression netlink attributes
> + *
> + * @NFTA_DUP_SREG_ADDR: source register of destination (NLA_U32: nft_registers)
> + * @NFTA_DUP_SREG_DEV: output interface name (NLA_U32: nft_register)
> + */
> +enum nft_tee_attributes {

Shouldn't these be called nft_dup_attributes?

> +	NFTA_DUP_UNSPEC,
> +	NFTA_DUP_SREG_ADDR,
> +	NFTA_DUP_SREG_DEV,
> +	__NFTA_DUP_MAX
> +};
> +#define NFTA_DUP_MAX		(__NFTA_DUP_MAX - 1)
