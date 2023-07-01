Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59D43C0015E
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Jul 2023 14:37:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjGAOhQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Jul 2023 10:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbjGAOhP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Jul 2023 10:37:15 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EAC535B7;
        Sat,  1 Jul 2023 07:37:12 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4QtZVF6fSlz6J6pr;
        Sat,  1 Jul 2023 22:35:33 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sat, 1 Jul 2023 15:37:09 +0100
Message-ID: <1073d016-4c70-6309-5ee1-026eec8e76f8@huawei.com>
Date:   Sat, 1 Jul 2023 17:37:08 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v11 03/12] landlock: Refactor
 landlock_find_rule/insert_rule
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
 <20230515161339.631577-4-konstantin.meskhidze@huawei.com>
 <7ccd6600-c171-136d-82b5-8555b81ea7ba@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <7ccd6600-c171-136d-82b5-8555b81ea7ba@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml500003.china.huawei.com (7.191.162.67) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



6/26/2023 9:40 PM, Mickaël Salaün пишет:
> 
> On 15/05/2023 18:13, Konstantin Meskhidze wrote:
>> Add a new landlock_key union and landlock_id structure to support
>> a socket port rule type. A struct landlock_id identifies a unique entry
>> in a ruleset: either a kernel object (e.g inode) or typed data (e.g TCP
>> port). There is one red-black tree per key type.
>> 
>> This patch also adds is_object_pointer() and get_root() helpers.
>> is_object_pointer() returns true if key type is LANDLOCK_KEY_INODE.
>> get_root() helper returns a red_black tree root pointer according to
>> a key type.
>> 
>> Refactor landlock_insert_rule() and landlock_find_rule() to support coming
>> network modifications. Adding or searching a rule in ruleset can now be
>> done thanks to a Landlock ID argument passed to these helpers.
>> 
>> Co-developed-by: Mickaël Salaün <mic@digikod.net>
>> Signed-off-by: Mickaël Salaün <mic@digikod.net>
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>> 
>> Changes since v10:
>> * None.
>> 
>> Changes since v9:
>> * Splits commit.
>> * Refactors commit message.
>> * Minor fixes.
>> 
>> Changes since v8:
>> * Refactors commit message.
>> * Removes inlining.
>> * Minor fixes.
>> 
>> Changes since v7:
>> * Completes all the new field descriptions landlock_key,
>>    landlock_key_type, landlock_id.
>> * Refactors commit message, adds a co-developer.
>> 
>> Changes since v6:
>> * Adds union landlock_key, enum landlock_key_type, and struct
>>    landlock_id.
>> * Refactors ruleset functions and improves switch/cases: create_rule(),
>>    insert_rule(), get_root(), is_object_pointer(), free_rule(),
>>    landlock_find_rule().
>> * Refactors landlock_append_fs_rule() functions to support new
>>    landlock_id type.
>> 
>> Changes since v5:
>> * Formats code with clang-format-14.
>> 
>> Changes since v4:
>> * Refactors insert_rule() and create_rule() functions by deleting
>> rule_type from their arguments list, it helps to reduce useless code.
>> 
>> Changes since v3:
>> * Splits commit.
>> * Refactors landlock_insert_rule and landlock_find_rule functions.
>> * Rename new_ruleset->root_inode.
>> 
>> ---
>>   security/landlock/fs.c      |  21 +++---
>>   security/landlock/ruleset.c | 134 ++++++++++++++++++++++++++----------
>>   security/landlock/ruleset.h |  65 ++++++++++++++---
>>   3 files changed, 166 insertions(+), 54 deletions(-)
> 
> [...]
> 
>> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
>> index 1f3188b4e313..deab37838f5b 100644
>> --- a/security/landlock/ruleset.c
>> +++ b/security/landlock/ruleset.c
> 
> [...]
> 
>> @@ -316,21 +368,29 @@ static int inherit_ruleset(struct landlock_ruleset *const parent,
>>   			   struct landlock_ruleset *const child)
>>   {
>>   	struct landlock_rule *walker_rule, *next_rule;
>> +	struct rb_root *parent_root;
>>   	int err = 0;
>> 
>>   	might_sleep();
>>   	if (!parent)
>>   		return 0;
>> 
>> +	parent_root = get_root(parent, LANDLOCK_KEY_INODE);
>> +	if (IS_ERR(parent_root))
>> +		return PTR_ERR(parent_root);
>> +
>>   	/* Locks @child first because we are its only owner. */
>>   	mutex_lock(&child->lock);
>>   	mutex_lock_nested(&parent->lock, SINGLE_DEPTH_NESTING);
>> 
>>   	/* Copies the @parent tree. */
>>   	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule,
>> -					     &parent->root, node) {
>> -		err = insert_rule(child, walker_rule->object,
>> -				  &walker_rule->layers,
>> +					     parent_root, node) {
>> +		const struct landlock_id id = {
>> +			.key = walker_rule->key,
>> +			.type = LANDLOCK_KEY_INODE,
>> +		};
> 
> Please add a line break here instead of in a the following refactoring
> commit.

   Ok. Will be addded.
> 
> 
>> +		err = insert_rule(child, id, &walker_rule->layers,
>>   				  walker_rule->num_layers);
>>   		if (err)
>>   			goto out_unlock;
> .
