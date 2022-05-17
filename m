Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FDCBC433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 May 2022 08:17:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243095AbiEQIR1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 May 2022 04:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243014AbiEQIRI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 May 2022 04:17:08 -0400
Received: from smtp-42ad.mail.infomaniak.ch (smtp-42ad.mail.infomaniak.ch [IPv6:2001:1600:3:17::42ad])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF92D4BBA7
        for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2022 01:15:01 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4L2TSN5yKPzMqHGp;
        Tue, 17 May 2022 10:15:00 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4L2TSN2Fx1zlhMCC;
        Tue, 17 May 2022 10:14:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1652775300;
        bh=zE7ryqyjpmw6+Bi35w6pIyVZL+D87Fwi0IjjIhnG3wY=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=CqmlqUw7tK4QiiWtsB61AXITTc7p/CfgPP5mvQOK/8X1crKLdE2s58bA+rxcePXbi
         5dpcdGZyr8uqnMxgCsVV18dFJ4uYlEhal6X6eQmGsanXJQ4OXcXC/VHH95PeiMOgXB
         Huw4KSxwonNbv+LeitiLboZkDhZ1dHVPHSagt6HU=
Message-ID: <72c37309-3535-8119-b701-193ccc75e74e@digikod.net>
Date:   Tue, 17 May 2022 10:14:59 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        anton.sirazetdinov@huawei.com
References: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
 <20220516152038.39594-4-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH v5 03/15] landlock: merge and inherit function refactoring
In-Reply-To: <20220516152038.39594-4-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 16/05/2022 17:20, Konstantin Meskhidze wrote:
> Merge_ruleset() and inherit_ruleset() functions were
> refactored to support new rule types. This patch adds
> tree_merge() and tree_copy() helpers. Each has
> rule_type argument to choose a particular rb_tree
> structure in a ruleset.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v3:
> * Split commit.
> * Refactoring functions:
> 	-insert_rule.
> 	-merge_ruleset.
> 	-tree_merge.
> 	-inherit_ruleset.
> 	-tree_copy.
> 	-free_rule.
> 
> Changes since v4:
> * None
> 
> ---
>   security/landlock/ruleset.c | 144 ++++++++++++++++++++++++------------
>   1 file changed, 98 insertions(+), 46 deletions(-)
> 
> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
> index f079a2a320f1..4b4c9953bb32 100644
> --- a/security/landlock/ruleset.c
> +++ b/security/landlock/ruleset.c
> @@ -112,12 +112,16 @@ static struct landlock_rule *create_rule(
>   	return new_rule;
>   }
> 
> -static void free_rule(struct landlock_rule *const rule)
> +static void free_rule(struct landlock_rule *const rule, const u16 rule_type)
>   {
>   	might_sleep();
>   	if (!rule)
>   		return;
> -	landlock_put_object(rule->object.ptr);
> +	switch (rule_type) {
> +	case LANDLOCK_RULE_PATH_BENEATH:
> +		landlock_put_object(rule->object.ptr);
> +		break;
> +	}
>   	kfree(rule);
>   }
> 
> @@ -227,12 +231,12 @@ static int insert_rule(struct landlock_ruleset *const ruleset,
>   			new_rule = create_rule(object_ptr, 0, &this->layers,
>   					       this->num_layers,
>   					       &(*layers)[0]);
> +			if (IS_ERR(new_rule))
> +				return PTR_ERR(new_rule);
> +			rb_replace_node(&this->node, &new_rule->node, &ruleset->root_inode);
> +			free_rule(this, rule_type);
>   			break;
>   		}
> -		if (IS_ERR(new_rule))
> -			return PTR_ERR(new_rule);
> -		rb_replace_node(&this->node, &new_rule->node, &ruleset->root_inode);
> -		free_rule(this);
>   		return 0;
>   	}
> 
> @@ -243,13 +247,12 @@ static int insert_rule(struct landlock_ruleset *const ruleset,
>   	switch (rule_type) {
>   	case LANDLOCK_RULE_PATH_BENEATH:
>   		new_rule = create_rule(object_ptr, 0, layers, num_layers, NULL);
> +		if (IS_ERR(new_rule))
> +			return PTR_ERR(new_rule);
> +		rb_link_node(&new_rule->node, parent_node, walker_node);
> +		rb_insert_color(&new_rule->node, &ruleset->root_inode);
>   		break;
>   	}
> -	if (IS_ERR(new_rule))
> -		return PTR_ERR(new_rule);
> -	rb_link_node(&new_rule->node, parent_node, walker_node);
> -	rb_insert_color(&new_rule->node, &ruleset->root_inode);
> -	ruleset->num_rules++;

Why removing this last line?
