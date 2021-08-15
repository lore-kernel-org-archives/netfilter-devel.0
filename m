Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52401C4338F
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Aug 2021 13:27:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E09260FC3
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Aug 2021 13:27:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238090AbhHON2H (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Aug 2021 09:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232412AbhHON2H (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Aug 2021 09:28:07 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA3EC061764
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Aug 2021 06:27:36 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mFGAn-00006f-KQ; Sun, 15 Aug 2021 15:27:33 +0200
Date:   Sun, 15 Aug 2021 15:27:33 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, Jan Engelhardt <jengelh@inai.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptabes-nft] iptables-nft: allow removal of empty builtin
 chains
Message-ID: <20210815132733.GI607@breakpoint.cc>
References: <20210814174643.130760-1-fw@strlen.de>
 <84q02320-o5pp-8q8q-q646-473ssq92n552@vanv.qr>
 <20210814205314.GF607@breakpoint.cc>
 <20210815131223.GA30503@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210815131223.GA30503@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sat, Aug 14, 2021 at 10:53:14PM +0200, Florian Westphal wrote:
> > Indeed.  Since this removes the base chain, it implicitly reverts
> > a DROP policy too.
> 
> User still has to iptables -F on that given chain before deleting,
> right?

Yes, -X fails if the chain has rules.

> If NLM_F_NONREC is used, the EBUSY is reported when trying to delete
> a chain with rules.

Yes.

> My assumption is that the user will perform:
> 
> iptables-nft -F -t filter
> iptables-nft -D -t filter

Yes, assuminy you meant -X instead of -D.

This behaves just like before, it deletes all rules (-F) and all user-defined
chains (-X).

> I mean, by when the user has an empty basechain with default policy to
> DROP, if they remove the chain, then they are really meaning to remove
> the chain and this default policy to DROP.

ATM iptables -X $BUILTIN will always fail.
In -legecy there is no kernel API to allow for its removal,
for -nft there is an extra check that throws an error.

> Or am I missing anything else?

No, I don't think so.  I would prefer if
iptables-nft -F -t filter
iptables-nft -X -t filter

... would result in an empty "filter" table.

I could also add a patch that requests removal
of the table as well for the -X case; but unlike base chain the
presence of the table alone has no impact on dataplane.
