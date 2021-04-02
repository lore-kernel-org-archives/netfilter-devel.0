Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30757C433B4
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Apr 2021 05:38:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF1136108F
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Apr 2021 05:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhDBFiP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Apr 2021 01:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhDBFiP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Apr 2021 01:38:15 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81AE2C0613E6
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Apr 2021 22:38:14 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lSCVW-0006ET-W1; Fri, 02 Apr 2021 07:38:11 +0200
Date:   Fri, 2 Apr 2021 07:38:10 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] nft: Increase BATCH_PAGE_SIZE to support huge
 rulesets
Message-ID: <20210402053810.GI13699@breakpoint.cc>
References: <20210401145307.29927-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401145307.29927-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> In order to support the same ruleset sizes as legacy iptables, the
> kernel's limit of 1024 iovecs has to be overcome. Therefore increase
> each iovec's size from 256KB to 4MB.
> 
> While being at it, add a log message for failing sendmsg() call. This is
> not supposed to happen, even if the transaction fails. Yet if it does,
> users are left with only a "line XXX failed" message (with line number
> being the COMMIT line).
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  iptables/nft.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/iptables/nft.c b/iptables/nft.c
> index bd840e75f83f4..e19c88ece6c2a 100644
> --- a/iptables/nft.c
> +++ b/iptables/nft.c
> @@ -88,11 +88,11 @@ int mnl_talk(struct nft_handle *h, struct nlmsghdr *nlh,
>  
>  #define NFT_NLMSG_MAXSIZE (UINT16_MAX + getpagesize())
>  
> -/* selected batch page is 256 Kbytes long to load ruleset of
> - * half a million rules without hitting -EMSGSIZE due to large
> - * iovec.
> +/* Selected batch page is 4 Mbytes long to support loading a ruleset of 3.5M
> + * rules matching on source and destination address as well as input and output
> + * interfaces. This is what legacy iptables supports.
>   */
> -#define BATCH_PAGE_SIZE getpagesize() * 32
> +#define BATCH_PAGE_SIZE getpagesize() * 512

Why not remove getpagesize() altogether?

The comment assumes getpagesize returns 4096 so might as well just use
"#define BATCH_PAGE_SIZE  (4 * 1024 * 1024)" or similar?

On my system getpagesize() * 512 yields 2097152 ...

>  static struct nftnl_batch *mnl_batch_init(void)
>  {
> @@ -220,8 +220,10 @@ static int mnl_batch_talk(struct nft_handle *h, int numcmds)
>  	int err = 0;
>  
>  	ret = mnl_nft_socket_sendmsg(h, numcmds);
> -	if (ret == -1)
> +	if (ret == -1) {
> +		fprintf(stderr, "sendmsg() failed: %s\n", strerror(errno));
>  		return -1;
> +	}

Isn't that library code?  At the very least this should use
nft_print().
