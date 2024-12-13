Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F49175AB;
	Fri, 13 Dec 2024 11:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734090131; cv=none; b=LJSZqicq4SHP5FTIE1U2gomdpQRrc3jf4HfkpMfUmVTPUYF5PRX0O6O9bAqhKH0iFCz5WI7ADOJ56kRO52PyQsuirIB0DsP4fjJmc3HCLS+BUNLUUHFPgKluT0P8iaTj/DIzbk+iZvCggZ0DEB6OtjkVzGknLEhXQvCILQy5jZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734090131; c=relaxed/simple;
	bh=/oQ6mHJZBMwmw1B1iPGf0C+f2cdxWgpcqUfqGCTkzCY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Uo8pAoNTmB2y054Ra5+gtSQ9hcieLqtGpK8HbQ5FUVkNzvP1FNbQihfwBKKwFhJF7DUwKgvQfYUC5YXZrWVpwddZ3svQ7COo+Vz4sFfpdaI3P64uuLd8605688mW3j+yE6by/pqaPbEDNG6tVnvVzgO92tHxHltER2Lcn/9Mhi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Y8nR75Hq5z6K5nd;
	Fri, 13 Dec 2024 19:38:43 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id 8CDA2140B33;
	Fri, 13 Dec 2024 19:42:05 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Fri, 13 Dec 2024 14:42:03 +0300
Message-ID: <ce8286c2-9ada-84c3-5110-4373a667b93d@huawei-partners.com>
Date: Fri, 13 Dec 2024 14:42:01 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 1/8] landlock: Fix non-TCP sockets restriction
Content-Language: ru
To: =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
CC: Matthieu Baerts <matttbe@kernel.org>, <gnoack@google.com>,
	<willemdebruijn.kernel@gmail.com>, <matthieu@buffet.re>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>, MPTCP Linux
	<mptcp@lists.linux.dev>, David Laight <David.Laight@aculab.com>
References: <20241017110454.265818-1-ivanov.mikhail1@huawei-partners.com>
 <20241017110454.265818-2-ivanov.mikhail1@huawei-partners.com>
 <49bc2227-d8e1-4233-8bc4-4c2f0a191b7c@kernel.org>
 <20241018.Kahdeik0aaCh@digikod.net> <20241204.fahVio7eicim@digikod.net>
 <20241204.acho8AiGh6ai@digikod.net>
 <a24b33c1-57c8-11bb-f3aa-32352b289a5c@huawei-partners.com>
 <20241210.Eenohkipee9f@digikod.net> <20241210.ohC4die2hi8v@digikod.net>
 <b8726b37-8819-2289-40ec-81d875b13eba@huawei-partners.com>
 <20241212.ief4eingaeVa@digikod.net>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20241212.ief4eingaeVa@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml500009.china.huawei.com (7.191.174.84) To
 mscpeml500004.china.huawei.com (7.188.26.250)

