From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/4, libnfntl] Implement rule comparison
Date: Fri, 12 Aug 2016 02:17:59 +0200
Message-ID: <20160812001759.GA12374@salvia>
References: <20160808111758.4062-1-carlosfg@riseup.net>
 <20160808111758.4062-2-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55116 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbcHLASG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Aug 2016 20:18:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 503A41878BF
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 02:18:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3F2E7DA7E7
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 02:18:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2EB89DA7EA
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 02:18:00 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160808111758.4062-2-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 08, 2016 at 01:17:56PM +0200, Carlos Falgueras García wrote:
> diff --git a/src/expr/dynset.c b/src/expr/dynset.c
> index 0eaa409..fa8b8d5 100644
> --- a/src/expr/dynset.c
> +++ b/src/expr/dynset.c
> @@ -370,6 +370,23 @@ static void nftnl_expr_dynset_free(const struct nftnl_expr *e)
>  	xfree(dynset->set_name);
>  }
>  
> +static bool nftnl_expr_dynset_cmp(const struct nftnl_expr *e1,
> +				  const struct nftnl_expr *e2)
> +{
> +	struct nftnl_expr_dynset *d1, *d2;
> +
> +	d1 = nftnl_expr_data(e1);
> +	d2 = nftnl_expr_data(e2);
> +
> +	return	d1->sreg_key  == d2->sreg_key       &&
> +		d1->sreg_data == d2->sreg_data      &&
> +		d1->op        == d2->op             &&
> +		d1->timeout   == d2->timeout        &&
> +		nftnl_expr_cmp(d1->expr, d2->expr)  &&
> +		!strcmp(d1->set_name, d2->set_name) &&
> +		d1->set_id    == d2->set_id;

Are we going to compare fields even if unset?

This is error prone, is we _set() an attribute, then _unset() it, we
just set off of the flag. So the value is still there and cmp will
return a bogus result.
