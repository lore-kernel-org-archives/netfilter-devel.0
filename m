Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6B717BCC;
	Thu, 11 Apr 2024 15:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712848607; cv=none; b=HOljhX0Uw/QW4lzQ95QcZH0ZSKKfLydVXuIunkDrxvViK8hQtSzsatM1LN8vHhcpV6EjVcybSSw8si6Heco9XTgVIPNO6pqrwwXD3Cz8zDHzWdrjCee8gXyRNuMR1/EcxxnXPbFjgZZ8tnL3LjbJHHHtGceNaNgqdGTyzYjbHhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712848607; c=relaxed/simple;
	bh=eZKeTdoBgCN/voI+FykzvT0PShkqcsMI2dABVoJLjdE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=S3W0DH+vEWoV8uuXKvRLhPW0H/h3z7AOGbwYTiGa4dmWwEEZHPK3ajmveflwJcNvydBz8p8UhoxMy/4pUpKG5i6e6OCgMhHarMgdw/PvshTxSCiyy+HZYJowI3SisFVaL5TwKTkfmhW8cZwk939lc17OLprBjtUBJ/p3rF1X6Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4VFjsW4M6sz1ymTb;
	Thu, 11 Apr 2024 23:14:23 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 8FF511A0172;
	Thu, 11 Apr 2024 23:16:40 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 11 Apr 2024 23:16:36 +0800
Message-ID: <a7e8f467-036c-a3e0-e26b-b5ba966b4e9e@huawei-partners.com>
Date: Thu, 11 Apr 2024 18:16:31 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 01/10] landlock: Support socket access-control
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20240408093927.1759381-1-ivanov.mikhail1@huawei-partners.com>
 <20240408093927.1759381-2-ivanov.mikhail1@huawei-partners.com>
 <ZhRKOTmoAOuwkujB@google.com>
From: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZhRKOTmoAOuwkujB@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100003.china.huawei.com (7.191.160.210) To
 dggpemm500020.china.huawei.com (7.185.36.49)

Hello! Big thanks for your review and ideas :)

P.S.: Sorry, previous mail was rejected by linux mailboxes
due to HTML formatting.

