From: Harald Welte <laforge@netfilter.org>
Subject: Re: NFCT ulogd pluging [was Re: [ULOGD RFC 11/30] NFCT: make
	reconfigurable]
Date: Wed, 30 Jan 2008 21:39:46 +0100
Message-ID: <20080130203946.GK5523@prithivi.gnumonks.org>
References: <20080130185847.693274384@kruemel.intranet.astaro.de> <20080130190127.847510508@kruemel.intranet.astaro.de> <47A0D063.7040807@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nhAUiXSLan16V5i8"
Cc: heitzenberger@astaro.com, netfilter-devel@vger.kernel.org,
	holger@eitzenberger.org, Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:59118 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757421AbYA3VMJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:12:09 -0500
Content-Disposition: inline
In-Reply-To: <47A0D063.7040807@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--nhAUiXSLan16V5i8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 30, 2008 at 08:30:43PM +0100, Pablo Neira Ayuso wrote:
> Hi,
>=20
> JFYI: conntrackd also does connection tracking accounting so I'm not
> sure if ulogd should do this as well via the NFCT plugin. This looks
> like duplicated effort IMO and, as for now, conntrackd also provides
> userspace conntrack table dumping without locking the kernel via
> `conntrackd -i' which is a feature that ulogd does not provide.
>=20
> I'm not sure if the effort is worth, Harald?

I think it is still worth having this in ulogd2, since ulogd2 is an
entire framework for all kinds of logging, including
input/filter/aggregator/output plugins where you can build IPFIX
compliant network-wide accounting/logging systems that are interoperable
with different vendors.

So conntrackd might be fine for the special case of locally logging into
a file or piping the output through some script.  But for all the more
sophisticated scenarios, ulogd2 is the solution of choice, I'd say.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--nhAUiXSLan16V5i8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHoOCSXaXGVTD0i/8RAvI4AJ0QjOq5LCExHbKAl8YRvaN9eMdxhgCgp5dr
qbXo57Mqk8SucR0XSZO+49I=
=x1Ef
-----END PGP SIGNATURE-----

--nhAUiXSLan16V5i8--
