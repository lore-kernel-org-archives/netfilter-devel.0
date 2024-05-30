Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B4717D371;
	Thu, 30 May 2024 12:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717070774; cv=none; b=i1F7gx9ql7PljpyQDqHkus4RZGP8aroFo07iGn/ltaWT+/VXTD03GRVGtKCLg1vAyLCCx43sE8hD0dBbeeYjGEKKbGMfGy6zVuCK5gKvnILBAtFAyRA8FOFDC8u6WzH9O/k7ca9megLoVI7f5boOS3o1htM+c2XwqKEex6BoKYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717070774; c=relaxed/simple;
	bh=5k24p30emoxdvdBuv+/tgNvIrHeFOzpRj1dfnHUDaYY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=IW0V0huIu2Wtv7oBkGi/i2rUELCCOS8TQh264+V+MHb5sCUqIRxweu3TjLscnVTAKz24aHj1Ibhf9tscVL/siQvv02WN+ck0CFqqetJrdzT9ywUR4HhyPXu/O4auAAmtsJDK2ErO8qZ3onlkH/LsH2TpxWdK/qAy1eHoGWvFe7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VqlHF3WW6zwQfB;
	Thu, 30 May 2024 20:02:17 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 52DA0140382;
	Thu, 30 May 2024 20:06:06 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 30 May 2024 20:06:01 +0800
Message-ID: <ff5ce842-7c67-d658-95b6-ba356dfcfeaf@huawei-partners.com>
Date: Thu, 30 May 2024 15:05:56 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 01/12] landlock: Support socket access-control
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20240524093015.2402952-1-ivanov.mikhail1@huawei-partners.com>
 <20240524093015.2402952-2-ivanov.mikhail1@huawei-partners.com>
 <ZlRY-W_30Kxd4RJd@google.com>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZlRY-W_30Kxd4RJd@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100006.china.huawei.com (7.191.160.224) To
 dggpemm500020.china.huawei.com (7.185.36.49)



