From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [RESEND] [PATCH] Additional Check to Unclean module
Date: Tue, 14 Jan 2003 18:05:31 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030114170531.GE18686@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.21.0208062014170.20336-200000@dns.toxicfilms.tv> <Pine.LNX.4.21.0208081943090.6794-200000@dns.toxicfilms.tv> <20030114163725.GD18686@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="osDK9TLjxFScVI/L"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>,
	netfilter-devel@lists.samba.org
Content-Disposition: inline
In-Reply-To: <20030114163725.GD18686@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--osDK9TLjxFScVI/L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 14, 2003 at 05:37:25PM +0100, Harald Welte wrote:

> > > plain and simple, this adds a check that looks for invalid
> > > ip version field in the ip header.
> > > Some tools generate these packets.
> > > isic does.
>=20
> Sorry for this late reply, but I'm trying to get all of this stuff
> cleaned up now...
>=20
> Putting it into pending right now.
=20
erm, no need for this patch.  The IP version is already checked in the
core IPv4 stack, and ip_tables would never receive a non-ipv4 packet
anyway.

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--osDK9TLjxFScVI/L
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+JENbXaXGVTD0i/8RAhMCAJ9cZ11Kctb7OT1oPEQ53JY3feYxVgCfXWX7
QFZpyIJz6h9slnjceRjnsg4=
=YWTu
-----END PGP SIGNATURE-----

--osDK9TLjxFScVI/L--
