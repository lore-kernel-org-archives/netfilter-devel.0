Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D48A40F8DC;
	Mon,  9 Mar 2026 21:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773090560; cv=none; b=irpz/+a8Fb2LhTi3jfR5K1LhConIYWAC4YJySHXRURI+E1o2BlmbWIQmW8UnT5ra/2jCZy7IupEDHew8FxJvIK1IIiGMYpOvnPufyw2wAIhvk07hhd44B0yaAhMpD2rE6i3cdl83b/Uj0PJe5R+UmhwoazrBdMFYzrxaGyR2R2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773090560; c=relaxed/simple;
	bh=sQ5SwBo9qxg8CLjshNJ3y3Srm8F3CDSgmndoixri7HQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F50dv4X5P4qNuw2gfTatGV4X6baLG7h5O4KQiMPTZueoOtFWlkRXZKV3RzVbnDBxKsoy3NklcD/5R5h50VEfQTK8AeRbOR6tXK/iL76fJtGO1anf1tmVvftgkL+G1mJCcwwAgRuN20M8ZTfBNLb01k/1xdRwYdi56R9EgkpUv4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 50C3960D2F; Mon, 09 Mar 2026 22:09:18 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 07/10] netfilter: ctnetlink: fix use-after-free in ctnetlink_dump_exp_ct()
Date: Mon,  9 Mar 2026 22:08:42 +0100
Message-ID: <20260309210845.15657-8-fw@strlen.de>
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

ctnetlink_dump_exp_ct() stores a conntrack pointer in cb->data for the
netlink dump callback ctnetlink_exp_ct_dump_table(), but drops the
conntrack reference immediately after netlink_dump_start().  When the
dump spans multiple rounds, the second recvmsg() triggers the dump
callback which dereferences the now-freed conntrack via nfct_help(ct),
leading to a use-after-free on ct->ext.

The bug is that the netlink_dump_control has no .start or .done
callbacks to manage the conntrack reference across dump rounds.  Other
dump functions in the same file (e.g. ctnetlink_get_conntrack) properly
use .start/.done callbacks for this purpose.

Fix this by adding .start and .done callbacks that hold and release the
conntrack reference for the duration of the dump, and move the
nfct_help() call after the cb->args[0] early-return check in the dump
callback to avoid dereferencing ct->ext unnecessarily.

 BUG: KASAN: slab-use-after-free in ctnetlink_exp_ct_dump_table+0x4f/0x2e0
 Read of size 8 at addr ffff88810597ebf0 by task ctnetlink_poc/133

 CPU: 1 UID: 0 PID: 133 Comm: ctnetlink_poc Not tainted 7.0.0-rc2+ #3 PREEMPTLAZY
 Call Trace:
  <TASK>
  ctnetlink_exp_ct_dump_table+0x4f/0x2e0
  netlink_dump+0x333/0x880
  netlink_recvmsg+0x3e2/0x4b0
  ? aa_sk_perm+0x184/0x450
  sock_recvmsg+0xde/0xf0

 Allocated by task 133:
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

 Freed by task 0:
  slab_free_after_rcu_debug+0xad/0x1e0
  rcu_core+0x5c3/0x9c0

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

Fixes: e844a928431f ("netfilter: ctnetlink: allow to dump expectation per master conntrack")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_netlink.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index c9d725fc2d71..65aa44a12d01 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3212,7 +3212,7 @@ ctnetlink_exp_ct_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
 	struct nf_conn *ct = cb->data;
-	struct nf_conn_help *help = nfct_help(ct);
+	struct nf_conn_help *help;
 	u_int8_t l3proto = nfmsg->nfgen_family;
 	unsigned long last_id = cb->args[1];
 	struct nf_conntrack_expect *exp;
@@ -3220,6 +3220,10 @@ ctnetlink_exp_ct_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	if (cb->args[0])
 		return 0;
 
+	help = nfct_help(ct);
+	if (!help)
+		return 0;
+
 	rcu_read_lock();
 
 restart:
@@ -3249,6 +3253,24 @@ ctnetlink_exp_ct_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+static int ctnetlink_dump_exp_ct_start(struct netlink_callback *cb)
+{
+	struct nf_conn *ct = cb->data;
+
+	if (!refcount_inc_not_zero(&ct->ct_general.use))
+		return -ENOENT;
+	return 0;
+}
+
+static int ctnetlink_dump_exp_ct_done(struct netlink_callback *cb)
+{
+	struct nf_conn *ct = cb->data;
+
+	if (ct)
+		nf_ct_put(ct);
+	return 0;
+}
+
 static int ctnetlink_dump_exp_ct(struct net *net, struct sock *ctnl,
 				 struct sk_buff *skb,
 				 const struct nlmsghdr *nlh,
@@ -3264,6 +3286,8 @@ static int ctnetlink_dump_exp_ct(struct net *net, struct sock *ctnl,
 	struct nf_conntrack_zone zone;
 	struct netlink_dump_control c = {
 		.dump = ctnetlink_exp_ct_dump_table,
+		.start = ctnetlink_dump_exp_ct_start,
+		.done = ctnetlink_dump_exp_ct_done,
 	};
 
 	err = ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_MASTER,
-- 
2.52.0

