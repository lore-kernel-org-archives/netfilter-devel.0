Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2D821A45F;
	Fri, 24 Jan 2025 12:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737721692; cv=none; b=LnHVb+apaLr5uUMdAJ1AY1pRFn7GpX2OQ8qANb5CSLVOnj7f5GY96Ur3Nisyag/qfJlrevZaxHSjj72InUaFnff3WuYl7S3SFmczYWt77qBX0mdFGYEKrW5CeTv4BzTDSX/ZAq+FgIzKvrSEf2Yi1VyuLyOPBeTcab/nrp7htAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737721692; c=relaxed/simple;
	bh=gcLSyHNYnRu2awQ9h9XWuZFp8Y1DmsUr/Y7Wymu/XIs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=i4G+QDDfhB5GQbglFtBaTTpiAC7FxJCrpfVyDI3W1h6GoqEN3jby6xwoXXYnWFDq37X7qAhc/weDKyGBCvjkT0lrxY/fVh1TQT0h5Rc0kz4qUXygMrHKpBmV3fb9N28dN6HQhNazIuw/yHWXNyD76/YQXgLdr8qlmTRmBoKX63A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YfcVS0PYjz6M4KC;
	Fri, 24 Jan 2025 20:26:08 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id 8C8F11400D4;
	Fri, 24 Jan 2025 20:28:06 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Fri, 24 Jan 2025 15:28:04 +0300
Message-ID: <aac17a25-eb9e-342e-953a-094ae0e86b54@huawei-partners.com>
Date: Fri, 24 Jan 2025 15:28:02 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 01/19] landlock: Support socket access-control
Content-Language: ru
To: =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
CC: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack3000@gmail.com>,
	=?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>,
	<willemdebruijn.kernel@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>, Matthieu Buffet <matthieu@buffet.re>
References: <36ac2fde-1344-9055-42e2-db849abf02e0@huawei-partners.com>
 <20241127.oophah4Ueboo@digikod.net>
 <eafd855d-2681-8dfd-a2be-9c02fc07050d@huawei-partners.com>
 <20241128.um9voo5Woo3I@digikod.net>
 <af72be74-50c7-d251-5df3-a2c63c73296a@huawei-partners.com>
 <f6b255c9-5a88-fedd-5d25-dd7d09ddc989@huawei-partners.com>
 <20250110.2893966a7649@gnoack.org>
 <3cdf6001-4ad4-6edc-e436-41a1eaf773f3@huawei-partners.com>
 <20250110.8ae6c145948f@gnoack.org>
 <cd78c2c8-feb3-b7f1-90be-3f6ab3becc09@huawei-partners.com>
 <20250114.maiR6ueChieD@digikod.net>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20250114.maiR6ueChieD@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
 mscpeml500004.china.huawei.com (7.188.26.250)

