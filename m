From: Harald Welte <laforge@netfilter.org>
Subject: Re: raw table breaks iptables binary compatibility
Date: Thu, 13 Nov 2003 12:18:04 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031113111804.GA17027@obroa-skai.de.gnumonks.org>
References: <20031109093255.GB1005@sunbeam.de.gnumonks.org> <Pine.LNX.4.33.0311131111300.28150-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Cc: Henrik Nordstrom <hno@marasystems.com>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0311131111300.28150-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2003 at 11:20:55AM +0100, Jozsef Kadlecsik wrote:
> I have committed the separation of the raw target into a backward
> compatible raw patch (with NOTRACK target) and a backward
> incompatible TRACE target patch in cvs.

thanks a lot, jozsef. I think we should aim to push that into 2.4.24

> Best regards,
> Jozsef

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/s2hsXaXGVTD0i/8RAmQ/AJ46+IOH6iM20lNJsJ7SVi3tnpD+4wCeNrOK
V26OLLVPkYhUHDwMGV61dOM=
=iu+z
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
