Return-Path: <SRS0=xF+Z=3Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48E9AC35240
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jan 2020 02:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F2EC20720
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jan 2020 02:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgA0CLN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 26 Jan 2020 21:11:13 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:34046 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726670AbgA0CLN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Jan 2020 21:11:13 -0500
Received: from dimstar.local.net (n175-34-107-236.sun1.vic.optusnet.com.au [175.34.107.236])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 43FD53A1523
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jan 2020 13:11:01 +1100 (AEDT)
Received: (qmail 16041 invoked by uid 501); 27 Jan 2020 02:11:00 -0000
Date:   Mon, 27 Jan 2020 13:11:00 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v2 0/1] New pktb_make() function
Message-ID: <20200127021100.GB15669@dimstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20191210112634.11511-1-duncan_roe@optusnet.com.au>
 <20200106031714.12390-1-duncan_roe@optusnet.com.au>
 <20200108225323.io724vuxuzsydjzs@salvia>
 <20200110022757.GA15290@dimstar.local.net>
 <20200113185150.xkxyys3psvddq2g5@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200113185150.xkxyys3psvddq2g5@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=HhxO2xtGR2hgo/TglJkeQA==:117 a=HhxO2xtGR2hgo/TglJkeQA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=Jdjhy38mL1oA:10
        a=RSmzAf-M6YYA:10 a=7z5itg5TLyDPM8l0p7EA:9 a=bWexT7Y3057maBhc:21
        a=sUMbnaP7TCTzK9EJ:21 a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jan 13, 2020 at 07:51:50PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Jan 10, 2020 at 01:27:57PM +1100, Duncan Roe wrote:
> > On Wed, Jan 08, 2020 at 11:53:23PM +0100, Pablo Neira Ayuso wrote:
> > > On Mon, Jan 06, 2020 at 02:17:13PM +1100, Duncan Roe wrote:
> > > > This patch offers a faster alternative / replacement function to pktb_alloc().
> > > >
> > > > pktb_make() is a copy of the first part of pktb_alloc() modified to use a
> > > > supplied buffer rather than calloc() one. It then calls the second part of
> > > > pktb_alloc() which is modified to be a static function.
> > > >
> > > > Can't think of a use case where one would choose to use pktb_alloc over
> > > > pktb_make.
> > > > In a furure documentation update, might relegate pktb_alloc and pktb_free to
> > > > "other functions".
> > >
> > > This is very useful.
> > >
> > > Would you explore something looking similar to what I'm attaching?
> > >
> > > Warning: Compile tested only :-)
> > >
> > > Thanks.
> >
[...]
> >
> > Ok, so this is another approach to reducing CPU time: avoid memcpy of data.
> >
> > That's great if you're not mangling content.
> >
> > But if you are mangling, beware. pktb now has pointers into the buffer you used
> > for receiving from Netlink so you must use a different buffer when sending.
>
> Probably we can store a flag in the pkt_buff structure to say "this
> buffer is now ours" so mangling can just trigger a clone via malloc()
> + memcpy() only for that path.

Not for pktb_make: we never call pktb_free.
>
> Or you can just document this, although handling this case for the
> library would be make it easier to user for users.

ATM I have to document that you must use separate Rx & Tx netlink buffers if
mangling at all, because otherwise you may get overlapping data moves or worse.

So I'm inclined to document about no length increase. But ...

There *is* room at the end of the buffer, as long as the received Netlink
message didn't fill it. We just need some way to know about it - maybe extra
args to the _data functions and maybe as well more _data helper functions to
keep it easy to use.

As well, I've been toying with the idea of not copying data out of the Rx buffer
at all, but rather building the verdict message around it. I have in mind a
user-space-only header to go at the front of the buffer, to be created before
receiving into it.

There's still the copies out from and back into kernel space - guess we're stuck
with those.

Cheers ... Duncan.
>
> Thanks.
