From: Harald Welte <laforge@netfilter.org>
Subject: 15000 connections (was Re: (no subject))
Date: Fri, 5 Sep 2003 13:49:32 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030905114931.GA665@obroa-skai.de.gnumonks.org>
References: <IAEOKBNDAKLABMLEEMMKIEBBFNAA.sh@realsecure.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Shaun Hedges <sh@realsecure.net>
Content-Disposition: inline
In-Reply-To: <IAEOKBNDAKLABMLEEMMKIEBBFNAA.sh@realsecure.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 30, 2003 at 10:51:12PM -0700, Shaun Hedges wrote:
> Hello,
>=20
> We have high speed applications that open up hundreads of threads per
> computer very fast then close then open again.  At one time, we can have
> about 15000 tcp connections going through the firewall at once.  We've
> recently been adding more application servers but we're noticing that the
> bandwidth usage isn't going up intune with the number of computers, it's
> actually stay the same.  We know this shouldn't be the case so am wonderi=
ng
> if 15000+ connections is too much for a RH Linux+netfilter configuration,
> using no stateful inspection just basic FORWARD'ing rules to block all
> traffic from those machines except one port coming in.

if you don't use connection tracking, there is no danger of running into
any connections/second limits - in fact, your firewall doesn't even know
about connections in this case.

> Our router is a P1.7ghz Celeron w/ 512mb ram and IDE disks..  Is this
> insufficient?  Our b/w usage is a mere 2mbits, but we have 10mbits
> available, and when it goes up, we seem to add more incoming bandwidth as
> outgoing, it looks as though the errors or timeouts are increasing.


10MBit is the kind of bandwith you can filter with an old 486 box.

> Any ideas?
> Thx


--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/WHhLXaXGVTD0i/8RAvqZAJ9VKDAT4VhM+5ggYkkVGFHFSP9RUwCfS3jR
lPLyRIZKQC2sM3QH1LlRDrg=
=QfMR
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
