From: Harald Welte <laforge@netfilter.org>
Subject: Re: writing a fragmentation-needed patch
Date: Mon, 31 Mar 2003 14:26:55 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030331122654.GM7718@sunbeam.de.gnumonks.org>
References: <3E85D60D.7040304@rtij.nl> <20030330093514.GA1098@oknodo.bof.de> <3E86C399.7020209@rtij.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h3BncCmUfYp8450W"
Cc: Patrick Schaaf <bof@bof.de>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martijn Lievaart <m@rtij.nl>
Content-Disposition: inline
In-Reply-To: <3E86C399.7020209@rtij.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--h3BncCmUfYp8450W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 30, 2003 at 12:14:49PM +0200, Martijn Lievaart wrote:

> >- why is it a patch against REJECT, instead of a standalone target?
>=20
> Because it feels (felt) right. It's the only subtype of=20
> icmp-dest-unreach that is not handled in REJECT.

Please re-read the whole discussion about reject-with-type-13.

We _cannot_ change the structure layout/valid value ranges/etc of any
target in the stable kernel series.  We always need to make sure
backwards- and forwards-compatibility between old/new kernel and old/new
iptables userspace.

> What do you think?

I think the solution is to create an ICMP target, which has the
parameters 'icmp type' and 'icmp code', where the kernel would accept
any values.  detecting invalid icmp code/types should be done in  the
libipt_ICMP.c userspace plugin.

> Martijn Lievaart

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--h3BncCmUfYp8450W
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+iDQOXaXGVTD0i/8RAsw4AJ4wyZXXNVluulj/Av1mWzKiDyPmVgCgtKC9
A1VRzHEvsLJrOCbH7yDFWQE=
=3/w8
-----END PGP SIGNATURE-----

--h3BncCmUfYp8450W--
