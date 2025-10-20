Received: from heron.birch.relay.mailchannels.net (heron.birch.relay.mailchannels.net [23.83.209.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D44238C1F
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2025 23:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.209.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761004311; cv=pass; b=exeQ2ejKfZ2Wf8o81dhW4fb6aObaVQJncMwgf4QWt7PW8JRJKtskU1ajJnvcxD+zmw4L0jCdNSg9/Thd2OvakZh3gqhlOuNtCrabBhHgqHLEAdLU11Jbkv4b4qt7hFg1Kp7Arzi9M14XHIKkq/gxhZP4nsLZKZlcMz2/VT5Zrjk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761004311; c=relaxed/simple;
	bh=QENU7zQ3mjEjnpN38puM1MUc2iwm2NaIORZinMETfqY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XBtqIGrMZYPpcWle8YeqplXh3EhZnHvwySZ/vYpMSeF4eQboUh3cJj7oNhty8I3DWfqxd+iOFBXuG4N4/oBM97QKPsAHcqVukn4lUrQIKS/ERJi5djSDuIOOygAzT45eoj0QWnnVdQVNwXhdqlcFCf19VxdkE0S+J/DyVtDmF+c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=christoph.anton.mitterer.name; dkim=fail (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b=b/P5edEe reason="key not found in DNS"; arc=pass smtp.client-ip=23.83.209.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b="b/P5edEe"
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 444492617F9;
	Mon, 20 Oct 2025 23:51:46 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-120-23-87.trex-nlb.outbound.svc.cluster.local [100.120.23.87])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 7A22B2616FD;
	Mon, 20 Oct 2025 23:51:45 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761004306; a=rsa-sha256;
	cv=none;
	b=GKy6Rs1BzF3G3EWbIyYSj+fD1gXtg/7LVJwnGiBoTY4qc5yDkxSouxE3kHITPYu7qeHkSO
	DACvVCOqSw5BfMG78ImhHYKW3/ge5q9LHozUVhmfDcMr426VNZJMU5WOffiA7fCFhPJbOp
	fuE2iPhX6l9R2YQzrwGDvYxpmsaUH/CYiWVEQzQ7tQcF/GgHDDdvUeco7JJ6tD1qEGrXa+
	DUbxNAcJzOSMcSzUu7EvKw8NWz/hz5PmiouoU4E8ddoxj0cZtMfWSRaxi3Ky/mM3Q7kgiN
	2NNO6HsYjmW/VojBrPTmppMf+2qyEErEhVu/hdMdlNbKjASXMkUPwtuVGClg1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761004306;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1mPjpLp5VGL5JjuIy1VmmvriYFQrLjqJcEvS5Ow965M=;
	b=pkvlv68jlteGAH9qH7g46p9rhNMSyoqjJAo+I1QwnblKWwZGqBGVgUotg6MKrOcBqJvmUN
	6/OgEpAxlLedW9Er/eJEeEk0u2wzujmweN/I/LkySgBJDdZ7bNE1hARIlpQyrx0kmL0dAz
	BDcRzEjtP8KRyqQEUn/Wgd95vJ+/1yeSk0cx3h5OcA7iAjBLs+KzgFHytwEMZnuEesvO4T
	Rq/BUmL0GrXW/d6pykSV7GClzFXfaXDOdkc0ppjgmQLVqErD0j/jwdvmYm5BjuODwlm5dX
	ghCO4hnMEVR8hE7+hNwul9fOJLgddGv0YTaGBmHpOvPw2nYSBBNGRG9dKbxqqw==
ARC-Authentication-Results: i=1;
	rspamd-6c854d7645-7xtt8;
	auth=pass smtp.auth=instrampxe0y3a
 smtp.mailfrom=mail@christoph.anton.mitterer.name
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MC-Relay: Neutral
X-MailChannels-SenderId:
 instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MailChannels-Auth-Id: instrampxe0y3a
X-Cooperative-Zesty: 34b40ca8612d12e0_1761004306164_3138477598
X-MC-Loop-Signature: 1761004306164:1232171498
X-MC-Ingress-Time: 1761004306164
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.120.23.87 (trex/7.1.3);
	Mon, 20 Oct 2025 23:51:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=christoph.anton.mitterer.name; s=default; h=MIME-Version:
	Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From
	:Subject:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=1mPjpLp5VGL5JjuIy1VmmvriYFQrLjqJcEvS5Ow965M=; b=b/P5edEez0Fp
	zne6w/1/LzF94dOpflApdENKT1tK5JwB9K6k/xQV7HGEGiDdWU1NGruOxrMnWwIiYjfdWB6klv26t
	u/by2aFYjTMghXMZWlVCewRhyOAup9dCEQ+k4LR1PGTdsclxSkPw27bDMFBf8DtJNokWDzJ2rsm4w
	N1c6aKg8x90U7M9o2x1Mxp4qASmWU271eLg0Q0l4WNyintRlP6eUR8KuQw9Y35KGug5koonMO83dn
	ICgu9LWU41Sl3XkIl9FXkGDh2ukrRgsx1vbpN06Df2adFFs+RDaSbPkPJ1XuGrj4EB5Rz/BYGzA9D
	12qU465RC/jQCgP4QXlepw==;
Received: from [79.127.207.162] (port=50996 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <mail@christoph.anton.mitterer.name>)
	id 1vAzfE-00000009cqT-28mG;
	Mon, 20 Oct 2025 23:51:43 +0000
Message-ID: <dbd4df6260d8361b8c66d8ec8c73478a579a45fa.camel@christoph.anton.mitterer.name>
Subject: Re: [PATCH v3 4/6] doc: add more documentation on bitmasks and sets
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Date: Tue, 21 Oct 2025 01:51:42 +0200
In-Reply-To: <aPa1NdDe-snoN1AG@strlen.de>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
	 <20251019014000.49891-1-mail@christoph.anton.mitterer.name>
	 <20251019014000.49891-5-mail@christoph.anton.mitterer.name>
	 <aPX7qH9nCZ5VfxEJ@strlen.de>
	 <cb2b48e9a9d4d8c13b53297e5cc4482e0057deec.camel@christoph.anton.mitterer.name>
	 <aPa1NdDe-snoN1AG@strlen.de>
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

On Tue, 2025-10-21 at 00:18 +0200, Florian Westphal wrote:
> Yes, I meant wrt. intervals, there is no need for the value to be in
> the set, match can also happen via range.

Integrated this now.

> +In expressions the bits of a bitmask may be specified as
> *'bit'[,'bit']...* with
> +'bit' being the value of the bit or a pre-defined symbolic constant,
> if any (for
> +example *ct state*=E2=80=99s bit 0x1 has the symbolic constant `new`).
> +
> +Equality of a value with such bitmask is given, if the value has any
> of the
> +bitmask=E2=80=99s bits set (and optionally others).
> +
> +The syntax *'expression' 'value' / 'mask'* is identical to
> +*'expression' and 'mask' =3D=3D 'value'*.
> +For example `tcp flags syn,ack / syn,ack,fin,rst` is the same as
> +`tcp flags and (syn|ack|fin|rst) =3D=3D syn|ack`.
> +
> +Note that *'expression' 'bit'[,'bit']...* is not the same as
> *'expression'
> +{'bit'[,'bit']...}*.
> +The latter form is a lookup in an anonymous set and will match only
> if the set
> +contains a matching value.
> +Example: *tcp flags syn,ack* matches packets that have the SYN, the
> ACK, or both
> +SYN and ACK flags set.=C2=A0 Other flags, such as PSH, are ignored.
> +*tcp flags { syn, ack }* matches packets that have only the SYN or
> only the ACK
> +flag set, all other flag bits must be unset.
> +
> +As usual, the the *nft describe* command may be used to get details
> on a data
> +type, which for bitmasks shows the symbolic names and values of the
> bits.
>=20
> This contains minor edits only, I don't see anything wrong with the
> above and I think that this is a worthwhile addition to the
> documentation.

I also had some further edits there meanwhile and changed the example.
Hope I haven't accidentally dropped anything from yours.

Differences:
- Added a "generally" to indicate that sometimes using bitmasks and
  sets is actually effectively the same.
  Gave that also as an example and mentioned that bitmask matches are
  faster.
- I think it's better not to restrict that only on anonymous sets,
  cause then it's unclear whether it applies to named ones, too.
  So did that.
- I think it's better to have "contains exactly one value that matches"
  rather than "contains a matching value".
  The latter wording would IMO allow for there being 1 or many matches.
- In the example with SYN,ACK:
  - Sneaked back an "either [... or]", hoping you don't see it ;-)
  - Removed the PSH... IMO unnecessary here, it's enough to many that
    others are ignored. Also we give no example flag or the set case
    either.
  - Made "all other flag bits must be unset" a standalone sentence,
    like in the bitmask case.
 =20

> > We can either simply drop, or move over to the BITMASK TYPE
> > section.
> > It's not super important, but I think there might be some value in
> > understanding why these are identical (especially as many people
> > use
> > something like ct new {established,related}.
>=20
> Yes, its an exception by virtue of a flow being either-or...
>=20
> If you think it should be documented then maybe it should be added to
> the bitmask example, it documents the difference with tcp flags
> example,
> maybe the counterexample can be made there.

Had meanwhile already done basically that... please check when I send
v4 :-)


Cheers,
Chris.
