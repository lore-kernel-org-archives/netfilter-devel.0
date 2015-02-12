From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nft_compat: fix sparse warning
Date: Thu, 12 Feb 2015 13:20:25 +0100
Message-ID: <20150212122025.GB3294@salvia>
References: <20150212101408.20533.19035.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52419 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755288AbbBLMRN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2015 07:17:13 -0500
Content-Disposition: inline
In-Reply-To: <20150212101408.20533.19035.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 12, 2015 at 11:14:09AM +0100, Arturo Borrero Gonzalez wrote:
> >> net/netfilter/nft_compat.c:140:37: sparse: incorrect type in assignment (different base types)
>    net/netfilter/nft_compat.c:140:37:    expected restricted __be16 [usertype] ethproto
>    net/netfilter/nft_compat.c:140:37:    got unsigned char [unsigned] [usertype] proto
> >> net/netfilter/nft_compat.c:351:37: sparse: incorrect type in assignment (different base types)
>    net/netfilter/nft_compat.c:351:37:    expected restricted __be16 [usertype] ethproto
>    net/netfilter/nft_compat.c:351:37:    got unsigned char [unsigned] [usertype] proto

This is spotting a more serious problem. The existing code is trimming
the ethernet protocol field to u8. We should use u16 all around the
code and then force the casting to calm down sparse.

> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  net/netfilter/nft_compat.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
> index c598f74..b5dc651 100644
> --- a/net/netfilter/nft_compat.c
> +++ b/net/netfilter/nft_compat.c
> @@ -137,7 +137,7 @@ nft_target_set_tgchk_param(struct xt_tgchk_param *par,
>  		entry->e6.ipv6.invflags = inv ? IP6T_INV_PROTO : 0;
>  		break;
>  	case NFPROTO_BRIDGE:
> -		entry->ebt.ethproto = proto;
> +		entry->ebt.ethproto = (__force __be16)proto;
>  		entry->ebt.invflags = inv ? EBT_IPROTO : 0;
>  		break;
>  	}
> @@ -348,7 +348,7 @@ nft_match_set_mtchk_param(struct xt_mtchk_param *par, const struct nft_ctx *ctx,
>  		entry->e6.ipv6.invflags = inv ? IP6T_INV_PROTO : 0;
>  		break;
>  	case NFPROTO_BRIDGE:
> -		entry->ebt.ethproto = proto;
> +		entry->ebt.ethproto = (__force __be16)proto;
>  		entry->ebt.invflags = inv ? EBT_IPROTO : 0;
>  		break;
>  	}
> 
