From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] was Re: QUEUE on Alpha not working?
Date: Sun, 7 Sep 2003 12:07:10 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030907100710.GA747@obroa-skai.de.gnumonks.org>
References: <Pine.LNX.4.55.0309041224060.27499@ryanspc.com> <20030905121526.GF665@obroa-skai.de.gnumonks.org> <Pine.LNX.4.55.0309062059230.31908@ryanspc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Cc: netfilter-devel@lists.netfilter.org,
	James Morris <jmorris@intercode.com.au>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ryan Veety <ryan@ryanspc.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0309062059230.31908@ryanspc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 06, 2003 at 09:16:22PM -0400, Ryan Veety wrote:
> On Fri, 5 Sep 2003, Harald Welte wrote:
>=20
> > On Thu, Sep 04, 2003 at 01:17:56PM -0400, Ryan Veety wrote:
> > > My DEC Alpha Multia is running debian unstable with kernel 2.4.21.
> > > All code that uses libipq fails.  ipq_message_type returns
> > > NLMSG_ERROR for every packet.  Even the intercept tool from the
> > > netfilter testsuite (CVS) fails:
> >
> > can you please submit this to bugzilla.netfilter.org?
> >
> > James Morris (the ip_queue author) is currently moving from one
> > continent to another... so it could take some time until he can have a
> > look.
>=20
> Instead of filing the bug report I decided to hunt down the bug. =20

Thank you!

> The problem was in the libipq.h header, where it assumed if the
> architecture was not 64bit kernel/32bit userspace that the userspace
> must be 32bit for the ipq_id_t type.  I instead defined ipq_id_t the
> same way it is in the kernel code, as unsigned long.  Now libipq
> should work everywhere (I'm assuming it was also broken on other 64bit
> cpus).

yes, indeed.  Your findings seem correct to me.  I will apply your
patch to our CVS repository.

I'm Cc'ing James Morris for reference (and am thus qouting your patch
again).

> --- netfilter-orig/userspace/include/libipq/libipq.h    2003-09-06
> 20:45:40.000000000 -0400
> +++ netfilter/userspace/include/libipq/libipq.h 2003-09-06 20:44:50.00000=
0000
> -0400
> @@ -35,7 +35,7 @@
>  typedef u_int64_t ipq_id_t;
>  #else
>  #include <linux/netfilter_ipv4/ip_queue.h>
> -typedef u_int32_t ipq_id_t;
> +typedef unsigned long ipq_id_t;
>  #endif
>=20
>  #ifdef DEBUG_LIBIPQ

> Ryan
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/WwNNXaXGVTD0i/8RAsgBAKCnEl8xUo9SvDIoMJv94phwfxwllQCaA8yw
EfqLGsNtU9/tydcNF1cmnrI=
=lVBz
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
