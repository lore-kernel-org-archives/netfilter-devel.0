From: Brad Fisher <brad@info-link.net>
Subject: Re: Patch with additional options for quota match
Date: Mon, 28 Apr 2003 16:49:00 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EADA1CC.32177E6F@info-link.net>
References: <3E9DCA15.40C99A6C@info-link.net> <20030427124055.GX990@sunbeam.de.gnumonks.org> <3EAD9895.6020408@aos.net.au>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------F5DCBF51296841475876C39C"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Sam Johnston <samj@aos.net.au>
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
--------------F5DCBF51296841475876C39C
Content-Type: multipart/alternative;
 boundary="------------F8A2F74CCB61BC696B7F6F20"


--------------F8A2F74CCB61BC696B7F6F20
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Sam, I sent you an email earlier following Harald's request.  I did neglect
to attach the patches to that email, sorry.  The patches should be attached
to this email.  Let me know if you need anything else.

The negated match has been very useful for my purposes.  I have been using it
to track quotas for individual hosts by ip as follows:

INPUT:
     target     prot opt in     out     source               destination
     i_1.0.0.1  all  --  *      eth1    1.0.0.1              0.0.0.0/0

FORWARD:
     target     prot opt in     out     source               destination
     i_1.0.0.1  all  --  *      eth1    1.0.0.1              0.0.0.0/0
     o_1.0.0.1  all  --  *      eth1    0.0.0.0/0            1.0.0.1

OUTUT:
    target     prot opt in     out     source               destination
    o_1.0.0.1  all  --  *      eth1    0.0.0.0/0            1.0.0.1

i_1.0.0.1:
    target     prot opt in     out     source               destination
    q_1.0.0.1  all  --  *      *       0.0.0.0/0            0.0.0.0/0
    ACCEPT     all  --  *      *       0.0.0.0/0            0.0.0.0/0

o_1.0.0.1:
    target     prot opt in     out     source               destination
    q_1.0.0.1  all  --  *      *       0.0.0.0/0            0.0.0.0/0
    ACCEPT     all  --  *      *       0.0.0.0/0            0.0.0.0/0

q_1.0.0.1:
    target     prot opt in     out     source               destination
    DROP       all  --  *      *       0.0.0.0/0
0.0.0.0/0          quota: !8000000 bytes (incl. headers)

If the quota rule in the q_1.0.0.1 chain matches (ie. the quota is
exhausted), the packet is dropped.  By using the three chains (i_*, o_*,
q_*),  all traffic to/from the ip is accounted for and the quotas are
enforced for all incoming and outgoing traffic with the same rule.

Brad Fisher
Info Link Inc.


Sam Johnston wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Harald Welte wrote:
>
> | On Wed, Apr 16, 2003 at 04:24:37PM -0500, Brad Fisher wrote:
> |
> |>I have made up a small patch for the quota match by Sam Johnston to add
> |>a couple of options I find useful - negated matching and the option to
> |>count total packet size (data + headers) instead of just data size.
> |
> |
> | I don't want to include this without the orignal author's permission.
> | Please contact Sam Johnston about your changes and ask him if he agrees
> | with those changes.
>
> Harald,
>
> Thankyou for confirming changes with me. I haven't seen this patch, so
> can someone please forward it on. The changes requested sound reasonable
> in principal - for most applications counting the headers is probably
> what is intended although this is a change in functionality. I'm not
> sure about the applications for negated matching but no doubt someone
> somewhere will find it useful.
>
> Sam
>
> - --
> Sam Johnston, Director
> Australian Online Solutions
> 1300 132 809
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.2.1 (MingW32)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org
>
> iD8DBQE+rZiVj4XJViLpTR0RAmW3AJ48YYYbgoNHI0bc18nRd4rszsmtTQCfcoeN
> 4mg8d/NVh50OSF9A2fMPTHY=
> =obWm
> -----END PGP SIGNATURE-----

--------------F8A2F74CCB61BC696B7F6F20
Content-Type: text/html; charset=us-ascii
Content-Transfer-Encoding: 7bit

