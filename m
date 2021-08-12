Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC858C4338F
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Aug 2021 14:31:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF2F46109F
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Aug 2021 14:31:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236800AbhHLObw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Aug 2021 10:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233293AbhHLObw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 10:31:52 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE5AC061756;
        Thu, 12 Aug 2021 07:31:26 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mEBjs-0007tz-Pr; Thu, 12 Aug 2021 16:31:20 +0200
Date:   Thu, 12 Aug 2021 16:31:20 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Kangmin Park <l4stpr0gr4m@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: remove duplicate code
Message-ID: <20210812143120.GD607@breakpoint.cc>
References: <20210807062106.2563-1-l4stpr0gr4m@gmail.com>
 <CAKW4uUx=cOu46E0QCdmg1Jq3WJ3w6ROo6oKZaXA=g6gdhdiDdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKW4uUx=cOu46E0QCdmg1Jq3WJ3w6ROo6oKZaXA=g6gdhdiDdg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Kangmin Park <l4stpr0gr4m@gmail.com> wrote:
> I checked the Changes Requested state in patchwork.
> But I have not received any review mails.

I did not see any either.

> I wonder if there is any problem.

I don't think its worth doing, the 'extra' check avoids the
need for two additional function arguments (and those are not free
either).
