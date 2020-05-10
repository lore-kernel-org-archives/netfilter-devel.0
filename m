Return-Path: <SRS0=uppk=6Y=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AC30C54E8D
	for <netfilter-devel@archiver.kernel.org>; Sun, 10 May 2020 21:30:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF1D52080C
	for <netfilter-devel@archiver.kernel.org>; Sun, 10 May 2020 21:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729327AbgEJVaL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 10 May 2020 17:30:11 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46352 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726955AbgEJVaL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 May 2020 17:30:11 -0400
Received: from dimstar.local.net (n175-34-64-112.sun1.vic.optusnet.com.au [175.34.64.112])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 86CB9820E5A
        for <netfilter-devel@vger.kernel.org>; Mon, 11 May 2020 07:30:07 +1000 (AEST)
Received: (qmail 16974 invoked by uid 501); 10 May 2020 21:30:07 -0000
Date:   Mon, 11 May 2020 07:30:07 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Duncan Roe <duncan_roe@optusnet.com.au>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue 1/1] src: add pktb_alloc2() and
 pktb_head_size()
Message-ID: <20200510213007.GG26529@dimstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Duncan Roe <duncan_roe@optusnet.com.au>,
        netfilter-devel@vger.kernel.org
References: <20200510135317.15526-1-duncan_roe@optusnet.com.au>
 <20200510135317.15526-2-duncan_roe@optusnet.com.au>
 <20200510151001.GA6216@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200510151001.GA6216@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=keeXcwCgVCrAuxOn72dlvA==:117 a=keeXcwCgVCrAuxOn72dlvA==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=RSmzAf-M6YYA:10
        a=uMZarwScDqQxgVzDeIEA:9 a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, May 10, 2020 at 05:10:01PM +0200, Pablo Neira Ayuso wrote:
> On Sun, May 10, 2020 at 11:53:17PM +1000, Duncan Roe wrote:
> > pktb_alloc2() avoids the malloc/free overhead in pktb_alloc() and also
> > eliminates memcpy() of the payload except when mangling increases the
> > packet length.
> >
> >  - pktb_mangle() does the memcpy() if need be.
> >    Packet metadata is altered in this case
> >  - All the _mangle functions are altered to account for possible change tp
> >    packet metadata
> >  - Documentation is updated
>
> Many chunks of this patchset look very much the same I posted. I'll
> apply my patchset and please rebase any update on top of it.

Your patchset is crap.
No documentation, giant holes that I haven't had time to reply to...
Apply this junk and I am walking away from netfilter.
>
> Thanks.
-Duncan
