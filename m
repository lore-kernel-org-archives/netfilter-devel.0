Return-Path: <SRS0=DEFU=WP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82610C3A59B
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Aug 2019 04:10:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48AE12082C
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Aug 2019 04:10:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbfHSEKC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Aug 2019 00:10:02 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:48521 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725768AbfHSEKB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Aug 2019 00:10:01 -0400
Received: from dimstar.local.net (unknown [114.72.91.7])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 4A9703622BC
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2019 14:09:46 +1000 (AEST)
Received: (qmail 31017 invoked by uid 501); 19 Aug 2019 04:09:44 -0000
Date:   Mon, 19 Aug 2019 14:09:44 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Mail List - Netfilter <netfilter@vger.kernel.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: meter in 0.9.1 (nft noob question)
Message-ID: <20190819040944.GB10803@dimstar.local.net>
Mail-Followup-To: Mail List - Netfilter <netfilter@vger.kernel.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <877e7qzhgh.fsf@goll.lan>
 <CAF90-WiPQgD7wftDxz6sT+nfH=bSRZiUJPKqBeUJRXhfPOkYsg@mail.gmail.com>
 <20190806173745.GA6175@dimstar.local.net>
 <CAF90-WiOo9wYWxJwAFcyjdU7OB1vgU9e=-QvDZ-vNJ1tcgmraQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF90-WiOo9wYWxJwAFcyjdU7OB1vgU9e=-QvDZ-vNJ1tcgmraQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=j7Z9DUGHOYSlcI8coM27+w==:117 a=j7Z9DUGHOYSlcI8coM27+w==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=PO7r1zJSAAAA:8 a=kV3Eo6CZAAAA:8 a=ppa5IZbrAAAA:8 a=zA0SHWS1AAAA:8
        a=ME0f44oeAAAA:8 a=JkLo1NlJAAAA:8 a=y26AOypDAAAA:8 a=4_sBpEKgcLUtCcxzt2MA:9
        a=CjuIK1q_8ugA:10 a=wBTssStCULwQOSYxcY-3:22 a=BV2AYZ6q_-PLpubgWqnI:22
        a=FnZx8gFN_icetnSpqohp:22 a=kyl_1lB5NLWVO0M7OfoP:22
        a=wxBptE4FF8CuHLKU2tlr:22 a=gaZMYIrvE4ppDZ61GkVA:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 07, 2019 at 04:13:36PM +0200, Laura Garcia wrote:
> On Tue, Aug 6, 2019 at 8:21 PM Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> >
> > I thought meters were unique in that the set underlying them gets added to
> > by incoming traffic. Can maps/sets do that?
[...]
>
> Sure, something like:
>
> table ip my_filter_table {
>     set my_connlimit {
>         type ipv4_addr
>         size 65535
>         flags dynamic
>         elements = { 192.168.56.1 counter packets 2 bytes 656 }
>     }
>
>     chain my_output_chain {
>         type filter hook output priority filter; policy accept;
>         ct state new add @my_connlimit { ip daddr counter } accept
>     }
> }
That works really well, thanks! Also I like that nowadays you get 2 addresses
per line instead of one long line with all addresses. I added a timeout to limit
the display length, here's a sample:

> 01:25:53# nft list ruleset
> table ip my_filter_table {
>         set my_connlimit {
>                 type ipv4_addr
>                 size 65535
>                 flags dynamic,timeout
>                 timeout 10m
>                 elements = { 10.255.255.3 expires 6m16s920ms counter packets 1848 bytes 173538, 13.55.50.68 expires 7m7s746ms counter packets 1 bytes 76,
>                              23.202.173.53 expires 3m8s953ms counter packets 5 bytes 300, 54.66.128.84 expires 8m10s639ms counter packets 1 bytes 60,
>                              54.230.243.55 expires 8m10s627ms counter packets 1 bytes 60, 103.126.53.123 expires 2m59s746ms counter packets 1 bytes 76,
>                              127.0.0.1 expires 1m36s898ms counter packets 4311 bytes 125298, 151.101.82.110 expires 8m10s632ms counter packets 1 bytes 60,
>                              162.247.242.20 expires 8m11s529ms counter packets 1 bytes 60, 172.217.25.36 expires 3m10s434ms counter packets 2 bytes 120,
>                              172.217.167.98 expires 8m10s89ms counter packets 3 bytes 180, 184.24.244.106 expires 8m10s425ms counter packets 2 bytes 120,
>                              216.58.196.138 expires 3m10s333ms counter packets 2 bytes 120, 216.58.199.33 expires 3m9s595ms counter packets 2 bytes 120,
>                              216.58.199.34 expires 3m9s590ms counter packets 2 bytes 120, 216.58.199.78 expires 8m10s1ms counter packets 1 bytes 60 }
>         }
>
>         chain my_output_chain {
>                 type filter hook output priority filter; policy accept;
>                 ct state new add @my_connlimit { ip daddr counter } accept
>         }
> }

