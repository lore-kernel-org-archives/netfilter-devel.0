Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E288936A008;
	Mon,  9 Mar 2026 21:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773090565; cv=none; b=sBYlg5Q+ecN3ERudAQZc8CQoItcKefJWiyEqQ4BxShLEjXTF9lucD0fWJ5rPM1k3e6HdIgRJl3H8K2VGw4owlcWi2E59XK3vbtmfVhQU6rNP9xrZF5DpIXnkWKl220YXWkfAnvscGjECyMh8Xdn+w+a8HNkf2Ria0PJcHH5Zwes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773090565; c=relaxed/simple;
	bh=dhgEAJUduxbNZZJHgsf1NItuMp0FsFosSresSzjbEnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPOoeOgM2SaSUEzUiWuUkYhR+kdI/GB0z0zJso5FxAqwiqJ5wWVEe2k6hGskUKFwSLdNSIbYQQ/1ROoy6oKZQRmnKogzBRXCAN83IgUop2FriGe604jJ6j6/KwF3pERaaWx/e7x0ffFsH9c0TYHR4CtaiujpAm24zLlEUJxhAR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 622AA60D2E; Mon, 09 Mar 2026 22:09:22 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 08/10] netfilter: ctnetlink: fix use-after-free of exp->master in single expectation GET
Date: Mon,  9 Mar 2026 22:08:43 +0100
Message-ID: <20260309210845.15657-9-fw@strlen.de>
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

ctnetlink_get_expect() in the non-dump path calls
nf_ct_expect_find_get() which only takes a reference on the expectation
itself, not on exp->master.  It then calls ctnetlink_exp_fill_info()
which dereferences exp->master extensively (tuplehash, ct->ext via
nfct_help()).

A concurrent conntrack deletion through NFNL_SUBSYS_CTNETLINK (a
different nfnetlink subsystem mutex than NFNL_SUBSYS_CTNETLINK_EXP) can
free the master conntrack while the single GET is in progress, leading
to use-after-free.  In particular, kfree(ct->ext) is immediate and not
RCU-deferred.

Fix this by taking a reference on exp->master under rcu_read_lock
(required for SLAB_TYPESAFE_BY_RCU) before calling
ctnetlink_exp_fill_info() and releasing it afterwards.

 BUG: KASAN: slab-use-after-free in ctnetlink_dump_tuples_ip+0xbc/0x1f0
 Read of size 2 at addr ffff8881042a8cb2 by task poc3/134

 CPU: 0 UID: 0 PID: 134 Comm: poc3 Not tainted 7.0.0-rc2+ #6 PREEMPTLAZY
 Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
 Call Trace:
  ctnetlink_dump_tuples_ip+0xbc/0x1f0
  ctnetlink_dump_tuples+0x19/0x60
  ctnetlink_exp_dump_tuple+0x6f/0xd0
  ctnetlink_exp_dump_expect+0x315/0x660
  ctnetlink_exp_fill_info.constprop.0+0xf9/0x180
  ctnetlink_get_expect+0x2f3/0x400
  nfnetlink_rcv_msg+0x48e/0x510
  netlink_rcv_skb+0xc9/0x1f0
  nfnetlink_rcv+0xdb/0x220
  netlink_unicast+0x3ec/0x590
  netlink_sendmsg+0x397/0x690
  ___sys_sendmsg+0xfc/0x170
  __sys_sendmsg+0xf4/0x180
  do_syscall_64+0xc3/0x6e0

 Allocated by task 131:
  kmem_cache_alloc_noprof+0x134/0x440
  __nf_conntrack_alloc+0xa8/0x2b0
  ctnetlink_create_conntrack+0xa1/0x900
  ctnetlink_new_conntrack+0x3cf/0x7d0
  nfnetlink_rcv_msg+0x48e/0x510
  netlink_rcv_skb+0xc9/0x1f0
  nfnetlink_rcv+0xdb/0x220
  netlink_unicast+0x3ec/0x590
  netlink_sendmsg+0x397/0x690
  __sys_sendmsg+0xf4/0x180
  do_syscall_64+0xc3/0x6e0
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

 Freed by task 0:
  __kasan_slab_free+0x43/0x70
  slab_free_after_rcu_debug+0xad/0x1e0
  rcu_core+0x5c3/0x9c0
  handle_softirqs+0x148/0x460

 Last potentially related work creation:
  kmem_cache_free+0x1f5/0x440
  nf_conntrack_free+0xc1/0x140
  ctnetlink_del_conntrack+0x4c4/0x520
  nfnetlink_rcv_msg+0x48e/0x510
  netlink_rcv_skb+0xc9/0x1f0
  nfnetlink_rcv+0xdb/0x220
  netlink_unicast+0x3ec/0x590
  netlink_sendmsg+0x397/0x690
  __sys_sendmsg+0xf4/0x180

 The buggy address belongs to the object at ffff8881042a8c80
  which belongs to the cache nf_conntrack of size 248
 The buggy address is located 50 bytes inside of
  freed 248-byte region [ffff8881042a8c80, ffff8881042a8d78)

Fixes: c1d10adb4a52 ("[NETFILTER]: Add ctnetlink port for nf_conntrack")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_netlink.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 65aa44a12d01..10a9b98368f4 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3324,6 +3324,7 @@ static int ctnetlink_get_expect(struct sk_buff *skb,
 {
 	u_int8_t u3 = info->nfmsg->nfgen_family;
 	struct nf_conntrack_tuple tuple;
+	struct nf_conn *master;
 	struct nf_conntrack_expect *exp;
 	struct nf_conntrack_zone zone;
 	struct sk_buff *skb2;
@@ -3378,10 +3379,19 @@ static int ctnetlink_get_expect(struct sk_buff *skb,
 	}
 
 	rcu_read_lock();
+	master = exp->master;
+	if (!refcount_inc_not_zero(&master->ct_general.use)) {
+		rcu_read_unlock();
+		nf_ct_expect_put(exp);
+		kfree_skb(skb2);
+		return -ENOENT;
+	}
+
 	err = ctnetlink_exp_fill_info(skb2, NETLINK_CB(skb).portid,
 				      info->nlh->nlmsg_seq, IPCTNL_MSG_EXP_NEW,
 				      exp);
 	rcu_read_unlock();
+	nf_ct_put(master);
 	nf_ct_expect_put(exp);
 	if (err <= 0) {
 		kfree_skb(skb2);
-- 
2.52.0

