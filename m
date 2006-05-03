From: Harald Welte <laforge@netfilter.org>
Subject: Re: Libnetfilter_conntrack problems
Date: Wed, 3 May 2006 13:15:49 +0200
Message-ID: <20060503111549.GO16562@sunbeam.de.gnumonks.org>
References: <ca021ab30604270455q5cf093c9s990558209bca3e1d@mail.gmail.com>
	<20060501175353.GD5267@rama>
	<ca021ab30605030249s62ab1924uf9b1be924bd2d28e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eGLW8NzjjVmDHwQh"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?iso-8859-1?Q?S=E9bastien?= LAVEZE <slaveze@gmail.com>
Content-Disposition: inline
In-Reply-To: <ca021ab30605030249s62ab1924uf9b1be924bd2d28e@mail.gmail.com>
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


--eGLW8NzjjVmDHwQh
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 03, 2006 at 11:49:04AM +0200, S=E9bastien LAVEZE wrote:
> OK
> I was trying to have multiple handles in different threads and it was
> working only for the first created thread. I change my application in
> a multi-process one and all seems to work fine

The libraries are not thread safe at all, and there was never any work
to make them so.  I personally (like many other netfilter developers, I
believe) never use threads in my programs, so it's unlikely that we'd be
working on that.  patches are welcome, though.

> However the DESTROY events come a long time after the actual end of a
> connection by timeout...am I right ?

not really.  please be more specific.  what is 'end of a connection by
timeout'? which specific timeout of which particular state are you
talking about?

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--eGLW8NzjjVmDHwQh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFEWJDlXaXGVTD0i/8RAjRbAJ4r6BGJkyRbSW7lCzwjP3EN8QJIAgCgm9VG
unEhUOV6G3nr/BFX033hYew=
=D/pd
-----END PGP SIGNATURE-----

--eGLW8NzjjVmDHwQh--
