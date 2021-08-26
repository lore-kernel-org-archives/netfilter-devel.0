Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF5DC432BE
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Aug 2021 10:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7EA46108F
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Aug 2021 10:59:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241552AbhHZLAj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Aug 2021 07:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbhHZLAi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Aug 2021 07:00:38 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBF5C061757
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Aug 2021 03:59:51 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mJD6p-0008AO-Ux; Thu, 26 Aug 2021 12:59:47 +0200
Date:   Thu, 26 Aug 2021 12:59:47 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] netlink_delinearize: incorrect meta protocol
 dependency kill
Message-ID: <20210826105947.GA13818@breakpoint.cc>
References: <20210826104952.4812-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826104952.4812-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> meta protocol is meaningful in bridge, netdev and inet familiiess, do
> not remove this.
> 
> Fixes: a1bcf8a34975 ("payload: add payload_may_dependency_kill()")

Looks like its a regression from
"netlink_delinearize: Refactor meta_may_dependency_kill()",
056aaa3e6dc65aced5e552233ac3e7f89fb81f86.
