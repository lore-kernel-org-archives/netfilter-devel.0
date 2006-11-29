From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 09/33]: nf_conntrack: minor __nf_ct_refresh_acct()
	whitespace cleanup
Date: Wed, 29 Nov 2006 03:08:58 +0100 (MET)
Message-ID: <20061129020857.21082.84804.sendpatchset@localhost.localdomain>
References: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: minor __nf_ct_refresh_acct() whitespace cleanup

Minor whitespace cleanup.

Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 01d88c08b8b25a08c7e2b3520ebc8e83ec4b3888
tree 759bbdf121cebe29c688cb50f2f16164edc2b966
parent fa685ac2d1dfe17d62464fd28c8151df5d323e47
author Martin Josefsson <gandalf@wlug.westbo.se> Tue, 28 Nov 2006 23:13:02 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 28 Nov 2006 23:57:08 +0100

 net/netfilter/nf_conntrack_core.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index ab161b7..355b330 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -877,9 +877,10 @@ #ifdef CONFIG_NF_CT_ACCT
 		ct->counters[CTINFO2DIR(ctinfo)].packets++;
 		ct->counters[CTINFO2DIR(ctinfo)].bytes +=
 			skb->len - (unsigned int)(skb->nh.raw - skb->data);
-	if ((ct->counters[CTINFO2DIR(ctinfo)].packets & 0x80000000)
-	    || (ct->counters[CTINFO2DIR(ctinfo)].bytes & 0x80000000))
-		event |= IPCT_COUNTER_FILLING;
+
+		if ((ct->counters[CTINFO2DIR(ctinfo)].packets & 0x80000000)
+		    || (ct->counters[CTINFO2DIR(ctinfo)].bytes & 0x80000000))
+			event |= IPCT_COUNTER_FILLING;
 	}
 #endif
 