4/8/2024 10:49 PM, Günther Noack wrote:
> Hello!
> 
> Just zooming in on what I think are the most high level questions here,
> so that we get the more dramatic changes out of the way early, if needed.
> 
> On Mon, Apr 08, 2024 at 05:39:18PM +0800, Ivanov Mikhail wrote:
>> diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
>> index 25c8d7677..8551ade38 100644
>> --- a/include/uapi/linux/landlock.h
>> +++ b/include/uapi/linux/landlock.h
>> @@ -37,6 +37,13 @@ struct landlock_ruleset_attr {
>>   	 * rule explicitly allow them.
>>   	 */
>>   	__u64 handled_access_net;
>> +
>> +	/**
>> +	 * @handled_access_net: Bitmask of actions (cf. `Socket flags`_)
>                             ^^^
> 			   Typo
>

Thanks, will be fixed.

>> +	 * that is handled by this ruleset and should then be forbidden if no
>> +	 * rule explicitly allow them.
>> +	 */
>> +	__u64 handled_access_socket;
> 
> What is your rationale for introducing and naming this additional field?
> 
> I am not convinced that "socket" is the right name to use in this field,
> but it is well possible that I'm missing some context.
> 
> * If we introduce this additional field in the landlock_ruleset_attr, which
>    other socket-related operations will go in the remaining 63 bits?  (I'm having
>    a hard time coming up with so many of them.)

If i understood correctly Mickaël suggested saving some space for
actions related not only to creating sockets, but also to sending
and receiving socket FDs from another processes, marking pre-sandboxed
sockets as allowed or denied after sandboxing [2]. This may be necessary
in order to achieve complete isolation of the sandbox, which will be
able to create, receive and send sockets of specific protocols.

In future this field may become more generic by including rules for
other entities with similar actions (e.g. files, pipes).

I think it is good approach, but we should discuss this design before
generalizing the name. For now `handled_access_socket` can be a good
name for actions related to accessing specific sockets (protocols).
What do you think?

[2] 
https://lore.kernel.org/all/b8a2045a-e7e8-d141-7c01-bf47874c7930@digikod.net/

> 
> * Should this have a more general name than "socket", so that other planned
>    features from the bug tracker [1] fit in?

I have not found any similar features for our case. Do you have any in
mind?

> 
> The other alternative is of course to piggy back on the existing
> handled_access_net field, whose name already is pretty generic.
> 
> For that, I believe we would need to clarify in struct landlock_net_port_attr
> which exact values are permitted there.
> 
> I imagine you have considered this approach?  Are there more reasons why this
> was ruled out, which I am overlooking?
> 
> [1] https://github.com/orgs/landlock-lsm/projects/1/views/1
> 
>

Currently `handled_access_net` stands for restricting actions for
specific network protocols by port values: LANDLOCK_ACCESS_NET_BIND_TCP,
LANDLOCK_ACCESS_NET_SEND_UDP (possibly will be added with UDP feature
[3]).

I dont think that complicating semantics with adding fields for
socket_create()-like actions would fit well here. Purpose of current
patch is to restrict usage of unwanted protocols, not to add logic
to restrict their actions. In addition, it is worth considering that we
want to restrict not only network protocols (e.g. Bluetooth).

[3] https://github.com/landlock-lsm/linux/issues/1

>> @@ -244,4 +277,20 @@ struct landlock_net_port_attr {
>>   #define LANDLOCK_ACCESS_NET_BIND_TCP			(1ULL << 0)
>>   #define LANDLOCK_ACCESS_NET_CONNECT_TCP			(1ULL << 1)
>>   /* clang-format on */
>> +
>> +/**
>> + * DOC: socket_acess
>> + *
>> + * Socket flags
>> + * ~~~~~~~~~~~~~~~~
> 
> Mega-Nit: This ~~~ underline should only be as long as the text above it ;-)
> You might want to fix it for the "Network Flags" headline as well.
> 

Ofc, thanks!

>> + *
>> + * These flags enable to restrict a sandboxed process to a set of
>> + * socket-related actions for specific protocols. This is supported
>> + * since the Landlock ABI version 5.
>> + *
>> + * - %LANDLOCK_ACCESS_SOCKET_CREATE: Create a socket
>> + */
> 
> 
>> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
>> index c7f152678..f4213db09 100644
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
>> +	 * landlock_rule nodes with socket type, described by (domain, type)
>> +	 * pair (see socket(2)). Once a ruleset is tied to a
>> +	 * process (i.e. as a domain), this tree is immutable until @usage
>> +	 * reaches zero.
>> +	 */
>> +	struct rb_root root_socket;
> 
> The domain is a value between 0 and 45,
> and the socket type is one of 1, 2, 3, 4, 5, 6, 10.
> 
> The bounds of these are defined with AF_MAX (include/linux/socket.h) and
> SOCK_MAX (include/linux/net.h).
> 
> Why don't we just combine these two numbers into an index and create a big bit
> vector here, like this:
> 
>      socket_type_mask_t socket_domains[AF_MAX];
> 
> socket_type_mask_t would need to be typedef'd to u16 and ideally have a static
> check to test that it has more bits than SOCK_MAX.
> 
> Then you can look up whether a socket creation is permitted by checking:
> 
>      /* assuming appropriate bounds checks */
>      if (dom->socket_domains[domain] & (1 << type)) { /* permitted */ }
> 
> and merging the socket_domains of two domains would be a bitwise-AND.
> 
> (We can also cram socket_type_mask_t in a u8 but it would require mapping the
> existing socket types onto a different number space.)
> 

I chose rbtree based on the current storage implementation in fs,net and
decided to leave the implementation of better variants in a separate
patch, which should redesign the entire storage system in Landlock
(e.g. implementation of a hashtable for storing rules by FDs,
port values) [4].

Do you think that it is bad idea and more appropriate storage for socket
rules(e.g. what you suggested) should be implemented by current patch?

[4] https://github.com/landlock-lsm/linux/issues/1

> 
> As I said before, I am very excited to see this patch.
> 
> I think this will unlock a tremendous amount of use cases for many programs,
> especially for programs that do not use networking at all, which can now lock
> themselves down to guarantee that with a sandbox.
> 
> Thank you very much for looking into it!
> —Günther
