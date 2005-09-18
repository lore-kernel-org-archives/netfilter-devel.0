From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] TARPIT cleanups
Date: Sun, 18 Sep 2005 10:07:15 -0700
Message-ID: <20050918170715.GA19936@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="OgqxwSJOaUobr8KG"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

TARPIT target doesn't compile with 2.6.14-rc due to nfcache references,
and also doesn't compile if CONFIG_SYSCTL is not set.  Below patch
fixes both, and closes bugzilla #387.

Phil



--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-tarpit

diff -ru pom-orig/patchlets/TARPIT/linux-2.6/net/ipv4/netfilter/ipt_TARPIT.c pom-new/patchlets/TARPIT/linux-2.6/net/ipv4/netfilter/ipt_TARPIT.c
--- pom-orig/patchlets/TARPIT/linux-2.6/net/ipv4/netfilter/ipt_TARPIT.c	2005-05-17 13:08:12.000000000 -0700
+++ pom-new/patchlets/TARPIT/linux-2.6/net/ipv4/netfilter/ipt_TARPIT.c	2005-09-18 10:04:35.000000000 -0700
@@ -121,7 +121,6 @@
 	/* This packet will not be the same as the other: clear nf fields */
 	nf_conntrack_put(nskb->nfct);
 	nskb->nfct = NULL;
-	nskb->nfcache = 0;
 #ifdef CONFIG_NETFILTER_DEBUG
 	nskb->nf_debug = 0;
 #endif
@@ -172,7 +171,11 @@
 						sizeof(struct tcphdr), 0));
 
 	/* Adjust IP TTL */
+#ifdef CONFIG_SYSCTL
 	nskb->nh.iph->ttl = sysctl_ip_default_ttl;
+#else
+	nskb->nh.iph->ttl = IPDEFTTL;
+#endif
 
 	/* Set DF, id = 0 */
 	nskb->nh.iph->frag_off = htons(IP_DF);

--OgqxwSJOaUobr8KG--
