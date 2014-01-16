From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft 2/3] payload: fix crash when wrong ethernet protocol
 type is used
Date: Thu, 16 Jan 2014 16:29:56 +0000
Message-ID: <20140116162956.GB4111@macbook.localnet>
References: <1389817823-7251-1-git-send-email-pablo@netfilter.org>
 <1389817823-7251-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57396 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbaAPQ37 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 11:29:59 -0500
Content-Disposition: inline
In-Reply-To: <1389817823-7251-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 15, 2014 at 09:30:22PM +0100, Pablo Neira Ayuso wrote:
> nft add rule ip filter output meta protocol xyz counter
>                                             ^^^
> 
> This fix is similar to 4097ad7 ("meta: fix crash when parsing
> unresolvable mark values").

I already fixed that for mark_type, but didn't realize we have more
instances of this. I double checked and we should be good now.

> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  src/payload.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/src/payload.c b/src/payload.c
> index 86d75fa..decfcd6 100644
> --- a/src/payload.c
> +++ b/src/payload.c
> @@ -993,6 +993,7 @@ static struct error_record *ethertype_parse(const struct expr *sym,
>  {
>  	struct error_record *erec;
>  
> +	*res = NULL;
>  	erec = sym->dtype->basetype->parse(sym, res);
>  	if (erec != NULL)
>  		return erec;
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
