From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 01/03: restore lost
Date: Tue, 14 Oct 2008 16:48:46 +0200 (MEST)
Message-ID: <20081014144844.27355.98122.sendpatchset@x2.localnet>
References: <20081014144843.27355.98898.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38314 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbYJNOsr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Oct 2008 10:48:47 -0400
In-Reply-To: <20081014144843.27355.98898.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 88e2364d9db799fec118e5a97f282762cdfb0d1a
Author: Patrick McHardy <kaber@trash.net>
Date:   Mon Oct 13 15:43:20 2008 +0200

    netfilter: restore lost #ifdef guarding defrag exception
    
    Nir Tzachar <nir.tzachar@gmail.com> reported a warning when sending
    fragments over loopback with NAT:
    
    [ 6658.338121] WARNING: at net/ipv4/netfilter/nf_nat_standalone.c:89 nf_nat_fn+0x33/0x155()
    
    The reason is that defragmentation is skipped for already tracked connections.
    This is wrong in combination with NAT and ip_conntrack actually had some ifdefs
    to avoid this behaviour when NAT is compiled in.
    
    The entire "optimization" may seem a bit silly, for now simply restoring the
    lost #ifdef is the easiest solution until we can come up with something better.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index aa2c50a..fa2d6b6 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -41,12 +41,13 @@ static unsigned int ipv4_conntrack_defrag(unsigned int hooknum,
 					  int (*okfn)(struct sk_buff *))
 {
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+#if !defined(CONFIG_NF_NAT) && !defined(CONFIG_NF_NAT_MODULE)
 	/* Previously seen (loopback)?  Ignore.  Do this before
 	   fragment check. */
 	if (skb->nfct)
 		return NF_ACCEPT;
 #endif
-
+#endif
 	/* Gather fragments. */
 	if (ip_hdr(skb)->frag_off & htons(IP_MF | IP_OFFSET)) {
 		if (nf_ct_ipv4_gather_frags(skb,
