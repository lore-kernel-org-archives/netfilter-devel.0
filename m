From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [1/1] ipt_osf: fix ipt_osf compilation on some distros.
Date: Fri, 25 Feb 2005 08:07:37 +0300
Message-ID: <1109308057.6728.54.camel@uganda>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-rPWcJ9Iyxt+cl7ZxeD3B"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
To: netfilter-devel@lists.netfilter.org
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


--=-rPWcJ9Iyxt+cl7ZxeD3B
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Some distros have magical header mess, which leads to undefined struct
tcphdr,=20
when net/tcp.h is not included directly.
Following patch workarounds it.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

--- orig/osf/linux-2.6/net/ipv4/netfilter/ipt_osf.c~ 2005-02-07
18:55:56.000000000 +0300
+++orig/osf/linux-2.6/net/ipv4/netfilter/ipt_osf.c  2005-02-24
12:49:22.329311368 +0300
@@ -47,6 +47,7 @@

 #include <net/sock.h>
 #include <net/ip.h>
+#include <net/tcp.h>

 #include <linux/netfilter_ipv4/ip_tables.h>


P.S. Should I resend lost patch with Subject line=20
"[1/1] libipt_osf: fix iptables-1.3.0rc1 compilation.", which moves
kernel headers in ipt_osf.h into appropriate ifdef/endif?
=20
--=20
        Evgeniy Polyakov

Crash is better than data corruption -- Arthur Grabowski

--=-rPWcJ9Iyxt+cl7ZxeD3B
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBCHrKZIKTPhE+8wY0RAtWnAJ418iwo6ySKNFrfkoVByIVYh5e+RgCgjiGF
t4Hz0uy/xpgu2fNqsBExU+4=
=URyH
-----END PGP SIGNATURE-----

--=-rPWcJ9Iyxt+cl7ZxeD3B--
