From: Harald Welte <laforge@netfilter.org>
Subject: Re: xt_MARK useless line
Date: Sun, 7 Jan 2007 15:15:57 +0100
Message-ID: <20070107141557.GB13543@prithivi.gnumonks.org>
References: <Pine.LNX.4.61.0612291752440.9799@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IiVenqGWf+H9Y6IX"
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0612291752440.9799@yvahk01.tjqt.qr>
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


--IiVenqGWf+H9Y6IX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 29, 2006 at 05:54:07PM +0100, Jan Engelhardt wrote:
> Hi,
>=20
>=20
> in linux-2.6.20-rc2/net/netfilter/xt_MARK.c one can find
>=20
>         if((*pskb)->mark !=3D markinfo->mark)
>                 (*pskb)->mark =3D markinfo->mark;
>=20
> would not it be simpler just to set the mark? Or are comparison-jumps=20
> like these 'cheaper' than assignments? (I don't think so.)

I don't really know. I think the intention might have been to prevent
writes to shared data structures, in order to reduce cache ping-pong on
SMP.  However, unlesss some really complex and rare event happens, this
skb will never be processed asynchronously and thus not be used on any
other CPU.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--IiVenqGWf+H9Y6IX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFFoQCdXaXGVTD0i/8RAsu6AJ9Cmmg7fpvJpkDLdO+m3hAZQ/Eu3wCfQ0oP
s0HYME5hAxTBGEWOJocDjN0=
=76Av
-----END PGP SIGNATURE-----

--IiVenqGWf+H9Y6IX--
