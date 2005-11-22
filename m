From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC] [PATCH] nf_conntrack_netlink port take#2
Date: Tue, 22 Nov 2005 23:08:51 +0100
Message-ID: <20051122220851.GD31478@sunbeam.de.gnumonks.org>
References: <43836FFE.3020504@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HVKb6YbgzW8Y2wp+"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <43836FFE.3020504@eurodev.net>
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


--HVKb6YbgzW8Y2wp+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 22, 2005 at 08:22:38PM +0100, Pablo Neira wrote:
> Hi,
>=20
> Sorry for the bad timing. Here attached the take#2 of the
> nf_conntrack_netlink port. It includes a layer-3 abstraction as
> suggested. Attached two patches:

ok, I didn't have the time for a detailed review (and chances are
undlikely that I will have anytime soon).  However, if noone opposes, I
would like to submit this for 2.6.16 quite soon.  But not too soon (dave
has a open net-2.6.16 tree, but we don't want to flood him with
incremental fixes, at least not intentionally).  So I'd say Pablo keeps
the patch update out-of-tree until 2.6.15 is released, and at that time
we push it to mainline immediately.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--HVKb6YbgzW8Y2wp+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDg5bzXaXGVTD0i/8RAmrMAKCv59vR32B5HPtHTQ3QBHi7BU8QRgCaAyY3
tmvLIjc0JDyB4IOE1c8eEfI=
=Rmrw
-----END PGP SIGNATURE-----

--HVKb6YbgzW8Y2wp+--
