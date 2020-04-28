Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CAB4C83004
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 10:34:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 731EA206D6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 10:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgD1KeX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Apr 2020 06:34:23 -0400
Received: from correo.us.es ([193.147.175.20]:36244 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726309AbgD1KeW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 06:34:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EFECF6D8CA
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 12:34:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C1BC8B801B
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 12:34:19 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9FFD6BAAB8; Tue, 28 Apr 2020 12:34:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3FC54BAC2F
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 12:34:08 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 28 Apr 2020 12:34:08 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1F15242EF4E7
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 12:34:08 +0200 (CEST)
Date:   Tue, 28 Apr 2020 12:34:07 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue 0/3] pktbuff API updates
Message-ID: <20200428103407.GA1160@salvia>
References: <20200426132356.8346-1-pablo@netfilter.org>
 <20200427110614.GA15436@dimstar.local.net>
 <20200427170656.GA22296@salvia>
 <20200428043302.GB15436@dimstar.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428043302.GB15436@dimstar.local.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 28, 2020 at 02:33:02PM +1000, Duncan Roe wrote:
> On Mon, Apr 27, 2020 at 07:06:56PM +0200, Pablo Neira Ayuso wrote:
> > Hi Duncan,
> >
> > On Mon, Apr 27, 2020 at 09:06:14PM +1000, Duncan Roe wrote:
> > > Hi Pablo,
> > >
> > > On Sun, Apr 26, 2020 at 03:23:53PM +0200, Pablo Neira Ayuso wrote:
> > > > Hi Duncan,
> > > >
> > > > This is another turn / incremental update to the pktbuff API based on
> > > > your feedback:
> > > >
> > > > Patch #1 adds pktb_alloc_head() to allocate the pkt_buff structure.
> > > > 	 This patch also adds pktb_build_data() to set up the pktbuff
> > > > 	 data pointer.
> > > >
> > > > Patch #2 updates the existing example to use pktb_alloc_head() and
> > > >          pktb_build_data().
> > > >
> > > > Patch #3 adds a few helper functions to set up the pointer to the
> > > >          network header.
> > > >
> > > > Your goal is to avoid the memory allocation and the memcpy() in
> > > > pktb_alloc(). With this scheme, users pre-allocate the pktbuff object
> > > > from the configuration step, and then this object is recycled for each
> > > > packet that is received from the kernel.
> > > >
> > > > Would this update fit for your usecase?
> > >
> > > No, sorry. The show-stopper is, no allowance for the "extra" arg,
> > > when you might want to mangle a packet tobe larger than it was.
> >
> > I see, maybe pktb_build_data() can be extended to take the "extra"
> > arg. Or something like this:
> >
> >  void pktb_build_data(struct pkt_buff *pktb, uint8_t *payload, uint32_t size, uint32_t len)
> >
> > where size is the total buffer size, and len is the number of bytes
> > that are in used in the buffer.
> 
> I really do not like the direction this is taking. pktb_build_data() is one of 4
> new functions you are suggesting, the others being pktb_alloc_head(),
> pktb_reset_network_header() and pktb_set_network_header(). In
> https://www.spinics.net/lists/netfilter-devel/msg65830.html, you asked
> 
> > I wonder if all these new functions can be consolidated into one
> > single function, something like:
> >
> >         struct pkt_buff *pktb_alloc2(int family, void *head, size_t head_size, void *data, size_t len, size_t extra);

pktb_alloc2() still has a memcpy which is not needed by people that do
not need to mangle the packet.

> That's what I have delivered, except for 2 extra args on the end for the packet
> copy buffer. And I get rid of pktb_free(), or at least deprecate and move it off
> the main doc page into the "Other functions" page.
> 
> Also pktb_set_network_header() makes no allowance for AF_BRIDGE.

This is not a problem, you only have to call this function with
ETH_HLEN to set the offset in case of bridge.

> Can we please just stick with
> 
> > struct pkt_buff *pktb_alloc2(int family, void *head, size_t headsize,
> >                              void *data, size_t len, size_t extra,
> >                              void *buf, size_t bufsize)

I'm fine if you still like the simplified pktb_alloc2() call, that's OK.

[...]
> > I think it's fine if pktb_mangle() deals with this data buffer
> > reallocation in case it needs to expand the packet, a extra patch on
> > top of this should be fine.
> 
> OK - will start on a patch based on
> https://www.spinics.net/lists/netfilter-devel/msg66710.html

Revisiting, I would prefer to keep things simple. The caller should
make sure that pktb_mangle() has a buffer containing enough room. I
think it's more simple for the caller to allocate a buffer that is
large enough for any mangling.
