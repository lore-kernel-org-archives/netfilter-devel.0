From: Harald Welte <laforge@gnumonks.org>
Subject: Re: ICMP match bug
Date: Fri, 31 Jan 2003 13:00:16 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030131120016.GY9073@naboo.cybercafe42>
References: <20030127140143.GA29965@balabit.hu> <20030127173937.GB31017@balabit.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p8mP+8RrBGerSNjm"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Balazs Scheidler <bazsi@balabit.hu>
Content-Disposition: inline
In-Reply-To: <20030127173937.GB31017@balabit.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--p8mP+8RrBGerSNjm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 27, 2003 at 06:39:37PM +0100, Balazs Scheidler wrote:
> On Mon, Jan 27, 2003 at 03:01:43PM +0100, Balazs Scheidler wrote:
> > We encountered this problem because we generate iptables-restore compat=
ible
> > output. iptables-restore does not demand load protocol matchers (thus we
> > needed explicit match specifications to be able to use --dport & friend=
s).
> > We rewrite rules by sed -e 's/-p \(.*\)/-p \1 -m \1/', thus iptables -p=
 icmp
> > becomes iptables -p icmp -m icmp unconditionally.
> >=20
> > The solution would be either to create a 'wildcard' match for -m icmp w=
hich
> > would match all packets (I'm afraid this would create incompatibilities)
> > _or_ to fix iptables-restore to load matches the same way as iptables i=
tself
> > does.
>=20
> Let me fix myself, the latest iptables version seems to have this demand
> loading fixed, thus our problem is solved.=20

;).  Yes, I remember having fixed that demandloading code.  It now has
more comment than C code :(

> However the way the icmp match defaults does not seem to be correct to me.

I totally agree.  Any suggestions?

> Bazsi
=20

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M-=
=20
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)

--p8mP+8RrBGerSNjm
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+OmVQXaXGVTD0i/8RAh3GAJ0ZHjwaMTC8aHPd780/e/7r1aDJUwCgrsF/
tvkHTRAwUbKikGXN7ZjeFwE=
=6BJD
-----END PGP SIGNATURE-----

--p8mP+8RrBGerSNjm--