5/27/2024 12:57 PM, Günther Noack wrote:
> On Fri, May 24, 2024 at 05:30:04PM +0800, Mikhail Ivanov wrote:
>> * Add new landlock rule type that corresponds to the restriction of
>>    socket protocols. This is represented as an landlock_socket_attr
>>    structure. Protocol allowed by landlock must be described by
>>    a family-type pair (see socket(2)).
>>
>> * Support socket rule storage in landlock ruleset.
>>
>> * Add flag LANDLOCK_ACCESS_SOCKET_CREATE that will provide the
>>    ability to control socket creation.
>>
>> * Add socket.c file that will contain socket rules management and hooks.
>>    Implement helper pack_socket_key() to convert 32-bit family and type
>>    values into uintptr_t. This is possible due to the fact that these
>>    values are limited to AF_MAX (=46), SOCK_MAX (=11) constants. Assumption
>>    is checked in build-time by the helper.
>>
>> * Support socket rules in landlock syscalls. Change ABI version to 6.
>>
>> Closes: https://github.com/landlock-lsm/linux/issues/6
>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>> ---
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
>>   include/uapi/linux/landlock.h                | 53 +++++++++++++++-
>>   security/landlock/Makefile                   |  2 +-
>>   security/landlock/limits.h                   |  5 ++
>>   security/landlock/ruleset.c                  | 37 ++++++++++-
>>   security/landlock/ruleset.h                  | 41 +++++++++++-
>>   security/landlock/socket.c                   | 60 ++++++++++++++++++
>>   security/landlock/socket.h                   | 17 +++++
>>   security/landlock/syscalls.c                 | 66 ++++++++++++++++++--
>>   tools/testing/selftests/landlock/base_test.c |  2 +-
>>   9 files changed, 272 insertions(+), 11 deletions(-)
>>   create mode 100644 security/landlock/socket.c
>>   create mode 100644 security/landlock/socket.h
>>
>> diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
>> index 68625e728f43..a25ba5983dfb 100644
>> --- a/include/uapi/linux/landlock.h
>> +++ b/include/uapi/linux/landlock.h
>> @@ -37,6 +37,13 @@ struct landlock_ruleset_attr {
>>   	 * rule explicitly allow them.
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
>> @@ -65,6 +72,11 @@ enum landlock_rule_type {
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
>> @@ -115,6 +127,28 @@ struct landlock_net_port_attr {
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
>> +	 */
>> +	int family;
>> +	/**
>> +	 * @type: Socket type (see socket(2)).
>> +	 */
>> +	int type;
>> +};
> 
> Regarding the naming of struct landlock_socket_attr and the associated
> LANDLOCK_RULE_SOCKET enum:
> 
> For the two existing rule types LANDLOCK_RULE_PATH_BENEATH (struct
> landlock_path_beneath_attr) and LANDLOCK_RULE_NET_PORT (struct
> landlock_net_port_attr), the names of the rule types are describing the
> *properties* by which we are filtering (path *beneath*, *network port*), rather
> than just the kind of object that we are filtering on.
> 
> Should the new enum and struct maybe be called differently as well to match that
> convention?  Maybe LANDLOCK_RULE_SOCKET_FAMILY_TYPE and struct
> landlock_socket_family_type_attr?
> 
> Are there *other* properties apart from family and type, by which you are
> thinking of restricting the use of sockets in the future?

There was a thought about adding `protocol` (socket(2)) restriction,
but Mickaël noted that it would be useless [1]. Therefore, no other
properties are planned until someone has good use cases.

I agree that current naming can be associated with socket objects. But i
don't think using family-type words for naming of this rule would be
convenient for users. In comparison with net port and path beneath
family-type pair doesn't represent a single semantic unit, so it would
be a little harder to read the code.

Perhaps LANDLOCK_RULE_SOCKET_PROTO (struct landlock_socket_proto_attr)
would be more suitable here? Although socket(2) has `protocol` argument
to specify the socket protocol in some cases (e.g. RAW sockets), in most
cases family-type pair defines protocol itself. Since the purpose of
this patchlist is to restrict protocols used in a sandboxed process, I
think that in the presence of well-written documentation, such naming
may be appropriate here. WDYT?

[1] 
https://lore.kernel.org/all/a6318388-e28a-e96f-b1ae-51948c13de4d@digikod.net/

> 
> 
>> @@ -266,4 +300,21 @@ struct landlock_net_port_attr {
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
>> + * These flags enable to restrict a sanboxed process to a set of socket
>> + * protocols. This is supported since the Landlock ABI version 6.
> 
> (Some phrasing remarks)
> 
>    * typo in "sanboxed"
>    * Optional grammar nit: you can drop the "the" in front of "Landlock ABI
>      version 6" (or alternatively use the phrasing as it was used in the FS
>      restriction docs)
>    * Grammar nit: The use of "enable to" sounds weird in my ears (but I am not a
>      native speaker either).  I think it could just be dropped here ("These flags
>      restrict a sandboxed process..." or "These flags control the use of...").
>      I realize that the wording was used in other places already, so it's just an
>      optional remark.

Thanks! I'll fix this according to your advices.

> 
> (More about the content)
> 
> The Landlock documentation states the general approach up front:
> 
>    A Landlock rule describes an *action* on an *object* which the process intends
>    to perform.
> 
> (In your case, the object is a socket, and the action is the socket's creation.
> The Landlock rules describe predicates on objects to restrict the set of actions
> through the access_mask_t.)
> 
> The implementation is perfectly in line with that, but it would help to phrase
> the documentation also in terms of that framework.  That means, what we are
> restricting are *actions*, not protocols.
> 
> To make a more constructive suggestion:
> 
>    "These flags restrict actions on sockets for a sandboxed process (e.g. socket
>    creation)."

I think this has too general meaning (e.g. bind(2) is also an action on
socket). Probably this one would be more suitable:

   "These flags restrict actions of adding sockets in a sandboxed
   process (e.g. socket creation, passing socket FDs to/from the
   process)."

> 
> Does it also need the following addition?
> 
>    "Sockets opened before sandboxing are not subject to these restrictions."

Yeah, it makes sense. I think it would be great to somehow make this
note common to all types of rules though.

> 
> 
>> + *
>> + * The following access rights apply only to sockets:
>                      ^^^^^^^^^^^^^^^^^^^
> Probably better to use singular for now: "access right applies".

agreed, thanks

> 
>> + *
>> + * - %LANDLOCK_ACCESS_SOCKET_CREATE: Create a socket.
> 
> Can we be more specific here what operations are affected by this?  It is rather
> obvious that this affects socket(2), but does this also affect accept(2) and
> connect(2)?
> 
> A scenario that I could imagine being useful is to sandbox a TCP server like
> this:
> 
>    * create a socket, bind(2) and listen(2)
>    * sandbox yourself so that no new sockets can be created with socket(2)
>    * go into the main loop and start accept(2)ing new connections
> 
> Is this an approach that would work with this patch set?

Yes, such scenario is possible. This rule should apply to all socket
creation requests in the user space (socket(2), socketpair(2), io_uring
request). Perhaps it's necessary to clarify here that only user space
sockets are restricted?

Btw, current implementation doesn't check that the socket creation
request doesn't come from the kernel space. Will be fixed.

> 
> (It might make a neat sample tool as well, if something like this works :))
> 
> 
> Regarding the list of socket access rights with only one item in it:
> 
> I am still unsure what other socket actions are in scope in the future; it would
> probably help to phrase the documentation in those terms.  (listen(2), bind(2),
> connect(2), shutdown(2)?  On the other hand, bind(2) and connect(2) for TCP are
> already restrictable differently.))

