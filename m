Received: from serval.cherry.relay.mailchannels.net (serval.cherry.relay.mailchannels.net [23.83.223.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AE62367D7
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Oct 2025 23:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.163
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760137624; cv=pass; b=CN3+4y8S97tWlB9V1j6b+EQoymiMh7jxfgovEow7rwsIvskk0Jddo8Q3kxm1ZJeTByBMPtMfmnmhlCUEjHUi6dMRvCUciS1I8NY8FmsA+c3u5RVcHDkW840BmLicn0tvua9PbLDDujedKSiABZVQEODFQjrLEkUiJ4lVbs/iI0Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760137624; c=relaxed/simple;
	bh=IrNF6JegBiRDF0y+03k2wvzOnUqUlwnUg9JEM4Ze33o=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OA9JNQjycOLG3eeshzR0salDOO64z4/ckucglKvA/jUgJyVlg79/zacFV5MHJk0bQlqEt5ClBDmwdbSuSr34qexyJQoOySPgcMPVZmPicvBWQ/s9HEnAa4PMBDd+B+Z8DUZ2Ip37n9dV2aBix/j/xvkujHNk8Yt4iCEgE0hd6W4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=christoph.anton.mitterer.name; dkim=fail (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b=P7/s0xfI reason="key not found in DNS"; arc=pass smtp.client-ip=23.83.223.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b="P7/s0xfI"
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id ABE57360ADE;
	Fri, 10 Oct 2025 23:06:55 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-0.trex.outbound.svc.cluster.local [100.117.100.69])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id D06A5360CF0;
	Fri, 10 Oct 2025 23:06:54 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1760137615; a=rsa-sha256;
	cv=none;
	b=gcYD8lZDh6WrqtjXbinYAxH7mMWte+xvU+u7BODmjNedVfNvCZli8E/HAVVPvrDjrnX5Of
	nx1sAWz+jXcqOH9eybdFppN/VC0wN2rCqInzHmJwlf0eMti1kp6KHMJfFlDLSh2biLWtAj
	PObqE7rixOXeKWV9sDrLetzb3WZ+CLJiB+6rbUTYPXWof/j3PiW3xkDZWJydhRoYiVFnW6
	3vHV5GyC8GIKh6hOMVwR2Pa921Rl0Lnrs3TjiJBmI0LWzC0ggcGWL+OT9NpoHPRq59uHcb
	j9GqnPQ+se1NnJsv6XIfv90ZF5iU2LATYMxpmBjpT5/1c4xsZO3+WniiVm6KXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1760137615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rgEuM8PPP6dP4N3SDWbPmM2Nn96kK5oJYd90uomSscA=;
	b=nxryLG5kFp3IYUws4aIw3XeJb3qC0htIJnDszFcqmWU5LXK9VUnH3DaKMPUVYmSg7AVQwn
	UOTS0fhw4d52CJDi47BxZjDp3b2o9EQeSB29Pd5meq5mrUfP/6Zu5ddQOJOPNxONDhWc+S
	xDV77NAzNqp7SrJ2vJHYBQc4VXswR59r51MYaY6p3lgKk+BOxO8msHyDf6uALK5kVwOFX3
	SXIPwREV+IRGqg+jnEQPSL9aavTQoZ1HpNZET7OwLG7tRoBLQKQYVoJnGnMBYertyKNcQ1
	9bI+2es3ZuW2e8OxIoyR7EABSbdsCez/0uRp4EY4tkghNka99ucNH4a2eljapQ==
ARC-Authentication-Results: i=1;
	rspamd-668c7f7ff9-w2q82;
	auth=pass smtp.auth=instrampxe0y3a
 smtp.mailfrom=mail@christoph.anton.mitterer.name
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MC-Relay: Neutral
X-MailChannels-SenderId:
 instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MailChannels-Auth-Id: instrampxe0y3a
X-Name-Madly: 5f10291268df9ef1_1760137615529_2713415843
X-MC-Loop-Signature: 1760137615529:2781847222
X-MC-Ingress-Time: 1760137615528
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.117.100.69 (trex/7.1.3);
	Fri, 10 Oct 2025 23:06:55 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=christoph.anton.mitterer.name; s=default; h=MIME-Version:
	Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From
	:Subject:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=rgEuM8PPP6dP4N3SDWbPmM2Nn96kK5oJYd90uomSscA=; b=P7/s0xfIyhy3
	qMYxcAD+eMacWz/llYdxN9LtU9yTM8o6SOUi71Lq/xFPpoA4u3EsFFoxG3vRtGFxsQgqN8AoJDaub
	ROn75jjaiyulFF85qyQXRvLoPlhikBC3fIMc3sHawExjCAU1z1ra/AfXQfLd38/bGQ312p+ZD0yb+
	NGJXz6282Bh00Lz2nC7Cs5niFZfHc3AcH3NzwHxP5vlyFH7Gq2vQnjiLbjW+VEVsvceQeBImoFfzW
	UjHgtQxkIOLWRIHHPJhUmHPrYguMkqcBNuK5na+eh067bzVuU/aaXBSvtvGys1p/UrPejOsCgCT0U
	699Nu2nU16WImGjIbXNNUQ==;
Received: from [212.104.214.84] (port=4585 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <mail@christoph.anton.mitterer.name>)
	id 1v7MCN-00000009LmM-2cgd;
	Fri, 10 Oct 2025 23:06:53 +0000
Message-ID: <533b405b3a540527f2f0716fe4a24b6c53863634.camel@christoph.anton.mitterer.name>
Subject: Re: [PATCH 2/7] doc: fix/improve documentation of verdicts
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sat, 11 Oct 2025 01:06:51 +0200
In-Reply-To: <aN6YkhJxliaNw2u2@strlen.de>
References: <aNTwsMd8wSe4aKmz@calendula>
	 <20250926021136.757769-1-mail@christoph.anton.mitterer.name>
	 <20250926021136.757769-3-mail@christoph.anton.mitterer.name>
	 <aNu1-kwUzXGXyNLJ@strlen.de>
	 <38e6a25fd2d311e2f33b1881542a9ce7b8a8473d.camel@christoph.anton.mitterer.name>
	 <aN6YkhJxliaNw2u2@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-5 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-AuthUser: mail@christoph.anton.mitterer.name

Hey.


On Thu, 2025-10-02 at 17:21 +0200, Florian Westphal wrote:
> > What's IMO important from the user PoV is that for example at a
> > sentence like:
> > > *accept* and *drop*/*reject* are absolute verdicts, which
> > > immediately
> > > terminate the evaluation of the current rule, i.e. even any later
> > > statements of the current rule won=E2=80=99t get executed
>=20
> Why not shorten it to "accept/drop/reject immediately terminate ..."

I solved that a bit different now, please have a look whether that's
fine for you.


>=20
> > I'm not sure how much we win, by differentiating between these two,
> > and
> > even if we do so, how shall we call things like reject? "verdict
> > like
> > statements"? "statements that imply a verdict"?
>=20
> What about "terminal statements"?
> This is already used in the man page in several places.

Hmm. Personally, I think "terminal" is a bit confusing, at least for
beginners, because we have termination on multiple levels:
- Termination of a rule and (AFAICS) then also always of the respective
  base chain and any regular chains called by that.
  As e.g. done by accept.
- Termination of the overall ruleset evaluation.
  As e.g. done by drop, reject (by implying drop).

From how I understood your explanation, the "terminating" is not an
inherent property of e.g. reject itself, but rather of drop/accept,
whereas the inherent property of reject is, that it implies a drop (at
the end).

So I'd have now gone the way to describe reject/synproxy and the NAT
statements as implying a verdict and further explaining that they thus
act like verdicts.
Further, giving, some concrete examples (like that reject also
completely ends ruleset evaluation, as drop does - which I think is
important).


> >=20
> > Is there a complete list of all these which are verdict-like and
> > what
> > verdict they actually imply?
>=20
> No.
>=20
> net/bridge/netfilter/nft_reject_bridge.c:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 regs->verdict.code =3D
> NF_DROP;
> net/ipv4/netfilter/nft_reject_ipv4.c:=C2=A0=C2=A0 regs->verdict.code =3D =
NF_DROP;
> net/ipv6/netfilter/nft_reject_ipv6.c:=C2=A0=C2=A0 regs->verdict.code =3D =
NF_DROP;
> net/netfilter/nft_reject_inet.c:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 regs->verdict.code =3D NF_DROP;
> net/netfilter/nft_reject_netdev.c:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 regs->ve=
rdict.code =3D NF_DROP;
>=20
> These are "obvious", reject is a fancier drop.
>=20
> net/netfilter/nft_compat.c:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 regs->verdict.code =3D
> NF_ACCEPT;
> net/netfilter/nft_compat.c:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 regs->verdict.code =3D NF_DROP;
>=20
> irrelevant for nftables
>=20
> net/netfilter/nft_connlimit.c:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 regs->verdict.code =3D NF_DROP;
>=20
> Error handling only
>=20
> net/netfilter/nft_ct.c:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 regs->verdict.code =3D NF_=
DROP;
> net/netfilter/nft_ct.c:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r=
egs->verdict.code =3D NF_DROP;
> net/netfilter/nft_exthdr.c:=C2=A0=C2=A0=C2=A0=C2=A0 regs->verdict.code =
=3D NF_DROP;
> net/netfilter/nft_fib_inet.c:=C2=A0=C2=A0 regs->verdict.code =3D NF_DROP;
>=20
> Same, only errors
>=20
> net/netfilter/nft_fwd_netdev.c: regs->verdict.code =3D NF_STOLEN;
>=20
> Terminal (packet is redirected)
>=20
> net/netfilter/nft_synproxy.c:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 regs->ve=
rdict.code =3D
> NF_DROP;
> net/netfilter/nft_synproxy.c:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 regs->ve=
rdict.code =3D
> NF_STOLEN;
> net/netfilter/nft_synproxy.c:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 regs->verdict.code =3D NF_DROP;
> net/netfilter/nft_synproxy.c:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 regs->verdict.code =3D
> NF_STOLEN;
>=20
> Also terminal, 3whs packets are dropped resp. stolen
> for further processing.

As far as I understood this:
- the NAT statements imply accept (and can later be overruled)
- reject implies drop
- synprxy implies drop
  Not sure what stolen does... since it doesn't seem to appear at
  all=C2=A0in nftables, I merely wrote now, that it implies drop.
  Please correct as needed.
- the others don't even show up in nftables?


Btw, one further question that just popped up:
In the VERDICTS section, accept/drop are described as "absolute", which
at this point I describe in my patch as:
> which immediately terminate the
> evaluation of the current rule, i.e. even any later statements of the
> current
> rule won=E2=80=99t get executed.

a) Does the term "absolute" really just mean "ends the current rule" or
=C2=A0  does it mean additionally mean "and the current base chain and any
   regular ones called from that?
   Cause my current wording, would rather imply it means only the
   former (while the actual verdicts are still described as also
   causing the latter).
b) Are jump/goto/return/queue/etc. i.e. all those which *DON'T* imply a
   accept or drop also absolute? I presume not, if the term also
   means "end current base/regular chains".
   But even if not, do these verdicts (jump/goto/return/queue/etc.)
   still cause the current rule to be ended?
   like in:
      jump counter
   vs
      counter jump

   Even with continue?

Cause then I need to update that in another iteration of the patch
series.


> Yes, I think an example would be prudent, it is probably simpler
> to unstand rather than describing the mechanism.

I've changed things now as follows:
- In the VERDICTS section, I keep things rather "abstract" and focused
  on the respectve verdict that we're just explaining.
  So examples will be in the evaluation summary chapter rather than
  there.
  Also e.g. at jump/goto it's *not* explained how the return position
  is determined... this is instead done at the return verdict.
  But what I do at jump is, describing what happens if there's an
  absolute verdict and if there's no verdict at all (i.e. the implicit
  return).
  Hope that split up makes kinda sense.

  goto I really describe as exactly jump, just without storing the
  position.
- I also reordered the verdicts to an IMO more reasonable order, in
  particular, continue and queue are IMO the least interesting ones for
  most users.
- In the summary chapter I give examples and describe it a bit more
  human readable.
 =20

> > But rather *if* there's nowhere to return to (like when it's called
> > from a base-chain) *then* the policy is applied, right!?
>=20
> Yes.

I did that now in the VERDICTS section and there in the return
statement.
What I do not explicitly mention is that the policy is also applied
when there *is* one last position to pop on the call stack, but when
there's no rule after that (i.e. the jump was the last rule in a base
chain).
But I kinda hope that it's obvious that this then also applies.

In principle that should perhaps be mentioned where policies are
explained (and of course in the summary chapter, too).
Or what would you think?


> >=20
> > As far as I understand it now:
> > =C2=A0 base --jump--> regularA --goto--> regularB
> > then at the end of regularB or if return is called in it, while I
> > don't
> > return to regularA, I actually will return to the jump position in
> > base, right?
>=20
> Yes, rules in "regularB" are evaluated as if they would reside in
> regularA, it resumes in the base chain.
>=20
> > Similar in:
> > =C2=A0 base --jump--> regularA --jump--> regularB --goto--> regularC
> > I will not return to regularB, but will return to the jump position
> > of
> > regularA and then to that of base, right?
>=20
> Yes.
>=20
> > Very open for opinions, but I do think with that semantics it
> > actually
> > might be best to describe things with a call stack an give some
> > examples.
>=20
> Yes, I think examples are best here.

I've added a number of examples to the summary chapter.


Thanks,
Chris.
