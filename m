From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH v2] ulogd: Implement PID file writing
Date: Sun, 19 May 2013 21:19:38 +0200
Message-ID: <1368991178.14976.4.camel@ice-age.regit.org>
References: <518F761E.8050701@bootc.net>
	 <1368362860-33843-1-git-send-email-bootc@bootc.net>
	 <5195DD43.50608@bootc.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-KO4UwFzInhFveBupZ3Un"
Cc: netfilter-devel@vger.kernel.org
To: Chris Boot <bootc@bootc.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:48066 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab3ESTUq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 May 2013 15:20:46 -0400
In-Reply-To: <5195DD43.50608@bootc.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-KO4UwFzInhFveBupZ3Un
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Le vendredi 17 mai 2013 =E0 08:33 +0100, Chris Boot a =E9crit :
> On 12/05/13 13:47, Chris Boot wrote:
> > The deamon currently does not have the ability to write a PID file to t=
rack its
> > process ID. This is very useful to an init script and to ensure there i=
s only
> > one running instance. This patch implements this functionality.
> >
> > Signed-off-by: Chris Boot <bootc@bootc.net>

I've applied this patch to my tree and made incremental modification to
fix some issues as explained in the upcoming patch.

BR,
--
Eric

--=-KO4UwFzInhFveBupZ3Un
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQBRmSXKnxA7CdMWjzIRAuldAJ4gpE6KU7ijOfYtPmwpGtjbofUA9wCdHWC2
Pjx9gKkR0ZAha3URx+Xa6Mw=
=k+H7
-----END PGP SIGNATURE-----

--=-KO4UwFzInhFveBupZ3Un--

