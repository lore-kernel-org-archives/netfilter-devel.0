Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38157296BCB
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Dec 2025 16:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765815371; cv=none; b=ArFNMnVK6XNYYC1FUoK6hPL71XCVMkniM/bMRmilsQGHAaAkPJzHzyY1xRcjzSU8GtBmb2iQnVmQoXxx8CAaPJ3cp85FMenDrrIzL1FfU9ElpFi8NQxgouo+xzvhU0eD6WYz2zkSYQ2F0CNiwCqGlwLchkQUrni6dbrzLR7N5YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765815371; c=relaxed/simple;
	bh=KqaiSjmSa4Qr68QYN2e5Gl5vUs2VpbqyDoMaDL7ACiQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oFQZ/4e6uBGldCA0GIbikJHTK3KcL3GvXTZbTbS9HtuYpYJUNRPy5iX1hbbRiHLJVGITp8Q/nlGLZCFUmAKqFljupkXr+Ouw8H5WJWo4ktlO6Yk/xKsg7EiHb5/G2Z7+XR3e/xsJhQblVwUTaK2ntKwaXyzrCfUeCsX+jPGz8WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b=2eHprBKu; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b="2eHprBKu"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-88a367a1db0so18097286d6.3
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Dec 2025 08:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20230601.gappssmtp.com; s=20230601; t=1765815366; x=1766420166; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WDw4KYVfuxcVTOOw8ahoBimkFT6ZVWon7a9hFOlhyDE=;
        b=2eHprBKuh2dXYnNAViNWxbExy5vL3iE9ocO4DQ85FKxNT0FmpqyQkzLFWeKrbhogJd
         aicwGrlVNEEvAcH4MkCmvDn5e1BlNBTJkB7KH4eDR2/tFTyTnCLXzetKbPSocmEGxKlH
         n9UM4l7J+PYZRFitaGNof3alBuNo2EiKMhE7/T6KNZusYMgN40AuNoSmTtflznL37QRo
         3X6TCCnb4nRmAcO4JgwCRGcLTuTNBYlUKpi3N69gJaILiq1jMhgmphWrWfHccwxmZZSJ
         9jhc6WKez6cjOTzpBpOW8gLKX0ORmO2Xu6zh2K3p4aBcPDWQz/lXDAdl6UdnFJ125QvZ
         gO3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765815366; x=1766420166;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WDw4KYVfuxcVTOOw8ahoBimkFT6ZVWon7a9hFOlhyDE=;
        b=LXxiCCWOvstw0zZKA1elKrrvebJnkkZM2p7odxqCZkDV2Rzk7bvlhcjTrvBDMRKpY/
         RqubBCdFCKM7sXpYI+XB3Clqs64tmYCZbVi10smdnxvEH+oT214mSR9WrXYQ6gIFZYeH
         Zs4RNPosID9PWmoPV6l8VofYyo5eH5182JzixsWH4pW2b9X2TFzizjbjm5VDvQu+6HDh
         Ea41re0La6zugFmc2cCUOFrSdmWzT5KPtcMHNYYArZGHuTWxsLT4rVqUsrcCCz7WhdLv
         fnyLrZKEnpmJSjjiPTjcbTwiIzqqcgnM1pZgjL1zX28WKMqlR8DlEnZN/HfoyO3gH2h5
         t9xg==
X-Forwarded-Encrypted: i=1; AJvYcCUZ7euYpNE4vCxJvfuKzETToArTjJeDk3jCERScUm4ZKXbaZimvQ+O9vRqrcXCM4rhw9CRFm2k8Q35y8ymPCQ8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxCYjM3cjidRVRhvp6jaEpi6YysxXLomU3xWQ8T35SyRL4uqid
	+qgn1o7pbN3rXH9kYOvTQb8sZ0VY5/DfaPcdex3nhe++ylMxMFXukwQZHT89PWbVOg==
X-Gm-Gg: AY/fxX6drnZo3YJgpe1xxa+OK7uLJ/18iu8LdUqhqO+tf/GLfyPf8NWm3sqE0cMM4V/
	b1J1CSN2Hc+lG07rbVRVYYVkpdwB26E94pnA1Vu3l/8vGAjRGgf9WCkE9UDlhJy/gqRfiBJFK0z
	Nt8eU0wymBdy+B4w/9UYj6E7tIDa6Mj/Y13yXT5Lx1cnAlaGj8jBGVDZ4hf8eUCItfAja2M57IU
	urVZvb8KP1vdJou6JVLrnouA7AV0LZRKADt80P31eBL0XrTfyzZFESY/OUvbvsBoYEIGiIBay2e
	stz/iEoSLsQp0IUrHP/m4ei9cybozciewawQvZk7R6ID6dtPpBaxEa7d/ksFxKFR7j3i4qGFsj7
	7s7+2oqTJxT/ORyRs75ODCZNmNkFSIXwvXLoSTSvxPGUFJ5d6OjvbTFItAyiOe/GItuiixPlTwG
	Z8mda5D3UG/g4=
X-Google-Smtp-Source: AGHT+IHd8VdwmNEn8YCNPiNUaYXMKLq+1t/sA/AKu0VgkUxQ7HtO1garqWIcdLRdwEPi6/JmWKYYfQ==
X-Received: by 2002:ad4:5dc2:0:b0:88a:4289:77c9 with SMTP id 6a1803df08f44-88a428978afmr4450906d6.10.1765815365576;
        Mon, 15 Dec 2025 08:16:05 -0800 (PST)
Received: from majuu.waya ([70.50.89.69])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88993b59838sm54627886d6.13.2025.12.15.08.16.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 08:16:04 -0800 (PST)
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
	Jamal Hadi Salim <jhs@mojatatu.com>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH RFC net v3 1/1] net: sched: Fix ethx:ingress -> ethy:egress -> ethx:ingress mirred loop
Date: Mon, 15 Dec 2025 11:15:50 -0500
Message-Id: <20251215161550.188784-1-jhs@mojatatu.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes in V1:
1) Fix compile issues found by Intel bot. Thank you bot
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512121401.3NRi0dUf-lkp@intel.com/
2) Fix other issues found by patchwork
 - https://patchwork.kernel.org/project/netdevbpf/patch/20251210172554.1071864-1-jhs@mojatatu.com/
3) The AI reviewer claimed there was an issue but the link was a 404
 - https://netdev-ai.bots.linux.dev/ai-review.html?id=23b3f0a5-ca6c-4cd2-962e-34cbf46f9d24

Changes in V2:
Fix compile issues found by Intel bot. Thank you bot!
The bot created the issue by unselecting ifb.
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512140745.hsk9Cf0J-lkp@intel.com/

This patch could be broken down into multiple patches(at least two), but
posted as one because it is an RFC.

When mirred redirects from egress to ingress  the loop state is lost.
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
 5 files changed, 34 insertions(+), 24 deletions(-)

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
-- 
2.34.1

