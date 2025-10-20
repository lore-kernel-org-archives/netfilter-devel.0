Received: from toucan.tulip.relay.mailchannels.net (toucan.tulip.relay.mailchannels.net [23.83.218.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AC33EA8D
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2025 23:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.254
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761004130; cv=pass; b=SBqu53Tm54o7n2PWb29ECnZVQS3sjKeDTLkKbbjEMVwP6jbdMZTl/Fpu93ahs6YYWbgiR2gicBm9bXTuF1YJ1twPkK12zJgBkp5HZs1bKxRAJl9+hX9xev3GHmBi6GUbBDrRZAV4tlX6jL3alwqtrVK7wiamg3tszVScrgCN/Jk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761004130; c=relaxed/simple;
	bh=qMhLtBCqTcxL//upPscwGSnlovYR6BqtlgkSGYMjCeU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qCz27+e2rH+36P207QxVfSfklzsv0t8mFimYhI1Bhk1HgR68dWgl3uQjMG7YjxafJGayQ/a5Y6PrJsG+LoQkVHz9eQDde9k67iqzJBViQnJyCgzVUwd4QB+pF4BUdBkkCmNR5NCn0iOaUNgrRXmpnwOrDZ4Xq3npstLA4kfThsU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=christoph.anton.mitterer.name; dkim=fail (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b=Nr0InTcM reason="key not found in DNS"; arc=pass smtp.client-ip=23.83.218.254
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b="Nr0InTcM"
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 3F51E1E1E74;
	Mon, 20 Oct 2025 23:48:46 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-4.trex.outbound.svc.cluster.local [100.117.123.159])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 71A671E0EDD;
	Mon, 20 Oct 2025 23:48:45 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761004126; a=rsa-sha256;
	cv=none;
	b=Af4t8f/NYdZhCidASj3GZwMosaVZXcA2PomiH1vaqzZRspqVAmfn7fcoNlXQAjyCmr1k0J
	y7/4XhXF7O1RI5JFHAK0I9sMPkN5ohhcMHtSSJl6lRdCqlV4Zz0eY7mvGpLY7N1hd4AGoT
	gmRrk0wyBWm6nf0yCnzGJg2ok96Rpz6RTEiUIEFF9dlvNmA2JrxHwIQPGZ2ToaZAO5T2qy
	7QHE7B5XvDx6isjakjyzrlc3rHmevfOey57KijvANYZYZdwIPQP6qkBUxjExAxr4N5rGCQ
	I1vTyP1bBgxRgeVdaibonhA4UOELD8JFkd2ogUq6g3E7o8wcPlSBV+OQ/moZoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761004126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WPna3akvuOEF5RnjPX10jcnOyObeRPsn0dOWVXcWzPs=;
	b=Lf7jsH4/tgRVjnYvr5ZFb49HVaUpAu8DzBjn0jLuls1O2Zr3MjEwYHRe21E+6HAjxvTYtV
	NY1saa57WHXrYou3GeGZSTAY5a4OdALfuPmDJ4NlrKV3BABc8HwlI72yROM9FmkOhxPmMw
	OQHfJjgMARMNjl53y27XtaRMgqDSagU17+MO7q7ezWFHa+oEVPVYnVDy1c6g/TlDy3a3eh
	UnzW/Yy6f+cOHbDF2LDF1mlOYIeRfoABpJCQ9ipIkBKFtKqTaeVnQ8tubXlLwoD3I55T8S
	+tmd6c3rE0Q/Ie48Hock0Jacd6PWNT+7zhfKgNT6j7JXte+vNjkJ60B0AF/T3w==
ARC-Authentication-Results: i=1;
	rspamd-869c579f6-wzb6g;
	auth=pass smtp.auth=instrampxe0y3a
 smtp.mailfrom=mail@christoph.anton.mitterer.name
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MC-Relay: Neutral
X-MailChannels-SenderId:
 instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MailChannels-Auth-Id: instrampxe0y3a
X-Wipe-Illegal: 457e3d7442627537_1761004126143_3310009816
X-MC-Loop-Signature: 1761004126143:1861510694
X-MC-Ingress-Time: 1761004126143
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.117.123.159 (trex/7.1.3);
	Mon, 20 Oct 2025 23:48:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=christoph.anton.mitterer.name; s=default; h=MIME-Version:
	Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From
	:Subject:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=WPna3akvuOEF5RnjPX10jcnOyObeRPsn0dOWVXcWzPs=; b=Nr0InTcMTidl
	FqnhgVfTEv2MjMAqpS1BB1fdbRlNNapNuWxHvzyiJ7dhxPC6LlbdSdrHrlNivpQIAY+wJXIMjZZ0u
	xwpEMLNMNq8+RZEqhyR1AGTS8BJr3OBbUeS5BlIQ0GrQTc4Cch0uXyG2mdlBHE8GFH0r2rgVxPK8g
	JQcUHBxWnQsDMTygbzTe/jrwwPYpI+x0cmWAzVacdWM4EeZj+aCkUZwTgf80C/buAKCV1IYUBzLSt
	aw38PA7UvDwOeiCCjDKqJYhIZJaJnSFdjBpxbYhalVUm7Cm6NBFicrStMVco2ZOfsjHvoaNoPWfHS
	56wW756xHrGMSKBeuUnzWA==;
Received: from [79.127.207.162] (port=21093 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <mail@christoph.anton.mitterer.name>)
	id 1vAzcJ-00000009cG4-2q7F;
	Mon, 20 Oct 2025 23:48:43 +0000
Message-ID: <9b936453175cccac308be2e8d6bfa8c232cbd0df.camel@christoph.anton.mitterer.name>
Subject: Re: [PATCH v2 4/7] doc: add overall description of the ruleset
 evaluation
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Date: Tue, 21 Oct 2025 01:48:41 +0200
In-Reply-To: <aPYDVPyq5x_2264k@strlen.de>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
	 <20251011002928.262644-1-mail@christoph.anton.mitterer.name>
	 <20251011002928.262644-5-mail@christoph.anton.mitterer.name>
	 <aPYDVPyq5x_2264k@strlen.de>
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

On Mon, 2025-10-20 at 11:39 +0200, Florian Westphal wrote:
> ... I think this is too confusing and verbose.
> packet ultimately passed: no drop verdict was issued.=C2=A0 Its all there
> is
> to it, really.

Phew...

I mean we have four parts in there:

> * An *accept* verdict (including an implict one via the base chain=E2=80=
=99s policy)    =20
>   ends the evaluation of the current base chain (and any regular chains c=
alled  =20
>   from that).                                                            =
       =20

That should IMO be uncontroversial and it's the counterpart to the
first sentence in drop's description.

>   It accepts the packet only with respect to the current base chain. Any =
other  =20
>   base chain (or regular chain called by such) with a higher priority of =
the    =20
>   same hook as well as any other base chain (or regular chain called by s=
uch) of=20
>   any later hook may however still ultimately *drop* (which might also be=
 done  =20
>   via verdict-like statements that imply *drop*, like *reject*) the packe=
t with =20
>   an according verdict (with consequences as described below for *drop*).=
       =20

That one is the counterpart to drop's "Unlike with an *accept*
verdict =E2=80=A6".

I'm not sure how we could shorten that without loosing something
valuable in terms of teaching.

- We can't shorten "Any other base chain (or regular chain called by
  such)" to e.g. "any other chain" because that would IMO not make it
  clear that this is only for a new base chain.
  If we leave out the "regular ones", people might come to think a drop
  in those might not be effective.
