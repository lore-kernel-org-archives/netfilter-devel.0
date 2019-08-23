Return-Path: <SRS0=Ar4o=WT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F404C3A5A1
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Aug 2019 02:35:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0921A23402
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Aug 2019 02:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391178AbfHWCfq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Aug 2019 22:35:46 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:36260 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389004AbfHWCfq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Aug 2019 22:35:46 -0400
Received: from dimstar.local.net (unknown [49.176.30.160])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id B08F243DCE0
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Aug 2019 12:35:32 +1000 (AEST)
Received: (qmail 16456 invoked by uid 501); 23 Aug 2019 02:35:30 -0000
Date:   Fri, 23 Aug 2019 12:35:30 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Netfilter <netfilter@vger.kernel.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Cc:     Mail List - Netfilter <netfilter@vger.kernel.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: meter in 0.9.1 (nft noob question)
Message-ID: <20190823023530.GB22615@dimstar.local.net>
Mail-Followup-To: Netfilter <netfilter@vger.kernel.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <877e7qzhgh.fsf@goll.lan>
 <CAF90-WiPQgD7wftDxz6sT+nfH=bSRZiUJPKqBeUJRXhfPOkYsg@mail.gmail.com>
 <20190806173745.GA6175@dimstar.local.net>
 <CAF90-WiOo9wYWxJwAFcyjdU7OB1vgU9e=-QvDZ-vNJ1tcgmraQ@mail.gmail.com>
 <20190819040944.GB10803@dimstar.local.net>
 <CAF90-Wgt9zBSi_as1vOsisegVFYSBHWSQwv5n_cMyEcFx3wcYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF90-Wgt9zBSi_as1vOsisegVFYSBHWSQwv5n_cMyEcFx3wcYw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=Z9xClQWs/QXK5X6ealIiYw==:117 a=Z9xClQWs/QXK5X6ealIiYw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=PO7r1zJSAAAA:8 a=zA0SHWS1AAAA:8 a=ME0f44oeAAAA:8 a=ppa5IZbrAAAA:8
        a=kV3Eo6CZAAAA:8 a=sqxYOmX52BIUqrrYTT0A:9 a=CjuIK1q_8ugA:10
        a=FnZx8gFN_icetnSpqohp:22 a=kyl_1lB5NLWVO0M7OfoP:22
        a=BV2AYZ6q_-PLpubgWqnI:22 a=wBTssStCULwQOSYxcY-3:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 22, 2019 at 01:14:40PM +0200, Laura Garcia wrote:
> Hi Duncan,
>
> On Mon, Aug 19, 2019 at 6:11 AM Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> >
>
> [...]
>
> >
> > *** I had expected or at least hoped that an element's expiry would revert
> > *** to the timeout interval if it was re-added, but this doesn't happen.
> >
>
> You'd have to use "element update" instead of "element add", but it's
> not supported yet for this case.
>
> > Was that possibility discussed on the list previously? Not having it leads
> > to at least 2 undesirable consequences when watching:
> >
> > 1. Frequently-accessed sites drop off the bottom and re-appear at the top.
> >    The lower part of the display would be more stable if expiry times
> >    reverted: frequently-accessed sites would stay near the top while others
> >    would percolate through.
> >
> > 2. Counters reset when these elements are destroyed and re-created.
> >
>
> As a workaround you can set the expiration time manually until the
> "element update" solution is in place.
>
> Cheers.

Hi Laura,

Many thanks for the suggestion!

I am finding that update *does* appear to work (nftables v0.9.2 (Scram),
kernel 5.2.0), assuming this is what you meant:

> #!/usr/sbin/nft -f
> flush ruleset
> table ip my_filter_table {
>     set my_connlimit {
>         type ipv4_addr
>         size 65535
>         flags dynamic
>         timeout 10m
>     }
>
>     chain my_output_chain {
>         type filter hook output priority filter; policy accept;
>         ct state new update @my_connlimit { ip daddr counter } accept
> #                    ^^^^^^
>     }
> }

Sample o/p:

> a23-202-173-53.deploy.static.akamaitechnologies.com expires 9m57s655ms counter packets 214 bytes 12840,
> a184-24-244-106.deploy.static.akamaitechnologies.com expires 7m46s412ms counter packets 15 bytes 900,
> bam-9.nr-data.net expires 7m45s462ms counter packets 6 bytes 360,
> syd09s12-in-f36.1e100.net expires 7m45s283ms counter packets 2 bytes 120,
> syd09s15-in-f10.1e100.net expires 7m45s170ms counter packets 3 bytes 180
> ec2-54-66-128-84.ap-southeast-2.compute.amazonaws.com expires 7m44s611ms counter packets 9 bytes 612,

Cheers ... Duncan.
