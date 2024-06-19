Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58527156F37
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2024 19:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718823910; cv=none; b=mVrJexYWqNyG9Kcs7R5Nxoi0KIAxtQx4dEYJrv5HDE7Ta5xbyjiLg9nqUQc3eXoKNxIb7foiRNeOw0/E0u5drwVzWb8GlwCXHfIX6oaTwMpgA1wAN9viRiQJ8hLq4xFGMY2QCh/A11/CTBRcCYvCtS/Z7GaPn71RJYlQMpqrqvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718823910; c=relaxed/simple;
	bh=HsYG3u4BQt6CoTRVpqG4TEiDfmw8LWNDnatTsKEzkb8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N9Sdc1xXQZ1yvDcrwruBiCwDvD3b+XhyAjhi4Huqn7ejJn/JMxAtx57wBM+f5/UviS1rv8ncdrdqFFgdHL1dicpO55fOnQT+nxAzSJyiNrTmXdZS3V4AbxC1GLWSPc4dmQynAaiDooJxD0gAmHnde9ZBe1XQlTIyoCi5zaJ7aWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SJR23Yxz; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SJR23Yxz"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-57ceb0e6a06so10538a12.1
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2024 12:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718823907; x=1719428707; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5cBZWGbah1lE3Ejb3luq7CWnw8Aj0HxoLRS/D6N+3r0=;
        b=SJR23YxzaYyvW889BAghG+CvSfV2szgHsex7117rRvLYhbedINvbUeXSLHENS/+L2K
         CXz3iARAOH90Rx6N4c+C6p+Rs1V6CuAdqcs4/BnJaYUMpgolamWwtBN48ETE4nUCjadF
         6Jo8a60Q1ICIIYpoVrB+93zCyFjXMrq41JIaKGos3QGBJ5bMDUUAnGIVh+qaUcsIfMOF
         h5x10boO4sdlWbfy89DrYsUcu9obMjPESsnxwhDJMk5i89pjG4JzyT0adn0iRlnXxtmW
         E1DcFui3UJTpuJBFLArrkwSGRA82rTxO0aOq9EJI/FkewsqCud2C+RjPHog2jFm6fwNl
         kZ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718823907; x=1719428707;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5cBZWGbah1lE3Ejb3luq7CWnw8Aj0HxoLRS/D6N+3r0=;
        b=qQdhUukr9z9bRFGO0Iz7gcGoTXQdGMLseG2wbUxL8bmWHJrMzEBKk0dtQYJJi/md7o
         GSfKPEpPiufdrWsx7v73IT2+1+TWqynWwSKh85hZ3em6s4acPBaTChy+5cLpZdMyKUC8
         nCDbW2TkSXQ+U7oRyPP3+7KvSdK+scj/JNSGe4SBfxvoYTbx5xDvW0BLUOtHX5wCNPzX
         a4CoZJcMqwVtjPQq1EJCfbA4tE/hobiGJRrfmM9VC2nWor6U2QtFj6174D2wZyzcEBMq
         B+s1TTVMmfzLiWKCq0xGxZzX7dHw6a0RwfZyPEgqim4SzcU0S/HhFt0vk4y8FhatGR6T
         maKw==
X-Forwarded-Encrypted: i=1; AJvYcCUpVKtT5oltSYFawpeYfDy1Tl1KjDBlJW44EJWDopO0C4u8atOiKtx96ThtxQwBQiQ3mgGOrVb04b+3Dyh4YGWyem5jsP2oT4K/diKhiD2K
X-Gm-Message-State: AOJu0Yy8yhOZ7nfwKESLjFY6NXQXsoDZKjSDmnoTkmGEXPQDjo9cTmqm
	55TOL/jl7rbf5xj1Nu3sRdj5H6whTnDfS5xUibQrsPsY4iY3OR4AQXLGky2/STvaqr3dp2xuJNF
	eAQ==
X-Google-Smtp-Source: AGHT+IH6ezgKV5I5dqSOcFIAzwyP5l78NkMHv7BZHgz0EUfSDl2F76DIwt6VZIICzod9Kw3Y9KPHF1bf3Jc=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a05:6402:1608:b0:57c:7cda:6757 with SMTP id
 4fb4d7f45d1cf-57d07edca18mr2461a12.6.1718823906227; Wed, 19 Jun 2024 12:05:06
 -0700 (PDT)