<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<html>
<tt>Sam, I sent you an email earlier following Harald's request.&nbsp;
I did neglect to attach the patches to that email, sorry.&nbsp; The patches
should be attached to this email.&nbsp; Let me know if you need anything
else.</tt><tt></tt>
<p><tt>The negated match has been very useful for my purposes.&nbsp; I
have been using it to track quotas for individual hosts by ip as follows:</tt><tt></tt>
<p><tt>INPUT:</tt>
<br><tt>&nbsp;&nbsp;&nbsp;&nbsp; target&nbsp;&nbsp;&nbsp;&nbsp; prot opt
in&nbsp;&nbsp;&nbsp;&nbsp; out&nbsp;&nbsp;&nbsp;&nbsp; source&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
destination</tt>
<br><tt>&nbsp;&nbsp;&nbsp;&nbsp; i_1.0.0.1&nbsp; all&nbsp; --&nbsp; *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
eth1&nbsp;&nbsp;&nbsp; 1.0.0.1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
0.0.0.0/0</tt><tt></tt>
<p><tt>FORWARD:</tt>
<br><tt>&nbsp;&nbsp;&nbsp;&nbsp; target&nbsp;&nbsp;&nbsp;&nbsp; prot opt
in&nbsp;&nbsp;&nbsp;&nbsp; out&nbsp;&nbsp;&nbsp;&nbsp; source&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
destination</tt>
<br><tt>&nbsp;&nbsp;&nbsp;&nbsp; i_1.0.0.1&nbsp; all&nbsp; --&nbsp; *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
eth1&nbsp;&nbsp;&nbsp; 1.0.0.1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
0.0.0.0/0</tt>
<br><tt>&nbsp;&nbsp;&nbsp;&nbsp; o_1.0.0.1&nbsp; all&nbsp; --&nbsp; *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
eth1&nbsp;&nbsp;&nbsp; 0.0.0.0/0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
1.0.0.1</tt><tt></tt>
<p><tt>OUTUT:</tt>
<br><tt>&nbsp;&nbsp;&nbsp; target&nbsp;&nbsp;&nbsp;&nbsp; prot opt in&nbsp;&nbsp;&nbsp;&nbsp;
out&nbsp;&nbsp;&nbsp;&nbsp; source&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
destination</tt>
<br><tt>&nbsp;&nbsp;&nbsp; o_1.0.0.1&nbsp; all&nbsp; --&nbsp; *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
eth1&nbsp;&nbsp;&nbsp; 0.0.0.0/0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
1.0.0.1</tt><tt></tt>
<p><tt>i_1.0.0.1:</tt>
<br><tt>&nbsp;&nbsp;&nbsp; target&nbsp;&nbsp;&nbsp;&nbsp; prot opt in&nbsp;&nbsp;&nbsp;&nbsp;
out&nbsp;&nbsp;&nbsp;&nbsp; source&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
destination</tt>
<br><tt>&nbsp;&nbsp;&nbsp; q_1.0.0.1&nbsp; all&nbsp; --&nbsp; *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.0.0.0/0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
0.0.0.0/0</tt>
<br><tt>&nbsp;&nbsp;&nbsp; ACCEPT&nbsp;&nbsp;&nbsp;&nbsp; all&nbsp; --&nbsp;
*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.0.0.0/0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
0.0.0.0/0</tt><tt></tt>
<p><tt>o_1.0.0.1:</tt>
<br><tt>&nbsp;&nbsp;&nbsp; target&nbsp;&nbsp;&nbsp;&nbsp; prot opt in&nbsp;&nbsp;&nbsp;&nbsp;
out&nbsp;&nbsp;&nbsp;&nbsp; source&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
destination</tt>
<br><tt>&nbsp;&nbsp;&nbsp; q_1.0.0.1&nbsp; all&nbsp; --&nbsp; *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.0.0.0/0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
0.0.0.0/0</tt>
<br><tt>&nbsp;&nbsp;&nbsp; ACCEPT&nbsp;&nbsp;&nbsp;&nbsp; all&nbsp; --&nbsp;
*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.0.0.0/0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
0.0.0.0/0</tt><tt></tt>
<p><tt>q_1.0.0.1:</tt>
<br><tt>&nbsp;&nbsp;&nbsp; target&nbsp;&nbsp;&nbsp;&nbsp; prot opt in&nbsp;&nbsp;&nbsp;&nbsp;
out&nbsp;&nbsp;&nbsp;&nbsp; source&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
destination</tt>
<br><tt>&nbsp;&nbsp;&nbsp; DROP&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; all&nbsp;
--&nbsp; *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
0.0.0.0/0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
0.0.0.0/0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; quota:
!8000000 bytes (incl. headers)</tt><tt></tt>
<p><tt>If the quota rule in the q_1.0.0.1 chain matches (ie. the quota
is exhausted), the packet is dropped.&nbsp; By using the three chains (i_*,
o_*, q_*),&nbsp; all traffic to/from the ip is accounted for and the quotas
are enforced for all incoming and outgoing traffic with the same rule.</tt><tt></tt>
<p><tt>Brad Fisher</tt>
<br><tt>Info Link Inc.</tt>
<br><tt></tt>&nbsp;<tt></tt>
<p><tt>Sam Johnston wrote:</tt>
<blockquote TYPE=CITE>-----BEGIN PGP SIGNED MESSAGE-----
<br>Hash: SHA1
<p>Harald Welte wrote:
<p>| On Wed, Apr 16, 2003 at 04:24:37PM -0500, Brad Fisher wrote:
<br>|
<br>|>I have made up a small patch for the quota match by Sam Johnston
to add
<br>|>a couple of options I find useful - negated matching and the option
to
<br>|>count total packet size (data + headers) instead of just data size.
<br>|
<br>|
<br>| I don't want to include this without the orignal author's permission.
<br>| Please contact Sam Johnston about your changes and ask him if he
agrees
<br>| with those changes.
<p>Harald,
<p>Thankyou for confirming changes with me. I haven't seen this patch,
so
<br>can someone please forward it on. The changes requested sound reasonable
<br>in principal - for most applications counting the headers is probably
<br>what is intended although this is a change in functionality. I'm not
<br>sure about the applications for negated matching but no doubt someone
<br>somewhere will find it useful.
<p>Sam
<p>- --
<br>Sam Johnston, Director
<br>Australian Online Solutions
<br>1300 132 809
<p>-----BEGIN PGP SIGNATURE-----
<br>Version: GnuPG v1.2.1 (MingW32)
<br>Comment: Using GnuPG with Mozilla - <a href="http://enigmail.mozdev.org">http://enigmail.mozdev.org</a>
<p>iD8DBQE+rZiVj4XJViLpTR0RAmW3AJ48YYYbgoNHI0bc18nRd4rszsmtTQCfcoeN
<br>4mg8d/NVh50OSF9A2fMPTHY=
<br>=obWm
<br>-----END PGP SIGNATURE-----</blockquote>
</html>

--------------F8A2F74CCB61BC696B7F6F20--

--------------F5DCBF51296841475876C39C
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

--------------F5DCBF51296841475876C39C
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

--------------F5DCBF51296841475876C39C--
