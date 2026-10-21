Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792611322;
	b=BVdOjLUuZWrTuqSra4/Vonb7X0FWaaVJMGPkjAtIAVtZpGq+JJ+s48Ti/QB90VzvAykm
	 3iClhw/vzkWCCaTRZIdGHyArYjbBkn7YxVttSr8qX31sDUJ1cfwbxEnNGWyBE59FV6vzx
	 JcxB8sjoYUXOH9Z53bS9+NChwImGAQcIj4YyG1+VUbxs1QFp3v4JFmFTiPxJVKfyvLI1K
	 NtKba6PEMFZPvP7E18ZNU3l5CCvTElzqRCSeIKAwR63d4X9lf3DOfw1AMgZtwXA8uUehi
	 idxAGSWx+CuYwo22Ae/wQEoDinewmVRUMiazbpVc9LA0d65wxATvVg4dp1UIkdCX4ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792611322;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=4vhNYdNuVIvMrC3YXBNP/msHgi5R0+GF0fZNGQns9Cg=;
	b=JseBzZyWLYdh9hJihGrTbeowJCvSWB3Hg8iCdCX3klExiF7BDaRWJwxyeGh5QX446eo+
	 iDTJr/aRpfiqKDwcL4IOeNn96mPQnPEKcnM7IanlRuHN6GvxqoA7cnRJpzCa8HK3yWj1r
	 mh2Ks0XGTaS67LTmf75G55D6lhLJnp9kqUKtpSQ8ojVPwDQy+4Xzsq7B3KRbhlnmgA8Ps
	 1gHrgc0Uqa0yo9dF378UdZ1khygemf+zexLivqHCly6v3najZz6rVULZz6pl4L4TBPV+y
	 TVjUipyJh+pnKWext16zb9Lxce4RJYt86bolgNNDXKDU0+dTBhH6CGP4daj1eyN9vCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--aojea.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=nPwgYuhx;
	arc=none smtp.remote-ip=209.85.208.69
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB47606A321
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 19:35:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4CB47606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=nPwgYuhx
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6b1d818b501so1178777a12.0
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 12:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792611321; x=1793216121; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4vhNYdNuVIvMrC3YXBNP/msHgi5R0+GF0fZNGQns9Cg=;
        b=nPwgYuhxoImTL+stlax0x8SEHdOAtOG9jJl1cfUacTewmNbzyP/yk2n5rV00wr8TLE
         mkx6SvSu4gbXV+jbo9/lG0FGYX2yDGiVqiTxpwgOpUTCeIZb/3TUd782k1g4DoRj6UyT
         dlUtK46BbuLO5LOpde3psZl+YxFr0LXWz5UycpljlFZ2itPqe0WpcFF5MgdUqSle9btw
         QetvAN10YPlqmQQp5FWuU56KMxGliiy6VWEryxqLkB/9sZ99E8z0WAkRFdDd4xs0cAuH
         8IQV2Eit/kccC+Fm9YXtyeWL1KaRLwK+YTNIGDSICxHR22+qDTx/vXUGbEWEZVO02NMs
         ekgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792611321; x=1793216121;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4vhNYdNuVIvMrC3YXBNP/msHgi5R0+GF0fZNGQns9Cg=;
        b=zSegpMujZaRPwmymO1BMC2HkgCESleaIL0saXvUW5wukxFB+JbKz7pSDfUg75icPYo
         dAd+Gm8doMwLd8o2c24FmEYnJWWSVuCvusTF9TBZG2OAI1E4RiSOqCnUgFrDx96lryl4
         FAsiJrkR/t1eLcuppK8Hxn2y3y0hHSX2/A9fO49CdrPs/BKf2nJug3T0+//ic6OGD+Vt
         VjG4FHD8ziqaAuFZrVsp0+wesu0qMqD1lRpvvVYIveJEuyxXtkabPUYhzAFEswaaj2Mq
         BqsR/kNkU570w+PxTI+A1XCCX4ENmfdQ6XRoLRxIawyGTTWflvXl8NsKwMZIAeeT3ust
         fU1w==
X-Gm-Message-State: AFq9FYJrAdiFZimcfhiSCxPeNe/3yuhoGJG4+bHbXNQ56SvuaxtgW69Y
	XTBcGsDX4CmsB6DD7ceVD5Hii6IO/pYWWgOJGqTU13SHTzSgFEJlieEvzTZLF77IBKM4vbXTt0g
	12A==
