Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FD13A1E70
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Dec 2025 21:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766696561; cv=none; b=cdSkgjxpKFaDx+eVHwlIgFXTq8LWJxRSyfwGndyDeNgokQBiPWTRZs5btWvVehm3mNK/YpMW/HSIuXlivfWPUexQCZZBR7CQnUtfi+pA+rfmH6OccKaZ+fV0HXtKuUW19+L2pq2ldn/c3or87Vh6p6Hh+EKf8gyFV653cGqTZQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766696561; c=relaxed/simple;
	bh=5/mJ+GM77wd9yVHoRhoZ6HzRdQGOxB4xaIBCLekK+Rk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=adKLR0Cfk/gLJljrucE/SWHMUS8qGr44kBQP/xj+7PnbkvbQKa07MGOLETEFZ4OvOjoV0jmcTbDN4y70apNdOUKdHvgdk5eAmzyzh3KL7/7lbl2iu8TJJkd47uE1xkSux5lEvce79MIENxvsKZIjyMc/+d+snYvsFYxgTI+TdV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b=hJfu8+bA; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b="hJfu8+bA"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-88fdac49a85so33409236d6.0
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Dec 2025 13:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20230601.gappssmtp.com; s=20230601; t=1766696559; x=1767301359; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=E9rsTX5Yid/6usuz603tSD+vnaGi2M2iqYSzD/+yP+A=;
        b=hJfu8+bAii0K7N35IWwiXCE65XesMfdJy5CuHliA5DOo+ufoH22gvQhCfOWboNnIq6
         kfhJuMlTZbnGBDZ44R57/FIilaWwfCBMdO9eEUw+WyGJu6Mqd5t/gmLqgrpDcTFGUO98
         M/0F9Hzv45XzdkPRZulTXBPXkmXdpNwK16xbVIt3RsMR4H8SoJqkE51OYbva0zVDQUSe
         BWfeI7+aOTOWEiLU6wTpNQwAdCCj7P9Bvo2c0mvnOENiAJuGl0PDfqmYa4zF8BBby79L
         vry/GYr236D97qGtXkv1iDzFlOP4INXmRzwCco+FKVe12y5b+i4tXUy4Jx+aczuZjvHC
         oC3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766696559; x=1767301359;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E9rsTX5Yid/6usuz603tSD+vnaGi2M2iqYSzD/+yP+A=;
        b=BvnKvvWgIMz1ZN3YALb8FrW4eSLmalGWeUm1R2ebUomc/nwn8Aiw/QJh0q147RJt0w
         IEPwcxHh4JseTzUGMqFAYj/Kzf+ku4cZT/jGMds3HaSLuXlziwdbDJZTsEKBMfdh/VC/
         5YGJ57WfEOn4KGP6o8vdmMDnS+vjDg2XxKXsDaNXRS+PRnlJjgVYQvNbCQ6CN5kOiAxb
         RNlKZzFzoRCJ40dQkCpyJSeSABM/yJIjf0U7ix4c4LxNmPcjU5lpZdYiXkL0XPmcmAFv
         97yuuA1YpV7dof+wsT1y0v3Es7X5Jj0biGGoOgq2Bq6ET1gI80tEfENL7dK7qx1FBYFe
         nSKA==
X-Forwarded-Encrypted: i=1; AJvYcCWV9jbrU5ZE2g487SjP752TE5ftNBXtFCN1xKJB9aYM5XkEBYdW1ciQqG4hXD7drLRkx4EzIuh9GhioZR3ACwg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxX1WlL51ls2WBkFJQhPwUzSaqgSXVGyOX1MixHrh7wy/FVXoR1
	Usa2yJl/yg6mcHwI4GIfhoi+cd5LXrogkVEItKw+Zgs+4gHBJmtJBX0pCiLPr8CJeQ==
