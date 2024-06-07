Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019C1197A65;
	Fri,  7 Jun 2024 13:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717767299; cv=none; b=t0ECv15ADg/HPL3ylwCX6hobuKjQCLTqins0q69ZyqkDmZX4xpKx2AELSSQZOSIhDTa3vcep85q1tWz7zfekbCzEgbqlbaZGneR5tVjExxP95B2ldqPcKMhM2exRGs7hqR8anq7XDk7Co7Ksu8gHgfHPIVhgY7FmFcIdBpT0VXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717767299; c=relaxed/simple;
	bh=mWjQoEgi5kGmomjk0FuUp9W3PmdI8Zl7APK/Y1sOD3U=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=GqgBbsgtH4wbCByRV2CH8Hhka+8IciX3BSuPbQXx5UjMGl/6JqzUfyx7B02wPweD094HqQLIVGYzavXBg1ttMS9qzLjez2GovlqMP1R8fKMhvvS3VGodzz/augQnvwqYfcok5ohgmwWV9bvY4CIadz+O4TGmS/Jk8+srdeS82Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Vwhwl0bZ3zdZQn;
	Fri,  7 Jun 2024 21:33:27 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 3044614011A;
	Fri,  7 Jun 2024 21:34:52 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 7 Jun 2024 21:34:47 +0800
Message-ID: <deeada6f-2538-027a-4922-8697fc59c43f@huawei-partners.com>
Date: Fri, 7 Jun 2024 16:34:42 +0300
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
 <ff5ce842-7c67-d658-95b6-ba356dfcfeaf@huawei-partners.com>
 <ZmCantjZlyxL8jzh@google.com>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZmCantjZlyxL8jzh@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml500003.china.huawei.com (7.191.162.67) To
 dggpemm500020.china.huawei.com (7.185.36.49)

