Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB3B2D8378;
	Wed, 10 Jun 2026 16:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781108200; cv=none; b=qEtLgcSUoA8g98lybiMpyGpa7HmPvvMJIOmrVqLLA0JnJjN1I4lJ0xhSZle+KXLqMptd24btHvZgRc3HqPoEQqbbcSkB0pV3fCWHcwTySy+28OMS9/7Ktrz9bABOqBEs7b6AAeNah4pehZB0V23Q1ObbVO2U9GxrPIJj35b1zrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781108200; c=relaxed/simple;
	bh=oj8NAdUL1Xtm4ICu6zhuVv4gNcAtxmUXSZuseS3bFBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KcCu1rE2cGiRXFAahoEt8jUUYsJjFTrLGMHoFXGqA7M6xtISV1bwL9Kx2Ot8YTsPtV7VT+Bb6DtDVvMK/tRVZzPOpScUMcfbGcGuGAnS75EGnVb19zufS5gID9fYBAXDCwmd0XS/c27jv4/QU6B7PMFYM0sxAaHvXLyPQPICscA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tdXXA1r6; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tdXXA1r6"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C349F601BE;
	Wed, 10 Jun 2026 18:16:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781108197;
	bh=5a81DRlp075fMmCxLLVa7Uwi8CLhqmH7yn9VB1rspbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tdXXA1r6s+YJUQdr88eQMXzau0Iz0ADVOUnJ6gMEicFUnNwGgIBouxMFZAYGWeHhG
	 8hoNTG78N4lBuMcBfGWSbkR5xBOzJ1Iy2EyIRIlkkuK/FjErCutZCyM8cOLWNuoTPS
	 iIKGBIRaWb+kAI20eKI/s2DkJxWzPAgInDzkU6AqKQTT//K0JQjVSVqu5H7eQm4wnj
	 hnhte0LpxipsPbMDRblIlnl+PTFmY9hUMEb4Ekpz2zH6zaAhn/Q6PKOB6zvhmAhBnM
	 SyRB041PnPU2W84+IMi2j8SGdFdRD7KfYhtMEQa9hcjubKD6h4mfmmckixKEYqb9Ky
	 PrvZPyCjBGqTQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 3/8] netfilter: nf_conntrack: destroy stale expectfn expectations on unregister
Date: Wed, 10 Jun 2026 18:16:23 +0200
Message-ID: <20260610161629.214092-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260610161629.214092-1-pablo@netfilter.org>
References: <20260610161629.214092-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Weiming Shi <bestswngs@gmail.com>

NAT helpers such as nf_nat_h323 store a raw pointer to module text in
exp->expectfn (e.g. ip_nat_q931_expect). nf_ct_helper_expectfn_unregister()
only unlinks the callback descriptor and never walks the expectation table,
so an expectation pending at module removal survives with a dangling
exp->expectfn into freed module text.

