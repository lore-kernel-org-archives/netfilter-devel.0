Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC180C7619A
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Apr 2023 11:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjDLLoL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Apr 2023 07:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjDLLoJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Apr 2023 07:44:09 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F8DE46
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Apr 2023 04:43:54 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pmYtD-0000Zp-G9; Wed, 12 Apr 2023 13:43:51 +0200
Date:   Wed, 12 Apr 2023 13:43:51 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nftables 8/8] test: py: add tests for shifted nat
 port-ranges
Message-ID: <20230412114351.GA2135@breakpoint.cc>
References: <20230305101418.2233910-1-jeremy@azazel.net>
 <20230305101418.2233910-9-jeremy@azazel.net>
 <20230324225904.GB17250@breakpoint.cc>
 <ZDUaIa0N2R1Ay7o/@calendula>
 <20230411123604.GF21051@breakpoint.cc>
 <ZDaUi172jznQL5l9@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDaUi172jznQL5l9@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I think my proposal provides a simple way to support this, it just a
> new flag in the NAT engine, few lines to handle it and new userspace
> code to handle -/+offset in a map.

Yes, thanks for clarifying this. I'm fine with your proposal.

I think it might even be possible to rework the iptables target
(the only user of the current shift/offset infra) to work with
the 'new' delta approach, to avoid cluttering the NAT engine with
both appraoaches.

> Your idea of doing it via payload + math is also good, but it would
> just require more work to support this NAT port-shift feature in
> userspace.

Indeed, its a lot more work.

> Does this help clarify? I am talking about a completely different
> design for this feature, not so iptablish.

Yes, it does.  Agree its better solution compared to the existing
one.