6/5/2024 8:04 PM, Günther Noack wrote:
> Hello!
> 
> On Thu, May 30, 2024 at 03:05:56PM +0300, Mikhail Ivanov wrote:
>> 5/27/2024 12:57 PM, Günther Noack wrote:
>>> On Fri, May 24, 2024 at 05:30:04PM +0800, Mikhail Ivanov wrote:
>>>> +/**
>>>> + * struct landlock_socket_attr - Socket definition
>>>> + *
>>>> + * Argument of sys_landlock_add_rule().
>>>> + */
>>>> +struct landlock_socket_attr {
>>>> +	/**
>>>> +	 * @allowed_access: Bitmask of allowed access for a socket
>>>> +	 * (cf. `Socket flags`_).
>>>> +	 */
>>>> +	__u64 allowed_access;
>>>> +	/**
>>>> +	 * @family: Protocol family used for communication
>>>> +	 * (same as domain in socket(2)).
>>>> +	 */
>>>> +	int family;
>>>> +	/**
>>>> +	 * @type: Socket type (see socket(2)).
>>>> +	 */
>>>> +	int type;
>>>> +};
>>>
>>> Regarding the naming of struct landlock_socket_attr and the associated
>>> LANDLOCK_RULE_SOCKET enum:
>>>
>>> For the two existing rule types LANDLOCK_RULE_PATH_BENEATH (struct
>>> landlock_path_beneath_attr) and LANDLOCK_RULE_NET_PORT (struct
>>> landlock_net_port_attr), the names of the rule types are describing the
>>> *properties* by which we are filtering (path *beneath*, *network port*), rather
>>> than just the kind of object that we are filtering on.
>>>
>>> Should the new enum and struct maybe be called differently as well to match that
>>> convention?  Maybe LANDLOCK_RULE_SOCKET_FAMILY_TYPE and struct
>>> landlock_socket_family_type_attr?
>>>
>>> Are there *other* properties apart from family and type, by which you are
>>> thinking of restricting the use of sockets in the future?
>>
>> There was a thought about adding `protocol` (socket(2)) restriction,
>> but Mickaël noted that it would be useless [1]. Therefore, no other
>> properties are planned until someone has good use cases.
>>
>> I agree that current naming can be associated with socket objects. But i
>> don't think using family-type words for naming of this rule would be
>> convenient for users. In comparison with net port and path beneath
>> family-type pair doesn't represent a single semantic unit, so it would
>> be a little harder to read the code.
>>
>> Perhaps LANDLOCK_RULE_SOCKET_PROTO (struct landlock_socket_proto_attr)
>> would be more suitable here? Although socket(2) has `protocol` argument
>> to specify the socket protocol in some cases (e.g. RAW sockets), in most
>> cases family-type pair defines protocol itself. Since the purpose of
>> this patchlist is to restrict protocols used in a sandboxed process, I
>> think that in the presence of well-written documentation, such naming
>> may be appropriate here. WDYT?
>>
>> [1]
>> https://lore.kernel.org/all/a6318388-e28a-e96f-b1ae-51948c13de4d@digikod.net/
> 
> It is difficult, I also can't come up with a much better name.  In doubt, we
> could stick with what you already have, I think.
> 
> LANDLOCK_RULE_SOCKET_PROTO alludes to "protocol" and even though that is the
> general term, it can be confused with the third argument to socket(2), which is
> also called "protocol" and is rarely used.
> 
> Mickaël, do you have any opinions on the naming of this?
> 
> 
>>> (More about the content)
>>>
>>> The Landlock documentation states the general approach up front:
>>>
>>>     A Landlock rule describes an *action* on an *object* which the process intends
>>>     to perform.
>>>
>>> (In your case, the object is a socket, and the action is the socket's creation.
>>> The Landlock rules describe predicates on objects to restrict the set of actions
>>> through the access_mask_t.)
>>>
>>> The implementation is perfectly in line with that, but it would help to phrase
>>> the documentation also in terms of that framework.  That means, what we are
>>> restricting are *actions*, not protocols.
>>>
>>> To make a more constructive suggestion:
>>>
>>>     "These flags restrict actions on sockets for a sandboxed process (e.g. socket
>>>     creation)."
>>
>> I think this has too general meaning (e.g. bind(2) is also an action on
>> socket). Probably this one would be more suitable:
>>
>>    "These flags restrict actions of adding sockets in a sandboxed
>>    process (e.g. socket creation, passing socket FDs to/from the
>>    process)."
> 
> Sounds good.  (Although I would not give "passing socket FDs to/from the
> process" as an example, as long as it's not supported yet.)

Agreed, thanks

> 
> 
>>>> + * - %LANDLOCK_ACCESS_SOCKET_CREATE: Create a socket.
>>>
>>> Can we be more specific here what operations are affected by this?  It is rather
>>> obvious that this affects socket(2), but does this also affect accept(2) and
>>> connect(2)?
>>>
>>> A scenario that I could imagine being useful is to sandbox a TCP server like
>>> this:
>>>
>>>     * create a socket, bind(2) and listen(2)
>>>     * sandbox yourself so that no new sockets can be created with socket(2)
>>>     * go into the main loop and start accept(2)ing new connections
>>>
>>> Is this an approach that would work with this patch set?
>>
>> Yes, such scenario is possible. This rule should apply to all socket
>> creation requests in the user space (socket(2), socketpair(2), io_uring
>> request). Perhaps it's necessary to clarify here that only user space
>> sockets are restricted?
>>
>> Btw, current implementation doesn't check that the socket creation
>> request doesn't come from the kernel space. Will be fixed.
> 
> Two brief side side discussions:
> 
> * What are the scenarios where that creation request comes from kernel space?
>    If this is used under the hood for network-backed file systems like NFS, can
>    this result in surprising interactions when the program tries to access the
>    file system?

Yes, i've figured out that NFS can use __sock_create() kernel method for
allocating per-client socket. If kernel allocation of sockets would be
restricted by Landlock that NFS client allocation may fail and proccess
won't be able to connect to the NFS server.

Some of the socket protocols uses kernel space methods like
sock_create_lite() or sock_create_kern() for their own needs.
For example netlink fou family uses sock_create_kern() for UDP
tunneling.

Landlock shouldn't allow to indirectly change the behavior of such
mechanisms from user space.

> 
> * To be clear, I think it would be useful to support the scenario above, where
>    accept() continues to work. - It would make it easy to create sandboxed server
>    processes and they could still accept connections, but do no other networking.

Yes, accept() should work with any restrictions.

> 
> But to bring it back to my original remark, and to unblock progress:
> 
> I think for this patch set (focused on userspace-requested socket creation), it
> would be enough to clarify in the documentation which operations are affected by
> the LANDLOCK_ACCESS_SOCKET_CREATE right.

Ok, I'll do it.

> 
> 
>>> (It might make a neat sample tool as well, if something like this works :))
>>>
>>>
>>> Regarding the list of socket access rights with only one item in it:
>>>
>>> I am still unsure what other socket actions are in scope in the future; it would
>>> probably help to phrase the documentation in those terms.  (listen(2), bind(2),
>>> connect(2), shutdown(2)?  On the other hand, bind(2) and connect(2) for TCP are
>>> already restrictable differently.))
>>
>> I think it would be useful to restrict sending and receiving socket
>> FDs via unix domain sockets (see SCM_RIGHTS in unix(7)).
> 
> That seems like a reasonable idea.  Would you like to file an issue on the
> Landlock bugtracker about it?
> 
> https://github.com/landlock-lsm/linux/issues

Ofc: https://github.com/landlock-lsm/linux/issues/33.

> 
> 
>>>> +	/* Checks that all supported socket families and types can be stored in socket_key. */
>>>> +	BUILD_BUG_ON(AF_MAX > (typeof(socket_key.data.family))~0);
>>>> +	BUILD_BUG_ON(SOCK_MAX > (typeof(socket_key.data.type))~0);
>>>
>>> Off-by-one nit: AF_MAX and SOCK_MAX are one higher than the last permitted value,
>>> so technically it would be ok if they are one higher than (unsigned short)~0.
> 
> (Did you see this remark?)

Yeah, sorry I've somehow lost my reply. This nit will be fixed.

