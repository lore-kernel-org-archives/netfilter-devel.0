From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2 libnftnl] expr: cmp: Use cmp2str() instead of
 directly access to array
Date: Mon, 15 Aug 2016 12:32:56 +0200
Message-ID: <20160815103256.GB5883@salvia>
References: <20160815091239.GC3905@salvia>
 <20160815102737.11955-1-carlosfg@riseup.net>
 <20160815102737.11955-2-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60088 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835AbcHOKdB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Aug 2016 06:33:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E624EA4170
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Aug 2016 12:32:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D93D0DA7FC
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Aug 2016 12:32:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C61B1DA7EC
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Aug 2016 12:32:57 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160815102737.11955-2-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 15, 2016 at 12:27:37PM +0200, Carlos Falgueras García wrote:

Please always add a description to your patches, even if it is only
one line to explain why we need this.

Thanks.

> Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
> ---
>  src/expr/cmp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/expr/cmp.c b/src/expr/cmp.c
> index 92c7364..b647b01 100644
> --- a/src/expr/cmp.c
> +++ b/src/expr/cmp.c
> @@ -267,7 +267,7 @@ static int nftnl_expr_cmp_snprintf_default(char *buf, size_t size,
>  	int len = size, offset = 0, ret;
>  
>  	ret = snprintf(buf, len, "%s reg %u ",
> -		       expr_cmp_str[cmp->op], cmp->sreg);
> +		       cmp2str(cmp->op), cmp->sreg);
>  	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
>  	ret = nftnl_data_reg_snprintf(buf+offset, len, &cmp->data,
> -- 
> 2.8.3
> 
