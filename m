From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH NF_CONNTRACK] compatible ipt_conntrack
Date: Mon, 29 Aug 2005 17:49:27 +0200
Message-ID: <20050829154927.GU4292@rama.de.gnumonks.org>
References: <200506200919.j5K9JIhl022823@toshiba.co.jp>
	<20050828122130.GH4244@rama.de.gnumonks.org>
	<4312EE29.9040102@trash.net>
	<200508291539.j7TFduLF019555@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WGtO2LJjz4IIGa2c"
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org,
	kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200508291539.j7TFduLF019555@toshiba.co.jp>
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


--WGtO2LJjz4IIGa2c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 30, 2005 at 12:39:55AM +0900, Yasuyuki KOZAKAI wrote:
>=20
> Hi, Patrick, Harald,
>=20
> From: Patrick McHardy <kaber@trash.net>
> Date: Mon, 29 Aug 2005 13:14:49 +0200
>=20
> > I feel reluctant to add complexity just so users can switch between
> > them at runtime. It may be useful for debugging, but it doesn't look
> > like a realistic usage scenario. So I would also prefer having a
> > compile-time choice.
>=20
> I re-read old mails, and I seemed to mis-understand your intention.
> I was trying to make possible to compile both of ip_conntrack and
> nf_conntrack as module, and let user choose "Which is linked with match/t=
arget
> modules ?".=20

Well, in an ideal world, the user wouldn't have to make a choice.  But I
really think it's too hard and too ugly to make this work.

> But your opinion was that user choose ip_conntrack or nf_conntrack to
> compile, right ?

Yes, that's what Patrick and I seemed to have agreed to now.
=20
> Then, let user choose ip_conntrack/nf_conntrack to compile.

Yes. ipt_{conntrack,state,helper} should however still be modified to
use struct ip_conntrack or struct nf_conntrack depending on the
compile-time decision.  Please make up your mind on the best possible
implementation.  Probably a large "#ifdef CONFIG_NF_CONNTRACK #else
#endif" section for each of the matches.  It's not nice, but since it
only affects three matches (and we don't pay a performance penalty this
way) I think it's ok.

> The drawback of compile-time choice is that user cannot use ip_conntrack
> for IPv4 NAT and use nf_conntrack for only IPv6 stateful tracking. This i=
s the
> reason why I tried above thing, but I changed my mind. This will not be
> problem because IPv4 NAT with nf_conntrack would be implemented in future,
> I think.

Yes, I was already thinking about nf_conntrack based ipv4 nat and
playing with some extremely early code, but abandoned it since other
issues are higher priority.  I think I'll get back to it at end of
October / beginning of November.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--WGtO2LJjz4IIGa2c
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDEy6HXaXGVTD0i/8RAk/6AJ4rZ695SUA3dAQbzPEVWWg7U6jURACgm524
Xwzq8Cfe/UqgeeKa9PoDID8=
=aT8l
-----END PGP SIGNATURE-----

--WGtO2LJjz4IIGa2c--
