Return-Path: <SRS0=fTMW=VP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B758C76191
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 12:56:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C74A2173E
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 12:56:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390256AbfGRM4n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Jul 2019 08:56:43 -0400
Received: from vxsic-smtp02hc14.srv.cat ([46.16.61.94]:48713 "EHLO
        vxsys-smtpclusterma-04.srv.cat" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726715AbfGRM4m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Jul 2019 08:56:42 -0400
Received: from [192.168.4.111] (242.red-83-48-67.staticip.rima-tde.net [83.48.67.242])
        by vxsys-smtpclusterma-04.srv.cat (Postfix) with ESMTPA id 8A0E52451E;
        Thu, 18 Jul 2019 14:56:40 +0200 (CEST)
Subject: Re: [PATCH v5 1/3] meta: Introduce new conditions 'time', 'day' and
 'hour'
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
References: <20190707205531.6628-1-a@juaristi.eus>
 <20190714231958.wtyiusnqpazmwbgl@breakpoint.cc>
 <20190714233401.frxc63fky53yfqft@breakpoint.cc>
From:   Ander Juaristi <a@juaristi.eus>
Message-ID: <0d7fec35-cf5b-1bdc-81de-99dd74e79621@juaristi.eus>
Date:   Thu, 18 Jul 2019 14:56:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20190714233401.frxc63fky53yfqft@breakpoint.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 15/7/19 1:34, Florian Westphal wrote:
>> Even when relying on kernel time zone for everything, I don't see
>> how we can support cross-day ("22:23-00:42") matching, as the range is
>> invalid.
> 
> And that as well of course, swap and invert should work just fine.
> 
>> Second problem:
>> Only solution I see is to change kernel patch to rely on
>> sys_tz, just like xt_time, with all the pain this brings.
> 
> This stands, as the weekday is computed in the kernel, we will
> need to bring sys_tz into this on the kernel side, the current
> code uses UTC so we could be several hours off.
> 
> This can be restricted to the 'DAY' case of course.
> 

I see... Thank you. You saved me hours of work figuring this out.

So, for the TIME case we just swap left and right, and for the DAY case,
just add (tz_minuteswest * 60) to the seconds before breaking it into 
day/mon/year?

And what does tz_dsttime do? gettimeofday(2) man says it is there for 
historical reasons and should be ignored on Linux. But I don't know what 
is it for in the kernel.

