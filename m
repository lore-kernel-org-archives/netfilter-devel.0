Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=136.143.169.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793958435;
	b=LU4/+6NLFZ7Dt/k1j/1Mrj0IfYNtxZywucE1NigF7AwiFXNDkwgtwqm7knZFxeA6nQmu
	 VhJL8YXo7mbKB4looXFlxt2urVaVIsOF2+7Uy0lo4skGgFk7/UFvu+CkH8Bc92Tqd38vq
	 4dhfzkttudjiDTE9J/LtIQ7JjBBmCrChtRsLvneXtouLdOcIdRLArwKtWssqYyQHROUO0
	 VoBR3cX+dgiGVxEnNyD363GBB3JSE2KuqjSNN2+gr/PXCR3ZmK0YihFBGiP7iecA8JJet
	 uR7T76QfLfttQ0pXrHUV5Irx9Bj4YvIXdEso6nhHWJq4TI0yjqDqI6ZvBaDhPxyeA5g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793958435;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Message-ID:
	 In-Reply-To:References:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Importance:User-Agent:X-Mailer;
	bh=KGWOanORJOsPJiH8nHT2neCvFSKdDJwDjyYcGTPjuQA=;
	b=PwIbnGUQ567jmNgQZfr/TaIDhPmJ4AsQnjd7nQRosJxg/K4aHlISllO/QZInZ4o0rCoZ
	 S1v7p32z3KCjSTUC1MbBSL972bTLpUbvAik4EhBaVSQaIxE9+P+HHyxTY20Wun7pMUeu5
	 QQEse1b/hIJODZ6IxRAHYSTby7D3chUOlgq1qsd9mDBqkneimadmHcTYEcF43e2SP+miR
	 J9VzVNrvl6qP+QwacoA4cyKq+FhKUnApyCy1x378GRZcIjD0FBWswWbdZriF5/DZSdaZv
	 R5hQsObZlWzzJSzFvsHvTVZDtexnMPg72XLfdAilpz1UkVwY10p7Cezvv4PYuOZkkbw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=asgari.net;
	spf=pass smtp.mailfrom=asgari.net;
	dkim=pass header.d=asgari.net header.i=@asgari.net header.a=rsa-sha256 header.s=zmail header.b=CuC3WrGO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=136.143.169.50
