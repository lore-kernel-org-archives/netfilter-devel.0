From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Netfilter modules to use modern parameters
Date: Tue, 23 Sep 2003 13:23:32 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030923112332.GK31401@sunbeam.de.gnumonks.org>
References: <20030923083215.7CFC62C23F@lists.samba.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DEfZqDS1MPR2ysog"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <20030923083215.7CFC62C23F@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--DEfZqDS1MPR2ysog
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 23, 2003 at 06:31:29PM +1000, Rusty Russell wrote:
> Requires previous patch send to lkml, entitled [PATCH] module_param_array=
().
>=20
> Harald: I changed ULOG's flushtimeout to always use 100ths of a
> second, to avoid being kernel-version and arch specific.

Thanks, I'm going to update 2.4.x accordingly.

> If no objections, I'll send to DaveM (it's 2.6-only).

sure, just go ahead.

> Cheers,
> Rusty.
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--DEfZqDS1MPR2ysog
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/cC00XaXGVTD0i/8RAqCLAJ9xepfac1PHoVSQtphXLsvYK3zV8ACfchfs
f9IX6wNOB2Kl+YDrY8hh9b4=
=aVuX
-----END PGP SIGNATURE-----

--DEfZqDS1MPR2ysog--
