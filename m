Received: from dwarf.ash.relay.mailchannels.net (dwarf.ash.relay.mailchannels.net [23.83.222.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD04A1799F
	for <netfilter-devel@vger.kernel.org>; Sun, 19 Oct 2025 00:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.222.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760833706; cv=pass; b=UuT/HHNmhf348qdSMi6Xs9HuU5X9JjVPhpSHehs3EkqeNteua7vKpJ4hjywHKPziBqWrdiUVUC2hIAoDFMNMxNJWv5F4RIdltI7hkzw2/HX9gmk8bD7zY8ONc+A7+sWqPKAl1YWaS6fM+ctWP0Szb4foQFjHG+ii8mr159uAqvo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760833706; c=relaxed/simple;
	bh=apLY7LLYt5oBIjfSxKGr+RZA/knshYnRyuqzHG1a3uY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=l3BfJcD8GXQOGeoJjsYY6Y7MIUVkNlV/ScomUheeNwBJRMmD1hKD5pvLyORGtr76RSVp085+PSFJTmUW2dZruW0tPIDS0foZeeuujUSauXbtKonTYvkVkM9swDAoqCT9ADZgV+bmlzfMoFMq9z19xnKs4IOizNSaG+yIj0LDxyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=christoph.anton.mitterer.name; dkim=fail (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b=hshAdrqe reason="key not found in DNS"; arc=pass smtp.client-ip=23.83.222.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b="hshAdrqe"
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 1C1B23625B6;
	Sun, 19 Oct 2025 00:11:17 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-9.trex.outbound.svc.cluster.local [100.119.71.185])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 37F0D362546;
	Sun, 19 Oct 2025 00:11:16 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1760832677; a=rsa-sha256;
	cv=none;
	b=Mqi32i2qmDRw9WR8fSyNbJ9dD54QMAa16KQKxLKHe3Gg/ENdYzQxBu8txLTG5ZNRsymg9P
	mHhRLKitbR6Z5yxwawkfPIq4Y6NZOIu0AYbXqx7TdHnz58Je7n2ZBBkr12XYeTbBcHoR6t
	8YfJH0U52NCRgbskOGk+PEgOLybwt3yx/+luhrXqxg4uEigEPDaD64VmdHU+YMc1kEkDjQ
	uMuR5pqjCNS9Cbqbhkm1VPiUyvdrxHRqcyGcSnl4yYqxFlfcwGF7KTKVL2VOuZA67tiqak
	JkQ9P6Aqcj2NcA496t2SL62QXbuZW+Excn4WuOy6uCga22ud6jq3lVmrusGO/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1760832677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uRG8bX2B+4UcJjZlL65jGRj4ANMLsnTf9sYVspdRG6s=;
	b=rom+2Km2MN0rW+941fg3MpqhOcJYEhdkIXH0b4lhMI3Z9ktQuqaH+30/jI4vDpjjOfMTGF
	o7kNAPzncw1B2vUeH1YCcYF0D1mQvlsa03Zn4GYpHskDaKla+PENQoirPVyck3XQ7kCRr3
	yNpCWQXlzu6FxoJtIf/eHupH/2y/6SuO95/SGksbHAfxWRiDmSQ4OEN4PT+2g7Hn3V+Nz7
	33oKim3I2pHBoFXq8+bn1+z3ylKEXiB9OU9y6o+w45GpPqY5mz1jlYZnUsKS2ajUmi+ug0
	42ASTldAA1XvklvQZz9OLq+9YqUnfeEHWCKYAlwVwfRdDjEBkk308SROMwKYoA==
ARC-Authentication-Results: i=1;
	rspamd-6c854d7645-q465b;
	auth=pass smtp.auth=instrampxe0y3a
 smtp.mailfrom=mail@christoph.anton.mitterer.name
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MC-Relay: Neutral
X-MailChannels-SenderId:
 instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MailChannels-Auth-Id: instrampxe0y3a
X-Cooing-Trail: 0c36518d6f2b7a01_1760832677044_3776333414
X-MC-Loop-Signature: 1760832677044:3139195638
X-MC-Ingress-Time: 1760832677044
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.119.71.185 (trex/7.1.3);
	Sun, 19 Oct 2025 00:11:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=christoph.anton.mitterer.name; s=default; h=MIME-Version:
	Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From
	:Subject:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=uRG8bX2B+4UcJjZlL65jGRj4ANMLsnTf9sYVspdRG6s=; b=hshAdrqexvci
	lrotyOToA6yuJ4mLOANepBWIygsa9zXsmJxvoDovt2gEmdETQcMcnIbqOPbRZYoLUaIAzCtA7GIG6
	iv3pRuByIvmeS0lJkfuZjCasUkL4eU+GD+grI1F3B9eCkrQfMzH9FjUw67lNvCmN1pduGSqulbILn
	Y6YH4mTeWTb32lIstPJfHQzZAnynXI8WAmumBnIwNLWL9m7W5Tq9HbewCCUk8wRPIJthHyUUPq4rb
	cRQaePzRMybnfsi3kos9LP+8bclrs72nkvGfiq52aNm4lLU2flKo5nIhSN4DTmgAAGygeQq44ruZ0
	FD7tw6yb+F31OyKq3OAivg==;
Received: from ipbcc0feaa.dynamic.kabel-deutschland.de ([188.192.254.170]:62368 helo=heisenberg.fritz.box)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <mail@christoph.anton.mitterer.name>)
	id 1vAH12-0000000D7lu-1Vox;
	Sun, 19 Oct 2025 00:11:14 +0000
Message-ID: <110fb0f07ed7570398dba13568387341f2ba8619.camel@christoph.anton.mitterer.name>
Subject: Re: [PATCH v2 2/7] doc: fix/improve documentation of verdicts
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Date: Sun, 19 Oct 2025 02:11:12 +0200
In-Reply-To: <aPOVNvw1t8lZT88o@strlen.de>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
	 <20251011002928.262644-1-mail@christoph.anton.mitterer.name>
	 <20251011002928.262644-3-mail@christoph.anton.mitterer.name>
	 <aO-IqRLJoEJ1RYTv@strlen.de>
	 <11427578d25220212d40533ed4a77652acefcc26.camel@christoph.anton.mitterer.name>
	 <aPOVNvw1t8lZT88o@strlen.de>
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

On Sat, 2025-10-18 at 15:25 +0200, Florian Westphal wrote:
> > What I'm neutral about: Strictly speaking, it does not mention
> > whether
> > evaluation of any "parent" chains is also terminated.
> > You try to solve that by saying "Evaluation continues in the next
> > base
> > chain"... and it is indeed kinda reasonable that all from the
> > current
> > base chain are then stopped... but a weird system could in
> > principle
> > continue with the next base chain, and eventually go back to the
> > previous.
>=20
> But this should describe netfilter and not something else :-)

