Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AA3FC08
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Apr 2025 11:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745409134; cv=none; b=Gz/KHNxOTLM6JTxt5Ml1Lsz5vqJBLrjtlpmrgzIfnlwr4UEuOzlfVvDgmCTllMr+0ktFnXal9yGILFpgsq1Wg6UV59azqC9QgK969Pn7kL1bYzn4lchrlKbGP+V6iPQ0AAIW5iE5zfPmEkucqLuCH4K3eWMBKmRV29ZEjW/0zMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745409134; c=relaxed/simple;
	bh=MRWryquFq1mr/R/svlPjN2T6gDgHOCWOs+iXQF4rkr0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gzHAwEugkjm47D5k22Z6UOLRWc3rs2kEAuNavAypvvt9F+vesP0TgN4kFXYZXPJczmNkpTLf0xchBN1f7ibI/G1QnlQmnPaV3i0oxOUy0S7rKpScSrRdjuQPKXQFDPyovY6qyewVaHqTcLrYYu58Ty8GkWIzpfO6GACTyJNFuMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=IxFT80Oz; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="IxFT80Oz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Ed5YdELfO8WXzoeAN+Q0QXC5Mpytds32OL/uzJBApq8=; b=IxFT80OzI76eRJl4A7K0JZyf0G
	fIwXhmiKOJ8hpGZsr+LNhFazXgJW+plYtu+VFJSkpLF7Fk6C/y7Z4u2eopHF5kNf+kbDkNmLrZ6NK
	zTr/sxkMckzU6qruZppsitsPDYu/3zja9FMKHMpN9wcuSpQe6ivCyUUShSrY1Hzbp4aJfpA6rR6XO
	baJ/GOKmDn/MFD29BA26JhOfKRYTdq05/9d9eS35niq9TG+ulfi6Hkxf7/g64yLuFm0ezzAqMZscH
	TJXhkH2UYZP/+/EPvj7t3iwkjbPaTWKcS9jV5XqPN2QHOl/bBjgcXCLoWhA1S7jFRQYvXhr6+8rNL
	Ck5dyFXQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=azazel.net)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1u7Ye2-007jhs-0m;
	Wed, 23 Apr 2025 12:52:02 +0100
Date: Wed, 23 Apr 2025 12:51:53 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Florian Westphal <fw@strlen.de>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH ulogd2 2/6] db, IP2BIN: correct `format_ipv6()` output
 buffer sizes
Message-ID: <20250423115153.GA349976@azazel.net>
References: <20250420172025.1994494-1-jeremy@azazel.net>
 <20250420172025.1994494-3-jeremy@azazel.net>
 <20250423112204.GA7371@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="1SNpoLleIhAUdK8X"
Content-Disposition: inline
In-Reply-To: <20250423112204.GA7371@breakpoint.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--1SNpoLleIhAUdK8X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2025-04-23, at 13:22:04 +0200, Florian Westphal wrote:
> Jeremy Sowden <jeremy@azazel.net> wrote:
> > `format_ipv6()` formats IPv6 addresses as hex-strings.  However, sizing=
 for the
> > output buffer is not done quite right.
> >=20
> > `format_ipv6()` itself uses the size of `struct in6_addr` to verify tha=
t the
> > buffer size is large enough, and the output buffer for the call in util=
/db.c is
> > sized the same way.  However, the size that should be used is that of t=
he
> > `s6_addr` member of `struct in6_addr`, not that of the whole structure.
>=20
> ?
>=20
> In what uinverse is sizeof(struct in6_addr) different from
> sizeof(((struct in6_addr) {}).s6_addr)?

A POSIX-compliant one? :)

	The <netinet/in.h> header shall define the in6_addr structure, which shall=
 include at least the following member:

	  uint8_t s6_addr[16]

I dare say it's hair-splitting, but it's the size of the `s6_addr` member t=
hat
is significant, not the structure as a whole.

> > The elements of the `ipbin_array` array in ulogd_filter_IP2BIN.c are si=
zed using
> > a local macro, `IPADDR_LENGTH`, which is defined as 128, the number of =
bits in
> > an IPv6 address; this is much larger than necessary.
>=20
> Agreed.
>=20
> > +#define FORMAT_IPV6_BUFSZ (2 + sizeof(((struct in6_addr) {}).s6_addr) =
* 2 + 1)
>=20
> I'd prefer to not use the .s6_addr, its not needed.
>=20
> > -		for (unsigned j =3D 0; i < sizeof(*ipv6); j +=3D 4, i +=3D 8) {
> > +		for (unsigned j =3D 0; i < sizeof(ipv6->s6_addr); j +=3D 4, i +=3D 8=
) {
>=20
> I would leave this as-is.

Fair enough.

> First patch looks good, I'll apply it later today.  Still reviewing the
> rest.

J.

--1SNpoLleIhAUdK8X
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmgI1FEACgkQKYasCr3x
BA3hcA//ahfA4UN8/wz3Oo5c7Afk8QvxsjxCEytQ5eajf26kkSrvtuM7TaH4ASiv
U21a7LeZYuufIrSVCDp8BhepqcVuuuXileZ2ehvxRDzdW9szb+GYdpy46EjaHYGc
KtiXgO7IpWDXaMzspiUE8hPklWe2PEw2Dnfcur1amdu6vKyvdm3PMGQW8w2hMm9j
X3x4dcPhOLfbcBcWxQsXL/r9nPq/Z9IITQ0dO0p9Uzah4ht/EXvoGOFrIZ4LfU/s
XmlrGMSvxQv73yb2Nx/6y18l444lff02tWwWs1JYAULTXx2BOwWp+1UWZ4CfjriQ
fKsgNv2iHnEQToQFy6CiBlW8TAjeJ1/VX5mjFMkwLxJHj16ke4UY2HRvhORVKSzl
Gika6TX8p/OexM2sALDHqT0I3Bat9Kq+QU5FlsbWEDZ1tbaid/q3rOfSGWLtBSis
vraj/lvHa7EggP3E0w0PidXcknt6DL+XGnXCsR5GAh/ff1yDMyQWBTJqQUABWHpY
vjGzwzg/PgHxtGb2K0bfu4oKxI59WUQ2mRohOq9ML4bKxE3Tz8dbl1h13CvPo7Vg
4rqdmeDDZrrc0JOPSCX6nTJ3r0ZwirhslGPtLV9r5TDaqa/dK2KQi2C62GZwViqG
myda3S89ogM5FLMgC2/ln7C8BnWcVRfcJQ+QqVJa8iIFmbMyeeE=
=uNeS
-----END PGP SIGNATURE-----

--1SNpoLleIhAUdK8X--
