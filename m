From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 2.6] connection tracking events
Date: Sat, 16 Oct 2004 17:07:57 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041016150756.GL29413@sunbeam.de.gnumonks.org>
References: <20041015175406.GK17516@obroa-skai.de.gnumonks.org>
	<41712042.2000505@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iRjOs3ViPWHdlw/I"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <41712042.2000505@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--iRjOs3ViPWHdlw/I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Patrick!

On Sat, Oct 16, 2004 at 03:21:06PM +0200, Patrick McHardy wrote:

> >Since we decided at the netfilter developer workshop that we want to
> >split conntrack events from the rest of ctnetlink, I've now done that
> >(and ported it to use percpu allocations).  This is needed mostly for=20
> >ct_sync.
> >=20
> >
> I've already did this in Erlangen. Pablo is currently working with
> Krizstian on this patch.

mh, did you post this to netfilter-devel?  I must have missed it...

Sorry for replicating your work then :(

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--iRjOs3ViPWHdlw/I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBcTlMXaXGVTD0i/8RAmH5AKCGWjXkGEigE5C2ka18rea4CkzcqACfT2f1
ituXIgnegLt5M0vh70JU7YU=
=eYqx
-----END PGP SIGNATURE-----

--iRjOs3ViPWHdlw/I--
