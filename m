Received: from toucan.tulip.relay.mailchannels.net (toucan.tulip.relay.mailchannels.net [23.83.218.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF66226D16
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2025 22:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.254
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760998786; cv=pass; b=KFifAac3IjC6ZKUB1Io03Dio29q7ZNuHpxGXG9+ar+nXm/Oaeb8wVN2JH7/UmjgnO7W21cVLF8F6QTXaiJPSPgW73UuQLvdmKX7dIIm/Zw013/aTfbzucGMwCB5OhcZZfRbjitM8P8cCdmJm/xsmwE8NffG5FcHtGEOJ3cppgNw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760998786; c=relaxed/simple;
	bh=JgOx4zqjUM4SQMyXmirfGb1O6RI4yQ/i1V7R3cxBkpU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JBQR+iZlPYuCT+AP/qUMdQnQvpx/NvRlCc/NOLzfxL1mK/pZtensm4S2UOR//w8LcW+KnPatBPQIZjcjW0vbKMcpIaCkXzfipCrFIXlGMPyHu8OT3Vp0wXFcDFQaVddeuiWHMEWHcqqaLgoJGtxoo/qNg5CVrYBQuKyalBkwFQQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=christoph.anton.mitterer.name; dkim=fail (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b=P8MM0ymX reason="key not found in DNS"; arc=pass smtp.client-ip=23.83.218.254
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b="P8MM0ymX"
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 4DE668A360E;
	Mon, 20 Oct 2025 22:14:00 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-4.trex.outbound.svc.cluster.local [100.119.74.21])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 7DC068A34A1;
	Mon, 20 Oct 2025 22:13:59 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1760998440; a=rsa-sha256;
	cv=none;
	b=FR9PW74qbeSk987Aj6Z12PVsWl87zsDLJ8Sf2FCnryhz6Pwfrend/auW+ALDateS7OsKwn
	qgVgAOEnUKjg+i8bYgjlM5sx7ISQkHOXI5s/Bc7pchYvrn1Itsjg6g4r1tbKT0yOoihcOl
	fJdQO35W6nHyluFbOQ2mLhKWaVN94/8Ghs05IMj7AhI+xeQctpjQhXs8tnRpuNZPD17His
	BP3DvMFG/HmVzYhK2iZILN6WTd9zgpAzD4so16TahQrSNUqxNt+mZL1nRjqlMiSYjsKoVR
	L0P2P92OSATLeWHZ0qJ7gI/W6vCaLedc/XfKzWPNZED0xaBocyWOtAJ/s11Efg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1760998440;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JgOx4zqjUM4SQMyXmirfGb1O6RI4yQ/i1V7R3cxBkpU=;
	b=WBcl/013OlBLRNHIAqsWE3FpwJeGhy5YFtDdJG28q/9fPovCrcHnNyb+2n+bW4QMiTlFLS
	1la2mZdtmQjTw0wO0u5YHCHLUTKjHtTo8Tla46oaCnDCBu+GxgpPXVxp2MN57mfl+xxW8g
	maq4MY07zvuZFb96RaMEh4zUTqHYqD/P131A8Wrn83dBEhI6Aaj7a+58dSl9Tj1M2ZWuyP
	eYwO9bgGu2UrSRCmg23fR6kzWVEoqD2TS3y8/ObEVLCSqXOkJe20xmMMHPqAgTKhZ+JLeE
	A60nyKlNdb5SifWUJ+2bFDK+IoMAgsvGXW8tN+KjjF8e7o9C4m/TQezeM5F+HA==
ARC-Authentication-Results: i=1;
	rspamd-6c854d7645-7tn78;
	auth=pass smtp.auth=instrampxe0y3a
 smtp.mailfrom=mail@christoph.anton.mitterer.name
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MC-Relay: Neutral
X-MailChannels-SenderId:
 instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MailChannels-Auth-Id: instrampxe0y3a
X-Squirrel-Whimsical: 1815fe6513d1fd6b_1760998440208_2313134713
X-MC-Loop-Signature: 1760998440208:1568662331
X-MC-Ingress-Time: 1760998440208
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.119.74.21 (trex/7.1.3);
	Mon, 20 Oct 2025 22:14:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=christoph.anton.mitterer.name; s=default; h=MIME-Version:
	Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From
	:Subject:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=JgOx4zqjUM4SQMyXmirfGb1O6RI4yQ/i1V7R3cxBkpU=; b=P8MM0ymXWdDa
	XMZDnimndrpgLyd5/jy6reU8yKFROCtX3DXM2g7pgPNdThWaDgtgI4OT9feajJB2Xw2wXqeyPRjBa
	cqWmfqDsBIU0erItSA6EhjSe7UAOIsaNRCnmQBR0PLPB1hLX/lTI4VbtXl3ZyQ/jZ4hqgnPf+uroO
	y4Blus00hdsuzLDY+D/jL50kwuAjUpXpYMXRWsHEzzyM1n3ykPz6/8knjXJ2BpK5ffbHOYtfu/fAc
	vt8ZDejto86Ok809lCwWppx662qJRy/wx4h4VsKAyA3m5ve2a8UCrPBazP4X4ApsjJHdWj8D+Eu+q
	IpKVwTbgCS6qniVmLYwM9w==;
Received: from [79.127.207.162] (port=54972 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <mail@christoph.anton.mitterer.name>)
	id 1vAy8b-00000009APD-3bMy;
	Mon, 20 Oct 2025 22:13:57 +0000
Message-ID: <d071e75f1b9981ba8d5f650c5805d79a0f77d683.camel@christoph.anton.mitterer.name>
Subject: Re: [PATCH v3 1/6] doc: fix/improve documentation of verdicts
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Date: Tue, 21 Oct 2025 00:13:55 +0200
In-Reply-To: <aPYAuQ89M7Z7doVJ@strlen.de>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
	 <20251019014000.49891-1-mail@christoph.anton.mitterer.name>
	 <20251019014000.49891-2-mail@christoph.anton.mitterer.name>
	 <aPYAuQ89M7Z7doVJ@strlen.de>
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

On Mon, 2025-10-20 at 11:28 +0200, Florian Westphal wrote:
> Christoph Anton Mitterer <mail@christoph.anton.mitterer.name> wrote:
> > +*drop*:: Immediately drop the packet and terminate ruleset
> > evaluation.
> > + This means no further evaluation of any chains and it=E2=80=99s thus =
=E2=80=93
> > unlike with
> > + *accept* =E2=80=93 not possible to again change the ultimate fate of =
the
> > packet in any
> > + later chain.
> > +
> > +
> > +Terminate ruleset evaluation and drop the packet. This occurs
>=20
>=20
> Hmm, looks like something went wrong during a rebase?
> Why are there 2 blank lines followed by a rephrase of the first
> sentence?

Nah,... my fault, not rebase=E2=80=99s. O:-)
Forgot to remove the old version. Sorry.


> > +For example, a *reject* also immediately terminates the evaluation
> > of the
> > +current rule as well as of all chains, overrules any *accept* from
> > any other chains and can itself not be
> > +overruled, while the various NAT statements may be overruled by
> > other *drop*
> > +verdict respectively statements that imply this.
>=20
> I totally dislike this sorry :-(

=F0=9F=98=85=EF=B8=8F


> There is no overruling, there is no 'verdict state tracking'.
>=20
> Or would you say that a qdisc that dropped a packet overruled a nft
> accept
> verdict...?
>=20
> Sorry for spinning on this again and again.

No worries. All fine. :-)


> All this talk about *overrule* makes it sound much more complicated
> than it is.
> Can you re-send this patch standalone, without this pragraph?
>=20
> Or perhaps just the 'For example, a *reject* also immediately *drops*
> the packet'.

I removed these examples altogether. The sentence:
> These statements thus behave like their implied verdicts, but with
> side effects.

should actually already be enough... maybe I overdid the "holding-the-
reader's-hand-and-guiding-him-through" a bit here O:-)
