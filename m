From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 01/03: nf_conntrack: fix ctnetlink related crash in nf_nat_setup_info()
Date: Thu, 19 Jun 2008 15:05:43 +0200 (MEST)
Message-ID: <20080619130543.26204.13895.sendpatchset@localhost.localdomain>
References: <20080619130541.26204.54310.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65326 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628AbYFSNFp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2008 09:05:45 -0400
In-Reply-To: <20080619130541.26204.54310.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: nf_conntrack: fix ctnetlink related crash in nf_nat_setup_info()

Upstream commit ceeff7541e5a4ba8e8d97ffbae32b3f283cb7a3f

When creation of a new conntrack entry in ctnetlink fails after having
set up the NAT mappings, the conntrack has an extension area allocated
that is not getting properly destroyed when freeing the conntrack again.
This means the NAT extension is still in the bysource hash, causing a
crash when walking over the hash chain the next time:

BUG: unable to handle kernel paging request at 00120fbd
IP: [<c03d394b>] nf_nat_setup_info+0x221/0x58a
*pde = 00000000
Oops: 0000 [#1] PREEMPT SMP

Pid: 2795, comm: conntrackd Not tainted (2.6.26-rc5 #1)
EIP: 0060:[<c03d394b>] EFLAGS: 00010206 CPU: 1
EIP is at nf_nat_setup_info+0x221/0x58a
EAX: 00120fbd EBX: 00120fbd ECX: 00000001 EDX: 00000000
ESI: 0000019e EDI: e853bbb4 EBP: e853bbc8 ESP: e853bb78
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process conntrackd (pid: 2795, ti=e853a000 task=f7de10f0 task.ti=e853a000)
Stack: 00000000 e853bc2c e85672ec 00000008 c0561084 63c1db4a 00000000 00000000
       00000000 0002e109 61d2b1c3 00000000 00000000 00000000 01114e22 61d2b1c3
       00000000 00000000 f7444674 e853bc04 00000008 c038e728 0000000a f7444674
Call Trace:
 [<c038e728>] nla_parse+0x5c/0xb0
 [<c0397c1b>] ctnetlink_change_status+0x190/0x1c6
 [<c0397eec>] ctnetlink_new_conntrack+0x189/0x61f
 [<c0119aee>] update_curr+0x3d/0x52
 [<c03902d1>] nfnetlink_rcv_msg+0xc1/0xd8
 [<c0390228>] nfnetlink_rcv_msg+0x18/0xd8
 [<c0390210>] nfnetlink_rcv_msg+0x0/0xd8
 [<c038d2ce>] netlink_rcv_skb+0x2d/0x71
 [<c0390205>] nfnetlink_rcv+0x19/0x24
 [<c038d0f5>] netlink_unicast+0x1b3/0x216
 ...

Move invocation of the extension destructors to nf_conntrack_free()
to fix this problem.

Fixes http://bugzilla.kernel.org/show_bug.cgi?id=10875

Reported-and-Tested-by: Krzysztof Piotr Oledzki <ole@ans.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
commit b59adf15982f7d435e1f6c5d8352d963a6c6a93a
tree 3de35661e3263db09f7b39ed3325781fe3e403c2
parent 82745b047c35da2d0b582f0e098bea573f250490
author Patrick McHardy <kaber@trash.net> Thu, 19 Jun 2008 14:46:08 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 19 Jun 2008 14:46:08 +0200

 net/netfilter/nf_conntrack_core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 4147de6..8785784 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -199,8 +199,6 @@ destroy_conntrack(struct nf_conntrack *nfct)
 	if (l4proto && l4proto->destroy)
 		l4proto->destroy(ct);
 
-	nf_ct_ext_destroy(ct);
-
 	rcu_read_unlock();
 
 	spin_lock_bh(&nf_conntrack_lock);
@@ -523,6 +521,7 @@ static void nf_conntrack_free_rcu(struct rcu_head *head)
 
 void nf_conntrack_free(struct nf_conn *ct)
 {
+	nf_ct_ext_destroy(ct);
 	call_rcu(&ct->rcu, nf_conntrack_free_rcu);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_free);
