From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH NF_CONNTRACK 0/10] compatibility between {ip,
	nf}_conntrack
Date: Mon, 19 Sep 2005 16:27:44 +0200
Message-ID: <20050919142744.GC4600@rama.de.gnumonks.org>
References: <200509010913.j819Dfcl004700@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5QAgd0e35j3NYeGe"
Cc: netfilter-devel@lists.netfilter.org, pablo@eurodev.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200509010913.j819Dfcl004700@toshiba.co.jp>
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


--5QAgd0e35j3NYeGe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 01, 2005 at 06:13:40PM +0900, Yasuyuki KOZAKAI wrote:
>=20
> Hi,
>=20
> I tried to solve compatibility issue, and these patches are my current
> solutions. Concepts are:

thanks, I've applied your patches without modifications.

I think due to the numerous changes in existing header files, we cannot
safely submit it for 2.6.14 anymore.  However, I plan to submit
nf_conntrack to the manline tree immediately after 2.6.14 has been
released, to make sure it gets into 2.6.15-rc1.

Pablo: Are you interested in porting ip_conntrack_netlink to
nf_conntrack_netlink ?  It would be great if nf_conntrack would support
it out of the box from the beginning...

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--5QAgd0e35j3NYeGe
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDLsrgXaXGVTD0i/8RAguxAKCQsYse3+OsGcC4nZZE78YDW15RCACgnJzO
qQJnZXCFmBmAMTa+HU/UHY4=
=H/Lz
-----END PGP SIGNATURE-----

--5QAgd0e35j3NYeGe--