Sure... but for a beginner (which this chapter is IMO primarily
intended for) - and who we must expect doesn't know about iptables
either - it may all but obvious whether netfilter/nftables would
eventually go back and revisit the other chains from the former base
chain's call stack.

It's a bit like my goto misunderstanding... totally obvious to a
netfilter developer, but maybe not so for a starter.


> > (Just like originally I completely misunderstood how return works
> > when
> > goto was involved).
> >=20
> > What I like less about it, is that is misses this additional
> > context of
> > "acceptance is only with respect to those chains".
>=20
> Hm, I think "Terminates the evaluation of the chain" is pretty clear.
> And "Evaluation continues in ..." is also clear, packet is allowed to
> move on in the processing pipeline.

Again, if one already knows how it works - it's clear, sure.

But if not, one could e.g. also think that evaluation continues only
for the side effects (e.g. counters).


>=20
> > What would you think about:
> > 1st:
> > =C2=A0=C2=A0 Either:
> > Terminate the evaluation of the current chain as well as any chains
> > from which that was called and accept the packet with respect to
> > the
> > base chain of these.
> > or:
> > Terminate the evaluation of the current chain as well as any chains
> > in
> > the call stack and accept the packet with respect to the base chain
> > of
> > these.
>=20
> It correct but it sounds overly complicated IMO.
>=20
> > 2nd and also replacing:
> > > The packet may however still be dropped by either another chain
> > > with a higher
> > > priority of the same hook or any chain of a later hook.
>=20
> I would be fine with that, even though I also consider it too
> verbose.
>=20
> > Evaluation continues in the next base chain (of higher or possibly
> > equal priority from the same hook or of any priority from a later
> > hook), if any.
>=20
>=20
> Hmm, I am not sure.=C2=A0 Is it really needed to mention all of this?
> Packet will just move on in the pipeline, it would be weird to assume
> that forward-accepted packet would e.g. bypass postrouting.

Well... I don't know whether the majority of beginners would
immediately grasp this or not.

I, personally, like it always more of teaching is rather done extra
elaborative... but that's of course just one approach.


> > This means the packet can still be dropped in that next base chain
> > as
> > well as any regular chain (directly or indirectly) called from it.
>=20
> ... or that it moes to the next base chain but that base chain
> ignores
> jumps to user-defined chains.
>=20
> Your suggestions aren't wrong of course but it seems very repetitive
> to
> me.

What about the following:

