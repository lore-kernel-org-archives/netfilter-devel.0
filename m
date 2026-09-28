Received: from mail-qk2-f42.google.com (mail-qk2-f42.google.com [74.125.230.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEE428B4E2
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 12:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790599586; cv=none; b=WaYqqTNTwijF0QDzVl4QMeiKKMXiCQWiwkbd865tfbvPilI95HxcLXPxNmkYw2f6sGdgU7epwxs/YlWdxiMxjP+Nu6wXBTmvOFJ5snYwMp4wyL4huROrtZsAj9QOicb917NVW3eIO7EP9siYVpQnS1xfQs3km6IBVoYDO942xrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790599586; c=relaxed/simple;
	bh=+73/2RVBZYhVjjU/QQ1pwX2flkUzIR8XUWrSaPb43Ck=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qKQir1FxoTzwhmzr5pLryGXYU96FNSScfJ+jZYtubngT1Payuayo1pOwDzBcpR2q5QohWn32xpkJH3+Wau6RjyUuHu2Zdq3gsY2LsG6+H7JKdxv5Ve5clXY42MJHbZSAK+hHURLkzH0ElbP+wjYvA+bCB//OQGtby4DT1aNgRCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.b=t43bwN9F; arc=none smtp.client-ip=74.125.230.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.b="t43bwN9F"
Received: by mail-qk2-f42.google.com with SMTP id af79cd13be357-93c56f7c1c8so249471585a.3
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 05:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu.com; s=google; t=1790599582; x=1791204382; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dRdc59m05rXeVS+DzkOtjK1VVLnJwJSXDPTVMzkoQik=;
        b=t43bwN9FI0CW5dIbQwRkpIXY0fHHPzIn0KwBH14sbcK4whIH83wB/CM3ociNGh/TIN
         KI/JLgtDGhhTleutx6lY9fmkHpqyxjmQxcjEhs/NKPg+QKIizL301b6bxrG0+ik+weER
         aeujcwM3IJo8EQvUlvSpg0/PLYunMkn18gr6M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790599582; x=1791204382;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dRdc59m05rXeVS+DzkOtjK1VVLnJwJSXDPTVMzkoQik=;
        b=Zoa2vPXTA3xZwr4o7zATvmZ+t/n2fDmb6eKHSxYczPbIKWHfY6hpIZi50kr/aUP0fX
         yTzmK2gglaRkoQmJzABK/5gmulRNiiCZQxN6IC5YZYB83+Kj27Fk+3lMPp63Vo/9VDnm
         D75Jhh3DHU4gq3PoE5GfboJCEy5SjqHrfaciCitS+e40ewZr9P1uiVQeNAdQeeE+ZT5c
         dG5DE30XhE6hfledwjF5mMLx3J7gJpJD0HfgqixyrSqIYGzeLymHzh4/Ih+csJg6Ljzk
         JkKAULOco05wwSz7BOW0tkM2BGZBaPp3U+HJW4GsyONHzgVOfAr6egHmgG/FgGD7KURc
         MRig==
X-Forwarded-Encrypted: i=1; AKwUvBwn+hpZvDq5VPcfJAdPJ6C9cT2NUSb5TNvlPkeCBMDFlpKuPzmMsfkaNe7E7oPvQ7QblDrXrdHon9bwBzC0gAI=@vger.kernel.org
X-Gm-Message-State: AFuF++kDFSHxV7SPsxTdbNukkEV9DGCfpFZjqwCDFZIpexeLGYdKePEy
	Dh7RccUnY8TsL2oK9J8L8uTfZ8zyToU71EGur4wh0dkFXpfCuLVGav4Ud0awAX2Fkg==
X-Gm-Gg: AYBFou0ArsRHZyHcvSk8lvEpZ/vtQ1BiYtzylO7ft1Sxup7SsCXuRaiOb8367uojjdQ
	05quIYaXrjMUAx5KkTKggCZjE2ysJQS+0B0Bt3YLyLJuSiLT/xuO9HwNeRfFIUrYgrvTrfyJaw8
	o7C2SWbSF1Fy4/7HN9csQFD2tvOe8KbqzWMkuHEkDwk29sga9MlyLnHwdZwLZA6bYNPdXpE43uB
	I5crPACtuKQikAFgac8gDeMs4n6UTYBl02uFSjVKb8o5qld+2Eq8OIw+kWOY3MNqkEWb8QVQtEL
	hVtgMsOqjB2PM6Q6bSmB4rBwpca0s1mz4owZF8MXN8tKIjB0uqcpRANHFQNUffVOl2swGa814O3
	0luwZCPymrbzDgWi7Qc4a2r0ONSVvyam4z2SjCIYMHELrYASfKkXGqKiGilgn3RMkPrNJzZNWqS
	vBrBtbRe1O6c/pzWoup95WmuxeLAy/QfGinpX2i2UcBifwMpjQbQH29Q6wKi4kJzYv2EtiHc6gr
	wswz6VMJNvThKAxAXVkLJ6vQlfsS+Dcw72Q1GfQ++IL/cp6nrNv8/6QLF+v
X-Received: by 2002:a05:620a:40d2:b0:93b:fafd:3adf with SMTP id af79cd13be357-93c43d0ddf0mr1940331985a.48.1790599580774;
        Mon, 28 Sep 2026 05:46:20 -0700 (PDT)
Received: from mbili.tail33bf8.ts.net ([64.203.83.2])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c813cf71asm138091685a.20.2026.09.28.05.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 05:46:20 -0700 (PDT)
From: Jamal Hadi Salim <jhs@mojatatu.com>
To: netdev@vger.kernel.org
Cc: Jamal Hadi Salim <jhs@mojatatu.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tonghao Zhang <xiangxia.m.yue@gmail.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Victor Nogueira <victor@mojatatu.com>,
	Zero Day Initiative <zdi-disclosures@trendmicro.com>,
	hybris <hybris@mojatatu.ai>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>
Subject: [PATCH net v4] net: cap skb->queue_mapping when the tx queue is picked
Date: Mon, 28 Sep 2026 08:46:16 -0400
Message-Id: <QDISC-9R8V.v4.20260928081529@mojatatu.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

skbedit can set skb->queue_mapping and raise the per-CPU skip_txqueue
flag so __dev_queue_xmit() honours the mapping. __dev_queue_xmit()
cleared the flag before sch_handle_egress() and only read it afterwards,
so the flag was not confined to the xmit that set it: a nested xmit
(mirred redirect or mirror, or a drop after skbedit) could set the flag
and the outer xmit would consume it for an skb that never went through
skbedit.

A forwarded packet still carries the ingress NIC's rx_queue + 1 in
skb->queue_mapping, so the outer device then indexes its tx queue state
with that stale value. Taprio's child array q->qdiscs[] is sized to the
device's queue count, so taprio_enqueue() indexes past its allocation
and dereferences the result as a struct Qdisc *.

We (ab)use the skb->nf_skip_egress which means "skip netfilter egress
for this packet" to tag to "am I in tc egress?". Despite the overload
I dont see it as a conflict since the marker is set only around the
single sch_handle_egress() call and ingress path is guarded by
tc_at_ingress.
I will send a followup(net-next) patch once this hits net-next to
rename the skb->nf_skip_egress bit/flag to skb->skip_egress

Arm the flag only from the egress classifier that can use it: raise
skip_txqueue from tcf_skbedit_act() only when it runs inside
sch_handle_egress(), thanks to skb->nf_skip_egress. An egress qdisc
classifier runs in q->enqueue(), after the tx queue has been picked,
so a mapping it sets cannot affect the current packet; arming the flag
there only pollutes it for a later xmit. Then own the flag for the xmit
frame the egress hook runs in: save the incoming value and clear it just
before sch_handle_egress(), and restore it after the hook - on the
consumed (drop) path, or, in the same call that reads it, on the
surviving path. The save and the restores stay inside the
egress_needed_key static branch, so a packet pays for them only when
egress hooks are active (2f1e85b1aee4).

Store the value netdev_cap_txqueue() selected back into skb->queue_mapping
in netdev_tx_queue_mapping(), as netdev_core_pick_tx() already does, so
the skip_txqueue path never hands a later reader on the xmit path a
mapping the device cannot serve. A store made still later in the same
frame, by a tc BPF program attached to a transmit qdisc, is outside this
path and is not re-capped; a separate followup will resolve that path.

netdev_xmit_skip_txqueue() returns the previous flag value so the
save-and-clear is one call, and a no-op stub is provided when
CONFIG_NET_EGRESS is disabled. skb->nf_skip_egress is compiled under
CONFIG_NET_EGRESS rather than CONFIG_NETFILTER_SKIP_EGRESS, so
skb_at_tc_egress() is valid whenever the egress path is built.

A local user in a network namespace can redirect a packet from a device
with more TX queues to one with fewer after setting a mapping valid only
on the larger device. That reaches these reads and, under KASAN, faults
with "slab-out-of-bounds in taprio_enqueue".

Conditions to recreate the bug: the report's own trigger is a local user
with CAP_NET_ADMIN in a network namespace, so no eBPF program is needed.
With CONFIG_NET_SCH_TAPRIO=y, CONFIG_NET_ACT_SKBEDIT=y,
CONFIG_NET_ACT_MIRRED=y, CONFIG_NET_CLS_MATCHALL=y,
CONFIG_NET_SCH_PRIO=y and KASAN enabled, create qa (3 queues), qb
(2 queues) and qc (1 queue) as dummy devices; put a taprio root on qb
(num_tc 1, queues 2@0) and clsact on all three; then add an egress
matchall filter on every device. On qa: "action skbedit queue_mapping 2
pipe action mirred egress redirect dev qb". On qb: "action mirred egress
mirror dev qc". On qc: "action skbedit queue_mapping 0 pipe". Send one
packet out qa. qc's skbedit sets the flag while qb's outer xmit is in
flight; without the fix qb consumes it and reads its two-entry taprio
child array with the forwarded packet's stale mapping. A qc whose
skbedit is instead installed in a transmit-qdisc classifier (a matchall
filter on the qc root qdisc) reaches the same code path the same way
without the fix.

Testing: on a KASAN build with panic_on_warn=1 the unfixed kernel panics
with "BUG: KASAN: slab-out-of-bounds in taprio_enqueue", a read 0 bytes
past a 16-byte taprio_init() allocation, for the clsact-setter and the
transmit-qdisc-classifier reproducers and for a clsact skbedit-then-tc-BPF
store; the fixed kernel runs all three with no report, and the BPF store
variant additionally shows the expected "selects TX queue" clamp notice
from the write-back.

Fixes: 2f1e85b1aee4 ("net: sched: use queue_mapping to pick tx queue")
Reported-by: Zero Day Initiative <zdi-disclosures@trendmicro.com>
Link: https://lore.kernel.org/netdev/CANn89iLwYx8nCVf0pCEk_MmEiyC6kQaMwCQT9WkQVeeNzNQHqQ@mail.gmail.com/
Link: https://lore.kernel.org/netdev/179008581937.2160803.7117814290574262942@kernel.org/
Link: https://lore.kernel.org/netdev/179033713973.2160803.4914570693994398206@kernel.org/
Link: https://lore.kernel.org/netdev/20260925180407.63647514@kernel.org/
Link: https://lore.kernel.org/netdev/CANn89i+k-mZKDQVtvws_MEXeuMTAdaCcOXFZE-RfhcGTu90sjA@mail.gmail.com/
Suggested-by: Eric Dumazet <edumazet@google.com>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Tested-by: hybris <hybris@mojatatu.ai>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
v3 -> v4:
- Arm skip_txqueue from tcf_skbedit_act() only inside sch_handle_egress()
  (new skb_at_tc_egress() helper); a transmit-qdisc classifier runs after
  the tx queue is picked, so its flag set could not affect the current
  packet and only leaked to a later xmit (Eric Dumazet).
- Move the save/clear/restore back inside the egress_needed_key static
  branch: with the only producer inside sch_handle_egress() the
  branch-local lifetime is sufficient, and packets no longer pay a
  per-CPU read/write when no egress hook is active (Eric Dumazet).
- Compile skb->nf_skip_egress under CONFIG_NET_EGRESS rather than
  CONFIG_NETFILTER_SKIP_EGRESS.
- Keep the retval helper, the !CONFIG_NET_EGRESS stub and the
  netdev_tx_queue_mapping() capped write-back.
- Add to Cc more stake holders.

v2 -> v3:
- netdev_xmit_skip_txqueue() returns the previous flag value, so the entry
  save-and-clear is one call; a no-op stub is provided when
  !CONFIG_NET_EGRESS, removing the three inline #ifdefs (Jakub Kicinski).
- Narrow the capability claim: the capped write-back covers the
  skip_txqueue path only; a store made later in the frame by a tc BPF
  program on a transmit qdisc is not re-capped and is a separate followup
  (nipa Sashiko).
- Comment: "per-CPU (per-task on PREEMPT_RT)" (nipa Sashiko).
- Drop the now-redundant #ifdef in act_skbedit.c.

v1 -> v2:
- Rework the root cause to the per-CPU skip_txqueue flag lifetime: it was
  cleared before sch_handle_egress() and read after, so a nested xmit could
  set it and the outer xmit consume it for an skb that never went through
  skbedit (Eric Dumazet, nipa Sashiko).
- Retain the v1 producer-side cap (netdev_tx_queue_mapping() writes the
  clamped value back).
- Correct the description of the reproducer to a three-device chain
  (qa 3q -> qb 2q taprio -> qc 1q).

 include/linux/netfilter_netdev.h |  2 +-
 include/linux/rtnetlink.h        |  7 ++++++-
 include/linux/skbuff.h           |  2 +-
 include/net/sch_generic.h        |  9 +++++++++
 net/core/dev.c                   | 31 ++++++++++++++++++++++++-------
 net/sched/act_skbedit.c          |  5 ++---
 6 files changed, 43 insertions(+), 13 deletions(-)

diff --git a/include/linux/netfilter_netdev.h b/include/linux/netfilter_netdev.h
index 3175073a66ba..2a854a0bbd4b 100644
--- a/include/linux/netfilter_netdev.h
+++ b/include/linux/netfilter_netdev.h
@@ -133,7 +133,7 @@ static inline struct sk_buff *nf_hook_egress(struct sk_buff *skb, int *rc,
 
 static inline void nf_skip_egress(struct sk_buff *skb, bool skip)
 {
-#ifdef CONFIG_NETFILTER_SKIP_EGRESS
+#ifdef CONFIG_NET_EGRESS
 	skb->nf_skip_egress = skip;
 #endif
 }
diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index 95729339e7a5..a54ec40d095c 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -186,7 +186,12 @@ void net_dec_ingress_queue(void);
 #ifdef CONFIG_NET_EGRESS
 void net_inc_egress_queue(void);
 void net_dec_egress_queue(void);
-void netdev_xmit_skip_txqueue(bool skip);
+bool netdev_xmit_skip_txqueue(bool skip);
+#else
+static inline bool netdev_xmit_skip_txqueue(bool skip)
+{
+	return false;
+}
 #endif
 
 void rtnetlink_init(void);
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 84308498a3a8..a3ff380d43f0 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1020,7 +1020,7 @@ struct sk_buff {
 #ifdef CONFIG_NET_REDIRECT
 	__u8			from_ingress:1;
 #endif
-#ifdef CONFIG_NETFILTER_SKIP_EGRESS
+#ifdef CONFIG_NET_EGRESS
 	__u8			nf_skip_egress:1;
 #endif
 #ifdef CONFIG_SKB_DECRYPTED
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index f35bd06a6bad..1acaadb3e2cf 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -810,6 +810,15 @@ static inline bool skb_at_tc_ingress(const struct sk_buff *skb)
 #endif
 }
 
+static inline bool skb_at_tc_egress(const struct sk_buff *skb)
+{
+#ifdef CONFIG_NET_EGRESS
+	return skb->nf_skip_egress && !skb_at_tc_ingress(skb);
+#else
+	return false;
+#endif
+}
+
 static inline bool skb_skip_tc_classify(struct sk_buff *skb)
 {
 #ifdef CONFIG_NET_CLS_ACT
diff --git a/net/core/dev.c b/net/core/dev.c
index f660fccfc0db..8638c994bbcb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4404,9 +4404,14 @@ EXPORT_SYMBOL(dev_loopback_xmit);
 static struct netdev_queue *
 netdev_tx_queue_mapping(struct net_device *dev, struct sk_buff *skb)
 {
-	int qm = skb_get_queue_mapping(skb);
+	int queue = skb_get_queue_mapping(skb);
+	int capped;
 
-	return netdev_get_tx_queue(dev, netdev_cap_txqueue(dev, qm));
+	capped = netdev_cap_txqueue(dev, queue);
+	if (unlikely(capped != queue))
+		skb_set_queue_mapping(skb, capped);
+
+	return netdev_get_tx_queue(dev, capped);
 }
 
 #ifndef CONFIG_PREEMPT_RT
@@ -4415,9 +4420,13 @@ static bool netdev_xmit_txqueue_skipped(void)
 	return __this_cpu_read(softnet_data.xmit.skip_txqueue);
 }
 
-void netdev_xmit_skip_txqueue(bool skip)
+bool netdev_xmit_skip_txqueue(bool skip)
 {
+	bool prev = netdev_xmit_txqueue_skipped();
+
 	__this_cpu_write(softnet_data.xmit.skip_txqueue, skip);
+
+	return prev;
 }
 EXPORT_SYMBOL_GPL(netdev_xmit_skip_txqueue);
 
@@ -4427,9 +4436,13 @@ static bool netdev_xmit_txqueue_skipped(void)
 	return current->net_xmit.skip_txqueue;
 }
 
-void netdev_xmit_skip_txqueue(bool skip)
+bool netdev_xmit_skip_txqueue(bool skip)
 {
+	bool prev = netdev_xmit_txqueue_skipped();
+
 	current->net_xmit.skip_txqueue = skip;
+
+	return prev;
 }
 EXPORT_SYMBOL_GPL(netdev_xmit_skip_txqueue);
 #endif
@@ -4848,21 +4861,25 @@ int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 	tcx_set_ingress(skb, false);
 #ifdef CONFIG_NET_EGRESS
 	if (static_branch_unlikely(&egress_needed_key)) {
+		bool skip_txq;
+
 		if (nf_hook_egress_active()) {
 			skb = nf_hook_egress(skb, &rc, dev);
 			if (!skb)
 				goto out;
 		}
 
-		netdev_xmit_skip_txqueue(false);
+		skip_txq = netdev_xmit_skip_txqueue(false);
 
 		nf_skip_egress(skb, true);
 		skb = sch_handle_egress(skb, &rc, dev);
-		if (!skb)
+		if (!skb) {
+			netdev_xmit_skip_txqueue(skip_txq);
 			goto out;
+		}
 		nf_skip_egress(skb, false);
 
-		if (netdev_xmit_txqueue_skipped())
+		if (netdev_xmit_skip_txqueue(skip_txq))
 			txq = netdev_tx_queue_mapping(dev, skb);
 	}
 #endif
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index bfec6b668410..26258b353cde 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -72,9 +72,8 @@ TC_INDIRECT_SCOPE int tcf_skbedit_act(struct sk_buff *skb,
 	}
 	if (params->flags & SKBEDIT_F_QUEUE_MAPPING &&
 	    skb->dev->real_num_tx_queues > params->queue_mapping) {
-#ifdef CONFIG_NET_EGRESS
-		netdev_xmit_skip_txqueue(true);
-#endif
+		if (skb_at_tc_egress(skb))
+			netdev_xmit_skip_txqueue(true);
 		skb_set_queue_mapping(skb, tcf_skbedit_hash(params, skb));
 	}
 	if (params->flags & SKBEDIT_F_MARK) {
