Return-Path: <SRS0=2e0L=2R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C8F7C2D0C0
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Dec 2019 00:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40FD120828
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Dec 2019 00:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbfL0Ajz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Dec 2019 19:39:55 -0500
Received: from mail.thelounge.net ([91.118.73.15]:48853 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbfL0Ajz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Dec 2019 19:39:55 -0500
X-Greylist: delayed 958 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Dec 2019 19:39:54 EST
Received: from srv-rhsoft.rhsoft.net  (Authenticated sender: h.reindl@thelounge.net) by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 47kSHD6LmBzXSZ;
        Fri, 27 Dec 2019 01:23:47 +0100 (CET)
Subject: Re: Weird/High CPU usage caused by LOG target
To:     Tom Yan <tom.ty89@gmail.com>, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org
References: <CAGnHSEkvf0zieVJtPyneZ6PfnzeANmfFxTb=0JpgVb1FXVk0-w@mail.gmail.com>
 <20191226222923.GA32765@dimstar.local.net>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Message-ID: <24814d60-92c1-6c7e-8eb5-e977e1c7c1d0@thelounge.net>
Date:   Fri, 27 Dec 2019 01:23:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191226222923.GA32765@dimstar.local.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



Am 26.12.19 um 23:29 schrieb Duncan Roe:
> On Thu, Dec 26, 2019 at 11:05:33AM +0800, Tom Yan wrote:
>> Hi all,
>>
>> So I was trying to log all traffics in the FORWARD chain with the LOG
>> target in iptables (while I say all, it's just some VPN server/client
>> that is used by only me, and the tests were just opening some
>> website).
>>
>> I notice that the logging causes high CPU usage (so it goes up only
>> when there are traffics). In (h)top, the usage shows up as openvpn's
>> if the forwarding involves their tuns. Say I am forwarding from one
>> tun to another, each of the openvpn instance will max out one core on
>> my raspberry pi 3 b+. (And that actually slows the whole system down,
>> like ssh/bash responsiveness, and stalls the traffic flow.) If I do
>> not log, or log with the NFLOG target instead, their CPU usage will be
>> less than 1%.
>>
>> Interestingly, the problem seems to be way less obvious if I am using
>> it on higher end devices (like my Haswell PC, or even a raspberry pi
>> 4). There are still "spikes" as well, but it won't make me "notice"
>> the problem, at least not when I am just doing some trivial web
>> browsing.
>>
>> Let me know how I can further help debugging, if any of you are
>> interested in fixing this.
>>
> Just in case you missed it, be sure that your logger is configured not to sync
> the file system after every logging. That is the default action btw.
> 
> I have used large-volume logging in the past and never encountered a CPU problem
> (but had to run logrotate every minute to avoid filling the disk)

the problem is "-j LOG" at it's own and not suprisingly after having
enough of random crashes and kexec only spits the disk full of
demsg-output from iptables "-j LOG" switching awy to NFLOG and ulogd and
never ever faced antother crash

"-j LOG" spits into kernel ring buffer and by it's own produces double
load no matter what happns after the action
