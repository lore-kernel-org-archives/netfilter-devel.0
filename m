From: Eric Leblond <eric@regit.org>
Subject: Re: [nftables PATCH 3/4] Update chain creation format.
Date: Mon, 16 Sep 2013 23:04:48 +0200
Message-ID: <1379365488.5155.43.camel@ice-age.regit.org>
References: <1379348858-29187-1-git-send-email-eric@regit.org>
	 <1379348858-29187-4-git-send-email-eric@regit.org>
	 <20130916202144.GE9713@breakpoint.cc>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-I7tpNHQwTuI/9ysK7lOr"
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:38734 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab3IPVGC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Sep 2013 17:06:02 -0400
In-Reply-To: <20130916202144.GE9713@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-I7tpNHQwTuI/9ysK7lOr
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Le lundi 16 septembre 2013 =E0 22:21 +0200, Florian Westphal a =E9crit :
> Eric Leblond <eric@regit.org> wrote:
> > type keyword is now mandatory when creating a new chain. This
> > patc halso implement the change required following the usage of human
> > notation in hook.
>=20
> > diff --git a/files/nftables/bridge-filter b/files/nftables/bridge-filte=
r
> > index ca306d4..6ed303e 100644
> > --- a/files/nftables/bridge-filter
> > +++ b/files/nftables/bridge-filter
> > @@ -1,7 +1,7 @@
> >  #! nft -f
> > =20
> >  table bridge filter {
> > -	chain input		{ hook NF_INET_LOCAL_IN		-200; }
> > -	chain forward		{ hook NF_INET_FORWARD		-200; }
> > -	chain output		{ hook NF_INET_LOCAL_OUT	200; }
> > +	chain input		{ table filter hook input priority -200; }
> > +	chain forward		{ table filter hook forward priority -200; }
> > +	chain output		{ table filter hook output priority 200; }
> >  }
>=20
> Did you mean 'type filter' instead of 'table' here?

Argh! (Banging head on the desk) Yes, good catch.

BR,
--
Eric

--=-I7tpNHQwTuI/9ysK7lOr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iD8DBQBSN3JwnxA7CdMWjzIRAlq4AJ9558aYEDw/aWgZsTuyuCNWLe6T5ACcDW2M
5MQOiV5HZpaIyGvrUBIv7g8=
=nTM6
-----END PGP SIGNATURE-----

--=-I7tpNHQwTuI/9ysK7lOr--

