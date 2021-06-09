Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 201D5C48BCD
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Jun 2021 19:34:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE26F613D4
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Jun 2021 19:34:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhFITgj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Jun 2021 15:36:39 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60074 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhFITgj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Jun 2021 15:36:39 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2FDA36422C;
        Wed,  9 Jun 2021 21:33:30 +0200 (CEST)
Date:   Wed, 9 Jun 2021 21:34:40 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2 nf-next] netfilter: nfnetlink_hook: add depends-on
 nftables
Message-ID: <20210609193440.GA4665@salvia>
References: <20210608205322.8748-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210608205322.8748-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 08, 2021 at 10:53:22PM +0200, Florian Westphal wrote:
> nfnetlink_hook.c: In function 'nfnl_hook_put_nft_chain_info':
> nfnetlink_hook.c:76:7: error: implicit declaration of 'nft_is_active'
> 
> This macro is only defined when NF_TABLES is enabled.
> While its possible to also add an ifdef-guard, the infrastructure
> is currently not useful without nf_tables.

Applied, thanks.