After some post-processing and running under "watch":

> Every 2.0s: nft list ruleset|q -niu,/home/dunc/macros/nft1.qm^J^N^Z            dimstar: Mon Aug 19 13:43:51 2019
>
> table ip my_filter_table {
>  set my_connlimit {
>   type ipv4_addr
>   size 65535
>   flags dynamic,timeout
>   timeout 10m
>   elements = {
>    ec2-13-55-50-68.ap-southeast-2.compute.amazonaws.com expires 8m44s328ms counter packets 1 bytes 76,
>    syd15s01-in-f68.1e100.net expires 7m39s862ms counter packets 1 bytes 60,
>    syd09s17-in-f10.1e100.net expires 7m39s721ms counter packets 1 bytes 60,
>    syd15s04-in-f1.1e100.net expires 7m39s120ms counter packets 1 bytes 60,
>    syd09s13-in-f2.1e100.net expires 7m39s115ms counter packets 1 bytes 60,
>    syd09s14-in-f2.1e100.net expires 7m38s594ms counter packets 3 bytes 180
>    syd15s01-in-f14.1e100.net expires 7m38s512ms counter packets 1 bytes 60,
>    a23-202-173-53.deploy.static.akamaitechnologies.com expires 7m38s503ms counter packets 2 bytes 120,
>    localhost expires 6m3s123ms counter packets 1733 bytes 50381,
>    pauseq4vntp2.datamossa.io expires 4m52s328ms counter packets 1 bytes 76,
>    bam-8.nr-data.net expires 2m39s43ms counter packets 2 bytes 120,
>    syd15s02-in-f4.1e100.net expires 2m38s911ms counter packets 1 bytes 60,
>    ec2-54-66-128-84.ap-southeast-2.compute.amazonaws.com expires 2m38s158ms counter packets 2 bytes 120,
>    server-54-230-243-55.mel50.r.cloudfront.net expires 2m38s138ms counter packets 2 bytes 120,
>    151.101.82.110 expires 2m38s138ms counter packets 2 bytes 120,
>    a184-24-244-106.deploy.static.akamaitechnologies.com expires 2m37s944ms counter packets 4 bytes 240,
>    syd15s03-in-f2.1e100.net expires 2m37s619ms counter packets 3 bytes 180,
>    dullstar.local.net expires 44s23ms counter packets 4344 bytes 409775,
>   }
>  }
>
>  chain my_output_chain {
>   type filter hook output priority filter; policy accept;
>   ct state new add @my_connlimit { ip daddr counter } accept
>  }
> }

The elements are sorted by decreasing expiry times, as well as the obvious
changes (1 elemnt per line, nothing else on an element line, display narrowed to
canonical minimal indent, IP addresses resolved where possible).

*** I had expected or at least hoped that an element's expiry would revert to
*** the timeout interval if it was re-added, but this doesn't happen.

Was that possibility discussed on the list previously? Not having it leads to at
least 2 undesirable consequences when watching:

1. Frequently-accessed sites drop off the bottom and re-appear at the top.
   The lower part of the display would be more stable if expiry times reverted:
   frequently-accessed sites would stay near the top while others would
   percolate through.

2. Counters reset when these elements are destroyed and re-created.

Was there a discussion on the list about this (possibility of reverting expiry
times) previously? Would there be much to it? I'm not especially familiar with
the kernel code but, supposing I figured it out, would a patch be acceptable?

IAC I'd be delighted to share the postprocessing software with anyone who's
interested,

Cheers ... Duncan.