When the expected connection arrives, init_conntrack() invokes
exp->expectfn(), now a stale pointer into the unloaded module. Reproduced
on a KASAN build by loading the H.323 helpers, creating a Q.931
expectation, unloading nf_nat_h323, then connecting to the expected port:

 Oops: int3: 0000 [#1] SMP KASAN NOPTI
 RIP: 0010:0xffffffffa06102d1
  init_conntrack.isra.0 (net/netfilter/nf_conntrack_core.c:1862)
  nf_conntrack_in (net/netfilter/nf_conntrack_core.c:2049)
  ipv4_conntrack_local (net/netfilter/nf_conntrack_proto.c:223)
  nf_hook_slow (net/netfilter/core.c:619)
  __ip_local_out (net/ipv4/ip_output.c:120)
  __tcp_transmit_skb (net/ipv4/tcp_output.c:1715)
  tcp_connect (net/ipv4/tcp_output.c:4374)
  tcp_v4_connect (net/ipv4/tcp_ipv4.c:345)
  __sys_connect (net/socket.c:2167)
 Modules linked in: nf_conntrack_h323 [last unloaded: nf_nat_h323]

Reaching the dangling state requires CAP_SYS_MODULE in the initial user
namespace to remove a NAT helper that still has live expectations, so this
is a robustness fix; leaving an expectation pointing at freed text is wrong
regardless.

Add nf_ct_helper_expectfn_destroy(), which walks the expectation table and
drops every expectation whose ->expectfn matches the descriptor being torn
down. Call it from each NAT helper's exit path after the existing RCU grace
period, so no expectation outlives the code it points at and no extra
synchronize_rcu() is introduced. With the fix, the same reproducer runs to
completion without the Oops.

Fixes: f587de0e2feb ("[NETFILTER]: nf_conntrack/nf_nat: add H.323 helper port")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_helper.h |  1 +
 net/ipv4/netfilter/nf_nat_h323.c            |  2 ++
 net/netfilter/nf_conntrack_helper.c         | 19 +++++++++++++++++++
 net/netfilter/nf_nat_core.c                 |  2 ++
 net/netfilter/nf_nat_sip.c                  |  1 +
 5 files changed, 25 insertions(+)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index de2f956abf34..24cf3d2d9745 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -155,6 +155,7 @@ void nf_ct_helper_log(struct sk_buff *skb, const struct nf_conn *ct,
 
 void nf_ct_helper_expectfn_register(struct nf_ct_helper_expectfn *n);
 void nf_ct_helper_expectfn_unregister(struct nf_ct_helper_expectfn *n);
+void nf_ct_helper_expectfn_destroy(const struct nf_ct_helper_expectfn *n);
 struct nf_ct_helper_expectfn *
 nf_ct_helper_expectfn_find_by_name(const char *name);
 struct nf_ct_helper_expectfn *
diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index faee20af4856..10e1b0837731 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -555,6 +555,8 @@ static void __exit nf_nat_h323_fini(void)
 	nf_ct_helper_expectfn_unregister(&q931_nat);
 	nf_ct_helper_expectfn_unregister(&callforwarding_nat);
 	synchronize_rcu();
+	nf_ct_helper_expectfn_destroy(&q931_nat);
+	nf_ct_helper_expectfn_destroy(&callforwarding_nat);
 }
 
 /****************************************************************************/
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 17e971bd4c74..2c5a71735561 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -283,6 +283,25 @@ void nf_ct_helper_expectfn_unregister(struct nf_ct_helper_expectfn *n)
 }
 EXPORT_SYMBOL_GPL(nf_ct_helper_expectfn_unregister);
 
+static bool expect_iter_expectfn(struct nf_conntrack_expect *exp, void *data)
+{
+	const struct nf_ct_helper_expectfn *n = data;
+
+	/* Relies on registered expectfn descriptors having unique ->expectfn
+	 * pointers, which holds for the in-tree NAT helpers.
+	 */
+	return exp->expectfn == n->expectfn;
+}
+
+/* Destroy expectations still pointing at @n->expectfn; call after the
+ * caller's RCU grace period so none outlives the (often modular) callback.
+ */
+void nf_ct_helper_expectfn_destroy(const struct nf_ct_helper_expectfn *n)
+{
+	nf_ct_expect_iterate_destroy(expect_iter_expectfn, (void *)n);
+}
+EXPORT_SYMBOL_GPL(nf_ct_helper_expectfn_destroy);
+
 /* Caller should hold the rcu lock */
 struct nf_ct_helper_expectfn *
 nf_ct_helper_expectfn_find_by_name(const char *name)
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 74ec224ce0d6..2bbf5163c0e2 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1341,6 +1341,7 @@ static int __init nf_nat_init(void)
 		RCU_INIT_POINTER(nf_nat_hook, NULL);
 		nf_ct_helper_expectfn_unregister(&follow_master_nat);
 		synchronize_net();
+		nf_ct_helper_expectfn_destroy(&follow_master_nat);
 		unregister_pernet_subsys(&nat_net_ops);
 		kvfree(nf_nat_bysource);
 	}
@@ -1358,6 +1359,7 @@ static void __exit nf_nat_cleanup(void)
 	RCU_INIT_POINTER(nf_nat_hook, NULL);
 
 	synchronize_net();
+	nf_ct_helper_expectfn_destroy(&follow_master_nat);
 	kvfree(nf_nat_bysource);
 	unregister_pernet_subsys(&nat_net_ops);
 }
diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index 9fbfc6bff0c2..00838c0cc5bb 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -655,6 +655,7 @@ static void __exit nf_nat_sip_fini(void)
 	RCU_INIT_POINTER(nf_nat_sip_hooks, NULL);
 	nf_ct_helper_expectfn_unregister(&sip_nat);
 	synchronize_rcu();
+	nf_ct_helper_expectfn_destroy(&sip_nat);
 }
 
 static const struct nf_nat_sip_hooks sip_hooks = {
-- 
2.47.3

