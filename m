Received: from buffalo.tulip.relay.mailchannels.net (buffalo.tulip.relay.mailchannels.net [23.83.218.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B307A2CCC0
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Oct 2025 14:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759416668; cv=pass; b=HLY1OYQLC8Ap4fYGHUACf/yz7gLS/6W+encxI1qSalGJNtUHB4Lf4sc3wErRTlm/hldogaZ1e7l9VahVv+05Q+StR662ltdogeaSyqG3OcKHeCxn8KQWaUqnXRKf/dNWC5FtASCA5UcT6oYBBlRJOy68Xgl2e6jhkST/gzG0DVw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759416668; c=relaxed/simple;
	bh=jJzOlU2O+1kkE5nJbql6sBLHzEDVPKDrGzwIPLFurA8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ioZhN6fyaIrc7Rm1nqUV91LduhK+2AYtHvMyJmDqWd7etbRxZoeFcYMIp3yJE19unbFeaqae5CnAn3FNKcZmAr22ExRVwHkWBt2XDL/QYYYk5Kc0JvyZ3qhEfoyWGvuNZA4u7w+sZoy3VcpwnR9dyZyR/E6atIxrrb/siNp9hlY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=christoph.anton.mitterer.name; dkim=fail (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b=oGnX2cjY reason="key not found in DNS"; arc=pass smtp.client-ip=23.83.218.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b="oGnX2cjY"
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 77F494227B8;
	Thu, 02 Oct 2025 14:50:59 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-blue-7.trex.outbound.svc.cluster.local [100.113.91.2])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 6F004422137;
	Thu, 02 Oct 2025 14:50:58 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1759416659; a=rsa-sha256;
	cv=none;
	b=uhiNpjkceUIQNNvT2wXpK7SGixvQnJ0u/R5Z/eNHZPIEEgjB5kzWlMXzAGiFklfth8rq8H
	kklVJBWUAt6basCRhitQVxNexdcuMST4cUEt2cUmvECh7jwRwHBy78oSwMOSqx17E+fMW4
	ABzmJLH/Xmqn+IH91HL+fWjACNEw3Ki5NJKW9jjqb5okEGpE14jHCJcm06fMUuGQ+3wbGj
	veuNgku6S7EROC2WudLGuHFwcZ3+TEAfvAYOlcyQ5fgq8mxmaiPClXD1HSAV0VkzvcnyIA
	Jm0pDPnfleaMOK4yRtrrgKhN5l5JILb7eik31P8dKFVDpDIRNSegUhWR45yH6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1759416659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gSuKqxcS/f4puaKVWYgpV+bl9zP5Pjxayb5ONdR1tuw=;
	b=fzlUJW8jiec9IZHRKOOpIUYaTBqEYs9Zv/+N/8qrW7Keyku4wgIlWBh51T8N8ZLkB1Ui/m
	EH3xTFZ+lV7epqFPb6XkSbXlQHLyruJkiE62RfLy0BE/2sUJzJA5CCGW3azdHfoBgjCQrV
	KfdBAlvLr/I/XpkCc1cC7LCvQVyZQKF3u+83laXGXDEbXjmZKaE1xgySk6sglhSqmundre
	Yvw8WH5opKaes8YiuDwmAvHwpyMEPk1q1IQD32gs2SFhG58OZjdC2ck3aAxHP9M1mPXbbf
	w7bqo2rYuTqVoxDqcxQ50riRQwQR5al502WU8gIu0TcyMaH+7I6FUFSAgwQVBA==
ARC-Authentication-Results: i=1;
	rspamd-845775c57d-kwhqw;
	auth=pass smtp.auth=instrampxe0y3a
 smtp.mailfrom=mail@christoph.anton.mitterer.name
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MC-Relay: Neutral
X-MailChannels-SenderId:
 instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MailChannels-Auth-Id: instrampxe0y3a
X-Dime-Callous: 10bd0c012da323fe_1759416659299_3712678595
X-MC-Loop-Signature: 1759416659299:246620781
X-MC-Ingress-Time: 1759416659299
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.113.91.2 (trex/7.1.3);
	Thu, 02 Oct 2025 14:50:59 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=christoph.anton.mitterer.name; s=default; h=MIME-Version:
	Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From
	:Subject:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=gSuKqxcS/f4puaKVWYgpV+bl9zP5Pjxayb5ONdR1tuw=; b=oGnX2cjY4rxn
	wy8nMmWtiBShNHLGM7g8P5yr95qYvjasbJM2Sp8w7yKYbTv1NpoahyDznwUBHR9eNhuKWWa4ElMEF
	0AOJlVILB7l4gtIMZEIureFmgmFXRw9iCgTU5riQiEEWfxwPP8FybcPvge4Zo9LcYriMLPLg2IC4o
	bF4I0LYRn2LeKgFd9lt7TGvTGRGtIy0lKqd+1TCC/tFjoqJx4U93CkKOdsdCVMDSpGcbiRnNu0LQF
	NkyQ/eMWyH5fbZo7o4o7EadNd5cEZPfc149zTgvn8zTQmi5bWRcDkjI46dqDiGfxc6Gdth0dZey3N
	KWCpYm8XR1exvR5oUxe9Bg==;
Received: from [212.104.214.84] (port=55513 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <mail@christoph.anton.mitterer.name>)
	id 1v4Ke3-00000005LWX-2iKf;
	Thu, 02 Oct 2025 14:50:56 +0000
Message-ID: <38e6a25fd2d311e2f33b1881542a9ce7b8a8473d.camel@christoph.anton.mitterer.name>
Subject: Re: [PATCH 2/7] doc: fix/improve documentation of verdicts
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 02 Oct 2025 16:50:54 +0200
In-Reply-To: <aNu1-kwUzXGXyNLJ@strlen.de>
References: <aNTwsMd8wSe4aKmz@calendula>
		 <20250926021136.757769-1-mail@christoph.anton.mitterer.name>
		 <20250926021136.757769-3-mail@christoph.anton.mitterer.name>
		 <aNu1-kwUzXGXyNLJ@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-3 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-AuthUser: mail@christoph.anton.mitterer.name

Hey.

Thanks for having a look. :-)

On Tue, 2025-09-30 at 12:50 +0200, Florian Westphal wrote:
> This isn't correct, strictly speaking, as 'reject' is not a verdict.
> The only verdicts accessible from userspace are accept and drop.
> (and queue, but thats a historic wart that should not be mentioned).

I see.

Not that I'd reject reworking this, but wearing my user hat, I'd say
that the user rather doesn't care so much whether in strict terminology
this is a verdict or not - cause from the user's PoV this is simply
like a verdict (i.e. causing - along with sending a reply - to either
accept/reject the packet).

What would you think about changing it roughly as follows (at this
place, as well as perhaps in my new summary chapter about how
evaluation works):
- remove the rejects from next to the drops
- add a paragraph which describes that there are verdict-like
  statements, which a) do some extra stuff and b) cause one of the true
  verdicts (drop/accept)
