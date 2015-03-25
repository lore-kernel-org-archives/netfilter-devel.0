From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft PATCH 1/3] src: expose delinearize/linearize structures and
 stmt_error()
Date: Wed, 25 Mar 2015 19:23:19 +0000
Message-ID: <20150325192319.GC8065@acer.localdomain>
References: <20150325191556.13491.88761.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51373 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbbCYTXY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 15:23:24 -0400
Content-Disposition: inline
In-Reply-To: <20150325191556.13491.88761.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> diff --git a/src/evaluate.c b/src/evaluate.c
> index 7ecb793..c420cd4 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -36,10 +36,10 @@ static const char *byteorder_names[] = {
>  	[BYTEORDER_BIG_ENDIAN]		= "big endian",
>  };
>  
> -static int __fmtstring(4, 5) __stmt_binary_error(struct eval_ctx *ctx,
> -						 const struct location *l1,
> -						 const struct location *l2,
> -						 const char *fmt, ...)
> +int __fmtstring(4, 5) __stmt_binary_error(struct eval_ctx *ctx,
> +					  const struct location *l1,
> +					  const struct location *l2,
> +					  const char *fmt, ...)
>  {
>  	struct error_record *erec;
>  	va_list ap;

Lets move this to erec.c and rename it to __binary_error. Its only
in evaluate.c because it didn't use to have other users.
