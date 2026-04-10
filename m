Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD4F332608
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Apr 2026 10:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775816043; cv=none; b=FVBflVkLJZbYTgH3dMn0AP1sewDGABvnlMZEtUlFFLx4+41rqhbV4EGLW2XaZFzWbtAAyu2SQDTMshUvZ5XAFVuL3r8WbwZs3XoVhQpXqv7Bw9aoefJ18AkM+doIFnMPz78lurVwvLi5i90hYG6akuNz0+VHnhpViuExwBHwPts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775816043; c=relaxed/simple;
	bh=+5JZ9xXoRUN85ru0donIjNuo+Waq/MzwyOIjJguYJz0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=emMDnC1IOivRPxf6TAy+NwmQKXX3zHM/jWYVnOUMaG3eMmA+wzMXIeNimC3SHqhSTXZqPEhvG6SSvYsBei+XiQtY8tczhtwcg25H/zFBaT/sYTVFWQW5Wte5500THEiwCVzNS97gWSDblAOAMHej/M6oJedpMId1+LMqO2rW1yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ILEd90kr; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ILEd90kr"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-82d561b3689so858917b3a.0
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Apr 2026 03:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775816041; x=1776420841; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5P6xJCvneuwhXql1CKN1XhB39jxxN+O7rcFH8Ar99kQ=;
        b=ILEd90krBc8fLzNvMpYMGxRSWS4Ejfm8Tafav2A49vFnVQWe+DjtRS6Ak8z6+BXt9x
         5FkXaLqttn4Rd0+WLdUlELZfqUTIQgEaO4Dv9yg6navjKQuQly5a292kLEma184Ke/TD
         JRzNUsXa8ENOHP77iSWpgHo6+/4pLXIgSzoyxouyzKVUtsa/p+Z6RU/L5sRcbZibB5D5
         XyTt8Vxo/u3lIfzDvHxna2DWV4JCO0ioQFGe2T6NzejI0wJHA1X1YYH4IIdvGf8fMtK0
         X9NQMnEUUa+9majKJ3RqCst1IBeKnXUHhBZwL/myhi8NcbqP4O/ZXp8gei5uNU74VRdU
         lOcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775816041; x=1776420841;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5P6xJCvneuwhXql1CKN1XhB39jxxN+O7rcFH8Ar99kQ=;
        b=ijVMvcl2482oaCRos35/q8MZ7APdcdubXjF5ZSps3YjkuNNDmhfQ1lpPA4wuPPv8WJ
         oimLaT0g9XINb/DjcMoC2U+9xKm3lf3b0d3/c23YH2QaD9Mw+KU58SfWsW16dTtqQzBU
         +e2Onk4rnu+BuPWJ8cIAdzVV7jd5FJZD7e+JSCh6yu+V5yUQ+AkZ8Pp6jOLNfte1iTuc
         0f9sYt2WxkhVjWqCwUsJQhuEzwtLowWMc9XSMmrj0b0ljvK+d1cSJEB/ce6GeisQAN8T
         5ieEG3XSCcMt1B/tAtEHjROGlGaVyQMfiOce391RsppVkDs7DbvKu+oyT5DgTAcppqd8
         mWsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLigwEQx0kCqi3r4haLMVOjELokHtTxYENL4qXXOCw8DEZqBplqg5GWLm7MI+NfvTVgoFB3D6aydEbtG9uoYQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgSspvyLw2oPz93b59mrXIRyajlsDD8itWf59xVWBVzhh3KILz
	/ujlEQTXPazVTI+fwIY3flFzkkq6yOvPcqZvBKUPaLk2C9BaQvWyUkHa
X-Gm-Gg: AeBDievLKWVyQlwXLVmfHHQ7fNo5ghV7zB/9dkeWOp3E7VJPT2lyc3UGUnLm0uZRdqe
	iJugz6C0Z+6aMufzV9TYC6pZKB3tXO9Sj2M+Rtu/5++KoulSYlktnWykg4+JBNDxfLoIM33NI/Y
	cSKaxIZ7e7bvbzLaFNaSO85QOozx8pHEYf0aHC7CnXtJsf+WD7T+826DOlmxHE5zTBaN7CMNz3t
	pmkRPZRhCdJvieL9NEvHCA8mWeuvaxVTxPLP6ymzKfxXmEOfseSs+yFGC5fw6I0qfb4jf/4+q8P
	3jE+HFfXDRh10U0KxwlKlv+BKTvlNX0aFu6VTyr1zLNV/W5NYCxGPW1Exk7ydtL1uSN/m6wCted
	vCB50czURKOyLIC2myZv08ghQ39pTKQd2HUZh9MmAJQ8RUjA/CzBF1T5mujtt4s0sKeAiTuH9T8
	Bu1cAP59rlgy20IyYu+VY5ozm7xsozSR4IHGRDvJqkiQ2lG7d8z9jrALfkoggsqKJpb0AxWjdNX
	FJLuZBVrrMq
