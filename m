From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] data_reg: xml: fix invalid veredict
 validation
Date: Wed, 5 Jun 2013 05:43:27 +0200
Message-ID: <20130605034327.GA31658@localhost>
References: <20130529224626.18127.15020.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32837 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab3FEDnd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Jun 2013 23:43:33 -0400
Content-Disposition: inline
In-Reply-To: <20130529224626.18127.15020.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 30, 2013 at 12:46:26AM +0200, Arturo Borrero wrote:
> Other kind of validations are used all over the XML parsing code.
> This validation is not valid anymore, and this patch update it.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  src/expr/data_reg.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
> index 71b10fe..12adc18 100644
> --- a/src/expr/data_reg.c
> +++ b/src/expr/data_reg.c
> @@ -64,10 +64,8 @@ static int nft_data_reg_verdict_xml_parse(union nft_data_reg *reg, char *xml)
>  		return -1;
>  	}
>  
> -	errno = 0;
>  	tmp = strtoll(node->child->value.opaque, &endptr, 10);
> -	if (tmp > INT_MAX || tmp < INT_MIN || errno != 0
> -						|| strlen(endptr) > 0) {
> +	if (tmp > INT_MAX || tmp < INT_MIN || *endptr) {

I think it's time to add some helper function like nft_stroll. This
function will take care of this tricky error handling and it will just
return -1 in case of error. You can put this new function in
src/utils.c and define it protype in internal.h.
