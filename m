From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Change protocol private information
Date: Fri, 5 Aug 2005 21:24:35 +0200
Message-ID: <20050805192435.GI13345@rama.de.gnumonks.org>
References: <42F2B516.5020307@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqCDj3hiknadvR6t"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <42F2B516.5020307@eurodev.net>
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


--AqCDj3hiknadvR6t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 05, 2005 at 02:38:46AM +0200, Pablo Neira wrote:
> Hi Harald,
>=20
> This is a resent. I'd like to discuss this a bit. Following the
> discusion left at:

I know it's an awful amount of overhead, but if we do this, we have to
nest the protoinfo into another attribute. =20

layer4-specific attributes like CTA_PROTOINFO_TCP_STATE just don't
belong in that list.  CTA_PROTOINFO is fine, and then inside protoinfo
every l4 helper can nest its own (private) nfattr's into that.

Please rework your patch and resubmit, thanks.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--AqCDj3hiknadvR6t
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC87zzXaXGVTD0i/8RAoZbAJ9fipNiRx1XFrl+mtskXuDfZDaC/QCeNFed
+AxApGqznOYgIihekaaH6UU=
=Q3bB
-----END PGP SIGNATURE-----

--AqCDj3hiknadvR6t--