X-Received: by 2002:a05:6a00:12ca:b0:82f:5a4:aa46 with SMTP id d2e1a72fcca58-82f0c2b510cmr2621656b3a.44.1775816041376;
        Fri, 10 Apr 2026 03:14:01 -0700 (PDT)
Received: from SLSGDTSWING002.tail0ac356.ts.net ([129.126.109.177])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c4d5413sm2206692b3a.40.2026.04.10.03.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 03:14:00 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Phil Sutter <phil@nwl.cc>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH nf] netfilter: nf_tables: use RCU-safe list primitives for basechain hook list
Date: Fri, 10 Apr 2026 18:13:22 +0800
Message-ID: <20260410101321.915190-2-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

NFT_MSG_GETCHAIN runs as an NFNL_CB_RCU callback, so chain dumps
traverse basechain->hook_list under rcu_read_lock() without holding
commit_mutex. Meanwhile, nft_delchain_hook() mutates that same live
hook_list with plain list_move() and list_splice(), and the commit/abort
paths splice hooks back with plain list_splice(). None of these are
RCU-safe list operations.

A concurrent GETCHAIN dump can observe partially updated list pointers,
follow them into stack-local or transaction-private list heads, and
crash when container_of() produces a bogus struct nft_hook pointer.

The PoC triggers this by racing GETCHAIN dumps against aborting DELCHAIN
hook updates, reachable from an unprivileged user namespace since all
capability checks use ns_capable() with CONFIG_NF_TABLES=y (default):

 Oops: general protection fault, probably for non-canonical address 0xdffffc0000000006: 0000 [#1] SMP KASAN NOPTI
 KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
 RIP: 0010:strlen (lib/string.c:420 (discriminator 1))
 Call Trace:
  <TASK>
  nf_tables_fill_chain_info (net/netfilter/nf_tables_api.c:1987 (discriminator 1) net/netfilter/nf_tables_api.c:1992 (discriminator 1) net/netfilter/nf_tables_api.c:2028 (discriminator 1) net/netfilter/nf_tables_api.c:2077 (discriminator 1))
  nf_tables_dump_chains (net/netfilter/nf_tables_api.c:2173 (discriminator 1))
  netlink_dump (net/netlink/af_netlink.c:2325 (discriminator 1))
  __netlink_dump_start (net/netlink/af_netlink.c:2442)
  nf_tables_getchain (net/netfilter/nf_tables_api.c:1314 net/netfilter/nf_tables_api.c:2212)
  nfnetlink_rcv_msg (net/netfilter/nfnetlink.c:290)
  netlink_rcv_skb (net/netlink/af_netlink.c:2550)
  nfnetlink_rcv (net/netfilter/nfnetlink.c:653)
  netlink_unicast (net/netlink/af_netlink.c:1319 net/netlink/af_netlink.c:1344)
  netlink_sendmsg (net/netlink/af_netlink.c:1894)
  __sys_sendto (net/socket.c:727 net/socket.c:742 net/socket.c:2206)
  __x64_sys_sendto (net/socket.c:2209)
  </TASK>

Replace list_move() in nft_delchain_hook() with list_del_rcu() plus an
intermediate pointer array, followed by synchronize_rcu() before the
deleted hooks' list pointers are reused to link them into the
transaction's private list. In the error paths, put hooks back with
list_add_tail_rcu() which is safe for concurrent RCU readers (they
either continue to the original successor or see the list head and
terminate the walk).

Add nft_hook_list_splice_rcu() helper that splices entries from a
private list into a live RCU-protected list using individual
list_add_tail_rcu() calls instead of plain list_splice(). Use it in
the commit and abort paths for NEWCHAIN updates and DELCHAIN rollback.

Fixes: 7d937b107108 ("netfilter: nf_tables: support for deleting devices in an existing netdev chain")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 net/netfilter/nf_tables_api.c | 64 ++++++++++++++++++++++++++++++-----
 1 file changed, 56 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8c42247a176c7..62fcfefba7b0f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -391,6 +391,22 @@ static void nft_netdev_unregister_hooks(struct net *net,
 	}
 }
 
+/* Splice hooks from a private list into a live (RCU-protected) hook list.
+ * Each entry is published individually via list_add_tail_rcu() so that
+ * concurrent RCU readers walking the destination list never observe torn
+ * list pointers.
+ */
+static void nft_hook_list_splice_rcu(struct list_head *from,
+				     struct list_head *to)
+{
+	struct nft_hook *hook, *next;
+
+	list_for_each_entry_safe(hook, next, from, list) {
+		list_del(&hook->list);
+		list_add_tail_rcu(&hook->list, to);
+	}
+}
+
 static int nf_tables_register_hook(struct net *net,
 				   const struct nft_table *table,
 				   struct nft_chain *chain)
