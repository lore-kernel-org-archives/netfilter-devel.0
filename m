Return-Path: <SRS0=4S6R=YT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE00FCA9EBD
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 11:48:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD9F3206DD
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 11:48:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfJZLry (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 26 Oct 2019 07:47:54 -0400
Received: from correo.us.es ([193.147.175.20]:46444 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbfJZLry (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 26 Oct 2019 07:47:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BB41D8C3C60
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:47:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A9FFAA7EFF
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:47:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9F674A7EE7; Sat, 26 Oct 2019 13:47:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 71002DA4CA;
        Sat, 26 Oct 2019 13:47:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:47:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 437DC42EE393;
        Sat, 26 Oct 2019 13:47:47 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 17/31] netfilter: add and use nf_hook_slow_list()
Date:   Sat, 26 Oct 2019 13:47:19 +0200
Message-Id: <20191026114733.28111-18-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191026114733.28111-1-pablo@netfilter.org>
References: <20191026114733.28111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

At this time, NF_HOOK_LIST() macro will iterate the list and then calls
nf_hook() for each individual skb.

This makes it so the entire list is passed into the netfilter core.
The advantage is that we only need to fetch the rule blob once per list
instead of per-skb.

NF_HOOK_LIST now only works for ipv4 and ipv6, as those are the only
callers.

v2: use skb_list_del_init() instead of list_del (Edward Cree)

Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Edward Cree <ecree@solarflare.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h | 41 +++++++++++++++++++++++++++++++----------
 net/netfilter/core.c      | 20 ++++++++++++++++++++
 2 files changed, 51 insertions(+), 10 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 77ebb61faf48..eb312e7ca36e 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -199,6 +199,8 @@ extern struct static_key nf_hooks_needed[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
 int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
 		 const struct nf_hook_entries *e, unsigned int i);
 
+void nf_hook_slow_list(struct list_head *head, struct nf_hook_state *state,
+		       const struct nf_hook_entries *e);
 /**
  *	nf_hook - call a netfilter hook
  *
@@ -311,17 +313,36 @@ NF_HOOK_LIST(uint8_t pf, unsigned int hook, struct net *net, struct sock *sk,
 	     struct list_head *head, struct net_device *in, struct net_device *out,
 	     int (*okfn)(struct net *, struct sock *, struct sk_buff *))
 {
-	struct sk_buff *skb, *next;
-	struct list_head sublist;
-
-	INIT_LIST_HEAD(&sublist);
-	list_for_each_entry_safe(skb, next, head, list) {
-		list_del(&skb->list);
-		if (nf_hook(pf, hook, net, sk, skb, in, out, okfn) == 1)
-			list_add_tail(&skb->list, &sublist);
+	struct nf_hook_entries *hook_head = NULL;
+
+#ifdef CONFIG_JUMP_LABEL
+	if (__builtin_constant_p(pf) &&
+	    __builtin_constant_p(hook) &&
+	    !static_key_false(&nf_hooks_needed[pf][hook]))
+		return;
+#endif
+
+	rcu_read_lock();
+	switch (pf) {
+	case NFPROTO_IPV4:
+		hook_head = rcu_dereference(net->nf.hooks_ipv4[hook]);
+		break;
+	case NFPROTO_IPV6:
+		hook_head = rcu_dereference(net->nf.hooks_ipv6[hook]);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
 	}
-	/* Put passed packets back on main list */
-	list_splice(&sublist, head);
+
+	if (hook_head) {
+		struct nf_hook_state state;
+
+		nf_hook_state_init(&state, hook, pf, in, out, sk, net, okfn);
+
+		nf_hook_slow_list(head, &state, hook_head);
+	}
+	rcu_read_unlock();
 }
 
 /* Call setsockopt() */
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 5d5bdf450091..78f046ec506f 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -536,6 +536,26 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
 }
 EXPORT_SYMBOL(nf_hook_slow);
 
+void nf_hook_slow_list(struct list_head *head, struct nf_hook_state *state,
+		       const struct nf_hook_entries *e)
+{
+	struct sk_buff *skb, *next;
+	struct list_head sublist;
+	int ret;
+
+	INIT_LIST_HEAD(&sublist);
+
+	list_for_each_entry_safe(skb, next, head, list) {
+		skb_list_del_init(skb);
+		ret = nf_hook_slow(skb, state, e, 0);
+		if (ret == 1)
+			list_add_tail(&skb->list, &sublist);
+	}
+	/* Put passed packets back on main list */
+	list_splice(&sublist, head);
+}
+EXPORT_SYMBOL(nf_hook_slow_list);
+
 /* This needs to be compiled in any case to avoid dependencies between the
  * nfnetlink_queue code and nf_conntrack.
  */
-- 
2.11.0