Date: Wed, 19 Jun 2024 21:05:03 +0200
In-Reply-To: <a18333c0-4efc-dcf4-a219-ec46480352b1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240408094747.1761850-1-ivanov.mikhail1@huawei-partners.com>
 <20240408094747.1761850-2-ivanov.mikhail1@huawei-partners.com>
 <20240425.Soot5eNeexol@digikod.net> <a18333c0-4efc-dcf4-a219-ec46480352b1@huawei-partners.com>
Message-ID: <ZnMr30kSCGME16rO@google.com>
Subject: Re: [PATCH 1/2] landlock: Add hook on socket_listen()
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Cc: "=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

I agree with Micka=C3=ABl's comment: this seems like an important fix.

Mostly for completeness: I played with the "socket type" patch set in a "TC=
P
server" example, where *all* possible operations are restricted with Landlo=
ck,
including the ones from the "socket type" patch set V2 with the little fix =
we
discussed.

 - socket()
 - bind()
 - enforce a landlock ruleset restricting:
   - file system access
   - all TCP bind and connect
   - socket creation
 - listen()
 - accept()

From the connection handler (which would be the place where an attacker can
usually provide input), it is now still possible to bind a socket due to th=
is
problem.  The steps are:

  1) connect() on client_fd with AF_UNSPEC to disassociate the client FD
  2) listen() on the client_fd

This succeeds and it listens on an ephemeral port.

The code is at [1], if you are interested.

[1] https://github.com/gnoack/landlock-examples/blob/main/tcpserver.c


On Mon, May 13, 2024 at 03:15:50PM +0300, Ivanov Mikhail wrote:
> 4/30/2024 4:36 PM, Micka=C3=ABl Sala=C3=BCn wrote:
> > On Mon, Apr 08, 2024 at 05:47:46PM +0800, Ivanov Mikhail wrote:
> > > Make hook for socket_listen(). It will check that the socket protocol=
 is
> > > TCP, and if the socket's local port number is 0 (which means,
> > > that listen(2) was called without any previous bind(2) call),
> > > then listen(2) call will be legitimate only if there is a rule for bi=
nd(2)
> > > allowing binding to port 0 (or if LANDLOCK_ACCESS_NET_BIND_TCP is not
> > > supported by the sandbox).
> >=20
> > Thanks for this patch and sorry for the late full review.  The code is
> > good overall.
> >=20
> > We should either consider this patch as a fix or add a new flag/access
> > right to Landlock syscalls for compatibility reason.  I think this
> > should be a fix.  Calling listen(2) without a previous call to bind(2)
> > is a corner case that we should properly handle.  The commit message
> > should make that explicit and highlight the goal of the patch: first
> > explain why, and then how.
>=20
> Yeap, this is fix-patch. I have covered motivation and proposed solution
> in cover letter. Do you have any suggestions on how i can improve this?

Without wanting to turn around the direction of this code review now, I am =
still
slightly concerned about the assymetry of this special case being implement=
ed
for listen() but not for connect().

The reason is this: My colleague Mr. B. recently pointed out to me that you=
 can
also do a bind() on a socket before a connect(!). The steps are:

* create socket with socket()
* bind() to a local port 9090
* connect() to a remote port 8080

This gives you a connection between ports 9090 and 8080.

A regular connect() without an explicit bind() is of course the more usual
scenario.  In that case, we are also using up ("implicitly binding") one of=
 the
ephemeral ports.

It seems that, with respect to the port binding, listen() and connect() wor=
k
quite similarly then?  This being considered, maybe it *is* the listen()
operation on a port which we should be restricting, and not bind()?

With some luck, that would then also free us from having to implement the
check_tcp_socket_can_listen() logic, which is seemingly emulating logic fro=
m
elsewhere in the kernel?

(I am by far not an expert in Linux networking, so I'll put this out for
consideration and will happily stand corrected if I am misunderstanding
something.  Maybe someone with more networking background can chime in?)


> > > +		/* Socket is alredy binded to some port. */
> >=20
> > This kind of spelling issue can be found by scripts/checkpatch.pl
>=20
> will be fixed

P.S. there are two typos here, the obvious one in "alredy",
but also the passive of "to bind" is "bound", not "binded".
(That is also mis-spelled in a few more places I think.)

=E2=80=94G=C3=BCnther