Received: from sender-of-o50.zoho.eu (sender-of-o50.zoho.eu [136.143.169.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BD6606A326;
	Fri,  6 Nov 2026 09:47:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5BD6606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asgari.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asgari.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=asgari.net header.i=@asgari.net header.a=rsa-sha256 header.s=zmail header.b=CuC3WrGO
ARC-Seal: i=1; a=rsa-sha256; t=1793958403; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=C1v6whtdB/SAVNYHEFOVJBXRrHgtOze15gO5BJZdymbpCgXQVzuNAH0IrEmf6jvMIt/OZv26yAuTiKPUMntBLYj7IANmZt2jTslSAYDgCJHJV0pFuUbKZuwGv9pt6zfMpksehseXcIePnnHipKmdX0wY3PNIWA940R+tnkqlHM0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1793958403; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=KGWOanORJOsPJiH8nHT2neCvFSKdDJwDjyYcGTPjuQA=; 
	b=VC22+Od9a2ofg9IxBTuATb2WZvpzB+oNKDQZsX/MnJuDjliy17Q8MA6bkdKjl4J0X31Be0lKqaw6j0+g7OSCe6UW8FNvbi/Ny1TpNYj3zC6rlFHlIvsKA8RGD8k5DGrx2QYpg7gkuY64qyP9SpVITrwCe8pCrxIweUoEea5S5AU=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=asgari.net;
	spf=pass  smtp.mailfrom=alireza@asgari.net;
	dmarc=pass header.from=<alireza@asgari.net>
DKIM-Signature: a=rsa-sha256; b=CuC3WrGOfIrde/sn4FZjliqjZUm0Vxvkut3UPqvc9cFeeYI2Vsxe1oHPLUzcgTw2Xi15FIutVakTOZHJakaGAyyDEZbm7dtbMoJ5BJjvPik2DBBpJWTGNl+HlbqBb/fUEKdYQ1f3bkZMHjfNUjYMwNuGq3ETRyEmuoPWJLcMW/I=; c=relaxed/relaxed; s=zmail; d=asgari.net; v=1; bh=KGWOanORJOsPJiH8nHT2neCvFSKdDJwDjyYcGTPjuQA=; h=Content-Description:Content-ID:Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:List-Subscribe:List-Post:List-Owner:List-Id:List-Archive:List-Help:List-Unsubscribe:MIME-Version:Message-ID:Resent-Sender:Resent-Cc:Resent-Date:Resent-To:Reply-To:Resent-Message-ID:Resent-From:Sender:Subject:To:Date:From:Message-Id:Reply-To:Subject:To:Cc;
Received: from mail.zoho.eu by mx.zoho.eu
	with SMTP id 1793958402628213.30561622537778; Fri, 6 Nov 2026 10:46:42 +0100 (CET)
Date: Fri, 06 Nov 2026 10:46:42 +0100
From: Alireza Asgari <alireza@asgari.net>
To: "Florian Westphal" <fw@strlen.de>
Cc: "Pablo Neira Ayuso" <pablo@netfilter.org>, "Phil Sutter" <phil@nwl.cc>,
	"netfilter-devel" <netfilter-devel@vger.kernel.org>,
	"netdev" <netdev@vger.kernel.org>,
	"kunit-dev" <kunit-dev@googlegroups.com>
Message-ID: <1a1b040da34.2a9c00de770859.6266910270967560587@asgari.net>
In-Reply-To: <au1difVZWMSV78wV@strlen.de>
References: <20261106-nfqueue-review-v1-0-b6c933f44943@asgari.net> <au1difVZWMSV78wV@strlen.de>
Subject: Re: [PATCH RFC net 0/3] netfilter: nfnetlink_queue: handle packet
 ID reuse and large gaps
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail

Thanks for the review.

I understand that batch verdicts are intended to be used in strict sequence=
. The scenarios motivating this RFC did not establish a failure under that =
usage model, and the evidence presented does not justify the additional epo=
ch and missing-boundary handling.

I=E2=80=99ll drop the current series. I also understand that the proposed c=
ollision disposition being reasonable does not by itself establish a need f=
or the duplicate-ID guard. I would revisit that separately only if I can pr=
ovide a concrete use case.

Thanks for taking the time to review it.



From: Florian Westphal <fw@strlen.de>
To: <alireza@asgari.net>
Cc: "Pablo Neira Ayuso"<pablo@netfilter.org>, "Phil Sutter"<phil@nwl.cc>, <=
netfilter-devel@vger.kernel.org>, <netdev@vger.kernel.org>, <kunit-dev@goog=
legroups.com>
Date: Fri, 06 Nov 2026 05:54:33 +0100
Subject: Re: [PATCH RFC net 0/3] netfilter: nfnetlink_queue: handle packet =
ID reuse and large gaps

 > Alireza Asgari via B4 Relay <devnull+alireza.asgari.net@kernel.org> wrot=
e:=20
 > > This series addresses packet-ID reuse and batch-verdict ordering in=20
 > > NFQUEUE. I am posting it as an RFC to discuss the handling of ambiguou=
s=20
 > > batch boundaries and the additional sequence state used to resolve the=
m.=20
 > =20
 > -v.  I see 0 bugs here.  Only lots of code churn.=20
 > =20
 > > An old packet can remain queued while newer packets receive individual=
=20
 > > verdicts.=20
 > =20
 > Not really, that would be a userspace bug.  Its not adviseable to do=20
 > out-of-order verdicts.  I know some people do that though :-/=20
 > =20
 > > Queue length therefore does not bound the distance between=20
 > > pending packet IDs. After a complete 32-bit ID cycle, two pending pack=
ets=20
 > > can have the same ID, making verdict lookup ambiguous. Even before reu=
se,=20
 > > the signed 32-bit comparison in the batch handler can select the wrong=
=20
 > > FIFO prefix when IDs are separated by half an ID cycle or more.=20
 > =20
 > WTF, whats the point of doing that?=20
 > =20
 > > Patch 1 rejects an incoming duplicate ID before list insertion or user=
space=20
 > > notification, preserving the existing pending packet. The incoming pac=
ket=20
 > > follows the existing enqueue-failure policy: drop by default, or accep=
t=20
 > > with FAIL_OPEN.=20
 > =20
 > OK, but really... who needs this?=20
 > =20
 > > Patch 2 uses an exact queued boundary to select the FIFO prefix. For a=
=20
 > > boundary no longer queued, it uses a 64-bit queue sequence and a per-e=
ntry=20
 > > 32-bit epoch to recover issuance order. Ambiguous missing boundaries=
=20
 > > return -ERANGE without changing the queue. The wire format is unchange=
d,=20
 > > but the rejection behavior is userspace-visible. This does not disting=
uish=20
 > > stale verdicts after an ID has been released and reused.=20
 > =20
 > Insane... tons of code added for what?  Batch verdicts are incompatible=
=20
 > with out-of-order verdicts.  I fail to understand why the kernel needs=
=20
 > to become more complex and more complex and more complex.=20
 > =20
 > LLMs make it oh-so-easy but whats left is even more unmaintanable than=
=20
 > the current state.=20
 > =20
 > > I would appreciate feedback on:=20
 > >=20
 > >   - Whether -ERANGE with the queue unchanged is the appropriate respon=
se=20
 > >     for an ambiguous missing batch boundary.=20
 > >   - Whether the per-entry epoch and widened queue counter are appropri=
ate=20
 > >     for handling boundaries that have already been removed.=20
 > =20
 > Sorry, I have no idea what these patches should accomplish.=20
 > =20
 > >   - Whether the existing drop/FAIL_OPEN policy is the preferred way to=
=20
 > >     handle an incoming packet whose ID is still pending.=20
 > =20
 > That one is fine, even though I would really like to understand what use=
=20
 > case requires holding on to a packet for 2**32 (!) Ids to pass.=20
 >=20