> 
> 
>>> I see that this function traces back to Mickaël's comment in
>>> https://lore.kernel.org/all/20240412.phoh7laim7Th@digikod.net/
>>>
>>> In my understanding, the motivation was to keep the key size in check.
>>> But that does not mean that we need to turn it into a uintptr_t?
>>>
>>> Would it not have been possible to extend the union landlock_key in ruleset.h
>>> with a
>>>
>>>     struct {
>>>       unsigned short family, type;
>>>     }
>>>
>>> and then do the AF_MAX, SOCK_MAX build-time checks on that?
>>> It seems like that might be more in line with what we already have?
>>
>> I don't think that complicating general entity with such a specific
>> representation would be a good solution here. `landlock_key` shouldn't
>> contain any semantic information about the key content.
> 
> Hm, OK.  I think that is debatable, but these are all things that are
> implementation details and can be changed later if needed.  Sounds good to me if
> we fix the undefined behaviour in the key calculation.

Ok, agreed! Mikael can probably give his opinion on this.

> 
> 
>>>> +	/* Denies inserting a rule with unsupported socket family and type. */
>                                          ^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Is the wording "unsupported socket family" misleading here?
> 
> (a) It is technically a "protocol family" and a "socket type", according to
>      socket(2). (BTW, the exact delineation between a "protocol family" and an
>      "address family" is not clear to me.)
> 
> (b) "unsupported" in the context of protocol families may mean that the kernel
>      does not know how to speak that protocol, which is slightly different than
>      saying that it's outside of the [0, AF_MAX) range.  If we wanted to check
>      for the protocol family being "supported", we should also probably return
>      -EAFNOSUPPORT, similar to what we already return when adding a "port" rule
>      with the wrong protocol [1]?
> 
>      [1] https://docs.kernel.org/userspace-api/landlock.html#extending-a-ruleset
> 
> I suspect that -EINVAL is slightly more correct here, because this is not about
> the protocols that the kernel supports, but only about the range.  If we wanted
> to return errors about the protocol that the kernel supports, I realized that
> we'd probably also have to check whether the *combination* of family and type
> makes sense.  In my understanding, the equivalent errors for type and protocol,
> ESOCKTNOSUPPORT and EPROTONOSUPPORT, only get returned based on whether they
> make sense together with the other values.

Thanks, "unsupported" is indeed an incorrect naming in this case.
To check if the protocol is supported, we'll have to validate 
family-type combination, which would be really ugly.

Taking into account the thoughts below regarding family-type checking,
the following description can be used.

   /* Denies inserting a rule with family and type outside the range. */

> 
> 
>>>> +	if (family < 0 || family >= AF_MAX)
>>>> +		return -EINVAL;
>>>> +	if (type < 0 || type >= SOCK_MAX)
>>>> +		return -EINVAL;
>>>
>>> enum sock_type (include/linux/net.h) has "holes": values 7, 8 and 9 are not
>>> defined in the header.  Should we check more specifically for the supported
>>> values here?  (Is there already a helper function for that?)
>>
>> I think that a more detailed check of the family-type values may have a
>> good effect here, since the rules will contain real codes of families
>> and types.
>>
>> I haven't found any helper to check the supported socket type value.
>> Performing a check inside landlock can lead to several minor problems,
>> which theoretically should not lead to any costs.
>>
>> * There are would be a dependency with constants of enum sock_types. But
>>    we are unlikely to see new types of sockets in the next few years, so
>>    it wouldn't be a problem to maintain such check.
>>
>> * enum sock_types can be redefined (see ARCH_HAS_SOCKET_TYPES in net.h),
>>    but i haven't found anyone to actually change the constants of socket
>>    types. It would be wrong to have a different landlock behavior for
>>    arch that redefines sock_types for some purposes, so probably this
>>    should also be maintained.
>>
>> WDYT?
> 
> Thinking about it again, from a Landlock safety perspective, I believe it is
> safe to keep the checks as they are and to check for the two values to be in the
> ranges [0, AF_MAX) and [0, SOCK_MAX).
> 
> Even if we permit the rule to be added for an invalid socket type, there does
> not seem to be any harm in that, as these sockets can't be created anyway.
> Also, given the semantics of these errors in socket(2), where also the
> *combinations* of the values are checked, it seems overly complicated to check
> all these combinations.  I think it would be fine to keep as is, I was mostly
> wondering whether you had done any deeper analysis?

No, I think that checking only ranges is also a good solution. We won't
care about maintaining valid type constants, and that would simplify
behavior of this method for users. Let's take this approach.

> 
> It might be worth spelling out in the struct documentation that the values which
> fulfil 0 <= family < AF_MAX and 0 <= type < SOCK_MAX are considered valid.  Does
> that sound reasonable?

Ofc, I'll add appropriate comments in the definition of struct
landlock_socket_attr and in the socket rule documentation. Thanks!

> 
> P.S., it seems that the security/apparmor/Makefile is turning the "#define"s
> into C code with lookup tables, but it seems that this is only used for
> human-readable audit-logging, not for validating the policies.
> 
> —Günther
