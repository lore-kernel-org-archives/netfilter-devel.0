From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 2/3] fix various things in ipt_MIRROR
Date: Wed, 23 Apr 2003 01:08:13 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030422230813.GI10887@sunbeam.de.gnumonks.org>
References: <3EA51F72.7030402@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2E/hm+v6kSLEYT3h"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3EA51F72.7030402@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--2E/hm+v6kSLEYT3h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2003 at 12:54:42PM +0200, Patrick McHardy wrote:
> This patch fixes a couple of things in the MIRROR target:
>=20
> - check ttl before rewriting so icmp_send gets clean packet
> - skb_copy_expand skb, for tcpdump and asym. routing
> - inline some functions
> - remove unecessary "struct in_device" declaration/RTO_CONN

thanks, putting this into pom/pending.

> Best regards,
> Patrick
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--2E/hm+v6kSLEYT3h
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+pctdXaXGVTD0i/8RAuldAJ98FEPRllQk3g6HByWcL6tH5m2PIgCdEfK+
17fc5gDM1RhKbAaRabCpaDU=
=fQQr
-----END PGP SIGNATURE-----

--2E/hm+v6kSLEYT3h--
