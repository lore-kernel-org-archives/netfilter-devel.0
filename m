Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6BB49651
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jul 2024 20:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720124362; cv=none; b=B0R/OEQoog7SHQpUYb02psjSQkLboHGdZcbTlp0YDmcc1yMRBOaVHd9s0mbJGlQCMQ54B4szfpXfQzvb7mnNMN+su8P3sYlRxeKp0swOR6kex4Vtrc2hiTJr8okqdbECIxHAJ3kl5M/jdQmWw3gjhuhzvU8H3jh5LC0TwtykcKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720124362; c=relaxed/simple;
	bh=4IhmFi4w9nfWUSYZJ2xZ2pkm+3zTfwOh9OPTKt9fwuU=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T5EJ6YSgywmCV0wVpMca+TXt5zWmQX3GqxNwkXJlJH5+smkKH+jKPnsLqT4FkxOMTs1hUPWarJ/e8cq4EyQaqacDsxq54FfXwlNroDeo+dOxD9EZ9Jy6wb8XVjul1iO7RTGU5ilwFPWBs0iRTNxX6uPKPOHOmH1JN+TbhONRiN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=Qe/iJTJB; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="Qe/iJTJB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tUiy4lprizOcQN30uJLDAFyeZbnTYo0C93Dgu7ZhzMc=; b=Qe/iJTJBkOzsZwMH+MX+TaWSQo
	vC0ED/Sn6DryQAtDkCU2xUtu+OJuYfzczswq3/F1mdeL4yB3yBwPMskvgj3TmoOdnIfO42f30aa+z
	kmZD1UlHtd7Zs2KEl0zSHKNsiN+K84UaVydh8hMI6olScU+kQUP+fVUGHr41s8GPCaaZ0ikKr2A9r
	F8qm2XIrWogR7EKKzSriSNkGHNEU6ht9bqk6uji8DJ3eIn5LNGX4f9A48ZJ6y5rD1+P7OYmcWKKpm
	sW6iZYCez2wSFiD3ERZQh0TLiFJtH5yFYQGnyveFtI3vTGmf/dY6+GXILl1sW8W+Ac62c3Kuhqj73
	pI4bs8CQ==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1sPSv5-004Hwu-31;
	Thu, 04 Jul 2024 21:19:07 +0100
Date: Thu, 4 Jul 2024 21:19:06 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>,
	Netfilter Devel <netfilter-devel@vger.kernel.org>,
	Michael Biebl <biebl@debian.org>
Subject: Re: iptables: reverting 34f085b16073 ("Revert "xshared: Print
 protocol numbers if --numeric was given"")
Message-ID: <20240704201906.GA3592786@celephais.dreamlands>
References: <20240703160204.GA2296970@azazel.net>
 <ZoWB2Qo_vi-YIRqc@orbyte.nwl.cc>
 <ZoWj4FBGF4E0Fwb3@egarver-mac>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="DXPQGkiBPCxlnzSi"
