Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29278EB64DD
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Aug 2023 14:14:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236114AbjHCOOV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Aug 2023 10:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233919AbjHCOOF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Aug 2023 10:14:05 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E57610D4;
        Thu,  3 Aug 2023 07:13:37 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RGrMm57tcz6J76K;
        Thu,  3 Aug 2023 22:10:12 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 15:13:34 +0100
Message-ID: <5fe69a93-926b-a682-ed38-0d06345f55e6@huawei.com>
Date:   Thu, 3 Aug 2023 17:13:33 +0300
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
 <20230803.EiD9Ea1Iel0f@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <20230803.EiD9Ea1Iel0f@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml100002.china.huawei.com (7.191.160.241) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



8/3/2023 5:12 PM, Mickaël Salaün пишет:
> On Tue, May 16, 2023 at 12:13:35AM +0800, Konstantin Meskhidze wrote:
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
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
> 
> [...]
> 
>> diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
>> index 8a54e87dbb17..5cb0a1bc6ec0 100644
>> --- a/security/landlock/syscalls.c
>> +++ b/security/landlock/syscalls.c
> 
> [...]
> 
>> +static int add_rule_net_service(struct landlock_ruleset *ruleset,
>> +				const void __user *const rule_attr)
>> +{
>> +#if IS_ENABLED(CONFIG_INET)
> 
> We should define two add_rule_net_service() functions according to
> IS_ENABLED(CONFIG_INET) instead of changing the body of the only
> function.  The second function would only return -EAFNOSUPPORT.  This
> cosmetic change would make the code cleaner.

   Ok. Got it.
> 
> 
>> +	struct landlock_net_service_attr net_service_attr;
>> +	int res;
>> +	access_mask_t mask;
>> +
>> +	/* Copies raw user space buffer, only one type for now. */
>> +	res = copy_from_user(&net_service_attr, rule_attr,
>> +			     sizeof(net_service_attr));
>> +	if (res)
>> +		return -EFAULT;
>> +
>> +	/*
>> +	 * Informs about useless rule: empty allowed_access (i.e. deny rules)
>> +	 * are ignored by network actions.
>> +	 */
>> +	if (!net_service_attr.allowed_access)
>> +		return -ENOMSG;
>> +
>> +	/*
>> +	 * Checks that allowed_access matches the @ruleset constraints
>> +	 * (ruleset->access_masks[0] is automatically upgraded to 64-bits).
>> +	 */
>> +	mask = landlock_get_net_access_mask(ruleset, 0);
>> +	if ((net_service_attr.allowed_access | mask) != mask)
>> +		return -EINVAL;
>> +
>> +	/* Denies inserting a rule with port 0 or higher than 65535. */
>> +	if ((net_service_attr.port == 0) || (net_service_attr.port > U16_MAX))
>> +		return -EINVAL;
>> +
>> +	/* Imports the new rule. */
>> +	return landlock_append_net_rule(ruleset, net_service_attr.port,
>> +					net_service_attr.allowed_access);
>> +#else /* IS_ENABLED(CONFIG_INET) */
>> +	return -EAFNOSUPPORT;
>> +#endif /* IS_ENABLED(CONFIG_INET) */
>> +}
> .
