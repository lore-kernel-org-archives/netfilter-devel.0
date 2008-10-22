From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 03/03: restore lost ifdef guarding defrag exception
Date: Wed, 22 Oct 2008 19:41:31 +0200 (MEST)
Message-ID: <20081022174130.21341.48347.sendpatchset@x2.localnet>
References: <20081022174126.21341.38231.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58296 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759002AbYJVRlc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:41:32 -0400
In-Reply-To: <20081022174126.21341.38231.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 3f3fb9fddbcb725482679fe3552e3003494c2d85
Author: Patrick McHardy <kaber@trash.net>
Date:   Wed Oct 22 19:36:23 2008 +0200

    netfilter: restore lost #ifdef guarding defrag exception
    
    Upstream commit 38f7ac3eb:
    
    Nir Tzachar <nir.tzachar@gmail.com> reported a warning when sending
    fragments over loopback with NAT:
    
    [ 6658.338121] WARNING: at net/ipv4/netfilter/nf_nat_standalone.c:89 nf_nat_fn+0x33/0x155()
    
    The reason is that defragmentation is skipped for already tracked connections.
    This is wrong in combination with NAT and ip_conntrack actually had some ifdefs
    to avoid this behaviour when NAT is compiled in.
    
    The entire "optimization" may seem a bit silly, for now simply restoring the
    lost #ifdef is the easiest solution until we can come up with something better.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 5a955c4..7eb0b61 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -150,10 +150,12 @@ static unsigned int ipv4_conntrack_defrag(unsigned int hooknum,
 					  const struct net_device *out,
 					  int (*okfn)(struct sk_buff *))
 {
+#if !defined(CONFIG_NF_NAT) && !defined(CONFIG_NF_NAT_MODULE)
 	/* Previously seen (loopback)?  Ignore.  Do this before
 	   fragment check. */
 	if (skb->nfct)
 		return NF_ACCEPT;
+#endif
 
 	/* Gather fragments. */
 	if (ip_hdr(skb)->frag_off & htons(IP_MF | IP_OFFSET)) {
