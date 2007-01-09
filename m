From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/04]: nf_conntrack_ipv6: fix crash when handling
	fragments
Date: Tue,  9 Jan 2007 17:29:53 +0100 (MET)
Message-ID: <20070109162953.6229.53706.sendpatchset@localhost.localdomain>
References: <20070109162952.6229.79602.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20070109162952.6229.79602.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack_ipv6: fix crash when handling fragments

When IPv6 connection tracking splits up a defragmented packet into
its original fragments, the packets are taken from a list and are
passed to the network stack with skb->next still set. This causes
dev_hard_start_xmit to treat them as GSO fragments, resulting in
a use after free when connection tracking handles the next fragment.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9a70cbbeb7bfa5194411b8a65b5c6372b93fa99d
tree d7ff95bc06655c96137f6c7a0eb7b2a4bae64b77
parent 3c1df52251d7d2243a88aa6ab00b6afeff666258
author Patrick McHardy <kaber@trash.net> Tue, 09 Jan 2007 11:59:59 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 09 Jan 2007 11:59:59 +0100

 net/ipv6/netfilter/nf_conntrack_reasm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 37e5fca..d9c1540 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -835,6 +835,8 @@ void nf_ct_frag6_output(unsigned int hoo
 		s->nfct_reasm = skb;
 
 		s2 = s->next;
+		s->next = NULL;
+
 		NF_HOOK_THRESH(PF_INET6, hooknum, s, in, out, okfn,
 			       NF_IP6_PRI_CONNTRACK_DEFRAG + 1);
 		s = s2;
