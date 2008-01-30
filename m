From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/69]: nf_nat: remove double bysource hash initialization
Date: Wed, 30 Jan 2008 21:16:58 +0100 (MET)
Message-ID: <20080130201656.29874.54709.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60637 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933449AbYA3UQ7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:16:59 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_nat: remove double bysource hash initialization

The hash table is already initialized by nf_ct_alloc_hashtable().

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4639b794086800b0bef00c06c880a47be1517853
tree 70dd7a1fda33819c1b1715722ca5b77f491a7c8f
parent 6276f9ebe13419b94f58dd9ef713c1c56c74e4ca
author Patrick McHardy <kaber@trash.net> Tue, 29 Jan 2008 16:21:50 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 15:04:12 +0100

 net/ipv4/netfilter/nf_nat_core.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index e53ae1e..c07575d 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -654,10 +654,6 @@ static int __init nf_nat_init(void)
 	rcu_assign_pointer(nf_nat_protos[IPPROTO_ICMP], &nf_nat_protocol_icmp);
 	write_unlock_bh(&nf_nat_lock);
 
-	for (i = 0; i < nf_nat_htable_size; i++) {
-		INIT_HLIST_HEAD(&bysource[i]);
-	}
-
 	/* Initialize fake conntrack so that NAT will skip it */
 	nf_conntrack_untracked.status |= IPS_NAT_DONE_MASK;
 
