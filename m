Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F4F8CDB465
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 11:38:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235283AbjJSLio (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 07:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345408AbjJSLii (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 07:38:38 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207A1D6C
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 04:38:12 -0700 (PDT)
Received: from [78.30.34.192] (port=39980 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qtRLp-002g1M-Hr; Thu, 19 Oct 2023 13:38:07 +0200
Date:   Thu, 19 Oct 2023 13:38:04 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH v3 3/3] netfilter: nf_tables: Add locking for
 NFT_MSG_GETRULE_RESET requests
Message-ID: <ZTEVHOLSk/SSMJNM@calendula>
References: <20231019113347.8753-1-phil@nwl.cc>
 <20231019113347.8753-4-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231019113347.8753-4-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 19, 2023 at 01:33:47PM +0200, Phil Sutter wrote:
> Rule reset is not concurrency-safe per-se, so multiple CPUs may reset
> the same rule at the same time. At least counter and quota expressions
> will suffer from value underruns in this case.
> 
> Prevent this by introducing dedicated locking callbacks for nfnetlink
> and the asynchronous dump handling to serialize access.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Changes since v2:
> - Keep local variable 'nft_net' in nf_tables_getrule_reset()
> - No need for local variable 'family' in same function (used only once
>   after all the churn)
> ---
>  net/netfilter/nf_tables_api.c | 74 ++++++++++++++++++++++++++++-------
>  1 file changed, 60 insertions(+), 14 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 584d3b204372..fbb688c9903c 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
[...]
> +static int nf_tables_dumpreset_rules(struct sk_buff *skb,
> +				     struct netlink_callback *cb)
> +{
> +	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
> +	int ret;
> +
> +	mutex_lock(&nft_net->commit_mutex);
> +	ret = nf_tables_dump_rules(skb, cb);
> +	mutex_unlock(&nft_net->commit_mutex);

NACK.

This just mitigates the problem we are discussing, when there is an
interference with an ongoing transaction.
