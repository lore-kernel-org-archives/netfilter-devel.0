From: Harald Welte <laforge@gnumonks.org>
Subject: Re: ICMP match bug
Date: Mon, 3 Feb 2003 14:52:18 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030203135218.GY27870@sunbeam.de.gnumonks.org>
References: <20030127140143.GA29965@balabit.hu> <20030127173937.GB31017@balabit.hu> <20030131120016.GY9073@naboo.cybercafe42> <20030203132020.GB17330@balabit.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dex7YdYhTh9daYX7"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Balazs Scheidler <bazsi@balabit.hu>
Content-Disposition: inline
In-Reply-To: <20030203132020.GB17330@balabit.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Dex7YdYhTh9daYX7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 03, 2003 at 02:20:20PM +0100, Balazs Scheidler wrote:
> Option 1) could be implemented without changing the size of the match
> struct, the other two would involve changing the size of the match struct.
>=20
> I've checked the kernel source, specifying -1 for old kernels would mean
> 'match nothing', thus our beloved compatibility equations would be like
> this:
>=20
> 1) old kernel - new iptables
>=20
> when ANY icmp type is specified, no packets would be matched, this is
> different from the current behaviour when icmp type 0 is matched (PONG).
>=20
> when a usual icmp type is specified everything works correctly.
>=20
> 2) new kernel - old iptables
>=20
> no problem.
>=20
> The question is whether we can live with the incompatibility of matching
> nothing instead of PONG when no --icmp-type is specified.

yes, this is perfectly fine.  matching 'pong' when no icmp-type is
specified was never advertised as a feature.  It's a misbehaviour which
is now going to be corrected.  We should document this change at least
in bugzilla (i.e. submit a bug report, and document the change to CVS)

Do you want to send me a patch?

Thanks.

> Bazsi

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--Dex7YdYhTh9daYX7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+PnQSXaXGVTD0i/8RAgcdAJ4oZu3+Hx4M4V6ljEZK98CEQbRAywCdE6u1
6qdaT7o4OUDGrjWWntvDoU0=
=OIy3
-----END PGP SIGNATURE-----

--Dex7YdYhTh9daYX7--
