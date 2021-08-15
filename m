Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C19B3C4338F
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Aug 2021 13:12:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96ED1610F7
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Aug 2021 13:12:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238068AbhHONND (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Aug 2021 09:13:03 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53258 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235540AbhHONND (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Aug 2021 09:13:03 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 956B560056;
        Sun, 15 Aug 2021 15:11:41 +0200 (CEST)
Date:   Sun, 15 Aug 2021 15:12:23 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptabes-nft] iptables-nft: allow removal of empty builtin
 chains
Message-ID: <20210815131223.GA30503@salvia>
References: <20210814174643.130760-1-fw@strlen.de>
 <84q02320-o5pp-8q8q-q646-473ssq92n552@vanv.qr>
 <20210814205314.GF607@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210814205314.GF607@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Aug 14, 2021 at 10:53:14PM +0200, Florian Westphal wrote:
> Jan Engelhardt <jengelh@inai.de> wrote:
> > 
> > On Saturday 2021-08-14 19:46, Florian Westphal wrote:
> > > Conservative change:
> > > iptables-nft -X will not remove empty builtin chains.
> > > OTOH, maybe it would be better to auto-remove those too, if empty.
> > > Comments?
> > 
> > How are chain policies expressed in nft, as a property on the
> > chain (like legacy), or as a separate rule?
> > That is significant when removing "empty" chains.
> 
> Indeed.  Since this removes the base chain, it implicitly reverts
> a DROP policy too.

User still has to iptables -F on that given chain before deleting,
right?

If NLM_F_NONREC is used, the EBUSY is reported when trying to delete
a chain with rules.

My assumption is that the user will perform:

iptables-nft -F -t filter
iptables-nft -D -t filter

to follow the classic iptables-like approach (which requires usual -F
+ -X on every table).

I mean, by when the user has an empty basechain with default policy to
DROP, if they remove the chain, then they are really meaning to remove
the chain and this default policy to DROP.

Or am I missing anything else?
