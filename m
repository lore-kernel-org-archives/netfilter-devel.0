From: Brad Fisher <brad@info-link.net>
Subject: Patch with additional options for quota match
Date: Wed, 16 Apr 2003 16:24:37 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E9DCA15.40C99A6C@info-link.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------C05BDC3C49D6FBA041B1AEDC"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------C05BDC3C49D6FBA041B1AEDC
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

I have made up a small patch for the quota match by Sam Johnston to add
a couple of options I find useful - negated matching and the option to
count total packet size (data + headers) instead of just data size.
Examples:

# Old behavior, ACCEPT packets UNTIL 5000000 quota has been consumed
iptables -A INPUT -m quota --quota 5000000 -j ACCEPT

# Negated match, DROP packets AFTER 5000000 quota has been consumed
#  Does not count packet headers when calculating the quota.
#  Lets packets pass as long as the remaining quota > 0
iptables -A INPUT -m quota --quota ! 5000000 -j DROP

# Negated match, DROP packets AFTER 5000000 quota has been consumed
#  Packet headers are counted in the quota.
#  Lets packets pass as long as the remaining quota > 0
iptables -A INPUT -m quota --quota ! 5000000 --count-headers -j DROP

The patches should apply cleanly to the iptables-1.2.7a and
patch-o-matic-20030107 distributions.

Brad Fisher
Info Link Inc.


--------------C05BDC3C49D6FBA041B1AEDC
Content-Type: text/plain; charset=us-ascii;
 name="iptables-libipt_quota.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-libipt_quota.diff"

--- iptables-1.2.7a/extensions/libipt_quota.c	Wed May 29 08:08:16 2002
+++ iptables-1.2.7a-imq/extensions/libipt_quota.c	Wed Apr 16 15:11:05 2003
@@ -2,6 +2,7 @@
  * Shared library add-on to iptables to add quota support
  *
  * Sam Johnston <samj@samj.net>
+ * (Modified to support negated matches and add option to count headers by Brad Fisher (brad@info-link.net))
  */
 #include <stdio.h>
 #include <stdlib.h>
@@ -13,6 +14,7 @@
 
 static struct option opts[] = {
         {"quota", 1, 0, '1'},
+        {"count-headers", 0, 0, '2'},
         {0}
 };
 
@@ -21,7 +23,8 @@
 help(void)
 {
         printf("quota options:\n"
-               " --quota quota                  quota (bytes)\n" "\n");
+               " --quota [!] quota              quota (bytes)\n"
+               " --count-headers                count headers as well as data\n" "\n");
 }
 
 /* initialise match */
@@ -37,7 +40,18 @@
 print(const struct ipt_ip *ip, const struct ipt_entry_match *match, int numeric)
 {
         struct ipt_quota_info *q = (struct ipt_quota_info *) match->data;
-        printf("quota: %llu bytes", (unsigned long long) q->quota);
+        char *negate = "";
+        char *headers = "";
+
+        if (q->flags & IPT_QUOTA_FLAG_NEGATE) {
+          negate = "!";
+        }
+
+        if (q->flags & IPT_QUOTA_FLAG_COUNT_FULL) {
+          headers = " (incl. headers)";
+        }
+
+        printf("quota: %s%llu bytes%s", negate, (unsigned long long) q->quota, headers);
 }
 
 /* save matchinfo */
