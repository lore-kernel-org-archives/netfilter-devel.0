From: Harald Welte <laforge@netfilter.org>
Subject: Re: Inbound packet buffering
Date: Wed, 21 Jan 2004 09:22:39 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040121142239.GW8642@obroa-skai.de.gnumonks.org>
References: <20040119143454.34247.qmail@web11610.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M2Pxvdb9QxnGd/3e"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Doug SC <dougsc@yahoo.com>
Content-Disposition: inline
In-Reply-To: <20040119143454.34247.qmail@web11610.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--M2Pxvdb9QxnGd/3e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 19, 2004 at 06:34:54AM -0800, Doug SC wrote:
> Good Morning.
>=20
> I have a kernel driver which has registered for
> inbound packets.
>=20
> nf_register_hook(...NF_IP_PRE_ROUTING...)
>=20
> I am looking to take action on certain UDP ports on
> packets which may exceed MTU.  I see the fragmented
> packets at this hook and since I can't be certain of
> the order of receipt I need to buffer packets until I
> receive the fragment which contains the ports.
>=20
> Once I can see the port I may want to send all the
> packets I have buffered plus the one that allowed me
> to make the decision.

please look at the implementation of ip_queue.c and it's use of
nf_reinject().  It should provide a good example of exactly what you want t=
o do.

> Thanks

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--M2Pxvdb9QxnGd/3e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFADosvXaXGVTD0i/8RAihbAKC0wCUqdIYaIVwGbVOZSNG0mosB9gCfep3p
7Nyyfc6s0cn9Yszo5r0Qum8=
=eUHP
-----END PGP SIGNATURE-----

--M2Pxvdb9QxnGd/3e--
