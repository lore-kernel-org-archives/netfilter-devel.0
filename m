From: Harald Welte <laforge@netfilter.org>
Subject: Re: ICMP DNAT bug fix no longer applies?
Date: Sun, 27 Apr 2003 15:20:39 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030427132039.GN990@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44.0304241412470.24242-100000@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rdbbj4JunmnVtKq/"
Cc: netfilter-devel@lists.netfilter.org,
	John McEleney <john@netservers.co.uk>,
	Philippe Biondi <biondi@cartel-securite.fr>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Wilson <chris@netservers.co.uk>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0304241412470.24242-100000@localhost>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--rdbbj4JunmnVtKq/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2003 at 02:34:11PM +0100, Chris Wilson wrote:
> Hi all,
>=20
> Since the ICMP DNAT advisory came out last year
> [http://www.iptables.org/security/2002-04-02-icmp-dnat.html], we have bee=
n=20
> applying this patch to all kernels we build. However, in between=20
> patch-o-matic 20030107 and 20030422 this has been broken and no longer=20
> applies.

This is becaue this bug should now finally have disappeared from all
future kernels ;)

> Does anyone know why the DNAT bug fix hasn't been incorporated into=20
> the main codebase yet?

The reason was that the solution at that time was too intrusive into the
core ipv4 stack to be applied by David Miller.

What we now have is a probably unclean solution, that mangles the same
stuff in a packet twice :(  But this was necessarry for yet another
number of ICMP NAT bugs (see bugzilla)

> Cheers, Chris.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--rdbbj4JunmnVtKq/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+q9knXaXGVTD0i/8RAsYZAJ49josNODeYRJdspoOitU+rXYYrogCglJXs
CL5aQanJjonslknfCN2+2g8=
=KJav
-----END PGP SIGNATURE-----

--rdbbj4JunmnVtKq/--
