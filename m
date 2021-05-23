Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 805A3C4707A
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 May 2021 08:52:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E57E610C8
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 May 2021 08:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbhEWIx6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 May 2021 04:53:58 -0400
Received: from mail.netfilter.org ([217.70.188.207]:55264 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbhEWIx6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 May 2021 04:53:58 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 384AB64160;
        Sun, 23 May 2021 10:51:33 +0200 (CEST)
Date:   Sun, 23 May 2021 10:52:28 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 4/4] netfilter: nf_tables: include table and
 chain name when dumping hooks
Message-ID: <20210523085228.GA11701@salvia>
References: <20210521113922.20798-1-fw@strlen.de>
 <20210521113922.20798-5-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210521113922.20798-5-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, May 21, 2021 at 01:39:22PM +0200, Florian Westphal wrote:
> For ip(6)tables, the function names will show 'raw', 'mangle',
> and so on, but for nf_tables the interpreter name is identical for all
> base chains in the same family, so its not easy to line up the defined
> chains with the hook function name.
> 
> To make it easier to see how the ruleset lines up with the defined
> hooks, extend the hook dump to include the chain+table name.
> 
> Example list:
> family ip hook input {
>   -0000000150 iptable_mangle_hook [iptable_mangle]
>   +0000000000 nft_do_chain_inet [nf_tables]  # nft table filter chain input
>  [..]                                          ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  2 ++
>  net/netfilter/nf_tables_api.c            | 42 ++++++++++++++++++++++++
>  2 files changed, 44 insertions(+)
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index ba6545a32e34..4822a837250d 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -149,6 +149,7 @@ enum nft_list_attributes {
>   * @NFTA_HOOK_DEVS: list of netdevices (NLA_NESTED)
>   * @NFTA_HOOK_FUNCTION_NAME: hook function name (NLA_STRING)
>   * @NFTA_HOOK_MODULE_NAME: kernel module that registered this hook (NLA_STRING)
> + * @NFTA_HOOK_NFT_CHAIN_INFO: nft chain and table name (NLA_NESTED)

Probably NFTA_HOOK_CHAIN_INFO ?
