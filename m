From: Harald Welte <laforge@gnumonks.org>
Subject: Re: 3 target treatment
Date: Thu, 6 Mar 2003 12:19:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030306111952.GB25556@sunbeam.de.gnumonks.org>
References: <3E65B570.5DA3802D@ie.cuhk.edu.hk> <200303052308.55624.fabrice@netfilter.org> <20030305181405.GD4880@sunbeam.de.gnumonks.org> <3E66DDFA.6759F728@ie.cuhk.edu.hk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z6Eq5LdranGa6ru8"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Philip Ho <cbho@ie.cuhk.edu.hk>
Content-Disposition: inline
In-Reply-To: <3E66DDFA.6759F728@ie.cuhk.edu.hk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--z6Eq5LdranGa6ru8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 06, 2003 at 01:34:50PM +0800, Philip Ho wrote:
> Hi Fabrice and Harald
>=20
> After I tried DSCP target, I have a bit of idea. I guess to update the fr=
ag.
> field, I have to add source code like libipt_DSCP.c and libipt_dscp_helpe=
r.c
>=20
> But I cannot find in the sources explicit reference of the position of DS=
CP
> field relative to IP header. Can you tell me the reason, please?

pleaes read the netfilter hacking HOWTO and my netfilter programming
tutorial (www.gnumonks.org/presentations/netfilter-programming-*)

and to answer the question: less /usr/src/linux/net/ipv4/netfilter/ipt_DSCP=
.c

> Regards,
> philip

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--z6Eq5LdranGa6ru8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+Zy7YXaXGVTD0i/8RAl8gAJwOszX+7V4mPcy+MjaNNh4M+fqZ/gCgrNZ1
kbNWOfPcnXm8nHuxz3g0Pyk=
=n1KQ
-----END PGP SIGNATURE-----

--z6Eq5LdranGa6ru8--
