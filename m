Return-Path: <SRS0=clD7=5W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC7E5C2BA18
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Apr 2020 06:17:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E952206C0
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Apr 2020 06:17:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgDFGRN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Apr 2020 02:17:13 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:55896 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725884AbgDFGRM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Apr 2020 02:17:12 -0400
Received: from dimstar.local.net (n175-34-64-112.sun1.vic.optusnet.com.au [175.34.64.112])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 582317EBD46
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Apr 2020 16:17:05 +1000 (AEST)
Received: (qmail 25280 invoked by uid 501); 6 Apr 2020 06:17:00 -0000
Date:   Mon, 6 Apr 2020 16:17:00 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v2] src: Add faster alternatives to
 pktb_alloc()
Message-ID: <20200406061700.GC13869@dimstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20200108225323.io724vuxuzsydjzs@salvia>
 <20200201062127.4729-1-duncan_roe@optusnet.com.au>
 <20200219180410.e56psjovne3y43rc@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219180410.e56psjovne3y43rc@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=keeXcwCgVCrAuxOn72dlvA==:117 a=keeXcwCgVCrAuxOn72dlvA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10
        a=RSmzAf-M6YYA:10 a=PO7r1zJSAAAA:8 a=csPL-m2dGY2BizXmgCAA:9
        a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Wed, Feb 19, 2020 at 07:04:10PM +0100, Pablo Neira Ayuso wrote:
> On Sat, Feb 01, 2020 at 05:21:27PM +1100, Duncan Roe wrote:
> > Functions pktb_alloc_data, pktb_make and pktb_make_data are defined.
> > The pktb_make pair are syggested as replacements for the pktb_alloc (now) pair
> > because they are always faster.
> >
> > - Add prototypes to include/libnetfilter_queue/pktbuff.h
> > - Add pktb_alloc_data much as per Pablo's email of Wed, 8 Jan 2020
> >   speedup: point to packet data in netlink receive buffer rather than copy to
> >            area immediately following pktb struct
> > - Add pktb_make much like pktb_usebuf proposed on 10 Dec 2019
> >   2 sppedups: 1. Use an existing buffer rather than calloc and (later) free one.
> >               2. Only zero struct and extra parts of pktb - the rest is
> >                  overwritten by copy (calloc has to zero the lot).
> > - Add pktb_make_data
> >   3 speedups: All of the above
> > - Document the new functions
> > - Move pktb_alloc and pktb_alloc_data into the "other functions" group since
> >   they are slower than the "make" equivalent functions
> >
> > Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> > ---
> >  include/libnetfilter_queue/pktbuff.h |   3 +
> >  src/extra/pktbuff.c                  | 296 ++++++++++++++++++++++++++++++-----
> >  2 files changed, 261 insertions(+), 38 deletions(-)
> >
> > diff --git a/include/libnetfilter_queue/pktbuff.h b/include/libnetfilter_queue/pktbuff.h
> > index 42bc153..fc6bf01 100644
> > --- a/include/libnetfilter_queue/pktbuff.h
> > +++ b/include/libnetfilter_queue/pktbuff.h
> > @@ -4,6 +4,9 @@
> >  struct pkt_buff;
> >
> >  struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra);
> > +struct pkt_buff *pktb_alloc_data(int family, void *data, size_t len);
> > +struct pkt_buff *pktb_make(int family, void *data, size_t len, size_t extra, void *buf, size_t bufsize);
> > +struct pkt_buff *pktb_make_data(int family, void *data, size_t len, void *buf, size_t bufsize);
>
> Hm, when I delivered the patch to you, I forgot that you main point
> was that you wanted to skip the memory allocation.
>
> I wonder if all these new functions can be consolidated into one
> single function, something like:
>
>         struct pkt_buff *pktb_alloc2(int family, void *head, size_t head_size, void *data, size_t len, size_t extra);
>
> The idea is that:
>
> * head is the memory area that is large enough for the struct pkt_buff
>   (metadata). You can add a new pktb_head_size() function that returns
>   the size of opaque struct pkt_buff structure (whose layout is not
>   exposed to the user). I think you can this void *buf in your pktb_make
>   function.
>
> * data is the memory area to store the network packet itself.

Wait, you need data & len to describe where the data is *now*. You need an extra
buf, buflen pair for where to put it.
>
> Then, you can allocate head and data in the stack and skip
> malloc/calloc.
>
> Would this work for you? I would prefer if there is just one single
> advanced function to do this.
>
> Thanks for your patience.

I think I can do as you requested.

Just one thing: do you really think pktb_alloc2 is a good name when users *must
not* call pktb_free? pktb_put would have been good but it's already taken.

Perhaps pktb_alloc2 could set a flag for pktb_free to become a no-op and maybe
issue a warning the first time it is called - would that be worth doing?

In pktb_alloc2, if extra == 0 then buf can be NULL and buflen 0, since the data
will be left in place. That way, we get a single entry point doing as much
optimising as possible.

Cheers ... Duncan.
