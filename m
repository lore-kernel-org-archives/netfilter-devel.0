From: Harald Welte <laforge@netfilter.org>
Subject: Re: Iptables 1.3.1 still not very fast.
Date: Thu, 28 Apr 2005 12:36:12 +0200
Message-ID: <20050428103612.GN7407@sunbeam.de.gnumonks.org>
References: <89b63d049739b257@mayday.cix.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nQUlLD2FJeKEtFpv"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Robert de Bath <list-netfilter@debath.co.uk>
Content-Disposition: inline
In-Reply-To: <89b63d049739b257@mayday.cix.co.uk>
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


--nQUlLD2FJeKEtFpv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 01, 2005 at 10:52:25PM +0100, Robert de Bath wrote:
> An example:
> I have a program (I've called iptrange) that will take a file full of ip=
=20
> address ranges (192.168.42.10 192.168.42.25) and converts them into a set
> of iptables chains that invokes another chain if the source (or dest) mat=
ches=20
> ie:
>=20
> iptables -N CHECK
> iptables -A CHECK -s 192.168.42.10/31 -j FOUND
> iptables -A CHECK -s 192.168.42.12/30 -j FOUND
> iptables -A CHECK -s 192.168.42.16/29 -j FOUND
> iptables -A CHECK -s 192.168.42.24/31 -j FOUND
>=20
> The good bit is that it will create a tree of subchains so that the
> matching is efficient for large numbers of ip addresses.

so why aren't you producing a 'iptables-save' style file that can be
loaded by 'iptables-restore'?  This way you should speed up the process
significantly, not requiring thousands of
fork/exec/getsockopt/parse/modify/generate/setsockopt cycles.

> BTW: iptables-restore is slower than my iptrange!

so you're creating your rules directly by linking against libiptc?

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--nQUlLD2FJeKEtFpv
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCcLycXaXGVTD0i/8RAv3zAKCp5mjfQHyoCsS61+emrY5FNjx2lgCeKCSN
4saIISRJtTxUr4hH5aP9p58=
=yXzn
-----END PGP SIGNATURE-----

--nQUlLD2FJeKEtFpv--
