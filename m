Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA77341C0D6;
	Mon,  9 Mar 2026 21:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773090569; cv=none; b=ZGTaZTx+dKgMXLdwrMzzv4CZbG8Vn0o0Ti8FIWjxyoTDMnrYBUf0THuUAm7cxuY0SmGHd9QhE8L/tl7DW8CSnQds3w7kgthg9Sc10zV/nyOfadZDMCsCmV1Fi6l3AjiCqJCJ5C75UxvPvnt3EV+rESUXKLa530Oc42BvYo3f/p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773090569; c=relaxed/simple;
	bh=fGI+WavfHDUyNuzFT+EnOo9U0OL09ipubj8FapJreVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BaSX4Bpit8v9pct5PF31SNUqZRxjIlX/kTucmK1FdcnWdci6X4b5ILG653KKsZsnDd7IxMZ1RaT2cdaRYQh8f3AG4Kjvi3rYDQ6eGZEcVJjvI9oCG7GHYLujuYuWr8gpg1Ly6T6jYQlupxpafmz83ypzaOclkaeyKKbAFyb1A08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 770F360D30; Mon, 09 Mar 2026 22:09:26 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 09/10] netfilter: ctnetlink: fix use-after-free of exp->master in expectation dump
Date: Mon,  9 Mar 2026 22:08:44 +0100
Message-ID: <20260309210845.15657-10-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260309210845.15657-1-fw@strlen.de>
References: <20260309210845.15657-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hyunwoo Kim <imv4bel@gmail.com>

ctnetlink_exp_dump_table() iterates the expectation hash table under
rcu_read_lock and dereferences exp->master to access the master
conntrack's fields (ct_net, tuplehash, ct->ext).  However, expectations
do not hold a reference on exp->master.  A concurrent conntrack deletion
via NFNL_SUBSYS_CTNETLINK (a different nfnetlink subsystem mutex) can
free the master conntrack while the dump is in progress, leading to
use-after-free on ct->ext which is freed immediately by kfree().

Fix this by taking a reference on exp->master with
refcount_inc_not_zero() before accessing it.  If the master conntrack is
already being destroyed, skip the expectation.

KASAN report:
 BUG: KASAN: slab-use-after-free in ctnetlink_exp_dump_expect+0x584/0x660
 Read of size 1 at addr ffff888102b4ab00 by task poc2/135

 CPU: 1 UID: 0 PID: 135 Comm: poc2 Not tainted 7.0.0-rc2+ #5 PREEMPTLAZY
 Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
 Call Trace:
  ctnetlink_exp_dump_expect+0x584/0x660
  ctnetlink_exp_fill_info.constprop.0+0xf9/0x180
  ctnetlink_exp_dump_table+0x24a/0x2e0
  netlink_dump+0x333/0x880
  __netlink_dump_start+0x391/0x450
  ctnetlink_get_expect+0x393/0x3f0
  nfnetlink_rcv_msg+0x48e/0x510
  netlink_rcv_skb+0xc9/0x1f0
  nfnetlink_rcv+0xdb/0x220
  netlink_unicast+0x3ec/0x590
  netlink_sendmsg+0x397/0x690
  __sys_sendmsg+0xf4/0x180

 Allocated by task 132:
  krealloc_node_align_noprof+0x124/0x3c0
  nf_ct_ext_add+0xd8/0x1a0
  ctnetlink_create_conntrack+0x38d/0x900
  ctnetlink_new_conntrack+0x3cf/0x7d0
  nfnetlink_rcv_msg+0x48e/0x510
  netlink_rcv_skb+0xc9/0x1f0
  nfnetlink_rcv+0xdb/0x220
  netlink_unicast+0x3ec/0x590
  netlink_sendmsg+0x397/0x690
  __sys_sendmsg+0xf4/0x180
  do_syscall_64+0xc3/0x6e0
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

 Freed by task 132:
  kfree+0x1ca/0x430
  nf_conntrack_free+0xb2/0x140
  ctnetlink_del_conntrack+0x4c4/0x520
  nfnetlink_rcv_msg+0x48e/0x510
  netlink_rcv_skb+0xc9/0x1f0
  nfnetlink_rcv+0xdb/0x220
  netlink_unicast+0x3ec/0x590
  netlink_sendmsg+0x397/0x690
  __sys_sendmsg+0xf4/0x180
  do_syscall_64+0xc3/0x6e0
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

 The buggy address belongs to the object at ffff888102b4ab00
  which belongs to the cache kmalloc-128 of size 128
 The buggy address is located 0 bytes inside of
  freed 128-byte region [ffff888102b4ab00, ffff888102b4ab80)

Fixes: c1d10adb4a52 ("[NETFILTER]: Add ctnetlink port for nf_conntrack")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_netlink.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 10a9b98368f4..96e342147de8 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3167,6 +3167,7 @@ static int
 ctnetlink_exp_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct net *net = sock_net(skb->sk);
+	struct nf_conn *master;
 	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
 	u_int8_t l3proto = nfmsg->nfgen_family;
 	unsigned long last_id = cb->args[1];
@@ -3180,12 +3181,20 @@ ctnetlink_exp_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 			if (l3proto && exp->tuple.src.l3num != l3proto)
 				continue;
 
-			if (!net_eq(nf_ct_net(exp->master), net))
+			master = exp->master;
+			if (!refcount_inc_not_zero(&master->ct_general.use))
 				continue;
 
+			if (!net_eq(nf_ct_net(master), net)) {
+				nf_ct_put(master);
+				continue;
+			}
+
 			if (cb->args[1]) {
-				if (ctnetlink_exp_id(exp) != last_id)
+				if (ctnetlink_exp_id(exp) != last_id) {
+					nf_ct_put(master);
 					continue;
+				}
 				cb->args[1] = 0;
 			}
 			if (ctnetlink_exp_fill_info(skb,
@@ -3194,8 +3203,11 @@ ctnetlink_exp_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 						    IPCTNL_MSG_EXP_NEW,
 						    exp) < 0) {
 				cb->args[1] = ctnetlink_exp_id(exp);
+				nf_ct_put(master);
 				goto out;
 			}
+
+			nf_ct_put(master);
 		}
 		if (cb->args[1]) {
 			cb->args[1] = 0;
-- 
2.52.0

