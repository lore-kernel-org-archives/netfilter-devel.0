From: Harald Welte <laforge@netfilter.org>
Subject: Re: nf_conntrack: state or conntrack match with ipv6?
Date: Sat, 12 Nov 2005 11:40:21 +0100
Message-ID: <20051112104020.GH10584@sunbeam.de.gnumonks.org>
References: <43749F24.4000705@fliegl.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NTDLp0XeCpa8ZytR"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Deti Fliegl <deti@fliegl.de>
Content-Disposition: inline
In-Reply-To: <43749F24.4000705@fliegl.de>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--NTDLp0XeCpa8ZytR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 11, 2005 at 02:39:48PM +0100, Deti Fliegl wrote:
> Hi there,
>=20
> is there any state or conntrack match extension supported with nf_conntra=
ck on ipv6?

not in the mainline kenrel yet, but in the x_tables branch of my git
tree.  Unfortunately this will probably be 2.6.16 :(

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--NTDLp0XeCpa8ZytR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDdcaUXaXGVTD0i/8RAn26AKCLLuzTV8Qat7aZptkHysxBIdcLFwCeKui3
IdBSVJqre/nTQ/j8PezStNI=
=Ez2H
-----END PGP SIGNATURE-----

--NTDLp0XeCpa8ZytR--