Content-Disposition: inline
In-Reply-To: <ZoWj4FBGF4E0Fwb3@egarver-mac>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--DXPQGkiBPCxlnzSi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2024-07-03, at 15:17:52 -0400, Eric Garver wrote:
> On Wed, Jul 03, 2024 at 06:52:41PM +0200, Phil Sutter wrote:
> > On Wed, Jul 03, 2024 at 05:02:04PM +0100, Jeremy Sowden wrote:
> > > At the beginning of the year you committed 34f085b16073 ("Revert
> > > "xshared: Print protocol numbers if --numeric was given""), which
> > > reverts da8ecc62dd76 ("xshared: Print protocol numbers if
> > > --numeric was given").
> >=20
> > I did this in response to nfbz#1729[1] which argued the names are
> > more descriptive. This is obviously true and since commit
> > b6196c7504d4d there is no real downside to printing the name if
> > available anymore (--numeric still prevents calls to
> > getprotobynumber()).
> >=20
> > Personally I don't mind that much about changing --list output as it
> > is not well suited for parsing anyway. I assume most scripts use
> > --list-rules or iptables-save output which wasn't affected by
> > da8ecc62dd76. Of course I am aware of those that have to parse
> > --list output for one or the other reason and their suffering. The
> > only bright side here is that whoever had to adjust to da8ecc62dd76
> > will know how to adjust to 34f085b16073, too. Plus it's not a moving
> > target as there are merely twelve names which remain in '-n -L'
> > output.
> >=20
> > > In response to a Debian bug-report:
> > >=20
> > >     https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1067733
> > >=20
> > > I applied the change to the iptables package and uploaded it.
> > > However, this caused test failures in the Debian CI pipeline for
> > > firewalld because its test-suite has been updated to expect the
> > > new numeric protocol output.  Michael Biebl, the firewalld Debian
> > > maintainer, (cc'ed so he can correct me if I misquote him) raised
> > > a point which I think has some merit.  It is now eighteen months
> > > since 1.8.9 was released.  One imagines that the majority of
> > > iptables users, who presumably are not building iptables directly
> > > from git, must, therefore, have adjusted to the new output.  Is
> > > it, then, worth it to revert this change and force them to undo
> > > that work after what may have been a couple of years by the time
> > > 1.8.11 comes out?
> > >=20
> > > What do you think?
> >=20
> > I think it's a mess and there's no clean way out. The current code
> > is at least consistent between '-S' and '-L' output (iptables-save
> > should not be "less numeric" than '-n -L'). If it helps, I can work
> > with Eric to solve the problem for firewalld so Michael will have
> > something to backport to fix it.
>=20
> The firewalld testuite failures have been fixed [1]. The revert
> exposed a bug in the testsuite normalization. It's not actually caused
> by the revert of iptables da8ecc62dd76.
>=20
> Michael could backport this to Sid.
>=20
> [1]: https://github.com/firewalld/firewalld/pull/1360

Michael has picked this up.

> > All in all I have not seen many complaints about this change, I
> > expect few people scraping iptables output and only a fraction doing
> > --list.  In addition to that, I plan on soon having a 1.8.11 release
> > (we're far ahead already to make backports a pain).
> >=20
> > What do you think?
>=20
> I'm indifferent. As you say, there is no clean way out.

Let's leave things as they are.

Thanks for your time, all.

J.

--DXPQGkiBPCxlnzSi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmaHA7IACgkQKYasCr3x
BA0OUw/+JSObloszgej8YISFs0WAm7k9pLmqQkYdhSW1oZ5UhB8UCGUFg9jn3dEX
D68gNI1niOAxASK3e2kcnxLb6flPJ0fm5OGpXt2Nld/uvUzwK/lLnCkWfI+s+ZBo
BirNkiBBeJpu8R3Abf5EszhgK8kjP2FFUVTjMyD7VJCVvjcfq1S4qA2RDv+L9EKW
MeLXoMv3TlrkHrRq5PgoTijcbZNvuynvqDf7XQc9x/TgCGeihBBViQTcfh3HDBL3
fgYQHBniKV5TucdabtOIMXiCPgX2Y5YECs4mj7gdKtcJXXZGKmFHZhjAhCzMMkuO
OeEYVHlfxtNSTjJSL6mNzCCBsLZurYuCLSnrNvMtUNWr2UjfJ0/AQO08nIuHQrfl
K5xKMktW9yqlbY3gJzO3K1Y15b6+BVYCYgH4MvAqa0Se2lc6jeJqvbZotMW8ljZp
W73SNaNbY8rpor6YVZKbZs0P720Gvgys+B6E/sYe+KNJpfyriJpEkSA4w4fdW3/Q
QU27MlSG3Dnv/c0Fq0Y4/yRTc2Lu9MHVFjKdOSEPctpqVpHkqg98VoJa6w3fZXJD
2Jt6BfUM1Mu4SwbeZ/G1kE/ATLcZrq/4/oQPk7LGDcgoIFsW6A7FIR76MKQSpEha
AFe8XKRRHQ3rw+tRSPCNdWveO4GgBfileWTHHG3M3p3n9IFJCq8=
=4siR
-----END PGP SIGNATURE-----

--DXPQGkiBPCxlnzSi--
