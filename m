From: Soren Hansen <soren@ubuntu.com>
Subject: Re: Automatically load modules in iptables-save
Date: Thu, 19 Mar 2009 15:29:35 +0100
Message-ID: <20090319142935.GE20472@ralph.linux2go.dk>
References: <20090316171014.GG31952@ralph.linux2go.dk> <20090319125532.GC20472@ralph.linux2go.dk> <49C24332.2020107@trash.net> <20090319135006.GD20472@ralph.linux2go.dk> <alpine.LSU.2.00.0903191452550.27642@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/2994txjAzEdQwm5"
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from atlas.linux2go.dk ([88.198.22.52]:36665 "EHLO atlas.linux2go.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737AbZCSOaE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Mar 2009 10:30:04 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0903191452550.27642@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--/2994txjAzEdQwm5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 19, 2009 at 02:55:54PM +0100, Jan Engelhardt wrote:
>>I decided to try to load the modules instead of just silently returning,
> IMHO, it should not fail, not even silently, but return success.
[..]
> If x_tables.ko is not loaded, there cannot be any tables active
> anyway, and thus would be equal to a loaded x_tables.ko with
> no table modules (iptable_filter, etc.) loaded.
>=20
> >so that if iptables-save succeeds, you can reasonably expect
> >iptables-restore to work as well.
>=20
> `echo '' | iptables-restore` does work.

Hrm. You appear to be right. I somehow thought that iptables-restore
would unconditionally try to load x_tables.ko.

> One more reason to make iptables-save not outputting anything
> returning 0.

That makes sense.

How about the case where someone calls "iptables-save -t foo"? Should
that just return an empty string and exit(0), should it attempt module
load to see if that's even a valid table or something entirely
different?

--=20
Soren Hansen                 |=20
Lead Virtualisation Engineer | Ubuntu Server Team
Canonical Ltd.               | http://www.ubuntu.com/

--/2994txjAzEdQwm5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAknCVs4ACgkQo+Mz6+DAzGzSWQP+Oz8k9Lgfmt59heTR+kHtlKDO
PKAcp3pZgTnNsVrFFrRqSXnbaeNKa0oW+tIBKQTpJUtHw5CLDwvsangcdQ/aD7/z
/XfPp8r/62uLbtDqUzBiNGu++zxV8c33B7XAvI7p/LlzbXUq/B47AfAV7+PKuDB8
kF6tm/y4IrzYUhrakt0=
=/xVm
-----END PGP SIGNATURE-----

--/2994txjAzEdQwm5--
