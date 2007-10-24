From: Volker Sauer <volker@volker-sauer.de>
Subject: Re: Problem with new --physdev-out style
Date: Wed, 24 Oct 2007 17:18:50 +0200
Message-ID: <20071024151850.GA7153@volker-sauer.de>
References: <20071024071854.GA18581@volker-sauer.de> <471EF68A.702@trash.net> <471F00DC.9070001@snapgear.com> <471F03B1.3090909@trash.net> <471F0AD5.2050202@snapgear.com> <471F136D.6090907@trash.net> <20071024120622.GB27593@volker-sauer.de> <471F528D.8000501@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lnx131.hrz.tu-darmstadt.de ([130.83.174.25]:45908 "EHLO
	lnx131.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754056AbXJXPTF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Oct 2007 11:19:05 -0400
Content-Disposition: inline
In-Reply-To: <471F528D.8000501@plouf.fr.eu.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mi, 24 Okt 2007, Pascal Hambourg <pascal.mail@plouf.fr.eu.org> wrote:
> As Patrick said, that condition may change over time. I like to have all =
my=20
> ruleset loaded before the network is configured, even before some interfa=
ces=20
> exist. Your proposed change would prevent it. Besides, my opinion is that=
 it=20
> is not the job of iptables to do such checks.

Agreed.

>
>> If yes, accept the rule, because then it is
>> allowed to use it!!!  (Which is the case all the thousands of rules in
>> my firewalls except the 5 that I sent to this list :-().
>> If no, display a message like this:
>> "physdev match: using --physdev-out in the FORWARD chains is only allowe=
d=20
>> if all physical interfaces are members of the same bridge."
>
> This is wrong and inacurate. Using --physdev-out in the FORWARD and=20
> POSTROUTING chains is supported for *bridged* traffic only, period. All=
=20
> physical interfaces being members of the same bridge is not a sufficient=
=20
> condition to make sure that only bridged traffic will be matched. Traffic=
=20
> can still be routed from a bridge to itself.

Yes, it is inacurate.
But I think one needs a better explenation. I'm a power-user but still a
user, not a developer. Users think in different terms and speak another
language.=20
Maybe an advice like "look for the option "--physdev-is-bridged" - it
may help you" or so would be good.

--=20
  Volker Sauer  *  Poststrasse 1/601   *   64293 Darmstadt  *   Germany
  E-Mail/Jabber: volker(at)volker-sauer.de * http://www.volker-sauer.de
  PGPKey-Fingerprint: DB26 11C7 B12E 0B27 3999 2E4F 7E35 4E4D 5DD5 D0E0
  http://wwwkeys.de.pgp.net/pks/lookup?op=3Dget&search=3D0x7E354E4D5DD5D0E0=
=20

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHH2JZfjVOTV3V0OARAoeoAKCSqobgcrGAa+jwE3MdANWBl8HCPQCg6X4n
Ft5CESoRy5o2gSFte9x4Css=
=GEiB
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
