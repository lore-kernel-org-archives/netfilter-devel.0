Return-Path: <SRS0=5/AD=YL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75C57CA9EA9
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Oct 2019 20:58:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50B4B2070B
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Oct 2019 20:58:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391535AbfJRU6L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Oct 2019 16:58:11 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:37718 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388245AbfJRU6K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Oct 2019 16:58:10 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iLZK4-0006ch-Qz; Fri, 18 Oct 2019 22:58:08 +0200
Date:   Fri, 18 Oct 2019 22:58:08 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] xtables-restore: Fix --table parameter check
Message-ID: <20191018205808.GC25052@breakpoint.cc>
References: <20190920154920.7927-1-phil@nwl.cc>
 <20191018140508.GB25052@breakpoint.cc>
 <20191018144806.GG26123@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018144806.GG26123@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> > How did you generate it?  The added code is pure voodoo magic to me,
> > so I wonder if we can just remove the 'test for -t in iptables-restore
> > files' code.
> 
> Sorry, I didn't mean to create such unreadable code. I guess after
> managing to wrap my head around to understand the old code, the new one
> seemed much more clear to me. ;)

Fair enough, my main point was where the test cases come from, i.e.
did you see such rule dumps in the wild, or did you create this manually
to catch all corner cases?

I see you have a test for things like "-?t", so I wondered where that
came from.

> What do you think? Or should I respin after adding a bunch of comments
> to is_table_param() to make it more clear?

I think thats the best option, I don't have any objections at the check
per se given older iptables does this too.
