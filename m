From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft v2] main: display errors through stderr
Date: Tue, 24 Feb 2015 18:35:05 +0000
Message-ID: <20150224183505.GN3713@acer.localdomain>
References: <1424802770-31213-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, alexandre@r42.ch
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46685 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbbBXSfM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Feb 2015 13:35:12 -0500
Content-Disposition: inline
In-Reply-To: <1424802770-31213-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.02, Pablo Neira Ayuso wrote:
> Debugging still goes through stdout as Patrick requests.
> 
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1000
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thinking about it, EREC_INFORMATIONAL should also go to stdout I
suppose. But since we don't have any of those yet, we can change
it once we get the first message of this type.

> ---
>  src/main.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/main.c b/src/main.c
> index b447aad..4590c30 100644
> --- a/src/main.c
> +++ b/src/main.c
> @@ -361,7 +361,7 @@ int main(int argc, char * const *argv)
>  		rc = NFT_EXIT_FAILURE;
>  out:
>  	scanner_destroy(scanner);
> -	erec_print_list(stdout, &msgs);
> +	erec_print_list(stderr, &msgs);
>  
>  	xfree(buf);
>  	return rc;
> -- 
> 1.7.10.4
> 
