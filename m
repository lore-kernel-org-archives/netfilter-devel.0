From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] ct: direction should be integer, not bitmask
Date: Tue, 18 Feb 2014 01:28:31 +0000
Message-ID: <20140218012830.GB12893@macbook.localnet>
References: <1392671107-6457-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54604 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbaBRB2e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 20:28:34 -0500
Content-Disposition: inline
In-Reply-To: <1392671107-6457-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 17, 2014 at 10:05:07PM +0100, Florian Westphal wrote:
> should always generate cmp op (its enum 0, 1 in kernel).
> 
> Note: 'original,reply' will no longer work after this patch.

I agree.

> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/ct.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/ct.c b/src/ct.c
> index f893df9..79d4666 100644
> --- a/src/ct.c
> +++ b/src/ct.c
> @@ -61,7 +61,7 @@ static const struct datatype ct_dir_type = {
>  	.desc		= "conntrack direction",
>  	.byteorder	= BYTEORDER_INVALID,
>  	.size		= BITS_PER_BYTE,
> -	.basetype	= &bitmask_type,
> +	.basetype	= &integer_type,
>  	.sym_tbl	= &ct_dir_tbl,
>  };
>  
> -- 
> 1.8.1.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
