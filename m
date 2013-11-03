From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 3/6] test: use constants for coloured strings
Date: Sun, 3 Nov 2013 22:31:03 +0100
Message-ID: <20131103213103.GC10464@localhost>
References: <20131031123618.32572.24929.stgit@nfdev.cica.es>
 <20131031123628.32572.32677.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41452 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142Ab3KCVbH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Nov 2013 16:31:07 -0500
Content-Disposition: inline
In-Reply-To: <20131031123628.32572.32677.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 31, 2013 at 01:36:29PM +0100, Arturo Borrero Gonzalez wrote:
> Use constants for coloured strings, which have a ugly format.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  tests/nft-parsing-test.c |   17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
> index 5eaaa1e..5333dbd 100644
> --- a/tests/nft-parsing-test.c
> +++ b/tests/nft-parsing-test.c
> @@ -33,6 +33,9 @@ enum {
>  	TEST_JSON_RULESET,
>  };
>  
> +#define FAILED_STR "\033[31mFAILED\e[0m"
> +#define OK_STR "\033[32mOK\e[0m"

I don't like this macro thing, sorry.
