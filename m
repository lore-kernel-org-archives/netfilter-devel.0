From: Harald Welte <laforge@gnumonks.org>
Subject: Re: PPTP conntrack w/out DEBUG is broken ???
Date: Wed, 2 Oct 2002 15:30:13 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021002153013.A13233@sunbeam.de.gnumonks.org>
References: <87d6r9jaa4.fsf@sensi.yemanja.net> <1032690651.9594.13.camel@tux> <200209251648.42936.marian@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Cc: Martin Josefsson <gandalf@wlug.westbo.se>,
	=?iso-8859-1?Q?C=E9dric_Rivard_=3Ccedric=40yemanja=2Enet=3E?=@sunbeam.gnumonks.org,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Netfilter <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Marian Stagarescu <marian@ti.com>
Content-Disposition: inline
In-Reply-To: <200209251648.42936.marian@ti.com>; from marian@ti.com on Wed, Sep 25, 2002 at 04:48:42PM -0400
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 25, 2002 at 04:48:42PM -0400, Marian Stagarescu wrote:
> i run into one problem with PPTP conntrack:
>=20
> run it with debug on: works
> run it w/out debug on: does not.

what do you call 'debug' ?  Does this mean the DEBUG #defines in the
respective sourcecode .c files, or are you talking about CONFIG_NETFILTER_D=
EBUG?

> this debug issue was tracked down to a single printk statement in=20
> ip_conntrack_pptp.c: line 244,245:
>=20
> DEBUGP("%s, CID=3D%X, PCID=3D%X\n", strMName[msg]                 =20
>                      ntohs(*cid), ntohs(*pcid));
>=20

What happens?  Does the kernel oops at this statement?

> thanks for any input,
> marian

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long =
as
 I'm the dictator."  --  George W. Bush Dec 18, 2000

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9mvTkXaXGVTD0i/8RApiFAKCMN6CH7uFv8Um+5vUhVdvfJ7GjhgCdG99w
il3dtSoAgs87jxS4qVxDedU=
=hj9p
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
