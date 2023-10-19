Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91394C41513
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 11:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345471AbjJSL53 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 07:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345449AbjJSL50 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 07:57:26 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C2ACF;
        Thu, 19 Oct 2023 04:57:24 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4SB5j152jMz6HJLt;
        Thu, 19 Oct 2023 19:53:57 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Thu, 19 Oct 2023 12:57:21 +0100
Message-ID: <d2ac366a-c929-0d2f-8855-0d7cf5e1704f@huawei.com>
Date:   Thu, 19 Oct 2023 14:57:20 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v13 07/12] landlock: Refactor landlock_add_rule() syscall
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20231016015030.1684504-1-konstantin.meskhidze@huawei.com>
 <20231016015030.1684504-8-konstantin.meskhidze@huawei.com>
 <20231018.quie0uuphieB@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <20231018.quie0uuphieB@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml100001.china.huawei.com (7.191.160.183) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



10/18/2023 7:34 PM, Mickaël Salaün пишет:
> On Mon, Oct 16, 2023 at 09:50:25AM +0800, Konstantin Meskhidze wrote:
>> Change the landlock_add_rule() syscall to support new rule types
>> in future Landlock versions. Add the add_rule_path_beneath() helper
>> to support current filesystem rules.
>> 
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> Link: https://lore.kernel.org/r/20230920092641.832134-8-konstantin.meskhidze@huawei.com
>> Signed-off-by: Mickaël Salaün <mic@digikod.net>
>> ---
>> 
>> Changes since v12:
>> * None.
>> 
>> Changes since v11:
>> * None.
>> 
>> Changes since v10:
>> * None.
>> 
>> Changes since v9:
>> * Minor fixes:
>> 	- deletes unnecessary curly braces.
>> 	- deletes unnecessary empty line.
>> 
>> Changes since v8:
>> * Refactors commit message.
>> * Minor fixes.
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
>>  security/landlock/syscalls.c | 92 +++++++++++++++++++-----------------
>>  1 file changed, 48 insertions(+), 44 deletions(-)
>> 
>> diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
>> index d35cd5d304db..8a54e87dbb17 100644
>> --- a/security/landlock/syscalls.c
>> +++ b/security/landlock/syscalls.c
>> @@ -274,6 +274,47 @@ static int get_path_from_fd(const s32 fd, struct path *const path)
>>  	return err;
>>  }
>> 
>> +static int add_rule_path_beneath(struct landlock_ruleset *const ruleset,
>> +				 const void __user *const rule_attr)
>> +{
>> +	struct landlock_path_beneath_attr path_beneath_attr;
>> +	struct path path;
>> +	int res, err;
>> +	access_mask_t mask;
>> +
>> +	/* Copies raw user space buffer, only one type for now. */
>> +	res = copy_from_user(&path_beneath_attr, rule_attr,
>> +			     sizeof(path_beneath_attr));
>> +	if (res)
>> +		return -EFAULT;
>> +
>> +	/*
>> +	 * Informs about useless rule: empty allowed_access (i.e. deny rules)
>> +	 * are ignored in path walks.
>> +	 */
>> +	if (!path_beneath_attr.allowed_access)
>> +		return -ENOMSG;
>> +
>> +	/*
>> +	 * Checks that allowed_access matches the @ruleset constraints
>> +	 * (ruleset->access_masks[0] is automatically upgraded to 64-bits).
>> +	 */
> 
> You now can replace this comment block with that:
> +	/* Checks that allowed_access matches the @ruleset constraints. */

   Done.
> 
>> +	mask = landlock_get_raw_fs_access_mask(ruleset, 0);
>> +	if ((path_beneath_attr.allowed_access | mask) != mask)
>> +		return -EINVAL;
>> +
>> +	/* Gets and checks the new rule. */
>> +	err = get_path_from_fd(path_beneath_attr.parent_fd, &path);
>> +	if (err)
>> +		return err;
>> +
>> +	/* Imports the new rule. */
>> +	err = landlock_append_fs_rule(ruleset, &path,
>> +				      path_beneath_attr.allowed_access);
>> +	path_put(&path);
>> +	return err;
>> +}
> .
