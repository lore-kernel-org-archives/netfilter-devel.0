From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [1/1] libipt_osf: fix iptables-1.3.0rc1 compilation.
Date: Mon, 07 Feb 2005 20:29:53 +0300
Message-ID: <1107797393.5789.17.camel@uganda>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-TnmmQgREf88XShfiQ8Pv"
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


--=-TnmmQgREf88XShfiQ8Pv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Bug reported by Sami Farin <safari-kernel@safari.iki.fi>.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

--- linux-2.6/include/linux/netfilter_ipv4/ipt_osf.h.orig 2005-02-07
19:11:08.237624320+0300
+++ linux-2.6/include/linux/netfilter_ipv4/ipt_osf.h    2005-02-07
19:11:43.854209776 +0300 @@ -33,9 +33,6 @@
 #define IPT_OSF_LOGLEVEL_ALL   0
 #define IPT_OSF_LOGLEVEL_FIRST 1

-#include <linux/list.h>
-#include <net/tcp.h>
-
 #ifndef __KERNEL__
 #include <netinet/ip.h>
 #include <netinet/tcp.h>
@@ -98,6 +95,10 @@

 #ifdef __KERNEL__

+#include <linux/list.h>
+#include <net/tcp.h>
+
+
 /* Defines for IANA option kinds */

 #define OSFOPT_EOL             0       /* End of options */

--=20
        Evgeniy Polyakov

Crash is better than data corruption -- Arthur Grabowski

--=-TnmmQgREf88XShfiQ8Pv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBCB6WRIKTPhE+8wY0RAlLGAJ9CnPwbdjFiKTojHOJlGMby6A7Y3QCdHXeq
RLj8VO8R3i/zBven8SbrgLM=
=bbwg
-----END PGP SIGNATURE-----

--=-TnmmQgREf88XShfiQ8Pv--
