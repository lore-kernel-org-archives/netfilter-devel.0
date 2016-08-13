From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/4, V2, libnftnl] tests: Fix wrong expression creation
Date: Sat, 13 Aug 2016 12:25:05 +0200
Message-ID: <20160813102505.GE1376@salvia>
References: <20160811233222.GB5108@salvia>
 <20160812201722.10134-1-carlosfg@riseup.net>
 <20160812201722.10134-2-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59226 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbcHMKZR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 13 Aug 2016 06:25:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 55CA4A416A
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Aug 2016 12:25:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 46CBD1B31E2
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Aug 2016 12:25:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 087841B31E2
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Aug 2016 12:25:13 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160812201722.10134-2-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Applied, thanks.

On Fri, Aug 12, 2016 at 10:17:20PM +0200, Carlos Falgueras García wrote:
> Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
> ---
>  tests/nft-expr_masq-test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/nft-expr_masq-test.c b/tests/nft-expr_masq-test.c
> index f0302e2..3f9903d 100644
> --- a/tests/nft-expr_masq-test.c
> +++ b/tests/nft-expr_masq-test.c
> @@ -52,7 +52,7 @@ int main(int argc, char *argv[])
>  	b = nftnl_rule_alloc();
>  	if (a == NULL || b == NULL)
>  		print_err("OOM");
> -	ex = nftnl_expr_alloc("nat");
> +	ex = nftnl_expr_alloc("masq");
>  	if (ex == NULL)
>  		print_err("OOM");
>  
> -- 
> 2.8.3
> 
