Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAFE9C433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Mar 2021 13:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5C7264F01
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Mar 2021 13:02:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhCRNBn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Mar 2021 09:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbhCRNBn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Mar 2021 09:01:43 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359A5C06174A
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Mar 2021 06:01:43 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lMsHS-0008Hy-FC; Thu, 18 Mar 2021 14:01:38 +0100
Date:   Thu, 18 Mar 2021 14:01:38 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Luuk Paulussen <Luuk.Paulussen@alliedtelesis.co.nz>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Bug when updating ICMP flows using conntrack tools
Message-ID: <20210318130138.GC22603@breakpoint.cc>
References: <1616049521015.25557@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1616049521015.25557@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Luuk Paulussen <Luuk.Paulussen@alliedtelesis.co.nz> wrote:
> However, in libnetfilter-conntrack the way that the message is built has been changed, and in nfct_nlmsg_build, the check about whether to build the REPL tuple has been extended to include
> test_bit(ATTR_ICMP_TYPE, ct->head.set) ||
> test_bit(ATTR_ICMP_CODE, ct->head.set) ||
> test_bit(ATTR_ICMP_ID, ct->head.set)

That looks like a bug, those checks should only be done for ORIG.
