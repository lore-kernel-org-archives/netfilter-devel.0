From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] PPTP conntrack enhancements
Date: Thu, 5 Dec 2002 21:03:56 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021205200356.GA11068@naboo.club.berlin.ccc.de>
References: <3DEC4A99.9090805@snapgear.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
Content-Disposition: inline
In-Reply-To: <3DEC4A99.9090805@snapgear.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 03, 2002 at 04:09:29PM +1000, Philip Craig wrote:
> Hi,
>=20
> I've attached a diff against the PPTP conntrack patch to fix
> various issues.  The major changes are that it now works in
> the presence of DNAT, and uses GRE expectations in both
> directions.

cool. Thanks a lot.

> * add ip_ct_gre_keymap_destroy(), and call it from
> pptp_timeout_related otherwise keymaps are never destroyed for
> expectations that never arrive.

true.

> * ip_conntrack_change_expect now uses the tuple mask to
> compare the old expect to the new expect.  This is because the
> source key may need changing, but this is not included in the
> mask, so expect_clash then fails when doing the check against
> the old expect.

ack.

> * GRE expectations are created for both directions.  Only one
> will be matched, the other hangs around until the call is
> disconnected.

yup.

> * DNAT is now supported, although it doesn't do NAT of the
> PAC call id since I can't see any situations in which that
> would be useful.

agreed.

> * pptp_inbound_pkt and pptp_outbound_pkt are called for the
> INPUT and OUTPUT hooks as well, otherwise fields in
> nat_pptp_info are uninitialized for local connections.

I never thought of local connections in the case of nat.

> Regards,
> Phil

Thanks a lot for your work on the PPTP helper.  I know how much of a
PITA this protocol (and this incarnation of a pptp helper) is.

I'll do a bit of testing and then apply it to CVS.

> Philip Craig     Software Engineer     http://www.SnapGear.com

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M-=
=20
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE977EsXaXGVTD0i/8RAhnkAKCMTwCdHNaePnKkOsd0PXg4/z+jRACdECrf
NQFZpklZJu2zoFDoxah7yl0=
=6dgR
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
