Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5CD215F4B;
	Mon,  9 Dec 2024 10:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733739569; cv=none; b=bUiDdnWiM+lXFf8hX4QbTfUjsrWqzJ40SZLV0bKTlSi6uzIgfr8QXkwY1UmUi+aOZ5y1yWDzVdBIbgvEW12j1sp4JYdWybRO8kyP5UGVFGdWq96DxMdAm2c26iNIXD4Kk0m/Aidu552NIL9VnUxWTU4LQ39mZ8wALmOeXx/JlKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733739569; c=relaxed/simple;
	bh=ir0eMn2cU5E1ZYPf41J9jPgI7dgJxqUiO/AYVDz2kdI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=UtVvxwuehjJeRvRMjHOw6FhoCBCItaURXmR6QrilOWZ/qyPm8TJcUOrLLiGiNVcYUN5HM+hSffuy3Wg57Y434zYMIC3CdE+LSe6saX4lpMksQsX45QEwnBBKWmj53BSuy7x8YmW1R2bMrwhl2Z73PviMSZKpL3aXAn73aK3rMzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Y6Hnn6XVrz6K9NY;
	Mon,  9 Dec 2024 18:16:13 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id 38B411403A1;
	Mon,  9 Dec 2024 18:19:24 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Mon, 9 Dec 2024 13:19:21 +0300
Message-ID: <a24b33c1-57c8-11bb-f3aa-32352b289a5c@huawei-partners.com>
Date: Mon, 9 Dec 2024 13:19:19 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 1/8] landlock: Fix non-TCP sockets restriction
Content-Language: ru
To: =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, Matthieu Baerts
	<matttbe@kernel.org>
CC: <gnoack@google.com>, <willemdebruijn.kernel@gmail.com>,
	<matthieu@buffet.re>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>, MPTCP Linux <mptcp@lists.linux.dev>, David
 Laight <David.Laight@aculab.com>
References: <20241017110454.265818-1-ivanov.mikhail1@huawei-partners.com>
 <20241017110454.265818-2-ivanov.mikhail1@huawei-partners.com>
 <49bc2227-d8e1-4233-8bc4-4c2f0a191b7c@kernel.org>
 <20241018.Kahdeik0aaCh@digikod.net> <20241204.fahVio7eicim@digikod.net>
 <20241204.acho8AiGh6ai@digikod.net>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20241204.acho8AiGh6ai@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 mscpeml500004.china.huawei.com (7.188.26.250)

On 12/4/2024 10:35 PM, Mickaël Salaün wrote:
> On Wed, Dec 04, 2024 at 08:27:58PM +0100, Mickaël Salaün wrote:
>> On Fri, Oct 18, 2024 at 08:08:12PM +0200, Mickaël Salaün wrote:
>>> On Thu, Oct 17, 2024 at 02:59:48PM +0200, Matthieu Baerts wrote:
>>>> Hi Mikhail and Landlock maintainers,
>>>>
>>>> +cc MPTCP list.
>>>
>>> Thanks, we should include this list in the next series.
>>>
>>>>
>>>> On 17/10/2024 13:04, Mikhail Ivanov wrote:
>>>>> Do not check TCP access right if socket protocol is not IPPROTO_TCP.
>>>>> LANDLOCK_ACCESS_NET_BIND_TCP and LANDLOCK_ACCESS_NET_CONNECT_TCP
>>>>> should not restrict bind(2) and connect(2) for non-TCP protocols
>>>>> (SCTP, MPTCP, SMC).
>>>>
>>>> Thank you for the patch!
>>>>
>>>> I'm part of the MPTCP team, and I'm wondering if MPTCP should not be
>>>> treated like TCP here. MPTCP is an extension to TCP: on the wire, we can
>>>> see TCP packets with extra TCP options. On Linux, there is indeed a
>>>> dedicated MPTCP socket (IPPROTO_MPTCP), but that's just internal,
>>>> because we needed such dedicated socket to talk to the userspace.
>>>>
>>>> I don't know Landlock well, but I think it is important to know that an
>>>> MPTCP socket can be used to discuss with "plain" TCP packets: the kernel
>>>> will do a fallback to "plain" TCP if MPTCP is not supported by the other
>>>> peer or by a middlebox. It means that with this patch, if TCP is blocked
>>>> by Landlock, someone can simply force an application to create an MPTCP
>>>> socket -- e.g. via LD_PRELOAD -- and bypass the restrictions. It will
>>>> certainly work, even when connecting to a peer not supporting MPTCP.
>>>>
>>>> Please note that I'm not against this modification -- especially here
>>>> when we remove restrictions around MPTCP sockets :) -- I'm just saying
>>>> it might be less confusing for users if MPTCP is considered as being
>>>> part of TCP. A bit similar to what someone would do with a firewall: if
>>>> TCP is blocked, MPTCP is blocked as well.
>>>
>>> Good point!  I don't know well MPTCP but I think you're right.  Given
>>> it's close relationship with TCP and the fallback mechanism, it would
>>> make sense for users to not make a difference and it would avoid bypass
>>> of misleading restrictions.  Moreover the Landlock rules are simple and
>>> only control TCP ports, not peer addresses, which seems to be the main
>>> evolution of MPTCP.
>>
>> Thinking more about this, this makes sense from the point of view of the
>> network stack, but looking at external (potentially bogus) firewalls or
>> malware detection systems, it is something different.  If we don't
>> provide a way for users to differenciate the control of SCTP from TCP,
>> malicious use of SCTP could still bypass this kind of bogus security
>> appliances.  It would then be safer to stick to the protocol semantic by
>> clearly differenciating TCP from MPTCP (or any other protocol).

You mean that these firewals have protocol granularity (e.g. different
restrictions for MPTCP and TCP sockets)?

>>
>> Mikhail, could you please send a new patch series containing one patch
>> to fix the kernel and another to extend tests?
> 
> No need to squash them in one, please keep the current split of the test
> patches.  However, it would be good to be able to easily backport them,
> or at least the most relevant for this fix, which means to avoid
> extended refactoring.

No problem, I'll remove the fix of error consistency from this patchset.
BTW, what do you think about second and third commits? Should I send the
new version of them as well (in separate patch)?