I think it would be useful to restrict sending and receiving socket
FDs via unix domain sockets (see SCM_RIGHTS in unix(7)).

> 
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
>> index 20fdb5ff3514..448b4d596783 100644
>> --- a/security/landlock/limits.h
>> +++ b/security/landlock/limits.h
>> @@ -28,6 +28,11 @@
>>   #define LANDLOCK_NUM_ACCESS_NET		__const_hweight64(LANDLOCK_MASK_ACCESS_NET)
>>   #define LANDLOCK_SHIFT_ACCESS_NET	LANDLOCK_NUM_ACCESS_FS
>>   
>> +#define LANDLOCK_LAST_ACCESS_SOCKET	    LANDLOCK_ACCESS_SOCKET_CREATE
>> +#define LANDLOCK_MASK_ACCESS_SOCKET	    ((LANDLOCK_LAST_ACCESS_SOCKET << 1) - 1)
>> +#define LANDLOCK_NUM_ACCESS_SOCKET		__const_hweight64(LANDLOCK_MASK_ACCESS_SOCKET)
>> +#define LANDLOCK_SHIFT_ACCESS_SOCKET	LANDLOCK_NUM_ACCESS_SOCKET
>> +
>>   /* clang-format on */
>>   
>>   #endif /* _SECURITY_LANDLOCK_LIMITS_H */
>> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
>> index e0a5fbf9201a..c782f7cd313d 100644
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
>> @@ -175,7 +186,9 @@ static void build_check_ruleset(void)
>>   	BUILD_BUG_ON(ruleset.num_layers < LANDLOCK_MAX_NUM_LAYERS);
>>   	BUILD_BUG_ON(access_masks <
>>   		     ((LANDLOCK_MASK_ACCESS_FS << LANDLOCK_SHIFT_ACCESS_FS) |
>> -		      (LANDLOCK_MASK_ACCESS_NET << LANDLOCK_SHIFT_ACCESS_NET)));
>> +		      (LANDLOCK_MASK_ACCESS_NET << LANDLOCK_SHIFT_ACCESS_NET) |
>> +		      (LANDLOCK_MASK_ACCESS_SOCKET
>> +		       << LANDLOCK_SHIFT_ACCESS_SOCKET)));
>>   }
>>   
>>   /**
>> @@ -399,6 +412,11 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
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
>> @@ -462,6 +480,11 @@ static int inherit_ruleset(struct landlock_ruleset *const parent,
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
>> @@ -498,6 +521,10 @@ static void free_ruleset(struct landlock_ruleset *const ruleset)
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
>> @@ -708,6 +735,10 @@ landlock_init_layer_masks(const struct landlock_ruleset *const domain,
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
>> index c7f1526784fd..a9773efd529b 100644
>> --- a/security/landlock/ruleset.h
>> +++ b/security/landlock/ruleset.h
>> @@ -92,6 +92,12 @@ enum landlock_key_type {
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
>> @@ -177,6 +183,15 @@ struct landlock_ruleset {
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
>> @@ -233,7 +248,8 @@ struct landlock_ruleset {
>>   
>>   struct landlock_ruleset *
>>   landlock_create_ruleset(const access_mask_t access_mask_fs,
>> -			const access_mask_t access_mask_net);
>> +			const access_mask_t access_mask_net,
>> +			const access_mask_t access_mask_socket);
>>   
>>   void landlock_put_ruleset(struct landlock_ruleset *const ruleset);
>>   void landlock_put_ruleset_deferred(struct landlock_ruleset *const ruleset);
>> @@ -282,6 +298,20 @@ landlock_add_net_access_mask(struct landlock_ruleset *const ruleset,
>>   		(net_mask << LANDLOCK_SHIFT_ACCESS_NET);
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
>> +	ruleset->access_masks[layer_level] |=
>> +		(socket_mask << LANDLOCK_SHIFT_ACCESS_SOCKET);
>> +}
>> +
>>   static inline access_mask_t
>>   landlock_get_raw_fs_access_mask(const struct landlock_ruleset *const ruleset,
>>   				const u16 layer_level)
>> @@ -309,6 +339,15 @@ landlock_get_net_access_mask(const struct landlock_ruleset *const ruleset,
>>   	       LANDLOCK_MASK_ACCESS_NET;
>>   }
>>   
>> +static inline access_mask_t
>> +landlock_get_socket_access_mask(const struct landlock_ruleset *const ruleset,
>> +				const u16 layer_level)
>> +{
>> +	return (ruleset->access_masks[layer_level] >>
>> +		LANDLOCK_SHIFT_ACCESS_SOCKET) &
>> +	       LANDLOCK_MASK_ACCESS_SOCKET;
>> +}
>> +
>>   bool landlock_unmask_layers(const struct landlock_rule *const rule,
>>   			    const access_mask_t access_request,
>>   			    layer_mask_t (*const layer_masks)[],
>> diff --git a/security/landlock/socket.c b/security/landlock/socket.c
>> new file mode 100644
>> index 000000000000..1249a4a36503
>> --- /dev/null
>> +++ b/security/landlock/socket.c
>> @@ -0,0 +1,60 @@
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
>> +		uintptr_t packed;
>> +	} socket_key;
>> +
>> +	/* Checks that all supported socket families and types can be stored in socket_key. */
>> +	BUILD_BUG_ON(AF_MAX > (typeof(socket_key.data.family))~0);
>> +	BUILD_BUG_ON(SOCK_MAX > (typeof(socket_key.data.type))~0);
> 
> Off-by-one nit: AF_MAX and SOCK_MAX are one higher than the last permitted value,
> so technically it would be ok if they are one higher than (unsigned short)~0.
> 
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
> 
> Can socket_key.packed end up containing uninitialized memory here?


