From: Harald Welte <laforge@netfilter.org>
Subject: Re: how to clear the conntrack table!
Date: Sat, 23 Aug 2003 23:08:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030823210837.GE6750@sunbeam.de.gnumonks.org>
References: <006301c3630d$7c163260$5b01aa0a@nightmare>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k3qmt+ucFURmlhDS"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Decoy <yangzehui@boco.com.cn>
Content-Disposition: inline
In-Reply-To: <006301c3630d$7c163260$5b01aa0a@nightmare>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--k3qmt+ucFURmlhDS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 15, 2003 at 05:13:05PM +0800, Decoy wrote:
> Hi!
>=20
> how can I clear the conntrack table?!

unfortunately there is currently no other way than to unload and reload the
ip_conntrack module :(

> Thanks very much!
> dec0y

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--k3qmt+ucFURmlhDS
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/R9fVXaXGVTD0i/8RArgTAJ46keIFC7haZ8KCyDbZYwm92xp6wwCcCWEV
F3uIQb2+qI0Zb9VKrkZDxPE=
=D8qE
-----END PGP SIGNATURE-----

--k3qmt+ucFURmlhDS--
