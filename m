Return-Path: <SRS0=9gIA=6L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92DC7C54FD0
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Apr 2020 11:06:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A499206B6
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Apr 2020 11:06:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgD0LGT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Apr 2020 07:06:19 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:39612 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726485AbgD0LGT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Apr 2020 07:06:19 -0400
Received: from dimstar.local.net (n175-34-64-112.sun1.vic.optusnet.com.au [175.34.64.112])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 4EDE0821224
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2020 21:06:15 +1000 (AEST)
Received: (qmail 22349 invoked by uid 501); 27 Apr 2020 11:06:14 -0000
Date:   Mon, 27 Apr 2020 21:06:14 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnetfilter_queue 0/3] pktbuff API updates
Message-ID: <20200427110614.GA15436@dimstar.local.net>
Mail-Followup-To: netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20200426132356.8346-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200426132356.8346-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=keeXcwCgVCrAuxOn72dlvA==:117 a=keeXcwCgVCrAuxOn72dlvA==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=RSmzAf-M6YYA:10 a=OLL_FvSJAAAA:8
        a=K_pkYZjdYe5xUPkQLiYA:9 a=CjuIK1q_8ugA:10 a=SAszQ4RR6nkA:10
        a=Z7RzNMET8NMA:10 a=oIrB72frpwYPwTMnlWqB:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Sun, Apr 26, 2020 at 03:23:53PM +0200, Pablo Neira Ayuso wrote:
> Hi Duncan,
>
> This is another turn / incremental update to the pktbuff API based on
> your feedback:
>
> Patch #1 adds pktb_alloc_head() to allocate the pkt_buff structure.
> 	 This patch also adds pktb_build_data() to set up the pktbuff
> 	 data pointer.
>
> Patch #2 updates the existing example to use pktb_alloc_head() and
>          pktb_build_data().
>
> Patch #3 adds a few helper functions to set up the pointer to the
>          network header.
>
> Your goal is to avoid the memory allocation and the memcpy() in
> pktb_alloc(). With this scheme, users pre-allocate the pktbuff object
> from the configuration step, and then this object is recycled for each
> packet that is received from the kernel.
>
> Would this update fit for your usecase?

No, sorry. The show-stopper is, no allowance for the "extra" arg, when you might
want to mangle a packet tobe larger than it was.

For "extra" support, you need something with the sophistication of pktb_malloc2.
If extra == 0, pktb_malloc2 optimises by leaving the packet data where it was.
Actually pktb_malloc2 doesn't need to make this decision. That can be deferred
to pktb_mangle, which could do the copy if it has been told to expand a packet
and the copy has not already been done (new "copy done" flag in the opaque
struct pkt_buff).

My nfq-based accidentally-written ad blocker would benefit from that deferment -
I allow extra bytes in case I have to lengthen a domain name, but most of the
time I'm shortening them.
>
> Thanks.
>
> P.S: I'm sorry for the time being, it's been hectic here.
>
> Pablo Neira Ayuso (3):
>   pktbuff: add pktb_alloc_head() and pktb_build_data()
>   example: nf-queue: use pkt_buff
>   pktbuff: add pktb_reset_network_header() and pktb_set_network_header()
>
>  examples/nf-queue.c                  | 25 +++++++++++++++++++--
>  include/libnetfilter_queue/pktbuff.h |  6 +++++
>  src/extra/pktbuff.c                  | 33 ++++++++++++++++++++++++++++
>  3 files changed, 62 insertions(+), 2 deletions(-)
>
> --
> 2.20.1
>
In https://www.spinics.net/lists/netfilter-devel/msg65830.html, you suggested a
pair of functions: pktb_alloc2 & pktb_head_size.

I really prefer that to your new suggestions.

More later,

Cheers ... Duncan.
