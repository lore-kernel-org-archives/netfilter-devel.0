Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B863225B1D2;
	Sat, 22 Nov 2025 17:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763832014; cv=none; b=jdW54Lf+LFrik6b1JSpLuCLj5dXbIgE8LwQ4/kIMvLKsWthJrfTWkomupGg16x0ZXLeR4o4MGfOCEK1FjgogbYU8wcK8Am61z8tYzndBR1ZCJMxvm9h/cKOwk5MBIGUiSomZueiRr4HfDheE3M9AkSajKvT5MdtYdkX67LnbXs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763832014; c=relaxed/simple;
	bh=sz/pDSTTApR9cxIHGR7p2n+30eVMwOoqzVr4UMvOmMU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=VcK2jWS2y4cqT511RS7ZJRlHRebImywvt3RiFApshsKLz61TQAKt6zbIWY5M1THXITkkb4i8TpT6JQ6RWECmbg4Y+3VdpDRJY5vx6qu6cT0qHEBZpRAaCRjl8eJQRaxq1BknRrndHGf/hxk0XAHwT8qvcKz0jrzWMzLaeuz+IIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dDJjD6BKbzJ468G;
	Sun, 23 Nov 2025 01:19:12 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id DA983140276;
	Sun, 23 Nov 2025 01:20:01 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 22 Nov 2025 20:19:59 +0300
Message-ID: <d97948f7-9933-1044-9137-b424b81ab926@huawei-partners.com>
Date: Sat, 22 Nov 2025 20:19:56 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 06/19] landlock: Add hook on socket creation
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack3000@gmail.com>
CC: <mic@digikod.net>, <gnoack@google.com>, <willemdebruijn.kernel@gmail.com>,
	<matthieu@buffet.re>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20251118134639.3314803-1-ivanov.mikhail1@huawei-partners.com>
 <20251118134639.3314803-7-ivanov.mikhail1@huawei-partners.com>
 <20251122.78c6cd69a873@gnoack.org>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20251122.78c6cd69a873@gnoack.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 mscpeml500004.china.huawei.com (7.188.26.250)

On 11/22/2025 2:41 PM, Günther Noack wrote:
> On Tue, Nov 18, 2025 at 09:46:26PM +0800, Mikhail Ivanov wrote:
>> Add hook on security_socket_create(), which checks whether the socket
>> of requested protocol is allowed by domain.
>>
>> Due to support of masked protocols Landlock tries to find one of the
>> 4 rules that can allow creation of requested protocol.
>>
>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>> ---
>> Changes since v3:
>> * Changes LSM hook from socket_post_create to socket_create so
>>    creation would be blocked before socket allocation and initialization.
>> * Uses credential instead of domain in hook_socket create.
>> * Removes get_raw_handled_socket_accesses.
>> * Adds checks for rules with wildcard type and protocol values.
>> * Minor refactoring, fixes.
>>
>> Changes since v2:
>> * Adds check in `hook_socket_create()` to not restrict kernel space
>>    sockets.
>> * Inlines `current_check_access_socket()` in the `hook_socket_create()`.
>> * Fixes commit message.
>>
>> Changes since v1:
>> * Uses lsm hook arguments instead of struct socket fields as family-type
>>    values.
>> * Packs socket family and type using helper.
>> * Fixes commit message.
>> * Formats with clang-format.
>> ---
>>   security/landlock/setup.c  |  2 +
>>   security/landlock/socket.c | 78 ++++++++++++++++++++++++++++++++++++++
>>   security/landlock/socket.h |  2 +
>>   3 files changed, 82 insertions(+)
>>
>> diff --git a/security/landlock/setup.c b/security/landlock/setup.c
>> index bd53c7a56ab9..140a53b022f7 100644
>> --- a/security/landlock/setup.c
>> +++ b/security/landlock/setup.c
>> @@ -17,6 +17,7 @@
>>   #include "fs.h"
>>   #include "id.h"
>>   #include "net.h"
>> +#include "socket.h"
>>   #include "setup.h"
>>   #include "task.h"
>>   
>> @@ -68,6 +69,7 @@ static int __init landlock_init(void)
>>   	landlock_add_task_hooks();
>>   	landlock_add_fs_hooks();
>>   	landlock_add_net_hooks();
>> +	landlock_add_socket_hooks();
>>   	landlock_init_id();
>>   	landlock_initialized = true;
>>   	pr_info("Up and running.\n");
>> diff --git a/security/landlock/socket.c b/security/landlock/socket.c
>> index 28a80dcad629..d7e6e7b92b7a 100644
>> --- a/security/landlock/socket.c
>> +++ b/security/landlock/socket.c
>> @@ -103,3 +103,81 @@ int landlock_append_socket_rule(struct landlock_ruleset *const ruleset,
>>   
>>   	return err;
>>   }
>> +
>> +static int check_socket_access(const struct landlock_ruleset *dom,
>> +			       uintptr_t key,
>> +			       layer_mask_t (*const layer_masks)[],
>> +			       access_mask_t handled_access)
>> +{
>> +	const struct landlock_rule *rule;
>> +	struct landlock_id id = {
>> +		.type = LANDLOCK_KEY_SOCKET,
>> +	};
>> +
>> +	id.key.data = key;
> 
> This line can be made part of the designated initializer:
> 
>      struct landlock_id id = {
>        .type = ...,
>        .key.data = ...,
>      };
> 

Indeed, thats would be better.

> 
>> +	rule = landlock_find_rule(dom, id);
>> +	if (landlock_unmask_layers(rule, handled_access, layer_masks,
>> +				   LANDLOCK_NUM_ACCESS_SOCKET))
>> +		return 0;
>> +	return -EACCES;
>> +}
>> +
>> +static int hook_socket_create(int family, int type, int protocol, int kern)
>> +{
>> +	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_SOCKET] = {};
>> +	access_mask_t handled_access;
>> +	const struct access_masks masks = {
>> +		.socket = LANDLOCK_ACCESS_SOCKET_CREATE,
>> +	};
>> +	const struct landlock_cred_security *const subject =
>> +		landlock_get_applicable_subject(current_cred(), masks, NULL);
>> +	uintptr_t key;
>> +
>> +	if (!subject)
>> +		return 0;
>> +	/* Checks only user space sockets. */
>> +	if (kern)
>> +		return 0;
>> +
>> +	handled_access = landlock_init_layer_masks(
>> +		subject->domain, LANDLOCK_ACCESS_SOCKET_CREATE, &layer_masks,
>> +		LANDLOCK_KEY_SOCKET);
> 
> Nit: I had to double check to confirm that the same PF_INET/PF_PACKET
> transformation (which net/socket.c refers to as the "uglymoron") has
> already happened on the arguments before hook_socket_create() gets
> called from there.  Maybe it's worth a brief mention in a comment
> here.

