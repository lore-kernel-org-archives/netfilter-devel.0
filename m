From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Outbound MAC addresses
Date: Sun, 15 Sep 2002 13:17:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020915131706.G3810@sunbeam.de.gnumonks.org>
References: <F223yZABrsRfN5Kl6jM000242a3@hotmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UKdSZztwKekUWPpk"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "hMax Roth" <mroth2002@hotmail.com>
Content-Disposition: inline
In-Reply-To: <F223yZABrsRfN5Kl6jM000242a3@hotmail.com>; from mroth2002@hotmail.com on Sat, Sep 14, 2002 at 08:15:41AM +0000
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--UKdSZztwKekUWPpk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 14, 2002 at 08:15:41AM +0000, hMax Roth wrote:
> Hello, again. One quick question:
>=20
> (a little off topic, my apologies).=20

you should ask this question at netdev@oss.sgi.com, since the question
is about the core netowkr layer.

> Who sets the MAC addresses for outbound packets? Is it the device driver?=
 I
> know the device driver sets them for incoming,=20

This assumption is wrong.

> sending packets? Does the IP layer track=20
> which mac addresses match the IP addresses?=20

there is no 1:1 mapping (consider assymetric routing).=20

> Chat with friends online, try MSN Messenger: http://messenger.msn.com

IRC can do this withoutany M$N stuff.

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M+=
=20
V-- PS++ PE-- Y++ PGP++ t+ 5-- !X !R tv-- b+++ !DI !D G+ e* h--- r++ y+(*)

--UKdSZztwKekUWPpk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9hGwxXaXGVTD0i/8RAs1XAKCIw/m4YPC26A01DxpcaoLiX5gErACgiymr
szA2fZRQXNht+1v1WIlLniA=
=YXVH
-----END PGP SIGNATURE-----

--UKdSZztwKekUWPpk--
