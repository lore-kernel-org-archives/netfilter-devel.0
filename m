Return-Path: <SRS0=jECH=SL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D7CFC282CE
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 14:03:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2541D2084F
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 14:03:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbfDIOD2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 10:03:28 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:53344 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726035AbfDIOD2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 10:03:28 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hDrLS-0001wf-Gb; Tue, 09 Apr 2019 16:03:26 +0200
Date:   Tue, 9 Apr 2019 16:03:26 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, fw@strlen.de, arturo@netfilter.org
Subject: Re: [PATCH nft] evaluate: disallow anonymous set with empty elements
Message-ID: <20190409140326.zme4ik6ozqbnf544@breakpoint.cc>
References: <20190409105936.23422-1-pablo@netfilter.org>
 <20190409135925.GQ4851@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190409135925.GQ4851@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Could we maybe find a middle ground where nft still does these
> optimizations but prints warnings so users are notified? We might even
> introduce -W flag to customize behaviour (-W all (default), -W error
> (strict mode), -W none (suppress any non-fatal output on stderr)).

I like this proposal.

One of the broken tproxy test cases (it prints warning) does this:

ip daddr 0.0.0.0/0

.. and that is always true and could be removed.
Different "problem" of course, but it shows that there is ample
opportunity for pruning irrelevant expressions.

And breaking scripts every time we decide that something is
"silly" is a bad decision, imo.

I suspect users will complain about { 1.2.3.4 } being illegal
"just because".
