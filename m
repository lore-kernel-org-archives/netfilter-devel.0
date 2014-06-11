From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] tests: Use the system errors in test_xml.
Date: Wed, 11 Jun 2014 19:48:28 +0200
Message-ID: <20140611174828.GB17547@localhost>
References: <1402501851-22208-1-git-send-email-anarey@gmail.com>
 <1402501851-22208-3-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56865 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409AbaFKRsd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:48:33 -0400
Content-Disposition: inline
In-Reply-To: <1402501851-22208-3-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 11, 2014 at 05:50:47PM +0200, Ana Rey wrote:
> Add the use of system errors (nft_parse_perror) in test_xml to know which
> node is not found.
> 
> Example:
> parsing xmlfiles/75-ruleset.xml: FAILED (Invalid argument)
> fail : Node "flags" not found

Renamed 'fail' to 'Reason'. I know the other part of code it was using
'fail', but it already said 'FAILED' above, so I think it clarifies a
bit more.

> Signed-off-by: Ana Rey <anarey@gmail.com>
> ---
>  tests/nft-parsing-test.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
> index 2a15109..5eff0b9 100644
> --- a/tests/nft-parsing-test.c
> +++ b/tests/nft-parsing-test.c
> @@ -177,6 +177,7 @@ failparsing:
>  	fclose(fp);
>  	printf("parsing %s: ", filename);
>  	printf("\033[31mFAILED\e[0m (%s)\n", strerror(errno));
> +	nft_parse_perror("fail", err);
>  	return -1;
>  }
>  
> -- 
> 2.0.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
