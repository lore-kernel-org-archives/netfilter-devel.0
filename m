Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2D31B251C;
	Mon,  9 Sep 2024 07:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725866612; cv=none; b=NKwSk7YPmwFX2rPC5BB62HWIPEewN98zIiF/bh1M5V8EypL8t3M95kS5VkguiWLusW+wqRLGvekXyEJo85aC63eHcX8zW3LTeadk76mO7M7OW8oY5cYY20pTv6Sz5CONDA9peSLXVEm/M5cgBEvSoz6EyvkXd9kd3selEAu3i64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725866612; c=relaxed/simple;
	bh=WzLWi3SbR4Ni+cozc5+ptQOnDb+ccWlWCQT0QEyLKN4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Ld+Xvh3fbxTQC+mqSqF3JIYRiILuA6GC6FWVc2U8/mGKbd1YghEZdGYjT/T/yrjoPEU95urW+d+N2AOChyCeinNrcU8Wv4TwdszhOKeSD3p/354kkCeCFAvj/gBVvBkF5k1YW3aNxfABlkDS+IyHrrE1HKacRzEL1w5WgoeUeiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4X2JFv5jTzz1j8H1;
	Mon,  9 Sep 2024 15:22:59 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 318041400DC;
	Mon,  9 Sep 2024 15:23:26 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 9 Sep 2024 15:23:22 +0800
Message-ID: <8041141b-4513-f9e4-9cf1-c7b2fc9d51a6@huawei-partners.com>
Date: Mon, 9 Sep 2024 10:23:18 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 01/19] landlock: Support socket access-control
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
 <20240904104824.1844082-2-ivanov.mikhail1@huawei-partners.com>
 <Ztr--_Erq0-8xfYc@google.com>
Content-Language: ru
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <Ztr--_Erq0-8xfYc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100002.china.huawei.com (7.191.160.241) To
 kwepemj200016.china.huawei.com (7.202.194.28)

On 9/6/2024 4:09 PM, Günther Noack wrote:
> Hello!
> 
> Just a few wording nits and a remark on using maybe u8, u16, u32.
> 
> On Wed, Sep 04, 2024 at 06:48:06PM +0800, Mikhail Ivanov wrote:
>> Landlock implements the `LANDLOCK_RULE_NET_PORT` rule type, which provides
>> fine-grained control of actions for a specific protocol. Any action or
>> protocol that is not supported by this rule can not be controlled. As a
>> result, protocols for which fine-grained control is not supported can be
>> used in a sandboxed system and lead to vulnerabilities or unexpected
>> behavior.
>>
>> Controlling the protocols used will allow to use only those that are
>> necessary for the system and/or which have fine-grained Landlock control
>> through others types of rules (e.g. TCP bind/connect control with
>> `LANDLOCK_RULE_NET_PORT`, UNIX bind control with
>> `LANDLOCK_RULE_PATH_BENEATH`). Consider following examples:
>>
>> * Server may want to use only TCP sockets for which there is fine-grained
>>    control of bind(2) and connect(2) actions [1].
>> * System that does not need a network or that may want to disable network
>>    for security reasons (e.g. [2]) can achieve this by restricting the use
>>    of all possible protocols.
>>
>> This patch implements such control by restricting socket creation in a
>> sandboxed process.
>>
>> Add `LANDLOCK_RULE_SOCKET` rule type that restricts actions on sockets.
>> This rule uses values of address family and socket type (Cf. socket(2))
>> to determine sockets that should be restricted. This is represented in a
>> landlock_socket_attr struct:
>>
>>    struct landlock_socket_attr {
>>      __u64 allowed_access;
>>      int family; /* same as domain in socket(2) */
>>      int type; /* see socket(2) */
>>    };
>>
>> Support socket rule storage in landlock ruleset.
>>
>> Add `LANDLOCK_ACCESS_SOCKET_CREATE` access right that corresponds to the
>> creation of user space sockets. In the case of connection-based socket
>> types, this does not restrict the actions that result in creation of
>> sockets used for messaging between already existing endpoints
>> (e.g. accept(2), SCTP_SOCKOPT_PEELOFF). Also, this does not restrict any
>> other socket-related actions such as bind(2) or send(2). All restricted
>> actions are enlisted in the documentation of this access right.
>>
>> As with all other access rights, using `LANDLOCK_ACCESS_SOCKET_CREATE`
>> does not affect the actions on sockets which were created before
>> sandboxing.
>>
>> Add socket.c file that will contain socket rules management and hooks.
>>
>> Implement helper pack_socket_key() to convert 32-bit family and type
>> alues into uintptr_t. This is possible due to the fact that these
>    ^^^^^
>    values

