Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FED13BBFBC
	for <netfilter-devel@vger.kernel.org>; Sun, 11 Oct 2026 11:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791718303; cv=none; b=q/szWNtIoKz8CIO/s4EMlT2zlR+Ql1CEH0+K8UMyZokSRYjco+kI6h1Mt3Yc9/f24CBv+npZ1Gi3SlOV/TwaXffZBgs8CIrL6zDI/RJV04sk9aCQuV4IANFx82LJ87ImwcpT+HMXwAKal/XSEQ9SiAbEjqVIK3OkhfQjLpXvxH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791718303; c=relaxed/simple;
	bh=RrdWJqsFAsBIwPKCW+nn8Urc7gZajau4QiK5XpQXd+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HhwqVziluJxx+9imtk/pAeHluC6PAXnIxXDwTBjtPor5jtBD4AyaftySzTqF8U/2oUbJ2n0yf2y9UYbCoKD2fZUspDnhdOm1SNTGGA5zA5okk0bzrClXz2crJNnBwu7H/aXMh3FU9O3jxxqInOYE0lq/RTtPNxChfXy+NFPm0l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=SFO7zzNh; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="SFO7zzNh"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cc4c02ddd62so432505a12.0
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Oct 2026 04:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1791718296; x=1792323096; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3qKr5+vCUq3bYAvqjVFOwD9z3n2IpZbW7LGlOmG0K4Q=;
        b=SFO7zzNhEb6rxKm9sCa84VN3WO0siTr66m+epbhX1P7mxjzsXE2C43VLr27HZAlQZx
         p9v4ohMzHDOv3bGRwOSQROjIUoKRQl5yxl+bZHukVNhNwigPUk+qsSyh3B+IUpTVUUGW
         WcfiVSD1TG9DHgBiZKOQpGfpA9rg8ZVmMCjEQZtpZF+/UuJsACt1semcYRNpiviGnLHK
         nEyyWMGrG7UAnW4HPevuSn0TSCgg+YJUne8pqoh01rQc7OOTFfZQLxisZLLQCah7q3Uk
         3mgjIfnBvqHuxxYJMUmHkwdvIKU+KTAe73NEjsTZhwgPuXZwzVxkGma5Ilo3rS24HTae
         3csw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791718296; x=1792323096;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3qKr5+vCUq3bYAvqjVFOwD9z3n2IpZbW7LGlOmG0K4Q=;
        b=PHIPQ7R+ZrUsend9yH4mnwmDIusuEV51t5lyuUvJwAjUCobCoD6R90UwIAduOaYJoU
         yZbf9mLn8j/tRPVueTToKda2cXJczd+tlyjCT4CJjiUNf8twRaSoUnYhYhLSFJObfDeu
         MCdWKib+sHwWYJy5sC4dZpt9gurGWag849t7QLIVJu8CGfXYEIgV9I36ZqNbU/ImJdnL
         4bMdmHN4ZSr/SFl6sp01w17wu4zBMZ5BIVHEawPyfp9P2XpFZ9X4NlQFGpw5ETTTDEu9
         khjkLs56r+MoXgzSkXHouiL51vypHXqvlvehJ09D+bmewFxX0LYv7HpdFVib3Mg0nrpC
         p3pQ==
X-Forwarded-Encrypted: i=1; AKwUvBwmBdOl75OUYEyWYNs8AibbfJEVOF4V7+6g+3x+X3iTfrAvHXC7WcGMHJlgGk7kbsl706CDBwJ/+2AFU1GI9SU=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ+wNKNu2f81e9N42et1goSbAVur7HTPz8nxHMhT4PC6jnvl+9C
	3Pcwf9f6tGeQ9Cy0FHzkJl5siw9AEZfyLaIAO47283goLn8PydnrgnVsLf/WtUMYw3UC
X-Gm-Gg: AYBFou2wQAlU4Wh0tulyKUaWEMLvx8Td4QFT87sCLRDE7D2p6uZRr7EvcSO5cgO26q4
	DEXXEQNhBTw3Wlf8u4Em46jpe1gGIeWlKrF/b1mLmPUTIxiAu+NDJ63HleNpxtM2qX/jGCnUPem
	09nCXvBqYG6WUszYDOMUjr1N4xpUS3rOyIufyAZq+7liyx1gVpy55Xr71b2Qz8m+UVVZMeLkPOv
	oWnlX1iMscZnoMZluqzocQHBen9P2VrivBECsGeVFbifNYJZHUpyPU9FkDNRINckU0JhCON6O8O
	9QMj3ZainbPbjMKiWhNNWqAy35GZ0cUn10IpsATVIbR1lVCzVELyTiCUKLYXnbsDR3tzeeVvHvX
	U8lT4lMtXCQj2Y52SSBR5KK60szWh0bzFuJBFD/4gOmbP8oUqI56cL/SmgNDwQgKOKn0BgIGAAl
	PeZh5xj4mHjR8mstptwIFXPeax0EwWC7ShjQppqPp1sgXaV1kKoWQzsguZNMAQMz9Mb/WltnTIq
	mOgbDcn0Jx1xH7MM4NkIUUvZyOMtw==
