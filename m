Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183B4190672;
	Fri,  7 Jun 2024 14:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717771562; cv=none; b=VGQuKB1UJqvlYJaZxniZ+Bgm0SIiqsz5dlUcc5Wy7bZXFqDTlPVBQWsHrhOChDpoeEY8DdslejORPbTM3+/VCuqngQM6bK2VCCnjq9WMpX4jKiYwRd5yR5MIz+T80nSrTyPik8b+m0V+CoVJBEQ/CEr/U3bimwgfZPu0pxQUr/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717771562; c=relaxed/simple;
	bh=rkBZeUKTqeFDh5cP2yVoebbQjSKSpEiANwSjoqxpAPA=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=QUzKJCACyZlfzbOnE7vYSz4uYjubl8t6K0Fr+PUWQZn6irbBQD2fzkGAeQq+uV4posMBqdFMiz0PpOz6Gyu/GLpRXBbkHvuPvZfvwAb6ppJV/ibBqgyS9Y/aVdnFnilLVFCREHnF82QtYb2xxEB9/HHB4Obs1uSIJiutqlHG7X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VwkRm3vm5zmXJq;
	Fri,  7 Jun 2024 22:41:56 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 0CBBF18007E;
	Fri,  7 Jun 2024 22:45:56 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 7 Jun 2024 22:45:51 +0800
Message-ID: <3433b163-2371-e679-cc8a-e540a0218bca@huawei-partners.com>
Date: Fri, 7 Jun 2024 17:45:46 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Subject: Re: [RFC PATCH v2 02/12] landlock: Add hook on socket creation
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20240524093015.2402952-1-ivanov.mikhail1@huawei-partners.com>
 <20240524093015.2402952-3-ivanov.mikhail1@huawei-partners.com>
 <ZlRI-gqDNkYOV_Th@google.com>
 <3cd4fad8-d72e-87cd-3cf9-2648a770f13c@huawei-partners.com>
 <ZmCf9JVIXmRZrCWk@google.com>
Content-Language: ru
In-Reply-To: <ZmCf9JVIXmRZrCWk@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 dggpemm500020.china.huawei.com (7.185.36.49)

6/5/2024 8:27 PM, Günther Noack wrote:
> Hello!
> 
> On Thu, May 30, 2024 at 03:20:21PM +0300, Mikhail Ivanov wrote:
>> 5/27/2024 11:48 AM, Günther Noack wrote:
>>> On Fri, May 24, 2024 at 05:30:05PM +0800, Mikhail Ivanov wrote:
>>>> Add hook to security_socket_post_create(), which checks whether the socket
>>>> type and family are allowed by domain. Hook is called after initializing
>>>> the socket in the network stack to not wrongfully return EACCES for a
>>>> family-type pair, which is considered invalid by the protocol.
>>>>
>>>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>>>
>>> ## Some observations that *do not* need to be addressed in this commit, IMHO:
>>>
>>> get_raw_handled_socket_accesses, get_current_socket_domain and
>>> current_check_access_socket are based on the similarly-named functions from
>>> net.c (and fs.c), and it makes sense to stay consistent with these.
>>>
>>> There are some possible refactorings that could maybe be applied to that code,
>>> but given that the same ones would apply to net.c as well, it's probably best to
>>> address these separately.
>>>
>>>     * Should get_raw_handled_socket_accesses be inlined
>> It's a fairly simple and compact function, so compiler should inline it
>> without any problems. Mickaël was against optional inlines [1].
>>
>> [1] https://lore.kernel.org/linux-security-module/5c6c99f7-4218-1f79-477e-5d943c9809fd@digikod.net/
> 
> Sorry for the confusion -- what I meant was not "should we add the inline
> keyword", but I meant "should we remove that function and place its
> implementation in the place where we are currently calling it"?

Oh, I got it, thanks!
It will be great to find a way how to generalize this helpers. But if
we won't come up with some good design, it will be really better to
simply inline them. I added a mark about this in code refactoring issue
[1].

[1] https://github.com/landlock-lsm/linux/issues/34

> 
> 
>>>     * Does the WARN_ON_ONCE(dom->num_layers < 1) check have the right return code?
>>
>> Looks like a rudimental check. `dom` is always NULL when `num_layers`< 1
>> (see get_*_domain functions).
> 
> What I found irritating about it is that with 0 layers (= no Landlock policy was
> ever enabled), you would logically assume that we return a success?  But then I
> realized that this code was copied verbatim from other places in fs.c and net.c,
> and it is actually checking for an internal inconsistency that is never supposed
> to happen.  If we were to actually hit that case at some point, we have probably
> stumbled over our own feet and it might be better to not permit anything.

This check is probably really useful for validating code changes.

> 
> 
>>>     * Can we refactor out commonalities (probably not worth it right now though)?
>>
>> I had a few ideas about refactoring commonalities, as currently landlock
>> has several repetitive patterns in the code. But solution requires a
>> good design and a separate patch. Probably it's worth opening an issue
>> on github. WDYT?
> 
> Absolutely, please do open one.  In my mind, patches in C which might not get
> accepted are an expensive way to iterate on such ideas, and it might make sense
> to collect some refactoring approaches on a bug or the mailing list before
> jumping into the implementation.
> 
> (You might want to keep an eye on https://github.com/landlock-lsm/linux/issues/1
> as well, which is about some ideas to refactor Landlock's internal data
> structures.)

Thank you! Discussing refactoring ideas before actually implementing
them sounds really great. We can collect multiple ideas, discuss them
and implement a single dedicated patchlist.

Issue: https://github.com/landlock-lsm/linux/issues/34.

> 
> 
>>> ## The only actionable feedback that I have that is specific to this commit is:
>>>
>>> In the past, we have introduced new (non-test) Landlock functionality in a
>>> single commit -- that way, we have no "loose ends" in the code between these two
>>> commits, and that simplifies it for people who want to patch your feature onto
>>> other kernel trees.  (e.g. I think we should maybe merge commit 01/12 and 02/12
>>> into a single commit.)  WDYT?
>>
>> Yeah, this two should be merged and tests commits as well. I just wanted
>> to do this in one of the latest patch versions to simplify code review.
> 
> That sounds good, thanks!
> 
> —Günther
