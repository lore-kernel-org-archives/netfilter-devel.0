From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] CLASSIFY target
Date: Sun, 13 Apr 2003 18:24:58 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030413162458.GW1922@sunbeam.de.gnumonks.org>
References: <3E92F2F8.1020707@trash.net> <1049832299.1318.19.camel@tux.rsn.bth.se> <3E935A9C.9030700@trash.net> <1049847707.1308.92.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1IOPqZ3f1xe/JZlz"
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1049847707.1308.92.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--1IOPqZ3f1xe/JZlz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 09, 2003 at 02:21:47AM +0200, Martin Josefsson wrote:
> Sounds like a good idea since Bert's suggestion was shot down (I think).
> Better not upset the gods by including it in this patch :)

actually, I don't mind this change. =20

As of now, I have no plan to submit the CLASSIFY target to the kernel,
so there is no 'ideological/political' problem with the core networking
change.

> We want to touch as little outside code as possible and if someone
> really needs this they can google and maybe find this discussion and
> then find the original thread and the patch :)

although, there is the practical issue.  Patching something in the core
networking reliably over lots of 2.4.x and 2.5.x kernels seems to be
almost impossible.

> /Martin

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--1IOPqZ3f1xe/JZlz
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+mY9aXaXGVTD0i/8RAngnAJ4nQwO1hxzgU4N9ijhf9ZDU7K+DRgCfStn9
lEDUe3qo7X99tQKE3DrzxgA=
=fYUv
-----END PGP SIGNATURE-----

--1IOPqZ3f1xe/JZlz--
