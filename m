Return-Path: <SRS0=QRwA=YQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F65CA9EB6
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Oct 2019 15:12:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B6CC21872
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Oct 2019 15:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392431AbfJWPMW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Oct 2019 11:12:22 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:50357 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390140AbfJWPMV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Oct 2019 11:12:21 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 11BD743E6D7
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Oct 2019 02:12:06 +1100 (AEDT)
Received: (qmail 6173 invoked by uid 501); 23 Oct 2019 15:12:05 -0000
Date:   Thu, 24 Oct 2019 02:12:05 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnfnetlink 1/1] src: Minimally resurrect doxygen
 documentation
Message-ID: <20191023151205.GA5848@dimstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20191014020223.21757-1-duncan_roe@optusnet.com.au>
 <20191014020223.21757-2-duncan_roe@optusnet.com.au>
 <20191023111346.4xoujsy6h2j7cv6y@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023111346.4xoujsy6h2j7cv6y@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=ln3mycrPa8d4u8wgigQA:9 a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 23, 2019 at 01:13:46PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Oct 14, 2019 at 01:02:23PM +1100, Duncan Roe wrote:
> > The documentation was written in the days before doxygen required groups or even
> > doxygen.cfg, so create doxygen.cfg.in and introduce one \defgroup per source
> > file, encompassing pretty-much the whole file.
> >
> > Also add a tiny \mainpage.
> >
> > Added:
> >
> >  doxygen.cfg.in: Same as for libmnl except FILE_PATTERNS = *.c linux_list.h
> >
> > Updated:
> >
> >  configure.ac: Create doxygen.cfg
> >
> >  include/linux_list.h: Add defgroup
> >
> >  src/iftable.c: Add defgroup
> >
> >  src/libnfnetlink.c: Add mainpage and defgroup
>
> I'm ambivalent about this, it's been up on the table for a while.
>
> This library is rather old, and new applications should probably
> be based instead used libmnl, which is a better choice.
>
> Did you already queue patches to make documentation for libnfnetlink
> locally there? I would like not to discourage you in your efforts to
> help us improve documentation, which is always extremely useful for
> everyone.
>
> Let me know, thanks.

Very timely of you to ask.

Just this morning I was going to get back into libnetfilter_queue documentation,
starting with the other 2 verdict helpers.

But I ran into a conundrum with nfq_nlmsg_verdict_put_mark (the one I didn't
use). It's a 1-liner (in src/nlmsg.c):

> 56  mnl_attr_put_u32(nlh, NFQA_MARK, htonl(mark));

But examples/nf-queue.c has an example to set the connmark which doesn't use
nfq_nlmsg_verdict_put_mark()

Instead it has this line:

> 52  mnl_attr_put_u32(nlh, CTA_MARK, htonl(42));

The trouble is, NFQA_MARK *is different from* CTA_MARK. NFQA_MARK is 3, while
CTA_MARK is 8.

At this point, I felt I did not understand the software well enough to be able
to document it further. If you could shed some light on this apparent
disrcepancy, it might restore my self-confidence sufficiently that I can
continue documenting.

Cheers ... Duncan.
