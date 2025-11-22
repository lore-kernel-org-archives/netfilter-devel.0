Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AAE21255A;
	Sat, 22 Nov 2025 11:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763810000; cv=none; b=aqslYUMFwvtEMOf0Gkg+ubAx0QKqNOKE9OV1+T7Ef6uQUcFEEzJyZnY16jZ3cUd2NFiLIA4tGSZ0JzB35XghDFFErpAiCe68zITTMNjThNYxle1r3Quy4Mciz7uK3qUHsvapXpqa370aXYtzWR6H06wDPlZFjN7VudrNaXNQ7C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763810000; c=relaxed/simple;
	bh=X1Lh+Ps3rG4GjAwf1ZaPk9X56RJCFxYA2C97DiG9Jno=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=TEoUHd7afgoDkzJGwmDda76NI7aqP67dHuZWNu7yjho3t0ZD3Z8Ge/a7r7qRI0lULcxOXcmJR8zi4UXON2axa3ESXK8AXpr7pkiBj6zHqiqRWq/4LVU84jfmD5V3tBh8D9xCTVqhrXJpTPNSuVsxIHSO1xV9D+DCk22GWnIrg3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dD8ZB6zfyzHnH7t;
	Sat, 22 Nov 2025 19:12:34 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id 82F471402F0;
	Sat, 22 Nov 2025 19:13:13 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 22 Nov 2025 14:13:11 +0300
Message-ID: <af464773-b01b-f3a4-474d-0efb2cfae142@huawei-partners.com>
Date: Sat, 22 Nov 2025 14:13:08 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 01/19] landlock: Support socket access-control
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack3000@gmail.com>
CC: <mic@digikod.net>, <gnoack@google.com>, <willemdebruijn.kernel@gmail.com>,
	<matthieu@buffet.re>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20251118134639.3314803-1-ivanov.mikhail1@huawei-partners.com>
 <20251118134639.3314803-2-ivanov.mikhail1@huawei-partners.com>
 <20251122.e645d2f1b8a1@gnoack.org>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20251122.e645d2f1b8a1@gnoack.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 mscpeml500004.china.huawei.com (7.188.26.250)

On 11/22/2025 1:49 PM, Günther Noack wrote:
> Hello!
> 
> On Tue, Nov 18, 2025 at 09:46:21PM +0800, Mikhail Ivanov wrote:
>> It is possible to create sockets of the same protocol with different
>> protocol number values. For example, TCP sockets can be created using one
>> of the following commands:
>>      1. fd = socket(AF_INET, SOCK_STREAM, 0);
>>      2. fd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
>> Whereas IPPROTO_TCP = 6. Protocol number 0 correspond to the default
>> protocol of the given protocol family and can be mapped to another
>> value.
>>
>> Socket rules do not perform such mappings to not increase complexity
>> of rules definition and their maintenance.
> 
> Minor phrasing nit: Maybe we can phrase this constructively, like
> "rules operate on the socket(2) parameters as they are passed by the
> user, before this mapping happens"?

OK, thats sounds good.

