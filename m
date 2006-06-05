From: Sven Anders <anders@anduras.de>
Subject: Negating limit
Date: Mon, 05 Jun 2006 21:54:09 +0200
Message-ID: <44848BE1.1070503@anduras.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050600040801010901040807"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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
--------------050600040801010901040807
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


Hello!

Here is a patch to allow a negated "limit", so we can match above and below the
limit.

It adds a new "flags" variable after the burst. I'm not sure, if I can add it
after the "*master" variable, so I added it here.
Does this preserve compatibility, because anything after is only used by the kernel?


struct xt_rateinfo {
        u_int32_t avg;    /* Average secs between packets * scale */
        u_int32_t burst;  /* Period multiplier for upper limit. */
        u_int8_t flags;   /* Match if, below or above limit? */

        /* Used internally by the kernel */
        unsigned long prev;
        u_int32_t credit;
        u_int32_t credit_cap, cost;

        /* Ugly, ugly fucker. */
        struct xt_rateinfo *master;
};

The patch is against 2.6.16.19.

Any comments? (I will post the patch for the iptables program, if I'm sure about
the position of the 'flags' variable...).


Regards
 Sven Anders

- --
 Sven Anders <anders@anduras.de>                 () Ascii Ribbon Campaign
                                                 /\ Support plain text e-mail
 ANDURAS service solutions AG
 Innstraße 71 - 94036 Passau - Germany
 Web: www.anduras.de - Tel: +49 (0)851-4 90 50-0 - Fax: +49 (0)851-4 90 50-55
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.1 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFEhIvg5lKZ7Feg4EcRAvC9AJ4oZbEYNYPzvwO49W6q/Zsuc8kuXQCfYVLH
npQt1K4pX0O6LAG786GZixE=
=sehO
-----END PGP SIGNATURE-----

--------------050600040801010901040807
Content-Type: text/x-diff;
 name="limit.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="limit.patch"

--- /usr/src/linux-2.6.16.19-vanilla/include/linux/netfilter/xt_limit.h	2006-05-31 02:31:44.000000000 +0200
+++ /usr/src/linux-2.6.16.19-patched/include/linux/netfilter/xt_limit.h	2006-06-05 21:34:06.942212274 +0200
@@ -4,11 +4,16 @@
 /* timings are in milliseconds. */
 #define XT_LIMIT_SCALE 10000
 
+/* invert match? */
+#define XT_LIMIT_MATCH_BELOW  0x00
+#define XT_LIMIT_MATCH_ABOVE  0x01
+
 /* 1/10,000 sec period => max of 10,000/sec.  Min rate is then 429490
    seconds, or one every 59 hours. */
 struct xt_rateinfo {
 	u_int32_t avg;    /* Average secs between packets * scale */
 	u_int32_t burst;  /* Period multiplier for upper limit. */
+	u_int8_t flags;   /* Match if, below or above limit? */
 
 	/* Used internally by the kernel */
 	unsigned long prev;
--- /usr/src/linux-2.6.16.19-vanilla/net/netfilter/xt_limit.c	2006-05-31 02:31:44.000000000 +0200
+++ /usr/src/linux-2.6.16.19-patched/net/netfilter/xt_limit.c	2006-06-05 21:34:42.631296000 +0200
@@ -3,7 +3,9 @@
  * 2 September 1999: Changed from the target RATE to the match
  *                   `limit', removed logging.  Did I mention that
  *                   Alexey is a fucking genius?
- *                   Rusty Russell (rusty@rustcorp.com.au).  */
+ *                   Rusty Russell (rusty@rustcorp.com.au).
+ * 8 September 2004: Added inversion, Sven Anders <anders@anduras.de>
+ */
 
 /* (C) 1999 Jérôme de Vivie <devivie@info.enserb.u-bordeaux.fr>
  * (C) 1999 Hervé Eychenne <eychenne@info.enserb.u-bordeaux.fr>
@@ -74,6 +76,7 @@
 		int *hotdrop)
 {
 	struct xt_rateinfo *r = ((struct xt_rateinfo *)matchinfo)->master;
+	struct xt_rateinfo *info = (struct xt_rateinfo *)matchinfo;
 	unsigned long now = jiffies;
 
 	spin_lock_bh(&limit_lock);
@@ -85,11 +88,11 @@
 		/* We're not limited. */
 		r->credit -= r->cost;
 		spin_unlock_bh(&limit_lock);
-		return 1;
+		return !(info->flags & XT_LIMIT_MATCH_ABOVE);
 	}
 
        	spin_unlock_bh(&limit_lock);
-	return 0;
+	return (info->flags & XT_LIMIT_MATCH_ABOVE);
 }
 
 /* Precision saver. */
--- /usr/src/linux-2.6.16.19-vanilla/include/linux/netfilter_ipv4/ipt_limit.h	2006-05-31 02:31:44.000000000 +0200
+++ /usr/src/linux-2.6.16.19-patched/include/linux/netfilter_ipv4/ipt_limit.h	2006-06-05 21:37:04.895726230 +0200
@@ -3,6 +3,8 @@
 
 #include <linux/netfilter/xt_limit.h>
 #define IPT_LIMIT_SCALE XT_LIMIT_SCALE
+#define IPT_LIMIT_MATCH_BELOW XT_LIMIT_MATCH_BELOW
+#define IPT_LIMIT_MATCH_ABOVE XT_LIMIT_MATCH_ABOVE
 #define ipt_rateinfo xt_rateinfo
 
 #endif /*_IPT_RATE_H*/
--- /usr/src/linux-2.6.16.19-vanilla/include/linux/netfilter_ipv6/ip6t_limit.h	2006-05-31 02:31:44.000000000 +0200
+++ /usr/src/linux-2.6.16.19-patched/include/linux/netfilter_ipv6/ip6t_limit.h	2006-06-05 21:38:36.307011415 +0200
@@ -3,6 +3,8 @@
 
 #include <linux/netfilter/xt_limit.h>
 #define IP6T_LIMIT_SCALE XT_LIMIT_SCALE
+#define IP6T_LIMIT_MATCH_BELOW XT_LIMIT_MATCH_BELOW
+#define IP6T_LIMIT_MATCH_ABOVE XT_LIMIT_MATCH_ABOVE
 #define ip6t_rateinfo xt_rateinfo
 
 #endif /*_IP6T_RATE_H*/

--------------050600040801010901040807--
