Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4990522F19;
	Thu,  3 Oct 2024 17:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727976465; cv=none; b=XxWwdX3mq6dPKzEsvoS6lm6MR+d+trSn5dyIY9dzJLP1RDgGGKcYv19CLeDxIT7S3YA+LVIdmbIOJaxWjePpdbgTsgdZApK54WatauDTm3xy4/w7o38toLJpXCzU8AenobLR8Wl00pM/486h/X6U0jqA1ZGGXDQPG1yMB2mhvGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727976465; c=relaxed/simple;
	bh=/2iaXVnZb/DUK9vNr/IKPO18H2SenOVe3Y9jHmJjMTM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=pWyTVTi76lmSOJVNZ8S2Qf1viYqnm8+vJpSdetyo3Lzq5mYNXr6D3RhXjKKOAlwbMwc1yyt8+YTwBaECJx15rOeZH04dAoJRLcJHjLxJQyOm26WPSPOJw3LAHANoGn8ysSdLG0XFcW5R+TOlR3iFn9PAezXoMsKMd6o+7GWw/p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XKJV84HsqzpWHW;
	Fri,  4 Oct 2024 01:25:36 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 8375A18010F;
	Fri,  4 Oct 2024 01:27:37 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 4 Oct 2024 01:27:33 +0800
Message-ID: <4a75e311-0e5d-2046-f71a-5535bb2db22b@huawei-partners.com>
Date: Thu, 3 Oct 2024 20:27:28 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 14/19] selftests/landlock: Test socketpair(2)
 restriction
Content-Language: ru
To: =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
	=?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>, Matthieu Buffet
	<matthieu@buffet.re>
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
 <20240904104824.1844082-15-ivanov.mikhail1@huawei-partners.com>
 <ZurZ7nuRRl0Zf2iM@google.com>
 <220a19f6-f73c-54ef-1c4d-ce498942f106@huawei-partners.com>
 <ZvZ_ZjcKJPm5B3_Z@google.com> <Zvhh3CRj9T7_KIhC@google.com>
 <20240929.Noovae0izai8@digikod.net>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20240929.Noovae0izai8@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 kwepemj200016.china.huawei.com (7.202.194.28)

