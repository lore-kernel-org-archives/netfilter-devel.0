Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DA45C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Mar 2022 17:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236843AbiCQR1Y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Mar 2022 13:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236826AbiCQR1X (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Mar 2022 13:27:23 -0400
X-Greylist: delayed 118762 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 17 Mar 2022 10:26:02 PDT
Received: from smtp-8fab.mail.infomaniak.ch (smtp-8fab.mail.infomaniak.ch [83.166.143.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99ABA114FC3
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Mar 2022 10:26:02 -0700 (PDT)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4KKDZK00LMzMqNMV;
        Thu, 17 Mar 2022 18:26:01 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4KKDZJ35qMzlhRVB;
        Thu, 17 Mar 2022 18:26:00 +0100 (CET)
Message-ID: <ef128eed-65a3-1617-d630-275f3cfa8220@digikod.net>
Date:   Thu, 17 Mar 2022 18:26:45 +0100
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com, anton.sirazetdinov@huawei.com
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
 <c9333349-5e05-de95-85da-f6a0cd836162@digikod.net>
 <29244d4d-70cc-9c4f-6d0f-e3ce3beb2623@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC PATCH v4 00/15] Landlock LSM
In-Reply-To: <29244d4d-70cc-9c4f-6d0f-e3ce3beb2623@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 17/03/2022 14:01, Konstantin Meskhidze wrote:
> 
> 
> 3/15/2022 8:02 PM, Mickaël Salaün пишет:
>> Hi Konstantin,
>>
>> This series looks good! Thanks for the split in multiple patches.
>>
>   Thanks. I follow your recommendations.
>>
>> On 09/03/2022 14:44, Konstantin Meskhidze wrote:
>>> Hi,
>>> This is a new V4 bunch of RFC patches related to Landlock LSM network 
>>> confinement.
>>> It brings deep refactirong and commit splitting of previous version V3.
>>> Also added additional selftests.
>>>
>>> This patch series can be applied on top of v5.17-rc3.
>>>
>>> All test were run in QEMU evironment and compiled with
>>>   -static flag.
>>>   1. network_test: 9/9 tests passed.
>>
>> I get a kernel warning running the network tests.
> 
>    What kind of warning? Can you provide it please?

You really need to get a setup that gives you such kernel warning. When 
running network_test you should get:
WARNING: CPU: 3 PID: 742 at security/landlock/ruleset.c:218 
insert_rule+0x220/0x270

Before sending new patches, please make sure you're able to catch such 
issues.


>>
>>>   2. base_test: 8/8 tests passed.
>>>   3. fs_test: 46/46 tests passed.
>>>   4. ptrace_test: 4/8 tests passed.
>>
>> Does your test machine use Yama? That would explain the 4/8. You can 
>> disable it with the appropriate sysctl.

Can you answer this question?


>>
>>>
>>> Tests were also launched for Landlock version without
>>> v4 patch:
>>>   1. base_test: 8/8 tests passed.
>>>   2. fs_test: 46/46 tests passed.
>>>   3. ptrace_test: 4/8 tests passed.
>>>
>>> Could not provide test coverage cause had problems with tests
>>> on VM (no -static flag the tests compiling, no v4 patch applied):
>>
>> You can build statically-linked tests with:
>> make -C tools/testing/selftests/landlock CFLAGS=-static
> 
>   Ok. I will try. Thanks.
>>
>>> 1. base_test: 7/8 tests passed.
>>>   Error:
>>>   # Starting 8 tests from 1 test cases.
>>>   #  RUN           global.inconsistent_attr ...
>>>   # base_test.c:51:inconsistent_attr:Expected ENOMSG (42) == errno (22)
>>
>> This looks like a bug in the syscall argument checks.
> 
>    This bug I just get when don't use -static option. With -static base 
> test passes 8/8.

Weird, I'd like to know what is the cause of this issue. What disto and 
version do you use as host and guest VM? Do you have some warning when 
compiling?