@@ -3162,9 +3178,11 @@ static int nft_delchain_hook(struct nft_ctx *ctx,
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_chain_hook chain_hook = {};
 	struct nft_hook *this, *hook;
+	struct nft_hook **del_hooks;
 	LIST_HEAD(chain_del_list);
 	struct nft_trans *trans;
-	int err;
+	int err, n = 0, i;
+	int max_hooks = 0;
 
 	if (ctx->table->flags & __NFT_TABLE_F_UPDATE)
 		return -EOPNOTSUPP;
@@ -3174,19 +3192,38 @@ static int nft_delchain_hook(struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
+	list_for_each_entry(this, &chain_hook.list, list)
+		max_hooks++;
+
+	del_hooks = kcalloc(max_hooks, sizeof(*del_hooks), GFP_KERNEL);
+	if (!del_hooks) {
+		nft_chain_release_hook(&chain_hook);
+		return -ENOMEM;
+	}
+
 	list_for_each_entry(this, &chain_hook.list, list) {
 		hook = nft_hook_list_find(&basechain->hook_list, this);
 		if (!hook) {
 			err = -ENOENT;
 			goto err_chain_del_hook;
 		}
-		list_move(&hook->list, &chain_del_list);
+		list_del_rcu(&hook->list);
+		del_hooks[n++] = hook;
 	}
 
+	/* Wait for any concurrent RCU readers (e.g. GETCHAIN dumps walking
+	 * basechain->hook_list) to finish before modifying the removed hooks'
+	 * list pointers to link them into the transaction's private list.
+	 */
+	synchronize_rcu();
+
+	for (i = 0; i < n; i++)
+		list_add_tail(&del_hooks[i]->list, &chain_del_list);
+
 	trans = nft_trans_alloc_chain(ctx, NFT_MSG_DELCHAIN);
 	if (!trans) {
 		err = -ENOMEM;
-		goto err_chain_del_hook;
+		goto err_chain_add_back;
 	}
 
 	nft_trans_basechain(trans) = basechain;
@@ -3194,13 +3231,24 @@ static int nft_delchain_hook(struct nft_ctx *ctx,
 	INIT_LIST_HEAD(&nft_trans_chain_hooks(trans));
 	list_splice(&chain_del_list, &nft_trans_chain_hooks(trans));
 	nft_chain_release_hook(&chain_hook);
+	kfree(del_hooks);
 
 	nft_trans_commit_list_add_tail(ctx->net, trans);
 
 	return 0;
 
+err_chain_add_back:
+	for (i = 0; i < n; i++)
+		list_add_tail_rcu(&del_hooks[i]->list, &basechain->hook_list);
+	kfree(del_hooks);
+	nft_chain_release_hook(&chain_hook);
+
+	return err;
+
 err_chain_del_hook:
-	list_splice(&chain_del_list, &basechain->hook_list);
+	for (i = 0; i < n; i++)
+		list_add_tail_rcu(&del_hooks[i]->list, &basechain->hook_list);
+	kfree(del_hooks);
 	nft_chain_release_hook(&chain_hook);
 
 	return err;
@@ -10912,8 +10960,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				nft_chain_commit_update(nft_trans_container_chain(trans));
 				nf_tables_chain_notify(&ctx, NFT_MSG_NEWCHAIN,
 						       &nft_trans_chain_hooks(trans));
-				list_splice(&nft_trans_chain_hooks(trans),
-					    &nft_trans_basechain(trans)->hook_list);
+				nft_hook_list_splice_rcu(&nft_trans_chain_hooks(trans),
+							&nft_trans_basechain(trans)->hook_list);
 				/* trans destroyed after rcu grace period */
 			} else {
 				nft_chain_commit_drop_policy(nft_trans_container_chain(trans));
@@ -11231,8 +11279,8 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		case NFT_MSG_DELCHAIN:
 		case NFT_MSG_DESTROYCHAIN:
 			if (nft_trans_chain_update(trans)) {
-				list_splice(&nft_trans_chain_hooks(trans),
-					    &nft_trans_basechain(trans)->hook_list);
+				nft_hook_list_splice_rcu(&nft_trans_chain_hooks(trans),
+							&nft_trans_basechain(trans)->hook_list);
 			} else {
 				nft_use_inc_restore(&table->use);
 				nft_clear(trans->net, nft_trans_chain(trans));
-- 
2.43.0

