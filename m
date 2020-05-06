Return-Path: <SRS0=4pKc=6U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3963C47247
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 00:57:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCD0E206A5
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 00:57:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729678AbgEFA5U (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 May 2020 20:57:20 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:34516 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729247AbgEFA5U (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 May 2020 20:57:20 -0400
Received: from dimstar.local.net (n175-34-64-112.sun1.vic.optusnet.com.au [175.34.64.112])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 821DC3A39F1
        for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2020 10:57:16 +1000 (AEST)
Received: (qmail 27081 invoked by uid 501); 6 May 2020 00:57:15 -0000
Date:   Wed, 6 May 2020 10:57:15 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue 0/3] pktbuff API updates
Message-ID: <20200506005715.GA26529@dimstar.local.net>
Mail-Followup-To: Netfilter Development <netfilter-devel@vger.kernel.org>
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
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
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
>
> The pktbuff structure helps you deal with the payload data, not the
> netlink message itself.

2 reasons, the first being more important:

1. We zeroise memory from 'data + len' for 'extra' bytes. This mirrors original
behaviour where calloc() was used to zeroise everything. Zeroising is only done
if a data copy is needed to mangle packet length to be larger than it was
originally. Do we need to zeroise at all? You tell me. We do need to zeroise the
'struct pkt_buff' - was that why calloc() was originally used?

2. We use extra to verify that 'buf_size' is big enough. It must be at least
'sizeof(struct pkt_buff) + (extra ? len + extra : 0)'.

If zeroising is unnecessary then yes, we don't need 'extra'. pktb_mangle() can
return 0 if 'buf_size' is inadequate. (pktb_alloc2() checks 'buf_size >=
sizeof(struct pkt_buff)' and copies 'buf_size' into the enlarged 'pktb' so it's
available to pktb_mangle()).

Cheeers ... Duncan.
