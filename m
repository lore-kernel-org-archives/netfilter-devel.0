Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A6D1B32A8;
	Thu,  1 Aug 2024 16:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722528435; cv=none; b=aqVtqBgQb3N2Vq3BRrYYAR2NnUZxIdDyvUIJ1KR8PWeQlisbv2z3ogHQvM9WZXrinzsb042OcaM7JxMhf/RKgeq9e2d8CAvo+4jn3DZsWC6NMYa6O+u20Z+g+6IG9J+4qyAIEu2uNhT04i9eOXBSQ4Ijh/z3TPzGzzcwz7nRx6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722528435; c=relaxed/simple;
	bh=bixVSSRoXHBvRRJby/jKQbob1oz3+FTnSMtRYK4gGv4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=LVl9bRQmNQOCbTqCnfqPfbXLgX39B9DrRA+pee1ogr+7Xi5qo7xy9d632pXrjMk/tqr/d8AdgqpphUjCdT0LJAhBCoIzSBKGJoTXNFvnpkaCySqIRM6sjhP9xXmVBCEL02Wq0U0t5MQ6/DwADoeN349hloJ4Orpb1RToEVjVPXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WZYkT5cRZzxVvR;
	Fri,  2 Aug 2024 00:06:57 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 0105D1800A0;
	Fri,  2 Aug 2024 00:07:11 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 2 Aug 2024 00:07:07 +0800
Message-ID: <35e1e1fb-7252-fcc5-7348-2a8a485efcce@huawei-partners.com>
Date: Thu, 1 Aug 2024 19:07:03 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 2/9] landlock: Support TCP listen access-control
Content-Language: ru
To: =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
References: <20240728002602.3198398-1-ivanov.mikhail1@huawei-partners.com>
 <20240728002602.3198398-3-ivanov.mikhail1@huawei-partners.com>
 <20240731.AFooxaeR5mie@digikod.net>
 <68568a44-2079-33ac-592d-c2677acf50dd@huawei-partners.com>
 <20240801.EeshaeThai9j@digikod.net>
 <7c8ed332-c4ec-81e7-a94a-e1b62d820dd3@huawei-partners.com>
 <20240801.eeBaiB4Ijion@digikod.net>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20240801.eeBaiB4Ijion@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100001.china.huawei.com (7.191.160.183) To
 dggpemm500020.china.huawei.com (7.185.36.49)

8/1/2024 7:01 PM, Mickaël Salaün wrote:
> On Thu, Aug 01, 2024 at 06:34:41PM +0300, Mikhail Ivanov wrote:
>> 8/1/2024 5:45 PM, Mickaël Salaün wrote:
>>> On Thu, Aug 01, 2024 at 10:52:25AM +0300, Mikhail Ivanov wrote:
>>>> 7/31/2024 9:30 PM, Mickaël Salaün wrote:
>>>>> On Sun, Jul 28, 2024 at 08:25:55AM +0800, Mikhail Ivanov wrote:
>>>>>> LANDLOCK_ACCESS_NET_BIND_TCP is useful to limit the scope of "bindable"
>>>>>> ports to forbid a malicious sandboxed process to impersonate a legitimate
>>>>>> server process. However, bind(2) might be used by (TCP) clients to set the
>>>>>> source port to a (legitimate) value. Controlling the ports that can be
>>>>>> used for listening would allow (TCP) clients to explicitly bind to ports
>>>>>> that are forbidden for listening.
>>>>>>
>>>>>> Such control is implemented with a new LANDLOCK_ACCESS_NET_LISTEN_TCP
>>>>>> access right that restricts listening on undesired ports with listen(2).
>>>>>>
>>>>>> It's worth noticing that this access right doesn't affect changing
>>>>>> backlog value using listen(2) on already listening socket.
>>>>>>
>>>>>> * Create new LANDLOCK_ACCESS_NET_LISTEN_TCP flag.
>>>>>> * Add hook to socket_listen(), which checks whether the socket is allowed
>>>>>>      to listen on a binded local port.
>>>>>> * Add check_tcp_socket_can_listen() helper, which validates socket
>>>>>>      attributes before the actual access right check.
>>>>>> * Update `struct landlock_net_port_attr` documentation with control of
>>>>>>      binding to ephemeral port with listen(2) description.
>>>>>> * Change ABI version to 6.
>>>>>>
>>>>>> Closes: https://github.com/landlock-lsm/linux/issues/15
>>>>>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>>>>>
>>>>> Thanks for this series!
>>>>>
>>>>> I cannot apply this patch series though, could you please provide the
>>>>> base commit?  BTW, this can be automatically put in the cover letter
>>>>> with the git format-patch's --base argument.
>>>>
>>>> base-commit: 591561c2b47b7e7225e229e844f5de75ce0c09ec
>>>
>>> Thanks, the following commit makes this series to not apply.
>>
>> Sorry, you mean that the series are succesfully applied, right?
> 
> Yes, it works with the commit you provided.  I was talking about a next
> (logical) commit f4b89d8ce5a8 ("landlock: Various documentation
> improvements") which makes your series not apply, but that's OK now.
Nice
