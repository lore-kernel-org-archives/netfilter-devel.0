Return-Path: <SRS0=7yxH=7C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E76D5C433DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 May 2020 05:54:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C29A2206BE
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 May 2020 05:54:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbgETFyY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 May 2020 01:54:24 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:53719 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726473AbgETFyY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 May 2020 01:54:24 -0400
Received: from dimstar.local.net (n175-34-64-112.sun1.vic.optusnet.com.au [175.34.64.112])
        by mail109.syd.optusnet.com.au (Postfix) with SMTP id D6D23D78C8B
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 15:54:20 +1000 (AEST)
Received: (qmail 11822 invoked by uid 501); 20 May 2020 05:54:15 -0000
Date:   Wed, 20 May 2020 15:54:15 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue 2/2] pktbuff: add pktb_head_alloc(),
 pktb_setup() and pktb_head_size()
Message-ID: <20200520055415.GD23132@dimstar.local.net>
Mail-Followup-To: netfilter-devel@vger.kernel.org
References: <20200509091141.10619-1-pablo@netfilter.org>
 <20200509091141.10619-2-pablo@netfilter.org>
 <20200509160903.GF26529@dimstar.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509160903.GF26529@dimstar.local.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=keeXcwCgVCrAuxOn72dlvA==:117 a=keeXcwCgVCrAuxOn72dlvA==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=RSmzAf-M6YYA:10
        a=pSWfypDpz6p3KOhGoOUA:9 a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, May 10, 2020 at 02:09:03AM +1000, Duncan Roe wrote:
> On Sat, May 09, 2020 at 11:11:41AM +0200, Pablo Neira Ayuso wrote:
[...]
> > diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
> > index 118ad898f63b..6acefbe72a9b 100644
> > --- a/src/extra/pktbuff.c
> > +++ b/src/extra/pktbuff.c
> > @@ -103,6 +103,26 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
> >  	return pktb;
> >  }
> >
> > +EXPORT_SYMBOL
> > +struct pkt_buff *pktb_setup(struct pkt_buff *pktb, int family, uint8_t *buf,
> > +			    size_t len, size_t extra)
> > +{
> > +	pktb->data_len = len + extra;
>
> Are you proposing to be able to use extra space in the receive buffer?
> I think that is unsafe. mnl_cb_run() steps through that bufffer and needs a
> zero following the last message to know there are no more. At least, that's
> how it looks to me on stepping through with gdb.

That's wrong - sorry. mnl_cb_run() *does* step through the received buffer but
uses the byte count at the front of each message. When there are not enough
unprocessed bytes for another message header (usually there are zero) then it
returns. So there is room to enlarge the packet in the read buffer if it is in
the last (or only) netlink message in that buffer.

In tests I have never seen more than one netlink message returned in the receive
buffer. Even stopping the nfq program with gdb and then sending 10 or so UDP
messges, each call to mnl_socket_recvfrom() only returns a single netlink
message.

If this always happens, there is no need for memcpy() at all. And even if it
doesn't, one could programatically check whether the struct nlmsghdr passed by
queue_cb() is the last in the receive buffer and memcpy() if not.

Any comments?
>
[...]

Cheers ... Duncan.
