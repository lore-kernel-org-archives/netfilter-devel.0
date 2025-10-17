Received: from bumble.maple.relay.mailchannels.net (bumble.maple.relay.mailchannels.net [23.83.214.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8053F186294
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Oct 2025 02:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.214.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760668230; cv=pass; b=X+RBNiPHSOfVHXDxgUnOGW3oxXo6CZkhxU1tOxrJ1jKjEFOXb+pVswg67+LSvgNAZgTlfRh0yNMHoH+58j+HVqaPn5Pt7pfa/2UIH2cqdODed8riKglf4bvgZD50t246R6aMmakctfN0wa7BKGEDY88y2ABhDEgU/jjDTJw8L6M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760668230; c=relaxed/simple;
	bh=q/mU65hnAZjA42aUm0ZFrfmHc8sQIiKk/XEn1R4+TgE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TBrpXPpve0muEVxdG7jS7eKViB4KLj8LU8GSTjE3+syeSJ5TOq57dCI3lzoIQmx4JjSC45DmHC6fkhPMtjQaFNogJbSeOPon1Yw2nna/oNlnUPMSerLSfTfJHWbxZ4O8LHkXU6gsXY2F9wXxWTenLtm0BAN3YQ5UwqwOARBjJOg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=christoph.anton.mitterer.name; dkim=fail (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b=ZeB0xpov reason="key not found in DNS"; arc=pass smtp.client-ip=23.83.214.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b="ZeB0xpov"
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id C6682501C9D;
	Fri, 17 Oct 2025 02:30:21 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-117-100-119.trex-nlb.outbound.svc.cluster.local [100.117.100.119])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id C7292501719;
	Fri, 17 Oct 2025 02:30:16 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1760668217; a=rsa-sha256;
	cv=none;
	b=0+Lrwm/bPyZlFjOkIDgfNAcWmMifniWQdtNw2g9w9fPoPU2zQjNi9z5vBHDixAmCV+o3M5
	7dfpGP57cbXz05rbf5Yk0kyTg7B9TdkVGVwX9bkj7y4/gFrGQ8BSQr07jqD8ONDBmC/27/
	pEs6BhxKSpqqZ4IVUbkDUctfFZKkSEXYIMbi0ENZl4EZAKA0SVoFIZb9Bqc3n04LgEfcVq
	9u6CSp99MnLDp83c6ztL8N981ol//1lIJX90KCCj2sEX2va+srcHuD3A6APubXrIc0eZkI
	+mzSfATTqMs7mnnTKbZVsMxfL71UC/+DURvFR4tZojFhTAKTKCiJyhO6AxSFbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1760668217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0YTDCeZoSv06AIvan8d7xR3S3GXOsIFXDPQWiTTSCIU=;
	b=R7mX0tgZZt06whJLg2YbanG/hwGXaPkMbYOK+l3LfYHYrSFH6QA2aYIDbuL4K6MOREZPp6
	uXE+UqpZeYorB4sFPNcPD8mqAQ/NkSlHITfuKwwN3dFdX7Q91i1YCfBlU4Im6lalhDerpk
	8H5X31VED9bzBE1L1GAIjWlfpMltLl3Vr3W5/TEu+aSLHurQeLCa5hWUHNdnbC2McmoLiR
	Et4twOKx+jOq1bXo2RDV6g6Q/XH0GsR31XhWJDOCZFymVL8LH6uy/toXtiFcEl5Fh0gW/Y
	MWHgiTyaE7jPWR3pEc2SDX1fdcOr17U4KiIbMYHafhn3yr9HuRdeUAKT+0UfEA==
ARC-Authentication-Results: i=1;
	rspamd-57f765db6d-wkb4p;
	auth=pass smtp.auth=instrampxe0y3a
 smtp.mailfrom=mail@christoph.anton.mitterer.name
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MC-Relay: Neutral
X-MailChannels-SenderId:
 instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MailChannels-Auth-Id: instrampxe0y3a
X-Celery-Bubble: 1ac1ac392907988f_1760668221677_530753100
X-MC-Loop-Signature: 1760668221677:1945870771
X-MC-Ingress-Time: 1760668221677
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.117.100.119 (trex/7.1.3);
	Fri, 17 Oct 2025 02:30:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=christoph.anton.mitterer.name; s=default; h=MIME-Version:
	Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From
	:Subject:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=0YTDCeZoSv06AIvan8d7xR3S3GXOsIFXDPQWiTTSCIU=; b=ZeB0xpov8Stc
	NljA9QAl4dUmRBFKwG0QghrvwmdbLqiIpMAcM5hNeNLyevTbJX0ofmf/NnLeQCq5URFuM/QNZXgq1
	S7JHp4gTwKCXfGiKiAtxqlsJSC9qtTDaqIpg0L94pJLzqWSyzut2DZhZKmo23tbbbR6gDJNr/BE9j
	2PvWUXHZeCImKCje5dQTz959sCgu5KuFX3ujMEEMoXZNJmin+Iu6tu4A3VTIPIt1zbqHZwk6uyzF0
	s4/Oisv/5wkQ3rGmxFoTggL/pg1BUeGFTsFi6+BlZACAn9kYCyuSL8qBKIS1KdqgoSXfdUW/DyLSw
	XZEgRShiVvvnElDYRTQ8bQ==;
Received: from [212.104.214.84] (port=21453 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <mail@christoph.anton.mitterer.name>)
	id 1v9aES-00000000DpL-2TBm;
	Fri, 17 Oct 2025 02:30:15 +0000
Message-ID: <11427578d25220212d40533ed4a77652acefcc26.camel@christoph.anton.mitterer.name>
Subject: Re: [PATCH v2 2/7] doc: fix/improve documentation of verdicts
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Date: Fri, 17 Oct 2025 04:30:13 +0200
In-Reply-To: <aO-IqRLJoEJ1RYTv@strlen.de>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
	 <20251011002928.262644-1-mail@christoph.anton.mitterer.name>
	 <20251011002928.262644-3-mail@christoph.anton.mitterer.name>
	 <aO-IqRLJoEJ1RYTv@strlen.de>
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


Thanks for already merging the first patch of the series :-)


On Wed, 2025-10-15 at 13:42 +0200, Florian Westphal wrote:
> Christoph Anton Mitterer <mail@christoph.anton.mitterer.name> wrote:
> > +*accept*:: Terminate the evaluation of the current base chain (and
> > any regular
> > +chains called from it) and accept the packet from their point of
> > view.
>=20
> Suggest:
> *accept*:: Terminate the evaluation of the chain.=C2=A0 Evaluation
> continues in the next base chain, if any.

What I like about it, is that it avoids the slightly awkward "current
base chain (and any regular chains called from it)" construct...

What I'm neutral about: Strictly speaking, it does not mention whether
evaluation of any "parent" chains is also terminated.
You try to solve that by saying "Evaluation continues in the next base
chain"... and it is indeed kinda reasonable that all from the current
base chain are then stopped... but a weird system could in principle
continue with the next base chain, and eventually go back to the
previous.
(Just like originally I completely misunderstood how return works when
goto was involved).

What I like less about it, is that is misses this additional context of
"acceptance is only with respect to those chains".

Yes it can be deduced from the following sentence ("The packet may
however still be dropped by either")... and meanwhile, where I
(hopefully ;-) ) understand how it works, that seems enough, but for a
pure beginner it's IMO better to give such context and rather reinforce
things twice in different words.


What would you think about:
1st:
   Either:
Terminate the evaluation of the current chain as well as any chains
from which that was called and accept the packet with respect to the
base chain of these.
or:
Terminate the evaluation of the current chain as well as any chains in
the call stack and accept the packet with respect to the base chain of
these.

2nd and also replacing:
> The packet may however still be dropped by either another chain with a hi=
gher
> priority of the same hook or any chain of a later hook.

Evaluation continues in the next base chain (of higher or possibly
equal priority from the same hook or of any priority from a later
hook), if any.
This means the packet can still be dropped in that next base chain as
well as any regular chain (directly or indirectly) called from it.


> > +The packet may however still be dropped by either another chain
> > with a higher
> > +priority of the same hook or any chain of a later hook.
>=20
> ... This means the packet can still be dropped ...

Shamelessly stole and integrated that in my proposal above.


>=20
> > +*drop*:: Terminate ruleset evaluation and drop the packet. This
> > occurs
> > +instantly, no further chains of any hooks are evaluated and it is
> > thus not
> > +possible to again accept the packet in a higher priority or later
> > chain, as
> > +those are not evaluated anymore for the packet.
>=20
> Can this be compacted a bit?=C2=A0 I feel this is a tad too verbose.
>=20
> *drop*: Packet is dropped immediately.=C2=A0 No futher evaluation of any
> kind.
>=20
> I think thats enough, no?

Uhm... I made it a perhaps bit extra verbose, mostly because we have
terms like "terminal statement/verdict", where not all of them are
really ultimately terminal.

What about the following compromise: O;-)

