Return-Path: <SRS0=rZfM=6X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1C97C28CBC
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 May 2020 08:26:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BF4624953
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 May 2020 08:26:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgEII0V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 May 2020 04:26:21 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:43724 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726214AbgEII0V (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 May 2020 04:26:21 -0400
Received: from dimstar.local.net (n175-34-64-112.sun1.vic.optusnet.com.au [175.34.64.112])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 2CE983A3CE3
        for <netfilter-devel@vger.kernel.org>; Sat,  9 May 2020 18:26:15 +1000 (AEST)
Received: (qmail 29300 invoked by uid 501); 9 May 2020 08:26:14 -0000
Date:   Sat, 9 May 2020 18:26:14 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Cc:     Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH libnetfilter_queue 0/3] pktbuff API updates
Message-ID: <20200509082614.GE26529@dimstar.local.net>
Mail-Followup-To: Netfilter Development <netfilter-devel@vger.kernel.org>,
        Phil Sutter <phil@nwl.cc>
References: <20200428103407.GA1160@salvia>
 <20200428211452.GF15436@dimstar.local.net>
 <20200428225520.GA30421@salvia>
 <20200429132840.GA3833@dimstar.local.net>
 <20200429191047.GB3833@dimstar.local.net>
 <20200429191643.GA16749@salvia>
 <20200429203029.GD3833@dimstar.local.net>
 <20200429210512.GA14508@salvia>
 <20200430063404.GF3833@dimstar.local.net>
 <20200505123034.GA16780@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505123034.GA16780@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=keeXcwCgVCrAuxOn72dlvA==:117 a=keeXcwCgVCrAuxOn72dlvA==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=RSmzAf-M6YYA:10 a=OLL_FvSJAAAA:8
        a=ZBu0UavJMiNc8dZV3RcA:9 a=CjuIK1q_8ugA:10 a=SAszQ4RR6nkA:10
        a=Z7RzNMET8NMA:10 a=oIrB72frpwYPwTMnlWqB:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Tue, May 05, 2020 at 02:30:34PM +0200, Pablo Neira Ayuso wrote:
> Hi Duncan,
>
> On Thu, Apr 30, 2020 at 04:34:04PM +1000, Duncan Roe wrote:
> [..]
> > Oh well in that case, how about:
> >
> > >	struct pkt_buff *pktb_alloc2(int family, void *buf, size_t buf_size, void *data, size_t len, size_t extra);
>
> Getting better. But why do you still need 'extra'?

As per other emails, no. I think it's fine not to zeroise that memory.
>
> > I.e. exactly as you suggested in
> > https://www.spinics.net/lists/netfilter-devel/msg65830.html except s/head/buf/
> >
> > And we tell users to dimension buf to NFQ_BUFFER_SIZE. We don't even need to
> > expose pktb_head_size().
>
> NFQ_BUFFER_SIZE tells what is the maximum netlink message size coming
> from the kernel. That netlink message contains metadata and the actual
> payload data.

As per other emails, I'll define and document NFQ_BUFFER_SIZE. If you have a
suggestion for a smaller value, I can put that in a v2.
>
> The pktbuff structure helps you deal with the payload data, not the
> netlink message itself.

Pablo, can we agree to proceed with

> struct pkt_buff *pktb_alloc2(int family, void *buf, size_t buf_size, void *data, size_t len);

then I can get on with the rest of the release.

Cheers ... Duncan.