- along with that add a list which explains which such statement causes
  which verdict

What's IMO important from the user PoV is that for example at a
sentence like:
>*accept* and *drop*/*reject* are absolute verdicts, which immediately
> terminate the evaluation of the current rule, i.e. even any later
> statements of the current rule won=E2=80=99t get executed

he also gets told that the very same concept (here: later statements
not being executed) applies also to verdict-like statements like reject
(if that's the case).

The user doesn't want to have to read through the whole manpage to
eventually realise that reject behaves effectively like drop here.
And even if you refer to the REJECT section and mention it there, it
makes things IMO more difficult to understand.

That's basically the reason why I propose this evaluation summary
chapter, because with the information spread out over many places it's
more difficult to grasp the big picture.


But back to verdict/verdict-like statements:
Are jump/goto/return/etc. then true verdicts? I wouldn't guess so, yet
they already are explained in the verdict section.

I'm not sure how much we win, by differentiating between these two, and
even if we do so, how shall we call things like reject? "verdict like
statements"? "statements that imply a verdict"?


> 'reject' is also not the only statement that ends rule/basechain
> evaluation,
> other examples are redirect/dnat/snat/masquerade which will
> internally
> issue an accept verdict.=C2=A0 Or synproxy, which will drop internally to
> consume the incoming packet.

Is there a complete list of all these which are verdict-like and what
verdict they actually imply?


> > +.*counter* will get executed:
> > +------------------------------
> > +=E2=80=A6 counter accept
> > +------------------------------
> > +
> > +.*counter* won=E2=80=99t get executed:
> > +------------------------------
> > +=E2=80=A6 accept counter
> > +------------------------------
>=20
> Thanks, this is a big improvement.

:-)


> > +*drop*/*reject*:: Terminate ruleset evaluation and drop/reject the
> > packet. This
> > +occurs instantly, no further chains of any hooks are evaluated and
> > it is thus
> > +not possible to again accept the packet in a later chain, as those
> > are not
> > +evaluated anymore for the packet.
>=20
> As above, reject isn't a verdict, it will 'drop' internally. Its also
> not a 'drop' alias (it sends a reply packet).
>=20
> Maybe the 'REJECT STATEMENT' section can be extended a little, but I
> think its ok as-is.