On 12/12/2024 9:43 PM, Mickaël Salaün wrote:
> On Wed, Dec 11, 2024 at 06:24:53PM +0300, Mikhail Ivanov wrote:
>> On 12/10/2024 9:05 PM, Mickaël Salaün wrote:
>>> On Tue, Dec 10, 2024 at 07:04:15PM +0100, Mickaël Salaün wrote:
>>>> On Mon, Dec 09, 2024 at 01:19:19PM +0300, Mikhail Ivanov wrote:
>>>>> On 12/4/2024 10:35 PM, Mickaël Salaün wrote:
>>>>>> On Wed, Dec 04, 2024 at 08:27:58PM +0100, Mickaël Salaün wrote:
>>>>>>> On Fri, Oct 18, 2024 at 08:08:12PM +0200, Mickaël Salaün wrote:
>>>>>>>> On Thu, Oct 17, 2024 at 02:59:48PM +0200, Matthieu Baerts wrote:
>>>>>>>>> Hi Mikhail and Landlock maintainers,
>>>>>>>>>
>>>>>>>>> +cc MPTCP list.
>>>>>>>>
>>>>>>>> Thanks, we should include this list in the next series.
>>>>>>>>
>>>>>>>>>
>>>>>>>>> On 17/10/2024 13:04, Mikhail Ivanov wrote:
>>>>>>>>>> Do not check TCP access right if socket protocol is not IPPROTO_TCP.
>>>>>>>>>> LANDLOCK_ACCESS_NET_BIND_TCP and LANDLOCK_ACCESS_NET_CONNECT_TCP
>>>>>>>>>> should not restrict bind(2) and connect(2) for non-TCP protocols
>>>>>>>>>> (SCTP, MPTCP, SMC).
>>>>>>>>>
>>>>>>>>> Thank you for the patch!
>>>>>>>>>
>>>>>>>>> I'm part of the MPTCP team, and I'm wondering if MPTCP should not be
>>>>>>>>> treated like TCP here. MPTCP is an extension to TCP: on the wire, we can
>>>>>>>>> see TCP packets with extra TCP options. On Linux, there is indeed a
>>>>>>>>> dedicated MPTCP socket (IPPROTO_MPTCP), but that's just internal,
>>>>>>>>> because we needed such dedicated socket to talk to the userspace.
>>>>>>>>>
>>>>>>>>> I don't know Landlock well, but I think it is important to know that an
>>>>>>>>> MPTCP socket can be used to discuss with "plain" TCP packets: the kernel
>>>>>>>>> will do a fallback to "plain" TCP if MPTCP is not supported by the other
>>>>>>>>> peer or by a middlebox. It means that with this patch, if TCP is blocked
>>>>>>>>> by Landlock, someone can simply force an application to create an MPTCP
>>>>>>>>> socket -- e.g. via LD_PRELOAD -- and bypass the restrictions. It will
>>>>>>>>> certainly work, even when connecting to a peer not supporting MPTCP.
>>>>>>>>>
>>>>>>>>> Please note that I'm not against this modification -- especially here
>>>>>>>>> when we remove restrictions around MPTCP sockets :) -- I'm just saying
>>>>>>>>> it might be less confusing for users if MPTCP is considered as being
>>>>>>>>> part of TCP. A bit similar to what someone would do with a firewall: if
>>>>>>>>> TCP is blocked, MPTCP is blocked as well.
>>>>>>>>
>>>>>>>> Good point!  I don't know well MPTCP but I think you're right.  Given
>>>>>>>> it's close relationship with TCP and the fallback mechanism, it would
>>>>>>>> make sense for users to not make a difference and it would avoid bypass
>>>>>>>> of misleading restrictions.  Moreover the Landlock rules are simple and
>>>>>>>> only control TCP ports, not peer addresses, which seems to be the main
>>>>>>>> evolution of MPTCP.
>>>>>>>
>>>>>>> Thinking more about this, this makes sense from the point of view of the
>>>>>>> network stack, but looking at external (potentially bogus) firewalls or
>>>>>>> malware detection systems, it is something different.  If we don't
>>>>>>> provide a way for users to differenciate the control of SCTP from TCP,
>>>>>>> malicious use of SCTP could still bypass this kind of bogus security
>>>>>>> appliances.  It would then be safer to stick to the protocol semantic by
>>>>>>> clearly differenciating TCP from MPTCP (or any other protocol).
>>>>>
>>>>> You mean that these firewals have protocol granularity (e.g. different
>>>>> restrictions for MPTCP and TCP sockets)?
>>>>
>>>> Yes, and more importantly they can miss the MTCP semantic and then not
>>>> properly filter such packet, which can be use to escape the network
>>>> policy.  See some issues here:
>>>> https://en.wikipedia.org/wiki/Multipath_TCP
>>>>
>>>> The point is that we cannot assume anything about other networking
>>>> stacks, and if Landlock can properly differentiate between TCP and MTCP
>>>> (e.g. with new LANDLOCK_ACCESS_NET_CONNECT_MTCP) users of such firewalls
>>>> could still limit the impact of their firewall's bugs.  However, if
>>>> Landlock treats TCP and MTCP the same way, we'll not be able to only
>>>> deny MTCP.  In most use cases, the network policy should treat both TCP
>>>> and MTCP the same way though, but we should let users decide according
>>>> to their context.
>>>>
>>>>   From an implementation point of view, adding MTCP support should be
>>>> simple, mainly tests will grow.
>>>
>>> s/MTCP/MPTCP/g of course.
>>
>> That's reasonable, thanks for explanation!
>>
>> We should also consider control of other protocols that use TCP
>> internally [1], since it should be easy to bypass TCP restriction by
>> using them (e.g. provoking a fallback of MPTCP or SMC connection to
>> TCP).
>>
>> The simplest solution is to implement separate access rights for SMC and
>> RDS, as well as for MPTCP. I think we should stick to it.
>>
>> I was worried if there was a case where it would be useful to allow only
>> SMC (and deny TCP). If there are any, it would be more correct to
>> restrict only the fallback SMC -> TCP with TCP access rights. But such
>> logic seems too complicated for the kernel and implicit for SMC
>> applications that can rely on a TCP connection.
>>
>> [1] https://lore.kernel.org/all/62336067-18c2-3493-d0ec-6dd6a6d3a1b5@huawei-partners.com/
> 
> Let's continue the discussion on this thread.
> 
>>
>>>
>>>>
>>>>>
>>>>>>>
>>>>>>> Mikhail, could you please send a new patch series containing one patch
>>>>>>> to fix the kernel and another to extend tests?
>>>>>>
>>>>>> No need to squash them in one, please keep the current split of the test
>>>>>> patches.  However, it would be good to be able to easily backport them,
>>>>>> or at least the most relevant for this fix, which means to avoid
>>>>>> extended refactoring.
>>>>>
>>>>> No problem, I'll remove the fix of error consistency from this patchset.
>>>>> BTW, what do you think about second and third commits? Should I send the
>>>>> new version of them as well (in separate patch)?
>>>>
>>>> According to the description, patch 2 may be included in this series if
>>>> it can be tested with any other LSM, but I cannot read these patches:
>>>> https://lore.kernel.org/all/20241017110454.265818-3-ivanov.mikhail1@huawei-partners.com/
>>
>> Ok I'll do this, since this patch doesn't make any functional changes.
>>
>> About readability, a lot of code blocks were moved in this patch, and
>> because of this, the regular diff file has become too unreadable.
>> So, I decided to re-generate it with --break-rewrites option of git
>> format- patch. Do you have any advice on how best to compose a diff for
>> this patch?
> 
> The changes are not clear to me so I don't know.  If a lot of parts are
> changed, maybe splitting this patch into a few patches would help.  I'm
> a bit worried that too much parts are changed though.

Mostly, there are just bind() and connect() related checks moved to
hook_socket_{connect, bind}.

I think I'd better move all refactoring-related fixes to a separate
patchset.

> 
> When I try to apply this series I get:
> 
>    Patch failed at 0002 landlock: Make network stack layer checks explicit
>    for each TCP action
>    error: patch failed: security/landlock/net.c:1
>    error: security/landlock/net.c: patch does not apply

Sorry, it looks like patches created using the --break-rewrites option
of git format can only be applied manually. I'll try to split this patch
in v3 so that it can be applied automatically.
