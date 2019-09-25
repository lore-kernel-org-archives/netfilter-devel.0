Return-Path: <SRS0=+tY6=XU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAF37C432C1
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 02:28:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 826FD20874
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 02:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411380AbfIYC21 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Sep 2019 22:28:27 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:41151 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2411378AbfIYC21 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Sep 2019 22:28:27 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 373E943F078
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2019 12:28:13 +1000 (AEST)
Received: (qmail 16811 invoked by uid 501); 25 Sep 2019 02:28:12 -0000
Date:   Wed, 25 Sep 2019 12:28:12 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] src: Enable clang build
Message-ID: <20190925022812.GA16766@dimstar.local.net>
Mail-Followup-To: Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20190922001031.30848-1-duncan_roe@optusnet.com.au>
 <20190924121129.GA32094@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190924121129.GA32094@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=JT8UIpuPHKVkOgFCtG0A:9 a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Sep 24, 2019 at 01:11:29PM +0100, Jeremy Sowden wrote:
> On 2019-09-22, at 10:10:31 +1000, Duncan Roe wrote:
> > Unlike gcc, clang insists to have EXPORT_SYMBOL(x) come before the definition
> > of x. So move all EXPORT_SYMBOL lines to just after the last #include line.
> >
> > pktbuff.c was missing its associated header, so correct that as well.
> >
> > gcc & clang produce different warnings. gcc warns that nfq_set_verdict_mark is
> > deprecated while clang warns of invalid conversion specifier 'Z' at
> > src/extra/ipv6.c:138 (should that be lower-case?)
>
> It should, yes.
>
> J.

Will send a v2 then.

Cheers ... Duncan.