- We could leave out the whole "with a higher priority of the same hook
  as well as any other base chain (or regular chain called by such) of
  any later hook" ... but I think one would loose the nice
  understanding at which chains exactly the "overruling" (sorry O:-) )
  could happen.


>   Thus and merely from netfilter=E2=80=99s point of view, a packet is onl=
y ultimately   =20
>   accepted if none of the chains (regardless of their tables) that are at=
tached =20
>   to any of the respectively relevant hooks issues a *drop* verdict (be i=
t      =20
>   explicitly or implicitly by policy or via a verdict-like statement that=
       =20
>   implies *drop*, for example *reject*), which already means that there h=
as to  =20
>   be at least one *accept* verdict (be it explicitly or implicitly by pol=
icy).

That's basically the counterpart to drop's "Thus, if any base chain
uses drop as its policy=E2=80=A6"  sentence, =E2=80=A6 basically trying to =
explain the
consequences of the above.

I think it's nice to have because it teaches this concept of: "What is
needed for a package to pass ultimately? No drops in any chain - which
automatically means there's at least one accept".

Could perhaps be shortened to:
> Thus and merely from netfilter=E2=80=99s point of view, a packet is
> ultimately only accepted if none of the chains of the relevant hooks
> issues a *drop* verdict (be it explicitly or implicitly by policy or
> via a verdict-like statement that implies *drop*, for example
> *reject*), which already means that there has to be at least one
> *accept* verdict (be it explicitly or implicitly by policy).

