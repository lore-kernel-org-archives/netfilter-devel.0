From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft RFC] datatype: add time type parser and adapt output
Date: Thu, 16 Jan 2014 21:05:56 +0000
Message-ID: <20140116210556.GA24079@macbook.localnet>
References: <1389906062-27409-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59229 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaAPVGA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 16:06:00 -0500
Content-Disposition: inline
In-Reply-To: <1389906062-27409-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 16, 2014 at 10:01:02PM +0100, Pablo Neira Ayuso wrote:
> This patch allows to specify a string to indicate the time, eg.
> 
> nft add rule filter output ct expiration \"1d2h3m4s\" counter
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> An alternative to this patch is to use seconds as input/output, that only
> needs a smaller patch to fix time_type_print().

I think this is a much more natural way to specify relative times.

>  include/utils.h |    4 ++
>  src/datatype.c  |  133 ++++++++++++++++++++++++++++++++++++++++++++++++-------
>  2 files changed, 121 insertions(+), 16 deletions(-)
> 
> diff --git a/include/utils.h b/include/utils.h
> index 854986f..f23f8e6 100644
> --- a/include/utils.h
> +++ b/include/utils.h
> @@ -62,6 +62,10 @@
>  	(void) (&_max1 == &_max2);		\
>  	_max1 > _max2 ? _max1 : _max2; })
>  
> +#ifndef ARRAY_SIZE
> +#define ARRAY_SIZE(a) (int)(sizeof(a)/sizeof((a)[0]))
> +#endif

We have array_size().
