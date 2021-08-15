Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A41BC4338F
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Aug 2021 14:14:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 446056103A
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Aug 2021 14:14:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234168AbhHOOOq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Aug 2021 10:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233687AbhHOOOq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Aug 2021 10:14:46 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D716C061764
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Aug 2021 07:14:16 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mFGty-0000Hq-KZ; Sun, 15 Aug 2021 16:14:14 +0200
Date:   Sun, 15 Aug 2021 16:14:14 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, Jan Engelhardt <jengelh@inai.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptabes-nft] iptables-nft: allow removal of empty builtin
 chains
Message-ID: <20210815141414.GJ607@breakpoint.cc>
References: <20210814174643.130760-1-fw@strlen.de>
 <84q02320-o5pp-8q8q-q646-473ssq92n552@vanv.qr>
 <20210814205314.GF607@breakpoint.cc>
 <20210815131223.GA30503@salvia>
 <20210815132733.GI607@breakpoint.cc>
 <20210815134922.GA10659@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210815134922.GA10659@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> But we really do not need NLM_F_NONREC for this new feature, right? I
> mean, a quick shortcut to remove the basechain and its content should
> be fine.

Would deviate a lot from iptables behaviour.

> > No, I don't think so.  I would prefer if
> > iptables-nft -F -t filter
> > iptables-nft -X -t filter
> > 
> > ... would result in an empty "filter" table.
> 
> Your concern is that this would change the default behaviour?

Yes, maybe ok to change it though.  After all, a "iptables-nft -A INPUT
..." will continue to work just fine (its auto-created again).

We could check if policy is still set to accept before implicit
removal in the "iptables-nft -X" case.
