Return-Path: <SRS0=1PIt=XE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3013BC4740A
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Sep 2019 22:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A63C218DE
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Sep 2019 22:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388663AbfIIWMX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Sep 2019 18:12:23 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:40594 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388574AbfIIWMX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Sep 2019 18:12:23 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i7RtS-0002Ga-Jk; Tue, 10 Sep 2019 00:12:19 +0200
Date:   Tue, 10 Sep 2019 00:12:18 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Eric Garver <eric@garver.life>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nftables 3/3] src: mnl: retry when we hit -ENOBUFS
Message-ID: <20190909221218.GA2066@breakpoint.cc>
References: <20190813201246.5543-1-fw@strlen.de>
 <20190813201246.5543-4-fw@strlen.de>
 <20190909211110.2dzcta4dgengb4wy@egarver.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190909211110.2dzcta4dgengb4wy@egarver.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Eric Garver <eric@garver.life> wrote:
> > +			if (errno == ENOBUFS && enobuf_restarts++ < 3) {
> > +				scale *= 2;
> > +				goto restart;
> > +			}
> 
> If this restart is triggered it causes rules to be duplicated. We send
> the same batch again.

Right :-(

> I'm hitting this on x86_64. Maybe we need find a better way to estimate
> the rcvbuffer in the case of --echo. By the time we see ENOBUFS we're
> already in a bad way - events have already be lost.

Thats correct.  Pablo, I don't see a way for dynamic probing, as Eric
explains the error occurs after the fact so we cannot recover.

I will send a best-effort fix in a bit.

