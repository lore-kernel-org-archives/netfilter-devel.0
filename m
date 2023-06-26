Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AFD5EB64DD
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Jun 2023 18:40:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbjFZSkS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Jun 2023 14:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbjFZSkR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jun 2023 14:40:17 -0400
Received: from smtp-8fac.mail.infomaniak.ch (smtp-8fac.mail.infomaniak.ch [IPv6:2001:1600:4:17::8fac])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B884CED
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jun 2023 11:40:15 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Qqc8s6HNHzMq6Tp;
        Mon, 26 Jun 2023 18:40:13 +0000 (UTC)
Received: from unknown by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4Qqc8s0mlGzMpqLq;
        Mon, 26 Jun 2023 20:40:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1687804813;
        bh=1lsc72iy6ST9mPJPeVB5zyv/6hjrSVWAcBML9Eit0II=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=FUtUSqnlRlIyxj5gsiRsVZGGbuvPVYz5sEh2XUIIzsDeMqGIt0MSNEcz4aL+dNBuY
         txxCGyKxbRDKp8NNaaC0IsCVG1RCIXHhNT5Ed5ln8pi/u4ODhBZMaYOaQsNV/VdO1q
         LBLy6o0htmp+vEDsbPiv7STwQ+qEaTyF51vLAqLk=
Message-ID: <7ccd6600-c171-136d-82b5-8555b81ea7ba@digikod.net>
Date:   Mon, 26 Jun 2023 20:40:12 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v11 03/12] landlock: Refactor
 landlock_find_rule/insert_rule
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
 <20230515161339.631577-4-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20230515161339.631577-4-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 15/05/2023 18:13, Konstantin Meskhidze wrote:
> Add a new landlock_key union and landlock_id structure to support
> a socket port rule type. A struct landlock_id identifies a unique entry
> in a ruleset: either a kernel object (e.g inode) or typed data (e.g TCP
> port). There is one red-black tree per key type.
> 
> This patch also adds is_object_pointer() and get_root() helpers.
> is_object_pointer() returns true if key type is LANDLOCK_KEY_INODE.
> get_root() helper returns a red_black tree root pointer according to
> a key type.
> 
> Refactor landlock_insert_rule() and landlock_find_rule() to support coming
> network modifications. Adding or searching a rule in ruleset can now be
> done thanks to a Landlock ID argument passed to these helpers.
> 
> Co-developed-by: Mickaël Salaün <mic@digikod.net>
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v10:
> * None.
> 
> Changes since v9:
> * Splits commit.
> * Refactors commit message.
> * Minor fixes.
> 
> Changes since v8:
> * Refactors commit message.
> * Removes inlining.
> * Minor fixes.
> 
> Changes since v7:
> * Completes all the new field descriptions landlock_key,
>    landlock_key_type, landlock_id.
> * Refactors commit message, adds a co-developer.
> 
> Changes since v6:
> * Adds union landlock_key, enum landlock_key_type, and struct
>    landlock_id.
> * Refactors ruleset functions and improves switch/cases: create_rule(),
>    insert_rule(), get_root(), is_object_pointer(), free_rule(),
>    landlock_find_rule().
> * Refactors landlock_append_fs_rule() functions to support new
>    landlock_id type.
> 
> Changes since v5:
> * Formats code with clang-format-14.
> 
> Changes since v4:
> * Refactors insert_rule() and create_rule() functions by deleting
> rule_type from their arguments list, it helps to reduce useless code.
> 
> Changes since v3:
> * Splits commit.
> * Refactors landlock_insert_rule and landlock_find_rule functions.
> * Rename new_ruleset->root_inode.
> 
> ---
>   security/landlock/fs.c      |  21 +++---
>   security/landlock/ruleset.c | 134 ++++++++++++++++++++++++++----------
>   security/landlock/ruleset.h |  65 ++++++++++++++---
>   3 files changed, 166 insertions(+), 54 deletions(-)

[...]

> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
> index 1f3188b4e313..deab37838f5b 100644
> --- a/security/landlock/ruleset.c
> +++ b/security/landlock/ruleset.c

[...]

> @@ -316,21 +368,29 @@ static int inherit_ruleset(struct landlock_ruleset *const parent,
>   			   struct landlock_ruleset *const child)
>   {
>   	struct landlock_rule *walker_rule, *next_rule;
> +	struct rb_root *parent_root;
>   	int err = 0;
> 
>   	might_sleep();
>   	if (!parent)
>   		return 0;
> 
> +	parent_root = get_root(parent, LANDLOCK_KEY_INODE);
> +	if (IS_ERR(parent_root))
> +		return PTR_ERR(parent_root);
> +
>   	/* Locks @child first because we are its only owner. */
>   	mutex_lock(&child->lock);
>   	mutex_lock_nested(&parent->lock, SINGLE_DEPTH_NESTING);
> 
>   	/* Copies the @parent tree. */
>   	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule,
> -					     &parent->root, node) {
> -		err = insert_rule(child, walker_rule->object,
> -				  &walker_rule->layers,
> +					     parent_root, node) {
> +		const struct landlock_id id = {
> +			.key = walker_rule->key,
> +			.type = LANDLOCK_KEY_INODE,
> +		};

Please add a line break here instead of in a the following refactoring 
commit.


> +		err = insert_rule(child, id, &walker_rule->layers,
>   				  walker_rule->num_layers);
>   		if (err)
>   			goto out_unlock;
