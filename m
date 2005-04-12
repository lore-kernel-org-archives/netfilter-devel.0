From: Florian Lohoff <flo@rfc822.org>
Subject: Re: libipt_REJECT does not compile with current svn
Date: Tue, 12 Apr 2005 14:58:17 +0200
Message-ID: <20050412125817.GE15606@paradigm.rfc822.org>
References: <1995673631.20050411200222@o2.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fWddYNRDgTk9wQGZ"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Maciej Soltysiak <pysiak_satriani@o2.pl>
Content-Disposition: inline
In-Reply-To: <1995673631.20050411200222@o2.pl>
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


--fWddYNRDgTk9wQGZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 11, 2005 at 08:02:22PM +0200, Maciej Soltysiak wrote:
> Hi,
>=20
> Trying to compile current svn with 2.6.12-rc2 give me this:
>=20
> Extensions found: IPv4:CLUSTERIP IPv4:recent IPv6:ah IPv6:esp IPv6:frag I=
Pv6:ipv6header IPv6:hbh IPv6:dst IPv6:rt
> cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/ -DIPTABLES_VERS=
ION=3D\"1.3.1\"  -fPIC -o extensions/libipt_REJECT_sh.o -c extensions/libip=
t_REJECT.c
> extensions/libipt_REJECT.c:50: error: `IPT_ICMP_FRAG_NEEDED' undeclared h=
ere (not in a function)
> extensions/libipt_REJECT.c:50: error: initializer element is not constant

You are missing the kernel patch - This is the hunk you are missing -
There is more - See my other posting a couple days ago.

Probably the _v1 stuff should be folded into ifdefs ?!?

diff -Nur linux-2.6.11.6.vanilla/include/linux/netfilter_ipv4/ipt_REJECT.h =
linux-2.6.11.6/include/linux/netfilter_ipv4/ipt_REJECT.h
--- linux-2.6.11.6.vanilla/include/linux/netfilter_ipv4/ipt_REJECT.h	2005-0=
3-26 04:28:26.000000000 +0100
+++ linux-2.6.11.6/include/linux/netfilter_ipv4/ipt_REJECT.h	2005-04-06 10:=
31:03.000000000 +0200
@@ -10,11 +10,17 @@
 	IPT_ICMP_NET_PROHIBITED,
 	IPT_ICMP_HOST_PROHIBITED,
 	IPT_TCP_RESET,
-	IPT_ICMP_ADMIN_PROHIBITED
+	IPT_ICMP_ADMIN_PROHIBITED,
+	IPT_ICMP_FRAG_NEEDED
 };
=20
 struct ipt_reject_info {
 	enum ipt_reject_with with;      /* reject type */
 };
=20
+struct ipt_reject_info_v1 {
+	enum ipt_reject_with with;      /* reject type */
+	u_int16_t value;
+};
+
 #endif /*_IPT_REJECT_H*/



--=20
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
                        Heisenberg may have been here.

--fWddYNRDgTk9wQGZ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFCW8XpUaz2rXW+gJcRAmyVAKCXPZSkNVtSJqx6gZZu8UulOaj8JgCgwOKJ
okcCRa6utZyrLcABeTGzG7Y=
=VeRB
-----END PGP SIGNATURE-----

--fWddYNRDgTk9wQGZ--
