From: Harald Welte <laforge@netfilter.org>
Subject: Re: Netbios problem with NAT
Date: Wed, 23 Jul 2003 14:15:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030723121512.GL3733@naboo>
References: <BAY5-F38OUbYAGeZNeH00001598@hotmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="it/zdz3K1bH9Y8/E"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Song Wang <song_wang@msn.com>
Content-Disposition: inline
In-Reply-To: <BAY5-F38OUbYAGeZNeH00001598@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--it/zdz3K1bH9Y8/E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 22, 2003 at 12:00:25AM -0700, Song Wang wrote:
> Hi,
>=20
> I found a problem with netbios when 2 Windows PCs behind a NAT router try=
=20
> to access the same shared directory on the Windows server sitting on
> the other side of the NAT router.  (kernel 2.4.17 w/ iptables 1.2.7a)

why did you ever think that this would work?  Even the microsoft
knowledge base contains an article that you'd need some kind of special
NAT support for it, in order to mangle the contents of the netbios
packets.

> Could this be a problem of netbios with connection tracking? Maybe we nee=
d=20
> to write a nat helper module for netbios?

yes, indeed. A nat helper would be required.  Patches welcome.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--it/zdz3K1bH9Y8/E
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/HnxPXaXGVTD0i/8RAsFpAJ9CB5WrKUO9ZMSgMkUAxAWmYuQn0wCgiGUz
UoX/yfPJO0oJNXPbVzVBPIA=
=m335
-----END PGP SIGNATURE-----

--it/zdz3K1bH9Y8/E--
