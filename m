From: Harald Welte <laforge@netfilter.org>
Subject: Re: New standalone nat helper module which help function is never called
Date: Tue, 18 Nov 2003 01:49:31 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031118004931.GH5075@sunbeam.de.gnumonks.org>
References: <20031117174829.711e2e82.tuxit@netcourrier.com> <20031117223129.GF5075@sunbeam.de.gnumonks.org> <20031118005846.06befa0d.tuxit@netcourrier.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8bBEDOJVaa9YlTAt"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: tuXit <tuxit@netcourrier.com>
Content-Disposition: inline
In-Reply-To: <20031118005846.06befa0d.tuxit@netcourrier.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--8bBEDOJVaa9YlTAt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2003 at 12:58:46AM +0100, tuXit wrote:
> 	ascii.flags =3D IP_NAT_HELPER_F_STANDALONE;

you are missing IP_NAT_HELPER_F_ALWAYS here.  otherwise a nat helper
will only be called if a connection tracking helper has issued an
expectation within that packet.

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

--8bBEDOJVaa9YlTAt
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/uWybXaXGVTD0i/8RAm8eAJ0RDvLPVDOcAZW2LYPapNRvOLeMxwCePuqS
axQ2GN/ZK13h0vGHn45SkgU=
=arVs
-----END PGP SIGNATURE-----

--8bBEDOJVaa9YlTAt--
