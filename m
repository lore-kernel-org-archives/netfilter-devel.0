From: Tim Waugh <twaugh@redhat.com>
Subject: Re: SNMP conntrack module a la netbios_ns
Date: Fri, 04 Dec 2009 16:58:22 +0000
Message-ID: <1259945902.2510.35.camel@localhost.localdomain>
References: <1259920389.2510.30.camel@localhost.localdomain>
	 <4B18E270.8090408@trash.net>  <4B18E2DD.1090405@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-9jG5/+1k4L+xKSSxobxY"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932190AbZLDQ6U (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Dec 2009 11:58:20 -0500
In-Reply-To: <4B18E2DD.1090405@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-9jG5/+1k4L+xKSSxobxY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-12-04 at 11:22 +0100, Patrick McHardy wrote:
> There is one problem however, we already have the SNMP NAT helper,
> which also registers for the SNMP port. Those would clash if you
> add a second registration.

Does that mean that even a simple copy of nf_conntrack_netbios_ns.c with
the port changed to 161 wouldn't work, or just that a more general
solution would be hard to implement?

What's the solution to that?  Must there be a single conntrack module to
handle both the SNMP broadcast queries and SNMP NAT?

Tim.
*/


--=-9jG5/+1k4L+xKSSxobxY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQBLGT+sBLQafZpK2tcRAiAjAKCVoYXRx0Q13TAXQQ6Nby2Tv3nKOACfbuzk
YKleDS7MFfjryb4EsZ/8+nQ=
=3c9B
-----END PGP SIGNATURE-----

--=-9jG5/+1k4L+xKSSxobxY--

