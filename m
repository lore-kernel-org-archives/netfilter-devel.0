From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH]: style/MODULE_AUTHOR fix for ipt_realm and ipt_CLASSIFY
Date: Sat, 23 Aug 2003 14:55:53 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030823124622.GA2669@obroa-skai.de.gnumonks.org>
References: <3F460E50.6060701@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eJnRUKwClWJh1Khz"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3F460E50.6060701@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 22, 2003 at 02:36:32PM +0200, Patrick McHardy wrote:
> Hi Harald,
>=20
> these two patches fix style / MODULE_AUTHOR in ipt_realm
> and ipt_CLASSIFY. Also some incorrect includes in ipt_realm
> are fixed. A similar patch for the addrtype match is going to
> follow.

thanks, patches applied.

> Best regards,
> Patrick
>=20
> PS: i had to take netfilter-devel off the CC list, lists.netfilter.org=20
> is unknown.

unknown? that is strange.  I did _change_ the MX to point to a different
machine (netfilter.franken.de), but I never removed it from the zone.

Anyway, it should be working again now.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/R2RYXaXGVTD0i/8RAmWxAJ9Fr8+zAZu1cv/0PYRLdRzvjEvkIgCgtUoI
AAnmtyZLm3GEt82doGXF6A4=
=KF0Z
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--
