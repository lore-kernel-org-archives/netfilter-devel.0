Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AEF7EB64DA
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jul 2023 10:36:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjGEKgV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jul 2023 06:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbjGEKgU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jul 2023 06:36:20 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85262E6E;
        Wed,  5 Jul 2023 03:36:18 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Qwwws55CCz6J6K5;
        Wed,  5 Jul 2023 18:33:17 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 5 Jul 2023 11:36:14 +0100
Message-ID: <fa5301dc-f9c4-3029-a422-36b29fc076c5@huawei.com>
Date:   Wed, 5 Jul 2023 13:36:14 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v11 04/12] landlock: Refactor merge/inherit_ruleset
 functions
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
 <20230515161339.631577-5-konstantin.meskhidze@huawei.com>
 <3b52ba0c-d013-b7a9-0f08-2e6d677a1df0@digikod.net>
 <12b5f33d-e2f5-3a12-c4f7-0164b6f36fba@huawei.com>
 <5713efed-22cb-7029-5dce-d2bd0b204a8b@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <5713efed-22cb-7029-5dce-d2bd0b204a8b@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml500002.china.huawei.com (7.191.160.78) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



7/5/2023 1:16 PM, Mickaël Salaün пишет:
> 
> On 01/07/2023 16:52, Konstantin Meskhidze (A) wrote:
>> 
>> 
>> 6/26/2023 9:40 PM, Mickaël Salaün пишет:
>>>
>>> On 15/05/2023 18:13, Konstantin Meskhidze wrote:
>>>> Refactor merge_ruleset() and inherit_ruleset() functions to support
>>>> new rule types. This patch adds merge_tree() and inherit_tree()
>>>> helpers. They use a specific ruleset's red-black tree according to
>>>> a key type argument.
>>>>
>>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>>> ---
>>>>
>>>> Changes since v10:
>>>> * Refactors merge_tree() function.
>>>>
>>>> Changes since v9:
>>>> * None
>>>>
>>>> Changes since v8:
>>>> * Refactors commit message.
>>>> * Minor fixes.
>>>>
>>>> Changes since v7:
>>>> * Adds missed lockdep_assert_held it inherit_tree() and merge_tree().
>>>> * Fixes comment.
>>>>
>>>> Changes since v6:
>>>> * Refactors merge_ruleset() and inherit_ruleset() functions to support
>>>>     new rule types.
>>>> * Renames tree_merge() to merge_tree() (and reorder arguments), and
>>>>     tree_copy() to inherit_tree().
>>>>
>>>> Changes since v5:
>>>> * Refactors some logic errors.
>>>> * Formats code with clang-format-14.
>>>>
>>>> Changes since v4:
>>>> * None
>>>>
>>>> ---
>>>>    security/landlock/ruleset.c | 122 +++++++++++++++++++++++-------------
>>>>    1 file changed, 79 insertions(+), 43 deletions(-)
>>>>
>>>> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
>>>> index deab37838f5b..e4f449fdd6dd 100644
>>>> --- a/security/landlock/ruleset.c
>>>> +++ b/security/landlock/ruleset.c
>>>> @@ -302,36 +302,22 @@ static void put_hierarchy(struct landlock_hierarchy *hierarchy)
>>>>    	}
>>>>    }
>>>>
>>>> -static int merge_ruleset(struct landlock_ruleset *const dst,
>>>> -			 struct landlock_ruleset *const src)
>>>> +static int merge_tree(struct landlock_ruleset *const dst,
>>>> +		      struct landlock_ruleset *const src,
>>>> +		      const enum landlock_key_type key_type)
>>>>    {
>>>>    	struct landlock_rule *walker_rule, *next_rule;
>>>>    	struct rb_root *src_root;
>>>>    	int err = 0;
>>>>
>>>>    	might_sleep();
>>>> -	/* Should already be checked by landlock_merge_ruleset() */
>>>> -	if (WARN_ON_ONCE(!src))
>>>> -		return 0;
>>>> -	/* Only merge into a domain. */
>>>> -	if (WARN_ON_ONCE(!dst || !dst->hierarchy))
>>>> -		return -EINVAL;
>>>> +	lockdep_assert_held(&dst->lock);
>>>> +	lockdep_assert_held(&src->lock);
>>>>
>>>> -	src_root = get_root(src, LANDLOCK_KEY_INODE);
>>>> +	src_root = get_root(src, key_type);
>>>>    	if (IS_ERR(src_root))
>>>>    		return PTR_ERR(src_root);
>>>>
>>>> -	/* Locks @dst first because we are its only owner. */
>>>> -	mutex_lock(&dst->lock);
>>>> -	mutex_lock_nested(&src->lock, SINGLE_DEPTH_NESTING);
>>>> -
>>>> -	/* Stacks the new layer. */
>>>> -	if (WARN_ON_ONCE(src->num_layers != 1 || dst->num_layers < 1)) {
>>>> -		err = -EINVAL;
>>>> -		goto out_unlock;
>>>> -	}
>>>> -	dst->access_masks[dst->num_layers - 1] = src->access_masks[0];
>>>> -
>>>>    	/* Merges the @src tree. */
>>>>    	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule, src_root,
>>>>    					     node) {
>>>> @@ -340,23 +326,52 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
>>>>    		} };
>>>>    		const struct landlock_id id = {
>>>>    			.key = walker_rule->key,
>>>> -			.type = LANDLOCK_KEY_INODE,
>>>> +			.type = key_type,
>>>>    		};
>>>>
>>>> -		if (WARN_ON_ONCE(walker_rule->num_layers != 1)) {
>>>> -			err = -EINVAL;
>>>> -			goto out_unlock;
>>>> -		}
>>>> -		if (WARN_ON_ONCE(walker_rule->layers[0].level != 0)) {
>>>> -			err = -EINVAL;
>>>> -			goto out_unlock;
>>>> -		}
>>>> +		if (WARN_ON_ONCE(walker_rule->num_layers != 1))
>>>> +			return -EINVAL;
>>>> +
>>>> +		if (WARN_ON_ONCE(walker_rule->layers[0].level != 0))
>>>> +			return -EINVAL;
>>>> +
>>>>    		layers[0].access = walker_rule->layers[0].access;
>>>>
>>>>    		err = insert_rule(dst, id, &layers, ARRAY_SIZE(layers));
>>>>    		if (err)
>>>> -			goto out_unlock;
>>>> +			return err;
>>>> +	}
>>>> +	return err;
>>>> +}
>>>> +
>>>> +static int merge_ruleset(struct landlock_ruleset *const dst,
>>>> +			 struct landlock_ruleset *const src)
>>>> +{
>>>> +	int err = 0;
>>>> +
>>>> +	might_sleep();
>>>> +	/* Should already be checked by landlock_merge_ruleset() */
>>>> +	if (WARN_ON_ONCE(!src))
>>>> +		return 0;
>>>> +	/* Only merge into a domain. */
>>>> +	if (WARN_ON_ONCE(!dst || !dst->hierarchy))
>>>> +		return -EINVAL;
>>>> +
>>>> +	/* Locks @dst first because we are its only owner. */
>>>> +	mutex_lock(&dst->lock);
>>>> +	mutex_lock_nested(&src->lock, SINGLE_DEPTH_NESTING);
>>>> +
>>>> +	/* Stacks the new layer. */
>>>> +	if (WARN_ON_ONCE(src->num_layers != 1 || dst->num_layers < 1)) {
>>>> +		err = -EINVAL;
>>>> +		goto out_unlock;
>>>>    	}
>>>> +	dst->access_masks[dst->num_layers - 1] = src->access_masks[0];
>>>> +
>>>> +	/* Merges the @src inode tree. */
>>>> +	err = merge_tree(dst, src, LANDLOCK_KEY_INODE);
>>>> +	if (err)
>>>> +		goto out_unlock;
>>>>
>>>>    out_unlock:
>>>>    	mutex_unlock(&src->lock);
>>>> @@ -364,43 +379,64 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
>>>>    	return err;
>>>>    }
>>>>
>>>> -static int inherit_ruleset(struct landlock_ruleset *const parent,
>>>> -			   struct landlock_ruleset *const child)
>>>> +static int inherit_tree(struct landlock_ruleset *const parent,
>>>> +			struct landlock_ruleset *const child,
>>>> +			const enum landlock_key_type key_type)
>>>>    {
>>>>    	struct landlock_rule *walker_rule, *next_rule;
>>>>    	struct rb_root *parent_root;
>>>>    	int err = 0;
>>>>
>>>>    	might_sleep();
>>>> -	if (!parent)
>>>> -		return 0;
>>>> +	lockdep_assert_held(&parent->lock);
>>>> +	lockdep_assert_held(&child->lock);
>>>>
>>>> -	parent_root = get_root(parent, LANDLOCK_KEY_INODE);
>>>> +	parent_root = get_root(parent, key_type);
>>>>    	if (IS_ERR(parent_root))
>>>>    		return PTR_ERR(parent_root);
>>>>
>>>> -	/* Locks @child first because we are its only owner. */
>>>> -	mutex_lock(&child->lock);
>>>> -	mutex_lock_nested(&parent->lock, SINGLE_DEPTH_NESTING);
>>>> -
>>>> -	/* Copies the @parent tree. */
>>>> +	/* Copies the @parent inode or network tree. */
>>>>    	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule,
>>>>    					     parent_root, node) {
>>>>    		const struct landlock_id id = {
>>>>    			.key = walker_rule->key,
>>>> -			.type = LANDLOCK_KEY_INODE,
>>>> +			.type = key_type,
>>>>    		};
>>>> +
>>>>    		err = insert_rule(child, id, &walker_rule->layers,
>>>>    				  walker_rule->num_layers);
>>>>    		if (err)
>>>> -			goto out_unlock;
>>>> +			return err;
>>>>    	}
>>>> +	return err;
>>>> +}
>>>> +
>>>> +static int inherit_ruleset(struct landlock_ruleset *const parent,
>>>> +			   struct landlock_ruleset *const child)
>>>> +{
>>>> +	int err = 0;
>>>> +
>>>> +	might_sleep();
>>>> +	if (!parent)
>>>> +		return 0;
>>>> +
>>>> +	/* Locks @child first because we are its only owner. */
>>>> +	mutex_lock(&child->lock);
>>>> +	mutex_lock_nested(&parent->lock, SINGLE_DEPTH_NESTING);
>>>> +
>>>> +	/* Copies the @parent inode tree. */
>>>> +	err = inherit_tree(parent, child, LANDLOCK_KEY_INODE);
>>>> +	if (err)
>>>> +		goto out_unlock;
>>>>
>>>>    	if (WARN_ON_ONCE(child->num_layers <= parent->num_layers)) {
>>>>    		err = -EINVAL;
>>>>    		goto out_unlock;
>>>>    	}
>>>> -	/* Copies the parent layer stack and leaves a space for the new layer. */
>>>> +	/*
>>>> +	 * Copies the parent layer stack and leaves a space
>>>> +	 * for the new layer.
>>>> +	 */
>>>
>>> Did that get formatted because of clang-format? The original line exceed
>>> the 80 columns limit, but it is not caught by different version of
>>> clang-format I tested. Anyway, we should remove this hunk for now
>>> because it has no link with the current patch.
>> 
>>     Yep. I format every patch with clnag-format.
>>     I will remove this hunk and let it be as it was.
> 
> It's weird because clang-format doesn't touch this hunk for me. Which
> version do you use? Do you have any specific configuration?

   Sorry for misleading, its my fault. I realized that I had formated it 
by myself (more than 80 columns length). You are right that clang-format 
does not have to do with it - just checked it. I will remove the hunk.

> .
