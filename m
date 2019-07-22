Return-Path: <SRS0=3WFO=VT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B925C76190
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 11:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A78F20449
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 11:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730124AbfGVL6B (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jul 2019 07:58:01 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45698 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727728AbfGVL6B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jul 2019 07:58:01 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hpWx2-0001ei-5d; Mon, 22 Jul 2019 13:57:56 +0200
Date:   Mon, 22 Jul 2019 13:57:56 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] doc: fib: explain example in more detail
Message-ID: <20190722115756.GH22661@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190721104305.29594-1-fw@strlen.de>
 <20190721184212.2fxviqkcil27wzqp@salvia>
 <20190721185432.o2wke7wecfdbyzfr@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190721185432.o2wke7wecfdbyzfr@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jul 21, 2019 at 08:54:32PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Cc'ing Phil.
> > 
> > On Sun, Jul 21, 2019 at 12:43:05PM +0200, Florian Westphal wrote:
> > > As noted by Felix Dreissig, fib documentation is quite terse, so explain
> > > the 'saddr . iif' example with a few more words.
> > 
> > There are patches to disallow ifindex 0 from Phil
> 
> WHich ones?
> I only see those that make meta write 0 in case iface doesn't exist,
> so it does exactly what fib does.

It is message-ID 20190718033940.12820-1-phil@nwl.cc and follow-ups,
trying to prevent users from matching against the values we decided to
use for "no data available" situations. This whole attempt feels a bit
futile. Maybe we should introduce something to signal "no value" so that
cmp expression will never match for '==' and always for '!='? Not sure
how to realize this via registers. Also undecided about '<' and '>' ops.

Cheers, Phil
