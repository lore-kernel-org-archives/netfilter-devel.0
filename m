Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.110
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793394575;
	b=Mw/KToMX71B7GJTJKHc74pfSdTRcmHtvSQ/v6VqXkTM7KhXDs0zbG4jLdSEjC1R2Qwxn
	 x3+IwC8mIZbXYpfomFS8DFCXPg3CDKWZW1LtjhdJPW9A4eFwHzm1zfo+htba3HUmcN4cr
	 YXA8vVspsmI9mUvtk9dGjz5HbgdIQHD8JUxyvfKDIfcU4dkGjs7nGPl8HMN11GD5AxYQw
	 Pc2qBVO4bQGRWGtBsMjtnuvc1scN9K7aA9irRs3F/mypCFh/Pt48Fc6t1yxamvW7GO+oW
	 jqP+LfMGbJvkJltvaU7m1j711X+4u9XMc2uN2Mx+pnJXGN1X4XK4ePwrsIQNU8KpAZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793394575;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=l5KITB++LwGgX9q7n3K+9DNuQSi45ehi31pKPZ6I4Gg=;
	b=DEK4kNXv8oKth8AQEhT3vtr9nbOgC+GSTY0+DkIcbDKmXASuHGEKn1jQD2Qc8mIrGZnJ
	 iXSjxWSNOBkWUeDoGvRw1mcX6Q6otkEtzqH/XH3+5xbLLYKfmOEzcy8vhA9r7S61uUyAO
	 NZHEFFjgAd20IEeWykmbGY5LF1QLSeU1wuzrbvxoYVE/haY7HyFVHXQ5bKixXQ0qjF/5J
	 lRKh5UIc8/xhTw/tfdTqfG1JR2kKfP37h2pflOgK+QgqaZQChynptepXsTBXXXXJWlxOu
	 CAPhz+gdl354oBorzoigHeqQm2cf6UfXr23S+IGx9Fgspsq1rxLw73CzrbzDZtjk2/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=none smtp.mailfrom=master.debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.master header.b=fjhHUAxz;
	arc=none smtp.remote-ip=82.195.75.110
Received: from master.debian.org (master.debian.org [82.195.75.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9A5606A31C
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2026 21:09:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD9A5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.master header.b=fjhHUAxz
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.master; h=In-Reply-To:Content-Type:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description;
	bh=l5KITB++LwGgX9q7n3K+9DNuQSi45ehi31pKPZ6I4Gg=; b=fjhHUAxzezowTq/or2lxOPaE6j
	s5ZNVHikb/yr3HmHw0kSMF/Q0jCN/FlQgyao2iiigcFo4bpUIh+/oGDA5+NQj47ALh6ykNTl0FxIi
	uAneKgKKZPrj7MqUO4MQOL+s1P/WTyBqc1eREY7cVvbO/kVHPgsp+bZHz74qSDjKN79MbrOCGytRx
	S8n7X1ZKW9znv6aVQQYqF3FlgJpUcN+MF595bHvAL0ERMRK1CXyncry0AWWm5iNvukfctSjN3Zz/W
	Fhsy7UXNRhbGaRfOtc9oD7gyum/rsqxa3BAfI01ZODs4ot3dSR5EdTHWySfGxqadYdol0aNwSW3fe
	FQcycDiw==;
Received: from ukleinek by master.debian.org with local (Exim 4.96)
	(envelope-from <ukleinek@master.debian.org>)
	id 1xMtqr-007WgP-38;
	Fri, 30 Oct 2026 21:09:29 +0000
Date: Fri, 30 Oct 2026 22:09:27 +0100
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <ukleinek@debian.org>
To: Philip Dodd <orange.spyderman@gmail.com>, 1149525-done@bugs.debian.org
Cc: Florian Westphal <fw@strlen.de>, 
	Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Subject: Re: Bug#1149525: invalid pointer in nf_conntrack
Message-ID: <auUFc76KW7-_u4R0@monoceros>
References: <auDhy6OW5SrGg3jv@monoceros>
 <auMgBQDEedGU8iiT@strlen.de>
 <179076304109.1376.1522422117778282591.reportbug@bellecote.private.montagnes.net>
 <e80f4fde-ec36-4fc3-9386-7b8c1053e1bf@gmail.com>
 <auRJp3wtNw4yaWXK@monoceros>
 <0d043989-c4b6-424a-93a8-3165e38750ad@gmail.com>
 <179076304109.1376.1522422117778282591.reportbug@bellecote.private.montagnes.net>
 <2256eafc-a76e-4b6f-b90e-1f5ed7147752@gmail.com>
 <179076304109.1376.1522422117778282591.reportbug@bellecote.private.montagnes.net>
 <7732fc2d-bdda-48fa-8822-b8066e22687b@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cao7az5c5gm2ncbn"
Content-Disposition: inline
In-Reply-To: <7732fc2d-bdda-48fa-8822-b8066e22687b@gmail.com>


--cao7az5c5gm2ncbn
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: Bug#1149525: invalid pointer in nf_conntrack
MIME-Version: 1.0

Hello Philip,

On Fri, Oct 30, 2026 at 01:45:15PM +0100, Philip Dodd wrote:
> OK - it's more complicated than that - previously Oops'ing images now no
> longer Oops either, so something else has changed.=A0 Am investigating bu=
t am
> pausing any bisect work until I can reliably reproduce the issue again.
> Having gone for a couple of weeks of being able to reproduce it easily, I
> now can't.

Yeah, without the ability to reproduce, bisecting doesn't make sense. A
bootloader and/or TF-A update can have an influence here (though that's
unlikely) or changes in your network.

Without a reproducer we can not help you (and don't need to). I'm
closing this bug to get it out of our list of relevant bugs. If you can
reproduce again, please reopen. Then it would be interesting to know
what makes the difference (if you find that out). Then you probably also
have to reverify that 7.2.x is bad and 7.3.x is good.

Best regards
Uwe

--cao7az5c5gm2ncbn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmrlB4QACgkQj4D7WH0S
/k4z1QgAgtNADPFMtR0xIQeqN9HDE7aA6zSYe9qjzhl+LC03DZzvH12tG//AWY65
kfrHDAHDGEmm/psjVgPaW3ctuldiMKeqInOqqHW/xTNOH/KBSowhQz95EjBiviBH
qSe0DElZvvBs+5Gi225qrg6JS+bE19vujmowMZciGT0tuENa5zROma+TdXlgBvVc
4JMAysDupVe3XVCaMeVqm6yqTVfZ1vcwkUZqluJoPYWfds+ZNQlSvu9vohcmdcyv
JvrTQuvnSowRPH441PUK08qMMit1M3UwMfo7HC+rDlXK08OrIcvewpvZl36PdI2F
VU/+AN0W2q2stK0W63Wm2Zzi6EJmxA==
=A7dp
-----END PGP SIGNATURE-----

--cao7az5c5gm2ncbn--
