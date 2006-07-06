From: Sven Anders <anders@anduras.de>
Subject: [PATCH] [POM] ipp2p/ipv4options patches
Date: Thu, 06 Jul 2006 11:24:50 +0200
Message-ID: <44ACD6E2.5010101@anduras.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050009050205010103090007"
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
--------------050009050205010103090007
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit

Hello!

Here are some patches for the latest Patch-O-Matic, which I needed for using
them with the latest stable kernel.

These are only corrections for the new function parameters and the missing
matchsize.

Regards
 Sven Anders

-- 
 Sven Anders <anders@anduras.de>                 () Ascii Ribbon Campaign
                                                 /\ Support plain text e-mail
 ANDURAS service solutions AG
 Innstraﬂe 71 - 94036 Passau - Germany
 Web: www.anduras.de - Tel: +49 (0)851-4 90 50-0 - Fax: +49 (0)851-4 90 50-55

--------------050009050205010103090007
Content-Type: text/plain;
 name="patch-o-matic-ng-20060704.patches"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-o-matic-ng-20060704.patches"

diff -u -r -N patch-o-matic-ng-20060704.vanilla/patchlets/ipp2p/linux-2.6/net/ipv4/netfilter/ipt_ipp2p.c patch-o-matic-ng-20060704/patchlets/ipp2p/linux-2.6/net/ipv4/netfilter/ipt_ipp2p.c
--- patch-o-matic-ng-20060704.vanilla/patchlets/ipp2p/linux-2.6/net/ipv4/netfilter/ipt_ipp2p.c	2006-03-29 14:42:09.000000000 +0200
+++ patch-o-matic-ng-20060704/patchlets/ipp2p/linux-2.6/net/ipv4/netfilter/ipt_ipp2p.c	2006-07-06 11:03:30.000000000 +0200
@@ -728,6 +728,7 @@
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
@@ -811,7 +812,8 @@
 
 static int
 checkentry(const char *tablename,
-            const void *ip,
+	    const void *ip,
+	    const struct xt_match *match,
 	    void *matchinfo,
 	    unsigned int matchsize,
 	    unsigned int hook_mask)
@@ -840,6 +842,7 @@
 	.name		= "ipp2p",
 	.match		= &match,
 	.checkentry	= &checkentry,
+	.matchsize	= sizeof(struct ipt_p2p_info),
 	.me		= THIS_MODULE,
 #endif
 };
diff -u -r -N patch-o-matic-ng-20060704.vanilla/patchlets/ipv4options/linux-2.6/net/ipv4/netfilter/ipt_ipv4options.c patch-o-matic-ng-20060704/patchlets/ipv4options/linux-2.6/net/ipv4/netfilter/ipt_ipv4options.c
--- patch-o-matic-ng-20060704.vanilla/patchlets/ipv4options/linux-2.6/net/ipv4/netfilter/ipt_ipv4options.c	2006-03-29 11:05:43.000000000 +0200
+++ patch-o-matic-ng-20060704/patchlets/ipv4options/linux-2.6/net/ipv4/netfilter/ipt_ipv4options.c	2006-07-06 11:04:55.000000000 +0200
@@ -25,6 +25,7 @@
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
@@ -107,6 +108,7 @@
 static int
 checkentry(const char *tablename,
 	   const void *ip,
+	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchsize,
 	   unsigned int hook_mask)
@@ -154,8 +156,9 @@
 
 static struct ipt_match ipv4options_match = { 
 	.name = "ipv4options",
-	.match = match,
-	.checkentry = checkentry,
+	.match = &match,
+	.matchsize = sizeof(struct ipt_ipv4options_info),
+	.checkentry = &checkentry,
 	.me = THIS_MODULE
 };
 

--------------050009050205010103090007--
