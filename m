Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AC718EAF;
	Mon,  1 Jul 2024 22:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.217.213.242
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719871390; cv=none; b=buy9CN2oGkH67KWx1qA5k00tHaAfxbv2/DK/rcrxzL7Jx5yqvCHYhqsWLn3fzWPmcOEijwOhAayRJbHpgcaK9heVTahphumlOUYhJf5jkrhn299rROXDNBGj+fngo3SR6XGna8N7+VsmVmul4g1ogaYNIFyh6v3htmPwPqznqFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719871390; c=relaxed/simple;
	bh=Y5o/L97g+ZYOG1CiQ7fBwcAl6AYqmFjKcl4L+CIA6oQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UUeAhrTusXZ1n9DEAQqKrryVHpb00TycAAbHNzfd+rI9ei/KGwOvkk8wyrzJizsJlvrGrOaj+ZYAPy7zXVRbSWiP85trr1CgmR9vf0LVlpBXD2Hr9/c8fglFFUKB55f/oI2pZZmqJ6jE8QX73h+P0hlUtChxt5cxAwWCkFhBn0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=95.217.213.242
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from 213.219.156.63.adsl.dyn.edpnet.net ([213.219.156.63] helo=deadeye)
	by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ben@decadent.org.uk>)
	id 1sOP71-0000b0-Hn; Tue, 02 Jul 2024 00:03:03 +0200
Received: from ben by deadeye with local (Exim 4.97)
	(envelope-from <ben@decadent.org.uk>)
	id 1sOP70-00000002Nka-3GYb;
	Tue, 02 Jul 2024 00:03:02 +0200
Message-ID: <8ede281c9348a21efc806739782f622bf27f8e7b.camel@decadent.org.uk>
Subject: Re: [PATCH 4.19 164/213] netfilter: nft_set_rbtree: Switch to node
 list walk for overlap detection
From: Ben Hutchings <ben@decadent.org.uk>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
  netfilter-devel@vger.kernel.org, patches@lists.linux.dev, Stefano Brivio
 <sbrivio@redhat.com>, Thorsten Alteholz <squeeze-lts@alteholz.de>, 
 jeremy@azazel.net
Date: Tue, 02 Jul 2024 00:02:52 +0200
In-Reply-To: <ZoMlOF3HVq3UP0aa@calendula>
References: <20240613113227.969123070@linuxfoundation.org>
	 <20240613113234.312205246@linuxfoundation.org>
	 <861740945d6a21d549d82249475b6b5a573bc9ed.camel@decadent.org.uk>
	 <ZoMkPqf8AOpROvRd@calendula> <ZoMlOF3HVq3UP0aa@calendula>
Autocrypt: addr=ben@decadent.org.uk; prefer-encrypt=mutual;
 keydata=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
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-knXT3Og6EkDmvDngi0YR"
User-Agent: Evolution 3.50.3-1+b1 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 213.219.156.63
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-knXT3Og6EkDmvDngi0YR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2024-07-01 at 23:52 +0200, Pablo Neira Ayuso wrote:
> On Mon, Jul 01, 2024 at 11:48:51PM +0200, Pablo Neira Ayuso wrote:
> > On Mon, Jul 01, 2024 at 10:51:17PM +0200, Ben Hutchings wrote:
> > > On Thu, 2024-06-13 at 13:33 +0200, Greg Kroah-Hartman wrote:
> > > > 4.19-stable review patch.  If anyone has any objections, please let=
 me know.
> > > >=20
> > > > ------------------
> > > >=20
> > > > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > > >=20
> > > > commit c9e6978e2725a7d4b6cd23b2facd3f11422c0643 upstream.
> > > [...]
> > >=20
> > > This turns out to cause a regression for nftables user-space versions
> > > older than v0.9.3, specifically before:
> > >=20
> > > commit a4ec053812610400b7a9e6c060d8b7589dedd5b1
> > > Author: Pablo Neira Ayuso <pablo@netfilter.org>
> > > Date:   Wed Oct 9 11:54:32 2019 +0200
> > > =20
> > >     segtree: always close interval in non-anonymous sets
> >=20
> > This is really fixing up userspace as the commit describes, otherwise
> > incremental updates are not possible on a set/map.
> >=20
> > > Should nft_set_rbtree detect and fix-up the bad set messages that
> > > nftables user-space used to send?
> >=20
> > Problem is that a non-anonymous set really needs close intervals,
> > otherwise incremental updates on it are not possible.
> >=20
> > It should be possible to backport a fix for such nftables version.
> >=20
> > I can see Debian 10 (Buster, oldoldstable) is using 0.9.0 but it was
> > discontinued in june 2022? But who is using such an old userspace versi=
on?
>=20
> Oh, I misread, it is still supported in oldoldstable in Debian.

It is out of support in Debian from today.  But Freexian will maintain
a derivative of it (with selective updates, including a newer kernel
branch) for some time to come.

> Then, userspace really needs this fix, because incremental updates on
> a set are not really possible.
>=20
> I can take a look and send a backport of this for nftables 0.9.0.

Thank you!  I already tried cherry-picking just that commit, and that
seemed to fix the issue, but I didn't test anything else and I'm not at
all familiar with the code.

Ben.

--=20
Ben Hutchings
A free society is one where it is safe to be unpopular.
                                                      - Adlai Stevenson


--=-knXT3Og6EkDmvDngi0YR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmaDJ4wACgkQ57/I7JWG
EQnMsg/+Oxz9/rbFumw73f+u5TiUiP8FS/3iCsTalugzQPVE4RgDOfdWA6swNNzC
TUDj/u34GFn9s6NiJsbSxqHiK1rSWIwjx9ezGTKMBiWw52Tek4IgM/2U5OjISRoM
jvq8W8cloqhuGVGHnbg1WtUNJj0/ymn9anpuuqkmodLZY7fHg45vNwQcvehd0B5M
K56njRbZc2ROTWUgi65+CbYa8aeH3NhvtieM7R0GslrOHYkU/OtVBjP3zXYOAW6f
1kWa7s9flQnseRbg0lB2R7xghtw+xB1Xu/S4HuLAwmVs0yeBnkPL950XXMSnd6hX
+xHgjCCNslEjLvY42I2jYGY45SxexJctXumGeU7LynG+/bmGAHudG1ClDKpRYVvx
kJpbMDrVuGsYEkUZZP7NAtCBJuzoHsOh3t6ETK6a65e48KozpUGz1nn9xRr1i0Wi
5NQA5Cx0sO9/detpNoXcUj6JmAXFTFfa0760CK0lPfoao/gDsEJHPuryuMjat8FT
QqmMEodg7ifB3WyipUeFGbQslGsg63UlQnIuEuSGyroKCxY+1tK5vXHG70G+kJoO
/kulYYtbEa1b1qqLI1RS41et3ZvZmypVUsnLi41cYOroGCxPr6EMP9IUTuMHRzz9
j0K4CNwGWvimNqHCH+eqNtsRNovYnhE15RGdjpuk7CnHa0h1Z1U=
=CTi/
-----END PGP SIGNATURE-----

--=-knXT3Og6EkDmvDngi0YR--
