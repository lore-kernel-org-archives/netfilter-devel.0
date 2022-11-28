Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B41EC4167D
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Nov 2022 03:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiK1Dcg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 27 Nov 2022 22:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiK1Dcf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Nov 2022 22:32:35 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5369AF21;
        Sun, 27 Nov 2022 19:32:33 -0800 (PST)
Received: from fraeml713-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NL9v25ymvz67Zm5;
        Mon, 28 Nov 2022 11:29:34 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml713-chm.china.huawei.com (10.206.15.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 28 Nov 2022 04:32:31 +0100
Received: from [10.122.132.241] (10.122.132.241) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 28 Nov 2022 03:32:30 +0000
Message-ID: <c8247148-2d44-d8e7-39e4-fa2e9f1f4384@huawei.com>
Date:   Mon, 28 Nov 2022 06:32:29 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v8 06/12] landlock: Refactor landlock_add_rule() syscall
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <artem.kuzin@huawei.com>
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-7-konstantin.meskhidze@huawei.com>
 <df4a441f-07c4-8eb0-6c71-58dc06604dd9@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <df4a441f-07c4-8eb0-6c71-58dc06604dd9@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhrpeml100006.china.huawei.com (7.191.160.224) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



11/17/2022 9:42 PM, Mickaël Salaün пишет:
> 
> On 21/10/2022 17:26, Konstantin Meskhidze wrote:
>> Modifies landlock_add_rule() syscall to support new rule types in future
> 
> Change the landlock_add_rule() syscall…
> 
   Ok.
> 
>> Landlock versions. Adds add_rule_path_beneath() helper to support
> 
> Add the…

   Got it. Thanks.
> 
>> current filesystem rules.
>> 
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>> 
>> Changes since v7:
>> * None
>> 
>> Changes since v6:
>> * None
>> 
>> Changes since v5:
>> * Refactors syscall landlock_add_rule() and add_rule_path_beneath() helper
>> to make argument check ordering consistent and get rid of partial revertings
>> in following patches.
>> * Rolls back refactoring base_test.c seltest.
>> * Formats code with clang-format-14.
>> 
>> Changes since v4:
>> * Refactors add_rule_path_beneath() and landlock_add_rule() functions
>> to optimize code usage.
>> * Refactors base_test.c seltest: adds LANDLOCK_RULE_PATH_BENEATH
>> rule type in landlock_add_rule() call.
>> 
>> Changes since v3:
>> * Split commit.
>> * Refactors landlock_add_rule syscall.
>> 
>> ---
>>   security/landlock/syscalls.c | 92 +++++++++++++++++++-----------------
>>   1 file changed, 48 insertions(+), 44 deletions(-)
>> 
>> diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
>> index 71aca7f990bc..87389d7bfbf2 100644
>> --- a/security/landlock/syscalls.c
>> +++ b/security/landlock/syscalls.c
>> @@ -274,6 +274,47 @@ static int get_path_from_fd(const s32 fd, struct path *const path)
>>   	return err;
>>   }
>> 
>> +static int add_rule_path_beneath(struct landlock_ruleset *const ruleset,
>> +				 const void __user *const rule_attr)
>> +{
>> +	struct landlock_path_beneath_attr path_beneath_attr;
>> +	struct path path;
>> +	int res, err;
>> +	u32 mask;
> 
> access_mask_t mask;

   will be fixed thanks.
> .
