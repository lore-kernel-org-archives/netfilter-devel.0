From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] payload: fix transport matching with no network
 layer info in bridge family
Date: Fri, 26 Jun 2015 10:54:41 +0200
Message-ID: <20150626085441.GB10981@acer.localdomain>
References: <1435308301-15867-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33803 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbbFZIyo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jun 2015 04:54:44 -0400
Content-Disposition: inline
In-Reply-To: <1435308301-15867-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26.06, Pablo Neira Ayuso wrote:
>  # nft --debug=netlink add rule bridge filter input tcp dport 22
>  bridge filter input
>   [ meta load l4proto => reg 1 ]
>   [ cmp eq reg 1 0x00000006 ]
>   [ payload load 2b @ transport header + 2 => reg 1 ]
>   [ cmp eq reg 1 0x00001600 ]
> 
> Reported-by: Eric Leblond <eric@regit.org>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  src/payload.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/src/payload.c b/src/payload.c
> index 08578fd..e67ef17 100644
> --- a/src/payload.c
> +++ b/src/payload.c
> @@ -219,6 +219,9 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
>  			case PROTO_BASE_LL_HDR:
>  				desc = &proto_eth;
>  				break;
> +			case PROTO_BASE_TRANSPORT_HDR:
> +				desc = &proto_inet_service;
> +				break;

Just a very minor issue - the switch statement for NFPROTO_INET
just above uses the opposite ordering. Would increase readbility
to use the same for both, and I actually LL then TRANSPORT.

>  			default:
>  				break;
>  			}
> -- 
> 1.7.10.4
> 
