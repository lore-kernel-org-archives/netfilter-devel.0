Return-Path: <SRS0=IXkg=6W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74AC4C35280
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 May 2020 01:13:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54D50207DD
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 May 2020 01:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgEHBNV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 May 2020 21:13:21 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:38342 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726509AbgEHBNU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 May 2020 21:13:20 -0400
Received: from dimstar.local.net (n175-34-64-112.sun1.vic.optusnet.com.au [175.34.64.112])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 1309D8207FC
        for <netfilter-devel@vger.kernel.org>; Fri,  8 May 2020 11:13:18 +1000 (AEST)
Received: (qmail 22547 invoked by uid 501); 8 May 2020 01:13:17 -0000
Date:   Fri, 8 May 2020 11:13:17 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue 0/3] pktbuff API updates
Message-ID: <20200508011317.GD26529@dimstar.local.net>
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
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=keeXcwCgVCrAuxOn72dlvA==:117 a=keeXcwCgVCrAuxOn72dlvA==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=RSmzAf-M6YYA:10 a=OLL_FvSJAAAA:8
        a=LgnNMTFPk_ALOH8hI4wA:9 a=CjuIK1q_8ugA:10 a=5IQaqkL3LGYA:10
        a=eNCFSZOqFEwA:10 a=oIrB72frpwYPwTMnlWqB:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Tue, May 05, 2020 at 02:30:34PM +0200, Pablo Neira Ayuso wrote: [...]
> > And we tell users to dimension buf to NFQ_BUFFER_SIZE. We don't even need to
> > expose pktb_head_size().

On second thoughts, maybe document in a Note the actual formula for how big the
buffer needs to be. And keep pktb_head_size().
>
> NFQ_BUFFER_SIZE tells what is the maximum netlink message size coming
> from the kernel. That netlink message contains metadata and the actual
> payload data.

I meant NFQ_BUFFER_SIZE (or some better name) to be a new macro expanding to
'0xffff + (MNL_SOCKET_BUFFER_SIZE/2)' as you suggested in
https://www.spinics.net/lists/netfilter-devel/msg66938.html. Is that only just
large enough for largest possible packet? Or is there room for struct pkt_buff
as well?

Cheers ... Duncan.
