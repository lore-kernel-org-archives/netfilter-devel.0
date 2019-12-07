Return-Path: <SRS0=byYJ=Z5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 253B7C43603
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Dec 2019 11:16:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02E2C24673
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Dec 2019 11:16:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfLGLQr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 7 Dec 2019 06:16:47 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:34374 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726025AbfLGLQr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Dec 2019 06:16:47 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1idY4r-0002HP-L6; Sat, 07 Dec 2019 12:16:45 +0100
Date:   Sat, 7 Dec 2019 12:16:45 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: Documentation question (verdicts)
Message-ID: <20191207111645.GB795@breakpoint.cc>
References: <20191202102623.GA775@dimstar.local.net>
 <20191207012843.GA22674@dimstar.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191207012843.GA22674@dimstar.local.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> Hi Pablo,
> 
> On Mon, Dec 02, 2019 at 09:26:23PM +1100, Duncan Roe wrote:
> > Hi Pablo,
> >
> > Queue handling [DEPRECATED] in libnetfilter_queue.c documents these 3:
> >
> > > 278  *   - NF_ACCEPT the packet passes, continue iterations
> > > 281  *   - NF_REPEAT iterate the same cycle once more
> > > 282  *   - NF_STOP accept, but don't continue iterations
> >
> > In my tests, NF_REPEAT works as documented - the input hook presents the packet
> > a second time. But, contrary to the above, the packet does not show again
> > after NF_ACCEPT.
> >
> > Is that expected behaviour nowadays?
> >
> > And if so, does that make NF_STOP redundant?
> >
> > BTW if you'd like to try it, my test program nfq6 is a subdirectory at
> > https://github.com/duncan-roe/nfq (nfq itself is an ad blocker).
> >
> > Cheers ... Duncan.
> 
> Specifically I need to know whether to document NF_STOP as obsolete (same as
> NF_ACCEPT).

They are not the same.  STOP calls the okfn directly so packet will be
done with the hook location.  NF_ACCEPT moves on to the next hook.

table ip raw {
        chain p1 {
                type filter hook prerouting priority -1000; policy accept;
                ip protocol icmp queue num 0 bypass
        }

        chain p2 {
                type filter hook prerouting priority filter; policy accept;
                ip protocol icmp meta mark 0x0000002a counter
        }
}

If nfqueue tool sets mark 42 and ACCEPT, the counter will increment.
If it uses STOP, the prerouting hook processing ends immediately
and the packet will continue stack traversal, all further prerouting
base chains are skipped.

It will eventually appear in forward or input.
