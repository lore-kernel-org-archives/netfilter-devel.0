From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: [PATCH] connrate missing exports fixed
Date: Thu, 17 Mar 2005 16:19:55 +0200
Message-ID: <4239920B.30906@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090808040708090608080606"
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

This is a multi-part message in MIME format.
--------------090808040708090608080606
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Connrate is missing two exports, which makes the kernel compilation fail if
either ip_conntrack or ipt_connrate is compiled as a module.

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCOZIExyF48ZTvn+4RAjevAKC6SzOT/tsdGJzP1x2j359krZeQbgCfdhT9
//cw9X54GzQDQT70H+5LeBs=
=A3ZE
-----END PGP SIGNATURE-----

--------------090808040708090608080606
Content-Type: text/x-patch;
 name="connrate-export-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="connrate-export-fix.patch"

Index: connrate/linux/net/ipv4/netfilter/ip_conntrack_rate.c
===================================================================
--- connrate/linux/net/ipv4/netfilter/ip_conntrack_rate.c	(revision 3800)
+++ connrate/linux/net/ipv4/netfilter/ip_conntrack_rate.c	(working copy)
@@ -129,3 +129,6 @@
 	READ_UNLOCK(&rate_lock);
 	return rate;
 }
+
+EXPORT_SYMBOL(ip_conntrack_rate_count);
+EXPORT_SYMBOL(ip_conntrack_rate_get);

--------------090808040708090608080606--
