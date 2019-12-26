Return-Path: <SRS0=nsnV=2Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDCD0C2D0C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Dec 2019 22:29:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C6D7206CB
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Dec 2019 22:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfLZW3k (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Dec 2019 17:29:40 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:56727 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727028AbfLZW3j (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Dec 2019 17:29:39 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id A2E907EACD5
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Dec 2019 09:29:24 +1100 (AEDT)
Received: (qmail 5185 invoked by uid 501); 26 Dec 2019 22:29:23 -0000
Date:   Fri, 27 Dec 2019 09:29:23 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Tom Yan <tom.ty89@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Subject: Re: Weird/High CPU usage caused by LOG target
Message-ID: <20191226222923.GA32765@dimstar.local.net>
Mail-Followup-To: Tom Yan <tom.ty89@gmail.com>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
References: <CAGnHSEkvf0zieVJtPyneZ6PfnzeANmfFxTb=0JpgVb1FXVk0-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGnHSEkvf0zieVJtPyneZ6PfnzeANmfFxTb=0JpgVb1FXVk0-w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=pxVhFHJ0LMsA:10
        a=RSmzAf-M6YYA:10 a=YN2swqTt7GDZSc3HkucA:9 a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 26, 2019 at 11:05:33AM +0800, Tom Yan wrote:
> Hi all,
>
> So I was trying to log all traffics in the FORWARD chain with the LOG
> target in iptables (while I say all, it's just some VPN server/client
> that is used by only me, and the tests were just opening some
> website).
>
> I notice that the logging causes high CPU usage (so it goes up only
> when there are traffics). In (h)top, the usage shows up as openvpn's
> if the forwarding involves their tuns. Say I am forwarding from one
> tun to another, each of the openvpn instance will max out one core on
> my raspberry pi 3 b+. (And that actually slows the whole system down,
> like ssh/bash responsiveness, and stalls the traffic flow.) If I do
> not log, or log with the NFLOG target instead, their CPU usage will be
> less than 1%.
>
> Interestingly, the problem seems to be way less obvious if I am using
> it on higher end devices (like my Haswell PC, or even a raspberry pi
> 4). There are still "spikes" as well, but it won't make me "notice"
> the problem, at least not when I am just doing some trivial web
> browsing.
>
> Let me know how I can further help debugging, if any of you are
> interested in fixing this.
>
> Regards,
> Tom
>
Hi Tom,

Just in case you missed it, be sure that your logger is configured not to sync
the file system after every logging. That is the default action btw.

I have used large-volume logging in the past and never encountered a CPU problem
(but had to run logrotate every minute to avoid filling the disk).

Cheers ... Duncan.
