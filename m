Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25BBCEB64DD
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jul 2023 14:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbjGFOfo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jul 2023 10:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231980AbjGFOfn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jul 2023 10:35:43 -0400
Received: from smtp-8fad.mail.infomaniak.ch (smtp-8fad.mail.infomaniak.ch [IPv6:2001:1600:3:17::8fad])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312FA1BD3
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jul 2023 07:35:40 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4QxfG20vc5zMrZyy;
        Thu,  6 Jul 2023 14:35:38 +0000 (UTC)
Received: from unknown by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4QxfG11plzzMpnPl;
        Thu,  6 Jul 2023 16:35:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1688654138;
        bh=H/3OCyM7CyvLYp3xIfScjdZFinrEwp8adqhHz1jvwJI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=adLV0onG/BYPlrDfIxzVXWQO0eaOFdBzHISAQCTwxuewY/HKFWxXiuVxL6+qAV3LY
         k5Oy9jLmmjAD/XfmSqKfbIm1oLVGTXhRQ7YVF3z40PwpnVuHC9lgniqNhTF/OjII8S
         lbn6SItg0PfAQih6RKd/4GB/5YA3WVV71MiNRCfs=
Message-ID: <7bdda2ea-979a-ccc1-88cf-9679239a880a@digikod.net>
Date:   Thu, 6 Jul 2023 16:35:36 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v11 11/12] samples/landlock: Add network demo
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>,
        =?UTF-8?Q?G=c3=bcnther_Noack?= <gnoack@google.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
 <20230515161339.631577-12-konstantin.meskhidze@huawei.com>
 <ZH9OFyWZ1njI7VG9@google.com>
 <d9f07165-f589-13d4-6484-1272704f1de0@huawei.com>
 <8c09fc5a-e3a5-4792-65a8-b84c6044128a@digikod.net>
 <c0713bf1-a65e-c4cd-08b9-c60bd79fc86f@huawei.com>
 <fb1d9351-355c-feb8-c2a2-419e24000049@digikod.net>
 <60e5f0ea-39fa-9f76-35bd-ec88fc489922@huawei.com>
 <1ee25561-96b8-67a6-77ca-475d12ea244d@digikod.net>
 <7df6f52c-578b-d396-7c7e-8dd63946c44e@huawei.com>
 <6d612605-f5c8-d82e-02ec-2f72e1123f53@digikod.net>
 <aa1e9a86-43a0-7967-9107-6b0128e65ef6@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <aa1e9a86-43a0-7967-9107-6b0128e65ef6@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 04/07/2023 14:33, Konstantin Meskhidze (A) wrote:
> 
> 
> 7/3/2023 8:09 PM, Mickaël Salaün пишет:
>>
>> On 03/07/2023 14:50, Konstantin Meskhidze (A) wrote:
>>>
>>>
>>> 6/22/2023 1:18 PM, Mickaël Salaün пишет:
>>>>
>>>> On 22/06/2023 10:00, Konstantin Meskhidze (A) wrote:
>>>>>
>>>>>
>>>>> 6/19/2023 9:19 PM, Mickaël Salaün пишет:
>>>>>>
>>>>>> On 19/06/2023 16:24, Konstantin Meskhidze (A) wrote:
>>>>>>>
>>>>>>>
>>>>>>> 6/13/2023 11:38 PM, Mickaël Salaün пишет:
>>>>>>>>
>>>>>>>> On 13/06/2023 12:54, Konstantin Meskhidze (A) wrote:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> 6/6/2023 6:17 PM, Günther Noack пишет:


[...]

>>>>>>>>>         Thanks for a tip. I think it's a better solution here. Now this
>>>>>>>>> commit is in Mickaёl's -next branch. I could send a one-commit patch later.
>>>>>>>>> Mickaёl, what do you think?
>>>>>>>>
>>>>>>>> I removed this series from -next because there is some issues (see the
>>>>>>>> bot's emails), but anyway, this doesn't mean these patches don't need to
>>>>>>>> be changed, they do. The goal of -next is to test more widely a patch
>>>>>>>> series and get more feedbacks, especially from bots. When this series
>>>>>>>> will be fully ready (and fuzzed with syzkaller), I'll push it to Linus
>>>>>>>> Torvalds.
>>>>>>>>
>>>>>>>> I'll review the remaining tests and sample code this week, but you can
>>>>>>>> still take into account the documentation review.
>>>>>>>
>>>>>>>       Hi, Mickaёl.
>>>>>>>
>>>>>>>       I have a few quetions?
>>>>>>>        - Are you going to fix warnings for bots, meanwhile I run syzcaller?
>>>>>>
>>>>>> No, you need to fix that with the next series (except the Signed-off-by
>>>>>> warnings).
>>>>>
>>>>>      Hi, Mickaёl.
>>>>>       As I understand its possible to check bots warnings just after you
>>>>> push the next V12 series again into your -next branch???
>>>>
>>>> Yes, we get bot warnings on the -next tree, but the command that
>>>> generate it should be reproducible.
>>>
>>>      Stephen Rothwell sent a few warnings he got with powerpc
>>> pseries_le_defconfig. Do I need to fix it in V12 patch? How can I handle
>>> it cause no warnings in current .config?
>>
>> Yes, this need to be fixed in the next series. Could you point to the
>> message?
>>
>     Here you are please:
>        1.
> https://lore.kernel.org/linux-next/20230607141044.1df56246@canb.auug.org.au

This issue is because the WARN_ON_ONCE() is triggered by any 
non-landlocked process, so removing the WARN_ON_ONCE() will fix that.


> 
>        2.
> https://lore.kernel.org/linux-next/20230607135229.1f1e5c91@canb.auug.org.au/

Wrong printf format.


>        3.
> https://lore.kernel.org/linux-next/20230607124940.44af88bb@canb.auug.org.au/

It looks like htmldocs doesn't like #if in enum definition. Anyway, I 
think it should be better to not conditionally define an enum. I've 
pushed this change here: https://git.kernel.org/mic/c/8c96c7eee3ff 
(landlock-net-v11 branch)


> 
>> I'm almost done with the test, I revamped code and I'll send that tomorrow.
>>
>     Ok.Thanks you. Please take your time. I will wait.

[...]
