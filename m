Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32DDBC30654
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Jul 2023 17:07:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbjGCRHB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Jul 2023 13:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjGCRHA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Jul 2023 13:07:00 -0400
Received: from smtp-8fab.mail.infomaniak.ch (smtp-8fab.mail.infomaniak.ch [IPv6:2001:1600:3:17::8fab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38BD5E64
        for <netfilter-devel@vger.kernel.org>; Mon,  3 Jul 2023 10:06:58 -0700 (PDT)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Qvsm032vbzMpp3Z;
        Mon,  3 Jul 2023 17:06:56 +0000 (UTC)
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4Qvslz4jh4z9Qb;
        Mon,  3 Jul 2023 19:06:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1688404016;
        bh=C5vGqflJZDHJVLj0UvIUk41VtDiMQZg9N7uGTIBIz8g=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=B1qdaq5W2hmvMHVseVzBviw13Ap2PClCOSuDA/nhDEmAc4zeHAKRYMN1NpYSLqIQp
         +eXj3r0FuaSlyJREcxMI0NNHWIMMHDy8lWkL/c+VZDXHcAPxk66npB8kgw4wy2X00q
         MD/EKMWjHRT4oLXm4mn8bhQYX2hMOgoVpxtePdxI=
Message-ID: <fa4c8e04-3999-94a9-7691-6df3130eb591@digikod.net>
Date:   Mon, 3 Jul 2023 19:06:55 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v11 08/12] landlock: Add network rules and TCP hooks
 support
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
 <20230515161339.631577-9-konstantin.meskhidze@huawei.com>
 <f14174f3-d855-dba9-5dd2-40a2c5e5ac3b@digikod.net>
 <55092d4f-b076-d4fc-e75f-b4981a382a78@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <55092d4f-b076-d4fc-e75f-b4981a382a78@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 03/07/2023 12:36, Konstantin Meskhidze (A) wrote:
> 
> 
> 6/26/2023 9:57 PM, Mickaël Salaün пишет:
>> Complementary review:
>>
>> On 15/05/2023 18:13, Konstantin Meskhidze wrote:
>>> This commit adds network rules support in the ruleset management
>>> helpers and the landlock_create_ruleset syscall.
>>> Refactor user space API to support network actions. Add new network
>>> access flags, network rule and network attributes. Increment Landlock
>>> ABI version. Expand access_masks_t to u32 to be sure network access
>>> rights can be stored. Implement socket_bind() and socket_connect()
>>> LSM hooks, which enables to restrict TCP socket binding and connection
>>> to specific ports.
>>>
>>> Co-developed-by: Mickaël Salaün <mic@digikod.net>
>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>> ---
>>>
>>> Changes since v10:
>>> * Removes "packed" attribute.
>>> * Applies Mickaёl's patch with some refactoring.
>>> * Deletes get_port() and check_addrlen() helpers.
>>> * Refactors check_socket_access() by squashing get_port() and
>>> check_addrlen() helpers into it.
>>> * Fixes commit message.
>>>
>>> Changes since v9:
>>> * Changes UAPI port field to __u64.
>>> * Moves shared code into check_socket_access().
>>> * Adds get_raw_handled_net_accesses() and
>>> get_current_net_domain() helpers.
>>> * Minor fixes.
>>>
>>> Changes since v8:
>>> * Squashes commits.
>>> * Refactors commit message.
>>> * Changes UAPI port field to __be16.
>>> * Changes logic of bind/connect hooks with AF_UNSPEC families.
>>> * Adds address length checking.
>>> * Minor fixes.
>>>
>>> Changes since v7:
>>> * Squashes commits.
>>> * Increments ABI version to 4.
>>> * Refactors commit message.
>>> * Minor fixes.
>>>
>>> Changes since v6:
>>> * Renames landlock_set_net_access_mask() to landlock_add_net_access_mask()
>>>     because it OR values.
>>> * Makes landlock_add_net_access_mask() more resilient incorrect values.
>>> * Refactors landlock_get_net_access_mask().
>>> * Renames LANDLOCK_MASK_SHIFT_NET to LANDLOCK_SHIFT_ACCESS_NET and use
>>>     LANDLOCK_NUM_ACCESS_FS as value.
>>> * Updates access_masks_t to u32 to support network access actions.
>>> * Refactors landlock internal functions to support network actions with
>>>     landlock_key/key_type/id types.
>>>
>>> Changes since v5:
>>> * Gets rid of partial revert from landlock_add_rule
>>> syscall.
>>> * Formats code with clang-format-14.
>>>
>>> Changes since v4:
>>> * Refactors landlock_create_ruleset() - splits ruleset and
>>> masks checks.
>>> * Refactors landlock_create_ruleset() and landlock mask
>>> setters/getters to support two rule types.
>>> * Refactors landlock_add_rule syscall add_rule_path_beneath
>>> function by factoring out get_ruleset_from_fd() and
>>> landlock_put_ruleset().
>>>
>>> Changes since v3:
>>> * Splits commit.
>>> * Adds network rule support for internal landlock functions.
>>> * Adds set_mask and get_mask for network.
>>> * Adds rb_root root_net_port.
>>>
>>> ---
>>>    include/uapi/linux/landlock.h                |  48 +++++
>>>    security/landlock/Kconfig                    |   1 +
>>>    security/landlock/Makefile                   |   2 +
>>>    security/landlock/limits.h                   |   6 +-
>>>    security/landlock/net.c                      | 174 +++++++++++++++++++
>>>    security/landlock/net.h                      |  26 +++
>>>    security/landlock/ruleset.c                  |  52 +++++-
>>>    security/landlock/ruleset.h                  |  63 +++++--
>>>    security/landlock/setup.c                    |   2 +
>>>    security/landlock/syscalls.c                 |  72 +++++++-
>>>    tools/testing/selftests/landlock/base_test.c |   2 +-
>>>    11 files changed, 425 insertions(+), 23 deletions(-)
>>>    create mode 100644 security/landlock/net.c
>>>    create mode 100644 security/landlock/net.h
>>>
>>> diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
>>> index 81d09ef9aa50..93794759dad4 100644
>>> --- a/include/uapi/linux/landlock.h
>>> +++ b/include/uapi/linux/landlock.h
>>> @@ -31,6 +31,13 @@ struct landlock_ruleset_attr {
>>>    	 * this access right.
>>>    	 */
>>>    	__u64 handled_access_fs;
>>> +
>>
>> Please remove this empty line.
> 
>    Ok. Thanks.
>>
>>
>>> +	/**
>>> +	 * @handled_access_net: Bitmask of actions (cf. `Network flags`_)
>>> +	 * that is handled by this ruleset and should then be forbidden if no
>>> +	 * rule explicitly allow them.
>>> +	 */
>>> +	__u64 handled_access_net;
>>>    };
>>>
>>>    /*
>>> @@ -54,6 +61,11 @@ enum landlock_rule_type {
>>>    	 * landlock_path_beneath_attr .
>>>    	 */
>>>    	LANDLOCK_RULE_PATH_BENEATH = 1,
>>> +	/**
>>> +	 * @LANDLOCK_RULE_NET_SERVICE: Type of a &struct
>>> +	 * landlock_net_service_attr .
>>> +	 */
>>> +	LANDLOCK_RULE_NET_SERVICE = 2,
>>>    };
>>>
>>>    /**
>>> @@ -79,6 +91,23 @@ struct landlock_path_beneath_attr {
>>>    	 */
>>>    } __attribute__((packed));
>>>
>>> +/**
>>> + * struct landlock_net_service_attr - TCP subnet definition
>>
>> s/TCP subnet definition/Network service definition/
>>
>     Ok. Thanks.
>>
>>> + *
>>> + * Argument of sys_landlock_add_rule().
>>> + */
>>> +struct landlock_net_service_attr {
>>> +	/**
>>> +	 * @allowed_access: Bitmask of allowed access network for services
>>> +	 * (cf. `Network flags`_).
>>> +	 */
>>> +	__u64 allowed_access;
>>> +	/**
>>> +	 * @port: Network port.
>>> +	 */
>>> +	__u64 port;
>>> +};
>>> +
>>>    /**
>>>     * DOC: fs_access
>>>     *
>>> @@ -189,4 +218,23 @@ struct landlock_path_beneath_attr {
>>>    #define LANDLOCK_ACCESS_FS_TRUNCATE			(1ULL << 14)
>>>    /* clang-format on */
>>>
>>> +/**
>>> + * DOC: net_access
>>> + *
>>> + * Network flags
>>> + * ~~~~~~~~~~~~~~~~
>>> + *
>>> + * These flags enable to restrict a sandboxed process to a set of network
>>> + * actions.
>>> + *
>>> + * TCP sockets with allowed actions:
>>> + *
>>> + * - %LANDLOCK_ACCESS_NET_BIND_TCP: Bind a TCP socket to a local port.
>>> + * - %LANDLOCK_ACCESS_NET_CONNECT_TCP: Connect an active TCP socket to
>>> + *   a remote port.
>>> + */
>>> +/* clang-format off */
>>> +#define LANDLOCK_ACCESS_NET_BIND_TCP			(1ULL << 0)
>>> +#define LANDLOCK_ACCESS_NET_CONNECT_TCP			(1ULL << 1)
>>> +/* clang-format on */
>>>    #endif /* _UAPI_LINUX_LANDLOCK_H */
>>> diff --git a/security/landlock/Kconfig b/security/landlock/Kconfig
>>> index 8e33c4e8ffb8..10c099097533 100644
>>> --- a/security/landlock/Kconfig
>>> +++ b/security/landlock/Kconfig
>>> @@ -3,6 +3,7 @@
>>>    config SECURITY_LANDLOCK
>>>    	bool "Landlock support"
>>>    	depends on SECURITY && !ARCH_EPHEMERAL_INODES
>>> +	select SECURITY_NETWORK
>>>    	select SECURITY_PATH
>>>    	help
>>>    	  Landlock is a sandboxing mechanism that enables processes to restrict
>>> diff --git a/security/landlock/Makefile b/security/landlock/Makefile
>>> index 7bbd2f413b3e..53d3c92ae22e 100644
>>> --- a/security/landlock/Makefile
>>> +++ b/security/landlock/Makefile
>>> @@ -2,3 +2,5 @@ obj-$(CONFIG_SECURITY_LANDLOCK) := landlock.o
>>>
>>>    landlock-y := setup.o syscalls.o object.o ruleset.o \
>>>    	cred.o ptrace.o fs.o
>>> +
>>> +landlock-$(CONFIG_INET) += net.o
>>> \ No newline at end of file
>>> diff --git a/security/landlock/limits.h b/security/landlock/limits.h
>>> index bafb3b8dc677..8a1a6463c64e 100644
>>> --- a/security/landlock/limits.h
>>> +++ b/security/landlock/limits.h
>>> @@ -23,6 +23,10 @@
>>>    #define LANDLOCK_NUM_ACCESS_FS		__const_hweight64(LANDLOCK_MASK_ACCESS_FS)
>>>    #define LANDLOCK_SHIFT_ACCESS_FS	0
>>>
>>> -/* clang-format on */
>>> +#define LANDLOCK_LAST_ACCESS_NET	LANDLOCK_ACCESS_NET_CONNECT_TCP
>>> +#define LANDLOCK_MASK_ACCESS_NET	((LANDLOCK_LAST_ACCESS_NET << 1) - 1)
>>> +#define LANDLOCK_NUM_ACCESS_NET		__const_hweight64(LANDLOCK_MASK_ACCESS_NET)
>>> +#define LANDLOCK_SHIFT_ACCESS_NET	LANDLOCK_NUM_ACCESS_FS
>>>
>>> +/* clang-format on */
>>
>> Please the empty line to make this patch clean.
> 
>    Ok. I will.
>>
>>
>>>    #endif /* _SECURITY_LANDLOCK_LIMITS_H */
>>> diff --git a/security/landlock/net.c b/security/landlock/net.c
>>> new file mode 100644
>>> index 000000000000..f8d2be53ac0d
>>> --- /dev/null
>>> +++ b/security/landlock/net.c
>>> @@ -0,0 +1,174 @@
>>> +// SPDX-License-Identifier: GPL-2.0-only
>>> +/*
>>> + * Landlock LSM - Network management and hooks
>>> + *
>>> + * Copyright © 2022 Huawei Tech. Co., Ltd.
>>> + * Copyright © 2022 Microsoft Corporation
>>> + */
>>> +
>>> +#include <linux/in.h>
>>> +#include <linux/net.h>
>>> +#include <linux/socket.h>
>>> +#include <net/ipv6.h>
>>> +
>>> +#include "common.h"
>>> +#include "cred.h"
>>> +#include "limits.h"
>>> +#include "net.h"
>>> +#include "ruleset.h"
>>> +
>>> +int landlock_append_net_rule(struct landlock_ruleset *const ruleset,
>>> +			     const u16 port, access_mask_t access_rights)
>>> +{
>>> +	int err;
>>> +	const struct landlock_id id = {
>>> +		.key.data = (__force uintptr_t)htons(port),
>>> +		.type = LANDLOCK_KEY_NET_PORT,
>>> +	};
>>> +
>>> +	BUILD_BUG_ON(sizeof(port) > sizeof(id.key.data));
>>> +
>>> +	/* Transforms relative access rights to absolute ones. */
>>> +	access_rights |= LANDLOCK_MASK_ACCESS_NET &
>>> +			 ~landlock_get_net_access_mask(ruleset, 0);
>>> +
>>> +	mutex_lock(&ruleset->lock);
>>> +	err = landlock_insert_rule(ruleset, id, access_rights);
>>> +	mutex_unlock(&ruleset->lock);
>>> +
>>> +	return err;
>>> +}
>>> +
>>> +static access_mask_t
>>> +get_raw_handled_net_accesses(const struct landlock_ruleset *const domain)
>>> +{
>>> +	access_mask_t access_dom = 0;
>>> +	size_t layer_level;
>>> +
>>> +	for (layer_level = 0; layer_level < domain->num_layers; layer_level++)
>>> +		access_dom |= landlock_get_net_access_mask(domain, layer_level);
>>> +	return access_dom;
>>> +}
>>> +
>>> +static const struct landlock_ruleset *get_current_net_domain(void)
>>> +{
>>> +	const struct landlock_ruleset *const dom =
>>> +		landlock_get_current_domain();
>>> +
>>> +	if (!dom || !get_raw_handled_net_accesses(dom))
>>> +		return NULL;
>>> +
>>> +	return dom;
>>> +}
>>> +
>>> +static int check_socket_access(struct socket *const sock,
>>> +			       struct sockaddr *const address,
>>> +			       const int addrlen,
>>> +			       const access_mask_t access_request)
>>> +{
>>> +	__be16 port;
>>> +	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_NET] = {};
>>> +	const struct landlock_rule *rule;
>>> +	access_mask_t handled_access;
>>> +	struct landlock_id id = {
>>> +		.type = LANDLOCK_KEY_NET_PORT,
>>> +	};
>>> +	const struct landlock_ruleset *const domain = get_current_net_domain();
>>> +
>>> +	if (WARN_ON_ONCE(!domain))
>>
>> The WARN_ON_ONCE() needs to be removed for processes not sandboxed. This
>> should be printed when running the tests.
>>
>    Probably during the boot stage it prints once since no process is
>    landlocked at this stage.
>    So we need to leave it like this:
> 	if (!domain)
>           	return 0;

Yes


>     ????
>>
>>
>>> +		return 0;
>>> +	if (WARN_ON_ONCE(domain->num_layers < 1))
>>> +		return -EACCES;
>>> +
>>> +	/* Checks if it's a TCP socket. */
>>> +	if (sock->type != SOCK_STREAM)
>>> +		return 0;
>>> +
>>> +	/* Checks for minimal header length. */
>>> +	if (addrlen < offsetofend(struct sockaddr, sa_family))
>>
>> You can use "typeof(*address)" instead of struct sockaddr, this makes it
>> easier to review.
>>
>     Do mean to change offsetofend() by typeof(*address)??

No: if (addrlen < offsetofend(typeof(*address), sa_family))

>>
>>> +		return -EINVAL;
>>> +
>>
>> [...]
>> .