On 1/14/2025 9:31 PM, Mickaël Salaün wrote:
> Happy new year!
> 
> On Fri, Jan 10, 2025 at 07:55:10PM +0300, Mikhail Ivanov wrote:
>> On 1/10/2025 7:27 PM, Günther Noack wrote:
>>> On Fri, Jan 10, 2025 at 04:02:42PM +0300, Mikhail Ivanov wrote:
>>>> Correct, but we also agreed to use bitmasks for "family" field as well:
>>>>
>>>> https://lore.kernel.org/all/af72be74-50c7-d251-5df3-a2c63c73296a@huawei-partners.com/
>>>
>>> OK
>>>
>>>
>>>> On 1/10/2025 2:12 PM, Günther Noack wrote:
>>>>> I do not understand why this convenience feature in the UAPI layer
>>>>> requires a change to the data structures that Landlock uses
>>>>> internally?  As far as I can tell, struct landlock_socket_attr is only
>>>>> used in syscalls.c and converted to other data structures already.  I
>>>>> would have imagined that we'd "unroll" the specified bitmasks into the
>>>>> possible combinations in the add_rule_socket() function and then call
>>>>> landlock_append_socket_rule() multiple times with each of these?
> 
> I agree that UAPI should not necessarily dictate the kernel
> implementation.
> 
>>>>
>>>> I thought about unrolling bitmask into multiple entries in rbtree, and
>>>> came up with following possible issue:
>>>>
>>>> Imagine that a user creates a rule that allows to create sockets of all
>>>> possible families and types (with protocol=0 for example):
>>>> {
>>>> 	.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
>>>> 	.families = INT64_MAX, /* 64 set bits */
>>>> 	.types = INT16_MAX, /* 16 set bits */
>>>> 	.protocol = 0,
>>>> },
>>>>
>>>> This will add 64 x 16 = 1024 entries to the rbtree. Currently, the
>>>> struct landlock_rule, which is used to store rules, weighs 40B. So, it
>>>> will be 40kB by a single rule. Even if we allow rules with only
>>>> "existing" families and types, it will be 46 x 7 = 322 entries and ~12kB
>>>> by a single rule.
>>>>
>>>> I understand that this may be degenerate case and most common rule will
>>>> result in less then 8 (or 4) entries in rbtree, but I think API should
>>>> be as intuitive as possible. User can expect to see the same
>>>> memory usage regardless of the content of the rule.
>>>>
>>>> I'm not really sure if this case is really an issue, so I'd be glad
>>>> to hear your opinion on it.
>>>
>>> I think there are two separate questions here:
>>>
>>> (a) I think it is OK that it is *possible* to allocate 40kB of kernel
>>>       memory.  At least, this is already possible today by calling
>>>       landlock_add_rule() repeatedly.
>>>
>>>       I assume that the GFP_KERNEL_ACCOUNT flag is limiting the
>>>       potential damage to the caller here?  That flag was added in the
>>>       Landlock v19 patch set [1] ("Account objects to kmemcg.").
>>>
>>> (b) I agree it might be counterintuitive when a single
>>>       landlock_add_rule() call allocates more space than expected.
>>>
>>> Mickaël, since it is already possible today (but harder), I assume
>>> that you have thought about this problem before -- is it a problem
>>> when users allocate more kernel memory through Landlock than they
>>> expected?
> 
> The imbalance between the user request and the required kernel memory is
> interesting.  It would not be a security issue thanks to the
> GFP_KERNEL_ACCOUNT, but it can be surprising for users that for some
> requests they can receive -ENOMEM but not for quite-similar ones (e.g.
> with only some bits different).  We should keep the principle of least
> astonishment in mind, but also the fact that the kernel implementation
> and the related required memory may change between two kernel versions
> for the exact same user request (because of Landlock implementation
> differences or other parts of the kernel).  In summary, we should be
> careful to prevent users from being able to use a large amount of memory
> with only one syscall.  This which would be an usability issue.
> 
>>>
>>>
>>> Naive proposal:
>>>
>>> If this is an issue, how about we set a low limit to the number of
>>> families and the number of types that can be used in a single
>>> landlock_add_rule() invocation?  (It tends to be easier to start with
>>> a restrictive API and open it up later than the other way around.)
>>
>> Looks like a good approach! Better to return with an error (which almost
>> always won't happen) and let the user to refactor the code than to
>> allow ruleset to eat an unexpected amount of memory.
>>
>>>
>>> For instance,
>>>
>>> * In the families field, at most 2 bits may be set.
>>> * In the types field, at most 2 bits may be set.
>>
>> Or we can say that rule can contain not more than 4 combinations of
>> family and type.
>>
>> BTW, 4 seems to be sufficient, at least for IP protocols.
>>
>>>
>>> In my understanding, the main use case of the bit vectors is that
>>> there is a short way to say "all IPv4+v6 stream+dgram sockets", but we
>>> do not know scenarios where much more than that is needed?  With that,
>>> we would still keep people from accidentally allocating larger amounts
>>> of memory, while permitting the main use case.
>>
>> Agreed
>>
>>>
>>> Having independent limits for the family and type fields is a bit
>>> easier to understand and document than imposing a limit on the
>>> multiplication result.
> 
> This is a safer approach that can indeed be documented, but it looks
> unintuitive and an arbitrary limitation.  Here is another proposal:
> 
> Let's ignore my previous suggestion to use bitfields for families and
> protocols.  To keep it simple, we can get back to the initial struct but
> specifically handle the (i64)-1 value (which cannot be a family,
> protocol, nor a type):
> {
> 	.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
> 	.family = AF_INET,
> 	.type = SOCK_STREAM,
> 	.protocol = -1,
> },
> 
> This would read: deny socket creation except for AF_INET with
> SOCK_STREAM (and any protocol).
> 
> Users might need to add several rules (e.g. one for AF_INET and another
> for AF_INET6) but that's OK.  Unfortunately we cannot identify a TCP
> socket with only protocol = IPPROTO_TCP because protocol definitions
> are relative to network families.  Specifying the protocol without the
> family should then return an error.
> 
> Before rule could be loaded, users define how much they want to match a
> socket: at least the family, optionally the type, and if the type is
> also set then the protocol can also be set.  These dependencies are
> required to transform this triplet to a key number, see below.
> 
> A landlock_ruleset_attr.handled_socket_layers field would define how
> much we want to match a socket:
> - 1: family only
> - 2: family and type
> - 3: family, type, and protocol
> 
> According to this ruleset's property, users will be allowed to fill the
> family, type, or protocol fields in landlock_socket_attr rules.  If a
> socket layer is not handled, it should contain (i64)-1 for the kernel to
> detect misuse of the API.
> 
> This enables us to get a key from this triplet:
> 
> family_bits = 6; // 45 values for now
> type_bits = 3; // 7 values for now
> protocol_bits = 5; // 28 values for now
> 
> // attr.* are the sanitized UAPI values, including -1 replaced with 0.
> // In this example, landlock_ruleset_attr.handled_socket_layers is 3, so
> // the key is composed of all the 3 properties.
> landlock_key.data = attr.family << (type_bits + protocol_bits) |
>                      attr.type << protocol_bits | attr.protocol;
> 
> For each layer of restriction in a domain, we know how precise they
> define a socket (i.e. with how many "socket layers").  We can then look
> for at most 3 entries in the red-black tree: one with only the family,
> another with the family and the type, and potentially a third also
> including the protocol.  Each key would have the same significant bits
> but with the lower bits masked according to each
> landlock_ruleset_attr.handled_socket_layers .  Composing the related
> access masks according to the defined socket layers, we can create an
> array of struct access_masks for the request and then check if such
> request is allowed by the current domain.  As for the currently stored
> data, we can also identify the domain layer that blocked the request
> (required for audit).

I do not quite understand why we need socket_layers. Without it,
user can set (i64)(-1) to type or protocol whenever he wants. While
transforming triplet to a key we can replace (i64)(-1) with some
constant (e.g. (1 << type_bits - 1) for the type if type_bits = 8 and
(1 << protocol_bits - 1) for the protocol if protocol_bits = 16).

> 
> With this design, each sandbox can define a socket as much as it wants.
> 
> The downside is that we lost the bitfields and we need several calls to
> filter more complex sockets (e.g. 4 for UDP and TCP with IPv4 and IPv6),
> which looks OK compared to the required calls for filesystem access
> control.
> 
>>>
>>>>> That being said, I am not a big fan of red-black trees for such simple
>>>>> integer lookups either, and I also think there should be something
>>>>> better if we make more use of the properties of the input ranges. The
>>>>> question is though whether you want to couple that to this socket type
>>>>> patch set, or rather do it in a follow up?  (So far we have been doing
>>>>> fine with the red black trees, and we are already contemplating the
>>>>> possibility of changing these internal structures in [2].  We have
>>>>> also used RB trees for the "port" rules with a similar reasoning,
>>>>> IIRC.)
>>>>
>>>> I think it'll be better to have a separate series for [2] if the socket
>>>> restriction can be implemented without rbtree refactoring.
>>>
>>> Sounds good to me. 👍
>>>
>>> [1] https://lore.kernel.org/all/20200707180955.53024-2-mic@digikod.net/
> 
> red-black trees are a good generic data structure for the current main
> use case (for dynamic rulesets and static domains), but we'll need to
> use more appropriate data structures.  I think this should not be a
> blocker for this patch series.  It will be required to match (port)
> ranges though (even if the use case seems limited), and in general for
> better performances.
