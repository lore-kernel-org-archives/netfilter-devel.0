Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC7A190472;
	Tue, 20 Aug 2024 13:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724161996; cv=none; b=UNAtgq7Xj1/IBI7Tooy20OoKUr7qzeWTtWwja80GfF3NKZ1EXw6SJ//XtiKu9CWy5BbFyiNKHLlB8pX1DDo+Qynds2tti5CwdodrzhSiSqwgR34pLlHm2krPmUqhffklxrMy//ILUzHRMUgK/xALGTUOqTK2kp3oUJ7WMApq+2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724161996; c=relaxed/simple;
	bh=3lJJWdkx6YDESRHCE0RBUg1PINl4+gnroJeCALwHgCw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=M4VZ96hqAKYiPJOipNmGPXjxSJUFW4XNXkhxFcEhp+dhbWKF+ZbDIDZHhowmfKyid9eIA7vWMWkwomITC18w7yx9IEz/Lc3NCCKDrybimJy1lp4PxtBBfRr+tC2G3/DwXyHmdeVP1x368AG7yS2NWlGGXVKRgsPpS3EUbnugqyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Wp9lx2lyVz20m9G;
	Tue, 20 Aug 2024 21:48:29 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 189F01401F4;
	Tue, 20 Aug 2024 21:53:10 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 20 Aug 2024 21:53:06 +0800
Message-ID: <39867bdf-c41b-7ab6-a190-cb557e077f2b@huawei-partners.com>
Date: Tue, 20 Aug 2024 16:53:01 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/9] Support TCP listen access-control
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20240814030151.2380280-1-ivanov.mikhail1@huawei-partners.com>
 <ZsSV6-o1guJdpPfu@google.com> <ZsSYu8kV9l-OTUnF@google.com>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZsSYu8kV9l-OTUnF@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100001.china.huawei.com (7.191.160.183) To
 dggpemm500020.china.huawei.com (7.185.36.49)

8/20/2024 4:23 PM, Günther Noack wrote:
> On Tue, Aug 20, 2024 at 03:11:07PM +0200, Günther Noack wrote:
>> Hello!
>>
>> Thanks for sending v2 of this patchset!
>>
>> On Wed, Aug 14, 2024 at 11:01:42AM +0800, Mikhail Ivanov wrote:
>>> Hello! This is v2 RFC patch dedicated to restriction of listening sockets.
>>>
>>> It is based on the landlock's mic-next branch on top of 6.11-rc1 kernel
>>> version.
>>>
>>> Description
>>> ===========
>>> LANDLOCK_ACCESS_NET_BIND_TCP is useful to limit the scope of "bindable"
>>> ports to forbid a malicious sandboxed process to impersonate a legitimate
>>> server process. However, bind(2) might be used by (TCP) clients to set the
>>> source port to a (legitimate) value. Controlling the ports that can be
>>> used for listening would allow (TCP) clients to explicitly bind to ports
>>> that are forbidden for listening.
>>>
>>> Such control is implemented with a new LANDLOCK_ACCESS_NET_LISTEN_TCP
>>> access right that restricts listening on undesired ports with listen(2).
>>>
>>> It's worth noticing that this access right doesn't affect changing
>>> backlog value using listen(2) on already listening socket. For this case
>>> test ipv4_tcp.double_listen is provided.
>>
>> This is a good catch, btw, that seems like the right thing to do. 👍
>>
>>
>> I am overall happy with this patch set, but left a few remarks in the tests so
>> far.  There are a few style nits here and there.
>>
>> A thing that makes me uneasy is that the tests have a lot of logic in
>> test_restricted_net_fixture(), where instead of the test logic being
>> straightforward, there are conditionals to tell apart different scenarios and
>> expect different results.  I wish that the style of these tests was more linear.
>> This patch set is making it a little bit worse, because the logic in
>> test_restricted_net_fixture() increases.
>>
>> I have also made some restructuring suggestions for the kernel code, in the hope
>> that they simplify things.  If they don't because I overlooked something, we can
>> skip that though.
> 
> I missed to mention it -- the documentation in
> Documentation/userspace-api/landlock.rst needs updating as well.

I'll do it. Thank you for reviewing this patch set!

> 
> —Günther