I think the "of the relevant hooks" is important as packets do not go
through all hooks, do they?!

The whole "which already means..." could perhaps be dropped, but people
might first come to think "Wait... I never said accept and it still
goes through? WTF?!"... until they realise that "no drop" already means
"at least one accept".=20

>   All this applies analogously to verdict-like statements that imply *acc=
ept*,  =20
>   for example the NAT statements.                                        =
       =20

Again, counterpart to the same in *drop*.



> > +* A *drop* verdict (including an implict one via the base chain=E2=80=
=99s
> > policy)
> > +=C2=A0 immediately ends the evaluation of the whole ruleset and
> > ultimately drops the
> > +=C2=A0 packet.
> > +=C2=A0 Unlike with an *accept* verdict, no further chains of any hook
> > and regardless
> > +=C2=A0 of their table get evaluated and it=E2=80=99s therefore not pos=
sible to
> > have an *drop*
> > +=C2=A0 verdict overruled.
>=20
> This is fine.

.oO( guess he must have overseen that mischievous in the end :P )


> > +* Given the semantics of *accept*/*drop* and only with respect to
> > the utlimate
> > +=C2=A0 decision of whether a packet is accepted or dropped, the
> > ordering of the
> > +=C2=A0 various base chains per hook via their priorities matters only
> > in so far, as
> > +=C2=A0 any of them modifies the packet or its meta data and that has a=
n
> > influence on
> > +=C2=A0 the verdicts issued by the chains =E2=80=93 other than that, th=
e
> > ordering shouldn=E2=80=99t
> > +=C2=A0 matter (except for performance and other side effects).
> > +=C2=A0 It also means that short-circuiting the ultimate decision is
> > only possible via
> > +=C2=A0 *drop* verdicts (respectively verdict-like statements that impl=
y
> > *drop*, for
> > +=C2=A0 example *reject*).
>=20
> Maybe rework the *accept* part to say that the packet moves on to the
> next hook?=C2=A0 (As opposed to *drop*, which is final).

You mean further above and not in the "Given the semantics of" point!?

I mean effectively this "accept =3D packt moves on to the next chain [not
hook]", is explained in the first two sentences ("An *accept* verdict=E2=80=
=A6"
and "It accepts the packet only=E2=80=A6").

Shorten it that drastically,... with pure beginners who never used
nf/iptables before probably having zero clue on how a packet moves
through netfilter (let alone that this works like a pipeline)... IMO
doesn't really add to understanding.

If one has no knowledge, accept means just that "allow for good" and
drop the other way round.
So we must at least tell that accept does not ultimately accept, but
only for the base chain. Thus we also need to tell it moves on to all
other chains, but only those that are relevant.
And we must bring in the concept that drop is more powerful than accept
and can actually immediately and ultimately decide the fate.

Even if we'd already introduce the pipeline concept at that stage...
not sure how much that would add to understanding/confusion.
I mean implicitly, we already kinda have it, I'd say...


> I think almost all of the overrule talk comes from this distinction
> (or lack thereof).

Well right now one one place is left where "overruling" is mentioned,
which you greenlit above ;-)
And that we could easily change to:
> it=E2=80=99s therefore not possible to have a *drop* changed to an *accep=
t*
> in a later chain.

which I actually did.



Will post v4 soon... not much changes for this patch though, so I guess
you won't be satisfied and we'll need another round. ;-)


Cheers,
Chris.
