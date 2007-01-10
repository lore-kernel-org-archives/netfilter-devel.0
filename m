From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/04]: nf_conntrack_ipv6: fix crash when handling
	fragments
Date: Wed, 10 Jan 2007 08:04:47 +0100 (MET)
Message-ID: <20070110070447.13495.61360.sendpatchset@localhost.localdomain>
References: <20070110070444.13495.95670.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: stable@kernel.org
In-Reply-To: <20070110070444.13495.95670.sendpatchset@localhost.localdomain>
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
commit 19dd639a05e28a91962032bcb820437068023095
tree 163ff8250c4f4143fd6af3c43fe8df77f3970d10
parent 8d63ea0b410fed5a1d7493fa139592394ad01664
author Patrick McHardy <kaber@trash.net> Wed, 10 Jan 2007 05:43:52 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 10 Jan 2007 05:43:52 +0100

 net/ipv6/netfilter/nf_conntrack_reasm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index bf93c1e..7745caf 100644
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
