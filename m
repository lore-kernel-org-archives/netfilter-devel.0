From: Matthias Juchem <lists@konfido.de>
Subject: [PATCH 2.4] Trivial: kill __FUNCTION__ warnings in ip_nat_helper.c
Date: Thu, 19 Jun 2003 13:30:09 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <200306191326.09187.lists@konfido.de>
Reply-To: Matthias Juchem <lists@konfido.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Id: netfilter-devel.vger.kernel.org

Hi there.

The attached patch kills two warnings (produced by gcc 3.3):

ip_nat_helper.c:493: warning: concatenation of string literals with 
__FUNCTION__ is deprecated
ip_nat_helper.c:577: warning: concatenation of string literals with 
__FUNCTION__ is deprecated

Diff is against 2.4.21.

Regards,
 Matthias

diff -urN linux-2.4.21-vanilla/net/ipv4/netfilter/ip_nat_helper.c 
linux-2.4.21/net/ipv4/netfilter/ip_nat_helper.c
--- linux-2.4.21-vanilla/net/ipv4/netfilter/ip_nat_helper.c     2003-06-19 
11:53:43.000000000 +0200
+++ linux-2.4.21/net/ipv4/netfilter/ip_nat_helper.c     2003-06-19 
12:37:26.000000000 +0200
@@ -488,9 +488,9 @@
                        const char *tmp = me->me->name;

                        if (strlen(tmp) + 6 > MODULE_MAX_NAMELEN) {
-                               printk(__FUNCTION__ ": unable to "
-                                      "compute conntrack helper name "
-                                      "from %s\n", tmp);
+                               printk("%s: unable to compute conntrack "
+                                      "helper name from %s\n",
+                                      __FUNCTION__, tmp);
                                return -EBUSY;
                        }
                        tmp += 6;
@@ -573,7 +573,8 @@
                    && ct_helper->me) {
                        __MOD_DEC_USE_COUNT(ct_helper->me);
                } else
-                       printk(__FUNCTION__ ": unable to decrement usage 
count"
-                              " of conntrack helper %s\n", me->me->name);
+                       printk("%s: unable to decrement usage count of "
+                              "conntrack helper %s\n",
+                              __FUNCTION__, me->me->name);
        }
 }