I'll make a v3 now, *with* the changes as proposed before, and you
simply redact things where you'd rather have them differently?
Otherwise we just continue to haggle on the wording ;-)

I'll be fine with whatever you choose. :-)


> > What about the following compromise: O;-)
> >=20
> > *drop*: Immediately drop the packet and terminate ruleset
> > evaluation.
> > This means no further evaluation of any chains and it's thus -
> > unlike
> > with=C2=A0 *accept* - not possible to again change the ultimate fate of
> > the
> > packet in any later chain.
>=20
> Thats fine.

Applied.


> > What I'd at least think would be nice to have is to re-iterate on
> > that
> > conceptual difference between accept (may be overruled) and drop
> > (is
> > ultimate).
>=20
> Yes, I understand that some people see it that way.
>=20
> I see netfilter as a pipeline, where packet moves along a certain
> path,
> e.g. prerouting, forward, postrouting or prerouting -> input.

Well, compared to a pure beginner,... how much more parts of netfilter
have been implemented by *you*? ;-)

> accept is just a "move along", whereas drop stops the packet dead in
> its
> tracks.

Don't forget... this *is* clear once you know how it works, but if you
start from scratch... the pure meaning of the word "accept" would IMO
rather imply: "let the packet through (ultimately)".

Just as "drop" implies "into the torch with it (ultimately)" (which is
actually the case here).


> nftables is just a "user visible" part that allows to customize
> the move-along-or-not decisions.
>=20
> Hence, this "overrule old decision" idea doesn't apply.
>=20
> But I can see that others may have a different concept of how
> this all works under the hood.
>=20
> But I have no idea how to best describe this let alone make it
> clear that you can't back out of a "drop" decision.

I'd have two proposals now:
a) We leave:
> For example, a *reject* also immediately terminates the evaluation of
> the current rule, overrules any *accept* from any other chains and
> can itself not be overruled, while the various NAT statements may be
> overruled by other *drop* verdicts respectively statements that imply
> this.

And add a sentence like:
> (Note that =E2=80=9Coverruling=E2=80=9D is only an abstract description a=
nd not how
> netfilter actually processes that internally.)

after it.
Though I personally would say that this is rather not of interest for
the evaluation summary chapter - only if it would make really a big
difference in terms of understanding how the evaluation effectively
works.

(Meanwhile I've already added a " as well as of all chains" after " the
current rule". I've also changed "*drop* verdicts" to singular as only
one could do the "overruling")

b) We change it to something like:
> For example, a *reject* also immediately terminates the evaluation of
> the current rule as well as of all chains, prevents any previous
> *accept* from other chains to decide the ultimate fate of the packet
> and cannot be turned into an *accept*, while the various NAT
> statements only decide the ultimate fate of the packet if no other
> *drop* verdict respectively statements that imply this are issued.

But TBH, I think (b) is ugly and rather difficult to understand... and
merely tries to avoid overruling/overriding/etc. at all costs.


Again, I can make another round after you decide... but feel free to
simply edit v3 as you wish. :-)


> > > > +All the above applies analogously to statements that imply a
> > > > verdict:
> > > > +*redirect*, *dnat*, *snat* and *masquerade* internally issue
> > > > eventually an
> > > > +*accept* verdict.
> > >=20
> > > You can remove 'eventually'.
> >=20
> > > > +*reject* and *synproxy* internally issue eventually a *drop*
> > > > verdict.
> > >=20
> > > Same.
> >=20
> > The idea of that was a slight indication that these statements do:
> > <other things> + accept|drop.
> >=20
> > Admittedly eventually isn't really perfect =E2=80=A6
>=20
> OK, never mind. I have no strong opinion here.

I'd have changed it now to:

> =E2=80=A6 internally issue an =E2=80=A6 verdict at the end of their respe=
ctive
> actions.

Feel free to change it, and also to replace "actions" with a better
word if you have one.


> >=20
> > > I would suggest:
> > > For example, *reject* is like *drop*, but will attempt to send a
> > > error
> > > reply packet back to the sender before doing so.
> >=20
> > I mean I'm open to change, but what I think should in one form or
> > another go in, is explicitly reinforcing that reject has the same
> > "power" like drop, i.e. it can render any further accepts (of other
> > base chains) moot.
>=20
> Hmm, I feel there is a need to document the netfilter pipeline
> better.
>=20
> Perhaps we should add a netfilter man page document and
> ship that too to explain this "move on" thing that accept does behind
> the scenes?

I think that would definitely make sense (then we could also simply let
the above "Note" sentence refer to that).

I mean such a document should then probably also describe the hooks,
what they're intended for and in general some concepts how the whole
networking thingy actually works (i.e. what happens from the arrival of
the packet until it reaches some application and the other way round).