*drop*: Immediately drop the packet and terminate ruleset evaluation.
This means no further evaluation of any chains and it's thus - unlike
with  *accept* - not possible to again change the ultimate fate of the
packet in any later chain.

What I'd at least think would be nice to have is to re-iterate on that
conceptual difference between accept (may be overruled) and drop (is
ultimate).



> > +All the above applies analogously to statements that imply a
> > verdict:
> > +*redirect*, *dnat*, *snat* and *masquerade* internally issue
> > eventually an
> > +*accept* verdict.
>=20
> You can remove 'eventually'.

+

> > +*reject* and *synproxy* internally issue eventually a *drop*
> > verdict.
>=20
> Same.

The idea of that was a slight indication that these statements do:
<other things> + accept|drop.

Admittedly eventually isn't really perfect =E2=80=A6

> > +These statements thus behave like their implied verdicts, but with
> > side effects.

=E2=80=A6 but since there's already this sentence, I think you're right an =
we
can just leave out the "eventually" without loosing too much.


> > +For example, a *reject* also immediately terminates the evaluation
> > of the
> > +current rule, overrules any *accept* from any other chains
>=20
> No, not really.=C2=A0 There is no *overrule*.=C2=A0 We don't keep any 've=
rdict
> state'.=C2=A0 There is no difference between 'drop' in the first rule of
> the
> first ever base chain or a drop somewhere later in the pipeline,
> aside
> from side effects from other matching expressions.