> 
> 
>> diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
>> index f030adc462ee..030c96cb5d25 100644
>> --- a/include/uapi/linux/landlock.h
>> +++ b/include/uapi/linux/landlock.h
>> @@ -45,6 +45,11 @@ struct landlock_ruleset_attr {
>>   	 * flags`_).
>>   	 */
>>   	__u64 handled_access_net;
>> +	/**
>> +	 * @handled_access_socket: Bitmask of handled actions performed on sockets
>> +	 * (cf. `Socket flags`).
>> +	 */
>> +	__u64 handled_access_socket;
> 
> This struct can only be extended at the end, for ABI compatibility reasons.
> 
> In the call to landlock_create_ruleset(2), the user passes the __user
> pointer to this struct along with its size (as known to the user at
> compile time).  When we copy this into the kernel, we blank out the
> struct and only copy the prefix of the caller-supplied size.  The
> implementation is in copy_min_struct_from_user() in landlock/syscalls.c.

Indeed... Thanks for pointing on this, I'll move this field in the end
of the structure.

> 
> When you rearrange the order, please also update it in other places
> where these fields are mentioned next to each other, for
> consistency. I'll try to point it out where I see it in the review,
> but I might miss some places.

ok

> 
>>   	/**
>>   	 * @scoped: Bitmask of scopes (cf. `Scope flags`_)
>>   	 * restricting a Landlock domain from accessing outside
>> @@ -140,6 +145,11 @@ enum landlock_rule_type {
>>   	 * landlock_net_port_attr .
>>   	 */
>>   	LANDLOCK_RULE_NET_PORT,
>> +	/**
>> +	 * @LANDLOCK_RULE_SOCKET: Type of a &struct
>> +	 * landlock_socket_attr.
>                                 ^
> 
> Nit: Adjacent documentation has a space before the dot.
> I assume this is needed for kernel doc formatting?

Probably, I'll fix this anyway.

> 
>> +	 */
>> +	LANDLOCK_RULE_SOCKET,
>>   };
>>   
>>   /**
>> @@ -191,6 +201,33 @@ struct landlock_net_port_attr {
>>   	__u64 port;
>>   };
>>   
>> +/**
>> + * struct landlock_socket_attr - Socket protocol definition
>> + *
>> + * Argument of sys_landlock_add_rule().
>> + */
>> +struct landlock_socket_attr {
>> +	/**
>> +	 * @allowed_access: Bitmask of allowed access for a socket protocol
>> +	 * (cf. `Socket flags`_).
>> +	 */
>> +	__u64 allowed_access;
>> +	/**
>> +	 * @family: Protocol family used for communication
>> +	 * (cf. include/linux/socket.h).
>> +	 */
>> +	__s32 family;
>> +	/**
>> +	 * @type: Socket type (cf. include/linux/net.h)
>> +	 */
>> +	__s32 type;
>> +	/**
>> +	 * @protocol: Communication protocol specific to protocol family set in
>> +	 * @family field.
> 
> This is specific to both the @family and the @type, not just the @family.
> 
>>From socket(2):
> 
>    Normally only a single protocol exists to support a particular
>    socket type within a given protocol family.
> 
> For instance, in your commit message above the protocol in the example
> is IPPROTO_TCP, which would imply the type SOCK_STREAM, but not work
> with SOCK_DGRAM.

You're right.

> 
>> +	 */
>> +	__s32 protocol;
>> +} __attribute__((packed));
> 
> Since we are in the UAPI header, please also document the wildcard
> values for @type and @protocol.

I'll add the description, thanks!

> 
> (Remark, should those be exposed as constants?)

I thought it could overcomplicate socket rules definition and Landlock
API. Do you think introducing such constants will be better decision?

> 
> 
>> diff --git a/security/landlock/access.h b/security/landlock/access.h
>> index 7961c6630a2d..03ccd6fbfe83 100644
>> --- a/security/landlock/access.h
>> +++ b/security/landlock/access.h
>> @@ -40,6 +40,8 @@ typedef u16 access_mask_t;
>>   static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_FS);
>>   /* Makes sure all network access rights can be stored. */
>>   static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_NET);
>> +/* Makes sure all socket access rights can be stored. */
>> +static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_SOCKET);
>>   /* Makes sure all scoped rights can be stored. */
>>   static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_SCOPE);
>>   /* Makes sure for_each_set_bit() and for_each_clear_bit() calls are OK. */
>> @@ -49,6 +51,7 @@ static_assert(sizeof(unsigned long) >= sizeof(access_mask_t));
>>   struct access_masks {
>>   	access_mask_t fs : LANDLOCK_NUM_ACCESS_FS;
>>   	access_mask_t net : LANDLOCK_NUM_ACCESS_NET;
>> +	access_mask_t socket : LANDLOCK_NUM_ACCESS_SOCKET;
>>   	access_mask_t scope : LANDLOCK_NUM_SCOPE;
> 
> (Please re-adjust field order for consistency with UAPI)

ok, will be fixed in all such places.

> 
>>   };
> 
>> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
>> index dfcdc19ea268..a34d2dbe3954 100644
>> --- a/security/landlock/ruleset.c
>> +++ b/security/landlock/ruleset.c
>> @@ -55,15 +56,15 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
>>   	return new_ruleset;
>>   }
>>   
>> -struct landlock_ruleset *
>> -landlock_create_ruleset(const access_mask_t fs_access_mask,
>> -			const access_mask_t net_access_mask,
>> -			const access_mask_t scope_mask)
>> +struct landlock_ruleset *landlock_create_ruleset(
>> +	const access_mask_t fs_access_mask, const access_mask_t net_access_mask,
>> +	const access_mask_t socket_access_mask, const access_mask_t scope_mask)
> 
> (Please re-adjust field order for consistency with UAPI)
> 
>>   {
>>   	struct landlock_ruleset *new_ruleset;
>>   
>>   	/* Informs about useless ruleset. */
>> -	if (!fs_access_mask && !net_access_mask && !scope_mask)
>> +	if (!fs_access_mask && !net_access_mask && !socket_access_mask &&
>> +	    !scope_mask)
> 
> (Please re-adjust field order for consistency with UAPI)
> 
>>   		return ERR_PTR(-ENOMSG);
>>   	new_ruleset = create_ruleset(1);
>>   	if (IS_ERR(new_ruleset))
>> @@ -72,6 +73,9 @@ landlock_create_ruleset(const access_mask_t fs_access_mask,
>>   		landlock_add_fs_access_mask(new_ruleset, fs_access_mask, 0);
>>   	if (net_access_mask)
>>   		landlock_add_net_access_mask(new_ruleset, net_access_mask, 0);
>> +	if (socket_access_mask)
>> +		landlock_add_socket_access_mask(new_ruleset, socket_access_mask,
>> +						0);
> 
> (Please re-adjust order of these "if"s for consistency with UAPI)
> 
>>   	if (scope_mask)
>>   		landlock_add_scope_mask(new_ruleset, scope_mask, 0);
>>   	return new_ruleset;
> 
>> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
>> index 1a78cba662b2..a60ede2fc2a5 100644
>> --- a/security/landlock/ruleset.h
>> +++ b/security/landlock/ruleset.h
>> @@ -189,10 +204,9 @@ struct landlock_ruleset {
>>   	};
>>   };
>>   
>> -struct landlock_ruleset *
>> -landlock_create_ruleset(const access_mask_t access_mask_fs,
>> -			const access_mask_t access_mask_net,
>> -			const access_mask_t scope_mask);
>> +struct landlock_ruleset *landlock_create_ruleset(
>> +	const access_mask_t access_mask_fs, const access_mask_t access_mask_net,
>> +	const access_mask_t access_mask_socket, const access_mask_t scope_mask);
> 
> (Please re-adjust field order for consistency with UAPI)
> 
>> index 000000000000..28a80dcad629
>> --- /dev/null
>> +++ b/security/landlock/socket.c
>> @@ -0,0 +1,105 @@
>> [...]
>> +#define TYPE_ALL (-1)
>> +#define PROTOCOL_ALL (-1)
> 
> Should these definitions go into the UAPI header (with a LANDLOCK_ prefix)?

answered above.

> 
> 
>> diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
>> index 33eafb71e4f3..e9f500f97c86 100644
>> --- a/security/landlock/syscalls.c
>> +++ b/security/landlock/syscalls.c
>> @@ -101,9 +104,10 @@ static void build_check_abi(void)
>>   	 */
>>   	ruleset_size = sizeof(ruleset_attr.handled_access_fs);
>>   	ruleset_size += sizeof(ruleset_attr.handled_access_net);
>> +	ruleset_size += sizeof(ruleset_attr.handled_access_socket);
>>   	ruleset_size += sizeof(ruleset_attr.scoped);
> (Please re-adjust field order for consistency with UAPI)
> 
>>   	BUILD_BUG_ON(sizeof(ruleset_attr) != ruleset_size);
>> -	BUILD_BUG_ON(sizeof(ruleset_attr) != 24);
>> +	BUILD_BUG_ON(sizeof(ruleset_attr) != 32);
>> [...]
> 
>> @@ -237,6 +248,11 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
>>   	    LANDLOCK_MASK_ACCESS_NET)
>>   		return -EINVAL;
>>   
>> +	/* Checks socket content (and 32-bits cast). */
>> +	if ((ruleset_attr.handled_access_socket |
>> +	     LANDLOCK_MASK_ACCESS_SOCKET) != LANDLOCK_MASK_ACCESS_SOCKET)
>> +		return -EINVAL;
>> +
>>   	/* Checks IPC scoping content (and 32-bits cast). */
>>   	if ((ruleset_attr.scoped | LANDLOCK_MASK_SCOPE) != LANDLOCK_MASK_SCOPE)
>>   		return -EINVAL;
>> @@ -244,6 +260,7 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
>>   	/* Checks arguments and transforms to kernel struct. */
>>   	ruleset = landlock_create_ruleset(ruleset_attr.handled_access_fs,
>>   					  ruleset_attr.handled_access_net,
>> +					  ruleset_attr.handled_access_socket,
>>   					  ruleset_attr.scoped);
> 
> (Please re-adjust field order for consistency with UAPI)
> 
>>   	if (IS_ERR(ruleset))
>>   		return PTR_ERR(ruleset);
>> [...]
> 
>> @@ -407,6 +458,8 @@ static int add_rule_net_port(struct landlock_ruleset *ruleset,
>>    *   &landlock_net_port_attr.allowed_access is not a subset of the ruleset
>>    *   handled accesses)
>>    * - %EINVAL: &landlock_net_port_attr.port is greater than 65535;
>> + * - %EINVAL: &landlock_socket_attr.{family, type} are greater than 254 or
>> + *   &landlock_socket_attr.protocol is greater than 65534;
> 
> Hmm, this is a bit annoying that these values have such unusual
> bounds, even though the input parameters are 32 bit.  We are exposing
> a little bit that we are internally storing this with only 8 and 16
> bits...  (I don't know a better solution immediately either, though. I
> think we discussed this on a previous version of the patch set as well
> and ended up with permitting larger values than the narrower SOCK_MAX
> etc bounds.)

I agree, one of the possible solutions may be to store larger values in
socket keys (eg. s32), but this would require to make a separate
interface for storing socket rules (in order to not change key size for
other type of rules which is currently 32-64 bit depending on virtual
address size).

> 
>>    * - %ENOMSG: Empty accesses (e.g. &landlock_path_beneath_attr.allowed_access is
>>    *   0);
>>    * - %EBADF: @ruleset_fd is not a file descriptor for the current thread, or a
>> @@ -439,6 +492,8 @@ SYSCALL_DEFINE4(landlock_add_rule, const int, ruleset_fd,
>>   		return add_rule_path_beneath(ruleset, rule_attr);
>>   	case LANDLOCK_RULE_NET_PORT:
>>   		return add_rule_net_port(ruleset, rule_attr);
>> +	case LANDLOCK_RULE_SOCKET:
>> +		return add_rule_socket(ruleset, rule_attr);
>>   	default:
>>   		return -EINVAL;
>>   	}
> 
> –Günther
