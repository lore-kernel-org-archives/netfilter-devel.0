From: Harald Welte <laforge@netfilter.org>
Subject: Re: ctnetlink questions
Date: Mon, 20 Oct 2003 20:37:42 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031020183741.GB20288@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44.0310201133040.23768-100000@filer.marasystems.com> <3F942CB6.5060005@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="61jdw2sOBCFtR2d/"
Cc: Henrik Nordstrom <hno@marasystems.com>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3F942CB6.5060005@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 20, 2003 at 08:43:02PM +0200, Patrick McHardy wrote:

> >The dump operation should be connetion oriented with the userspace=20
> >application, not purely datagram based. The kernel should know for certa=
in=20
> >if the userspace application terminates a dump operation mid-air.
> >
>=20
> Actually the kernel knows. If the socket is closed cb->done() is called.
> However the kernel can not know if userspace still keeps the socket open
> but doesn't read anymore. Connection oriented sockets don't help with thi=
s.

yes, but if the application is broken, that's not our problem.  If the
API and the behaviour is documented, I don't see any problems with this.
If an app wants to intentionally allocate many opjects in kernel space,
there's nothing we can do.  Also, since we are sending to userspace, we
could actually allocate this as virtual memory, right?

> Best regards,
> Patrick

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--61jdw2sOBCFtR2d/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/lCt1XaXGVTD0i/8RAh/GAJsHK17Dx3yWiElNM89iniwUqGIutgCgn5CV
Z2ADTnFL4rJpI397WMY8bjg=
=6sYn
-----END PGP SIGNATURE-----

--61jdw2sOBCFtR2d/--
