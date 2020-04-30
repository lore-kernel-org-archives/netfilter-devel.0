Return-Path: <SRS0=RE83=6O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 120FBC83001
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 06:34:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED17220784
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 06:34:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbgD3GeI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Apr 2020 02:34:08 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:38284 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726378AbgD3GeI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Apr 2020 02:34:08 -0400
Received: from dimstar.local.net (n175-34-64-112.sun1.vic.optusnet.com.au [175.34.64.112])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id B4F5B820C58
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2020 16:34:05 +1000 (AEST)
Received: (qmail 11726 invoked by uid 501); 30 Apr 2020 06:34:04 -0000
Date:   Thu, 30 Apr 2020 16:34:04 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnetfilter_queue 0/3] pktbuff API updates
Message-ID: <20200430063404.GF3833@dimstar.local.net>
Mail-Followup-To: Netfilter Development <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20200427170656.GA22296@salvia>
 <20200428043302.GB15436@dimstar.local.net>
 <20200428103407.GA1160@salvia>
 <20200428211452.GF15436@dimstar.local.net>
 <20200428225520.GA30421@salvia>
 <20200429132840.GA3833@dimstar.local.net>
 <20200429191047.GB3833@dimstar.local.net>
 <20200429191643.GA16749@salvia>
 <20200429203029.GD3833@dimstar.local.net>
 <20200429210512.GA14508@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429210512.GA14508@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=keeXcwCgVCrAuxOn72dlvA==:117 a=keeXcwCgVCrAuxOn72dlvA==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=RSmzAf-M6YYA:10 a=OLL_FvSJAAAA:8
        a=voM4FWlXAAAA:8 a=3HDBlxybAAAA:8 a=_vdq4B85Ww93OoYmRX4A:9
        a=32EQcqo6bRQ160ow:21 a=a9a8tTNdu4p-3ijc:21 a=CjuIK1q_8ugA:10
        a=SAszQ4RR6nkA:10 a=Z7RzNMET8NMA:10 a=oIrB72frpwYPwTMnlWqB:22
        a=IC2XNlieTeVoXbcui8wp:22 a=laEoCiVfU_Unz3mSdgXN:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 29, 2020 at 11:05:12PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Apr 30, 2020 at 06:30:29AM +1000, Duncan Roe wrote:
> > Hi Pablo,
> >
> > I sent this email (explanation of how the system works) before I saw your email
> > asking for that explanation.
> >
> > Then I replied to that email of yours before I saw this one.
> >
> > On Wed, Apr 29, 2020 at 09:16:43PM +0200, Pablo Neira Ayuso wrote:
> > > On Thu, Apr 30, 2020 at 05:10:47AM +1000, Duncan Roe wrote:
> > > [...]
> > > > Sorry, I should have explained a bit more how the system would work:
> > > >
> > > > struct pkt_buff has 3 new members:
> > > >
> > > >         bool    copy_done;
> > > >         uint32_t extra;
> > > >         uint8_t *copy_buf;
> > > >
> > > > When extra > 0, pktb_alloc2 verifies that buflen is >= len + extra. It then
> > > > stores extra and copy_buf in pktb, ready for use by pktb_mangle() (all the other
> > > > manglers call this eventually).
> > > >
> > > > So that's how pktb_mangle() doesn't need to allocate a buffer.
> > >
> > > Thanks for the explaining. Given this is in userspace, it is easier if
> >
> > Tiny nit - this could be userspace on an embedded device where memory is really
> > tight. So perhaps document with "If memory is at a premium, you really only need
> > len + extra" otherwise a big buf is fine.
>
> This buffer is still relatively small, the reallocation also forces
> the user to refetch pointers. Skipping all that complexity for a bit
> of memory in userspace is fine.

Oh well in that case, how about:

>	struct pkt_buff *pktb_alloc2(int family, void *buf, size_t buf_size, void *data, size_t len, size_t extra);

I.e. exactly as you suggested in
https://www.spinics.net/lists/netfilter-devel/msg65830.html except s/head/buf/

And we tell users to dimension buf to NFQ_BUFFER_SIZE. We don't even need to
expose pktb_head_size().
>
> > > the user allocates the maximum packet length that is possible:
> > >
> > >         0xffff + (MNL_SOCKET_BUFFER_SIZE/2);
> > >
> > > We can probably expose this to the header so they can pre-allocate a
> > > buffer that is large enough and, hence, _mangle() is guaranteed to
> > > have always enough room to add extra bytes.
> >
> > Yes I saw that expression in examples/nf-queue.c. How about
> >
> > #define COPY_BUF_SIZE (0xffff + (MNL_SOCKET_BUFFER_SIZE/2))
> >
> > or what other name would you like?
>
> I'd suggest to add the NFQ_ prefix, probably NFQ_BUFFER_SIZE is fine.
>
> > --- Off-topic
> >
> > I'm intrigued that you ccan use MNL_SOCKET_BUFFER_SIZE when dimensioning static
> > variables. The expansion is
> >
> > #define MNL_SOCKET_BUFFER_SIZE (sysconf(_SC_PAGESIZE) < 8192L ?
> > sysconf(_SC_PAGESIZE) : 8192L)
> >
> > and sysconf is an actual function:
> >
> > unistd.h:622:extern long int sysconf (int __name) __THROW;
> >
> > If I try to dimension a static variable using pktb_head_size(), the compiler
> > throws an error.  Why is sysconf() ok but not pktb_head_size()?
>
> I'm fine to expose if you would like to add pktb_head_size() if you
> prefer to store the pkt_buff in the stack. You will have to use
> pktb_build_data() [1] to initialize the pkt_buff. Would that work for you?
>
> [1] https://patchwork.ozlabs.org/project/netfilter-devel/patch/20200426132356.8346-2-pablo@netfilter.org/