Ok, thanks!

> 
>> +	/*
>> +	 * Error could happen due to parameters are outside of the allowed range,
> 
> Grammar nit: drop the "are"
> 
> Suggestion: "If this error happens, the parameters are outside of the
> allowed range, so this combination can't have been added to the
> ruleset previously."

Thanks, I'll use it.

> 
>> +	 * so this combination couldn't be added in ruleset previously.
>> +	 * Therefore, it's not permitted.
>> +	 */
>> +	if (pack_socket_key(family, type, protocol, &key) == -EACCES)
>> +		return -EACCES;
> 
> BUG: pack_socket_key() does never return -EACCES!

Thanks a lot, will be fixed!

> 
> (Consider whether that function should really return an error?  Maybe
> a boolean would be better, if you anyway need a different error code
> in both locations where it is called.)

Agreed

> 
> Can this code path actually get hit, or do the entry points for
> creating sockets refuse these wrong values at an earlier stage with
> EINVAL already?

There are checks for family and type ranges in __sock_create. Protocol
ranges should be checked in methods specific to protocol family after
LSM hook is triggered. But it would be safer to keep this check in order
to be independent of the specific kernel version.

> 
>> +	if (check_socket_access(subject->domain, key, &layer_masks,
>> +				handled_access) == 0)
>> +		return 0;
>> +
>> +	/* Ranges were already checked. */
>> +	(void)pack_socket_key(family, TYPE_ALL, protocol, &key);
>> +	if (check_socket_access(subject->domain, key, &layer_masks,
>> +				handled_access) == 0)
>> +		return 0;
>> +
>> +	(void)pack_socket_key(family, type, PROTOCOL_ALL, &key);
>> +	if (check_socket_access(subject->domain, key, &layer_masks,
>> +				handled_access) == 0)
>> +		return 0;
>> +
>> +	(void)pack_socket_key(family, TYPE_ALL, PROTOCOL_ALL, &key);
>> +	if (check_socket_access(subject->domain, key, &layer_masks,
>> +				handled_access) == 0)
>> +		return 0;
>> +
>> +	return -EACCES;
>> +}
> 
> It initially doesn't look very nice to drop the error from
> pack_socket_key() repeatedly.  The call repeats the bounds checks and
> requires more cross-function reasoning to understand.

Agreed

> 
> Since 'key' is an uintptr_t anyway, and the wildcards are all ones,
> maybe a simpler way is to define masks for the wildcards?
> 
>      const uintptr_t any_type_mask     = (union key){.data.type     = UINT8_MAX}.packed;
>      const uintptr_t any_protocol_mask = (union key){.data.protocol = UINT16_MAX}.packed;
> 
> and then, after calling pack_socket_key() once with error check, use
> the combinations
> 
>    * key
>    * key | any_type
>    * key | any_protocol
>    * key | any_type | any_protocol
> 
> to construct the wildcard-enabled keys in the four calls to
> check_socket_access()?  You could have compile-time assertions or
> tests to check that the masking does the same as packing it from
> scratch when passing -1.
> 
> (That being said, I don't feel strongly about it.)

It seems clearer and simpler to me, so I think we should use your
approach. Probably, pack_socket_key() should be changed to pack values
using bit operations instead of socket_key structure:
	key = protocol << 16 | type << 8 | family;

> 
> Remark on the side: I was briefly confused why we don't need to guard
> on CONFIG_SECURITY_NETWORK, but this is already required by
> CONFIG_LANDLOCK. So that looks good.
> 
> –Günther
