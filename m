From: Volker Sauer <volker@volker-sauer.de>
Subject: Re: Problem with new --physdev-out style
Date: Wed, 24 Oct 2007 14:57:19 +0200
Message-ID: <20071024125718.GA27909@volker-sauer.de>
References: <20071024071854.GA18581@volker-sauer.de> <471EF68A.702@trash.net> <471F00DC.9070001@snapgear.com> <471F03B1.3090909@trash.net> <471F0AD5.2050202@snapgear.com> <471F136D.6090907@trash.net> <20071024120622.GB27593@volker-sauer.de> <471F3F4B.80205@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Cc: Philip Craig <philipc@snapgear.com>, netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lnx131.hrz.tu-darmstadt.de ([130.83.174.25]:57358 "EHLO
	lnx131.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752624AbXJXM5t (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Oct 2007 08:57:49 -0400
Content-Disposition: inline
In-Reply-To: <471F3F4B.80205@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mi, 24 Okt 2007, Patrick McHardy <kaber@trash.net> wrote:
> >This means, that all rules like that are valid even with the new concept
> >of netfilter, right?? But why do I get error messages like quoted in my
> >first mail for these rules - it *is* bridged traffic inside *one*
> >bridge!
> >And: I don't see how --physdev-is-bridged should help, since it's a
> >match and not a command to the kernel saying: "this *is* bridged
> >traffic". It the kernel does not see this by itself,
> >--physdev-is-bridged doesn't help.
>=20
> Whether you believe it or not, this is the only way to tell
> the physdev match that the rule only affects purely bridged
> traffic.

Aah, now I get it! This way I can avoid the error message....
Great, I'll test it as soon as I'm back to the lab.=20

> Does not work since one of the devices might be put in a different
> bridge after you loaded the rules.

Yes, you're right.=20
Then the only solution is to improve the error messages.

> >If no, display a message like this:
> >
> >"physdev match: using --physdev-out in the FORWARD chains is only=20
> >allowed if all physical interfaces are members of the same bridge."
>=20
>=20
> Feel free to send a patch to improve the error messages.

Oh, I'll see if I can patch kernel 2.6.23.1.

Regards
Volker

--=20
  Volker Sauer  *  Poststrasse 1/601   *   64293 Darmstadt  *   Germany
  E-Mail/Jabber: volker(at)volker-sauer.de * http://www.volker-sauer.de
  PGPKey-Fingerprint: DB26 11C7 B12E 0B27 3999 2E4F 7E35 4E4D 5DD5 D0E0
  http://wwwkeys.de.pgp.net/pks/lookup?op=3Dget&search=3D0x7E354E4D5DD5D0E0=
=20

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHH0EufjVOTV3V0OARAsTdAJ9xqlwxLmRVncofPNMqEZenErCy8wCcDg42
/Mqmt3nUodBd+5THMvXk8sQ=
=5dU0
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