X-Gm-Gg: AY/fxX6FxI9ql6ib4NLqO0KkVOPVh52tpV0cu9ye48AStusE6xI5VzOE4SJYiDiqC/M
	94m+A/FokLt+QJ+cOWTlbkoc1Uco2aLn/tFy9vBIaKacGRzGovlegqKlMcl8RdpLSObzF6daP7q
	9io/ePdYVc7grWkE3J9xmmHqqajp9KnRdgxowy22ve7orUWaKouUoacYPBzIBAE/qoAJWm9c5Wm
	l4a4lnDR5hioTWSsn7Gc7ct6vaiaHhwuTkXWr1baUyejUQig4CEwwWnVuWr1IZt/Yi4YLjbty/k
	pHwd/glq5fd2p3b7nrkpX7a6T7OM5r+ckzjNgNmvQYqyhC1qO3Q2CmRmFzPoYMdP0xcrDZW9bJb
	3rYagtOSH9m9UBBDNXrb+3dm0TaGMAc+rcVVZwmgumSctkMdAXDMzEBaURDSj+cN+W4DIc093GJ
	qHrcE1zbN06GEaCt6AVlbuEw==
X-Google-Smtp-Source: AGHT+IEhxElW9Wxc4MWiMp2RDmmsBUDoUeYPP1kJv7VCYwX3ped446mLuxxgktp8zI8BF72G+c8emw==
X-Received: by 2002:a05:6214:1873:b0:88a:2343:3ae0 with SMTP id 6a1803df08f44-88d851fd745mr248900036d6.3.1766696558666;
        Thu, 25 Dec 2025 13:02:38 -0800 (PST)
Received: from majuu.waya ([70.50.89.69])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88d99d7e926sm149254146d6.42.2025.12.25.13.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Dec 2025 13:02:37 -0800 (PST)
From: Jamal Hadi Salim <jhs@mojatatu.com>
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	andrew+netdev@lunn.ch
Cc: netdev@vger.kernel.org,
	xiyou.wangcong@gmail.com,
	jiri@resnulli.us,
	victor@mojatatu.com,
	dcaratti@redhat.com,
	lariel@nvidia.com,
	daniel@iogearbox.net,
	pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	will@willsroot.io,
	stephen@networkplumber.org,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH RFC net v4 1/1] net: sched: Fix ethx:ingress -> ethy:egress -> ethx:ingress mirred loop
Date: Thu, 25 Dec 2025 16:02:21 -0500
Message-Id: <20251225210221.152189-1-jhs@mojatatu.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since V1:
1) Fix compile issues found by Intel bot. Thank you bot
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512121401.3NRi0dUf-lkp@intel.com/
2) Fix other issues found by patchwork
 - https://patchwork.kernel.org/project/netdevbpf/patch/20251210172554.1071864-1-jhs@mojatatu.com/
3) The AI reviewer claimed there was an issue but the link was a 404
 - https://netdev-ai.bots.linux.dev/ai-review.html?id=23b3f0a5-ca6c-4cd2-962e-34cbf46f9d24

Changes since V2:
Fix compile issues found by Intel bot. Thank you bot!
The bot created the issue by unselecting ifb.
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512140745.hsk9Cf0J-lkp@intel.com/

Changes since v3:
From Victor - add support for netem loop fix.
Post RFC would need for William's patch to be reverted.

This patch could be broken down into multiple patches(at least three), but
posted as one because it is an RFC.

For netem, see Will's current fix: ec8e0e3d7ade ("net/sched: Restrict conditions for adding duplicating netems to qdisc tree")

A simple test:

tc qdisc add dev lo root handle 1: netem limit 1 duplicate 100%
tc qdisc add dev lo parent 1: handle 2: netem gap 1 limit 1 duplicate 100% delay 1us reorder 100%
ping -I lo -f -c1 -s48 -W0.001 127.0.0.1

For the mirred case:
When mirred redirects from egress to ingress the loop state is lost.
This is because the current loop detection mechanism depends on the device
being rememebred on the sched_mirred_dev array; however, that array is
cleared when we go from egress->ingress because the packet ends up in the
backlog and when we restart from the backlog the loop is amplified, on and
on...

A simple test case:

tc qdisc add dev ethx clsact
tc qdisc add dev ethy clsact
tc filter add dev ethx ingress protocol ip \
   prio 10 matchall action mirred egress redirect dev ethy
