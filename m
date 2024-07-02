Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45AF116C6A2;
	Tue,  2 Jul 2024 12:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719924224; cv=none; b=kfnigZiNY9d9VnFFiIjt3MTCcTAk6Pfn6vzg+TS2vWWi5cKqEQa0PjZkIOSADDMqvICIpeACHDrgs4MuP7cabzgYDeNsYOgSFqYc6vhBKr0ui3Q7fd1sPqLkTFuB0XJH/Q0UMEzFU+i09kh93RtgVG6jVLtNwk0wsKyjc0luCA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719924224; c=relaxed/simple;
	bh=+4pUZI8Vh3YIUfOxi6pW0WIBII4dOgHNC8SzYkgDUCw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=WKxKPHBin60m4bVMw1UVVCRSr5kcNS7aWzk8cubNJt7H9XGc8o+e6qOhX/biDeYh4dqNHvFO9ARqfTzX496RW9URGW6rqctO+mjU+tcQAlYbIBeuNNzWj7jTX/ZuPgV+xlWMlvRH4l+Fgjwx2cMhkUKtZrVbBL0p7m8I0Xh+sQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4WD2XV3dNTz1T4H3;
	Tue,  2 Jul 2024 20:39:06 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 9B3241400CD;
	Tue,  2 Jul 2024 20:43:38 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 2 Jul 2024 20:43:34 +0800
Message-ID: <9943a87b-b981-794a-2c3d-b8dc143fe3e9@huawei-partners.com>
Date: Tue, 2 Jul 2024 15:43:21 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] landlock: Add hook on socket_listen()
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
	<willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
References: <20240408094747.1761850-1-ivanov.mikhail1@huawei-partners.com>
 <20240408094747.1761850-2-ivanov.mikhail1@huawei-partners.com>
 <20240425.Soot5eNeexol@digikod.net>
 <a18333c0-4efc-dcf4-a219-ec46480352b1@huawei-partners.com>
 <ZnMr30kSCGME16rO@google.com>
 <b2d1a152-0241-6a3a-1f31-4a1045fff856@huawei-partners.com>
 <ZoKB7bl41ZOiiXmF@google.com>
 <bd2622cf-27e2-dbb6-735a-0adf6c79b339@huawei-partners.com>
 <ZoLPhQ4eyl0H_oSQ@google.com>
From: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZoLPhQ4eyl0H_oSQ@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100001.china.huawei.com (7.191.160.183) To
 dggpemm500020.china.huawei.com (7.185.36.49)

7/1/2024 6:47 PM, Günther Noack wrote:
> On Mon, Jul 01, 2024 at 04:10:27PM +0300, Ivanov Mikhail wrote:
>> Thanks for the great explanation! We're on the same page.
>>
>> Considering that binding to ephemeral ports can be done not only with
>> bind() or listen(), I think your approach is more correct.
>> Restricting any possible binding to ephemeral ports just using
>> LANDLOCK_ACCESS_NET_BIND_TCP wouldn't allow sandboxed processes
>> to deny listen() without pre-binding (which is quite unsafe) and
>> use connect() in the usuall way (without pre-binding).
>>
>> Controlling ephemeral ports allocation for listen() can be done in the
>> same way as for LANDLOCK_ACCESS_NET_BIND_TCP in the patch with
>> LANDLOCK_ACCESS_NET_LISTEN_TCP access right implementation.
> 
> That sounds good, yes! 👍
> 
> 
>> I'm only concerned about controlling the auto-binding for other
>> operations (such as connect() and sendto() for UDP). As I said, I think
>> this can also be useful: users will be able to control which processes
>> are allowed to use ephemeral ports from ip_local_port_range and which
>> are not, and they must assign ports for each operation explicitly. If
>> you agree that such control is reasonable, we'll probably  have to
>> consider some API changes, since such control is currently not possible.
>>
>> We should clarify this before I send a patch with the
>> LANDLOCK_ACCESS_NET_LISTEN_TCP implementation. WDYT?
> 
> LANDLOCK_ACCESS_NET_LISTEN_TCP seems like the most important to me.
> 
> For connect() and sendto(), I think the access rights are less urgent:
> 
> connect(): We already have LANDLOCK_ACCESS_NET_CONNECT_TCP, but that one is
> getting restricted for the *remote* port number.
> 
>   (a) I think it would be possible to do the same for the *local* port number, by
>       introducing a separate LANDLOCK_ACCESS_NET_CONNECT_TCP_LOCALPORT right.
>       (Yes, the name is absolutely horrible, this is just for the example :))
>       hook_socket_connect() would then need to do both a check for the remote
>       port using LANDLOCK_ACCESS_NET_CONNECT_TCP, as it already does today, as
>       well as a check for the (previously bound?) local port using
>       LANDLOCK_ACCESS_NET_CONNECT_TCP_LOCALPORT.
>       
>       So I think it is extensible in that direction, in principle, even though I
>       don't currently have a good name for that access right. :)

Indeed, implementing a new type of rule seems to be an optimal approach
for this.

>       
>   (b) Compared to what LANDLOCK_ACCESS_NET_BIND_TCP already restricts, a
>       hypothetical LANDLOCK_ACCESS_NET_CONNECT_TCP_LOCALPORT right would only
>       additionally restrict the use of ephemeral ports.  I'm currently having a
>       hard time seeing what an attacker could do with that (use up all ephemeral
>       ports?).

I thought about something like that, yeah) Also, I tried to find out
if there are cases where port remains bound to the client socket after
the connection is completed. In this case, listen() can be called to a
socket with a port bound via connect() call. In the case of TCP, such
scenario is not possible, port is always deallocated in tcp_set_state()
method.

So, I don't see any realworld vulnerabilities, we can leave this case
until someone comes up with a real issue.

> 
> sendto(): I think this is not relevant yet, because as the documentation said,
> ephemeral ports are only handed out when sendto() is used with datagram (UDP)
> sockets.
> 
> Once Landlock starts having UDP support, this would become relevant, but for
> this patch set, I think that the TCP server use case as discussed further above
> in this thread is very compelling.

Agreed. Anyway, if someone finds any interesting cases with
auto-binding via sendto(), we can implement a new rule, as you suggested
for connect().

Thanks you for your research and ideas, Günther!
I'll prepare the LANDLOCK_ACCESS_NET_LISTEN_TCP patchset for the review.

> 
> Thanks,
> —Günther
