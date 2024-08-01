Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE49213E02D;
	Thu,  1 Aug 2024 11:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722512719; cv=none; b=DQvH+ZmBgGjpJXELg8g5MypiqCK+S5roBMTvGFR25ISYtCbzWLyXqW4niNOFoH2HBP7RUyKeTnRDRY0sSvgxNxeNQldBegThfW+HSkNPS7amftWNhKSGZO7uqz4SDeM2Ua7x4yBl+mxRw6yQMl1zDKcCYSptg5zCUsQy3zZZY6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722512719; c=relaxed/simple;
	bh=ZFMoUzY5E8lLLv4LL/iZum5Y0YaLE+OHzfNurcyxX5E=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=MDwGtFFojETHwncPOj2+6zDd9wNSsBqDYxbWPTgRrkXK3tRnFB9VjBwgCjgoYcVKt5poPM1Q+lFLlFuT+OoAm3RJ5ZZn10bF1QQTu3Ws+1xctuADUKf1xDRyYKl5dpqtpld/tnsgCWcCga5Dxl74WmqDS1Jm/+GKBwDWu+Riu0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4WZRwD3JGVz1L9Ff;
	Thu,  1 Aug 2024 19:45:00 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 23491180AE5;
	Thu,  1 Aug 2024 19:45:13 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 1 Aug 2024 19:45:09 +0800
Message-ID: <51b6b614-66d7-1acc-a676-b7302537e1fb@huawei-partners.com>
Date: Thu, 1 Aug 2024 14:45:04 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 2/9] landlock: Support TCP listen access-control
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>, <alx@kernel.org>
References: <20240728002602.3198398-1-ivanov.mikhail1@huawei-partners.com>
 <20240728002602.3198398-3-ivanov.mikhail1@huawei-partners.com>
 <ZqijJPrnCnGnVGkq@google.com>
 <0a3b8596-f3f3-f617-c40d-de54e8ff05f0@huawei-partners.com>
 <ZqtlJZMHVf-otlOq@google.com>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZqtlJZMHVf-otlOq@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
 dggpemm500020.china.huawei.com (7.185.36.49)

8/1/2024 1:36 PM, Günther Noack wrote:
> On Wed, Jul 31, 2024 at 08:20:41PM +0300, Mikhail Ivanov wrote:
>> 7/30/2024 11:24 AM, Günther Noack wrote:
>>> On Sun, Jul 28, 2024 at 08:25:55AM +0800, Mikhail Ivanov wrote:
>>>> LANDLOCK_ACCESS_NET_BIND_TCP is useful to limit the scope of "bindable"
>>>> ports to forbid a malicious sandboxed process to impersonate a legitimate
>>>> server process. However, bind(2) might be used by (TCP) clients to set the
>>>> source port to a (legitimate) value. Controlling the ports that can be
>>>> used for listening would allow (TCP) clients to explicitly bind to ports
>>>> that are forbidden for listening.
>>>>
>>>> Such control is implemented with a new LANDLOCK_ACCESS_NET_LISTEN_TCP
>>>> access right that restricts listening on undesired ports with listen(2).
>>>
>>> Nit: I would turn around the first two commit message paragraphs and describe
>>> your changes first, before explaining the problems in the bind(2) support.  I
>>> was initially a bit confused that the description started talking about
>>> LANDLOCK_ACCESS_NET_BIND_TCP.
>>>
>>> General recommendations at:
>>> https://www.kernel.org/doc/html/v6.10/process/submitting-patches.html#describe-your-changes
>>
>> I consider the first paragraph as a problem statement for this patch.
>> According to linux recommendations problem should be established before
>> the description of changes. Do you think that the changes part should
>> stand before the problem anyway?
> 
> Up to you. To be fair, I'm sold on the approach in this patchset anyway :)

Nice :)

> 
> 
>>> When we have the documentation wording finalized,
>>> please send an update to the man pages as well,
>>> for this and other documentation updates.
>>
>> Should I send it after this patchset would be accepted?
> 
> Yes, that would be the normal process which we have been following so far.
> 
> (I don't like the process much either, because it decouples feature development
> so far from documentation writing, but it's what we have for now.)
> 
> An example patch which does that for the network bind(2) and connect(2) features
> (and where I would still like a review from Konstantin) is:
> https://lore.kernel.org/all/20240723101917.90918-1-gnoack@google.com/

got it

> 
> 
>>> Small remarks on what I've done here:
>>>
>>> * I am avoiding the word "binding" when referring to the automatic assignment to
>>>     an ephemeral port - IMHO, this is potentially confusing, since bind(2) is not
>>>     explicitly called.
>>> * I am also dropping the "It should be noted" / "Note that" phrase, which is
>>>     frowned upon in man pages.
>>
>> Didn't know that, thanks
> 
> Regarding "note that", see
> https://lore.kernel.org/all/0aafcdd6-4ac7-8501-c607-9a24a98597d7@gmail.com/
> https://lore.kernel.org/linux-man/20210729223535.qvyomfqvvahzmu5w@localhost.localdomain/
> https://lore.kernel.org/linux-man/20230105225235.6cjtz6orjzxzvo6v@illithid/
> (The "Kemper notectomy")
> 
> This came up in man page reviews, but we'll have an easier time keeping the
> kernel and man page documentation in sync if we adhere to man page style
> directly.  (The man page style is documented in man-pages(7) and contains some
> groff-independent wording advice as well.)

Ok, such phrases should be really avoided in kernel as well.

> 
> 
>>> If I understand correctly, these are cases where we use TCP on top of protocols
>>> that are not IP (or have an additional layer in the middle, like TLS?).  This
>>> can not be recognized through the socket family or type?
>>
>> ULP can be used in the context of TCP protocols as an additional layer
>> (currently supported only by IP and MPTCP), so it cannot be recognized
>> with family or type. You can check this test [1] in which TCP IP socket
>> is created with ULP control hook.
>>
>> [1] https://lore.kernel.org/all/20240728002602.3198398-8-ivanov.mikhail1@huawei-partners.com/
> 
> Thanks, this is helpful.
> 
> For reference, it seems that ULP were introduced in
> https://lore.kernel.org/all/20170614183714.GA80310@davejwatson-mba.dhcp.thefacebook.com/
> 
> 
>>> Do we have cases where we can run TCP on top of something else than plain IPv4
>>> or IPv6, where the clone method exists?
>>
>> Yeah, MPTCP protocol for example (see net/mptcp/subflow.c). ULP control
>> hook is supported only by IP and MPTCP, and in both cases
>> clone method is checked during listen(2) execution.
> 
> 
>>> Aren't the socket type and family checks duplicated with existing logic that we
>>> have for the connect(2) and bind(2) support?  Should it be deduplicated, or is
>>> that too messy?
>>
>> bind(2) and connect(2) hooks also support AF_UNSPEC family, so I think
>> such helper is gonna complicate code a little bit. Also it can
>> complicate switch in current_check_access_socket().
> 
> OK, sounds good. 👍
> 
> —Günther
