Return-Path: <SRS0=TDc5=UZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E00AC48BD3
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 10:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40512204FD
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 10:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfFZKce (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 06:32:34 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:39916 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726077AbfFZKce (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 06:32:34 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hg5E6-0001Dl-Fb; Wed, 26 Jun 2019 12:32:30 +0200
Date:   Wed, 26 Jun 2019 12:32:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: Use of oifname in input chains
Message-ID: <20190626103230.b7eqh2i3ibpkfv52@breakpoint.cc>
References: <20190625122954.GC9218@orbyte.nwl.cc>
 <20190625194321.e2siqh7jfhldwzgw@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625194321.e2siqh7jfhldwzgw@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Feature because one could add the rule to a non-base chain and jump to
> > it from any hook to reduce duplication in ruleset. We would have to
> > check rules in the target chain while validating the rule containing the
> > jump.
> > 
> > What do you think?
> 
> How does this behave in iptables BTW? I think iptables simply allows
> this, but it won't ever match obviously.

iptables userspace will reject iptables -A INPUT -o foo.
-A FOO -o foo will "work", even if we only have a -j FOO from INPUT.

I don't think its worth to add tracking for this to kernel:

new chain C
meta oifname bla added to C
jump added from output to C
jump added from input to C   # should this fail? why?

new chain C
jump added from input to C
meta oifname added to C	     # same q: why should this fail?
