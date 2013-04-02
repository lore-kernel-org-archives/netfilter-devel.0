From: Eric Leblond <eric@regit.org>
Subject: Re: How to modify conntrack accounting?
Date: Tue, 02 Apr 2013 22:46:34 +0200
Message-ID: <1364935594.30922.3.camel@ice-age.regit.org>
References: <515B2D5B.8010807@wildgooses.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-OZOe+/j0YkeDsckDsO3a"
Cc: netfilter-devel@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:49184 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762323Ab3DBUqm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Apr 2013 16:46:42 -0400
In-Reply-To: <515B2D5B.8010807@wildgooses.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-OZOe+/j0YkeDsckDsO3a
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hello,

Le mardi 02 avril 2013 =E0 20:11 +0100, Ed W a =E9crit :
> Hi, I have a requirement to account for "bytes I pay for" over some=20
> link, and conntrack very nearly gives me the right answer...  This link=
=20
> uses accounting somewhat like ATM, where the IP data is sliced into=20
> fixed size cells and you have to pay for the overhead per cell, plus the=
=20
> wasted space in the extra cell.

I'm not sure I really understood your ATM comparison but why not use the
new accounting system like described here:

https://home.regit.org/2012/07/flow-accounting-with-netfilter-and-ulogd2/


BR,

>=20
> I look at the latest kernel sources and all the packet size accounting=
=20
> seems to be performed in: nf_conntrack_core.c / __nf_ct_refresh_acct()=
=20
> and __nf_ct_kill_acct().
>=20
> I see several options:
>=20
> 1) Modify the accounting procedure in nf_conntrack_core.c so that=20
> certain connections will use a different accounting formula. However,=20
> how would I mark from userspace that a certain interface has this=20
> unusual accounting property?
>=20
> 2) Could/Should I produce a new netfilter module which operates per=20
> packet, looks up the connection object for a given packet, and then adds=
=20
> a "fudge" to the connection accounting number to correct for the effect=
=20
> of the odd packetisation? Presumably from userspace you would then=20
> simply create an iptables rule tagging packets out of a certain=20
> interface with "-m my_odd_accounting".
>=20
> I don't yet know how to build option 2), but it seems appealing (anyone=
=20
> got any consultancy time and want to bill me to build it?)
>=20
> I would appreciate feedback from those more knowledgeable? Given the=20
> small niche of the solution a modification to nf_conntrack_core.c is=20
> appealing, but I'm unsure how to indicate which are the peculiar=20
> interfaces, only userspace will know this.
>=20
> Thanks for your thoughts/hints
>=20
> Ed W
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=-OZOe+/j0YkeDsckDsO3a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQBRW0OqnxA7CdMWjzIRAts0AJ49udP9AtMgtoW6N+cen4WhFXlwsQCghuNo
6nooFDi6WN2pNPsfqWb4SKg=
=rXo+
-----END PGP SIGNATURE-----

--=-OZOe+/j0YkeDsckDsO3a--