thanks! Will be fixed

> 
>> values are limited to AF_MAX (=46), SOCK_MAX (=11) constants. Assumption
>> is checked in build-time by the helper.
>>
>> Support socket rules in landlock syscalls. Change ABI version to 6.
>>
>> [1] https://lore.kernel.org/all/ZJvy2SViorgc+cZI@google.com/
>> [2] https://cr.yp.to/unix/disablenetwork.html
>>
>> Closes: https://github.com/landlock-lsm/linux/issues/6
>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>> ---
>> Changes since v2:
>> * Refactors access_mask for `LANDLOCK_RULE_SOCKET`.
>> * Changes type of 'socket_key.packed' from 'uintptr_t' to 'unsigned int'
>>    in order to fix UB in pack_socket_key().
>> * Accepts (AF_INET, SOCK_PACKET) as an alias for (AF_PACKET, SOCK_PACKET)
>>    in landlock_append_socket_rule().
>> * Fixes documentation.
>> * Rewrites commit message.
>> * Fixes grammar.
>> * Minor fixes.
>>
>> Changes since v1:
>> * Reverts landlock_key.data type from u64 to uinptr_t.
>> * Adds helper to pack domain and type values into uintptr_t.
>> * Denies inserting socket rule with invalid family and type.
>> * Renames 'domain' to 'family' in landlock_socket_attr.
>> * Updates ABI version to 6 since ioctl patches changed it to 5.
>> * Formats code with clang-format.
>> * Minor fixes.
>> ---
>>   include/uapi/linux/landlock.h                | 61 ++++++++++++++++-
>>   security/landlock/Makefile                   |  2 +-
>>   security/landlock/limits.h                   |  4 ++
>>   security/landlock/ruleset.c                  | 33 +++++++++-
>>   security/landlock/ruleset.h                  | 45 ++++++++++++-
>>   security/landlock/socket.c                   | 69 ++++++++++++++++++++
>>   security/landlock/socket.h                   | 17 +++++
>>   security/landlock/syscalls.c                 | 66 +++++++++++++++++--
>>   tools/testing/selftests/landlock/base_test.c |  2 +-
>>   9 files changed, 287 insertions(+), 12 deletions(-)
>>   create mode 100644 security/landlock/socket.c
>>   create mode 100644 security/landlock/socket.h
>>
>> diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
>> index 2c8dbc74b955..d9da9f2c0640 100644
>> --- a/include/uapi/linux/landlock.h
>> +++ b/include/uapi/linux/landlock.h
>> @@ -44,6 +44,13 @@ struct landlock_ruleset_attr {
>>   	 * flags`_).
>>   	 */
>>   	__u64 handled_access_net;
>> +
>> +	/**
>> +	 * @handled_access_socket: Bitmask of actions (cf. `Socket flags`_)
>> +	 * that is handled by this ruleset and should then be forbidden if no
>> +	 * rule explicitly allow them.
>> +	 */
>> +	__u64 handled_access_socket;
>>   };
>>   
>>   /*
>> @@ -72,6 +79,11 @@ enum landlock_rule_type {
>>   	 * landlock_net_port_attr .
>>   	 */
>>   	LANDLOCK_RULE_NET_PORT,
>> +	/**
>> +	 * @LANDLOCK_RULE_SOCKET: Type of a &struct
>> +	 * landlock_socket_attr .
>> +	 */
>> +	LANDLOCK_RULE_SOCKET,
>>   };
>>   
>>   /**
>> @@ -123,6 +135,32 @@ struct landlock_net_port_attr {
>>   	__u64 port;
>>   };
>>   
>> +/**
>> + * struct landlock_socket_attr - Socket definition
>> + *
>> + * Argument of sys_landlock_add_rule().
>> + */
>> +struct landlock_socket_attr {
>> +	/**
>> +	 * @allowed_access: Bitmask of allowed access for a socket
>> +	 * (cf. `Socket flags`_).
>> +	 */
>> +	__u64 allowed_access;
>> +	/**
>> +	 * @family: Protocol family used for communication
>> +	 * (same as domain in socket(2)).
>> +	 *
>> +	 * This argument is considered valid if it is in the range [0, AF_MAX).
>> +	 */
>> +	int family;
>> +	/**
>> +	 * @type: Socket type (see socket(2)).
>> +	 *
>> +	 * This argument is considered valid if it is in the range [0, SOCK_MAX).
>> +	 */
>> +	int type;
>> +};
>> +
>>   /**
>>    * DOC: fs_access
>>    *
>> @@ -259,7 +297,7 @@ struct landlock_net_port_attr {
>>    * DOC: net_access
>>    *
>>    * Network flags
>> - * ~~~~~~~~~~~~~~~~
>> + * ~~~~~~~~~~~~~
>>    *
>>    * These flags enable to restrict a sandboxed process to a set of network
>>    * actions. This is supported since the Landlock ABI version 4.
>> @@ -274,4 +312,25 @@ struct landlock_net_port_attr {
>>   #define LANDLOCK_ACCESS_NET_BIND_TCP			(1ULL << 0)
>>   #define LANDLOCK_ACCESS_NET_CONNECT_TCP			(1ULL << 1)
>>   /* clang-format on */
>> +
>> +/**
>> + * DOC: socket_access
>> + *
>> + * Socket flags
>> + * ~~~~~~~~~~~~
>> + *
>> + * These flags restrict actions on sockets for a sandboxed process (e.g. socket
>> + * creation). Sockets opened before sandboxing are not subject to these
>> + * restrictions. This is supported since the Landlock ABI version 6.
>> + *
>> + * The following access right apply only to sockets:
>                                   ^^^^^
> 				 applies

Thank you! will be fixed

> 
>> + *
>> + * - %LANDLOCK_ACCESS_SOCKET_CREATE: Create an user space socket. This access
>                                                 ^^
> 					       a

will be fixed

> 
>> + *   right restricts following operations:
>                         ^ ...*the* following operations:

will be fixed

> 
>> + *   * :manpage:`socket(2)`, :manpage:`socketpair(2)`,
>> + *   * ``IORING_OP_SOCKET`` io_uring operation (see :manpage:`io_uring_enter(2)`),
>> + */
>> +/* clang-format off */
>> +#define LANDLOCK_ACCESS_SOCKET_CREATE			(1ULL << 0)
>> +/* clang-format on */
>>   #endif /* _UAPI_LINUX_LANDLOCK_H */
>> diff --git a/security/landlock/Makefile b/security/landlock/Makefile
>> index b4538b7cf7d2..ff1dd98f6a1b 100644
>> --- a/security/landlock/Makefile
>> +++ b/security/landlock/Makefile
>> @@ -1,6 +1,6 @@
>>   obj-$(CONFIG_SECURITY_LANDLOCK) := landlock.o
>>   
>>   landlock-y := setup.o syscalls.o object.o ruleset.o \
>> -	cred.o task.o fs.o
>> +	cred.o task.o fs.o socket.o
>>   
>>   landlock-$(CONFIG_INET) += net.o
>> diff --git a/security/landlock/limits.h b/security/landlock/limits.h
>> index 4eb643077a2a..2c04dca414c7 100644
>> --- a/security/landlock/limits.h
>> +++ b/security/landlock/limits.h
>> @@ -26,6 +26,10 @@
>>   #define LANDLOCK_MASK_ACCESS_NET	((LANDLOCK_LAST_ACCESS_NET << 1) - 1)
>>   #define LANDLOCK_NUM_ACCESS_NET		__const_hweight64(LANDLOCK_MASK_ACCESS_NET)
>>   
>> +#define LANDLOCK_LAST_ACCESS_SOCKET	    LANDLOCK_ACCESS_SOCKET_CREATE
>> +#define LANDLOCK_MASK_ACCESS_SOCKET	    ((LANDLOCK_LAST_ACCESS_SOCKET << 1) - 1)
>> +#define LANDLOCK_NUM_ACCESS_SOCKET		__const_hweight64(LANDLOCK_MASK_ACCESS_SOCKET)
>> +
>>   /* clang-format on */
>>   
>>   #endif /* _SECURITY_LANDLOCK_LIMITS_H */
>> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
>> index 6ff232f58618..9bf5e5e88544 100644
>> --- a/security/landlock/ruleset.c
>> +++ b/security/landlock/ruleset.c
>> @@ -40,6 +40,7 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
>>   #if IS_ENABLED(CONFIG_INET)
>>   	new_ruleset->root_net_port = RB_ROOT;
>>   #endif /* IS_ENABLED(CONFIG_INET) */
>> +	new_ruleset->root_socket = RB_ROOT;
>>   
>>   	new_ruleset->num_layers = num_layers;
>>   	/*
>> @@ -52,12 +53,13 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
>>   
>>   struct landlock_ruleset *
>>   landlock_create_ruleset(const access_mask_t fs_access_mask,
>> -			const access_mask_t net_access_mask)
>> +			const access_mask_t net_access_mask,
>> +			const access_mask_t socket_access_mask)
>>   {
>>   	struct landlock_ruleset *new_ruleset;
>>   
>>   	/* Informs about useless ruleset. */
>> -	if (!fs_access_mask && !net_access_mask)
>> +	if (!fs_access_mask && !net_access_mask && !socket_access_mask)
>>   		return ERR_PTR(-ENOMSG);
>>   	new_ruleset = create_ruleset(1);
>>   	if (IS_ERR(new_ruleset))
>> @@ -66,6 +68,9 @@ landlock_create_ruleset(const access_mask_t fs_access_mask,
>>   		landlock_add_fs_access_mask(new_ruleset, fs_access_mask, 0);
>>   	if (net_access_mask)
>>   		landlock_add_net_access_mask(new_ruleset, net_access_mask, 0);
>> +	if (socket_access_mask)
>> +		landlock_add_socket_access_mask(new_ruleset, socket_access_mask,
>> +						0);
>>   	return new_ruleset;
>>   }
>>   
>> @@ -89,6 +94,9 @@ static bool is_object_pointer(const enum landlock_key_type key_type)
>>   		return false;
>>   #endif /* IS_ENABLED(CONFIG_INET) */
>>   
>> +	case LANDLOCK_KEY_SOCKET:
>> +		return false;
>> +
>>   	default:
>>   		WARN_ON_ONCE(1);
>>   		return false;
>> @@ -146,6 +154,9 @@ static struct rb_root *get_root(struct landlock_ruleset *const ruleset,
>>   		return &ruleset->root_net_port;
>>   #endif /* IS_ENABLED(CONFIG_INET) */
>>   
>> +	case LANDLOCK_KEY_SOCKET:
>> +		return &ruleset->root_socket;
>> +
>>   	default:
>>   		WARN_ON_ONCE(1);
>>   		return ERR_PTR(-EINVAL);
>> @@ -395,6 +406,11 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
>>   		goto out_unlock;
>>   #endif /* IS_ENABLED(CONFIG_INET) */
>>   
>> +	/* Merges the @src socket tree. */
>> +	err = merge_tree(dst, src, LANDLOCK_KEY_SOCKET);
>> +	if (err)
>> +		goto out_unlock;
>> +
>>   out_unlock:
>>   	mutex_unlock(&src->lock);
>>   	mutex_unlock(&dst->lock);
>> @@ -458,6 +474,11 @@ static int inherit_ruleset(struct landlock_ruleset *const parent,
>>   		goto out_unlock;
>>   #endif /* IS_ENABLED(CONFIG_INET) */
>>   
>> +	/* Copies the @parent socket tree. */
>> +	err = inherit_tree(parent, child, LANDLOCK_KEY_SOCKET);
>> +	if (err)
>> +		goto out_unlock;
>> +
>>   	if (WARN_ON_ONCE(child->num_layers <= parent->num_layers)) {
>>   		err = -EINVAL;
>>   		goto out_unlock;
>> @@ -494,6 +515,10 @@ static void free_ruleset(struct landlock_ruleset *const ruleset)
>>   		free_rule(freeme, LANDLOCK_KEY_NET_PORT);
>>   #endif /* IS_ENABLED(CONFIG_INET) */
>>   
>> +	rbtree_postorder_for_each_entry_safe(freeme, next,
>> +					     &ruleset->root_socket, node)
>> +		free_rule(freeme, LANDLOCK_KEY_SOCKET);
>> +
>>   	put_hierarchy(ruleset->hierarchy);
>>   	kfree(ruleset);
>>   }
>> @@ -704,6 +729,10 @@ landlock_init_layer_masks(const struct landlock_ruleset *const domain,
>>   		break;
>>   #endif /* IS_ENABLED(CONFIG_INET) */
>>   
>> +	case LANDLOCK_KEY_SOCKET:
>> +		get_access_mask = landlock_get_socket_access_mask;
>> +		num_access = LANDLOCK_NUM_ACCESS_SOCKET;
>> +		break;
>>   	default:
>>   		WARN_ON_ONCE(1);
>>   		return 0;
>> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
>> index 0f1b5b4c8f6b..5cf7251e11ca 100644
>> --- a/security/landlock/ruleset.h
>> +++ b/security/landlock/ruleset.h
>> @@ -42,6 +42,7 @@ static_assert(sizeof(unsigned long) >= sizeof(access_mask_t));
>>   struct access_masks {
>>   	access_mask_t fs : LANDLOCK_NUM_ACCESS_FS;
>>   	access_mask_t net : LANDLOCK_NUM_ACCESS_NET;
>> +	access_mask_t socket : LANDLOCK_NUM_ACCESS_SOCKET;
>>   };
>>   
>>   typedef u16 layer_mask_t;
>> @@ -92,6 +93,12 @@ enum landlock_key_type {
>>   	 * node keys.
>>   	 */
>>   	LANDLOCK_KEY_NET_PORT,
>> +
>> +	/**
>> +	 * @LANDLOCK_KEY_SOCKET: Type of &landlock_ruleset.root_socket's
>> +	 * node keys.
>> +	 */
>> +	LANDLOCK_KEY_SOCKET,
>>   };
>>   
>>   /**
>> @@ -177,6 +184,15 @@ struct landlock_ruleset {
>>   	struct rb_root root_net_port;
>>   #endif /* IS_ENABLED(CONFIG_INET) */
>>   
>> +	/**
>> +	 * @root_socket: Root of a red-black tree containing &struct
>> +	 * landlock_rule nodes with socket type, described by (family, type)
>> +	 * pair (see socket(2)). Once a ruleset is tied to a
>> +	 * process (i.e. as a domain), this tree is immutable until @usage
>> +	 * reaches zero.
>> +	 */
>> +	struct rb_root root_socket;
>> +
>>   	/**
>>   	 * @hierarchy: Enables hierarchy identification even when a parent
>>   	 * domain vanishes.  This is needed for the ptrace protection.
>> @@ -215,8 +231,10 @@ struct landlock_ruleset {
>>   			 */
>>   			u32 num_layers;
>>   			/**
>> -			 * @access_masks: Contains the subset of filesystem and
>> -			 * network actions that are restricted by a ruleset.
>> +			 * @access_masks: Contains the subset of filesystem,
>> +			 * network and socket actions that are restricted by
>> +			 * a ruleset.
>> +			 *
>>   			 * A domain saves all layers of merged rulesets in a
>>   			 * stack (FAM), starting from the first layer to the
>>   			 * last one.  These layers are used when merging
>> @@ -233,7 +251,8 @@ struct landlock_ruleset {
>>   
>>   struct landlock_ruleset *
>>   landlock_create_ruleset(const access_mask_t access_mask_fs,
>> -			const access_mask_t access_mask_net);
>> +			const access_mask_t access_mask_net,
>> +			const access_mask_t access_mask_socket);
>>   
>>   void landlock_put_ruleset(struct landlock_ruleset *const ruleset);
>>   void landlock_put_ruleset_deferred(struct landlock_ruleset *const ruleset);
>> @@ -280,6 +299,19 @@ landlock_add_net_access_mask(struct landlock_ruleset *const ruleset,
>>   	ruleset->access_masks[layer_level].net |= net_mask;
>>   }
>>   
>> +static inline void
>> +landlock_add_socket_access_mask(struct landlock_ruleset *const ruleset,
>> +				const access_mask_t socket_access_mask,
>> +				const u16 layer_level)
>> +{
>> +	access_mask_t socket_mask = socket_access_mask &
>> +				    LANDLOCK_MASK_ACCESS_SOCKET;
>> +
>> +	/* Should already be checked in sys_landlock_create_ruleset(). */
>> +	WARN_ON_ONCE(socket_access_mask != socket_mask);
>> +	ruleset->access_masks[layer_level].socket |= socket_mask;
>> +}
>> +
>>   static inline access_mask_t
>>   landlock_get_raw_fs_access_mask(const struct landlock_ruleset *const ruleset,
>>   				const u16 layer_level)
>> @@ -303,6 +335,13 @@ landlock_get_net_access_mask(const struct landlock_ruleset *const ruleset,
>>   	return ruleset->access_masks[layer_level].net;
>>   }
>>   
>> +static inline access_mask_t
>> +landlock_get_socket_access_mask(const struct landlock_ruleset *const ruleset,
>> +				const u16 layer_level)
>> +{
>> +	return ruleset->access_masks[layer_level].socket;
>> +}
>> +
>>   bool landlock_unmask_layers(const struct landlock_rule *const rule,
>>   			    const access_mask_t access_request,
>>   			    layer_mask_t (*const layer_masks)[],
>> diff --git a/security/landlock/socket.c b/security/landlock/socket.c
>> new file mode 100644
>> index 000000000000..cad89bb91678
>> --- /dev/null
>> +++ b/security/landlock/socket.c
>> @@ -0,0 +1,69 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Landlock LSM - Socket management and hooks
>> + *
>> + * Copyright © 2024 Huawei Tech. Co., Ltd.
>> + */
>> +
>> +#include <linux/net.h>
>> +#include <linux/socket.h>
>> +#include <linux/stddef.h>
>> +
>> +#include "limits.h"
>> +#include "ruleset.h"
>> +#include "socket.h"
>> +
>> +static uintptr_t pack_socket_key(const int family, const int type)
>> +{
>> +	union {
>> +		struct {
>> +			unsigned short family, type;
>> +		} __packed data;
>> +		unsigned int packed;
>> +	} socket_key;
> 
> Maybe a slightly more obvious way would be to use the u8, u16 and u32 types
> here?  Then it would be more directly visible that we have considered this
> correctly and that not one of the variables has an odd size on an obscure
> platform somewhere.

Agreed, thank you for the suggestion!

> 
>> +
>> +	/*
>> +	 * Checks that all supported socket families and types can be stored
>> +	 * in socket_key.
>> +	 */
>> +	BUILD_BUG_ON(AF_MAX >= (typeof(socket_key.data.family))~0);
>> +	BUILD_BUG_ON(SOCK_MAX >= (typeof(socket_key.data.type))~0);
>> +
>> +	/* Checks that socket_key can be stored in landlock_key. */
>> +	BUILD_BUG_ON(sizeof(socket_key.data) > sizeof(socket_key.packed));
>> +	BUILD_BUG_ON(sizeof(socket_key.packed) >
>> +		     sizeof_field(union landlock_key, data));
>> +
>> +	socket_key.data.family = (unsigned short)family;
>> +	socket_key.data.type = (unsigned short)type;
>> +
>> +	return socket_key.packed;
>> +}
> 
> —Günther
