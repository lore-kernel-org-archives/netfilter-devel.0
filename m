Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D44DC47082
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Jun 2021 15:46:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E31360FE8
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Jun 2021 15:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhFHPsm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Jun 2021 11:48:42 -0400
Received: from mail.netfilter.org ([217.70.188.207]:56696 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbhFHPsm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Jun 2021 11:48:42 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id AF37863E3D;
        Tue,  8 Jun 2021 17:45:36 +0200 (CEST)
Date:   Tue, 8 Jun 2021 17:46:46 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH nf-next] nfilter: nf_hooks: fix build failure with
 NF_TABLES=n
Message-ID: <20210608154646.GA983@salvia>
References: <202106082146.9TmnLWJk-lkp@intel.com>
 <20210608144237.5813-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210608144237.5813-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Maybe from Kconfig, select CONFIG_NF_TABLES from NFNETLINK_HOOK to
reduce ifdef pollution?

On Tue, Jun 08, 2021 at 04:42:37PM +0200, Florian Westphal wrote:
> nfnetlink_hook.c: In function 'nfnl_hook_put_nft_chain_info':
> nfnetlink_hook.c:76:7: error: implicit declaration of 'nft_is_active'
> 
> This macro is only defined when NF_TABLES is enabled.
> Add IS_ENABLED guards for this.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 252956528caa ("netfilter: add new hook nfnl subsystem")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nfnetlink_hook.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
> index 04586dfa2acd..d624805e977c 100644
> --- a/net/netfilter/nfnetlink_hook.c
> +++ b/net/netfilter/nfnetlink_hook.c
> @@ -61,6 +61,7 @@ static int nfnl_hook_put_nft_chain_info(struct sk_buff *nlskb,
>  					unsigned int seq,
>  					const struct nf_hook_ops *ops)
>  {
> +#if IS_ENABLED(CONFIG_NF_TABLES)
>  	struct net *net = sock_net(nlskb->sk);
>  	struct nlattr *nest, *nest2;
>  	struct nft_chain *chain;
> @@ -104,6 +105,9 @@ static int nfnl_hook_put_nft_chain_info(struct sk_buff *nlskb,
>  cancel_nest:
>  	nla_nest_cancel(nlskb, nest);
>  	return -EMSGSIZE;
> +#else
> +	return 0;
> +#endif
>  }
>  
>  static int nfnl_hook_dump_one(struct sk_buff *nlskb,
> -- 
> 2.31.1
> 
