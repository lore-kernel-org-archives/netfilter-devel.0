From: Eric Leblond <eric@inl.fr>
Subject: Re: ulogd2 commit
Date: Sat, 18 Apr 2009 13:58:05 +0200
Message-ID: <1240055885.10215.27.camel@ice-age>
References: <49E85F6D.9030008@netfilter.org>
	 <1240053470.10215.16.camel@ice-age>  <49E9BCFD.80102@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UrHTD8XNr0Pf0md6JzmW"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Pierre Chifflier <chifflier@inl.fr>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([91.121.73.151]:41177 "EHLO
	ks301150.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbZDRL63 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Apr 2009 07:58:29 -0400
In-Reply-To: <49E9BCFD.80102@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-UrHTD8XNr0Pf0md6JzmW
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Le samedi 18 avril 2009 =E0 13:43 +0200, Pablo Neira Ayuso a =E9crit :
> Eric Leblond wrote:
> > Hi,
> >=20
> > Le vendredi 17 avril 2009 =E0 12:52 +0200, Pablo Neira Ayuso a =E9crit =
:
> >>=20

...

> 1) Looking at my ulogd2 installation, this exports a lot of header files
> for external use:
>=20
> $ ls /usr/include/ulogd/
> common.h    hash.h            jhash.h      linux_rbtree.h  timer.h
> conffile.h  ipfix_protocol.h  linuxlist.h  slist.h         ulogd.h
>=20
> Sorry, but this is a bit nasty. If this patch aims to allow compiling
> external ulogd2 module,  please make public only the basic functions
> (register, unregister, ...) in one header public file called ulogd.h or
> something like that. But not exporting all those jhash.h, linux_rbtree.h
> and so on.

Your point is correct...

> 2) Related to the previous point, if we make public some API, we'll have
> to get attached to them to ensure backward compatibility. If we support
> external modules, we'll have to engage to not changing the exported API,
> otherwise people may complain about breakages of their external modules.
> All those files that you have exported means quite a lot APIs that we'll
> have to get attached to.


This is not what I was trying to do. The only goal was compilation
outside of tree. Target was not to provide a complete and fixed plugin
infrastructure. In this case, a clean and stable API is really needed.=20

> I have my concerns with regards to this patch from both the technical
> approach and the new policy that it introduces.

I agree for a revert of this commit. I can push it if you want.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--=-UrHTD8XNr0Pf0md6JzmW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Ceci est une partie de message
 =?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJ6cBKnxA7CdMWjzIRAmwSAJ9G4OsVxsF+jRULVYtOdq/w3NSyNQCfRV8G
J4dvFGjPulNWuKi7Y1WuwzE=
=lCjv
-----END PGP SIGNATURE-----

--=-UrHTD8XNr0Pf0md6JzmW--

