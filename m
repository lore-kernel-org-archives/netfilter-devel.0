From: Harald Welte <laforge@netfilter.org>
Subject: Re: latest nf_conntrack version
Date: Thu, 4 Aug 2005 23:49:09 +0200
Message-ID: <20050804214909.GB4100@rama.de.gnumonks.org>
References: <42EFEA57.5010406@trash.net>
	<20050803142708.GA9456@rama.de.gnumonks.org>
	<20050804.061445.46125299.kozakai@isl.rdc.toshiba.co.jp>
	<200508032237.j73Mb6QG017987@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H1spWtNR+x+ondvy"
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200508032237.j73Mb6QG017987@toshiba.co.jp>
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


--H1spWtNR+x+ondvy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 04, 2005 at 07:37:02AM +0900, Yasuyuki KOZAKAI wrote:
>=20
> Harald, sory, I was looking different file.
>=20
> Please forgot changes of masq/NAT in previous patch.
> What I have to do in that patch was adding menu.
> I attached new patch.
>=20

thanks for correcting this.  I didn't see the problem since I only did
"make oldconfig" and not use any "menuconfig/xconfig" like interface so
far.

I've applied it to my tree right now.

Please include a valud 'Signed-off-by' line in your future patches,
thanks.
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--H1spWtNR+x+ondvy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC8o1VXaXGVTD0i/8RAuthAJ0VWMdw7NY+7lCuuokQbwJpIHJ2agCcD9nn
E4rDEwbF8FjuLKTmgpG1x2o=
=aI5P
-----END PGP SIGNATURE-----

--H1spWtNR+x+ondvy--
