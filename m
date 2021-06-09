Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AD6FC48BCF
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Jun 2021 19:35:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03F8161287
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Jun 2021 19:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhFIThQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Jun 2021 15:37:16 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60090 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhFIThQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Jun 2021 15:37:16 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 667836422C;
        Wed,  9 Jun 2021 21:34:07 +0200 (CEST)
Date:   Wed, 9 Jun 2021 21:35:17 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        coverity-bot <keescook+coverity-bot@chromium.org>
Subject: Re: [PATCH nf-next] netfilter: move nf_tables base hook annotation
 to init helper
Message-ID: <20210609193517.GA4711@salvia>
References: <20210608210607.13325-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210608210607.13325-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 08, 2021 at 11:06:07PM +0200, Florian Westphal wrote:
> coverity scanner says:
> 2187  if (nft_is_base_chain(chain)) {
> vvv   CID 1505166:  Memory - corruptions  (UNINIT)
> vvv   Using uninitialized value "basechain".
> 2188  basechain->ops.hook_ops_type = NF_HOOK_OP_NF_TABLES;
> 
> ... I don't see how nft_is_base_chain() can evaluate to true
> while basechain pointer is garbage.
> 
> However, it seems better to place the NF_HOOK_OP_NF_TABLES annotation
> in nft_basechain_hook_init() instead.

Applied, thanks.
