From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH NF_CONNTRACK] compatible ipt_conntrack
Date: Sun, 28 Aug 2005 14:21:30 +0200
Message-ID: <20050828122130.GH4244@rama.de.gnumonks.org>
References: <200506200919.j5K9JIhl022823@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKijDXBCEH69PxaN"
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200506200919.j5K9JIhl022823@toshiba.co.jp>
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


--gKijDXBCEH69PxaN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Yasuyuki,

I've found those old patches of yours that unfortunately never received
any comment, AFAICT.

Just to re-state some of the issues at stake:

1) ip_conntrack and nf_conntrack can never be used both together in one
   system.  However, you can compile both of them as modules, and then
   decide to load one or the other.
2) we have some matches (ipt_{state,conntrack,helper}) that refer to
   certain data within the conntrack.  They now only know (and deal)
   with ip_conntrack.
3) we have a whole subsystem including its own targets (the nat code)
   that only works on top of ip_conntrack

On Mon, Jun 20, 2005 at 06:19:17PM +0900, Yasuyuki KOZAKAI wrote:
>=20
> These make ipt_conntrack match compatible with ip_conntrack and nf_conntr=
ack.
> I wrote 2 patches with different approaches.
>=20
> 	1. [ipt_conntrack.patch]
> 	   Introducing glue functions and grouping the common member in
> 	   struct ip_conntrack/nf_conn. {ip,nf}_conntrack registers glue
> 	   functions like ip_ct_attach() and matches/targets use them.
> 	   This is the rough conclusion on discussion with Patrick on March.
> 	   This approach hides dependencies well, but the glue functions will
> 	   add some overheads.

I think this code looks cleaner than the macro-based patch.

However, I think we make our lives much more easy when we make
ip_conntrack / nf_conntrack a compile-time decision.  This way we avoid
compromising any run-time efficiency at the cost of some configurations
where the user doesn't know at compile time which of the two systems he
should use.

I also dislike the "CONNTRACK_IPV4_DEFAULT" config option that you use
in your patches.  I think it was introduced because we cannot have two
modules that supply the same symbol. =20

I think we either make the ip_conntrack/nf_conntrack decision at
compile-time (like stated above), _or_ we find a run-time solution that
will work transparently with both ip_conntrack and nf_conntrack.
Whatever we use for the actual implementation (macros, glue functions,
=2E..) is a different question.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--gKijDXBCEH69PxaN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDEaxJXaXGVTD0i/8RAk+OAJ44+IMd4op3NPTc8oL3v1J4wCyULACdF9bq
jAFMAt7mWHNFrvgJo8+nNlU=
=mvfq
-----END PGP SIGNATURE-----

--gKijDXBCEH69PxaN--