X-Received: by 2002:a17:90b:4fcb:b0:3ab:31b9:fe51 with SMTP id 98e67ed59e1d1-3ab3acf311bmr6017144a91.67.1791718296162;
        Sun, 11 Oct 2026 04:31:36 -0700 (PDT)
Received: from 759f62e3e206.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab38b9639bsm11417577a91.4.2026.10.11.04.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 04:31:35 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	kaber@trash.net,
	jengelh@medozas.de,
	lukas@wunner.de,
	vega@nebusec.ai,
	root@tr0jan.top,
	zihanx@nebusec.ai
Subject: [PATCH nf v7 1/1] netfilter: nf_dup: preserve duplication guard across NFQUEUE
Date: Sun, 11 Oct 2026 11:28:44 +0000
Message-ID: <9c51ddfce3069d585b6c9b87e7e1bf3a3b0a2761.1791688819.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1791688819.git.zihanx@nebusec.ai>
References: <cover.1791688819.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nf_dup_ipv4() and nf_dup_ipv6() set current->in_nf_duplicate while the
cloned skb traverses output hooks. NFQUEUE can retain the clone and return
NF_STOLEN while that traversal is in progress. Once ip_local_out() or
ip6_local_out() returns, the task-local guard is cleared. NF_ACCEPT then
resumes hook traversal after the queued hook in the verdict task, where
the guard is no longer set. A later dup rule can clone the packet again,
causing repeated packet processing and resource consumption.

Record the duplication state in nf_queue_entry and use a separate
reinjection flag while nf_reinject() resumes hook traversal. Consult that
flag only in task context: local_bh_enable() can process pending softirqs
before reinjection finishes, and those packets must not inherit the
reinjection guard. Restore the verdict task's prior flag on every exit.

The netdev dup path uses a separate xmit recursion counter. Mark cloned
output within the BH-disabled transmit section so NFQUEUE entries created
there retain the duplication state. The counter itself remains unchanged.
This covers NFQUEUE reinjection only; it does not carry duplicate state
across an independent device receive path.

Fixes: cd58bcd9787e ("netfilter: xt_TEE: have cloned packet travel through Xtables too")
Fixes: 8537f78647c0 ("netfilter: Introduce egress hook")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
---
changes in v7:
  - replace the v6 user-namespace setup restriction with NFQUEUE state
    capture and restoration
  - use a separate reinjection flag checked only in task context, and scope
    the netdev dup marker to its BH-disabled transmit section
  - cover queued IPv4/IPv6 duplication and nft_dup_netdev clones; restore the
    verdict task's previous state on every exit path
  - keep the claim limited to NFQUEUE reinjection, not independent device
    receive paths
  - point the netdev NFQUEUE Fixes tag to the earliest egress-hook
    introduction (8537f78647c0), not the current reintroduction
    (42df6e1d221d)
  - v6 Link:
    https://lore.kernel.org/all/82abaa776053bb3e716095a783722452d87fa039.1791429178.git.zihanx@nebusec.ai/
changes in v6:
  - reroll the unchanged four-file setup-time restriction on nf.git main at
    ab699d296e06
  - do not present v5 build or runtime results as v6 validation
  - v5 Link:
    https://lore.kernel.org/all/20260929125832.25316-1-zihanx@nebusec.ai/
changes in v5:
  - describe the patch as a non-initial-userns setup restriction, not a
    general recursion fix; state that init_user_ns behavior is unchanged
  - remove path-specific trigger details and run-specific metrics from the
    public commit and cover prose
  - drop d877f07112f1 from Fixes: because it added a later frontend, not the
    shared duplication behavior addressed by that restriction
  - record the v5 build and setup-time validation, distinguishing them from
    earlier unpatched-baseline and root-OOM runs
  - v4 Link:
    https://lore.kernel.org/all/cover.1790408011.git.zihanx@nebusec.ai/
