Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F73377EB4
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Mar 2026 11:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772711767; cv=none; b=HEykEqlga0U/L3kPKMz4SqqnZinDICZtm9+78W76hydWgZQw928cpJ1qSTwo41b1KYiQhhKYTCUFgGbKxqSh0QUAPzr2Rp4bcFmBG5iXUNSZiJEihU51LZxaGR2IuASReeEeCv0pFG/tO26UymOur3MyM3i8U/VlGVObrmhSW3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772711767; c=relaxed/simple;
	bh=btUAeNB2L2jiK/FxnsxtzPS/elFLqaIcYr1c44lk5iI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d6Y2g868+vVuFBxHIm9h+Re9pe4r7UiOkutoMJfZR0lHP+1WeFmnogED5Pyw1EwxhNdhJDNoUUJiarKIP/nGejNeFZrAdscMdndVpVX3u9PhpKnTjD3kaZsA2wJr9ixwaAUH+Wk0LnEXVgZpGPBaWHz0TteiwlDLlBYLMUoPncI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=ZHdyNRha; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="ZHdyNRha"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tsk8SRukygvSHIv7NfJSKQ4KHa59ehELQcCUKVmcOoY=; b=ZHdyNRhaBAUmc9YJSBmYPS5Nvy
	lJgdwnq7Efh1gN3R5sXo7KI4WVO03cLIWkBgygJwYGqnQym+iqaRU038wr43Y140jpGaMF3WhxyvA
	W6hNGdjZzgVz/BzpQJcZWa1O56XOjNh5IcXnyNVVlDMovgjbr7aymWqdgg0RQmds7aGHPfN+VwbI3
	CKQGuEhNs4HCDwzqL5/n3UquWmda/0HCJwMDumsZHyDdQO01fHWzT37C7C9aPgkkDW5hG1zbUqyBH
	6bNhQRduWGvcaqD0fwtqHywoh49xP8UMkHVukOdpBSUZX2Ujy7KSr6SCpWeCFLZ9Aywp9Paw3BSZ8
	ZDQ0BF6Q==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=azazel.net)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <jeremy@azazel.net>)
	id 1vy7JE-0000000A9CE-0FHL;
	Thu, 05 Mar 2026 11:56:04 +0000
Date: Thu, 5 Mar 2026 11:55:50 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Phil Sutter <phil@nwl.cc>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH iptables] tests: iptables-test, xlate-test: use
 `os.unshare` Python function
Message-ID: <20260305115550.GA770968@azazel.net>
References: <20260304181304.696423-1-jeremy@azazel.net>
 <aalk_STwkHIwC4RY@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="RBJ38wvUmu3YlPjt"
Content-Disposition: inline
In-Reply-To: <aalk_STwkHIwC4RY@orbyte.nwl.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--RBJ38wvUmu3YlPjt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2026-03-05, at 12:11:57 +0100, Phil Sutter wrote:
> On Wed, Mar 04, 2026 at 06:13:03PM +0000, Jeremy Sowden wrote:
> > Since Python 3.12 the standard library has included an `os.unshare`
> > function.  Use it if it is available.
> >=20
> > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
>=20
> Patch applied, thanks!
>=20
> We have the same pattern in nftables' tests/py/nft-test.py, could you ple=
ase
> send a patch for that as well?

Yup.

J.

--RBJ38wvUmu3YlPjt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJpqW8pCRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmc5A2/FcuNEwqfKj2xVNba1MhNgt695NX9aS7eCaLbB
jBYhBGwdtFNj70A3vVbVFymGrAq98QQNAAAGKA//QGJDVegaIsT77L59GBdpG6fX
4Z8drl4LZQSGt9cc4E50sEuHGaL5+XFdqQyuxscUfC9dqyrhlcB3gF2TdEEK1ZJ3
7xBi2k0CsdrA7T6DLd5yhyvS5CsI3L9vXeodFbUzNYietJ7y7eQbeSofk6NVR1Yu
5MdeHnUWQ8JW0yP5z1K6C67kzkO1CcGwP8uIk5YHWQR0soIbfrOEBUX8b/bONjhz
om6Y8sickVh1ju1JQ0DJsUMAP0fIM5twWlSTS73cj1bfLeNQb5Pr3L3wYH+8bRum
+zUh8KYpdokDQ5HjfdVxjl2/vnx8oZ5+YQ7W/iIcLQrOXG6L96Uoe4GqcWjE/Kzo
Kfhk7Wux9Q4MNC+XRMKbPqYHSvd7VaM960QPiZkVAkvf65eLChFDOEahAyKWYZ0w
lWs3y7caKJASgFSxglJr7pYpLTc6SLlQ8JjfDxH0qGg0OS/08hA4OkX4fSTGaJYr
Ksam6N6u1/b2YsHN6clkukWhMBNlh9rtkV6FA26UHyFvFw4nVBWmW63WQGlmDTRb
9C4P7IZFDSGy9Vt+u8DExJVOpnoauUb1hi+DcRkL2ioJ9UobRYktyVcxNBBC05KF
Ivdq+tqHxBGQEjxCoy3tldwSfdvQj3zvq/9M9gSLTf8uaf1VAA01utq5AHvP0xSj
3pdTZu8HVwNvPYkwo4g=
=4kWu
-----END PGP SIGNATURE-----

--RBJ38wvUmu3YlPjt--
