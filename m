Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20733C27C48
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Oct 2023 02:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbjJ1CHQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Oct 2023 22:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjJ1CHQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Oct 2023 22:07:16 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC01B8;
        Fri, 27 Oct 2023 19:07:10 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4SHNDt1KnYz67bjw;
        Sat, 28 Oct 2023 10:06:22 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Sat, 28 Oct 2023 03:07:06 +0100
Message-ID: <b24bee4a-5131-b8bd-2cdc-833fcc0297f1@huawei.com>
Date:   Sat, 28 Oct 2023 05:07:05 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v14 00/12] Network support for Landlock
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>, Paul Moore <paul@paul-moore.com>
References: <20231026014751.414649-1-konstantin.meskhidze@huawei.com>
 <20231027.weic8eidaiQu@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <20231027.weic8eidaiQu@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml100006.china.huawei.com (7.191.160.224) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



10/27/2023 4:06 PM, Mickaël Salaün пишет:
> Thanks Konstantin!
> 
> I did some minor cosmetic changes, extended a bit the documentation and
> improved the ipv4_tcp.with_fs test. You can see these changes in my
> -next branch:
> https://git.kernel.org/pub/scm/linux/kernel/git/mic/linux.git/log/?h=nex >
> We have a very good test coverage and I think these patches are ready
> for mainline.  If it's OK with you, I plan to send a PR for v6.7-rc1 .
> 
> Regards,
>   Mickaël

  Hi Mickaёl.
  Sounds great. It's OK with me. I learned a lot about kernel 
development process preparing these patch sets. Thank you so much for 
tutoring and patience. I would not make that without your support.

I'm ready for the next steps like we've already discussed:
https://lore.kernel.org/linux-security-module/b4440d19-93b9-e234-007b-4fc4f987550b@digikod.net/
> 
> On Thu, Oct 26, 2023 at 09:47:39AM +0800, Konstantin Meskhidze wrote:
>> Hi,
>> This is a new V14 patch related to Landlock LSM network confinement.
>> It is based on v6.6-rc2 kernel version.
>> 
>> It brings refactoring of previous patch version V13.
>> Mostly there are fixes of logic and typos, refactoring some selftests.
>> 
>> All test were run in QEMU evironment and compiled with
>>  -static flag.
>>  1. network_test: 82/82 tests passed.
>>  2. base_test: 7/7 tests passed.
>>  3. fs_test: 107/107 tests passed.
>>  4. ptrace_test: 8/8 tests passed.
>> 
>> Previous versions:
>> v13: https://lore.kernel.org/linux-security-module/20231016015030.1684504-1-konstantin.meskhidze@huawei.com/
>> v12: https://lore.kernel.org/linux-security-module/20230920092641.832134-1-konstantin.meskhidze@huawei.com/
>> v11: https://lore.kernel.org/linux-security-module/20230515161339.631577-1-konstantin.meskhidze@huawei.com/
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
>>   landlock: Make ruleset's access masks more generic
>>   landlock: Refactor landlock_find_rule/insert_rule
>>   landlock: Refactor merge/inherit_ruleset functions
>>   landlock: Move and rename layer helpers
>>   landlock: Refactor layer helpers
>>   landlock: Refactor landlock_add_rule() syscall
>>   landlock: Add network rules and TCP hooks support
>>   selftests/landlock: Share enforce_ruleset()
>>   selftests/landlock: Add network tests
>>   samples/landlock: Support TCP restrictions
>>   landlock: Document network support
>> 
>> Mickaël Salaün (1):
>>   landlock: Allow FS topology changes for domains without such rule type
>> 
>>  Documentation/userspace-api/landlock.rst     |   96 +-
>>  include/uapi/linux/landlock.h                |   55 +
>>  samples/landlock/sandboxer.c                 |  115 +-
>>  security/landlock/Kconfig                    |    1 +
>>  security/landlock/Makefile                   |    2 +
>>  security/landlock/fs.c                       |  232 +--
>>  security/landlock/limits.h                   |    6 +
>>  security/landlock/net.c                      |  198 ++
>>  security/landlock/net.h                      |   33 +
>>  security/landlock/ruleset.c                  |  405 +++-
>>  security/landlock/ruleset.h                  |  183 +-
>>  security/landlock/setup.c                    |    2 +
>>  security/landlock/syscalls.c                 |  158 +-
>>  tools/testing/selftests/landlock/base_test.c |    2 +-
>>  tools/testing/selftests/landlock/common.h    |   13 +
>>  tools/testing/selftests/landlock/config      |    4 +
>>  tools/testing/selftests/landlock/fs_test.c   |   10 -
>>  tools/testing/selftests/landlock/net_test.c  | 1744 ++++++++++++++++++
>>  18 files changed, 2908 insertions(+), 351 deletions(-)
>>  create mode 100644 security/landlock/net.c
>>  create mode 100644 security/landlock/net.h
>>  create mode 100644 tools/testing/selftests/landlock/net_test.c
>> 
>> --
>> 2.25.1
>> 
> .