changes in v4:
  - add Fixes tags for TEE, IPv4/IPv6 nft dup, and netdev nft dup
    frontends
  - clarify that fcd53c51d037 only added a synchronous guard
  - clarify that this restricts non-initial user namespaces and does not
    fix asynchronous recursion in init_user_ns-owned network namespaces
  - state explicitly that the netdev loop was not runtime-reproduced
  - v3 Link:
    https://lore.kernel.org/all/cover.1790042930.git.zihanx@nebusec.ai/
changes in v3:
  - reroll the fix against the latest nf.git main after no follow-up on v2
  - add the Co-developed-by trailer and matching Signed-off-by
  - v2 Link:
    https://lore.kernel.org/all/cover.1788425393.git.zihanx@nebusec.ai/
changes in v2:
  - drop the persistent struct sk_buff::nf_duplicated field and nf_copy()
    change from v1
  - disable IPv4/IPv6 duplication in non-initial user namespaces
  - v1 Link:
    https://lore.kernel.org/all/cover.1787903722.git.zihanx@nebusec.ai/
---
 include/linux/sched.h            |  2 ++
 include/net/netfilter/nf_queue.h |  1 +
 net/ipv4/netfilter/ip_tables.c   |  5 ++++-
 net/ipv4/netfilter/nf_dup_ipv4.c |  5 ++++-
 net/ipv6/netfilter/ip6_tables.c  |  5 ++++-
 net/ipv6/netfilter/nf_dup_ipv6.c |  6 +++++-
 net/netfilter/nf_dup_netdev.c    | 13 ++++++++++++-
 net/netfilter/nf_queue.c         |  4 ++++
 net/netfilter/nfnetlink_queue.c  |  8 +++++++-
 9 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d35ae49a9..f1ffc9d48 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1070,6 +1070,8 @@ struct task_struct {
 	unsigned                        in_thrashing:1;
 #endif
 	unsigned			in_nf_duplicate:1;
+	unsigned			in_nf_dup_netdev:1;	/* netdev dup output is active */
+	unsigned			in_nf_duplicate_reinject:1;	/* NFQUEUE resume */
 #ifdef CONFIG_PREEMPT_RT
 	struct netdev_xmit		net_xmit;
 #endif
diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index fc3e81c07..d6d335273 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -23,6 +23,7 @@ struct nf_queue_entry {
 	struct net_device	*physout;
 #endif
 	struct nf_hook_state	state;
+	bool			in_nf_duplicate;	/* skb is on a duplication path */
 	bool			nf_ct_is_unconfirmed;
 	u16			size; /* sizeof(entry) + saved route keys */
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 809441ced..7c2027ef8 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -14,6 +14,7 @@
 #include <linux/vmalloc.h>
 #include <linux/netdevice.h>
 #include <linux/module.h>
+#include <linux/preempt.h>
 #include <net/ip.h>
 #include <net/compat.h>
 #include <linux/uaccess.h>
@@ -270,7 +271,9 @@ ipt_do_table(void *priv,
 	 * but it is no problem since absolute verdict is issued by these.
 	 */
 	if (static_key_false(&xt_tee_enabled))
-		jumpstack += private->stacksize * current->in_nf_duplicate;
+		jumpstack += private->stacksize *
+			     (current->in_nf_duplicate ||
+			      (in_task() && current->in_nf_duplicate_reinject));
 
 	e = get_entry(table_base, private->hook_entry[hook]);
 
diff --git a/net/ipv4/netfilter/nf_dup_ipv4.c b/net/ipv4/netfilter/nf_dup_ipv4.c
index 9a773502f..1cac70cac 100644
--- a/net/ipv4/netfilter/nf_dup_ipv4.c
+++ b/net/ipv4/netfilter/nf_dup_ipv4.c
@@ -7,6 +7,7 @@
  */
 #include <linux/ip.h>
 #include <linux/module.h>
+#include <linux/preempt.h>
 #include <linux/percpu.h>
 #include <linux/route.h>
 #include <linux/skbuff.h>
@@ -52,9 +53,11 @@ void nf_dup_ipv4(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 		 const struct in_addr *gw, int oif)
 {
 	struct iphdr *iph;
+	bool in_nf_duplicate_reinject = in_task() &&
+					current->in_nf_duplicate_reinject;
 
 	local_bh_disable();
-	if (current->in_nf_duplicate)
+	if (current->in_nf_duplicate || in_nf_duplicate_reinject)
 		goto out;
 	/*
 	 * Copy the skb, and route the copy. Will later return %XT_CONTINUE for
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 313c4aac3..017b57691 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -17,6 +17,7 @@
 #include <linux/vmalloc.h>
 #include <linux/netdevice.h>
 #include <linux/module.h>
+#include <linux/preempt.h>
 #include <linux/poison.h>
 #include <net/ipv6.h>
 #include <net/compat.h>
@@ -292,7 +293,9 @@ ip6t_do_table(void *priv, struct sk_buff *skb,
 	 * but it is no problem since absolute verdict is issued by these.
 	 */
 	if (static_key_false(&xt_tee_enabled))
-		jumpstack += private->stacksize * current->in_nf_duplicate;
+		jumpstack += private->stacksize *
+			     (current->in_nf_duplicate ||
+			      (in_task() && current->in_nf_duplicate_reinject));
 
 	e = get_entry(table_base, private->hook_entry[hook]);
 
diff --git a/net/ipv6/netfilter/nf_dup_ipv6.c b/net/ipv6/netfilter/nf_dup_ipv6.c
index 6da3102b7..ee4262cc3 100644
--- a/net/ipv6/netfilter/nf_dup_ipv6.c
+++ b/net/ipv6/netfilter/nf_dup_ipv6.c
@@ -6,6 +6,7 @@
  * Extracted from xt_TEE.c
  */
 #include <linux/module.h>
+#include <linux/preempt.h>
 #include <linux/percpu.h>
 #include <linux/skbuff.h>
 #include <linux/netfilter.h>
@@ -47,8 +48,11 @@ static bool nf_dup_ipv6_route(struct net *net, struct sk_buff *skb,
 void nf_dup_ipv6(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 		 const struct in6_addr *gw, int oif)
 {
+	bool in_nf_duplicate_reinject = in_task() &&
+					current->in_nf_duplicate_reinject;
+
 	local_bh_disable();
-	if (current->in_nf_duplicate)
+	if (current->in_nf_duplicate || in_nf_duplicate_reinject)
 		goto out;
 	skb = pskb_copy(skb, GFP_ATOMIC);
 	if (skb == NULL)
diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index c6bd5c29b..8b8e6f938 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/netlink.h>
@@ -57,14 +58,24 @@ void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif)
 {
 	struct net_device *dev;
 	struct sk_buff *skb;
+	bool old_in_nf_dup_netdev;
+
+	if (in_task() && current->in_nf_duplicate_reinject)
+		return;
 
 	dev = dev_get_by_index_rcu(nft_net(pkt), oif);
 	if (dev == NULL)
 		return;
 
 	skb = skb_clone(pkt->skb, GFP_ATOMIC);
-	if (skb)
+	if (skb) {
+		local_bh_disable();
+		old_in_nf_dup_netdev = current->in_nf_dup_netdev;
+		current->in_nf_dup_netdev = true;
 		nf_do_netdev_egress(skb, dev, nft_hook(pkt));
+		current->in_nf_dup_netdev = old_in_nf_dup_netdev;
+		local_bh_enable();
+	}
 }
 EXPORT_SYMBOL_GPL(nf_dup_netdev_egress);
 
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 73363ceed..a1f395415 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -219,6 +220,9 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 	*entry = (struct nf_queue_entry) {
 		.skb	= skb,
 		.skb_dev = skb->dev,
+		.in_nf_duplicate = current->in_nf_duplicate ||
+				  (in_task() && current->in_nf_duplicate_reinject) ||
+				  current->in_nf_dup_netdev,
 		.state	= *state,
 		.hook_index = index,
 		.size	= sizeof(*entry) + route_key_size,
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index a3bc00280..222166898 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -13,6 +13,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/init.h>
@@ -368,9 +369,12 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	unsigned int i;
 	int err;
 	u8 pf;
+	bool old_in_nf_duplicate_reinject;
 
 	net = entry->state.net;
 	pf = entry->state.pf;
+	old_in_nf_duplicate_reinject = current->in_nf_duplicate_reinject;
+	current->in_nf_duplicate_reinject |= entry->in_nf_duplicate;
 
 	hooks = nf_hook_entries_head(net, pf, entry->state.hook);
 
@@ -378,7 +382,7 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	if (!hooks || i >= hooks->num_hook_entries) {
 		kfree_skb_reason(skb, SKB_DROP_REASON_NETFILTER_DROP);
 		nf_queue_entry_free(entry);
-		return;
+		goto out;
 	}
 
 	hook_entry = &hooks->hooks[i];
@@ -417,6 +421,8 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	}
 
 	nf_queue_entry_free(entry);
+out:
+	current->in_nf_duplicate_reinject = old_in_nf_duplicate_reinject;
 }
 
 /* return true if the entry has an unconfirmed conntrack attached that isn't owned by us
-- 
2.43.0

