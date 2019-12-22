Return-Path: <SRS0=SsnH=2M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D005C2D0D3
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Dec 2019 02:09:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3345D206D8
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Dec 2019 02:09:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbfLVCJ0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Dec 2019 21:09:26 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:37802 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726086AbfLVCJ0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Dec 2019 21:09:26 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id E1C1D3A1B8A
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Dec 2019 13:09:12 +1100 (AEDT)
Received: (qmail 12619 invoked by uid 501); 22 Dec 2019 02:09:10 -0000
Date:   Sun, 22 Dec 2019 13:09:10 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue 0/1] New pktb_usebuf() function
Message-ID: <20191222020910.GA1804@dimstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20191210112634.11511-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210112634.11511-1-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=pxVhFHJ0LMsA:10
        a=RSmzAf-M6YYA:10 a=xLCLjxN10RmHeJYhxVQA:9 a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

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
After a day or so of testing, it appears pktb_usebuf() saves 6% overall CPU over
pktb_alloc() in a program similar to libnetfilter_queue/examples/nf-queue.c (but
not printing every packet). The variance is quite high, so plus or minus 1%. Can
supply more details of testing methodology if you want them.

Overall I would say 6% is a worthwhile saving.

What about it?

Cheers ... Duncan.
