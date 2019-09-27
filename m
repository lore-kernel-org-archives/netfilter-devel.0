Return-Path: <SRS0=c7vx=XW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1071C4360C
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Sep 2019 00:42:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA94A2086A
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Sep 2019 00:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfI0Amj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Sep 2019 20:42:39 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:41115 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725808AbfI0Amj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Sep 2019 20:42:39 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 0BBCB43E165
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Sep 2019 10:42:36 +1000 (AEST)
Received: (qmail 32297 invoked by uid 501); 27 Sep 2019 00:42:36 -0000
Date:   Fri, 27 Sep 2019 10:42:36 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnetfilter_queue] src: Enable clang build
Message-ID: <20190927004236.GB31954@dimstar.local.net>
Mail-Followup-To: Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Development <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20190922001031.30848-1-duncan_roe@optusnet.com.au>
 <20190924121129.GA32094@azazel.net>
 <20190925022812.GA16766@dimstar.local.net>
 <20190927000032.GA31954@dimstar.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190927000032.GA31954@dimstar.local.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=amA5tBAHi04z8VDdgLoA:9 a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Sep 27, 2019 at 10:00:32AM +1000, Duncan Roe wrote:
> On Wed, Sep 25, 2019 at 12:28:12PM +1000, Duncan Roe wrote:
> > On Tue, Sep 24, 2019 at 01:11:29PM +0100, Jeremy Sowden wrote:
> > > On 2019-09-22, at 10:10:31 +1000, Duncan Roe wrote:
> > > > Unlike gcc, clang insists to have EXPORT_SYMBOL(x) come before the definition
> > > > of x. So move all EXPORT_SYMBOL lines to just after the last #include line.
> > > >
> > > > pktbuff.c was missing its associated header, so correct that as well.
> > > >
> > > > gcc & clang produce different warnings. gcc warns that nfq_set_verdict_mark is
> > > > deprecated while clang warns of invalid conversion specifier 'Z' at
> > > > src/extra/ipv6.c:138 (should that be lower-case?)
> > >
> > > It should, yes.
> > >
> > > J.
> >
> > Will send a v2 then.
> >
> > Cheers ... Duncan.
>
> On second thoughts, will send a separate 1-liner patch for 5z as time permits.
>
> Cheers ... Duncan.

s/5/%/
