From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] resync ipt_cluster structure
Date: Thu, 5 May 2005 22:12:34 +0200
Message-ID: <20050505201234.GB30482@sunbeam.de.gnumonks.org>
References: <427A47CF.8080904@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QYbTd+PSDu6P6/0L"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <427A47CF.8080904@eurodev.net>
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


--QYbTd+PSDu6P6/0L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 05, 2005 at 06:20:31PM +0200, Pablo Neira wrote:
> Hi Harald,
>=20
> Currently ipt_clusterip_tgt_info structure is out of sync with regards to=
=20
> iptables snapshot in SVN. This happened because the patch to fix deletion=
 was=20
> applied to iptables but not the kernel part, so it got lost somehow.

thanks, I'll push it with my other change to davem.  Trying to set up a
local git tree where he can pull from, before.
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--QYbTd+PSDu6P6/0L
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCen4yXaXGVTD0i/8RAmjQAJ4qRgKSjdKSHtAtbYdSxPdU5ZAIdgCgm7H1
d9xCeJVu5mg8UqhnloFSQwg=
=Yie/
-----END PGP SIGNATURE-----

--QYbTd+PSDu6P6/0L--