On 9/29/2024 8:31 PM, Mickaël Salaün wrote:
> On Sat, Sep 28, 2024 at 10:06:52PM +0200, Günther Noack wrote:
>> On Fri, Sep 27, 2024 at 11:48:22AM +0200, Günther Noack wrote:
>>> On Mon, Sep 23, 2024 at 03:57:47PM +0300, Mikhail Ivanov wrote:
>>>> (Btw I think that disassociation control can be really useful. If
>>>> it were possible to restrict this action for each protocol, we would
>>>> have stricter control over the protocols used.)
>>>
>>> In my understanding, the disassociation support is closely intertwined with the
>>> transport layer - the last paragraph of DESCRIPTION in connect(2) is listing
>>> TCP, UDP and Unix Domain sockets in datagram mode. -- The relevant code in in
>>> net/ipv4/af_inet.c in inet_dgram_connect() and __inet_stream_connect(), where
>>> AF_UNSPEC is handled.
>>>
>>> I would love to find a way to restrict this independent of the specific
>>> transport protocol as well.
>>>
>>> Remark on the side - in af_inet.c in inet_shutdown(), I also found a worrying
>>> scenario where the same sk->sk_prot->disconnect() function is called and
>>> sock->state also gets reset to SS_UNCONNECTED.  I have done a naive attempt to
>>> hit that code path by calling shutdown() on a passive TCP socket, but was not
>>> able to reuse the socket for new connections afterwards. (Have not debugged it
>>> further though.)  I wonder whether this is a scnenario that we also need to
>>> cover?
>>
>> FYI, **this does turn out to work** (I just fumbled in my first experiment). --
>> It is possible to reset a listening socket with shutdown() into a state where it
>> can be used for at least a new connect(2), and maybe also for new listen(2)s.
> 
> Interesting syscall...
> 
>>
>> The same might also be possible if a socket is in the TCP_SYN_SENT state at the
>> time of shutdown() (although that is a bit trickier to try out).
>>
>> So a complete disassociation control for TCP/IP might not only need to have
>> LANDLOCK_ACCESS_SOCKET_CONNECT_UNSPEC (or however we'd call it), but also
>> LANDLOCK_ACCESS_SOCKET_PASSIVE_SHUTDOWN and maybe even another one for the
>> TCP_SYN_SENT case...? *
> 
> That would make the Landlock interface too complex, we would need a more
> generic approach instead e.g. with a single flag.
> 
>>
>> It makes me uneasy to think that I only looked at AF_INET{,6} and TCP so far,
>> and that other protocols would need a similarly close look.  It will be
>> difficult to cover all the "disassociation" cases in all the different
>> protocols, and even more difficult to detect new ones when they pop up.  If we
>> discover new ones and they'd need new Landlock access rights, it would also
>> potentially mean that existing Landlock users would have to update their rules
>> to spell that out.
>>
>> It might be easier after all to not rely on "disassociation" control too much
>> and instead to design the network-related access rights in a way so that we can
>> provide the desired sandboxing guarantees by restricting the "constructive"
>> operations (the ones that initiate new network connections or that listen on the
>> network).
> 
> I agree.  So, with the ability to control socket creation and to also
> control listen/bind/connect (and sendmsg/recvmsg for datagram protocols)
> we should be good right?
> 
>>
>> Mikhail, in your email I am quoting above, you are saying that "disassociation
>> control can be really useful"; do you know of any cases where a restriction of
>> connect/listen is *not* enough and where you'd still want the disassociation
>> control?

Disassociation is basically about making socket be able to connect or
listen (again). If these actions are already controlled, disassociation
should always be permitted (as it's currently implemented for TCP
connect).

I thought that LANDLOCK_ACCESS_SOCKET_CONNECT_UNSPEC would be useful
for the protocols that do not have related LANDLOCK_ACCESS_NET_*
access rights. It would allow to (for example) create listening socket
of non-TCP(UDP) protocol and fully restrict networking (by restricting
any disassociation and socket creation).

But since disasossication is implemented in the transport layer there
is no clear way to control it with socket access. Considering this and
that previous scenario can be achieved by implementing networking
control (LANDLOCK_ACCESS_NET_* rights) for a needed protocol, potential
cost of "disassociation control" implementation is much more than the
benefits.

>>
>> (In my mind, the disassociation control would have mainly been needed if we had
>> gone with Mickaël's "Use socket's Landlock domain" RFC [1]?  Mickaël and me have
>> discussed this patch set at LSS and I am also now coming around to the
>> realization that this would have introduced more complication.  - It might have
>> been a more "pure" approach, but comes at the expense of complicating Landlock
>> usage.)
> 
> Indeed, and this RFC will not be continued.  We should not think of a
> socket as a security object (i.e. a real capability), whereas sockets
> are kernel objects used to configure and exchange data, a bit like a
> command multiplexer for network actions that can also be used to
> identify peers.
> 
> Because Landlock is a sandboxing mechanism, the security policy tied to
> a task may change during its execution, which is not the case for other
> access control systems such as SELinux.  That's why we should not
> blindly follow other security models.  In the case of socket control,
> Landlock uses the calling task's credential to check if the call should
> be allowed.  In the case of abstract UNIX socket control (with Linux
> 5.12), the check is done on the domain that created the peer's socket,
> not the domain that will received the packet.  In this case Landlock can
> rely on the peer socket's domain because it is a consistent and
> race-free way to identify a peer, and this peer socket is not the one
> doing the action.  It's a bit different with non-UNIX sockets because
> peers may not be local to the system.
> 
>>
>> —Günther
>>
>> [1] https://lore.kernel.org/all/20240719150618.197991-1-mic@digikod.net/
>>
>> * for later reference, my reasoning in the code is: net/ipv4/af_inet.c
>>    implements the entry points for connect() and listen() at the address family
>>    layer.  Both operations require that the sock->state is SS_UNCONNECTED.  So
>>    the rest is going through the other occurrences of SS_UNCONNECTED in that same
>>    file to see if there are any places where the socket can get back into that
>>    state.  The places I found where it is set to that state are:
>>    
>>    1. inet_create (right after creation, expected)
>>    2. __inet_stream_connect in the AF_UNSPEC case (known issue)
>>    3. __inet_stream_connect in the case of a failed connect (expected)
>>    4. inet_shutdown in the case of TCP_LISTEN or TCP_SYN_SENT (mentioned above)
>>
