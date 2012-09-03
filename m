From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH] pgsql: add SSL connection implementation to PGSQL plugin
Date: Mon, 03 Sep 2012 08:33:17 +0200
Message-ID: <1346653997.5194.37.camel@tiger.regit.org>
References: <1346503911-3781-1-git-send-email-mr.dash.four@googlemail.com>
	 <20120902233228.GA22069@1984> <50440A1B.7060908@googlemail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Q+d8sZDV8Qo331UgS7YW"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:43745 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab2ICGes (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Sep 2012 02:34:48 -0400
In-Reply-To: <50440A1B.7060908@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-Q+d8sZDV8Qo331UgS7YW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Le lundi 03 septembre 2012 =C3=A0 02:38 +0100, Mr Dash Four a =C3=A9crit :
> > I won't take a patch that fixes a NULL pointer dereference and adds a
> > new feature.
> >=20
> > Please, split this in two patches. First fix the bug, then add the new
> > fature.
> Sure. Are there any (other) objections to the patch I submitted?

I've applied the current patch to give it a run. And it shows a lot of
whitespace errors. You'll need to fix it too.

BR,
--=20
Eric Leblond=20
Blog: http://home.regit.org/ - Portfolio: http://regit.500px.com/

--=-Q+d8sZDV8Qo331UgS7YW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlBETy0ACgkQnxA7CdMWjzL3/QCeL3AJv74hccdCXPbzFUz6U6n3
YOMAn3WZoaSNMuwJCevmo1e8HotErQFW
=SwjU
-----END PGP SIGNATURE-----

--=-Q+d8sZDV8Qo331UgS7YW--

