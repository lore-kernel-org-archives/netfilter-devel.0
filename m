Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D3E1EB2A;
	Mon,  1 Jul 2024 13:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719839457; cv=none; b=bj72zHD725mSeEHKM6SPIsPGY+9ZOYfX1mmMVguAN8xTZ0299B/4eLmNfL9Y7CnDo89eQcYha/Ajt0OiZhTScTqt8pkXmvgFEPwXqaYwNHyrC7VCMJZy/SyRbjZBjL1QvZEBN/Taxjn2+FjSPUxl3aLOq4X/yqNArg45Yziq7hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719839457; c=relaxed/simple;
	bh=BzFaEn11ycGUZj5/yQOsE4ys7q1rIfmH1GclFKEwPWQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=n2/bZoYiJ5gl5PaIL8GWCIyaeb254nFftw4hMzdtd6o6F8mvCE+bDxvwLXUf1waGm0VKvmNrTB9UOQsbcfbZVxrkCs049GB43u4rIQHiCBoqGJMXhYGRmP4slolaESAcTsDB4ziX6tAqLFvLY918wvWqtXsI+uItCrlX0Z0xGdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WCRHG5VBPznYjM;
	Mon,  1 Jul 2024 21:10:34 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id BAA22140417;
	Mon,  1 Jul 2024 21:10:48 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 1 Jul 2024 21:10:44 +0800
Message-ID: <bd2622cf-27e2-dbb6-735a-0adf6c79b339@huawei-partners.com>
Date: Mon, 1 Jul 2024 16:10:27 +0300
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
From: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZoKB7bl41ZOiiXmF@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100002.china.huawei.com (7.191.160.241) To
 dggpemm500020.china.huawei.com (7.185.36.49)

7/1/2024 1:16 PM, Günther Noack wrote:
> Hello!
> 
> On Fri, Jun 28, 2024 at 07:51:00PM +0300, Ivanov Mikhail wrote:
>> 6/19/2024 10:05 PM, Günther Noack wrote:
>>> I agree with Mickaël's comment: this seems like an important fix.
>>>
>>> Mostly for completeness: I played with the "socket type" patch set in a "TCP
>>> server" example, where *all* possible operations are restricted with Landlock,
>>> including the ones from the "socket type" patch set V2 with the little fix we
>>> discussed.
>>>
>>>    - socket()
>>>    - bind()
>>>    - enforce a landlock ruleset restricting:
>>>      - file system access
>>>      - all TCP bind and connect
>>>      - socket creation
>>>    - listen()
>>>    - accept()
>>>
>>>>  From the connection handler (which would be the place where an attacker can
>>> usually provide input), it is now still possible to bind a socket due to this
>>> problem.  The steps are:
>>>
>>>     1) connect() on client_fd with AF_UNSPEC to disassociate the client FD
>>>     2) listen() on the client_fd
>>>
>>> This succeeds and it listens on an ephemeral port.
>>>
>>> The code is at [1], if you are interested.
>>>
>>> [1] https://github.com/gnoack/landlock-examples/blob/main/tcpserver.c
>>
>> Do you mean that this scenario works with patch-fix currently being
>> discussed?
> 
> I did not mean to say that, no, I mostly wanted to spell out the scenario to
> make sure we are on the same page about the goal.
> 
> I have tried it out with a kernel that had V2 of the "socket type" patch set
> patched in, with the minor fix that we discussed on the "socket type" patch
> thread after the initial submission.  On that kernel, I did not have the
> patch-fix applied.
> 
> The patch-fix should keep the listen() from working, yes, but I have not tried
> it out yet.

I got it, thanks for the clarification! Indeed, goal of this patch-fix
is to restrict such scenarios.

