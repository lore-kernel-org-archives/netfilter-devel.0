Return-Path: <SRS0=SsnH=2M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1BCEC2D0C3
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Dec 2019 02:24:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2121206D3
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Dec 2019 02:24:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbfLVCYE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Dec 2019 21:24:04 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:46539 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726131AbfLVCYE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Dec 2019 21:24:04 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 6D8943A1746
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Dec 2019 13:23:51 +1100 (AEDT)
Received: (qmail 16312 invoked by uid 501); 22 Dec 2019 02:23:51 -0000
Date:   Sun, 22 Dec 2019 13:23:51 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: Documentation question
Message-ID: <20191222022351.GB1804@dimstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20191215020220.GA10616@dimstar.local.net>
 <20191220002953.gv25rcn7kvv43zk4@salvia>
 <20191221104345.GA10475@dimstar.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191221104345.GA10475@dimstar.local.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=pxVhFHJ0LMsA:10
        a=RSmzAf-M6YYA:10 a=ZhCHxgLN90Xc5NeUzKoA:9 a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Dec 21, 2019 at 09:43:45PM +1100, Duncan Roe wrote:
> On Fri, Dec 20, 2019 at 01:29:53AM +0100, Pablo Neira Ayuso wrote:
> > On Sun, Dec 15, 2019 at 01:02:20PM +1100, Duncan Roe wrote:
> > > Hi Pablo,
> > >
> > > In pktbuff.c, the doc for pktb_mangle states that "It is appropriate to use
> > > pktb_mangle to change the MAC header".
> > >
> > > This is not true. pktb_mangle always mangles from the network header onwards.
> > >
> > > I can either:
> > >
> > > Whithdraw the offending doc items
> > >
> > > OR:
> > >
> > > Adjust pktb_mangle to make the doc correct. This involves changing pktb_mangle,
> > > nfq_ip_mangle and (soon) nfq_ip6_mangle. The changes would be a no-op for
> > > AF_INET and AF_INET6 packet buffers.
> > >
> > > What do you think?
> >
> > You could fix it through signed int dataoff. So the users could
> > specify a negative offset to mangle the MAC address.
> >
> > This function was made to update layer 7 payload information to
> > implement the helpers. So dataoff usually contains the transport
> > header size.
> >
> > Let me know, thanks.
> >
> -ve offsets? There has to be a better way.
>
> When I added documentation for pktb_mangle, I assumed it mangled from
> pktb->data, rather than checking the source.
>
> That is the function I documented, and I think we need a function like that.
>
> Rather than change the behaviour of pktb_mangle when a MAC header is present, I
> propose a new function pktb_mangle2 which mangles from pktb->data onwards.
>
> pktb_mangle would call this new function, with dataoff incremented by
> pktb->network_header - pktb->data (only nonzero for AF_BRIDGE)
>
> Ok?
>
> Cheers ... Duncan.
>
On second thoughts, I'll just do the signed offset thing and have done with it.
Hope you can accept it quickly: I'll base it on master so you can apply it
before considering the pktb_usebuf() patch.
