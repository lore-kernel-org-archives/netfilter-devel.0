Return-Path: <SRS0=9gIA=6L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B57FC54FD0
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Apr 2020 17:07:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6228A20738
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Apr 2020 17:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgD0RHC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Apr 2020 13:07:02 -0400
Received: from correo.us.es ([193.147.175.20]:38678 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726217AbgD0RHB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Apr 2020 13:07:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 943591BFA80
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2020 19:06:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 838CABAAA3
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2020 19:06:59 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 79370BAAB8; Mon, 27 Apr 2020 19:06:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 66DE0BAAAF
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2020 19:06:57 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 27 Apr 2020 19:06:57 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 49EC742EF9E0
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2020 19:06:57 +0200 (CEST)
Date:   Mon, 27 Apr 2020 19:06:56 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue 0/3] pktbuff API updates
Message-ID: <20200427170656.GA22296@salvia>
References: <20200426132356.8346-1-pablo@netfilter.org>
 <20200427110614.GA15436@dimstar.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427110614.GA15436@dimstar.local.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Duncan,

On Mon, Apr 27, 2020 at 09:06:14PM +1000, Duncan Roe wrote:
> Hi Pablo,
> 
> On Sun, Apr 26, 2020 at 03:23:53PM +0200, Pablo Neira Ayuso wrote:
> > Hi Duncan,
> >
> > This is another turn / incremental update to the pktbuff API based on
> > your feedback:
> >
> > Patch #1 adds pktb_alloc_head() to allocate the pkt_buff structure.
> > 	 This patch also adds pktb_build_data() to set up the pktbuff
> > 	 data pointer.
> >
> > Patch #2 updates the existing example to use pktb_alloc_head() and
> >          pktb_build_data().
> >
> > Patch #3 adds a few helper functions to set up the pointer to the
> >          network header.
> >
> > Your goal is to avoid the memory allocation and the memcpy() in
> > pktb_alloc(). With this scheme, users pre-allocate the pktbuff object
> > from the configuration step, and then this object is recycled for each
> > packet that is received from the kernel.
> >
> > Would this update fit for your usecase?
> 
> No, sorry. The show-stopper is, no allowance for the "extra" arg, when you might
> want to mangle a packet tobe larger than it was.

I see, maybe pktb_build_data() can be extended to take the "extra"
arg. Or something like this:

 void pktb_build_data(struct pkt_buff *pktb, uint8_t *payload, uint32_t size, uint32_t len)

where size is the total buffer size, and len is the number of bytes
that are in used in the buffer.

> For "extra" support, you need something with the sophistication of pktb_malloc2.
> If extra == 0, pktb_malloc2 optimises by leaving the packet data where it was.

With this patchset, the user is in control of the data buffer memory
area that is attached to the pkt_buff head, so you can just allocate
the as many extra byte as you require.

> Actually pktb_malloc2 doesn't need to make this decision. That can be deferred
> to pktb_mangle, which could do the copy if it has been told to expand a packet
> and the copy has not already been done (new "copy done" flag in the opaque
> struct pkt_buff).

I think it's fine if pktb_mangle() deals with this data buffer
reallocation in case it needs to expand the packet, a extra patch on
top of this should be fine.

> My nfq-based accidentally-written ad blocker would benefit from that deferment -
> I allow extra bytes in case I have to lengthen a domain name, but most of the
> time I'm shortening them.

Thanks for explaining.
