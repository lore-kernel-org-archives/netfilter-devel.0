From: Harald Welte <laforge@netfilter.org>
Subject: Re: helper and handling IPv6 fragments [was Re: nf_conntrack resync
	with 2.6.11-rc4]
Date: Sat, 19 Feb 2005 19:50:28 +0100
Message-ID: <20050219185028.GN29256@sunbeam.de.gnumonks.org>
References: <200502151615.23463.michal@rokos.info>
	<200502151654.57371.michal@rokos.info>
	<200502161132.19312.michal@rokos.info>
	<200502171520.j1HFKH6U029405@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LSp5EJdfMPwZcMS1"
Cc: netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200502171520.j1HFKH6U029405@toshiba.co.jp>
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


--LSp5EJdfMPwZcMS1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 18, 2005 at 12:20:16AM +0900, Yasuyuki KOZAKAI wrote:
> Well, There seems to be some issues in IPv6 module by resent changes.

ACK.

> In the result, all fragments reach ipv6_confirm(). helper should not
> track all of them, and track reassembled skb JUST ONCE.

Agreed.

> But how ipv6_confirm() can figure out whether helper has already tracked
> the reassembled skb or not ?
>=20
> I think nfcache flag may help. If helper return NF_ACCEPT, ipv6_confirm()
> set NFC_ALTERD to nfcache of it. And when other fragments reach ipv6_conf=
irm(),
> it can return without call helper. Of cause, we need to define the other =
flags
> for STOLEN/REPEAT...

I'm not sure if I understand this proposal correctly. Do you suggest to
set the nfcache bit of the reassembled clone as soon as the first
fragment has passed the helper (and returned NF_ACCEPT) ?

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--LSp5EJdfMPwZcMS1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCF4p0XaXGVTD0i/8RApldAJ97zpEWcffBikP9ubUfAf7WQpPOYgCgooTH
FYp/brfQX+ChcmJETXE+4mE=
=/ggS
-----END PGP SIGNATURE-----

--LSp5EJdfMPwZcMS1--
