From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/5, V2, libnftnl] rule: Add const modifier to rule field
 of expression iterator
Date: Mon, 8 Aug 2016 16:48:34 +0200
Message-ID: <20160808144834.GB6264@salvia>
References: <20160808111758.4062-1-carlosfg@riseup.net>
 <20160808124235.11135-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43560 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916AbcHHOsn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Aug 2016 10:48:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id AF7521DF883
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Aug 2016 16:48:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A05FA1B3328
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Aug 2016 16:48:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8AE161B328C
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Aug 2016 16:48:39 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160808124235.11135-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 08, 2016 at 02:42:31PM +0200, Carlos Falgueras García wrote:
> Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
> ---
>  include/libnftnl/rule.h | 2 +-
>  src/rule.c              | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/libnftnl/rule.h b/include/libnftnl/rule.h
> index 2776a77..09af96c 100644
> --- a/include/libnftnl/rule.h
> +++ b/include/libnftnl/rule.h
> @@ -70,7 +70,7 @@ int nftnl_expr_foreach(struct nftnl_rule *r,
>  
>  struct nftnl_expr_iter;
>  
> -struct nftnl_expr_iter *nftnl_expr_iter_create(struct nftnl_rule *r);
> +struct nftnl_expr_iter *nftnl_expr_iter_create(const struct nftnl_rule *r);

Good point, other iterators need this too.

Some please send a patch constifying them all these nftnl_*_iter
functions.

Once this patch is applied, then you send a v3 of this patches. Try to
deliver updates that have dependencies in smaller batches.

Thanks Carlos.
