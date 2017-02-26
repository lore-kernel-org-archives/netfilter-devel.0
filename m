From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] mnl: continue monitor if errno is ESRCH
Date: Sun, 26 Feb 2017 21:24:10 +0100
Message-ID: <20170226202410.GB1827@salvia>
References: <20170226163058.24754-1-alexander@alemayhu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alexander Alemayhu <alexander@alemayhu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54476 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751221AbdBZUz2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Feb 2017 15:55:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 956B3ED90F
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Feb 2017 21:24:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8877ADA729
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Feb 2017 21:24:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B838EDA729
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Feb 2017 21:24:11 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170226163058.24754-1-alexander@alemayhu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Feb 26, 2017 at 05:30:58PM +0100, Alexander Alemayhu wrote:
> Running the test cases in the shell directory while running nft monitor results
> in nft exiting with '# ERROR: No such process'. The minimal steps where I could
> reproduce is:
> 
> nft monitor # shell 1
> run-tests.sh testcases/sets/0011add_many_elements_0 # shell 2
> 
> Signed-off-by: Alexander Alemayhu <alexander@alemayhu.com>
> ---
> 
> Not sure if this is considered a fix or desired behaviour, but I was not
> expecting monitor to exit like this.
> 
>  src/mnl.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/src/mnl.c b/src/mnl.c
> index 295dd84a5840..a0066a28b44f 100644
> --- a/src/mnl.c
> +++ b/src/mnl.c
> @@ -1129,7 +1129,10 @@ int mnl_nft_event_listener(struct mnl_socket *nf_sock,
>  				printf("# ERROR: We lost some netlink events!\n");
>  				continue;
>  			}
> +
>  			fprintf(stdout, "# ERROR: %s\n", strerror(errno));
> +			if (errno == ESRCH)
> +				continue;

It seems netlink is returning ESRCH when the number of events is high,
however, it should hit ENOBUFS instead, this is strange.