Indeed, there is UB here. socket_key.packed type should be changed to
unsigned int. Thank you!

> 
>> +}
> 
> I see that this function traces back to Mickaël's comment in
> https://lore.kernel.org/all/20240412.phoh7laim7Th@digikod.net/
> 
> In my understanding, the motivation was to keep the key size in check.
> But that does not mean that we need to turn it into a uintptr_t?
> 
> Would it not have been possible to extend the union landlock_key in ruleset.h
> with a
> 
>    struct {
>      unsigned short family, type;
>    }
> 
> and then do the AF_MAX, SOCK_MAX build-time checks on that?
> It seems like that might be more in line with what we already have?

I don't think that complicating general entity with such a specific
representation would be a good solution here. `landlock_key` shouldn't
contain any semantic information about the key content.

> 
>> +
>> +int landlock_append_socket_rule(struct landlock_ruleset *const ruleset,
>> +				const int family, const int type,
>> +				access_mask_t access_rights)
>> +{
>> +	int err;
>> +
>> +	const struct landlock_id id = {
>> +		.key.data = pack_socket_key(family, type),
>> +		.type = LANDLOCK_KEY_SOCKET,
>> +	};
>> +
>> +	/* Transforms relative access rights to absolute ones. */
>> +	access_rights |= LANDLOCK_MASK_ACCESS_SOCKET &
>> +			 ~landlock_get_socket_access_mask(ruleset, 0);
>> +
>> +	mutex_lock(&ruleset->lock);
>> +	err = landlock_insert_rule(ruleset, id, access_rights);
>> +	mutex_unlock(&ruleset->lock);
>> +
>> +	return err;
>> +}
>> diff --git a/security/landlock/socket.h b/security/landlock/socket.h
>> new file mode 100644
>> index 000000000000..8519357f1c39
>> --- /dev/null
>> +++ b/security/landlock/socket.h
>> @@ -0,0 +1,17 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Landlock LSM - Socket management and hooks
>> + *
>> + * Copyright © 2024 Huawei Tech. Co., Ltd.
>> + */
>> +
>> +#ifndef _SECURITY_LANDLOCK_SOCKET_H
>> +#define _SECURITY_LANDLOCK_SOCKET_H
>> +
>> +#include "ruleset.h"
>> +
>> +int landlock_append_socket_rule(struct landlock_ruleset *const ruleset,
>> +				const int family, const int type,
>> +				access_mask_t access_rights);
>> +
>> +#endif /* _SECURITY_LANDLOCK_SOCKET_H */
>> diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
>> index 03b470f5a85a..30c771f5e74f 100644
>> --- a/security/landlock/syscalls.c
>> +++ b/security/landlock/syscalls.c
>> @@ -24,12 +24,14 @@
>>   #include <linux/syscalls.h>
>>   #include <linux/types.h>
>>   #include <linux/uaccess.h>
>> +#include <linux/net.h>
>>   #include <uapi/linux/landlock.h>
>>   
>>   #include "cred.h"
>>   #include "fs.h"
>>   #include "limits.h"
>>   #include "net.h"
>> +#include "socket.h"
>>   #include "ruleset.h"
>>   #include "setup.h"
>>   
>> @@ -88,7 +90,8 @@ static void build_check_abi(void)
>>   	struct landlock_ruleset_attr ruleset_attr;
>>   	struct landlock_path_beneath_attr path_beneath_attr;
>>   	struct landlock_net_port_attr net_port_attr;
>> -	size_t ruleset_size, path_beneath_size, net_port_size;
>> +	struct landlock_socket_attr socket_attr;
>> +	size_t ruleset_size, path_beneath_size, net_port_size, socket_size;
>>   
>>   	/*
>>   	 * For each user space ABI structures, first checks that there is no
>> @@ -97,8 +100,9 @@ static void build_check_abi(void)
>>   	 */
>>   	ruleset_size = sizeof(ruleset_attr.handled_access_fs);
>>   	ruleset_size += sizeof(ruleset_attr.handled_access_net);
>> +	ruleset_size += sizeof(ruleset_attr.handled_access_socket);
>>   	BUILD_BUG_ON(sizeof(ruleset_attr) != ruleset_size);
>> -	BUILD_BUG_ON(sizeof(ruleset_attr) != 16);
>> +	BUILD_BUG_ON(sizeof(ruleset_attr) != 24);
>>   
>>   	path_beneath_size = sizeof(path_beneath_attr.allowed_access);
>>   	path_beneath_size += sizeof(path_beneath_attr.parent_fd);
>> @@ -109,6 +113,12 @@ static void build_check_abi(void)
>>   	net_port_size += sizeof(net_port_attr.port);
>>   	BUILD_BUG_ON(sizeof(net_port_attr) != net_port_size);
>>   	BUILD_BUG_ON(sizeof(net_port_attr) != 16);
>> +
>> +	socket_size = sizeof(socket_attr.allowed_access);
>> +	socket_size += sizeof(socket_attr.family);
>> +	socket_size += sizeof(socket_attr.type);
>> +	BUILD_BUG_ON(sizeof(socket_attr) != socket_size);
>> +	BUILD_BUG_ON(sizeof(socket_attr) != 16);
>>   }
>>   
>>   /* Ruleset handling */
>> @@ -149,7 +159,7 @@ static const struct file_operations ruleset_fops = {
>>   	.write = fop_dummy_write,
>>   };
>>   
>> -#define LANDLOCK_ABI_VERSION 5
>> +#define LANDLOCK_ABI_VERSION 6
>>   
>>   /**
>>    * sys_landlock_create_ruleset - Create a new ruleset
>> @@ -213,9 +223,15 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
>>   	    LANDLOCK_MASK_ACCESS_NET)
>>   		return -EINVAL;
>>   
>> +	/* Checks socket content (and 32-bits cast). */
>> +	if ((ruleset_attr.handled_access_socket |
>> +	     LANDLOCK_MASK_ACCESS_SOCKET) != LANDLOCK_MASK_ACCESS_SOCKET)
>> +		return -EINVAL;
>> +
>>   	/* Checks arguments and transforms to kernel struct. */
>>   	ruleset = landlock_create_ruleset(ruleset_attr.handled_access_fs,
>> -					  ruleset_attr.handled_access_net);
>> +					  ruleset_attr.handled_access_net,
>> +					  ruleset_attr.handled_access_socket);
>>   	if (IS_ERR(ruleset))
>>   		return PTR_ERR(ruleset);
>>   
>> @@ -371,6 +387,45 @@ static int add_rule_net_port(struct landlock_ruleset *ruleset,
>>   					net_port_attr.allowed_access);
>>   }
>>   
>> +static int add_rule_socket(struct landlock_ruleset *ruleset,
>> +			   const void __user *const rule_attr)
>> +{
>> +	struct landlock_socket_attr socket_attr;
>> +	int family, type;
>> +	int res;
>> +	access_mask_t mask;
>> +
>> +	/* Copies raw user space buffer. */
>> +	res = copy_from_user(&socket_attr, rule_attr, sizeof(socket_attr));
>> +	if (res)
>> +		return -EFAULT;
>> +
>> +	/*
>> +	 * Informs about useless rule: empty allowed_access (i.e. deny rules)
>> +	 * are ignored by socket actions.
>> +	 */
>> +	if (!socket_attr.allowed_access)
>> +		return -ENOMSG;
>> +
>> +	/* Checks that allowed_access matches the @ruleset constraints. */
>> +	mask = landlock_get_socket_access_mask(ruleset, 0);
>> +	if ((socket_attr.allowed_access | mask) != mask)
>> +		return -EINVAL;
>> +
>> +	family = socket_attr.family;
>> +	type = socket_attr.type;
>> +
>> +	/* Denies inserting a rule with unsupported socket family and type. */
>> +	if (family < 0 || family >= AF_MAX)
>> +		return -EINVAL;
>> +	if (type < 0 || type >= SOCK_MAX)
>> +		return -EINVAL;
> 
> enum sock_type (include/linux/net.h) has "holes": values 7, 8 and 9 are not
> defined in the header.  Should we check more specifically for the supported
> values here?  (Is there already a helper function for that?)

I think that a more detailed check of the family-type values may have a
good effect here, since the rules will contain real codes of families
and types.

I haven't found any helper to check the supported socket type value.
Performing a check inside landlock can lead to several minor problems,
which theoretically should not lead to any costs.

* There are would be a dependency with constants of enum sock_types. But
   we are unlikely to see new types of sockets in the next few years, so
   it wouldn't be a problem to maintain such check.

* enum sock_types can be redefined (see ARCH_HAS_SOCKET_TYPES in net.h),
   but i haven't found anyone to actually change the constants of socket
   types. It would be wrong to have a different landlock behavior for
   arch that redefines sock_types for some purposes, so probably this
   should also be maintained.

WDYT?

> 
> 
>> +	/* Imports the new rule. */
>> +	return landlock_append_socket_rule(ruleset, family, type,
>> +					   socket_attr.allowed_access);
>> +}
>> +
>>   /**
>>    * sys_landlock_add_rule - Add a new rule to a ruleset
>>    *
>> @@ -429,6 +484,9 @@ SYSCALL_DEFINE4(landlock_add_rule, const int, ruleset_fd,
>>   	case LANDLOCK_RULE_NET_PORT:
>>   		err = add_rule_net_port(ruleset, rule_attr);
>>   		break;
>> +	case LANDLOCK_RULE_SOCKET:
>> +		err = add_rule_socket(ruleset, rule_attr);
>> +		break;
>>   	default:
>>   		err = -EINVAL;
>>   		break;
>> diff --git a/tools/testing/selftests/landlock/base_test.c b/tools/testing/selftests/landlock/base_test.c
>> index 3c1e9f35b531..52b00472a487 100644
>> --- a/tools/testing/selftests/landlock/base_test.c
>> +++ b/tools/testing/selftests/landlock/base_test.c
>> @@ -75,7 +75,7 @@ TEST(abi_version)
>>   	const struct landlock_ruleset_attr ruleset_attr = {
>>   		.handled_access_fs = LANDLOCK_ACCESS_FS_READ_FILE,
>>   	};
>> -	ASSERT_EQ(5, landlock_create_ruleset(NULL, 0,
>> +	ASSERT_EQ(6, landlock_create_ruleset(NULL, 0,
>>   					     LANDLOCK_CREATE_RULESET_VERSION));
>>   
>>   	ASSERT_EQ(-1, landlock_create_ruleset(&ruleset_attr, 0,
>> -- 
>> 2.34.1
>>
> 
> —Günther
