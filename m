From: Harald Welte <laforge@gnumonks.org>
Subject: Re: (no subject)
Date: Wed, 30 Oct 2002 09:55:43 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021030095543.U8635@sunbeam.de.gnumonks.org>
References: <1035739556.3dbc21a447d28@student-webmail.lboro.ac.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6SWS31fp4apnN2Tf"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: C.Shelley-02@student.lboro.ac.uk
Content-Disposition: inline
In-Reply-To: <1035739556.3dbc21a447d28@student-webmail.lboro.ac.uk>; from C.Shelley-02@student.lboro.ac.uk on Sun, Oct 27, 2002 at 05:25:56PM +0000
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--6SWS31fp4apnN2Tf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 27, 2002 at 05:25:56PM +0000, C.Shelley-02@student.lboro.ac.uk =
wrote:
> Developers,
>=20
> I have had an idea for a new target for moifying the TCP flags of a packe=
t.

> Do you think it will work?

yes, it will work with 'weak' firewalls doing very lazy checking on the TCP=
 ,
of course.=20

An iptables target like this is an ugly hack, so don't expect it to show
up in the linux kernel, after you have submitted it to me :)

> --Craig Shelley  =20

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--6SWS31fp4apnN2Tf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9v56PXaXGVTD0i/8RAtxsAJ9WBmDgBXg/B5zVd+5bqxFzGThiNwCgtGvv
ij4oeMmczKJu4xrZ6eQjJRU=
=oERv
-----END PGP SIGNATURE-----

--6SWS31fp4apnN2Tf--
