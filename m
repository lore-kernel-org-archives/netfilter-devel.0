Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33FA184538
	for <netfilter-devel@vger.kernel.org>; Thu,  1 Aug 2024 10:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722508586; cv=none; b=ticaRBS0ebRhn/xYZtUuPbeda7t40q5iWtDLpafYsJptayOtWyDC8qfwAWwDcd2/on0cAVxBZWiOA58ZSuNZzDuuqJKKPmTOrCvtPE/XFPukRZRKaD3cfsnhh+koaXQuV5C8kqyv3ShWIoR7KHzHXx51Xgy0DxSXW0uPpOg931s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722508586; c=relaxed/simple;
	bh=K66gAp8SRsfpfuM3SHt00HYhvmX5sXJ/9hQegPDQEwo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=smNuyK3I3QAbkrmMZskEq/2ZiteqvOt2t2vKmND6dMmFKPRmHdKpI2h6YEYdFcAKnhKNcdY2ZUZkSH0SAUy4x9x0f6Ce8rqPpWu2F3wBxqrfCCrk9YTTa54nnyQSPPSVaKMytsfrKGPwuzch7OX5AFYeh/LtHUynTVcITf/GS44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hs/VoQC3; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hs/VoQC3"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-66619cb2d3eso145597367b3.2
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Aug 2024 03:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722508584; x=1723113384; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OP6c+sS8ST+QgrxChdVqPzP1UOGKL00OxIAhJNniQNU=;
        b=hs/VoQC3N5EmgH9n9Ws/TpRSfkbImcYp27d7RAX1hRiWpBZ3vNpBaEIPRzYbZycILA
         Qv8D9AbV4dbG1VFHTxenkMZcFIXlKHr/sQ/g/y/shOQe5mu6VVO7HzGZA1WxaB7Mf2EZ
         hroQ1Gli81GlzCiFlrKXUxWVBXx+16ni91yg9pQf7ALnQF8OqhrowdRClwrQmpwLWk1g
         PRZNyeauIExz9XEL4y0aoJpVaxkswxQY6O8+uG3j4rsfvlNGUfngiJ3tf2hqlNsXO8nZ
         vGsbt68/WNFDiEuIdOxexNLFU75uGQvv2+Q5CS15L5NQxhGyp0N/spFgI4escqpA4rMP
         Vb9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722508584; x=1723113384;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OP6c+sS8ST+QgrxChdVqPzP1UOGKL00OxIAhJNniQNU=;
        b=Kw60lCS4qVxQG59rl9L+g2Qny/2SCbBtgBfSCx+kUzj5Qm9HW40gzgiRCQ4VQg4dr3
         pcaI2ia+a5nhjPYcev/QnunjEyysZTViyZQ3zHHqXMOTU7hmQUe6NktZr2VBL7/MOoQH
         LRnkJsNNXBuz2xtBcynn9/NVvM26cxPK7AIKDwTiq+h4lfysLhFPMNRBgKccp6sAGL15
         3KvVKD2vbezl0Zm7IM2zlrp3kLBRdaj6sAum2KG+meKZUNZVPW846VJsPnzgbNR8Z1Nf
         ieoCU75F2r4k2Xudizam2gCVZ1/uaG9XnCXmjtsIxURNvCyTth87ZTCRu0R1touAZIj9
         W5yA==
X-Forwarded-Encrypted: i=1; AJvYcCU1wwn6zobfQdVN4ACn7gSA1ED/pV/yGs56P6XiEtzfzo1P9FfSJpN3F3Cvgsc5VCx9t+Q1TcHmYwSoC4bFI62HJlYvWccx9g0FdJslihRr
X-Gm-Message-State: AOJu0Yw4/zJrFhaOa9EgvAeVyf0IT31sBXawUITTfB5x00vdt5iOVHYU
	9oasXGimOdfS+HQNrkLUDI7dd6w0+ThFvNAsHzAA37NGTYE7xo/6IXcd+tfWaxl9dgjXmRHR9+o
	CUA==
X-Google-Smtp-Source: AGHT+IF+eUivr2h0SH34s71+ADV9gRcCXE+IamWe/PIXPtHE74QITKrF4NakeUKYqgv1iKboSormAh7Fcxo=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a05:690c:289:b0:62c:ea0b:a447 with SMTP id
 00721157ae682-6874abdc8a7mr1021287b3.2.1722508583905; Thu, 01 Aug 2024
 03:36:23 -0700 (PDT)
Date: Thu, 1 Aug 2024 12:36:21 +0200
In-Reply-To: <0a3b8596-f3f3-f617-c40d-de54e8ff05f0@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240728002602.3198398-1-ivanov.mikhail1@huawei-partners.com>
 <20240728002602.3198398-3-ivanov.mikhail1@huawei-partners.com>
 <ZqijJPrnCnGnVGkq@google.com> <0a3b8596-f3f3-f617-c40d-de54e8ff05f0@huawei-partners.com>
