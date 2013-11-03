From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 5/6] test: style cleanup
Date: Sun, 3 Nov 2013 22:33:27 +0100
Message-ID: <20131103213327.GE10464@localhost>
References: <20131031123618.32572.24929.stgit@nfdev.cica.es>
 <20131031123639.32572.83332.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41648 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315Ab3KCVdb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Nov 2013 16:33:31 -0500
Content-Disposition: inline
In-Reply-To: <20131031123639.32572.83332.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 31, 2013 at 01:36:39PM +0100, Arturo Borrero Gonzalez wrote:
> Some style cleanups.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  tests/nft-parsing-test.c |   34 ++++++++++++++++++++++------------
>  1 file changed, 22 insertions(+), 12 deletions(-)
> 
> diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
> index 3d26c3a..e147e79 100644
> --- a/tests/nft-parsing-test.c
> +++ b/tests/nft-parsing-test.c
> @@ -193,8 +193,10 @@ static int test_json(const char *filename)
>  	if (json_object_get(root, "table") != NULL) {
>  		t = nft_table_alloc();
>  		if (t != NULL) {
> -			if (nft_table_parse(t, NFT_TABLE_PARSE_JSON, json) == 0)
> -				ret = compare_test(TEST_JSON_TABLE, t, filename);
> +			if (nft_table_parse(t,
> +					    NFT_TABLE_PARSE_JSON, json) == 0)
> +				ret = compare_test(TEST_JSON_TABLE,
> +						   t, filename);
>  			else
>  				goto failparsing;

If you need to break lines like this, it usually means that this code
needs to be split in smaller functions. Please, send me a clean up by
encapsulating the tests in new smaller functions, eg. test_json_table().
