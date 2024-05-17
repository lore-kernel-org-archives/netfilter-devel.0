Received: from smtp-8fa9.mail.infomaniak.ch (smtp-8fa9.mail.infomaniak.ch [83.166.143.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FAB12CD8A;
	Fri, 17 May 2024 15:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.166.143.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715959396; cv=none; b=fRz5pZuVVYjDpsI7/Lqu19P31Ovl5SaW3VILN5z0tYj9cBEHQtuMo4+B6mLJgUgogOasiph+yGSkjcyFAj+VGnMB/12SMhIf//IZPl4TI5mF4WMnXpXSCfnPH023qPfYkWuW3ljx8pvwFpCM+XfpBT1p6ppqv3qDv4f/AG2BliE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715959396; c=relaxed/simple;
	bh=Aqm4rQ6fA8zQGRPRwRDXUfKfXuyDD8WlVYGYuORG9Wg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jVLECtVgFUNqIoy+BIsnBnZu+3bFA+OWfCxSUZ3hUoIMEsiCjS3wBZytrS+cOqaRAL8OSGaBKph63j6PcbcBwj93xYIePbEio16rMaWEgH4VblFSBgAxV3gzuha9F7Wfo8Lddc5BfY+YAfqOSqv3c/dO07GP/O0P4ghxf7N/irQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=xXlPCMC9; arc=none smtp.client-ip=83.166.143.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="xXlPCMC9"
Received: from smtp-4-0001.mail.infomaniak.ch (smtp-4-0001.mail.infomaniak.ch [10.7.10.108])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4VgrLr2Dc0z16SX;
	Fri, 17 May 2024 17:23:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1715959380;
	bh=18SA0w9qbc0hJ2jDLC8bwCABDXE6nCN3mQ4dHgHlO+A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xXlPCMC9HunO9Izxd3uzCt2OUKk1mxHPVCsiYkc5xTl8XCN4SX/9DbNPeMsSYIq1I
	 i+hSC5SoMk9DgNzjoR6wSSL0rLIUklkok77QVCHit5BrPzOy20jfdtQ5rewXLouvIH
	 sP9XFEteDF2Hmvxr9/CUuzsLX6EWivhL+zXm2eA0=
Received: from unknown by smtp-4-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4VgrLq4yyMzgvX;
	Fri, 17 May 2024 17:22:59 +0200 (CEST)
Date: Fri, 17 May 2024 17:22:45 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>, 
	Eric Dumazet <edumazet@google.com>
Cc: willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	yusongping@huawei.com, artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com, 
	=?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>
Subject: Re: [PATCH 1/2] landlock: Add hook on socket_listen()
Message-ID: <20240517.EeHizaR1gie7@digikod.net>
References: <20240408094747.1761850-1-ivanov.mikhail1@huawei-partners.com>
 <20240408094747.1761850-2-ivanov.mikhail1@huawei-partners.com>
 <20240425.Soot5eNeexol@digikod.net>
 <a18333c0-4efc-dcf4-a219-ec46480352b1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a18333c0-4efc-dcf4-a219-ec46480352b1@huawei-partners.com>
X-Infomaniak-Routing: alpha

On Mon, May 13, 2024 at 03:15:50PM +0300, Ivanov Mikhail wrote:
> 
> 
> 4/30/2024 4:36 PM, Mickaël Salaün wrote:
> > On Mon, Apr 08, 2024 at 05:47:46PM +0800, Ivanov Mikhail wrote:
> > > Make hook for socket_listen(). It will check that the socket protocol is
> > > TCP, and if the socket's local port number is 0 (which means,
> > > that listen(2) was called without any previous bind(2) call),
> > > then listen(2) call will be legitimate only if there is a rule for bind(2)
> > > allowing binding to port 0 (or if LANDLOCK_ACCESS_NET_BIND_TCP is not
> > > supported by the sandbox).
> > 
> > Thanks for this patch and sorry for the late full review.  The code is
> > good overall.
> > 
> > We should either consider this patch as a fix or add a new flag/access
> > right to Landlock syscalls for compatibility reason.  I think this
> > should be a fix.  Calling listen(2) without a previous call to bind(2)
> > is a corner case that we should properly handle.  The commit message
> > should make that explicit and highlight the goal of the patch: first
> > explain why, and then how.
> 
> Yeap, this is fix-patch. I have covered motivation and proposed solution
> in cover letter. Do you have any suggestions on how i can improve this?

You can start this commit message with the same description as in the
cover letter.

[...]

> > 
> > > +	if (!((1 << cur_sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
> > > +		return -EINVAL;
> > > +
> > > +	/* Sockets can listen only if ULP control hook has clone method. */
> > 
> > What is ULP?
> 
> ULP (Upper Layer Protocol) stands for protocols which are higher than
> transport protocol in OSI model. Linux has an infrastructure that
> allows TCP sockets to support logic of some ULP (e.g. TLS ULP). [1]

OK, you can extend the comment with this information, but no need for
the links.

> 
> There is a patch that prevents ULP sockets from listening
> if corresponding ULP implementation in linux doesn't have a clone
> method. [2]
> 
> Landlock shouldn't return EACCES for ULP sockets that cannot listen
> due to some ULP restrictions.

Looks good.

> 
> [1]
> https://lore.kernel.org/all/20170524162646.GA24128@davejwatson-mba.local/
> [2] https://lore.kernel.org/all/4b80c3d1dbe3d0ab072f80450c202d9bc88b4b03.1672740602.git.pabeni@redhat.com/
> 
> > 
> > > +	icsk = inet_csk(sk);
> > > +	if (icsk->icsk_ulp_ops && !icsk->icsk_ulp_ops->clone)
> > > +		return -EINVAL;
> > 
> > Can you please add tests covering all these error cases?
> 
> Yeap, i'll add a test for first check.
> 
> I have not found a way to trigger the second check from userspace.
> Since socket wasn't binded to any port, this means that it cannot
> be part of a TCP connection in any state, so it has to be in TCPF_CLOSE

If you're sure this cannot be triggered from user space, you can wrap
the test with WARN_ON_ONCE(), but we need to be careful.  I'd like to
get the point of view of kernel network expert though.

Eric, is this assumption correct?

> state. Nevertheless i think that this check is required:
> 
> * for consistency with inet stack (see __inet_listen_sk())
> 
> * i have not found any restrictions connected with sock locking
>   for TCP-like protocols, so listen(2) can be called after
>   sk->sk_prot->connect() method will change sock state in
>   __inet_stream_connect() (e.g. to TCP_SYN_SENT). In that case this
>   check may be required.
> 
> What do you think?

This looks good, but we need to explain this rationale in comments, with
explicit mention of network stack functions.

> Btw this hook on socket_listen() should be fixed in
> order to not check socket that is already in TCP_LISTEN state. Calling
> listen(2) only changes backlog value, so landlock shouldn't do anything
> in this case.
> 
> I'm not sure about ULP checking. I thought of adding test that creates
> espintcp ULP (net/xfrm/expintcp.c) socket and tries to listen on it.
> Since espintcp doesn't have clone method ULP check will be triggered.
> Problem is that kernel doesnt support this ULP module by default and it
> should be configured with CONFIG_XFRM_ESPINTCP option enabled. I think
> that selftests shouldn't depend on specific kernel configuration to be
> fully executed, so probably we should just skip this. What do you think?

Testing with espintcp makes sense for this clone case.  I hope it would
not require too much boilerplate code though.  We can and should add all
the required kernel option in tools/testing/selftests/landlock/config,
and we should not restrict tests to default kernel options, quite the
contrary if it makes sense.

[...]

> > 
> > > +	family = sock->sk->__sk_common.skc_family;
> > > +
> > > +	if (family == AF_INET || family == AF_INET6) {
> > 
> > This would make the code simpler:
> > 
> > if (family != AF_INET && family != AF_INET6)
> > 	return 0;
> 
> indeed, will be fixed.
> 
> > 
> > 
> > What would be the effect of listen() on an AF_UNSPEC socket?
> 
> AF_UNSPEC is a family type that only addresses can use.
> Socket itself can only be AF_INET or AF_INET6 in TCP.

Indeed, it is worth mentioning in a comment.
