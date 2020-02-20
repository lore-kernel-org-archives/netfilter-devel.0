Return-Path: <SRS0=kbfM=4I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A64A6C11D00
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Feb 2020 23:51:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7428D207FD
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Feb 2020 23:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729298AbgBTXvE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Feb 2020 18:51:04 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:43075 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729234AbgBTXvE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Feb 2020 18:51:04 -0500
Received: from dimstar.local.net (n122-110-29-255.sun2.vic.optusnet.com.au [122.110.29.255])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 0C5188203F4
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Feb 2020 10:50:51 +1100 (AEDT)
Received: (qmail 20359 invoked by uid 501); 20 Feb 2020 23:50:50 -0000
Date:   Fri, 21 Feb 2020 10:50:50 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v2] src: Add faster alternatives to
 pktb_alloc()
Message-ID: <20200220235050.GB19954@dimstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20200108225323.io724vuxuzsydjzs@salvia>
 <20200201062127.4729-1-duncan_roe@optusnet.com.au>
 <20200219180410.e56psjovne3y43rc@salvia>
 <20200220232229.GA19954@dimstar.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220232229.GA19954@dimstar.local.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=xEIwVUYJq7t7CX9UEWuoUA==:117 a=xEIwVUYJq7t7CX9UEWuoUA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=RSmzAf-M6YYA:10 a=OLL_FvSJAAAA:8 a=DuLIHlSciJKB-aB4cgQA:9
        a=CjuIK1q_8ugA:10 a=2RsHJzH7CMAA:10 a=HAg69MfTcCgA:10 a=Zs9bb-uN6TQA:10
        a=wvMYNXCZtGYA:10 a=H9SuFdNxUskA:10 a=80-O730x2jAA:10 a=wbbTpC8Z_7cA:10
        a=oIrB72frpwYPwTMnlWqB:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Feb 21, 2020 at 10:22:29AM +1100, Duncan Roe wrote:
> Hi Pablo,
>
> On Wed, Feb 19, 2020 at 07:04:10PM +0100, Pablo Neira Ayuso wrote:
[...]
> I had to put libnetfilter_queue development on hold because
> juggling 3 branches was just getting to be too much.
>
> (others are https://www.spinics.net/lists/netfilter-devel/msg65661.html (man
> pages) and https://www.spinics.net/lists/netfilter-devel/msg65585.html (add
> more helper functions to simplify coding)).
>
Please see https://www.spinics.net/lists/netfilter-devel/msg65584.html for a
roadmap of the new helper functions. Another plus for the new functions would
be that they would all have man pages (as long as you take that patch ;)

Cheers ... Duncan.
