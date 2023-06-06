Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D86D1C7EE2C
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jun 2023 09:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbjFFJK6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjFFJK6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2023 05:10:58 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71048F;
        Tue,  6 Jun 2023 02:10:55 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Qb4QX1kDtz67gyM;
        Tue,  6 Jun 2023 17:08:36 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 10:10:52 +0100
Message-ID: <ea810d57-93fe-1724-4aab-5cbc1a35062f@huawei.com>
Date:   Tue, 6 Jun 2023 12:10:51 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v11 00/12] Network support for Landlock
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
 <8f3d242a-c0ee-217e-8094-84093ce4e134@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <8f3d242a-c0ee-217e-8094-84093ce4e134@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml500002.china.huawei.com (7.191.160.78) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



6/5/2023 6:02 PM, Mickaël Salaün пишет:
> Hi Konstantin,
> 
> The kernel code looks good. I found some issues in tests and
> documentation, and I'm still reviewing the whole patches. In the
> meantime, I've pushed it in -next, we'll see how it goes.
> 
> We need to have this new code covered by syzkaller. I'll work on that
> unless you want to.
> 
> Regards,
>    Mickaël
> 
   Hi, Mickaël!
   I have never set up syzkaller. Do you have a syzkaller scenario for 
Landlock code? I need some hints. I will give it a shot.

  Regards,
     Konstantin.
> 
> On 15/05/2023 18:13, Konstantin Meskhidze wrote:
>> Hi,
>> This is a new V11 patch related to Landlock LSM network confinement.
>> It is based on the landlock's -next branch on top of v6.2-rc3+ kernel version:
>> https://git.kernel.org/pub/scm/linux/kernel/git/mic/linux.git/log/?h=next
>> 
>> It brings refactoring of previous patch version V10.
>> Mostly there are fixes of logic and typos, refactoring some selftests.
>> 
>> All test were run in QEMU evironment and compiled with
>>   -static flag.
>>   1. network_test: 36/36 tests passed.
>>   2. base_test: 7/7 tests passed.
>>   3. fs_test: 78/78 tests passed.
>>   4. ptrace_test: 8/8 tests passed.
>> 
>> Previous versions:
>> v10: https://lore.kernel.org/linux-security-module/20230323085226.1432550-1-konstantin.meskhidze@huawei.com/
>> v9: https://lore.kernel.org/linux-security-module/20230116085818.165539-1-konstantin.meskhidze@huawei.com/
>> v8: https://lore.kernel.org/linux-security-module/20221021152644.155136-1-konstantin.meskhidze@huawei.com/
>> v7: https://lore.kernel.org/linux-security-module/20220829170401.834298-1-konstantin.meskhidze@huawei.com/
>> v6: https://lore.kernel.org/linux-security-module/20220621082313.3330667-1-konstantin.meskhidze@huawei.com/
>> v5: https://lore.kernel.org/linux-security-module/20220516152038.39594-1-konstantin.meskhidze@huawei.com
>> v4: https://lore.kernel.org/linux-security-module/20220309134459.6448-1-konstantin.meskhidze@huawei.com/
>> v3: https://lore.kernel.org/linux-security-module/20220124080215.265538-1-konstantin.meskhidze@huawei.com/
>> v2: https://lore.kernel.org/linux-security-module/20211228115212.703084-1-konstantin.meskhidze@huawei.com/
>> v1: https://lore.kernel.org/linux-security-module/20211210072123.386713-1-konstantin.meskhidze@huawei.com/
>> 
>> Konstantin Meskhidze (11):
>>    landlock: Make ruleset's access masks more generic
>>    landlock: Refactor landlock_find_rule/insert_rule
>>    landlock: Refactor merge/inherit_ruleset functions
>>    landlock: Move and rename layer helpers
>>    landlock: Refactor layer helpers
>>    landlock: Refactor landlock_add_rule() syscall
>>    landlock: Add network rules and TCP hooks support
>>    selftests/landlock: Share enforce_ruleset()
>>    selftests/landlock: Add 11 new test suites dedicated to network
>>    samples/landlock: Add network demo
>>    landlock: Document Landlock's network support
>> 
>> Mickaël Salaün (1):
>>    landlock: Allow filesystem layout changes for domains without such
>>      rule type
>> 
>>   Documentation/userspace-api/landlock.rst     |   89 +-
>>   include/uapi/linux/landlock.h                |   48 +
>>   samples/landlock/sandboxer.c                 |  128 +-
>>   security/landlock/Kconfig                    |    1 +
>>   security/landlock/Makefile                   |    2 +
>>   security/landlock/fs.c                       |  232 +--
>>   security/landlock/limits.h                   |    7 +-
>>   security/landlock/net.c                      |  174 +++
>>   security/landlock/net.h                      |   26 +
>>   security/landlock/ruleset.c                  |  405 +++++-
>>   security/landlock/ruleset.h                  |  185 ++-
>>   security/landlock/setup.c                    |    2 +
>>   security/landlock/syscalls.c                 |  163 ++-
>>   tools/testing/selftests/landlock/base_test.c |    2 +-
>>   tools/testing/selftests/landlock/common.h    |   10 +
>>   tools/testing/selftests/landlock/config      |    4 +
>>   tools/testing/selftests/landlock/fs_test.c   |   74 +-
>>   tools/testing/selftests/landlock/net_test.c  | 1317 ++++++++++++++++++
>>   18 files changed, 2520 insertions(+), 349 deletions(-)
>>   create mode 100644 security/landlock/net.c
>>   create mode 100644 security/landlock/net.h
>>   create mode 100644 tools/testing/selftests/landlock/net_test.c
>> 
>> --
>> 2.25.1
>> 
> .
