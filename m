From: Harald Welte <laforge@netfilter.org>
Subject: Re: raw patch = kernel panic :(
Date: Mon, 6 Oct 2003 16:22:14 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031006142214.GM5758@sunbeam.de.gnumonks.org>
References: <3F8045B3.6000607@wp.pl> <Pine.LNX.4.33.0310061238480.15175-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FWsKKOMrHBxzpZBm"
Cc: c0g <c0g@wp.pl>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0310061238480.15175-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--FWsKKOMrHBxzpZBm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 06, 2003 at 12:44:17PM +0200, Jozsef Kadlecsik wrote:
>=20
> Harald, I added the ported nf-log patch to the 2.5 p-o-m tree as
> pending. But what to do with the port of the raw patch, which is ready?
> Shall we introduce the userspace tree under patch-o-matic_2.5/?

No.  We just commit the userspace changes to the stock iptables package.

The changes are:
- add support for the raw table to libipt_conntrack.  This needs
  IPT_CONNTRACK_STATE_UNTRACKED defined.  It has an (ugly) section to
  libipt_conntrack.c to accomodate the fact that we might not have a
  patched kernel
- add support to libipt_state. The same for IPT_STATE_UNTRACKED
- add support for the raw table to libi4tc.c.  This has no compatibility
  implications.

So I don't really see the need for raw.patch having a userspace part at
all.

Did I miss something?

> Best regards,
> Jozsef

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--FWsKKOMrHBxzpZBm
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/gXqWXaXGVTD0i/8RAnBAAKClBroOGgilj2viFgc2R/0uVXfqugCeKLPl
1I2Yb9vPsnhdX71++lkwH0A=
=IXlj
-----END PGP SIGNATURE-----

--FWsKKOMrHBxzpZBm--
