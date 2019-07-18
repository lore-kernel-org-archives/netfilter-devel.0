Return-Path: <SRS0=fTMW=VP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59EB1C76191
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 13:41:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2983720873
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 13:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfGRNl4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Jul 2019 09:41:56 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:39776 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726665AbfGRNl4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Jul 2019 09:41:56 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1ho6fS-0002vX-W5; Thu, 18 Jul 2019 15:41:55 +0200
Date:   Thu, 18 Jul 2019 15:41:54 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v5 1/3] meta: Introduce new conditions 'time', 'day' and
 'hour'
Message-ID: <20190718134154.j3mkphxztmzva2hu@breakpoint.cc>
References: <20190707205531.6628-1-a@juaristi.eus>
 <20190714231958.wtyiusnqpazmwbgl@breakpoint.cc>
 <20190714233401.frxc63fky53yfqft@breakpoint.cc>
 <0d7fec35-cf5b-1bdc-81de-99dd74e79621@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d7fec35-cf5b-1bdc-81de-99dd74e79621@juaristi.eus>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ander Juaristi <a@juaristi.eus> wrote:
> On 15/7/19 1:34, Florian Westphal wrote:
> > > Even when relying on kernel time zone for everything, I don't see
> > > how we can support cross-day ("22:23-00:42") matching, as the range is
> > > invalid.
> > 
> > And that as well of course, swap and invert should work just fine.
> > 
> > > Second problem:
> > > Only solution I see is to change kernel patch to rely on
> > > sys_tz, just like xt_time, with all the pain this brings.
> > 
> > This stands, as the weekday is computed in the kernel, we will
> > need to bring sys_tz into this on the kernel side, the current
> > code uses UTC so we could be several hours off.
> > 
> > This can be restricted to the 'DAY' case of course.
> > 
> 
> I see... Thank you. You saved me hours of work figuring this out.

Giving hints is what I am supposed to do :-)

> So, for the TIME case we just swap left and right, and for the DAY case,
> just add (tz_minuteswest * 60) to the seconds before breaking it into
> day/mon/year?

Yes, swap and eq -> not eq -- at least I think that should work and
would make something like 18:00-07:00 work.

> And what does tz_dsttime do? gettimeofday(2) man says it is there for
> historical reasons and should be ignored on Linux. But I don't know what is
> it for in the kernel.

The kernel has no idea what a time zone is, the tz_dsttime setting
comes from userspace, typically during boot via hwclock(8).

IIRC it only flags if we're in 'daylight saving time' or not,
i.e. 0 for CET and 1 in CEST case.