Well first, whether you keep an internal verdict state or not... isn't
that again some implementation detail which here not really matters for
the user's understanding of how evaluation works?


> I would suggest:
> For example, *reject* is like *drop*, but will attempt to send a
> error
> reply packet back to the sender before doing so.

I mean I'm open to change, but what I think should in one form or
another go in, is explicitly reinforcing that reject has the same
"power" like drop, i.e. it can render any further accepts (of other
base chains) moot.
That's what I mean with respect to "overruling" (i.e. and previous
accept).

You're proposal rather describes the side effects of *reject* which are
however IMO not really relevant with respect to overall ruleset
evaluation.


> > +overruled, while the various NAT statements may be overruled by
> > other *drop*
> > +verdicts respectively statements that imply this.
>=20
> There is no overrule.=C2=A0 I would not mention NAT at all here.
> *accept* documentation already says that later chains in the pipeline
> can drop the packet (and so could the traffic scheduler, qdisc, NIC,
> network ...)

Like above... the idea here was again to reinforce that the statements
which internally issue an accept, have the same "weakness" as accept
itself, i.e. they're not ultimate and any later drop/reject/similar may
"overrule" them.



Any other ideas how include these two points? At least I personally
rather think that the actual side effect of "but will attempt to send a
error reply packet back to the sender" is rather not that interesting
with respect to the overall semantics of evaluation.


I think it makes no sense to spam the list with a v3 until I've got
your opinions on all the above points.... so I'm waiting for that and
the make a v3. :-)


Thanks and best wishes,
Chris.