@@ -45,14 +59,28 @@
 save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
 {
         struct ipt_quota_info *q = (struct ipt_quota_info *) match->data;
-        printf("--quota %llu ", (unsigned long long) q->quota);
+
+        printf("--quota ");
+        if (q->flags & IPT_QUOTA_FLAG_NEGATE) {
+                printf("! ");
+        }
+        printf("%llu ", (unsigned long long) q->quota);
+
+        if (q->flags & IPT_QUOTA_FLAG_COUNT_FULL) {
+                printf("--count-headers ");
+        }
 }
 
 /* parse quota option */
 static int
 parse_quota(const char *s, u_int64_t * quota)
 {
-        *quota = strtoull(s, (char **) NULL, 10);
+        /* Don't allow negative quotas... Not perfect since it doesn't skip whitespace */
+        if (s && (*s == '-')) {
+                *quota = -1;
+        } else {
+                *quota = strtoull(s, (char **) NULL, 10);
+        }
 
 #ifdef DEBUG_IPT_QUOTA
         printf("Quota: %llu\n", *quota);
@@ -74,12 +102,20 @@
 
         switch (c) {
         case '1':
-                if (check_inverse(optarg, &invert, NULL, 0))
-                        exit_error(PARAMETER_PROBLEM, "quota: unexpected '!'");
-                if (!parse_quota(optarg, &info->quota))
+                check_inverse(optarg, &invert, &optind, 0);
+                if (invert) {
+                        info->flags |= IPT_QUOTA_FLAG_NEGATE;
+                }
+                if (!parse_quota(argv[optind-1], &info->quota))
                         exit_error(PARAMETER_PROBLEM,
                                    "bad quota: '%s'", optarg);
                 break;
+
+        case '2':
+                if (check_inverse(optarg, &invert, NULL, 0))
+                        exit_error(PARAMETER_PROBLEM, "count-headers: unexpected '!'");
+                info->flags |= IPT_QUOTA_FLAG_COUNT_FULL;
+                break;
 
         default:
                 return 0;

--------------C05BDC3C49D6FBA041B1AEDC
Content-Type: text/plain; charset=us-ascii;
 name="patch-o-matic-20030107-quota.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-o-matic-20030107-quota.diff"

diff -urN patch-o-matic-20030107/base/quota.patch patch-o-matic-20030107-imq/base/quota.patch
--- patch-o-matic-20030107/base/quota.patch	Mon Dec  3 16:22:56 2001
+++ patch-o-matic-20030107-imq/base/quota.patch	Wed Apr 16 15:46:43 2003
@@ -1,26 +1,35 @@
-diff -urN kernel-source-2.4.16/include/linux/netfilter_ipv4/ipt_quota.h kernel-source-2.4.16-samj/include/linux/netfilter_ipv4/ipt_quota.h
---- kernel-source-2.4.16/include/linux/netfilter_ipv4/ipt_quota.h	Thu Jan  1 10:00:00 1970
-+++ kernel-source-2.4.16-samj/include/linux/netfilter_ipv4/ipt_quota.h	Mon Dec  3 21:43:07 2001
-@@ -0,0 +1,11 @@
+diff -urN linux-2.4.20-clean/include/linux/netfilter_ipv4/ipt_quota.h linux-2.4.20/include/linux/netfilter_ipv4/ipt_quota.h
+--- linux-2.4.20-clean/include/linux/netfilter_ipv4/ipt_quota.h	Wed Dec 31 18:00:00 1969
++++ linux-2.4.20/include/linux/netfilter_ipv4/ipt_quota.h	Wed Apr 16 13:35:52 2003
+@@ -0,0 +1,19 @@
 +#ifndef _IPT_QUOTA_H
 +#define _IPT_QUOTA_H
 +
 +/* print debug info in both kernel/netfilter module & iptable library */
 +//#define DEBUG_IPT_QUOTA
 +
++#define IPT_QUOTA_FLAG_NEGATE 1
++#define IPT_QUOTA_FLAG_COUNT_FULL 2
++
 +struct ipt_quota_info {
-+        u_int64_t quota;
++        u_int64_t quota;	/* Remaining bytes to allow */
++	u_int16_t flags;	/* Bitmask: */
++				/*   Bit 0 - negate match if set (matches if quota == 0) */
++				/*           normal match if not set (matches if quota > 0) */
++				/*   Bit 1 - include entire packet (headers + data) in count if set */
++				/*           only count data size if not set */
 +};
 +
 +#endif /*_IPT_QUOTA_H*/
-diff -urN kernel-source-2.4.16/net/ipv4/netfilter/ipt_quota.c kernel-source-2.4.16-samj/net/ipv4/netfilter/ipt_quota.c
---- kernel-source-2.4.16/net/ipv4/netfilter/ipt_quota.c	Thu Jan  1 10:00:00 1970
-+++ kernel-source-2.4.16-samj/net/ipv4/netfilter/ipt_quota.c	Mon Dec  3 21:42:08 2001
-@@ -0,0 +1,81 @@
+diff -urN linux-2.4.20-clean/net/ipv4/netfilter/ipt_quota.c linux-2.4.20/net/ipv4/netfilter/ipt_quota.c
+--- linux-2.4.20-clean/net/ipv4/netfilter/ipt_quota.c	Wed Dec 31 18:00:00 1969
++++ linux-2.4.20/net/ipv4/netfilter/ipt_quota.c	Wed Apr 16 14:07:56 2003
+@@ -0,0 +1,99 @@
 +/* 
 + * netfilter module to enforce network quotas
 + *
 + * Sam Johnston <samj@samj.net>
++ * (Modified to support negation by Brad Fisher <brad@info-link.net>)
 + */
 +#include <linux/module.h>
 +#include <linux/skbuff.h>
@@ -44,6 +53,10 @@
 +
 +        struct ipt_quota_info *q = (struct ipt_quota_info *) matchinfo;
 +
++	if (q->flags & IPT_QUOTA_FLAG_COUNT_FULL) {
++		datalen = skb->len;
++	}
++
 +        spin_lock_bh(&quota_lock);
 +
 +        if (q->quota >= datalen) {
@@ -51,20 +64,33 @@
 +                q->quota -= datalen;
 +                spin_unlock_bh(&quota_lock);
 +
++		if ((q->flags & IPT_QUOTA_FLAG_NEGATE) == 0) {
 +#ifdef DEBUG_IPT_QUOTA
-+                printk("IPT Quota OK: %llu datlen %d \n", q->quota, datalen);
++	                printk("IPT Quota OK: %llu datlen %d \n", q->quota, datalen);
 +#endif
-+                return 1;
++        	        return 1;
++		} else {
++#ifdef DEBUG_IPT_QUOTA
++		        printk("IPT Quota Failed: !%llu datlen %d \n", q->quota, datalen);
++#endif
++			return 0;
++		}
 +        }
 +
 +        /* so we do not allow even small packets from now on */
 +        q->quota = 0;
 +
++        spin_unlock_bh(&quota_lock);
++	if ((q->flags & IPT_QUOTA_FLAG_NEGATE)) {
++#ifdef DEBUG_IPT_QUOTA
++                printk("IPT Quota OK: %llu datlen !%d \n", q->quota, datalen);
++#endif
++		return 1;
++	}
++
 +#ifdef DEBUG_IPT_QUOTA
 +        printk("IPT Quota Failed: %llu datlen %d \n", q->quota, datalen);
 +#endif
-+
-+        spin_unlock_bh(&quota_lock);
 +        return 0;
 +}
 +
diff -urN patch-o-matic-20030107/base/quota.patch.help patch-o-matic-20030107-imq/base/quota.patch.help
--- patch-o-matic-20030107/base/quota.patch.help	Mon Dec  3 16:22:56 2001
+++ patch-o-matic-20030107-imq/base/quota.patch.help	Wed Apr 16 15:49:37 2003
@@ -5,6 +5,9 @@
 quotas by decrementing a byte counter with each packet.
 
 Supported options are:
---quota <bytes>
-  The quota in bytes.
-
+--quota [!] <bytes>
+  The quota in bytes.  The normal form matches all packets up to the
+    quota, while the negated form only matches after quota bytes have
+    been examined by the rule.
+--count-headers
+  Counts headers as well as data (default only counts data)

--------------C05BDC3C49D6FBA041B1AEDC--
