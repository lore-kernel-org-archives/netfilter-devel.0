Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD86D212B02;
	Fri, 10 Jan 2025 16:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736528121; cv=none; b=Dab2H5aT9wEde53aUl57AZRIFW5qRlIy6is4nW26reBzIwB0hPPhsrA5G0GPxmMLq5aTKHGBjDUXMSDM1waQVYR8WIHvZovFyfqI/+GQvs6aaVttoSNblTW5N5rjKqtbnq9E9M51+sErwzXA4hQ79HZ26Dcu1wsKBbsvzAHB5TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736528121; c=relaxed/simple;
	bh=713G3w7yLUaNqhCI4MAHxZg8d0OUUUek1/UahKUayyo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=c2WcPrhyaOrzcnTD9sn+5a3p1x9X6Dn4ydOsvpqgK9X5NSq2v1anJ99UI8fhl6MFo7fWmaZVdd0N+rDwmI64Yua9rqMyenGazDFCE2Q8Z1St34xvprPMlZvZ5y+kNUyAl95CXLj93e+xqrdmnri2fgaaPSrXiIOFgU9yfdvRQ6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YV75X2DKxz6M4NC;
	Sat, 11 Jan 2025 00:53:36 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id 402D7140B67;
	Sat, 11 Jan 2025 00:55:14 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Fri, 10 Jan 2025 19:55:12 +0300
Message-ID: <cd78c2c8-feb3-b7f1-90be-3f6ab3becc09@huawei-partners.com>
Date: Fri, 10 Jan 2025 19:55:10 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 01/19] landlock: Support socket access-control
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack3000@gmail.com>
CC: =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
	=?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>,
	<willemdebruijn.kernel@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <ea026af8-bc29-709c-7e04-e145d01fd825@huawei-partners.com>
 <Z0DDQKACIRRDRZRE@google.com>
 <36ac2fde-1344-9055-42e2-db849abf02e0@huawei-partners.com>
 <20241127.oophah4Ueboo@digikod.net>
 <eafd855d-2681-8dfd-a2be-9c02fc07050d@huawei-partners.com>
 <20241128.um9voo5Woo3I@digikod.net>
 <af72be74-50c7-d251-5df3-a2c63c73296a@huawei-partners.com>
 <f6b255c9-5a88-fedd-5d25-dd7d09ddc989@huawei-partners.com>
 <20250110.2893966a7649@gnoack.org>
 <3cdf6001-4ad4-6edc-e436-41a1eaf773f3@huawei-partners.com>
 <20250110.8ae6c145948f@gnoack.org>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20250110.8ae6c145948f@gnoack.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 mscpeml500004.china.huawei.com (7.188.26.250)

On 1/10/2025 7:27 PM, Günther Noack wrote:
> On Fri, Jan 10, 2025 at 04:02:42PM +0300, Mikhail Ivanov wrote:
>> Correct, but we also agreed to use bitmasks for "family" field as well:
>>
>> https://lore.kernel.org/all/af72be74-50c7-d251-5df3-a2c63c73296a@huawei-partners.com/
> 
> OK
> 
> 
>> On 1/10/2025 2:12 PM, Günther Noack wrote:
>>> I do not understand why this convenience feature in the UAPI layer
>>> requires a change to the data structures that Landlock uses
>>> internally?  As far as I can tell, struct landlock_socket_attr is only
>>> used in syscalls.c and converted to other data structures already.  I
>>> would have imagined that we'd "unroll" the specified bitmasks into the
>>> possible combinations in the add_rule_socket() function and then call
>>> landlock_append_socket_rule() multiple times with each of these?
>>
>> I thought about unrolling bitmask into multiple entries in rbtree, and
>> came up with following possible issue:
>>
>> Imagine that a user creates a rule that allows to create sockets of all
>> possible families and types (with protocol=0 for example):
>> {
>> 	.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
>> 	.families = INT64_MAX, /* 64 set bits */
>> 	.types = INT16_MAX, /* 16 set bits */
>> 	.protocol = 0,
>> },
>>
>> This will add 64 x 16 = 1024 entries to the rbtree. Currently, the
>> struct landlock_rule, which is used to store rules, weighs 40B. So, it
>> will be 40kB by a single rule. Even if we allow rules with only
>> "existing" families and types, it will be 46 x 7 = 322 entries and ~12kB
>> by a single rule.
>>
>> I understand that this may be degenerate case and most common rule will
>> result in less then 8 (or 4) entries in rbtree, but I think API should
>> be as intuitive as possible. User can expect to see the same
>> memory usage regardless of the content of the rule.
>>
>> I'm not really sure if this case is really an issue, so I'd be glad
>> to hear your opinion on it.
> 
> I think there are two separate questions here:
> 
> (a) I think it is OK that it is *possible* to allocate 40kB of kernel
>      memory.  At least, this is already possible today by calling
>      landlock_add_rule() repeatedly.
> 
>      I assume that the GFP_KERNEL_ACCOUNT flag is limiting the
>      potential damage to the caller here?  That flag was added in the
>      Landlock v19 patch set [1] ("Account objects to kmemcg.").
> 
> (b) I agree it might be counterintuitive when a single
>      landlock_add_rule() call allocates more space than expected.
> 
> Mickaël, since it is already possible today (but harder), I assume
> that you have thought about this problem before -- is it a problem
> when users allocate more kernel memory through Landlock than they
> expected?
> 
> 
> Naive proposal:
> 
> If this is an issue, how about we set a low limit to the number of
> families and the number of types that can be used in a single
> landlock_add_rule() invocation?  (It tends to be easier to start with
> a restrictive API and open it up later than the other way around.)

Looks like a good approach! Better to return with an error (which almost
always won't happen) and let the user to refactor the code than to
allow ruleset to eat an unexpected amount of memory.

> 
> For instance,
> 
> * In the families field, at most 2 bits may be set.
> * In the types field, at most 2 bits may be set.

Or we can say that rule can contain not more than 4 combinations of
family and type.

BTW, 4 seems to be sufficient, at least for IP protocols.

> 
> In my understanding, the main use case of the bit vectors is that
> there is a short way to say "all IPv4+v6 stream+dgram sockets", but we
> do not know scenarios where much more than that is needed?  With that,
> we would still keep people from accidentally allocating larger amounts
> of memory, while permitting the main use case.

Agreed

> 
> Having independent limits for the family and type fields is a bit
> easier to understand and document than imposing a limit on the
> multiplication result.
> 
>>> That being said, I am not a big fan of red-black trees for such simple
>>> integer lookups either, and I also think there should be something
>>> better if we make more use of the properties of the input ranges. The
>>> question is though whether you want to couple that to this socket type
>>> patch set, or rather do it in a follow up?  (So far we have been doing
>>> fine with the red black trees, and we are already contemplating the
>>> possibility of changing these internal structures in [2].  We have
>>> also used RB trees for the "port" rules with a similar reasoning,
>>> IIRC.)
>>
>> I think it'll be better to have a separate series for [2] if the socket
>> restriction can be implemented without rbtree refactoring.
> 
> Sounds good to me. 👍
> 
> –Günther
> 
> [1] https://lore.kernel.org/all/20200707180955.53024-2-mic@digikod.net/