tc filter add dev ethy egress protocol ip \
   prio 10 matchall action mirred ingress redirect dev ethx

ping such that packets arrive on ethx. Puff and sweat while the cpu
consumption goes up. Or just delete those two qdiscs from above
on ethx and ethy.

For this to work we need to _remember the loop state in the skb_.
We reclaim the bit "skb->from_ingress" to the qdisc_skb_cb since its use
is constrained for ifb. We then use an extra bit that was available on
the skb for a total of 2 "skb->ttl" bits.
Mirred increments the ttl whenever it sees the same skb. We then
catch it when it exceeds MIRRED_NEST_LIMIT iterations of the loop.

Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 drivers/net/ifb.c              |  2 +-
 include/linux/skbuff.h         | 24 ++----------------------
 include/net/sch_generic.h      | 27 +++++++++++++++++++++++++++
 net/netfilter/nft_fwd_netdev.c |  1 +
 net/sched/act_mirred.c         |  4 +++-
 net/sched/sch_netem.c          |  7 +++----
 6 files changed, 37 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index d3dc0914450a..137a20e4bf8c 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -124,7 +124,7 @@ static void ifb_ri_tasklet(struct tasklet_struct *t)
 		rcu_read_unlock();
 		skb->skb_iif = txp->dev->ifindex;
 
