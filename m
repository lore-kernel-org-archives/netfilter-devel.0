Return-Path: <SRS0=H0Uh=TP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90040C04E53
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 May 2019 10:46:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 602092084F
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 May 2019 10:46:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbfEOKqz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 May 2019 06:46:55 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:50490 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725953AbfEOKqz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 May 2019 06:46:55 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hQrQy-00027s-CI; Wed, 15 May 2019 12:46:52 +0200
Date:   Wed, 15 May 2019 12:46:52 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 2/2 nft] jump: Allow goto and jump to a variable using
 nft input files
Message-ID: <20190515104652.GZ4851@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org
References: <20190514211340.913-1-ffmancera@riseup.net>
 <20190514211340.913-2-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514211340.913-2-ffmancera@riseup.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Tue, May 14, 2019 at 11:13:40PM +0200, Fernando Fernandez Mancera wrote:
> This patch introduces the use of nft input files variables in 'jump' and 'goto'
> statements, e.g.
> 
> define dest = ber
> 
> add table ip foo
> add chain ip foo bar {type filter hook input priority 0;}
> add chain ip foo ber
> add rule ip foo ber counter
> add rule ip foo bar jump $dest
> 
> table ip foo {
> 	chain bar {
> 		type filter hook input priority filter; policy accept;
> 		jump ber
> 	}
> 
> 	chain ber {
> 		counter packets 71 bytes 6664
> 	}
> }
> 
> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
> ---
>  src/datatype.c     | 11 +++++++++++
>  src/parser_bison.y |  6 +++++-
>  2 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/src/datatype.c b/src/datatype.c
> index 6aaf9ea..7e9ec5e 100644
> --- a/src/datatype.c
> +++ b/src/datatype.c
> @@ -297,11 +297,22 @@ static void verdict_type_print(const struct expr *expr, struct output_ctx *octx)
>  	}
>  }
>  
> +static struct error_record *verdict_type_parse(const struct expr *sym,
> +					       struct expr **res)
> +{
> +	*res = constant_expr_alloc(&sym->location, &string_type,
> +				   BYTEORDER_HOST_ENDIAN,
> +				   (strlen(sym->identifier) + 1) * BITS_PER_BYTE,
> +				   sym->identifier);
> +	return NULL;
> +}
> +
>  const struct datatype verdict_type = {
>  	.type		= TYPE_VERDICT,
>  	.name		= "verdict",
>  	.desc		= "netfilter verdict",
>  	.print		= verdict_type_print,
> +	.parse		= verdict_type_parse,
>  };
>  
>  static const struct symbol_table nfproto_tbl = {
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index 69b5773..a955cb5 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -3841,7 +3841,11 @@ verdict_expr		:	ACCEPT
>  			}
>  			;
>  
> -chain_expr		:	identifier
> +chain_expr		:	variable_expr
> +			{
> +				$$ = $1;
> +			}

Are you sure this is needed? The provided code should be what bison does
by default if no body was given.

Cheers, Phil
