From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 32/69]: nf_conntrack_ipv6: fix sparse warnings
Date: Wed, 30 Jan 2008 21:17:44 +0100 (MET)
Message-ID: <20080130201741.29874.306.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60726 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762830AbYA3URp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:17:45 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_ipv6: fix sparse warnings

  CHECK   net/ipv6/netfilter/nf_conntrack_reasm.c
  net/ipv6/netfilter/nf_conntrack_reasm.c:77:18: warning: symbol 'nf_ct_ipv6_sysctl_table' was not declared. Should it be static?
  net/ipv6/netfilter/nf_conntrack_reasm.c:586:16: warning: symbol 'nf_ct_frag6_gather' was not declared. Should it be static?
  net/ipv6/netfilter/nf_conntrack_reasm.c:662:6: warning: symbol 'nf_ct_frag6_output' was not declared. Should it be static?
  net/ipv6/netfilter/nf_conntrack_reasm.c:683:5: warning: symbol 'nf_ct_frag6_kfree_frags' was not declared. Should it be static?
  net/ipv6/netfilter/nf_conntrack_reasm.c:698:5: warning: symbol 'nf_ct_frag6_init' was not declared. Should it be static?
  net/ipv6/netfilter/nf_conntrack_reasm.c:717:6: warning: symbol 'nf_ct_frag6_cleanup' was not declared. Should it be static?

Based on patch by Stephen Hemminger with suggestions by Yasuyuki KOZAKAI.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ec8971e984194b97af037d06dc40a23f9581276b
tree 12aa4bdb71e3226153aa2a47d90ae168757f4e8c
parent e31ab9c086cec05ec66429e4d60a12cb60615c0e
author Patrick McHardy <kaber@trash.net> Tue, 29 Jan 2008 16:22:09 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:05 +0100

 net/ipv6/netfilter/nf_conntrack_reasm.c |   16 +---------------
 1 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 022da6c..2a0d698 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -39,6 +39,7 @@
 #include <net/rawv6.h>
 #include <net/ndisc.h>
 #include <net/addrconf.h>
+#include <net/netfilter/ipv6/nf_conntrack_ipv6.h>
 #include <linux/sysctl.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv6.h>
@@ -680,21 +681,6 @@ void nf_ct_frag6_output(unsigned int hooknum, struct sk_buff *skb,
 	nf_conntrack_put_reasm(skb);
 }
 
-int nf_ct_frag6_kfree_frags(struct sk_buff *skb)
-{
-	struct sk_buff *s, *s2;
-
-	for (s = NFCT_FRAG6_CB(skb)->orig; s; s = s2) {
-
-		s2 = s->next;
-		kfree_skb(s);
-	}
-
-	kfree_skb(skb);
-
-	return 0;
-}
-
 int nf_ct_frag6_init(void)
 {
 	nf_frags.hashfn = nf_hashfn;
