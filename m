Return-Path: <SRS0=l6lg=33=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D624C2BA83
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Feb 2020 22:39:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F150421775
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Feb 2020 22:39:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgBGWjs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Feb 2020 17:39:48 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:60586 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727031AbgBGWjs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Feb 2020 17:39:48 -0500
Received: from dimstar.local.net (n175-34-107-236.sun1.vic.optusnet.com.au [175.34.107.236])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 5B0E53A5DC8
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Feb 2020 09:39:29 +1100 (AEDT)
Received: (qmail 27685 invoked by uid 501); 7 Feb 2020 22:39:28 -0000
Date:   Sat, 8 Feb 2020 09:39:28 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v2] src: Add faster alternatives to
 pktb_alloc()
Message-ID: <20200207223928.GB27448@dimstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20200108225323.io724vuxuzsydjzs@salvia>
 <20200201062127.4729-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200201062127.4729-1-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=HhxO2xtGR2hgo/TglJkeQA==:117 a=HhxO2xtGR2hgo/TglJkeQA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=RSmzAf-M6YYA:10 a=PO7r1zJSAAAA:8 a=hfIAFtAwt3Ksdk8kjyQA:9
        a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Sat, Feb 01, 2020 at 05:21:27PM +1100, Duncan Roe wrote:
> Functions pktb_alloc_data, pktb_make and pktb_make_data are defined.
> The pktb_make pair are syggested as replacements for the pktb_alloc (now) pair
> because they are always faster.
>
> - Add prototypes to include/libnetfilter_queue/pktbuff.h
> - Add pktb_alloc_data much as per Pablo's email of Wed, 8 Jan 2020
>   speedup: point to packet data in netlink receive buffer rather than copy to
>            area immediately following pktb struct
> - Add pktb_make much like pktb_usebuf proposed on 10 Dec 2019
>   2 sppedups: 1. Use an existing buffer rather than calloc and (later) free one.
>               2. Only zero struct and extra parts of pktb - the rest is
>                  overwritten by copy (calloc has to zero the lot).
> - Add pktb_make_data
>   3 speedups: All of the above
> - Document the new functions
> - Move pktb_alloc and pktb_alloc_data into the "other functions" group since
>   they are slower than the "make" equivalent functions
>
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
[...]

Did you notice this? I guess it should have been v3 really.

I'd really appreciate some feedback soon, if you or whoever could find the time.

Cheers ... Duncan.
