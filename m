Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61C6FC07E99
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jul 2021 14:30:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35EAF613BD
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jul 2021 14:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbhGEOdJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Jul 2021 10:33:09 -0400
Received: from mail.netfilter.org ([217.70.188.207]:47998 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbhGEOdJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jul 2021 10:33:09 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 849F861652
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Jul 2021 16:30:21 +0200 (CEST)
Date:   Mon, 5 Jul 2021 16:30:29 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] src: annotation: Correctly identify
 item for which header is needed
Message-ID: <20210705143029.GA29924@salvia>
References: <20210704054708.8495-1-duncan_roe@optusnet.com.au>
 <20210705085246.GA16975@salvia>
 <YOL6jXNMeRGh+BlX@slk1.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YOL6jXNMeRGh+BlX@slk1.local.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 05, 2021 at 10:26:53PM +1000, Duncan Roe wrote:
> On Mon, Jul 05, 2021 at 10:52:46AM +0200, Pablo Neira Ayuso wrote:
> > On Sun, Jul 04, 2021 at 03:47:08PM +1000, Duncan Roe wrote:
> > > Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> > > ---
> > >  examples/nf-queue.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/examples/nf-queue.c b/examples/nf-queue.c
> > > index 3da2c24..7d34081 100644
> > > --- a/examples/nf-queue.c
> > > +++ b/examples/nf-queue.c
> > > @@ -15,7 +15,7 @@
> > >
> > >  #include <libnetfilter_queue/libnetfilter_queue.h>
> > >
> > > -/* only for NFQA_CT, not needed otherwise: */
> > > +/* only for CTA_MARK, not needed otherwise: */
> >    #include <linux/netfilter/nfnetlink_conntrack.h>
> >
> > The reference to NFQA_CT is correct.
> 
> If I comment out the #include, the compiler complains about CTA_MARK. It does
> not complain about NFQA_CT. Perhaps:
> > -/* only for NFQA_CT, not needed otherwise: */
> > +/* only for conntrack attribute CTA_MARK, not needed otherwise: */

Maybe:

/* NFQA_CT requires CTA_* attributes defined in nfnetlink_conntrack.h */

> In any case:
> >
> > enum nfqnl_attr_type {
> [...]
> >         NFQA_CT,                        /* nf_conntrack_netlink.h */
> >
> The header is nfnetlink_conntrack.h, not nf_conntrack_netlink.h.

Good point.

> I can submit a v2 to also fix nf_conntrack_netlink in the cached headers.

Sure, go ahead.
