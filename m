Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C60B7EB64DD
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Jul 2023 14:55:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbjGAOzC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Jul 2023 10:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjGAOzC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Jul 2023 10:55:02 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506ED35B3;
        Sat,  1 Jul 2023 07:55:01 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4QtZs11kMNz6D8dQ;
        Sat,  1 Jul 2023 22:51:49 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sat, 1 Jul 2023 15:54:58 +0100
Message-ID: <53bc02e9-d3b1-cb35-0b92-0edf8d9d6e58@huawei.com>
Date:   Sat, 1 Jul 2023 17:54:58 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v11 08/12] landlock: Add network rules and TCP hooks
 support
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
 <20230515161339.631577-9-konstantin.meskhidze@huawei.com>
 <fc490ec3-12ff-bca1-1c5e-44d09c54b8a4@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <fc490ec3-12ff-bca1-1c5e-44d09c54b8a4@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml500006.china.huawei.com (7.191.161.198) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



6/26/2023 9:41 PM, Mickaël Salaün пишет:
> 
> On 15/05/2023 18:13, Konstantin Meskhidze wrote:
>> This commit adds network rules support in the ruleset management
>> helpers and the landlock_create_ruleset syscall.
>> Refactor user space API to support network actions. Add new network
>> access flags, network rule and network attributes. Increment Landlock
>> ABI version. Expand access_masks_t to u32 to be sure network access
>> rights can be stored. Implement socket_bind() and socket_connect()
>> LSM hooks, which enables to restrict TCP socket binding and connection
>> to specific ports.
>> 
>> Co-developed-by: Mickaël Salaün <mic@digikod.net>
> 
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> 
> 
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>> 
>> Changes since v10:
>> * Removes "packed" attribute.
>> * Applies Mickaёl's patch with some refactoring.
>> * Deletes get_port() and check_addrlen() helpers.
>> * Refactors check_socket_access() by squashing get_port() and
>> check_addrlen() helpers into it.
>> * Fixes commit message.
>> 
>> Changes since v9:
>> * Changes UAPI port field to __u64.
>> * Moves shared code into check_socket_access().
>> * Adds get_raw_handled_net_accesses() and
>> get_current_net_domain() helpers.
>> * Minor fixes.
>> 
>> Changes since v8:
>> * Squashes commits.
>> * Refactors commit message.
>> * Changes UAPI port field to __be16.
>> * Changes logic of bind/connect hooks with AF_UNSPEC families.
>> * Adds address length checking.
>> * Minor fixes.
>> 
>> Changes since v7:
>> * Squashes commits.
>> * Increments ABI version to 4.
>> * Refactors commit message.
>> * Minor fixes.
>> 
>> Changes since v6:
>> * Renames landlock_set_net_access_mask() to landlock_add_net_access_mask()
>>    because it OR values.
>> * Makes landlock_add_net_access_mask() more resilient incorrect values.
>> * Refactors landlock_get_net_access_mask().
>> * Renames LANDLOCK_MASK_SHIFT_NET to LANDLOCK_SHIFT_ACCESS_NET and use
>>    LANDLOCK_NUM_ACCESS_FS as value.
>> * Updates access_masks_t to u32 to support network access actions.
>> * Refactors landlock internal functions to support network actions with
>>    landlock_key/key_type/id types.
>> 
>> Changes since v5:
>> * Gets rid of partial revert from landlock_add_rule
>> syscall.
>> * Formats code with clang-format-14.
>> 
>> Changes since v4:
>> * Refactors landlock_create_ruleset() - splits ruleset and
>> masks checks.
>> * Refactors landlock_create_ruleset() and landlock mask
>> setters/getters to support two rule types.
>> * Refactors landlock_add_rule syscall add_rule_path_beneath
>> function by factoring out get_ruleset_from_fd() and
>> landlock_put_ruleset().
>> 
>> Changes since v3:
>> * Splits commit.
>> * Adds network rule support for internal landlock functions.
>> * Adds set_mask and get_mask for network.
>> * Adds rb_root root_net_port.
>> 
>> ---
>>   include/uapi/linux/landlock.h                |  48 +++++
>>   security/landlock/Kconfig                    |   1 +
>>   security/landlock/Makefile                   |   2 +
>>   security/landlock/limits.h                   |   6 +-
>>   security/landlock/net.c                      | 174 +++++++++++++++++++
>>   security/landlock/net.h                      |  26 +++
>>   security/landlock/ruleset.c                  |  52 +++++-
>>   security/landlock/ruleset.h                  |  63 +++++--
>>   security/landlock/setup.c                    |   2 +
>>   security/landlock/syscalls.c                 |  72 +++++++-
>>   tools/testing/selftests/landlock/base_test.c |   2 +-
>>   11 files changed, 425 insertions(+), 23 deletions(-)
>>   create mode 100644 security/landlock/net.c
>>   create mode 100644 security/landlock/net.h
>> 
> 
> [...]
> 
>> diff --git a/security/landlock/net.c b/security/landlock/net.c
>> new file mode 100644
>> index 000000000000..f8d2be53ac0d
>> --- /dev/null
>> +++ b/security/landlock/net.c
>> @@ -0,0 +1,174 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Landlock LSM - Network management and hooks
>> + *
>> + * Copyright © 2022 Huawei Tech. Co., Ltd.
>> + * Copyright © 2022 Microsoft Corporation
> 
> You can replace these dates with "2022-2023", and same for all your
> other "2022" I guess.
   Ok. Thanks. I will change the dates.
> .
