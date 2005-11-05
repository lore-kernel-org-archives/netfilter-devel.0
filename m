From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] libnetfilter_queue nfattr[] abstraction
Date: Sat, 5 Nov 2005 10:18:54 +0100
Message-ID: <20051105091854.GR5594@sunbeam.de.gnumonks.org>
References: <1131063778.11853.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v+Mbu5iuT/5Blw/K"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
Content-Disposition: inline
In-Reply-To: <1131063778.11853.6.camel@localhost.localdomain>
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


--v+Mbu5iuT/5Blw/K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 04, 2005 at 01:22:58AM +0100, Eric Leblond wrote:
> Hi,
>=20
> This patch is a proposal to suppress the use of struct nfattr* nfa[]
> like params in user level function.

looks fine to me.  I'll rename nfnl_q_datas into nfnl_q_data, though.

> This just hide the low-level structure behind a dummy structure. But
> from a user point of view, this structure should remain inchanged even
> if the kernel internal are changing.

ACK. this can easily be enforced if we put the structure definition into
the C file, and just have a dummy 'struct nfnl_q_data' declaration in
the header.

> I've checked the provided test util and NuFW against the modified
> library.

Please re-check after my changes went in (maybe in 30mins).

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--v+Mbu5iuT/5Blw/K
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDbHj+XaXGVTD0i/8RAirzAJ4/jwNyumPZj8k9Iu5JgrGWetlXoQCfYe1I
+2PLTo/9c9wDk+35hMEbTFI=
=mHNT
-----END PGP SIGNATURE-----

--v+Mbu5iuT/5Blw/K--
