From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1 linux-next] netfilter: conntrack: fix kmemleak false positive
Date: Wed, 21 Sep 2016 21:49:57 +0200
Message-ID: <1474487397-11032-1-git-send-email-fabf@skynet.be>
Cc: Eric Dumazet <edumazet@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        fabf@skynet.be
To: Florian Westphal <fw@strlen.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Since commit f330a7fdbe16
("netfilter: conntrack: get rid of conntrack timer")

closed connections remain longer in /proc/net/nf_conntrack

Running current kernel; just after boot:
cat /proc/net/nf_conntrack | wc -l = 5
4 minutes required to clean up the table.

Going back to kernel version before commit above there are
no connections after some seconds.

Referring to the commit changelog this was an expected behaviour but
it results in temporary kmemleak reports:

unreferenced object 0xffff88003b0e6600 (size 248):
  comm "rsyslogd", pid 1595, jiffies 4294741312 (age 7.343s)
  ...
  backtrace:
    [<ffffffff818f0163>] kmemleak_alloc+0x23/0x40
    [<ffffffff8117abf9>] kmem_cache_alloc+0xd9/0x180
    [<ffffffff817533a8>] __nf_conntrack_alloc.isra.50+0x48/0x170
    [<ffffffff81754262>] nf_conntrack_in+0x3a2/0x5f0
    [<ffffffff817bc9e0>] ipv4_conntrack_local+0x40/0x50
    [<ffffffff8174f17d>] nf_iterate+0x5d/0x70
    [<ffffffff8174f1ef>] nf_hook_slow+0x5f/0xb0
    [<ffffffff8176ffbd>] __ip_local_out+0xad/0xe0
    [<ffffffff81770007>] ip_local_out+0x17/0x40
    [<ffffffff817711f4>] ip_send_skb+0x14/0x40
    [<ffffffff81797591>] udp_send_skb+0x91/0x260
    [<ffffffff817985e5>] udp_sendmsg+0x2f5/0x950
    [<ffffffff817a4f80>] inet_sendmsg+0x60/0x90
    [<ffffffff816fe7d3>] sock_sendmsg+0x33/0x40
    [<ffffffff816fed0e>] SYSC_sendto+0xee/0x160
    [<ffffffff816ff719>] SyS_sendto+0x9/0x10

(248 bytes being an nf_conn structure)

Those structures being cleared in gc_worker() later on we can't talk
about unreferenced object so this patch uses kmemleak_not_leak() to
prevent those warnings.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/netfilter/nf_conntrack_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 50106a1..59396f3 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1022,6 +1022,7 @@ __nf_conntrack_alloc(struct net *net,
 	 * SLAB_DESTROY_BY_RCU.
 	 */
 	ct = kmem_cache_alloc(nf_conntrack_cachep, gfp);
+	kmemleak_not_leak(ct);
 	if (ct == NULL)
 		goto out;
 
-- 
2.8.1