> 
> 
>>> On Mon, May 13, 2024 at 03:15:50PM +0300, Ivanov Mikhail wrote:
>>>> 4/30/2024 4:36 PM, Mickaël Salaün wrote:
>>>>> On Mon, Apr 08, 2024 at 05:47:46PM +0800, Ivanov Mikhail wrote:
>>>>>> Make hook for socket_listen(). It will check that the socket protocol is
>>>>>> TCP, and if the socket's local port number is 0 (which means,
>>>>>> that listen(2) was called without any previous bind(2) call),
>>>>>> then listen(2) call will be legitimate only if there is a rule for bind(2)
>>>>>> allowing binding to port 0 (or if LANDLOCK_ACCESS_NET_BIND_TCP is not
>>>>>> supported by the sandbox).
>>>>>
>>>>> Thanks for this patch and sorry for the late full review.  The code is
>>>>> good overall.
>>>>>
>>>>> We should either consider this patch as a fix or add a new flag/access
>>>>> right to Landlock syscalls for compatibility reason.  I think this
>>>>> should be a fix.  Calling listen(2) without a previous call to bind(2)
>>>>> is a corner case that we should properly handle.  The commit message
>>>>> should make that explicit and highlight the goal of the patch: first
>>>>> explain why, and then how.
>>>>
>>>> Yeap, this is fix-patch. I have covered motivation and proposed solution
>>>> in cover letter. Do you have any suggestions on how i can improve this?
>>>
>>> Without wanting to turn around the direction of this code review now, I am still
>>> slightly concerned about the assymetry of this special case being implemented
>>> for listen() but not for connect().
>>>
>>> The reason is this: My colleague Mr. B. recently pointed out to me that you can
>>> also do a bind() on a socket before a connect(!). The steps are:
>>>
>>> * create socket with socket()
>>> * bind() to a local port 9090
>>> * connect() to a remote port 8080
>>>
>>> This gives you a connection between ports 9090 and 8080.
>>>
>>> A regular connect() without an explicit bind() is of course the more usual
>>> scenario.  In that case, we are also using up ("implicitly binding") one of the
>>> ephemeral ports.
>>>
>>> It seems that, with respect to the port binding, listen() and connect() work
>>> quite similarly then?  This being considered, maybe it *is* the listen()
>>> operation on a port which we should be restricting, and not bind()?
>>
>> Do you mean that ability to restrict auto-binding for connect() should
>> also be implemented? This looks like good idea if we want to provide
>> full control over port binding. But it's hard for me to come up with an
>> idea how it can be implemented: current Landlock API allows to restrict
>> only the destination port for connect().
> 
> I do not think that restricting auto-binding for connect as part of
> LANDLOCK_ACCESS_NET_BIND_TCP would be the correct way.
> 
> 
>> I think an independent restriction of auto-binding for bind() and
>> listen() is a good approach: API is more clear and Landlock rules do
>> not affect each other's behavior. Did I understood your suggestion
>> correctly?
> 
> I believe you did; After reading a lot of documentation on that subject
> recently, let me try to phrase it in yet another way, so that we are on the same
> page:
> 
> The socket operations do the following things:
> 
>   - listen() and connect() make the local port available from the outside.
> 
>   - bind(): Userspace processes call bind() to express that they want to use a
>     specific local address (IP+port) with the given socket.  With TCP, userspace
>     may always omit the call to bind().  If omitted, the kernel picks an
>     ephemeral port.
> 
> So, bind() behaves the same way, whether is is being used with listen() or
> connect().  The common way is to use listen() with bind() and connect() without
> bind(), but the opposite can also be done: listen() without bind() will listen
> on an ephemeral port, and connect() with bind() will use the desired port.
> 
> (The Unix Network Programming book remarks that listen() without bind() is done
> for SunRPC servers, where the separately running portmapper daemon provides a
> lookup facility for the running services, and services can therefore be offered
> on any port.)
> 
> A good description I found in the man pages is this:
> 
>>From ip(7):
> 
>    An ephemeral port is allocated to a socket in the following circumstances:
> 
>    •  the port number in a socket address is specified as 0 when calling bind(2);
>    •  listen(2) is called on a stream socket that was not previously bound;
>    •  connect(2) was called on a socket that was not previously bound;
>    •  sendto(2) is called on a datagram socket that was not previously bound.
> 
> (This section of the ip(7) man page is referenced from connect(2) and listen(2),
> in their ERRORS sections.)
> 
> So, due to the symmetry of how bind() behaves for both connect() and listen(),
> my suggestion would be:
> 
>   * Keep the LANDLOCK_ACCESS_NET_BIND_TCP implementation as it is.
> 
>   * Clarify in LANDLOCK_ACCESS_NET_BIND_TCP that this only makes calls to bind()
>     return errors, but that this does not keep a socket from listening on
>     ephemeral ports.
> 
>   * Create a new LANDLOCK_ACCESS_NET_LISTEN_TCP access right and restrict
>     listen() with that.  Looking at your patch set again, the code in
>     hook_socket_listen() should be very similar, but we might want to call
>     check_access_socket() with the port number that was previously bound (if
>     bind() was called).
> 
> Does that sound reasonable?
> 
> 
> With the current patch-fix as you sent it on the top of this thread, there are
> otherwise some confusing aspects to it, such as:
> 
>   * connect() is also implicitly using a local ephemeral port, just like
>     listen().  But while calls to listen() are checked against
>     LANDLOCK_ACCESS_NET_BIND_TCP, calls to connect() are not.
> 
>   * listen() can return an error due to LANDLOCK_ACCESS_NET_BIND_TCP,
>     even when the userspace program never called bind().
> 
> Both of these are potentially puzzling and might be more in-line with BSD socket
> concepts if we did it differently.

Thanks for the great explanation! We're on the same page.

Considering that binding to ephemeral ports can be done not only with
bind() or listen(), I think your approach is more correct.
Restricting any possible binding to ephemeral ports just using
LANDLOCK_ACCESS_NET_BIND_TCP wouldn't allow sandboxed processes
to deny listen() without pre-binding (which is quite unsafe) and
use connect() in the usuall way (without pre-binding).

Controlling ephemeral ports allocation for listen() can be done in the
same way as for LANDLOCK_ACCESS_NET_BIND_TCP in the patch with
LANDLOCK_ACCESS_NET_LISTEN_TCP access right implementation.

I'm only concerned about controlling the auto-binding for other
operations (such as connect() and sendto() for UDP). As I said, I think
this can also be useful: users will be able to control which processes
are allowed to use ephemeral ports from ip_local_port_range and which
are not, and they must assign ports for each operation explicitly. If
you agree that such control is reasonable, we'll probably  have to
consider some API changes, since such control is currently not possible.

We should clarify this before I send a patch with the
LANDLOCK_ACCESS_NET_LISTEN_TCP implementation. WDYT?

> 
> 
>>> With some luck, that would then also free us from having to implement the
>>> check_tcp_socket_can_listen() logic, which is seemingly emulating logic from
>>> elsewhere in the kernel?
>>
>> But check_tcp_socket_can_listen() will be required for
>> LANDLOCK_ACCESS_NET_LISTEN_TCP hook anyway. Did I miss smth?
> 
> You are right -- my fault, I misread that.
> 
> —Günther
