Received: from smtp-190a.mail.infomaniak.ch (smtp-190a.mail.infomaniak.ch [185.125.25.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF91172BAB
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Jun 2024 08:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.25.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718871044; cv=none; b=qBXE1bQWEY/E31XaMuTug9h1O4MA85bfgpV6a6kbK/r2JtnZCsAc3w14FVNRdFNdiCfqcBUUoBuYuZXpyQ0jGK3hk55REN3CNComzWAmtNT6pSsxwptrz/dRdCcbde/Ei9YtKvLxbVxJlz8zAuefCWdqH0chRxHsNCT92kOFqNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718871044; c=relaxed/simple;
	bh=FyjNm/I3kq/pP/dapIPg9gsHpP1PzC710dtt7pmzUKY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vAXhZOE28YQEyFiqPzG5+KT3ADQXEiKJxgiNr8uqdKMSBqe8fBwYD84fmyiAhEn/OuzCz5pQsnwQuP8JVcA5DabVxBfu0MizoJOtBOI6ZUJYcfOi1POFtcPcr6vI44uLrqI0JdgIGiyE3C3hqrIaEbfogzTcr9VC3yLAyUnyYmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=sOtNOmYZ; arc=none smtp.client-ip=185.125.25.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="sOtNOmYZ"
Received: from smtp-3-0001.mail.infomaniak.ch (smtp-3-0001.mail.infomaniak.ch [10.4.36.108])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4W4Xwr6kjdz8pT;
	Thu, 20 Jun 2024 10:00:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1718870444;
	bh=W/NUAL6voE5A4pFcJSHOLM46v6kGmeT8h3EcYwb3KUc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sOtNOmYZHEhT5EIB2V7KL7iSkDlMWcmlXneHp9D4RSJGbbkFF01kDHHlU3rEP3MqK
	 db2AHQ+1PdQ3sARwOOndydYhkRuqDzzz0lu9vjn3Zis9aLshwsvhTNB4T4MNzlnX7h
	 tVG6xTX3hNIg1t4k/xOjCkXRQ4pckdidlfeyTPvk=
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4W4Xwk3bNHzMhc;
	Thu, 20 Jun 2024 10:00:38 +0200 (CEST)
Date: Thu, 20 Jun 2024 10:00:36 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: =?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>, 
	Eric Dumazet <edumazet@google.com>
Cc: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>, 
	willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, linux-security-module@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Subject: Re: [PATCH 1/2] landlock: Add hook on socket_listen()
Message-ID: <20240620.teeFoot6gaeX@digikod.net>
References: <20240408094747.1761850-1-ivanov.mikhail1@huawei-partners.com>
 <20240408094747.1761850-2-ivanov.mikhail1@huawei-partners.com>
 <20240425.Soot5eNeexol@digikod.net>
 <a18333c0-4efc-dcf4-a219-ec46480352b1@huawei-partners.com>
 <ZnMr30kSCGME16rO@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZnMr30kSCGME16rO@google.com>
X-Infomaniak-Routing: alpha

On Wed, Jun 19, 2024 at 09:05:03PM +0200, Günther Noack wrote:
> I agree with Mickaël's comment: this seems like an important fix.
> 
> Mostly for completeness: I played with the "socket type" patch set in a "TCP
> server" example, where *all* possible operations are restricted with Landlock,
> including the ones from the "socket type" patch set V2 with the little fix we
> discussed.
> 
>  - socket()
>  - bind()
>  - enforce a landlock ruleset restricting:
>    - file system access
>    - all TCP bind and connect
>    - socket creation
>  - listen()
>  - accept()
> 
> From the connection handler (which would be the place where an attacker can
> usually provide input), it is now still possible to bind a socket due to this
> problem.  The steps are:
> 
>   1) connect() on client_fd with AF_UNSPEC to disassociate the client FD
>   2) listen() on the client_fd
> 
> This succeeds and it listens on an ephemeral port.
> 
> The code is at [1], if you are interested.
> 
> [1] https://github.com/gnoack/landlock-examples/blob/main/tcpserver.c
> 
> 
> On Mon, May 13, 2024 at 03:15:50PM +0300, Ivanov Mikhail wrote:
> > 4/30/2024 4:36 PM, Mickaël Salaün wrote:
> > > On Mon, Apr 08, 2024 at 05:47:46PM +0800, Ivanov Mikhail wrote:
> > > > Make hook for socket_listen(). It will check that the socket protocol is
> > > > TCP, and if the socket's local port number is 0 (which means,
> > > > that listen(2) was called without any previous bind(2) call),
> > > > then listen(2) call will be legitimate only if there is a rule for bind(2)
> > > > allowing binding to port 0 (or if LANDLOCK_ACCESS_NET_BIND_TCP is not
> > > > supported by the sandbox).
> > > 
> > > Thanks for this patch and sorry for the late full review.  The code is
> > > good overall.
> > > 
> > > We should either consider this patch as a fix or add a new flag/access
> > > right to Landlock syscalls for compatibility reason.  I think this
> > > should be a fix.  Calling listen(2) without a previous call to bind(2)
> > > is a corner case that we should properly handle.  The commit message
> > > should make that explicit and highlight the goal of the patch: first
> > > explain why, and then how.
> > 
> > Yeap, this is fix-patch. I have covered motivation and proposed solution
> > in cover letter. Do you have any suggestions on how i can improve this?
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

Yes, this should not be an issue, but something to keep in mind.

> 
> A regular connect() without an explicit bind() is of course the more usual
> scenario.  In that case, we are also using up ("implicitly binding") one of the
> ephemeral ports.
> 
> It seems that, with respect to the port binding, listen() and connect() work
> quite similarly then?  This being considered, maybe it *is* the listen()
> operation on a port which we should be restricting, and not bind()?

I agree that we should be able to control listen according to the binded
port, see https://github.com/landlock-lsm/linux/issues/15
In a nutshell, the LANDLOCK_ACCESS_NET_LISTEN_TCP should make more sense
for most use cases, but I think LANDLOCK_ACCESS_NET_BIND_TCP is also
useful to limit opened (well-known) ports and port spoofing.

> 
> With some luck, that would then also free us from having to implement the
> check_tcp_socket_can_listen() logic, which is seemingly emulating logic from
> elsewhere in the kernel?

An alternative could be to only use LANDLOCK_ACCESS_NET_BIND_TCP for
explicit binding (i.e. current state, but with appropriate
documentation), and delegate to LANDLOCK_ACCESS_NET_LISTEN_TCP the
control of binding with listen(2).  That should free us from
implementing check_tcp_socket_can_listen().  The rationale would be that
a malicious sandboxed process could not explicitly bind to a
well-specified port, but only to a range of dedicated random ports (the
same range use for auto-binding with connect).  That could also help
developers by staying close to the kernel syscall ABI (principle of
least astonishment).

> 
> (I am by far not an expert in Linux networking, so I'll put this out for
> consideration and will happily stand corrected if I am misunderstanding
> something.  Maybe someone with more networking background can chime in?)

That would be good indeed.  Netfilter or network folks? Eric?

> 
> 
> > > > +		/* Socket is alredy binded to some port. */
> > > 
> > > This kind of spelling issue can be found by scripts/checkpatch.pl
> > 
> > will be fixed
> 
> P.S. there are two typos here, the obvious one in "alredy",
> but also the passive of "to bind" is "bound", not "binded".
> (That is also mis-spelled in a few more places I think.)
> 
> —Günther
> 
