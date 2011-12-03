From: Eric Leblond <eric@regit.org>
Subject: Re: doc: Secure use of iptables and connection tracking helpers
Date: Sat, 03 Dec 2011 14:46:06 +0100
Message-ID: <1322919966.2568.5.camel@ice-age.regit.org>
References: <1322501576.20587.22.camel@tiger.regit.org>
			 <1322906769.8042.4.camel@hakkenden.homenet>
		 <1322911416.603.2.camel@ice-age.regit.org>
		 <4EDA1BE9.4060703@googlemail.com>
	 <1322917503.2568.2.camel@ice-age.regit.org>
	 <4EDA2715.7030006@googlemail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-W5L7O5HAgJjLK4TuAYAT"
Cc: "Nikolay S." <nowhere@hakkenden.ath.cx>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	kaber@trash.net
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:37467 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab1LCNqM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 Dec 2011 08:46:12 -0500
In-Reply-To: <4EDA2715.7030006@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-W5L7O5HAgJjLK4TuAYAT
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hello,

Le samedi 03 d=E9cembre 2011 =E0 13:41 +0000, Mr Dash Four a =E9crit :
> >>> Really good catch, I've published an update.
> >>>  =20
> >>>      =20
> >> I don't want to be seen as "picky", but there is a spelling mistake at=
=20
> >>    =20
> >
> > no problem with that.
> >  =20
> OK then (you asked for it :-P ):
>=20
> p.1 "but it is stored in a separate table and as generally a limited=20
> duration" ("as" should be "has")
> p.2 "conjonction" should be "conjunction"
> p.2 "If your clients are authorized to access to FTP outside of your=20
> network you can add" should be "If your clients are authorized to access=
=20
> FTP outside of your network you can add"
...
> p.6 "and have eth0 the interface with the default route" should be "and=
=20
> have the eth0 interface with a default route"
> p.6 "antispoofing with the following rules" should be "anti-spoofing=20
> with the following rules:"

Most of them have been fixed by Jan, I will have a cautious look.

> >> the 3rd line on the very first page of this document - "negociate"=20
> >> should be "negotiate". It is worth running a spell-checker on this=20
> >> entire document though - just in case I've missed something. ;-)
> >>    =20
> >
> > It seems your document is outdated. If not please tell me where you've
> > got it. And all my apologies for the spelling mistake in first version.
> >  =20
> I've just downloaded it from the link in your previous post/reply:=20
> http://home.regit.org/wp-content/uploads/2011/11/helper-recommandation.pd=
f

Arghh, the only one link I did not update after the renaming of the
file:
http://home.regit.org/wp-content/uploads/2011/11/secure-conntrack-helpers.p=
df

I'm hidding...

BR,
--
Eric

--=-W5L7O5HAgJjLK4TuAYAT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQBO2igenxA7CdMWjzIRAuBGAJ0T1WHhAeNLdsKEaA69YFcSZnrUhACeNy/c
lRWKw9NPRz8kp7gKyGFW3RQ=
=h5SZ
-----END PGP SIGNATURE-----

--=-W5L7O5HAgJjLK4TuAYAT--

