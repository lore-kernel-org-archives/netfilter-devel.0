From: Harald Welte <laforge@netfilter.org>
Subject: Re: Packet fragmentation handling
Date: Fri, 14 Nov 2003 16:15:13 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031114151513.GF2395@obroa-skai.de.gnumonks.org>
References: <1068817102.22300.52.camel@rade7.s.cs.auc.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6WlEvdN9Dv0WHSBl"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Emmanuel Fleury <fleury@cs.auc.dk>
Content-Disposition: inline
In-Reply-To: <1068817102.22300.52.camel@rade7.s.cs.auc.dk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--6WlEvdN9Dv0WHSBl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2003 at 02:38:22PM +0100, Emmanuel Fleury wrote:
> Hi,
>=20
> I am trying to understand the way Netfilter (and other firewall) are
> handling packet fragmentation.
>=20
> Does somebody has good documentations, links, opinions about packet
> fragmentation handling in firewall ?

In the netfilter/iptables case it's pretty easy.=20

If you don't have ip_conntrack loaded, you can match the first fragment
like any other packet, and all further fragments with the '-f' or
'--fragment' switch to iptables.

If you have ip_conntrack loaded, all fragmented packets get defragmented
via ip_defrag() at the PRE_ROUTING hook, and (if necessarry)
re-fragmented at POST_ROUTING according to the MTU of the outgoing
interface.  Thus all your packet filter rules (filter,nat,mangle table)
will never see fragmented packets in that case.

> Regards
> Emmanuel

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--6WlEvdN9Dv0WHSBl
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/tPGBXaXGVTD0i/8RAmLAAKCcVIdW9qBaHLAoUR9iyOuMDdfr/ACgiFxi
64m4wSJBV5GLhVWDjraeUGk=
=iXVs
-----END PGP SIGNATURE-----

--6WlEvdN9Dv0WHSBl--
