Received: from buffalo.tulip.relay.mailchannels.net (buffalo.tulip.relay.mailchannels.net [23.83.218.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18AC27A468
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Oct 2025 23:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760138159; cv=pass; b=cB02PVDU5heMj7fRCTaujRQKiWh4j/kDJXRQCRuVpAF04SPcgG3Cf695sa8iAgoQWXDGaQ0M7uePpDIA4epVPRIwhiM557mdC4BBQgBNB5U+unckhQenmZ9rL4/juBwhsfjlG/aOlB2au9rIDZ/b2DtQXAdfO1BnwHI72Nyoe08=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760138159; c=relaxed/simple;
	bh=xyY/PyuO17JbJr77UvIfjWDskSvS2FnlLgxcgkfls5Y=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EI8b2v62Qqgov4Q5fEjplixdWKsSTnx0ezT8EVnId28wywkQi1pxULYiukfNZ1d3LJ7FGKN+B44jLb6syL9uDFVeLPPMwrWsbeKT4OlCN9Z8+VNf3pBd9d3vcZ5NIeKlb3ZWFZXseY+9Mpf+PzTK7vatLWgOxBPUEXKjzJVhLA0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=christoph.anton.mitterer.name; dkim=fail (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b=M6m1kcHV reason="key not found in DNS"; arc=pass smtp.client-ip=23.83.218.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b="M6m1kcHV"
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 926A68A13EC;
	Fri, 10 Oct 2025 23:07:19 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-113-91-253.trex-nlb.outbound.svc.cluster.local [100.113.91.253])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 8DA338A03F4;
	Fri, 10 Oct 2025 23:07:18 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1760137639; a=rsa-sha256;
	cv=none;
	b=J5oo3+/siAcp6vV6AUkqKFckknuzDjerC/CwnuBnVvop3rroquOVASu0yq7SctdDFl837g
	BywaydhKoQGyVdS4OFNAOXMnEa96C3K40o/Ra5WMaxKXwJSCMDYhG5/fe4S1YXt/3CeCkG
	IlcsF9CfpZ5MkCtMi9PiZSxHUUMbrEQm6O42JmEN/JyJmgIah5bF5kZJnrXIOPJCGeeOw6
	ItlCCGCJ+6ozDCcmRfexapuFDkpIg7raqwFyvLkw/wZJxnjrg3dHP5mvxS9Kq3+msECfeW
	78TcZAyMJa+ibR9z6LSNXObJCFH6Dh7u4OtXtN+H0R6gBXXiRSupjp0krQU2Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1760137639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/QZE6Z+01ETaNo31T7ZJoZxnkir05lV5ZXPrCCIMBYo=;
	b=5+aIP8s49xTrRVdVNPWZGwNxQnafgen0/isnjRCOTGQ99wUTGY0T6yqa46nfDSrQQDlVlP
	s+FIC66Ub7e/kTGRO0kigy3wadvXXf6oydP8+1GdJqNauxegly6kUAo/35bhEic9/g8QMx
	P9cVJ8pSykRPANWYmwbxRuuQcMcrcZ+/MzNNrKikoAhE+vbOlXm5TXugkPg/RQ2PhySB/W
	lXiKdkeLXqrvuKOFwISoVTLQfF/z8NQz/FAev2qqh5HPCr+g8pxZBpU26XJC36M4GJGrq2
	IgQbDGgAW4Pf2635puN2dBpxhR2vatREK1VSDoP3/ZnE03ANWcteiMXfoDz9ug==
ARC-Authentication-Results: i=1;
	rspamd-668c7f7ff9-dj9kz;
	auth=pass smtp.auth=instrampxe0y3a
 smtp.mailfrom=mail@christoph.anton.mitterer.name
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MC-Relay: Neutral
X-MailChannels-SenderId:
 instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MailChannels-Auth-Id: instrampxe0y3a
X-Average-Fearful: 3939fc4c13d6bb18_1760137639411_614368084
X-MC-Loop-Signature: 1760137639411:3391761481
X-MC-Ingress-Time: 1760137639411
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.113.91.253 (trex/7.1.3);
	Fri, 10 Oct 2025 23:07:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=christoph.anton.mitterer.name; s=default; h=MIME-Version:
	Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From
	:Subject:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=/QZE6Z+01ETaNo31T7ZJoZxnkir05lV5ZXPrCCIMBYo=; b=M6m1kcHVGE0S
	PuPjTsYIejMZDr4Ys7qSgCm1WYxmU2KvXCTbt+foOLMxEnKE3w3V2hjArKA2ygNXsSqE21UnG9re6
	FBZ7Z0iZglO4zViJq0eUvdKCRWJcU2cI+fYU3lBPkDcP7D+v0O/1uRozfQw+2R9QlUZ1qAIZse8n0
	ac4kAHl/pm5nBxMNFK6+NFPxyhhD0evTxDjoR2veLQaTnA1QCqDkA7nVjBADQSBikC7GVQb6is/2A
	C0MHrfVICIBm32BhXFIerhAUmU+IamX3PIbB/S7/KLCEM7ZN4xZZvvuNUc1T0cLsaluTmzNEGK2mN
	xYEOwpv7v2PaFBPWcreSqg==;
Received: from [212.104.214.84] (port=38749 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <mail@christoph.anton.mitterer.name>)
	id 1v7MCl-00000009Lsy-0Dy8;
	Fri, 10 Oct 2025 23:07:16 +0000
Message-ID: <a9790d0ae61fda6405d32e26a533cd4283aeb0b4.camel@christoph.anton.mitterer.name>
Subject: Re: [PATCH 4/7] doc: add overall description of the ruleset
 evaluation
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sat, 11 Oct 2025 01:07:15 +0200
In-Reply-To: <aNvECxpxlsYS7Noy@strlen.de>
References: <aNTwsMd8wSe4aKmz@calendula>
			 <20250926021136.757769-1-mail@christoph.anton.mitterer.name>
			 <20250926021136.757769-5-mail@christoph.anton.mitterer.name>
			 <aNvECxpxlsYS7Noy@strlen.de>
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


Sorry for the delay... but I've been travelling to some science
conference.


On Tue, 2025-09-30 at 13:50 +0200, Florian Westphal wrote:
> > +=C2=A0 various ICMP types and are sysctl options lik
>=20
> Minor typo, 'like'.

Thx for catching.


> > +=C2=A0 `net.ipv{4,6}.conf.*.forwarding` or `net.ipv4.conf.*.rp_filter`=
.
> > +* With respect to the evaluation tables don=E2=80=99t matter at all an=
d
> > are not known by
> > +=C2=A0 netfilter.
> > +=C2=A0 They=E2=80=99re merely used to structure the ruleset.
>=20
> 'evaluation ordering'?=C2=A0 Tables do matter in the sense that you can't
> have any chains without them.

What would you think about merely adding a "," after "evaluation"?
"Evaluation ordering" could be understood as implicitly meaning that it
doesn't have an effect on the ordering of the evaluations, but might
still have some other effect (from netfilter's PoV).


> > +* Packets traverse the network stack and at various hooks they=E2=80=
=99re
> > evaluated by
> > +=C2=A0 any base chains attached to these hooks.
>=20
> Maybe add the hook names here?=C2=A0 (preouting, input, and so on).
> Or a reference to this topic.

I've added a reference to the ADDRESS_FAMILIES chapter.

One may argue now whether this defeats the purpose of the summary
chapter, if one has again to look things up somewhere else.

I have no strong opinion in this case, but I would say that a user
realises quite soon what hooks are (in particular input/output/forward
are probably well known)... so I don't think it's necessary to explain
here *what* they are,... but it's good to give a reference to the full
list, so that a reader can cross check whether some foobar term he
stumbled over is actually a hook or not.


> > +* For each hook, the attached chains are evaluated in order of
> > their priorities
> > +=C2=A0 (with chains with lower priority values being evaluated before
> > those with
> > +=C2=A0 higher values and the order of chains with the same value being
> > undefined).
>=20
> It took me a sec to parse this, maybe:
>=20
> ... higher values.=C2=A0 The order of chains with identical priorities is
> undefined.
>=20
> (or similar).

Also disliked that sentence when I wrote it,... but found nothing
better where I could keep it in parentheses.
I removed those now and made two proper sentences.

Also made an analogous change in patch 1 of this series.


> > +* An *accept* verdict (including an implict one via the base
> > chain=E2=80=99s policy,
> > +=C2=A0 even if caused in certain cases by a *return* verdict) ends the
> > evaluation of
> > +=C2=A0 the current base chain and any regular chains called from that.
> > +=C2=A0 It accepts the packet only with respect to the current base
> > chain, which does
> > +=C2=A0 not mean that the packet is ultimately accepted.
>=20
> Maybe: 'It accepts the packet only with respect to the current base
> chain.'=C2=A0 The rest is already made clear by your next sentence:

done


> > +=C2=A0 Any other base chain (or regular chain called by such) with a
> > higher priority
> > +=C2=A0 of the same hook as well as any other base chain (or regular
> > chain called by
> > +=C2=A0 such) of any later hook may still utlimately *deny*/*reject* th=
e
> > packet with
>  ~~~~~~~ ultimately, but i'd just
>  remove this word.

I thought it might help to reiterate that drop - unlike accept - is in
fact ultimate, ... in particular to point out, that it can't be
overridden by a later accept in another chain.

Have merely fixed the typo for now, waiting for further feedback,
whether I shall remove it altogether.

> please avoid 'deny' and use 'drop' everywhere.=C2=A0 In this case,
> .. may still drop the packet.

Mistakenly used... must have mixed up drop and deny at some point. O:-)


> > +=C2=A0 Thus and merely from netfilter=E2=80=99s point of view, a packe=
t is only
> > accepted if
> > +=C2=A0 none of the chains (regardless of their tables) that are
> > attached to any of
> > +=C2=A0 the respectively relevant hooks issues a *deny*/*reject* verdic=
t
> > (be it
> > +=C2=A0 explicitly or implicitly by policy) and if there=E2=80=99s at l=
east on
> > *accept*
> > +=C2=A0 verdict (be it explicitly or implicitly by policy).
>=20
> I'm not sure if the last part is needed as there is no such thing as
> a
> base chain without a policy, so i would simplify this to:
>=20
> Thus a packet is only accepted if no chain or rule issues a drop
> verdict, including chain policies.

In principle yes, but that's IMO already "quite some" conclusions that
a novice reader would need to draw, i.e. the combination of:
- no drops by any mean
plus
- all chains have a policy
plus
- policy is any of drop/accept
thus, there must be at least one accept, if nothing drops.

In teaching, which this chapter is in principle meant for, I'd rather
keep things as simple as possible not requiring the reader to draw
implicit conclusions.

I changed it however a bit to make it more clear that "at least one
accept" is already implied by "nothing drops".
If you still want it to removed, just tell.


> > +=C2=A0 In that, the ordering of the various base chains per hook via
> > their priorities
> > +=C2=A0 matters (with respect to the packets utlimate fate) only in so
> > far, if any of
> > +=C2=A0 then would modify the packet or its meta data and that has an
> > influence on the
> > +=C2=A0 verdicts =E2=80=93 if not, the ordering shouldn=E2=80=99t matte=
r (except for
> > performance).
>=20
> I'm not sure about this paragraph.=C2=A0 While its correct, base chains
> and
> their priorities still have effects, e.g. if ip defragmentation has
> taken place or not.=C2=A0 I think the previous paragraph is clear enough
> wrt.
> packet acceptance.

What I wanted to say with that paragraph was effectively:

The ordering of chains via priorities, doesn't matter with respect to
whether a packet is ultimately accepted or dropped.
Except of course, an earlier chain modifies something on the packet,
which no longer causes it to be dropped/accepted.

While that is of course a logical conclusion from the earlier text, I
think it's nevertheless good to have it explicitly mentioned.

E.g. when I transitioned to nftables and looked at what fail2ban does
when using its nftables backend, I was first a bit puzzled when I saw
that it uses a chain priority of -1.
At a first glance I thought +1 would be better so that my normal filter
table could "fast-accept" e.g. all related,established packets and
traversing the (potentially long) fail2ban chain would be short-cut.

Of course I then realised that this is not really how it works, and
short-circuiting is only possibly via drop/reject/etc..


> > +* A *drop*/*reject* verdict (including an implict one via the base
> > chain=E2=80=99s
> > +=C2=A0 policy even if caused in certain cases by a *return* verdict)
> > immediately ends
> > +=C2=A0 the evaluation of the whole ruleset and ultimately drops/reject=
s
> > the packet.
> > +=C2=A0 Unlike with an *accept* verdict, no further chains of any hook
> > and regardless
> > +=C2=A0 of their table get evaluated and it=E2=80=99s therefore not pos=
sible to
> > have an
> > +=C2=A0 *drop*/*reject* verdict overturned.
>=20
> As noted elsewhere, reject is just a more fancy drop, it should not
> be
> mentioned here.

I've reworked the integration of *reject* and verdict-like statements
everywhere.
In some places, like the one here where I describe drop, I still
mention them, though less prominent.
Simply because I think it's helpful if people get told at the important
places, that reject/etc. effectively behave like drop (by internally
issuing it).

Just have a look whether you're fine with the way I did it, and if you
still think it should be changed, we can of course reiterate.


> > +=C2=A0 Thus, if any base chain uses drop as it=E2=80=99s policy, the s=
ame base
> > chain or any
> > +=C2=A0 regular chain directly or indirectly called by it must accept a
> > packet or it
> > +=C2=A0 is ensured to be ultimately dropped by it.
>=20
> Can that be reduced to something like:
>=20
> Thus, base chains that use 'policy drop' must contain at least one
> accept rule or
> must call another chain with an accept rule to avoid blocking all
> traffic.

That seems a bit imprecise to me?

The sections describe things from the view of a single packet, but
you're now referring to all traffic?
Also, "must contain/call with"... isn't really exactly true, is it?! I
mean the intention may just be to do that.


> > +* A *jump* verdict causes evaluation to continue at the first rule
> > of the
> > +=C2=A0 regular chain it calls. Called chains must be of the same table
> > and cannot be
> > +=C2=A0 base chains.
>=20
> 'must reside in same table'?

"reside" feels also awkward. What about "belong to" or "be from" (which
I'd have chosen now)?


> > +=C2=A0 If no other verdict is issued in the called chain and if all
> > rules of that
>=20
> .. chain... ?

I've completely changed that part, so this is gone anyway.


> > +=C2=A0 have been evaluated, evaluation will continue with the next rul=
e
> > after the
> > +=C2=A0 calling rule of the calling chain.
> > +=C2=A0 That is, reaching the end of the called chain causes a =E2=80=
=9Cjump
> > back to the
> > +=C2=A0 calling chain=E2=80=9D respectively an implicit *return* verdic=
t.
>=20
> Yes, this is why there is sometimes a reference to the call stack /
> or
> chain stack.
>=20
> 'jump' makes a 'where am I' note, 'goto' doesn't.

I think I'm described that now correctly.
Same with respect to your other comments, that were about my wrong
description of how the returning from jump/goto works.

Please check :-)


> > +* All verdicts described above (that is: *accept*, *drop*,
> > *reject*, *jump*,
> > +=C2=A0 *goto* and *return*) also end the evaluation of any later
> > statements in their
> > +=C2=A0 respective rules (or even cause an error when loadin such rules=
)
> > with the
> > +=C2=A0 exception of the `comment` statement.
>=20
> Why mention the comment statement here?
>=20
> Comment is special, its not a statement from the evaluation
> perspective. It tells the kernel to allocate some extra space to
> store the comment data, the interpreter doesn't know its there.

Well, we've just described in that text, that any later statements will
be ignored.
A user doesn't really know whether or not comment is special and since
it's actually not just a comment with respect to the nftables rules
files, but really stored in the kernel memory - as you say - ... it's
IMO not really obvious whether this happens e.g. in a rule like:
   drop comment "bar"

The mentioning of "comment" (which btw. I've changed now slightly) is
to explain just this - i.e. comment is *not* ignored, even if after the
terminal statement.

I could explain that with an example like:
> drop comment "foo"
>is the same as
> comment "foo" drop

but I thought that's overkill... if no, just tell me.



> > +=C2=A0 That is, for example in `=E2=80=A6 counter accept` the `counter=
`
> > statement is
> > +=C2=A0 processed, but in `=E2=80=A6 accept counter` it is not.
>=20
> I think this was already mentioned

It's already mentioned, but only in the VERDICTS chapter. So I think it
should be re-iterated in the summary chapter.

> , also, nft should already be
> informing the user that the rule has unreachable trailing statements.

This actually might be a valid reason to remove it, but:

- Is this really enforced in all cases (or are there some statements
  where nftables would ignore it but not error out)
- Could that behaviour (of nftables) ever change? Like by adding a
  --only-warn-on-ignored-statements option?
  In that case, we should IMO leave it in.
- What about beyond-the-nftables-utility?
  E.g. if someone uses libnftnl or nftables from python... would it
  still be guaranteed to error out? Cause if that's only a mechanism in
  the utility, we should IMO still describe the true behaviour (of
  ignoring such statements) because users likely use the nft manpage
  for their education.


Thanks,
Chris.

PS: v2 of the patch series will follow in a few minutes.