Perhaps also elaborating a bit on concepts like NAT, forwarding, etc.
... which easily makes such a manpage quite some effort and go beyond
netfilter into general networking.


Though I think what would be even nicer would be some generic
"teaching" on writing nftables rules... I've mentioned some examples
before.

E.g. I've been trying to implement the strong host model via:
  fib daddr . iif type !=3D {local, broadcast, multicast} drop

which nft(8) places in prerouting but some examples on the net in input
I guess I might understand the difference ^^ ... but I tried to
actually verify whether it does what it should (via some qemu VM with
multiple ifaces and nping), but failed.


And in particular also with respect to writing "performant" rules,
e.g.:
- I've seen many examples, where the rules for actually accepting new
  connections (like SSH, http, whatever) do things like these:
 =20
  in iptables, they often used --syn, which iptables-translate would
  translate, but - assuming the conntrack state is always readily
  available - I guess it's better (and equally fast if not faster) to
  use ct state new.

  But even then, many people do things like:
        ct state established,related accept
        ct state invalid drop
        meta iif lo accept

  In that light, does it even make sense to match on ct state new
  later?

  Perhaps also telling whther it makes sense to have the
        ct state established,related accept
  rule first, (assuming most packets will already be handled by it).
  I've seen quite some examples which accept the loopback first, but -
  under my above assumption - would also guess that having the
  established rule first should be at least equally fast.

- Teaching people a bit about how ordering of statements should be done
  within one rule.
  Consider something like:
     ct state new iifname eth0 tcp dport ssh accept
  would e.g.:
     ct state new tcp dport ssh iifname eth0 accept
  be faster?

  Perhaps also telling a bit about: which information is already
  available and which requires further parsing when the statement is
  encoutnered, e.g. if tcp dport is encountered, does that first need
  to be extracted form the packet, or is that already done?

  Similarly, is it better to first match on ip [ds]addr and then on
  (tcp|udp) [ds]port or vice versa... or no difference or is it
  dependent on what one matches on?

- Perhaps also on: when should one start to split things up in chains?
  Consider e.g.:
     ct state new tcp dport ssh accept
     ct state new tcp dport http accept
     ct state new tcp dport https accept
     ct state new udp dport domain accept

  For each packet, ct state new would be checked again, so when does it
  make sense (i.e. when is the jump/goto/return cheaper) to do:
     ct state new jump new-packets
  and evaluate tcp/udp dports there?

  Similarly, a UDP packet would be evaluated against all rules (even
  with a new-packets chain)... so roughly when does it make sense to
  make yet another sub chain for tcp and one for udp?

- I've also seen a great many of "base rule sets" for workstations...
  like what which ICMPv[46] to let through, etc. ... all slightly
  different.
  Of course this may again be beyond the scope of nftables/netfilter
  and rather go into general teaching of networking.


I mean all this probably doesn't matter on some workstation, but at the
university I work we run a storage element for LHC with many PiB data
and more or less constant high volume network,... there these things
might matter?


> > Like above... the idea here was again to reinforce that the
> > statements
> > which internally issue an accept, have the same "weakness" as
> > accept
> > itself, i.e. they're not ultimate and any later drop/reject/similar
> > may
> > "overrule" them.
>=20
> I wonder where the idea that "accept" is a kind of magic teleporter
> that
> just fast-forwards a packet to the socket or NIC came from...

Well, it's kind of the anti-particle to drop, which does just that
fast-forwarding (except into the void).

> This isn't the case even in old ipchains.

I guess that quite some users never ever touched chains other than
INPUT and OUTPUT,... so from their PoV, -j ACCEPT might have been kinda
like that.


> > Any other ideas how include these two points? At least I personally
> > rather think that the actual side effect of "but will attempt to
> > send a
> > error reply packet back to the sender" is rather not that
> > interesting
> > with respect to the overall semantics of evaluation.
>=20
> Correct, it should be in the REJECT STATEMENT section only.

It already is:
> A reject statement is used to send back an error packet in response
> to the matched packet otherwise it is equivalent to drop so it is a
> terminating statement, ending rule traversal.

which may be considered a bit fuzzy again, cause it mentions that rule
traversal is ended (which could be considered to mean only with respect
to the current base chain)... and doesn't mention that it also
"ignores" any further statements in the current rule.

I've added another commit on top, which takes care of this.


> I suggest to send a smaller v3 first, with the less "controversial"
> stuff.=C2=A0 Patch 3 seems ready to go for instance.

Would you mind just dropping/editing the controversial stuff as you
seems it fits? :-)

Especially since I've kinda lost track which parts of it are now
exactly still controversial and which not (I guess mostly the *accept*
documentation now?) ^^


Thanks,
Chris.
