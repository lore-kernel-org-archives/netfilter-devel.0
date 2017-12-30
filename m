From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl] tests: nft-parsing-test: fix warning - ignoring
 return value of fgets
Date: Sat, 30 Dec 2017 22:02:20 +0100
Message-ID: <20171230210220.tl23muxui43nmhn5@salvia>
References: <20171229072925.15689-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58008 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750912AbdL3VCZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Dec 2017 16:02:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 22A6AC9EC5
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Dec 2017 22:02:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 13DCA71C9
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Dec 2017 22:02:24 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171229072925.15689-1-harshasharmaiitr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Harsha,

On Fri, Dec 29, 2017 at 12:59:25PM +0530, Harsha Sharma wrote:
> This patch fixes compilation warning: ignoring return value of fgets.
> 
> Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
> ---
>  tests/nft-parsing-test.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
> index d25a73e..97f402d 100644
> --- a/tests/nft-parsing-test.c
> +++ b/tests/nft-parsing-test.c
> @@ -80,7 +80,8 @@ static int compare_test(uint32_t type, struct nftnl_ruleset *rs,
>  	}
>  
>  	rewind(fp);
> -	fgets(orig, sizeof(orig), fp);
> +	if (fgets(orig, sizeof(orig), fp) == NULL)
> +		fprintf(stderr, "Error in reading or end of file.\n");

Did you test this? Are you sure this is the right fix for this?
IIRC, EOF is reported via NULL too for fgets.

Thanks.