Message-ID: <ZqtlJZMHVf-otlOq@google.com>
Subject: Re: [RFC PATCH v1 2/9] landlock: Support TCP listen access-control
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com, alx@kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 31, 2024 at 08:20:41PM +0300, Mikhail Ivanov wrote:
> 7/30/2024 11:24 AM, G=C3=BCnther Noack wrote:
> > On Sun, Jul 28, 2024 at 08:25:55AM +0800, Mikhail Ivanov wrote:
> > > LANDLOCK_ACCESS_NET_BIND_TCP is useful to limit the scope of "bindabl=
e"
> > > ports to forbid a malicious sandboxed process to impersonate a legiti=
mate
> > > server process. However, bind(2) might be used by (TCP) clients to se=
t the
> > > source port to a (legitimate) value. Controlling the ports that can b=
e
> > > used for listening would allow (TCP) clients to explicitly bind to po=
rts
> > > that are forbidden for listening.
> > >=20
> > > Such control is implemented with a new LANDLOCK_ACCESS_NET_LISTEN_TCP
> > > access right that restricts listening on undesired ports with listen(=
2).
> >=20
> > Nit: I would turn around the first two commit message paragraphs and de=
scribe
> > your changes first, before explaining the problems in the bind(2) suppo=
rt.  I
> > was initially a bit confused that the description started talking about
> > LANDLOCK_ACCESS_NET_BIND_TCP.
> >=20
> > General recommendations at:
> > https://www.kernel.org/doc/html/v6.10/process/submitting-patches.html#d=
escribe-your-changes
>=20
> I consider the first paragraph as a problem statement for this patch.
> According to linux recommendations problem should be established before
> the description of changes. Do you think that the changes part should
> stand before the problem anyway?

Up to you. To be fair, I'm sold on the approach in this patchset anyway :)


> > When we have the documentation wording finalized,
> > please send an update to the man pages as well,
> > for this and other documentation updates.
>=20
> Should I send it after this patchset would be accepted?

Yes, that would be the normal process which we have been following so far.

(I don't like the process much either, because it decouples feature develop=
ment
so far from documentation writing, but it's what we have for now.)

An example patch which does that for the network bind(2) and connect(2) fea=
tures
(and where I would still like a review from Konstantin) is:
https://lore.kernel.org/all/20240723101917.90918-1-gnoack@google.com/


> > Small remarks on what I've done here:
> >=20
> > * I am avoiding the word "binding" when referring to the automatic assi=
gnment to
> >    an ephemeral port - IMHO, this is potentially confusing, since bind(=
2) is not
> >    explicitly called.
> > * I am also dropping the "It should be noted" / "Note that" phrase, whi=
ch is
> >    frowned upon in man pages.
>=20
> Didn't know that, thanks

Regarding "note that", see
https://lore.kernel.org/all/0aafcdd6-4ac7-8501-c607-9a24a98597d7@gmail.com/
https://lore.kernel.org/linux-man/20210729223535.qvyomfqvvahzmu5w@localhost=
.localdomain/
https://lore.kernel.org/linux-man/20230105225235.6cjtz6orjzxzvo6v@illithid/
(The "Kemper notectomy")

This came up in man page reviews, but we'll have an easier time keeping the
kernel and man page documentation in sync if we adhere to man page style
directly.  (The man page style is documented in man-pages(7) and contains s=
ome
groff-independent wording advice as well.)


> > If I understand correctly, these are cases where we use TCP on top of p=
rotocols
> > that are not IP (or have an additional layer in the middle, like TLS?).=
  This
> > can not be recognized through the socket family or type?
>=20
> ULP can be used in the context of TCP protocols as an additional layer
> (currently supported only by IP and MPTCP), so it cannot be recognized
> with family or type. You can check this test [1] in which TCP IP socket
> is created with ULP control hook.
>=20
> [1] https://lore.kernel.org/all/20240728002602.3198398-8-ivanov.mikhail1@=
huawei-partners.com/

Thanks, this is helpful.

For reference, it seems that ULP were introduced in
https://lore.kernel.org/all/20170614183714.GA80310@davejwatson-mba.dhcp.the=
facebook.com/


> > Do we have cases where we can run TCP on top of something else than pla=
in IPv4
> > or IPv6, where the clone method exists?
>=20
> Yeah, MPTCP protocol for example (see net/mptcp/subflow.c). ULP control
> hook is supported only by IP and MPTCP, and in both cases
> clone method is checked during listen(2) execution.


> > Aren't the socket type and family checks duplicated with existing logic=
 that we
> > have for the connect(2) and bind(2) support?  Should it be deduplicated=
, or is
> > that too messy?
>=20
> bind(2) and connect(2) hooks also support AF_UNSPEC family, so I think
> such helper is gonna complicate code a little bit. Also it can
> complicate switch in current_check_access_socket().

OK, sounds good. =F0=9F=91=8D

=E2=80=94G=C3=BCnther
