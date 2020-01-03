Return-Path: <SRS0=aqP0=2Y=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12045C3276F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jan 2020 02:48:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2B93217F4
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jan 2020 02:48:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbgACCsK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Jan 2020 21:48:10 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:34861 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726148AbgACCsK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Jan 2020 21:48:10 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 61D6A3A1670
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Jan 2020 13:47:57 +1100 (AEDT)
Received: (qmail 5866 invoked by uid 501); 3 Jan 2020 02:47:56 -0000
Date:   Fri, 3 Jan 2020 13:47:56 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue 0/1] New pktb_usebuf() function
Message-ID: <20200103024756.GA27138@dimstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20191210112634.11511-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210112634.11511-1-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=Jdjhy38mL1oA:10
        a=RSmzAf-M6YYA:10 a=wu99km_YaOeKYbNboVEA:9 a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Do you think pktb_make() might be a better name for this new function?

I noticed an errant free() call after "errno = EPROTONOSUPPORT" so there will
have to be a v2 anyway.

I could merge the (now almost-) identical second halves of pktb_alloc and
pktb_make into a static function to avoid the duplicate code maintenance
overhead. Would you prefer that?

Cheers ... Duncan.

On Tue, Dec 10, 2019 at 10:26:33PM +1100, Duncan Roe wrote:
> pktb_usebuf() is a copy of pktb_alloc() with the first part modified to use
> a supplied buffer rather than calloc() one. I thought this would give a
> measurable performance boost and it does.
> All the code after the memset() call is common to pktb_alloc(). If you like,
> I can submit a v2 with this code in a static function called by both.
>
> Duncan Roe (1):
>   src: Add alternative function to pktb_alloc to avoid malloc / free
>     overhead
>
>  include/libnetfilter_queue/pktbuff.h |  2 +
>  src/extra/pktbuff.c                  | 82 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 84 insertions(+)
>
> --
> 2.14.5
>
