Return-Path: <SRS0=5AJI=YR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 251F1CA9EAF
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 23:52:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 010C621A4C
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 23:52:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732576AbfJXXwG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Oct 2019 19:52:06 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:34207 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727309AbfJXXwG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Oct 2019 19:52:06 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 9BA3B36426F
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Oct 2019 10:51:49 +1100 (AEDT)
Received: (qmail 12635 invoked by uid 501); 24 Oct 2019 23:51:48 -0000
Date:   Fri, 25 Oct 2019 10:51:48 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnfnetlink 1/1] src: Minimally resurrect doxygen
 documentation
Message-ID: <20191024235148.GA8836@dimstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20191014020223.21757-1-duncan_roe@optusnet.com.au>
 <20191014020223.21757-2-duncan_roe@optusnet.com.au>
 <20191023111346.4xoujsy6h2j7cv6y@salvia>
 <20191023153142.GB5848@dimstar.local.net>
 <20191023204836.ws4rv55f2dczhq2q@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023204836.ws4rv55f2dczhq2q@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=v6Ttdrwpusi1BPa057QA:9 a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Wed, Oct 23, 2019 at 10:48:36PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Oct 24, 2019 at 02:31:42AM +1100, Duncan Roe wrote:
> > On Wed, Oct 23, 2019 at 01:13:46PM +0200, Pablo Neira Ayuso wrote:
> > > On Mon, Oct 14, 2019 at 01:02:23PM +1100, Duncan Roe wrote:
> > > > The documentation was written in the days before doxygen required groups or even
> > > > doxygen.cfg, so create doxygen.cfg.in and introduce one \defgroup per source
> > > > file, encompassing pretty-much the whole file.
> > > >
> > [...]
> > > >
> > >
> > > I'm ambivalent about this, it's been up on the table for a while.
> > >
> > > This library is rather old, and new applications should probably
> > > be based instead used libmnl, which is a better choice.
> > >
> > The thing is, the Deprecated functions in libnetfilter_queue are much better
> > documented than the newer functions and that documentation refers to
> > libnfnetlink functions.
>
> Would you help me get better the documentation for the new
> libnetfilter_queue API? I'll be trying to address your questions
> timely in case you decide to enroll in such endeavor.

OK I will take that on as a project.
>
> > So I think that while the deprecated functions are documented, you should really
> > have documentation for the old library they use.
>
> Are you refering to libnfnetlink or libnetfilter_queue in this case?

libnetfilter_queue

> If you insist on documenting libnfnetlink, I'll be fine with it, no
> worries.

Yes I insist. LMK which compiler warning fix you'd like (if any)
>
> > BTW, ldd of my app shows libnfnetlink.so although it doesn't use any deprecated
> > functions. Is that expected?
>
> Yes, there is still code in the libraries that refer to libnfnetlink.
> Replacing some of that code should be feasible via libmnl, it is a
> task that has been in my TODO list for long time. There's always
> something with more priority in the queue.

Cheers ... Duncan.
