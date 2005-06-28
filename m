From: Tom Eastep <teastep@shorewall.net>
Subject: Re: Iptables snapshot compile failure with 2.6.12 headers: - please
 disregard
Date: Mon, 27 Jun 2005 17:06:22 -0700
Message-ID: <42C0947E.5060305@shorewall.net>
References: <008901c57ab9$e6946330$5001010a@bluereef.local>	<07f301c57acb$19aaa250$5001010a@bluereef.local>
	<20050627091342.GF19928@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig8CC35D6CADB7522042464FE7"
Cc: Andrew Hall <temp02@bluereef.com.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050627091342.GF19928@sunbeam.de.gnumonks.org>
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

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8CC35D6CADB7522042464FE7
Content-Type: multipart/mixed; boundary="------------090001090207000002080606"

This is a multi-part message in MIME format.
--------------090001090207000002080606
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Harald Welte wrote:
> On Mon, Jun 27, 2005 at 01:48:37PM +1000, Andrew Hall wrote:
>
>>It's the ipsec patches that cause the failure, and Tom's patch fixes this
>>so there's no longer a problem.
>
> sorry, which particular "tom's patch" are your referring to?
>
> was that already included (to mainline kernel, p-o-m, iptables)?  Is
> ther anything we still need to do about this issue?
>

I assume that he is referring to the attached hack.

-Tom
--
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net
PGP Public Key   \ https://lists.shorewall.net/teastep.pgp.key

--------------090001090207000002080606
Content-Type: text/x-patch;
 name="ipsec-05-iptablescompile.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipsec-05-iptablescompile.diff"

diff -Naur linux-2.6.11.orig/include/linux/netfilter_ipv4.h linux-2.6.11/include/linux/netfilter_ipv4.h
--- linux-2.6.11.orig/include/linux/netfilter_ipv4.h	2005-03-03 10:55:24.895484995 -0800
+++ linux-2.6.11/include/linux/netfilter_ipv4.h	2005-03-03 10:55:13.496133352 -0800
@@ -7,8 +7,10 @@

 #include <linux/config.h>
 #include <linux/netfilter.h>
+#ifdef __KERNEL__
 #include <linux/netdevice.h>
 #include <net/protocol.h>
+#endif

 /* IP Cache bits. */
 /* Src IP address. */
diff -Naur linux-2.6.11.orig/include/net/ip.h linux-2.6.11/include/net/ip.h
--- linux-2.6.11.orig/include/net/ip.h	2005-03-03 10:54:34.418212127 -0800
+++ linux-2.6.11/include/net/ip.h	2005-03-03 10:54:25.250342049 -0800
@@ -30,8 +30,10 @@
 #include <linux/netdevice.h>
 #include <linux/inetdevice.h>
 #include <linux/in_route.h>
+#ifdef __KERNEL__
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv4.h>
+#endif
 #include <net/route.h>
 #include <net/arp.h>
 #include <net/snmp.h>

--------------090001090207000002080606--

--------------enig8CC35D6CADB7522042464FE7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCwJR+O/MAbZfjDLIRAt4MAKC+cecpnaOJla9qZTrudCT7vk268wCeLJ4/
JjXzaskpSeEP3EoKr2oHHS4=
=hGPf
-----END PGP SIGNATURE-----

--------------enig8CC35D6CADB7522042464FE7--
