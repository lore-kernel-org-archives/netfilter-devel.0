Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A81DEB64DA
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jul 2023 12:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjGJMak (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jul 2023 08:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjGJMaj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jul 2023 08:30:39 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86FD2B1;
        Mon, 10 Jul 2023 05:30:38 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4R03DM28Dbz67cSV;
        Mon, 10 Jul 2023 20:27:31 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 10 Jul 2023 13:30:36 +0100
Message-ID: <d1a8449a-cd55-90d5-8892-769ad6f702c1@huawei.com>
Date:   Mon, 10 Jul 2023 15:30:35 +0300
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
 <ac3c0b76-01a9-b36f-63a2-734250d486b2@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <ac3c0b76-01a9-b36f-63a2-734250d486b2@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



7/6/2023 5:34 PM, Mickaël Salaün пишет:
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
> 
> [...]
> 
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
> 
>> +	}
> 
> 
> Because of enum change [1], could you please put the following block
> inside this commit's switch with a new "default:" case, and add a line
> break after the previous return like this:
> 
> \n
> default:
>> +	WARN_ON_ONCE(1);
>> +	return false;
> 
> break;
> }

   Ok. I will add "default: case.
   Thank you.
> 
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
> 
> Same here, you can remove the "root" variable:
> 
>> +	struct rb_root *root = NULL;
>> +
>> +	switch (key_type) {
>> +	case LANDLOCK_KEY_INODE:
>> +		root = &ruleset->root_inode;
>> +		break;
> 
> return &ruleset->root_inode;
> \n
> default:
>> +	if (WARN_ON_ONCE(!root))
>> +		return ERR_PTR(-EINVAL);
> break;
> }

   Ok. Will be fixed.
> 
>> +}
> 
> Actually, I've pushed this change here:
> https://git.kernel.org/mic/c/8c96c7eee3ff (landlock-net-v11 branch)

  Thank you.
> .
