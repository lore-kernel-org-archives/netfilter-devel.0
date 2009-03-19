From: Soren Hansen <soren@ubuntu.com>
Subject: Re: Automatically load modules in iptables-save
Date: Thu, 19 Mar 2009 14:50:06 +0100
Message-ID: <20090319135006.GD20472@ralph.linux2go.dk>
References: <20090316171014.GG31952@ralph.linux2go.dk> <20090319125532.GC20472@ralph.linux2go.dk> <49C24332.2020107@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wLAMOaPNJ0fu1fTG"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from atlas.linux2go.dk ([88.198.22.52]:53684 "EHLO atlas.linux2go.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757572AbZCSNuR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Mar 2009 09:50:17 -0400
Content-Disposition: inline
In-Reply-To: <49C24332.2020107@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--wLAMOaPNJ0fu1fTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 19, 2009 at 02:05:54PM +0100, Patrick McHardy wrote:
>>> If the iptables modules are not loaded when iptables-save is run,
>>> iptables-save will fail, because it can't open the relevant files in
>>> /proc.  This patch makes iptables-save attempt to load the modules,
>>> and then retries.
>> Is this the correct list for this?
> It is. The patch seems rather pointless though, if the module isn't
> loaded, there's obviously nothing to save.

Right. I thought about just silently bailing out, but decided to go this
route instead. Explanation follows.

>> If the iptables modules are not loaded when iptables-save is run,
>> iptables-save will fail
> What does "fail" mean in this context?

$ sudo iptables-save
iptables-save v1.4.1.1: Unable to open /proc/net/ip_tables_names: No such f=
ile or directory
$ echo $?
1

I decided to try to load the modules instead of just silently returning,
so that if iptables-save succeeds, you can reasonably expect
iptables-restore to work as well. I would be quite surprised if I found
that the firewall rules I just saved (perhaps not realising that there
weren't any) coulnd't be loaded again, which is what you'd get if your
system had no iptables support at all.

--=20
Soren Hansen                 |=20
Lead Virtualisation Engineer | Ubuntu Server Team
Canonical Ltd.               | http://www.ubuntu.com/

--wLAMOaPNJ0fu1fTG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAknCTY0ACgkQo+Mz6+DAzGxEMgP/VQTGVEKs/BhxfElt0P8V70LI
kC6MCjVuKkGLM5QVoOXW685PQ7SAFCM8oxDk3jHTzDqly/qraTW9OnMl8ChplxaM
3SKjyQBuQLOiCaf+A4+JeC4ylQGicpT9OJkOcqetc8OV5ETaNcCowPK9Glm5o6Rs
f0XdYmcUREClM8DwdDQ=
=JBKL
-----END PGP SIGNATURE-----

--wLAMOaPNJ0fu1fTG--
