From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] x_tables, take 5 (Final Review)
Date: Thu, 12 Jan 2006 17:02:24 +0100
Message-ID: <20060112160224.GK4430@sunbeam.de.gnumonks.org>
References: <20060108212619.GE24266@sunbeam.de.gnumonks.org>
	<200601091744.k09HiVP2022456@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Hb0QVqIhF4gpPBBD"
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200601091744.k09HiVP2022456@toshiba.co.jp>
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


--Hb0QVqIhF4gpPBBD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 10, 2006 at 02:44:31AM +0900, Yasuyuki KOZAKAI wrote:
> Hi,
>=20
> From: Harald Welte <laforge@netfilter.org>
> Date: Sun, 8 Jan 2006 22:26:20 +0100
>=20
> > I'm planning to submit x_tables eatly next week, so this is assumed to
> > be the final review phase.
> >=20
> > So if you have any issues, please comment now before it's too late :)
>=20
> I have some more comments.

great, thanks.

> - xt_dccp:
> dccp_find_option() assumes dccp header is just after IPv4 header.
> Please consider to apply the attached 1st patch.

ok, applied your fix.

> - xt_length:
> The place of IPv4/IPv6 payload length field is different. I think that
> this feature would be better to be implemented as per layer 3 protocol.

well, that's why we have two separate 'match' functions for AF_INET and
AF_INET6.  Having two different modules sounds like overkill for me,
considering that we waste one page per module, even if the functionality
is only a single line of C code.

> - ip6t_owner:
> ip6t_owner.h is missing.

oops. re-adding it right now.

> - xt_sctp:
> match_packet() assumes sctp header is just after IPv4 header, too.
> Please consider to apply the attached 2nd patch.

thanks, applied your fix.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Hb0QVqIhF4gpPBBD
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDxn2QXaXGVTD0i/8RAuUrAJ0bJp5g+ft6ma/f0DFrs6OdTiLWrwCfcdes
0gLHUrvqG8/fWaM6AGEVAQA=
=7MB/
-----END PGP SIGNATURE-----

--Hb0QVqIhF4gpPBBD--
