From: Harald Welte <laforge@netfilter.org>
Subject: Re: Which netfilter modues are ready for 2.6 ?
Date: Thu, 29 Jan 2004 20:38:46 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040129193846.GQ11761@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.58L.0401291151110.8878@alpha.zarz.agh.edu.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8GRwW6U345Myp3+h"
Cc: Netfilter developmnet mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Wojciech 'Sas' Cieciwa <cieciwa@alpha.zarz.agh.edu.pl>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58L.0401291151110.8878@alpha.zarz.agh.edu.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--8GRwW6U345Myp3+h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 29, 2004 at 12:02:23PM +0100, Wojciech 'Sas' Cieciwa wrote:
>=20
> Hi,
>=20
> I try to build modules from patch-o-matic-ng on kernel 2.6.2-rc2.
> But as I see many of modules aren't prepared for kernel 2.6.*
> For example:=20
> nf-log - missing BT_NETPROTO_LOCK declaration
> rtsp-conntrack - missing ct_rtsp_info
> talk-conntrack-nat - missing ct_talk_info
> mms-conntrack-nat - missing ct_mms_info
> ctstat and raw - missing ip_conntrack_defrag_ops and=20
> ip_conntrack_defrag_local_out_ops
>=20
> Can anyone tell mw which modules are tested [and working] on 2.6.* ?

No, but we would be very happy if one would provide us with such a list,
or (even better) ports some of those patches.

netfilter/iptables is a community effort, after all.  We depend a lot on
contributions.  If nobody contributes those ports, it will take a long
time until one of the core team members will catch up with that job.

I'm currently concentrating on developing the failover code and can
rarely spare any more time.

> Thanx.
> 					Sas.
=20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--8GRwW6U345Myp3+h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAGWFGXaXGVTD0i/8RAtHCAJ91N/394k1Q1q+SD8ex/p9maBvofgCfeKfg
ScI4dXCSfVhtZ93eDbwkstY=
=J6HQ
-----END PGP SIGNATURE-----

--8GRwW6U345Myp3+h--
