Return-Path: <SRS0=4amC=5K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9FABC2D0E8
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Mar 2020 23:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB6C02073E
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Mar 2020 23:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbgCYXN6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Mar 2020 19:13:58 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:34496 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727395AbgCYXN5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Mar 2020 19:13:57 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jHFDa-00053N-5c; Thu, 26 Mar 2020 00:13:51 +0100
Date:   Thu, 26 Mar 2020 00:13:50 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Qian Cai <cai@lca.pw>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter/nf_tables: silence a RCU-list warning
Message-ID: <20200325231350.GC878@breakpoint.cc>
References: <20200325143142.6955-1-cai@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325143142.6955-1-cai@lca.pw>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Qian Cai <cai@lca.pw> wrote:
> It is safe to traverse &net->nft.tables with &net->nft.commit_mutex
> held using list_for_each_entry_rcu(). Silence the PROVE_RCU_LIST false
> positive,

[..]

> -	list_for_each_entry_rcu(table, &net->nft.tables, list) {
> +	list_for_each_entry_rcu(table, &net->nft.tables, list,
> +				lockdep_is_held(&net->nft.commit_mutex)) {

Thanks for the patch.

Acked-by: Florian Westphal <fw@strlen.de>
