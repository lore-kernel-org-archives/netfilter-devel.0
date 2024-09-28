Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7924C1494DA
	for <netfilter-devel@vger.kernel.org>; Sat, 28 Sep 2024 20:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727554017; cv=none; b=OauG43tanIqdmFHXCXDYYvIW6PURzYiwor/2GbAnyorpl36ltR0QSsskov0DmPR0HFNtniXEIrQfmhpJoT+NNLQCGwWZTupUDhbCvuXL364WhPGN2wdWALn+ZD34/EOyOD+oZYTvP7HplqAnNbeAT2GUpr5GlwMW8WhkXkEc8oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727554017; c=relaxed/simple;
	bh=h0sNuBxsvoK2YChegc9QSYuEMp8d+DJBKteN7IMj0A4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Wg6rvzU8tBASsv1Zm5cMEJRJ9aRTghz350lJgqIOF4RszKZQ6Ry8D7hLCPuxyPj8MQg6iC7GFNq7xMDuAnH5gqnmG6eYRQ3PhW0WVm37bUMAgciwCCSJ1CB7XlWoHT89tiLrnVFrLF0WGlJ8hBmLlSOP9nCleRmnFcd2RtC6JLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mswEaIxt; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mswEaIxt"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e253a8b95aso16034367b3.0
        for <netfilter-devel@vger.kernel.org>; Sat, 28 Sep 2024 13:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727554014; x=1728158814; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y1SqGaOAQOPzAn14KPrnOehT0qxEpBZk7h3tAfBnOmM=;
        b=mswEaIxtkZm5hRXLc/zPHoCM0SG07iYCduhZD+5ni+YVOtM2UZt7VYcFgig69nR6pg
         cYMxUZzP2cOiLfavE58L6eJf/i+XgKALYxWAa0hNU4OOILB2lqy93fwli5fcNAu//Frc
         eri1PUqHONpU30k1Kh+X2GZ2hx4TlTSHsDvHv5XNA3ySYkvppnYyWMTBjtZyxej9mLc2
         sp0o+E7jS1STRlnCZnNupnTqmLVZ3Xk11mYXCvqqz61rG5oiGHYH8KHco5CDl8Kti+jE
         3YRBmUvOjDNDVcsgUwUkQ7vL0Dwz/7GgrzGZ5UAEMu5G8wrB7TODn+UUHmUTCvDEXzpP
         bs3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727554014; x=1728158814;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=y1SqGaOAQOPzAn14KPrnOehT0qxEpBZk7h3tAfBnOmM=;
        b=XLK7rOtenhFyVkcoYuVUg2aApQ/0sRhd8wvLm4rEgM+oo/bgGGZ5SNWqzCsYSgcj4i
         nngxW8Qyn/mTOtMBqxDSuSnsjnufQ1FN21GOEctgZw9ytIo+qAp3ACmBIDbtKLUl0Ht7
         kVxjQlv+/Et2v2YBQLyZNyxzLMueTFUpkqUSA0l6qOXQ69buurXdp1vhO3wX73wU3C+b
         xl4Uf+9ZVVRdC4oirjhNfnzdkAw2GhTeEgwFtq8iD5J5Rg6pjuoL8oGYAaC4qNVprDoJ
         s/ZT7+ad0BLX2Kn/7dD9zOJqEXP0f87lZZfHB/6qPFy04Dh33TUT/yb6gCcy5YpJObR7
         y9OA==
X-Forwarded-Encrypted: i=1; AJvYcCUf9ptuYcIMII853qQfPrcmKO9bGoMQZI+SMFKd6/cCI1/TxuUgG2kCs3CSC/Br7aJoq5ctTlAOwYMY/FW9ouM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyv4Kda0H9pnmKilRMc6M0AP9W6323dG9c69+EQQpFqdgk1ppWp
	V65pcduEGCXv9LwyyXmV4y3PjaFxt/Er4YlAhhojUoFEIDMpSd6LDJTcG1Zkx8aQKpaV3QSStwG
	boQ==
X-Google-Smtp-Source: AGHT+IE80aZhCT4JHwgHwsEdaDWdBP8dNZdVjFPvbHZ/3cczSejefNhUNjkgqyWFX+K6tqTYQ9YkfEFTh9M=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a05:690c:4b92:b0:6dd:bb6e:ec89 with SMTP id
 00721157ae682-6e245317e48mr935707b3.2.1727554014549; Sat, 28 Sep 2024
 13:06:54 -0700 (PDT)