-		if (!skb->from_ingress) {
+		if (!qdisc_skb_cb(skb)->from_ingress) {
 			dev_queue_xmit(skb);
 		} else {
 			skb_pull_rcsum(skb, skb->mac_len);
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 86737076101d..7f18b0c28728 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -840,6 +840,7 @@ enum skb_tstamp_type {
  *	@no_fcs:  Request NIC to treat last 4 bytes as Ethernet FCS
  *	@encapsulation: indicates the inner headers in the skbuff are valid
  *	@encap_hdr_csum: software checksum is needed
+ *	@ttl: time to live count when a packet loops.
  *	@csum_valid: checksum is already valid
  *	@csum_not_inet: use CRC32c to resolve CHECKSUM_PARTIAL
  *	@csum_complete_sw: checksum was completed by software
@@ -1000,6 +1001,7 @@ struct sk_buff {
 	/* Indicates the inner headers are valid in the skbuff. */
 	__u8			encapsulation:1;
 	__u8			encap_hdr_csum:1;
+	__u8			ttl:2;
 	__u8			csum_valid:1;
 #ifdef CONFIG_IPV6_NDISC_NODETYPE
 	__u8			ndisc_nodetype:2;
@@ -1016,9 +1018,6 @@ struct sk_buff {
 	__u8			offload_l3_fwd_mark:1;
 #endif
 	__u8			redirected:1;
-#ifdef CONFIG_NET_REDIRECT
-	__u8			from_ingress:1;
-#endif
 #ifdef CONFIG_NETFILTER_SKIP_EGRESS
 	__u8			nf_skip_egress:1;
 #endif
@@ -5352,30 +5351,11 @@ static inline bool skb_is_redirected(const struct sk_buff *skb)
 	return skb->redirected;
 }
 
-static inline void skb_set_redirected(struct sk_buff *skb, bool from_ingress)
-{
-	skb->redirected = 1;
-#ifdef CONFIG_NET_REDIRECT
-	skb->from_ingress = from_ingress;
-	if (skb->from_ingress)
-		skb_clear_tstamp(skb);
-#endif
-}
-
 static inline void skb_reset_redirect(struct sk_buff *skb)
 {
 	skb->redirected = 0;
 }
 
-static inline void skb_set_redirected_noclear(struct sk_buff *skb,
-					      bool from_ingress)
-{
-	skb->redirected = 1;
-#ifdef CONFIG_NET_REDIRECT
-	skb->from_ingress = from_ingress;
-#endif
-}
-
 static inline bool skb_csum_is_sctp(struct sk_buff *skb)
 {
 #if IS_ENABLED(CONFIG_IP_SCTP)
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index c3a7268b567e..b34a1ba258c1 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -459,6 +459,14 @@ struct qdisc_skb_cb {
 	u8			post_ct:1;
 	u8			post_ct_snat:1;
 	u8			post_ct_dnat:1;
+#ifdef CONFIG_NET_REDIRECT
+	/* XXX: For RFC,  we should review and/or fix CONFIG_NET_REDIRECT
+	 * dependency or totally get rid of the NET_REDIRECT Kconfig (which
+	 * would work assuming qdisc_skb_cb is omni present; need to check
+	 * on netfilter dependency; everything else depends on mirred.
+	 */
+	u8			from_ingress:1;
+#endif
 };
 
 typedef void tcf_chain_head_change_t(struct tcf_proto *tp_head, void *priv);
@@ -1140,6 +1148,25 @@ static inline void qdisc_dequeue_drop(struct Qdisc *q, struct sk_buff *skb,
 	q->to_free = skb;
 }
 
+static inline void skb_set_redirected(struct sk_buff *skb, bool from_ingress)
+{
+	skb->redirected = 1;
+#ifdef CONFIG_NET_REDIRECT
+	qdisc_skb_cb(skb)->from_ingress = from_ingress;
+	if (qdisc_skb_cb(skb)->from_ingress)
+		skb_clear_tstamp(skb);
+#endif
+}
+
+static inline void skb_set_redirected_noclear(struct sk_buff *skb,
+					      bool from_ingress)
+{
+	skb->redirected = 1;
+#ifdef CONFIG_NET_REDIRECT
+	qdisc_skb_cb(skb)->from_ingress = from_ingress;
+#endif
+}
+
 /* Instead of calling kfree_skb() while root qdisc lock is held,
  * queue the skb for future freeing at end of __dev_xmit_skb()
  */
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 152a9fb4d23a..d62c856ef96a 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -16,6 +16,7 @@
 #include <net/netfilter/nf_dup_netdev.h>
 #include <net/neighbour.h>
 #include <net/ip.h>
+#include <net/sch_generic.h>
 
 struct nft_fwd_netdev {
 	u8	sreg_dev;
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 91c96cc625bd..4a945ea00197 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -318,8 +318,10 @@ static int tcf_mirred_to_dev(struct sk_buff *skb, struct tcf_mirred *m,
 
 		skb_set_redirected(skb_to_send, skb_to_send->tc_at_ingress);
 
+		skb_to_send->ttl++;
 		err = tcf_mirred_forward(at_ingress, want_ingress, skb_to_send);
 	} else {
+		skb_to_send->ttl++;
 		err = tcf_mirred_forward(at_ingress, want_ingress, skb_to_send);
 	}
 	if (err)
@@ -434,7 +436,7 @@ TC_INDIRECT_SCOPE int tcf_mirred_act(struct sk_buff *skb,
 #else
 	xmit = this_cpu_ptr(&softnet_data.xmit);
 #endif
-	if (unlikely(xmit->sched_mirred_nest >= MIRRED_NEST_LIMIT)) {
+	if (skb->ttl >= MIRRED_NEST_LIMIT - 1) {
 		net_warn_ratelimited("Packet exceeded mirred recursion limit on dev %s\n",
 				     netdev_name(skb->dev));
 		return TC_ACT_SHOT;
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 32a5f3304046..7363e13286de 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -461,7 +461,8 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	skb->prev = NULL;
 
 	/* Random duplication */
-	if (q->duplicate && q->duplicate >= get_crandom(&q->dup_cor, &q->prng))
+	if (q->duplicate && !skb->ttl &&
+	    q->duplicate >= get_crandom(&q->dup_cor, &q->prng))
 		++count;
 
 	/* Drop packet? */
@@ -539,11 +540,9 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	 */
 	if (skb2) {
 		struct Qdisc *rootq = qdisc_root_bh(sch);
-		u32 dupsave = q->duplicate; /* prevent duplicating a dup... */
 
-		q->duplicate = 0;
+		skb2->ttl++; /* prevent duplicating a dup... */
 		rootq->enqueue(skb2, rootq, to_free);
-		q->duplicate = dupsave;
 		skb2 = NULL;
 	}
 
-- 
2.34.1

