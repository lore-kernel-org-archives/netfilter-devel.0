Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2486A15698D;
	Fri, 28 Jun 2024 16:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719593477; cv=none; b=sk+cGQ7tmqUDiydTYaus5P1dZJmpgCZyGCaJrdsMuFqVxvp9vKmP45BJW2D7voEEHY0Pkg2Ree0HXHHXIMaAUemXL0u9Sszhr3ZZfNbLPocLzhIylz++lEK0n8A8WcKRBraZl4bQzbxA3cdU4GQ1NnDlJd3d6NTq1DunCzbFsZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719593477; c=relaxed/simple;
	bh=4owyfH6X+DyJ9WfPxXPkoc5JShgygnGI39eEOeau6PI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=bxRp05Xa0FI/BDItVP/AyRiUDN7VSZJyxitONmRpik5z8Dz0DYemZJlk7HSwh50NcQKd9qGcMuPfwGN4OC3TwKuTiqtlXTp4f3zBWs1xSQeVBeOs2iaPs1P0G02oDbIegym1ohwYHQP/GlCcghKMXSmLS+eoebAtFj9yOqzN5Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4W9hHM0dTgzdfP2;
	Sat, 29 Jun 2024 00:49:35 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 0F5C1180087;
	Sat, 29 Jun 2024 00:51:10 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 29 Jun 2024 00:51:05 +0800
Message-ID: <b2d1a152-0241-6a3a-1f31-4a1045fff856@huawei-partners.com>
Date: Fri, 28 Jun 2024 19:51:00 +0300
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
From: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZnMr30kSCGME16rO@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100006.china.huawei.com (7.191.160.224) To
 dggpemm500020.china.huawei.com (7.185.36.49)

6/19/2024 10:05 PM, Günther Noack wrote:
> I agree with Mickaël's comment: this seems like an important fix.
> 
> Mostly for completeness: I played with the "socket type" patch set in a "TCP
> server" example, where *all* possible operations are restricted with Landlock,
> including the ones from the "socket type" patch set V2 with the little fix we
> discussed.
> 
>   - socket()
>   - bind()
>   - enforce a landlock ruleset restricting:
>     - file system access
>     - all TCP bind and connect
>     - socket creation
>   - listen()
>   - accept()
> 
>>From the connection handler (which would be the place where an attacker can
> usually provide input), it is now still possible to bind a socket due to this
> problem.  The steps are:
> 
>    1) connect() on client_fd with AF_UNSPEC to disassociate the client FD
>    2) listen() on the client_fd
> 
> This succeeds and it listens on an ephemeral port.
> 
> The code is at [1], if you are interested.
> 
> [1] https://github.com/gnoack/landlock-examples/blob/main/tcpserver.c

Do you mean that this scenario works with patch-fix currently being
discussed?

> 
> 
> On Mon, May 13, 2024 at 03:15:50PM +0300, Ivanov Mikhail wrote:
>> 4/30/2024 4:36 PM, Mickaël Salaün wrote:
>>> On Mon, Apr 08, 2024 at 05:47:46PM +0800, Ivanov Mikhail wrote:
>>>> Make hook for socket_listen(). It will check that the socket protocol is
>>>> TCP, and if the socket's local port number is 0 (which means,
>>>> that listen(2) was called without any previous bind(2) call),
>>>> then listen(2) call will be legitimate only if there is a rule for bind(2)
>>>> allowing binding to port 0 (or if LANDLOCK_ACCESS_NET_BIND_TCP is not
>>>> supported by the sandbox).
>>>
>>> Thanks for this patch and sorry for the late full review.  The code is
>>> good overall.
>>>
>>> We should either consider this patch as a fix or add a new flag/access
>>> right to Landlock syscalls for compatibility reason.  I think this
>>> should be a fix.  Calling listen(2) without a previous call to bind(2)
>>> is a corner case that we should properly handle.  The commit message
>>> should make that explicit and highlight the goal of the patch: first
>>> explain why, and then how.
>>
>> Yeap, this is fix-patch. I have covered motivation and proposed solution
>> in cover letter. Do you have any suggestions on how i can improve this?
> 
> Without wanting to turn around the direction of this code review now, I am still
> slightly concerned about the assymetry of this special case being implemented
> for listen() but not for connect().
> 
> The reason is this: My colleague Mr. B. recently pointed out to me that you can
> also do a bind() on a socket before a connect(!). The steps are:
> 
> * create socket with socket()
> * bind() to a local port 9090
> * connect() to a remote port 8080
> 
> This gives you a connection between ports 9090 and 8080.
> 
> A regular connect() without an explicit bind() is of course the more usual
> scenario.  In that case, we are also using up ("implicitly binding") one of the
> ephemeral ports.
> 
> It seems that, with respect to the port binding, listen() and connect() work
> quite similarly then?  This being considered, maybe it *is* the listen()
> operation on a port which we should be restricting, and not bind()?

Do you mean that ability to restrict auto-binding for connect() should
also be implemented? This looks like good idea if we want to provide
full control over port binding. But it's hard for me to come up with an
idea how it can be implemented: current Landlock API allows to restrict
only the destination port for connect().

I think an independent restriction of auto-binding for bind() and
listen() is a good approach: API is more clear and Landlock rules do
not affect each other's behavior. Did I understood your suggestion
correctly?

> 
> With some luck, that would then also free us from having to implement the
> check_tcp_socket_can_listen() logic, which is seemingly emulating logic from
> elsewhere in the kernel?

But check_tcp_socket_can_listen() will be required for
LANDLOCK_ACCESS_NET_LISTEN_TCP hook anyway. Did I miss smth?

> 
> (I am by far not an expert in Linux networking, so I'll put this out for
> consideration and will happily stand corrected if I am misunderstanding
> something.  Maybe someone with more networking background can chime in?)
> 
> 
>>>> +		/* Socket is alredy binded to some port. */
>>>
>>> This kind of spelling issue can be found by scripts/checkpatch.pl
>>
>> will be fixed
> 
> P.S. there are two typos here, the obvious one in "alredy",
> but also the passive of "to bind" is "bound", not "binded".
> (That is also mis-spelled in a few more places I think.)

Thanks, I'll fix them.

> 
> —Günther
