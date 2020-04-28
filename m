Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 544DDC83004
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 21:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E6DB2072A
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 21:15:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgD1VPC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Apr 2020 17:15:02 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:36819 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726535AbgD1VO4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 17:14:56 -0400
Received: from dimstar.local.net (n175-34-64-112.sun1.vic.optusnet.com.au [175.34.64.112])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 44A30820ADB
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 07:14:53 +1000 (AEST)
Received: (qmail 1104 invoked by uid 501); 28 Apr 2020 21:14:52 -0000
Date:   Wed, 29 Apr 2020 07:14:52 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue 0/3] pktbuff API updates
Message-ID: <20200428211452.GF15436@dimstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20200426132356.8346-1-pablo@netfilter.org>
 <20200427110614.GA15436@dimstar.local.net>
 <20200427170656.GA22296@salvia>
 <20200428043302.GB15436@dimstar.local.net>
 <20200428103407.GA1160@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428103407.GA1160@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=keeXcwCgVCrAuxOn72dlvA==:117 a=keeXcwCgVCrAuxOn72dlvA==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=RSmzAf-M6YYA:10 a=OLL_FvSJAAAA:8
        a=MCESyHqk0TfmNL7siMoA:9 a=NK350nmagHTuHoZv:21 a=6WyNACks00FMYP41:21
        a=CjuIK1q_8ugA:10 a=SAszQ4RR6nkA:10 a=OVJnjtlDKZIA:10 a=Z7RzNMET8NMA:10
        a=AH0NCSqBHYIA:10 a=oIrB72frpwYPwTMnlWqB:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 28, 2020 at 12:34:07PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Apr 28, 2020 at 02:33:02PM +1000, Duncan Roe wrote:
> > On Mon, Apr 27, 2020 at 07:06:56PM +0200, Pablo Neira Ayuso wrote:
> > > Hi Duncan,
> > >
> > > On Mon, Apr 27, 2020 at 09:06:14PM +1000, Duncan Roe wrote:
> > > > Hi Pablo,
> > > >
> > > > On Sun, Apr 26, 2020 at 03:23:53PM +0200, Pablo Neira Ayuso wrote:
> > > > > Hi Duncan,
> > > > >
> > > > > This is another turn / incremental update to the pktbuff API based on
> > > > > your feedback:
> > > > >
> > > > > Patch #1 adds pktb_alloc_head() to allocate the pkt_buff structure.
> > > > > 	 This patch also adds pktb_build_data() to set up the pktbuff
> > > > > 	 data pointer.
> > > > >
> > > > > Patch #2 updates the existing example to use pktb_alloc_head() and
> > > > >          pktb_build_data().
> > > > >
> > > > > Patch #3 adds a few helper functions to set up the pointer to the
> > > > >          network header.
> > > > >
> > > > > Your goal is to avoid the memory allocation and the memcpy() in
> > > > > pktb_alloc(). With this scheme, users pre-allocate the pktbuff object
> > > > > from the configuration step, and then this object is recycled for each
> > > > > packet that is received from the kernel.
> > > > >
> > > > > Would this update fit for your usecase?
> > > >
> > > > No, sorry. The show-stopper is, no allowance for the "extra" arg,
> > > > when you might want to mangle a packet tobe larger than it was.
> > >
> > > I see, maybe pktb_build_data() can be extended to take the "extra"
> > > arg. Or something like this:
> > >
> > >  void pktb_build_data(struct pkt_buff *pktb, uint8_t *payload, uint32_t size, uint32_t len)
> > >
> > > where size is the total buffer size, and len is the number of bytes
> > > that are in used in the buffer.
> >
> > I really do not like the direction this is taking. pktb_build_data() is one of 4
> > new functions you are suggesting, the others being pktb_alloc_head(),
> > pktb_reset_network_header() and pktb_set_network_header(). In
> > https://www.spinics.net/lists/netfilter-devel/msg65830.html, you asked
> >
> > > I wonder if all these new functions can be consolidated into one
> > > single function, something like:
> > >
> > >         struct pkt_buff *pktb_alloc2(int family, void *head, size_t head_size, void *data, size_t len, size_t extra);
>
> pktb_alloc2() still has a memcpy which is not needed by people that do
> not need to mangle the packet.

No it does not. Please look again. There is only a memcpy if the caller
specifies extra > 0, in which case she clearly intends to mangle it (perhaps
depending on its contents).

"depending on its contents" is where the memcpy deferral comes in. pktb_alloc2()
verifies that the supplied buffer is big enough (size >= len + extra). The user
declared it as a stack variable that size so it will be. With the deferral
enhancement, pktb_alloc2() records the buffer address and extra in the enlarged
struct pktbuff (extra is needed to tell pktb_mangle how much memory to memset to
0).

If pktb_mangle() finds it has to make the packet larger then its original length
and the packet is still in its original location then copy it and zero extra.
(i.e. pktb_mangle() doesn't just check whether it was asked to make the packet
bigger: it might have previously been asked to make it smaller).

Also (and this *is* tricky, update relevant pointers in the struct pktbuff).
That invalidates any poiners the caller may have obtained from e.g. pktb_data()
- see end of email.
>
> > That's what I have delivered, except for 2 extra args on the end for the packet
> > copy buffer. And I get rid of pktb_free(), or at least deprecate and move it off
> > the main doc page into the "Other functions" page.
> >
> > Also pktb_set_network_header() makes no allowance for AF_BRIDGE.
>
> This is not a problem, you only have to call this function with
> ETH_HLEN to set the offset in case of bridge.
>
> > Can we please just stick with
> >
> > > struct pkt_buff *pktb_alloc2(int family, void *head, size_t headsize,
> > >                              void *data, size_t len, size_t extra,
> > >                              void *buf, size_t bufsize)
>
> I'm fine if you still like the simplified pktb_alloc2() call, that's OK.
>
> [...]
> > > I think it's fine if pktb_mangle() deals with this data buffer
> > > reallocation in case it needs to expand the packet, a extra patch on
> > > top of this should be fine.
> >
> > OK - will start on a patch based on
> > https://www.spinics.net/lists/netfilter-devel/msg66710.html
>
> Revisiting, I would prefer to keep things simple. The caller should
> make sure that pktb_mangle() has a buffer containing enough room. I
> think it's more simple for the caller to allocate a buffer that is
> large enough for any mangling.

Yes it's more complex. No problem with the buffer - the user gave that to
pktb_alloc2().

Problem is that if mangler moves the packet, then any packet pointer the caller
had is invalid (points to the un-mangled copy). This applies at all levels, e.g.
nfq_udp_get_payload(). There is no way for the mangler functions to address
this: it just has to be highlighted in the documentation.

Still, I really like the deferred copy enhancement. Your thoughts?

Cheers ... Duncan.
