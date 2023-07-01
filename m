Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF749EB64DD
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Jul 2023 14:38:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbjGAOi2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Jul 2023 10:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjGAOi1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Jul 2023 10:38:27 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242E73A92;
        Sat,  1 Jul 2023 07:38:24 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4QtZV96ndWz6D9Bf;
        Sat,  1 Jul 2023 22:35:29 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sat, 1 Jul 2023 15:38:21 +0100
Message-ID: <46883829-2099-5323-233b-86abc3fc311d@huawei.com>
Date:   Sat, 1 Jul 2023 17:38:20 +0300
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
 <64e21175-77ab-9a91-2997-43411b93cdaa@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <64e21175-77ab-9a91-2997-43411b93cdaa@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml100005.china.huawei.com (7.191.160.25) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



6/26/2023 9:58 PM, Mickaël Salaün пишет:
> Complementary review:
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
>> 
>> diff --git a/security/landlock/fs.c b/security/landlock/fs.c
>> index a0c9c927fdf9..9a8e70f65a88 100644
>> --- a/security/landlock/fs.c
>> +++ b/security/landlock/fs.c
>> @@ -158,7 +158,9 @@ int landlock_append_fs_rule(struct landlock_ruleset *const ruleset,
>>   			    access_mask_t access_rights)
>>   {
>>   	int err;
>> -	struct landlock_object *object;
>> +	struct landlock_id id = {
>> +		.type = LANDLOCK_KEY_INODE,
>> +	};
>> 
>>   	/* Files only get access rights that make sense. */
>>   	if (!d_is_dir(path->dentry) &&
>> @@ -170,17 +172,17 @@ int landlock_append_fs_rule(struct landlock_ruleset *const ruleset,
>>   	/* Transforms relative access rights to absolute ones. */
>>   	access_rights |= LANDLOCK_MASK_ACCESS_FS &
>>   			 ~landlock_get_fs_access_mask(ruleset, 0);
>> -	object = get_inode_object(d_backing_inode(path->dentry));
>> -	if (IS_ERR(object))
>> -		return PTR_ERR(object);
>> +	id.key.object = get_inode_object(d_backing_inode(path->dentry));
>> +	if (IS_ERR(id.key.object))
>> +		return PTR_ERR(id.key.object);
>>   	mutex_lock(&ruleset->lock);
>> -	err = landlock_insert_rule(ruleset, object, access_rights);
>> +	err = landlock_insert_rule(ruleset, id, access_rights);
>>   	mutex_unlock(&ruleset->lock);
>>   	/*
>>   	 * No need to check for an error because landlock_insert_rule()
>>   	 * increments the refcount for the new object if needed.
>>   	 */
>> -	landlock_put_object(object);
>> +	landlock_put_object(id.key.object);
>>   	return err;
>>   }
>> 
>> @@ -197,6 +199,9 @@ find_rule(const struct landlock_ruleset *const domain,
>>   {
>>   	const struct landlock_rule *rule;
>>   	const struct inode *inode;
>> +	struct landlock_id id = {
>> +		.type = LANDLOCK_KEY_INODE,
>> +	};
>> 
>>   	/* Ignores nonexistent leafs. */
>>   	if (d_is_negative(dentry))
>> @@ -204,8 +209,8 @@ find_rule(const struct landlock_ruleset *const domain,
>> 
>>   	inode = d_backing_inode(dentry);
>>   	rcu_read_lock();
>> -	rule = landlock_find_rule(
>> -		domain, rcu_dereference(landlock_inode(inode)->object));
>> +	id.key.object = rcu_dereference(landlock_inode(inode)->object);
>> +	rule = landlock_find_rule(domain, id);
>>   	rcu_read_unlock();
>>   	return rule;
>>   }
>> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
>> index 1f3188b4e313..deab37838f5b 100644
>> --- a/security/landlock/ruleset.c
>> +++ b/security/landlock/ruleset.c
>> @@ -35,7 +35,7 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
>>   		return ERR_PTR(-ENOMEM);
>>   	refcount_set(&new_ruleset->usage, 1);
>>   	mutex_init(&new_ruleset->lock);
>> -	new_ruleset->root = RB_ROOT;
>> +	new_ruleset->root_inode = RB_ROOT;
>>   	new_ruleset->num_layers = num_layers;
>>   	/*
>>   	 * hierarchy = NULL
>> @@ -68,8 +68,18 @@ static void build_check_rule(void)
>>   	BUILD_BUG_ON(rule.num_layers < LANDLOCK_MAX_NUM_LAYERS);
>>   }
>> 
>> +static bool is_object_pointer(const enum landlock_key_type key_type)
>> +{
>> +	switch (key_type) {
>> +	case LANDLOCK_KEY_INODE:
>> +		return true;
>> +	}
>> +	WARN_ON_ONCE(1);
>> +	return false;
>> +}
>> +
>>   static struct landlock_rule *
>> -create_rule(struct landlock_object *const object,
>> +create_rule(const struct landlock_id id,
>>   	    const struct landlock_layer (*const layers)[], const u32 num_layers,
>>   	    const struct landlock_layer *const new_layer)
>>   {
>> @@ -90,8 +100,13 @@ create_rule(struct landlock_object *const object,
>>   	if (!new_rule)
>>   		return ERR_PTR(-ENOMEM);
>>   	RB_CLEAR_NODE(&new_rule->node);
>> -	landlock_get_object(object);
>> -	new_rule->object = object;
>> +	if (is_object_pointer(id.type)) {
>> +		/* This should be catched by insert_rule(). */
>> +		WARN_ON_ONCE(!id.key.object);
>> +		landlock_get_object(id.key.object);
>> +	}
>> +
>> +	new_rule->key = id.key;
>>   	new_rule->num_layers = new_num_layers;
>>   	/* Copies the original layer stack. */
>>   	memcpy(new_rule->layers, layers,
>> @@ -102,12 +117,29 @@ create_rule(struct landlock_object *const object,
>>   	return new_rule;
>>   }
>> 
>> -static void free_rule(struct landlock_rule *const rule)
>> +static struct rb_root *get_root(struct landlock_ruleset *const ruleset,
>> +				const enum landlock_key_type key_type)
>> +{
>> +	struct rb_root *root = NULL;
>> +
>> +	switch (key_type) {
>> +	case LANDLOCK_KEY_INODE:
>> +		root = &ruleset->root_inode;
>> +		break;
>> +	}
>> +	if (WARN_ON_ONCE(!root))
>> +		return ERR_PTR(-EINVAL);
>> +	return root;
>> +}
>> +
>> +static void free_rule(struct landlock_rule *const rule,
>> +		      const enum landlock_key_type key_type)
>>   {
>>   	might_sleep();
>>   	if (!rule)
>>   		return;
>> -	landlock_put_object(rule->object);
>> +	if (is_object_pointer(key_type))
>> +		landlock_put_object(rule->key.object);
>>   	kfree(rule);
>>   }
>> 
>> @@ -129,8 +161,8 @@ static void build_check_ruleset(void)
>>    * insert_rule - Create and insert a rule in a ruleset
>>    *
>>    * @ruleset: The ruleset to be updated.
>> - * @object: The object to build the new rule with.  The underlying kernel
>> - *          object must be held by the caller.
>> + * @id: The ID to build the new rule with.  The underlying kernel object, if
>> + *      any, must be held by the caller.
>>    * @layers: One or multiple layers to be copied into the new rule.
>>    * @num_layers: The number of @layers entries.
>>    *
>> @@ -144,26 +176,37 @@ static void build_check_ruleset(void)
>>    * access rights.
>>    */
>>   static int insert_rule(struct landlock_ruleset *const ruleset,
>> -		       struct landlock_object *const object,
>> +		       const struct landlock_id id,
>>   		       const struct landlock_layer (*const layers)[],
>> -		       size_t num_layers)
>> +		       const size_t num_layers)
>>   {
>>   	struct rb_node **walker_node;
>>   	struct rb_node *parent_node = NULL;
>>   	struct landlock_rule *new_rule;
>> +	struct rb_root *root;
>> 
>>   	might_sleep();
>>   	lockdep_assert_held(&ruleset->lock);
>> -	if (WARN_ON_ONCE(!object || !layers))
>> +	if (WARN_ON_ONCE(!layers))
>>   		return -ENOENT;
>> -	walker_node = &(ruleset->root.rb_node);
>> +
>> +	if (is_object_pointer(id.type)) {
>> +		if (WARN_ON_ONCE(!id.key.object))
> 
> This would be simpler:
> 
> if (is_object_pointer(id.type) && WARN_ON_ONCE(!id.key.object))
> 	return -ENOENT;
>  
   Yep. Thank you for the tip.
> 
>> +			return -ENOENT;
>> +	}
>> +
> .
