From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] updates for libnfnetlink_conntrack
Date: Fri, 5 Aug 2005 15:04:57 +0200
Message-ID: <20050805130457.GH4245@rama.de.gnumonks.org>
References: <42F2B551.4070204@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tcC6YSqBgqqkz7Sb"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <42F2B551.4070204@eurodev.net>
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


--tcC6YSqBgqqkz7Sb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 05, 2005 at 02:39:45AM +0200, Pablo Neira wrote:
> @Harald: BTW, I can reach SVN to commit changes to conntrack (timeout err=
or).

the firewall (which was recently rebooted during an upgrade) was missing
a required rule to allow svn commit access. It's fixed now.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--tcC6YSqBgqqkz7Sb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC82P5XaXGVTD0i/8RArpgAJwP4Fo3ue+tqsaTG0VywWoFBDmGAwCfQVdG
WkHszpy+ouC3TElgYC5zFsw=
=VR7i
-----END PGP SIGNATURE-----

--tcC6YSqBgqqkz7Sb--