X-Received: from edcpp11.prod.google.com ([2002:a05:6402:c0cb:b0:6ae:14cc:13c4])
 (user=aojea job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:e07:b0:6b1:c5c3:9624
 with SMTP id 4fb4d7f45d1cf-6b408eb45cemr2264098a12.22.1792611320449; Wed, 21
 Oct 2026 12:35:20 -0700 (PDT)
Date: Wed, 21 Oct 2026 19:35:09 +0000
In-Reply-To: <20261021193512.2302587-1-aojea@google.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261021193512.2302587-1-aojea@google.com>
X-Mailer: git-send-email 2.56.0.218.g1ec904b173-goog
Message-ID: <20261021193512.2302587-2-aojea@google.com>
Subject: [PATCH nf-next 1/4] netfilter: br_netfilter: flush nfqueue entries
 when the hooks are removed
From: Antonio Ojea <aojea@google.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Nikolay Aleksandrov <razor@blackwall.org>, 
	Ido Schimmel <idosch@nvidia.com>, bridge@lists.linux.dev, Antonio Ojea <aojea@google.com>, 
	"Sashiko (nipa)" <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"

br_netfilter registers hooks at the bridge hook points and at ip and ip6
prerouting. It also calls NF_HOOK() itself with its own functions as
okfn: br_nf_forward() and br_nf_forward_arp() run the ip, ip6 and arp
forward hooks with br_nf_forward_finish(), br_nf_post_routing() runs the
ip and ip6 postrouting hooks with br_nf_dev_queue_xmit(). A packet
queued to userspace from one of these hook points keeps that okfn in its
nf_queue_entry and nf_reinject() calls it when the verdict arrives.

Until commit 72ac1c0937df ("netfilter: nf_queue: limit the hook drop
flush to the unregistered hook point") unregistering any hook flushed
every queued packet of the network namespace, so brnf_exit_net()
dropped these entries as a side effect of removing br_nf_ops. The flush
now only covers the hook points of the removed hooks, and the entries
queued from forward and postrouting stay in the queue after
rmmod br_netfilter. The next verdict for one of them jumps into freed
module text:

  BUG: unable to handle page fault for address: ffffffffc0802250
  #PF: supervisor instruction fetch in kernel mode
  #PF: error_code(0x0010) - not-present page
  RIP: 0010:0xffffffffc0802250
  Call Trace:
   nfqnl_reinject+0x221/0x3d0
   nfqnl_recv_verdict+0x851/0xaa0
   nfnetlink_rcv_msg+0x199/0x300
   netlink_rcv_skb+0x59/0x100
   netlink_unicast+0x28c/0x3c0
   netlink_sendmsg+0x1f2/0x420
  Modules linked in: [last unloaded: br_netfilter]

Flush every queued packet of the namespace when br_netfilter leaves it.
Move the hook removal to a pre_exit callback and do the flush in the
exit callback: the pernet core runs a grace period between the two, so
no hook of this module is still running when the flush happens and no
entry with an okfn in this module can be queued after it. The same
split is what nf_tables_pre_exit_net() uses for base chain hooks.

nf_queue_nf_hook_drop() was declared in nf_internals.h, which is
private to net/netfilter; move the declaration to nf_queue.h so that
br_netfilter can call it, and include that header in the two files that
used the private declaration.

Reproduced in virtme-ng with br_netfilter built as a module: two network
namespaces connected through a bridge with bridge-nf-call-iptables=1, an
ip forward chain that sends udp dport 12345 to queue 1, and the nf_queue
selftest helper holding the verdicts (-H). With 10 packets queued, rmmod
br_netfilter returns and /proc/net/netfilter/nfnetlink_queue still shows
the 10 entries; the first verdict panics the kernel as shown above. With
this patch rmmod drops the 10 entries and the verdict fails with
-ENOENT. nft_queue.sh passes.

The code and this commit message were written with an LLM coding
assistant from the review linked below. The author reviewed the result
and validated it with the reproducer and the selftest.

Fixes: 72ac1c0937df ("netfilter: nf_queue: limit the hook drop flush to the unregistered hook point")
Reported-by: Sashiko (nipa) <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/netfilter-devel/179237288267.3135.9555179349652175002@kernel.org/
Suggested-by: Florian Westphal <fw@strlen.de>
Assisted-by: LLM
Signed-off-by: Antonio Ojea <aojea@google.com>
---
 include/net/netfilter/nf_queue.h  |  5 +++++
 net/bridge/br_netfilter_hooks.c   | 21 ++++++++++++++++++---
 net/netfilter/nf_conntrack_core.c |  1 +
 net/netfilter/nf_internals.h      |  3 ---
 net/netfilter/nft_ct.c            |  1 +
 5 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index 86021c55ba3c..9e1388179097 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -42,6 +42,11 @@ struct nf_queue_handler {
 void nf_register_queue_handler(const struct nf_queue_handler *qh);
 void nf_unregister_queue_handler(void);
 
+/* Drop the packets of @net queued from the hook point of @ops, or every
+ * queued packet of @net when @ops is NULL.
+ */
+void nf_queue_nf_hook_drop(struct net *net, const struct nf_hook_ops *ops);
+
 bool nf_queue_entry_get_refs(struct nf_queue_entry *entry);
 void nf_queue_entry_free(struct nf_queue_entry *entry);
 
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index e15355ff215a..d3fc89c3317c 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -37,6 +37,7 @@
 #include <net/dst_metadata.h>
 #include <net/route.h>
 #include <net/netfilter/br_netfilter.h>
+#include <net/netfilter/nf_queue.h>
 #include <net/netns/generic.h>
 #include <net/inet_dscp.h>
 
@@ -1296,14 +1297,27 @@ static int __net_init brnf_init_net(struct net *net)
 	return br_netfilter_sysctl_init_net(net);
 }
 
+static void __net_exit brnf_pre_exit_net(struct net *net)
+{
+	struct brnf_net *brnet = net_generic(net, brnf_net_id);
+
+	if (brnet->enabled)
+		nf_unregister_net_hooks(net, br_nf_ops, ARRAY_SIZE(br_nf_ops));
+}
+
 static void __net_exit brnf_exit_net(struct net *net)
 {
-	struct brnf_net *brnet;
+	struct brnf_net *brnet = net_generic(net, brnf_net_id);
 
-	brnet = net_generic(net, brnf_net_id);
 	if (brnet->enabled) {
-		nf_unregister_net_hooks(net, br_nf_ops, ARRAY_SIZE(br_nf_ops));
 		brnet->enabled = false;
+		/* A grace period has passed since brnf_pre_exit_net() removed
+		 * the hooks, so none of them is still running.  Drop what they
+		 * queued from the ip, ip6 and arp forward and postrouting hook
+		 * points: those entries carry an okfn in this module and the
+		 * hook removal did not flush them.
+		 */
+		nf_queue_nf_hook_drop(net, NULL);
 	}
 
 	br_netfilter_sysctl_exit_net(net, brnet);
@@ -1311,6 +1325,7 @@ static void __net_exit brnf_exit_net(struct net *net)
 
 static struct pernet_operations brnf_net_ops __read_mostly = {
 	.init = brnf_init_net,
+	.pre_exit = brnf_pre_exit_net,
 	.exit = brnf_exit_net,
 	.id   = &brnf_net_id,
 	.size = sizeof(struct brnf_net),
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 931b76aacd93..42a7cbdbd7d5 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -49,6 +49,7 @@
 #include <net/netfilter/nf_conntrack_synproxy.h>
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_helper.h>
+#include <net/netfilter/nf_queue.h>
 #include <net/netns/hash.h>
 #include <net/ip.h>
 
diff --git a/net/netfilter/nf_internals.h b/net/netfilter/nf_internals.h
index ce5aff2cae71..06a795bbbb99 100644
--- a/net/netfilter/nf_internals.h
+++ b/net/netfilter/nf_internals.h
@@ -23,9 +23,6 @@
 #define CTA_FILTER_F_ALL			(CTA_FILTER_F_MAX-1)
 #define CTA_FILTER_FLAG(ctattr) CTA_FILTER_F_ ## ctattr
 
-/* nf_queue.c */
-void nf_queue_nf_hook_drop(struct net *net, const struct nf_hook_ops *ops);
-
 /* nf_log.c */
 int __init netfilter_log_init(void);
 
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 5a8db5592036..7464805651ae 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -23,6 +23,7 @@
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_seqadj.h>
+#include <net/netfilter/nf_queue.h>
 #include "nf_internals.h"
 
 struct nft_ct_helper_obj  {
-- 
2.56.0.218.g1ec904b173-goog