Same solution as I'd propose above?!



> > +*return*:: In a regular chain that was called via *jump*, end
> > evaluation of that
> > + chain and return to the calling chain, continuing evaluation
> > there at the rule
> > + after the calling rule.
>=20
>=20
> Maybe we should mention that 'return' is the implicit thing at the
> end
> of a user-created non-base chain?
>=20
> Or do you think thats self-evident?

I do mention it in my summary chapter.

In the section on the verdicts you're referring to it follows
implicitly from the description of the *jump* statement, but at least
there I'd also think it's perhaps good to explicitly mention it in
parentheses.

Whether we also mentioned it in the return description, I don't mind.
We can, so to say as extra information, but it's IMO not strictly
necessary. Because if someone looks up the book for the return
statement he most likely wants to know what happens we issuing it - not
which other things (he wasn't looking up) also behave in some cases
like the statement he was looking up.

But again... I'd be fine either way.


> > + In a regular chain that was called via *goto* or in a base chain,
> > the *return*
> > + verdict is equivalent to the base chain=E2=80=99s policy.
>=20
> No, its not.
> I think this warrants an example.
>=20
> chain two { ... }
> chain one {
>  ...
>  goto two
>  ip saddr ..=C2=A0=C2=A0 # never matched
> }
>=20
> chain in {
>  hook input type filter ...
>  jump one
>  ip saddr .. # evaluated for all packets not dropped/accepted yet
> }
>=20
> -> base chain calls 'one' and remembers this location
> -> 'one' calls 'two', but doesn't place it on chain stack.
> -> at the end of 'two' / on 'return', we resume after 'jump one', not
> =C2=A0=C2=A0 after 'goto'.
>=20
> The sentence wrt. base chain policy is valid in case 'chain in' would
> contain 'goto one', as it doesn't remember the origin location,
> end-of-one / return is equal to explicit 'return' from the base
> chain.

Uff... okay... that makes things quite a bit harder to describe.

So effectively that means, return (explicit or implicit) it not really
equivalent to the policy, as claimed for at least base-chains in the
current manpage:
> return
> Return from the current chain and continue evaluation at the next
> rule in the last chain. If issued in a base chain, it isequivalent to
> the base chain policy.

But rather *if* there's nowhere to return to (like when it's called
from a base-chain) *then* the policy is applied, right!?

I merely had checked calling return from a regular chain into which
I've jumped to from the base-chain, ... that together with the above
sentence from the manpage, made me think it would work that way.



> > +*jump* 'CHAIN':: Continue evaluation at the first rule of 'CHAIN'.
> > The position
> > + in the current chain is remembered and evaluation will continue
> > there with the
> > + next rule when 'CHAIN' is entirely evaluated or a *return*
> > verdict is issued in
> > + 'CHAIN' itself.
> > + In case an absolute verdict is issued by a rule in 'CHAIN',
> > evaluation
> > + terminates as described above.
> > +*goto* 'CHAIN':: Similar to *jump*, but the position in the
> > current chain is not
> > + remembered and evaluation will neihter return at the current
> > chain when 'CHAIN'
> > + is entirely evaluated nor when a *return* verdict is issued in
> > 'CHAIN' itself.
>=20
> Maybe it should say that it will instead resume after the last jump
> (if
> there was any?, or not at all (base chain policy executes?)

As far as I understand it now:
  base --jump--> regularA --goto--> regularB
then at the end of regularB or if return is called in it, while I don't
return to regularA, I actually will return to the jump position in
base, right?

Similar in:
  base --jump--> regularA --jump--> regularB --goto--> regularC
I will not return to regularB, but will return to the jump position of
regularA and then to that of base, right?


Very open for opinions, but I do think with that semantics it actually
might be best to describe things with a call stack an give some
examples.

What do you think?

Cheers,
Chris.
