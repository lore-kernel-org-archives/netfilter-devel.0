Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE8F4C07E96
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Jul 2021 00:05:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE1EB61C3C
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Jul 2021 00:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhGGAIS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jul 2021 20:08:18 -0400
Received: from mail.netfilter.org ([217.70.188.207]:52970 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbhGGAIR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jul 2021 20:08:17 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 751E86165D
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Jul 2021 02:05:26 +0200 (CEST)
Date:   Wed, 7 Jul 2021 02:05:35 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v2] src: annotation: Correctly
 identify item for which header is needed
Message-ID: <20210707000535.GA14395@salvia>
References: <YOL6jXNMeRGh+BlX@slk1.local.net>
 <20210706013656.10833-1-duncan_roe@optusnet.com.au>
 <20210706224657.GA12859@salvia>
 <YOTu7qROo1iL/09T@slk1.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YOTu7qROo1iL/09T@slk1.local.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jul 07, 2021 at 10:01:50AM +1000, Duncan Roe wrote:
> On Wed, Jul 07, 2021 at 12:46:57AM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Jul 06, 2021 at 11:36:56AM +1000, Duncan Roe wrote:
> > > Also fix header annotation to refer to nfnetlink_conntrack.h,
> > > not nf_conntrack_netlink.h
> >
> > Please, split this in two patches. See below. Thanks.
> >
> > > Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> > > ---
> > >  examples/nf-queue.c                                | 2 +-
> > >  include/libnetfilter_queue/linux_nfnetlink_queue.h | 4 ++--
> > >  include/linux/netfilter/nfnetlink_queue.h          | 4 ++--
> > >  3 files changed, 5 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/examples/nf-queue.c b/examples/nf-queue.c
> > > index 3da2c24..5b86e69 100644
> > > --- a/examples/nf-queue.c
> > > +++ b/examples/nf-queue.c
> > > @@ -15,7 +15,7 @@
> > >
> > >  #include <libnetfilter_queue/libnetfilter_queue.h>
> > >
> > > -/* only for NFQA_CT, not needed otherwise: */
> > > +/* NFQA_CT requires CTA_* attributes defined in nfnetlink_conntrack.h */
> > >  #include <linux/netfilter/nfnetlink_conntrack.h>
> > >
> > >  static struct mnl_socket *nl;
> >
> > This chunk belongs to libnetfilter_queue.
> >
> > > diff --git a/include/libnetfilter_queue/linux_nfnetlink_queue.h b/include/libnetfilter_queue/linux_nfnetlink_queue.h
> > > index 1975dfa..caa6788 100644
> > > --- a/include/libnetfilter_queue/linux_nfnetlink_queue.h
> > > +++ b/include/libnetfilter_queue/linux_nfnetlink_queue.h
> >
> > This chunk below, belongs to the nf tree. You have to fix first the
> > kernel UAPI, then you can refresh this copy that is stored in
> > libnetfilter_queue.
> 
> I already sent you an nf-next patch which you said you would forward to nf.

Yes, it can be applied to nf as I said since it is a fix, it needs
changes, I'm refering to this patch:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210705123829.10090-1-duncan_roe@optusnet.com.au/

> I don't have the nf tree here but I guess the nf-next package will apply if
> I re-package.

The nf and nf-next trees look the same for nfnetlink_queue.h, you can
base your patch on either tree, just use [PATCH nf] to target this to
the nf git.

> Will send 3 patches as you request.

Thanks. I'll review them.
