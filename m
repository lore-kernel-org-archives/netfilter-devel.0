From: Gianni Tedesco <gianni@ecsc.co.uk>
Subject: [PATCH]: NETLINK can sleep in illegal context
Date: 11 Nov 2002 10:14:24 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1037009663.29603.5.camel@lemsip>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EKjeFKF5Uyn1NCFQI03I"
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-EKjeFKF5Uyn1NCFQI03I
Content-Type: multipart/mixed; boundary="=-7F721UKEBfpCof7XRG7E"


--=-7F721UKEBfpCof7XRG7E
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hello,

Attached patch fixes kernel panic in the NETLINK target. It's quite rare
(I run this on about 100 firewalls and have seen it happen on 1 so far).
Its just a GFP_KERNEL where it needs to be a GFP_ATOMIC.

*hangs head in shame at such a lame bug*

--=20
// Gianni Tedesco (gianni at ecsc dot co dot uk)
lynx --source www.scaramanga.co.uk/gianni-at-ecsc.asc | gpg --import
8646BE7D: 6D9F 2287 870E A2C9 8F60 3A3C 91B5 7669 8646 BE7D

--=-7F721UKEBfpCof7XRG7E
Content-Disposition: attachment; filename=NETLINK-illegal-context.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch; name=NETLINK-illegal-context.diff; charset=ISO-8859-1

diff -u -r1.3 NETLINK.patch
--- netfilter.orig/patch-o-matic/base/NETLINK.patch	12 Nov 2001 08:19:29 -0=
000	1.3
+++ netfilter/patch-o-matic/base/NETLINK.patch	11 Nov 2002 10:10:22 -0000
@@ -65,7 +65,7 @@
 +		skb_put(outskb, len);
 +		memcpy(outskb->data, &nlhdr, sizeof(nlhdr));
 +		memcpy((outskb->data)+sizeof(nlhdr), ip, len-sizeof(nlhdr));
-+		netlink_broadcast(ipfwsk, outskb, 0, ~0, GFP_KERNEL);
++		netlink_broadcast(ipfwsk, outskb, 0, ~0, GFP_ATOMIC);
 +	}else{
 +		if (net_ratelimit())
 +			printk(KERN_WARNING "ipt_NETLINK: packet drop due to netlink failure\n=
");

--=-7F721UKEBfpCof7XRG7E--

--=-EKjeFKF5Uyn1NCFQI03I
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQA9z4L+kbV2aYZGvn0RApqjAJ4v0BA88NRrKi3Hhv5Mf8S9Z7kGOwCeJMy7
USnC2gQbckXuqbzJsLJ8uv0=
=OhnY
-----END PGP SIGNATURE-----

--=-EKjeFKF5Uyn1NCFQI03I--
