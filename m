From: Harald Welte <laforge@netfilter.org>
Subject: Re: PPTP connection tracking and Poptop on same box
Date: Mon, 22 Sep 2003 10:52:07 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030922085207.GE31401@sunbeam.de.gnumonks.org>
References: <20030905115534.GD665@obroa-skai.de.gnumonks.org> <3F5D91DC.3030706@snapgear.com> <20030921140546.GB20986@sunbeam.de.gnumonks.org> <3F6EAD85.1070707@snapgear.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sgneBHv3152wZ8jf"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
Content-Disposition: inline
In-Reply-To: <3F6EAD85.1070707@snapgear.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--sgneBHv3152wZ8jf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 22, 2003 at 06:06:29PM +1000, Philip Craig wrote:
> Harald Welte wrote:
> >great.  NAT works also?
>=20
> Actually, I've only tested with NAT.
>=20
> >However, there were some problems with running a PPTP daemon on the PPTP
> >NAT box at the same time, and I never really understand the source of
> >the problem [most likely because I didn't have enough time].  So I went
> >for the 'quick fix now, real solution later' approach, that ended up
> >with the 25_natcore-nohelper.patch.
>=20
> If I recall correctly, the problem was that local PPTP connections did not
> work unless you also had CONFIG_IP_NF_NAT_LOCAL enabled.  This was because
> the helper/expect were being called at LOCAL_OUT, but not at LOCAL_IN,
> and so the manips were only created for one direction.
>=20
> Is it possible to change it so that the helper is not called at all
> at LOCAL_OUT unless CONFIG_IP_NF_NAT_LOCAL is enabled?
>=20
> Btw, why do we even have the LOCAL_OUT hook for nat when
> CONFIG_IP_NF_NAT_LOCAL is disabled?

because of the history...

1) SNAT of locally-originated connections (rules in POSTROUTING).  We
   need to mangle reply packets at NF_IP_PRE_ROUTING.  This case works
   without CONFIG_IP_NF_NAT_LOCAL, and has always been working.

2) DNAT of local packets (rules in OUTPUT).  We need to mangle the reply
   packets at NF_IP_LOCAL_IN.  This was broken for a long time (from
   2.4.0 to 2.4.18).  It was broken in a 'silent' way.=20

If I'm not missing something, we could just remove the hook registration
for LOCAL_OUT in case CONFIG_IP_NF_NAT_LOCAL is undefined.  We have to
continue providing the OUTPUT chain, however - for compatibility to
userspace.

I've written a patch. Will test that late today and put it in pom, if it
looks good.

> I've attached a patch for this.

Thanks, applied to CVS (with some additional comment since I tend to
forget stuff like this, not even talking about other people who try to
read that code).

> --=20
> Philip Craig - philipc@snapgear.com - http://www.SnapGear.com
> SnapGear - Custom Embedded Solutions and Security Appliances

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--sgneBHv3152wZ8jf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/brg3XaXGVTD0i/8RAr96AJ9NhSjlIDO8ObnJaKx+mmQksqc+pQCfTmyZ
ejO+jVoUS+0cpDCto55tkkg=
=aqR1
-----END PGP SIGNATURE-----

--sgneBHv3152wZ8jf--
