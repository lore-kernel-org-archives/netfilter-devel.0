Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48256CE79CF
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 13:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236379AbjITNDu convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 09:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236426AbjITNDl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 09:03:41 -0400
Received: from smtp.gentoo.org (mail.gentoo.org [IPv6:2001:470:ea4a:1:5054:ff:fec7:86e4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D008E9;
        Wed, 20 Sep 2023 06:03:34 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
From:   Sam James <sam@gentoo.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [ANNOUNCE] ipset 7.18 released
Date:   Wed, 20 Sep 2023 14:03:18 +0100
Message-Id: <21CF8732-712C-463C-9DA7-A40DA6A1A9B8@gentoo.org>
References: <20230920125056.GA25778@breakpoint.cc>
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
In-Reply-To: <20230920125056.GA25778@breakpoint.cc>
To:     Florian Westphal <fw@strlen.de>
X-Mailer: iPhone Mail (20G81)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



> On 20 Sep 2023, at 13:51, Florian Westphal <fw@strlen.de> wrote:
> 
> ﻿Jan Engelhardt <jengelh@inai.de> wrote:
> 
> You might want to CC author of that change.
> 
Yeah, happy to fix my error - although being polite wouldn't go amiss.

>>> On Wednesday 2023-09-20 13:20, Jan Engelhardt wrote:
>>> On Tuesday 2023-09-19 20:26, Jozsef Kadlecsik wrote:
>>>> 
>>>> I'm happy to announce ipset 7.18, which brings a few fixes, backports, 
>>>> tests suite fixes and json output support.
>>> 
>>> The installation of the pkgconfig file is now broken.
>>> 
>>>> - lib/Makefile.am: fix pkgconfig dir (Sam James)
>>> 
>>> Aaaaagh.. that change completely broke installation and must be reverted.
>> 
>> commit 326932be0c4f47756f9809cad5a103ac310f700d
>> Author: Sam James <sam@gentoo.org>
>> Date:   Sat Jan 28 19:23:54 2023 +0100
>> 
>>    lib/Makefile.am: fix pkgconfig dir
>> 
>>    Signed-off-by: Sam James <sam@gentoo.org>
>>    Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
>> 
>> Can I just take a moment to vent about this some more.
>> The change is, in the words of another Linux developer, utter garbage.
>> ${libdir} contains ${prefix} and did so for eternities.
>> 
>> The commit message is utter garbage too, because it does not
>> even try to make an argument to even _have_ the change in the
>> first place. Allowing such an underdocumented change is a
>> failure in the review process itself.
