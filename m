From: Harald Welte <laforge@netfilter.org>
Subject: Re: New standalone nat helper module which help function is never called
Date: Tue, 18 Nov 2003 17:59:04 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031118165904.GQ5075@sunbeam.de.gnumonks.org>
References: <20031117174829.711e2e82.tuxit@netcourrier.com> <20031117223129.GF5075@sunbeam.de.gnumonks.org> <20031118005846.06befa0d.tuxit@netcourrier.com> <20031118004931.GH5075@sunbeam.de.gnumonks.org> <20031118100449.4815515b.tuxit@netcourrier.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jIYo0VRlfdMI9fLa"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: tuXit <tuxit@netcourrier.com>
Content-Disposition: inline
In-Reply-To: <20031118100449.4815515b.tuxit@netcourrier.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--jIYo0VRlfdMI9fLa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2003 at 10:04:49AM +0100, tuXit wrote:
> On Tue, 18 Nov 2003 01:49:31 +0100
> Harald Welte <laforge@netfilter.org> wrote:
>=20
> > On Tue, Nov 18, 2003 at 12:58:46AM +0100, tuXit wrote:
> > > 	ascii.flags =3D IP_NAT_HELPER_F_STANDALONE;
> >=20
> > you are missing IP_NAT_HELPER_F_ALWAYS here.  otherwise a nat helper
> > will only be called if a connection tracking helper has issued an
> > expectation within that packet.
>=20
> That's true; I added this flag so now, I have :
> ascii.flags =3D IP_NAT_HELPER_F_STANDALONE + IP_NAT_HELPER_F_ALWAYS;
> I also changed=20
> char ascii_names[10];
> that was in my previous post from the function=20
> __init=20
> outside of it (because it is in the stack, so deleted whenever this funct=
ion
> is finished).
>
> But it still doesn't help.=20

Flags in a bitmask have to be bit-wise or'ed
(IP_NAT_HELPER_F_STANDALONE|IP_NAT_HELPER_F_ALWAYS).  Please see the
existing code.

> Florian Pouradier

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--jIYo0VRlfdMI9fLa
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/uk/YXaXGVTD0i/8RAmAiAJ9gfjVK71W+nl19o7GuzwPlHXzA+QCeMheo
7DRVBK+FLYH3lB/Mg8Gp6o8=
=oZDF
-----END PGP SIGNATURE-----

--jIYo0VRlfdMI9fLa--
