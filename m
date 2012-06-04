From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: status of ulogd2 package
Date: Mon, 4 Jun 2012 14:25:14 +0200
Message-ID: <20120604122514.GI13093@pcnci2.linuxbox.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tcC6YSqBgqqkz7Sb"
Cc: nikola.ciprich@linuxbox.cz,
	Stanislav Schattke <schattke@linuxbox.cz>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gwu.lbox.cz ([62.245.111.132]:35496 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760423Ab2FDMbw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jun 2012 08:31:52 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--tcC6YSqBgqqkz7Sb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Greeting to all netfilter developers!

I'd like to ask about the status of ulogd2 package.
we're using ULOGD for all our firewalls, but
1) I see deprecation warning for CONFIG_IP_NF_TARGET_ULOG in newer
kernels
2) we need to log IPv6 stuff

Therefore we started testing ulogd2 some time ago, and it works pretty
well for us. But on netfilter webpage, there is warning that for production=
, ulogd1 should
be used.

My question is, is there a plan for releasing stable version in near future?
I see beta4 was tagged in git almost 2 years ago, since then, there's been =
some
activity but code seems quite stable to me.
Are there some remaining blockers? If not, could I maybe
suggest "Release early, Release often" policy? :)

thanks in advance for reply

BR

nik





--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28.rijna 168, 709 00 Ostrava

tel.:   +420 591 166 214
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--tcC6YSqBgqqkz7Sb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAk/MqSoACgkQ3xdJJrLygV4zHgCglLJyS2RL2E2h28wwcwdENyko
WakAoOOy0IJWZdAhDgSSUZrclZX1KJjG
=K8a1
-----END PGP SIGNATURE-----

--tcC6YSqBgqqkz7Sb--
