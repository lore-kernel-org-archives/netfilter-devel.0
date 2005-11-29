From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] CTA_PROTO_NUM is u_int8_t not u_int16_t (was Re:
	CTA_PROTO_NUM u_int8_t or u_int16_t)
Date: Tue, 29 Nov 2005 05:09:25 +0100
Message-ID: <20051129040925.GC3544@rama.towersoft.de>
References: <Pine.LNX.4.64.0511231128510.9162@bizon.gios.gov.pl>
	<20051124200736.GW31478@sunbeam.de.gnumonks.org>
	<20051124202125.GX31478@sunbeam.de.gnumonks.org>
	<43864DC7.6060109@trash.net>
	<Pine.LNX.4.64.0511250040030.14092@bizon.gios.gov.pl>
	<20051125084427.GL31478@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.64.0511251019330.32144@bizon.gios.gov.pl>
	<438710E1.2000202@trash.net> <4387A946.3000005@eurodev.net>
	<Pine.LNX.4.64.0511272313570.28434@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JgQwtEuHJzHdouWu"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira Ayuso <pablo@eurodev.net>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0511272313570.28434@bizon.gios.gov.pl>
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


--JgQwtEuHJzHdouWu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 27, 2005 at 11:28:47PM +0100, Krzysztof Oledzki wrote:
>=20
>=20
> On Sat, 26 Nov 2005, Pablo Neira Ayuso wrote:
>=20
> >Patrick McHardy wrote:
> >>Krzysztof Oledzki wrote:
> >>>On Fri, 25 Nov 2005, Harald Welte wrote:
> >>>>yes.  old libnetfilter_conntrack is broken, because it makes wrong si=
ze
> >>>>assumptions.  But if we'd start introdcucing the "new scheme" I
> >>>>proposed, we can guarantee not to run into any of these.
> >>>Only if new libnetfilter_conntrack will send different messages to
> >>>differnet kernels (u_int16_t for 2.6.14 and u_int8_t for 2.6.15+).
> >>I also thinks its a large overkill to introduce this scheme just to
> >>handle brokeness, lets just try not to make this kind of mistake again.
> >>Also it doesn't handle the byteorder-problem of this particular case,
> >>so I don't think we should go this way.
> >I agree. Sorry, I'm not willing to be repetitive but I still see a
> >possible workaround as something ugly that we'll have to live with
> >forever because of an early mistake in the development. If there will be
> >more 2.6.14.x release, fixing it there can be a choice. In spite of
> >everything, I understand that breaking backward compatibility isn't nice
> >but in this case ctnetlink just got pushed forward and it's barely one
> >month old.
>=20
> So, I think what we can do is to fix it in 2.6.15, leave it unchanged
> in 2.6.14 and add kernel version checking to the
> libnetfilter_conntrack to send u_int16_t for 2.6.14 and u_int8_t for
> 2.6.15+ (one if/else). I don't know if (and when) there will be
> another 2.6.14-stable release.

No, I oppose any kind of kernel version number checking.  I'd rather
break 2.6.14 with new versions of the userspace.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--JgQwtEuHJzHdouWu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDi9R1XaXGVTD0i/8RArHyAJ0Zrp7ZRqVeWB1OmZPGWCq5IWCqDQCgjfUd
fUTf+a7C1gy9RfDsjaqB13E=
=vTaA
-----END PGP SIGNATURE-----

--JgQwtEuHJzHdouWu--
