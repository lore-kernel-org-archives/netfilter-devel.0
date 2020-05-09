Return-Path: <SRS0=rZfM=6X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B28BC28CBC
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 May 2020 17:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D2CA208CA
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 May 2020 17:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgEIR0Y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 May 2020 13:26:24 -0400
Received: from correo.us.es ([193.147.175.20]:59196 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbgEIR0Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 May 2020 13:26:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 36C08DA7E3
        for <netfilter-devel@vger.kernel.org>; Sat,  9 May 2020 19:26:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2593C2067E
        for <netfilter-devel@vger.kernel.org>; Sat,  9 May 2020 19:26:22 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1B009A6A0; Sat,  9 May 2020 19:26:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F138911540C
        for <netfilter-devel@vger.kernel.org>; Sat,  9 May 2020 19:26:19 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 09 May 2020 19:26:19 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D494342EF4E2
        for <netfilter-devel@vger.kernel.org>; Sat,  9 May 2020 19:26:19 +0200 (CEST)
Date:   Sat, 9 May 2020 19:26:19 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue 2/2] pktbuff: add pktb_head_alloc(),
 pktb_setup() and pktb_head_size()
Message-ID: <20200509172619.GA11918@salvia>
References: <20200509091141.10619-1-pablo@netfilter.org>
 <20200509091141.10619-2-pablo@netfilter.org>
 <20200509160903.GF26529@dimstar.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509160903.GF26529@dimstar.local.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, May 10, 2020 at 02:09:03AM +1000, Duncan Roe wrote:
> On Sat, May 09, 2020 at 11:11:41AM +0200, Pablo Neira Ayuso wrote:
> > Add two new helper functions, as alternative to pktb_alloc().
> >
> > * pktb_setup() allows you to skip memcpy()'ing the payload from the
> >   netlink message.
> >
> > * pktb_head_size() returns the size of the pkt_buff opaque object.
> >
> > * pktb_head_alloc() allows you to allocate the pkt_buff in the heap.
> >
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  include/libnetfilter_queue/pktbuff.h |  7 +++++++
> >  src/extra/pktbuff.c                  | 20 ++++++++++++++++++++
> >  2 files changed, 27 insertions(+)
> >
> > diff --git a/include/libnetfilter_queue/pktbuff.h b/include/libnetfilter_queue/pktbuff.h
> > index 42bc153ec337..a27582b02840 100644
> > --- a/include/libnetfilter_queue/pktbuff.h
> > +++ b/include/libnetfilter_queue/pktbuff.h
> > @@ -6,6 +6,13 @@ struct pkt_buff;
> >  struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra);
> >  void pktb_free(struct pkt_buff *pktb);
> >
> > +#define NFQ_BUFFER_SIZE	(0xffff + (MNL_SOCKET_BUFFER_SIZE / 2)
> > +struct pkt_buff *pktb_setup(struct pkt_buff *pktb, int family, uint8_t *data,
> > +			    size_t len, size_t extra);
> > +size_t pktb_head_size(void);
> > +
> > +#define pktb_head_alloc()	(struct pkt_buff *)(malloc(pktb_head_size()))
> > +
> >  uint8_t *pktb_data(struct pkt_buff *pktb);
> >  uint32_t pktb_len(struct pkt_buff *pktb);
> >
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

There are "two buffers":

1) The buffer that you use to receive the netlink message. This buffer
   is parsed via mnl_cb_run().

2) The buffer that stores the pkt_buff structure.

pktb_setup() is called after mnl_cb_run(), once you have already
parsed the buffer that you have received from netlink. You might want
to pass the pointer to the data to mnl_cb_run().

If you would like to mangle the payload, then you can memcpy() the
attr[NFQA_PAYLOAD] and specify how many extra bytes (unused) are
available in the new buffer.

If you use attr[NFQA_PAYLOAD], then extra is zero.

This already allowing you to allocate the data in the stack as you
would like to do.
