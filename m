From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 2.6] NETFILTER: tcp window tracking
Date: Sun, 25 Jul 2004 16:05:01 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040725200500.GC10342@obroa-skai.de.gnumonks.org>
References: <20040724153427.GV2848@obroa-skai.de.gnumonks.org> <20040724232239.29bd3ee3.davem@redhat.com> <20040725131249.GA10342@obroa-skai.de.gnumonks.org> <20040725110214.057d3919.davem@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E/DnYTRukya0zdZ1"
Cc: Harald Welte <laforge@netfilter.org>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
Content-Disposition: inline
In-Reply-To: <20040725110214.057d3919.davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--E/DnYTRukya0zdZ1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 25, 2004 at 11:02:14AM -0700, David S. Miller wrote:
> On Sun, 25 Jul 2004 09:12:49 -0400
> Harald Welte <laforge@netfilter.org> wrote:
>=20
> > Now let's see how many people complain about some breakage before
> > 2.6.9 gets released.
>=20
> I'll be the first, it doesn't even build :-)
> Missing some linux/sysctl.h changes perhaps in the
> window tracking diff?

I am sorry. I have an 'over-optimized' script that only diff's the
netfilter include and .c files... resulting in changes to core files
like the sysctl.h not being part of the resulting diff :(

That's why my tree compiles and yours didn't (I always do a final compile t=
est
with what I send you...)

> Just send me the necessary sysctl.h diff so I can fix this up.
> Thanks.

diff -urN --exclude-from=3D/usr/src/diff.exclude linux-2.6.6-ct_error_api-u=
dp/include/linux/sysctl.h linux-2.6.6-tcp-win2/include/linux/sysctl.h
--- linux-2.6.6-ct_error_api-udp/include/linux/sysctl.h	2004-06-18 15:01:33=
=2E000000000 +0200
+++ linux-2.6.6-tcp-win2/include/linux/sysctl.h	2004-06-18 15:20:31.0000000=
00 +0200
@@ -407,6 +407,10 @@
 	NET_IPV4_NF_CONNTRACK_GENERIC_TIMEOUT=3D13,
 	NET_IPV4_NF_CONNTRACK_BUCKETS=3D14,
 	NET_IPV4_NF_CONNTRACK_LOG_INVALID=3D15,
+	NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_MAX_RETRANS=3D16,
+	NET_IPV4_NF_CONNTRACK_TCP_LOOSE=3D17,
+	NET_IPV4_NF_CONNTRACK_TCP_BE_LIBERAL=3D18,
+	NET_IPV4_NF_CONNTRACK_TCP_MAX_RETRANS=3D19,
 };
 =20
 /* /proc/sys/net/ipv6 */

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--E/DnYTRukya0zdZ1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBBBJsXaXGVTD0i/8RAgJNAJ4ipKqPxFGDOiyorbbWp0awIusaigCgq5Hg
QrU1x0YMRgo8vvDce13/ybg=
=cTU+
-----END PGP SIGNATURE-----

--E/DnYTRukya0zdZ1--