Date: Sat, 28 Sep 2024 22:06:52 +0200
In-Reply-To: <ZvZ_ZjcKJPm5B3_Z@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
 <20240904104824.1844082-15-ivanov.mikhail1@huawei-partners.com>
 <ZurZ7nuRRl0Zf2iM@google.com> <220a19f6-f73c-54ef-1c4d-ce498942f106@huawei-partners.com>
 <ZvZ_ZjcKJPm5B3_Z@google.com>
Message-ID: <Zvhh3CRj9T7_KIhC@google.com>
Subject: Re: [RFC PATCH v3 14/19] selftests/landlock: Test socketpair(2) restriction
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 27, 2024 at 11:48:22AM +0200, G=C3=BCnther Noack wrote:
> On Mon, Sep 23, 2024 at 03:57:47PM +0300, Mikhail Ivanov wrote:
> > (Btw I think that disassociation control can be really useful. If
> > it were possible to restrict this action for each protocol, we would
> > have stricter control over the protocols used.)
>=20
> In my understanding, the disassociation support is closely intertwined wi=
th the
> transport layer - the last paragraph of DESCRIPTION in connect(2) is list=
ing
> TCP, UDP and Unix Domain sockets in datagram mode. -- The relevant code i=
n in
> net/ipv4/af_inet.c in inet_dgram_connect() and __inet_stream_connect(), w=
here
> AF_UNSPEC is handled.
>=20
> I would love to find a way to restrict this independent of the specific
> transport protocol as well.
>=20
> Remark on the side - in af_inet.c in inet_shutdown(), I also found a worr=
ying
> scenario where the same sk->sk_prot->disconnect() function is called and
> sock->state also gets reset to SS_UNCONNECTED.  I have done a naive attem=
pt to
> hit that code path by calling shutdown() on a passive TCP socket, but was=
 not
> able to reuse the socket for new connections afterwards. (Have not debugg=
ed it
> further though.)  I wonder whether this is a scnenario that we also need =
to
> cover?

FYI, **this does turn out to work** (I just fumbled in my first experiment)=
. --
It is possible to reset a listening socket with shutdown() into a state whe=
re it
can be used for at least a new connect(2), and maybe also for new listen(2)=
s.

The same might also be possible if a socket is in the TCP_SYN_SENT state at=
 the
time of shutdown() (although that is a bit trickier to try out).

So a complete disassociation control for TCP/IP might not only need to have
LANDLOCK_ACCESS_SOCKET_CONNECT_UNSPEC (or however we'd call it), but also
LANDLOCK_ACCESS_SOCKET_PASSIVE_SHUTDOWN and maybe even another one for the
TCP_SYN_SENT case...? *

It makes me uneasy to think that I only looked at AF_INET{,6} and TCP so fa=
r,
and that other protocols would need a similarly close look.  It will be
difficult to cover all the "disassociation" cases in all the different
protocols, and even more difficult to detect new ones when they pop up.  If=
 we
discover new ones and they'd need new Landlock access rights, it would also
potentially mean that existing Landlock users would have to update their ru=
les
to spell that out.

It might be easier after all to not rely on "disassociation" control too mu=
ch
and instead to design the network-related access rights in a way so that we=
 can
provide the desired sandboxing guarantees by restricting the "constructive"
operations (the ones that initiate new network connections or that listen o=
n the
network).

Mikhail, in your email I am quoting above, you are saying that "disassociat=
ion
control can be really useful"; do you know of any cases where a restriction=
 of
connect/listen is *not* enough and where you'd still want the disassociatio=
n
control?

(In my mind, the disassociation control would have mainly been needed if we=
 had
gone with Micka=C3=ABl's "Use socket's Landlock domain" RFC [1]?  Micka=C3=
=ABl and me have
discussed this patch set at LSS and I am also now coming around to the
realization that this would have introduced more complication.  - It might =
have
been a more "pure" approach, but comes at the expense of complicating Landl=
ock
usage.)

=E2=80=94G=C3=BCnther

[1] https://lore.kernel.org/all/20240719150618.197991-1-mic@digikod.net/

* for later reference, my reasoning in the code is: net/ipv4/af_inet.c
  implements the entry points for connect() and listen() at the address fam=
ily
  layer.  Both operations require that the sock->state is SS_UNCONNECTED.  =
So
  the rest is going through the other occurrences of SS_UNCONNECTED in that=
 same
  file to see if there are any places where the socket can get back into th=
at
  state.  The places I found where it is set to that state are:
 =20
  1. inet_create (right after creation, expected)
  2. __inet_stream_connect in the AF_UNSPEC case (known issue)
  3. __inet_stream_connect in the case of a failed connect (expected)
  4. inet_shutdown in the case of TCP_LISTEN or TCP_SYN_SENT (mentioned abo=
ve)
