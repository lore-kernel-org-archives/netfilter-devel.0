From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf 3/3] netfilter: cttimeout: unlink timeout objs in the unconfirmed ct lists
Date: Mon, 22 Aug 2016 21:58:18 +0800
Message-ID: <1471874298-20503-3-git-send-email-zlpnobody@163.com>
References: <1471874298-20503-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-18.163.com ([220.181.12.18]:52082 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755278AbcHVN7R (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2016 09:59:17 -0400
In-Reply-To: <1471874298-20503-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

KASAN reported this bug:
  BUG: KASAN: use-after-free in icmp_packet+0x25/0x50 [nf_conntrack_ipv4] at
  addr ffff880002db08c8
  Read of size 4 by task lt-nf-queue/19041
  Call Trace:
  <IRQ>  [<ffffffff815eeebb>] dump_stack+0x63/0x88
  [<ffffffff813386f8>] kasan_report_error+0x528/0x560
  [<ffffffff81338cc8>] kasan_report+0x58/0x60
  [<ffffffffa07393f5>] ? icmp_packet+0x25/0x50 [nf_conntrack_ipv4]
  [<ffffffff81337551>] __asan_load4+0x61/0x80
  [<ffffffffa07393f5>] icmp_packet+0x25/0x50 [nf_conntrack_ipv4]
  [<ffffffffa06ecaa0>] nf_conntrack_in+0x550/0x980 [nf_conntrack]
  [<ffffffffa06ec550>] ? __nf_conntrack_confirm+0xb10/0xb10 [nf_conntrack]
  [ ... ]

The main reason is that we missed to unlink the timeout objects in the
unconfirmed ct lists, so we will access the timeout objects that have
already been freed.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nfnetlink_cttimeout.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 6844c7a..139e086 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -302,7 +302,16 @@ static void ctnl_untimeout(struct net *net, struct ctnl_timeout *timeout)
 	const struct hlist_nulls_node *nn;
 	unsigned int last_hsize;
 	spinlock_t *lock;
-	int i;
+	int i, cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct ct_pcpu *pcpu = per_cpu_ptr(net->ct.pcpu_lists, cpu);
+
+		spin_lock_bh(&pcpu->lock);
+		hlist_nulls_for_each_entry(h, nn, &pcpu->unconfirmed, hnnode)
+			untimeout(h, timeout);
+		spin_unlock_bh(&pcpu->lock);
+	}
 
 	local_bh_disable();
 restart:
-- 
2.5.5


