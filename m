Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C4B49C4B8
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 07:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792050328; cv=none; b=It9kWdWFU+Jys4JENcyq6rHczujCy32nrsE5+p6LzV3R/imWY1bE29yRLZB2tF9dwhKLlF6aw56CWSKWOq6CupR/jxEUWgYW5cMDYX+kJJXQCPydrHkYk5PQFYWWdTyyMgbGCP2hEJkVGcAxSpIJ+vzAQR5U7qmGOk6Zwi4a+XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792050328; c=relaxed/simple;
	bh=uydjsRF8+x+WAcngNzwtmv3vMS/A8zQgGCCktf020Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJ7cMrdvBODXZzJ9NjIQg/0iSgLpQVA/mAYk4FZDYkXgNJFw/qK6Q9OyYP8oYTRfqSS05UqMaXh4M29zI7J0c7fTPN35JOJU5gR38/UlZqUUIFHhOlofL9fnz38H4vxAK5D41FTT4IMl8Ryfffpl2PDKBGb9xwM6qjdSzBKCulM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=nk7ZUXhM; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="nk7ZUXhM"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3ac677668a9so1154450a91.2
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 00:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1792050322; x=1792655122; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mkNMtqsX2YWk+nZqcj9+M8tuNizL7NZGfLO9i4JP5Co=;
        b=nk7ZUXhMsFO+Od9LzpRereWjfzS49J5+BfIubkxZ12pyN2PmMFRLtozpW4ErxNTec4
         0HgpQVLI63uUVnv3W+EPZDGMHXhG+kikliUVGGyYJ4H/X7TohkhzWG2NUtO6jS0nYt+H
         tXBIX8banV8qkDHRrjLnQpgMBrKzdeOCPqsJpt0WJ+tTQplWNjr2TiTZzuNVV74EvGp9
         KNiNxrhZ/1P6fNMjZR4Ut9xYnDavpYxqFEtMg8/eZj6vsGiaRuxOW9nyA532H4pDs5c7
         w8kkXgNxPUNZL0/myBbMY9np4HHD11mSaJkphtYBYPdGqPQTrq3ATK/LSvS6AhM4uepr
         oy6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792050322; x=1792655122;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mkNMtqsX2YWk+nZqcj9+M8tuNizL7NZGfLO9i4JP5Co=;
        b=0BV+A5SnDtQDM+wL+B4h5Gh1RDTQFze6oJmcPIzijZPiE6BvPfiBGqanPnTjq9CQ+v
         TAhFNWFGI38aAK3b/nyqpLoia0TsCiv0DCH33z42sSmJP0Yxl6xvEOMIE1Y2CnWkJlqt
         RQwKLJk0/m774D60NiNOIonBEPgCoSA0IVCM1RLxQmqJ3FdaUxDk471/aQ1f+LAKjnYF
         vVVibOFVSMZyV0CUpd8n23tXzdwBcPEduUtRsg9ETQnZ567qE7G1b7g3IqcXeITDuf4o
         gSG3aUzHnlsVLO9jdzhUGb4OmKq5fR8Pq2MP2rpVz79T5WKHSo4iT/1IFZuW7KytpB0n
         ejDA==
X-Gm-Message-State: AFq9FYLmM4uzjqy8JUbuBjPnPVOK1uutfYcQk/Wc9Z3oObhiqGGc5VQm
	JZfovoeT90u4B3LKYEUvlwqaRYHFY7VnNPqgUMrcGX+D9NYx1E2Obqrn2Sn6DmyeOl0AsNr9gPb
	EoatQnQ==
X-Gm-Gg: AYBFou1pBUARw61APEAblgIBIn/batXa15BrwZfR5/YuTTe3TMkRy22Yj0Bzi/+WgrZ
	9wjUuZ0yu1XX1zZe211hs7oMeqJczoq6rlMgD287JcxDcboz3dhxbUYvIyZstzUYH3DTJmEiRzq
	QQJujUHuzwONmCGfub9+NdDIIeEFf/TT/NqvT/7NzxLWFGVCv7hsDVSS6ZN7NpzyfdFhTm2vTnk
	G7Wd/IlwCBjko7APGiZtIceNU0W6xbcA4AIm+qKnZX/EGeSz60DhriE7sG3ra0jKTpUPoWmgLdI
	4lswkAMnYG7ClYio04sNgDyzMzd5L7NjCNXPYU8mtAp4NaVEhXQE7bB14NmWBODD6Rkb3cQ6DwS
	Eab6m0FJl/4Apa1JIC+4e5jUZQ7m+fkeW6IG6YkiZMbrNSZ4r+R7igEDw4KMOW6CRWUIJFlYPfE
	BEzQNeq2exbLxwNz/SOK26uFkmylbc27ch+sMSMU4B5Qoe7eZCeav9QqeODb8YrERfXbw8LpsAp
	iQASxd1GxoYwk7ND+miHI0sa44/5Q==
X-Received: by 2002:a17:90b:1d52:b0:3a6:e8fb:76b5 with SMTP id 98e67ed59e1d1-3ab3a79001bmr16349899a91.37.1792050320802;
        Thu, 15 Oct 2026 00:45:20 -0700 (PDT)
Received: from 24c857d0c3be.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac93849da5sm1636831a91.4.2026.10.15.00.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 00:45:18 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: netfilter-devel@vger.kernel.org,
	virtualization@lists.linux.dev,
	intel-wired-lan@lists.osuosl.org,
	bpf@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	kaber@trash.net,
	jengelh@medozas.de,
	andrew+netdev@lunn.ch,
	mst@redhat.com,
	jasowangio@gmail.com,
	eperezma@redhat.com,
	xuanzhuo@linux.alibaba.com,
	aleksander.lobakin@intel.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	sdf@fomichev.me,
	magnus.karlsson@intel.com,
	maciej.fijalkowski@intel.com,
	willemb@google.com,
	alice.kernel@fastmail.im,
	eilaimemedsnaimel@gmail.com,
	imv4bel@gmail.com,
	shiming.cheng@mediatek.com,
	sd@queasysnail.net,
	vega@nebusec.ai,
	root@tr0jan.top,
	zihanx@nebusec.ai
Subject: [PATCH nf v8 2/3] netfilter: nf_dup_netdev: bound asynchronous duplication
Date: Thu, 15 Oct 2026 07:43:08 +0000
Message-ID: <a23b041de631f3c3821de021cbd4d421f2359ae9.1792048855.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1792048855.git.zihanx@nebusec.ai>
References: <cover.1792048855.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The task-local transmit recursion counter covers synchronous
dev_queue_xmit() recursion, but does not follow a duplicated skb through
asynchronous receive paths. Carry a bounded duplication depth with the skb
and preserve it across skb and XDP conversions.

Store the depth in the sk_buff headers group. __copy_skb_header() copies
that group with a single memcpy(), so skb_clone() preserves the depth.
Propagate it explicitly when veth converts an skb to an XDP buffer and
when XDP buffers or frames are converted back to skbs in the core and
virtio paths. Preserve it through zero-copy XDP frame conversion as well.

Clear the depth when GRO reuses an skb and when AF_XDP or libeth
reinitializes a recycled XDP buffer, so a fresh packet does not inherit
stale recursion state.

Keep the existing recursion limit and reject MIRRED flow offload where
the software depth cannot be enforced.

Fixes: 502061f81d3e ("netfilter: nf_tables: add packet duplication to the netdev family")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
---
changes in v8:
  - explain how skb_clone() inherits the depth through the sk_buff headers
    group and identify the explicit skb/XDP propagation and reset paths
  - split the v7 NFQUEUE/netdev proposal and add the ingress
    TTL/hop-limit limit as a separate patch
  - preserve the IPv4/IPv6 recursion guard across NFQUEUE reinjection
  - bound netdev dup depth across software skb/XDP paths
  - stop IPv4 TTL and IPv6 hop-limit underflow before cloning
  - limit the netdev claim to software skb/XDP paths and document the
    MIRRED offload restriction
  - v7 Link:
    https://lore.kernel.org/all/cover.1791688819.git.zihanx@nebusec.ai/
changes in v7:
  - replace the v6 user-namespace setup restriction with NFQUEUE state
    capture and restoration
  - use a separate reinjection flag checked only in task context, and scope
    the netdev dup marker to its BH-disabled transmit section
  - cover queued IPv4/IPv6 duplication and nft_dup_netdev clones; restore the
    verdict task's previous state on every exit path
  - keep the claim limited to NFQUEUE reinjection, not independent device
    receive paths
  - add the netdev frontend Fixes tag for its separate NFQUEUE trigger path
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
    shared duplication behavior addressed by this restriction
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
 drivers/net/veth.c            |  3 +++
 drivers/net/virtio_net.c      |  3 +++
 include/linux/skbuff.h        |  9 +++++++++
 include/net/libeth/xdp.h      |  6 ++++--
 include/net/xdp.h             | 25 +++++++++++++++++++++++++
 net/core/gro.c                |  3 +++
 net/core/xdp.c                | 10 ++++++++++
 net/netfilter/nf_dup_netdev.c | 11 ++++++++++-
 net/xdp/xsk_buff_pool.c       |  2 ++
 9 files changed, 69 insertions(+), 3 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 71227d0389aa..e24a81a14301 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -771,6 +771,9 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
 	xdp_init_buff(xdp, frame_sz, &rq->xdp_rxq);
 	xdp_prepare_buff(xdp, skb->head, skb_headroom(skb),
 			 skb_headlen(skb), true);
+#if IS_ENABLED(CONFIG_NF_TABLES)
+	xdp_buff_set_nf_dup_netdev(xdp, skb->nf_dup_netdev);
+#endif
 
 	if (skb_shinfo(skb)->nr_frags) {
 		skb_shinfo(skb)->xdp_frags_size = skb->data_len;
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index daab43ac92ce..c78bcef1ef11 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2083,6 +2083,9 @@ static struct sk_buff *build_skb_from_xdp_buff(struct net_device *dev,
 	data_len = xdp->data_end - xdp->data;
 	skb_reserve(skb, headroom);
 	__skb_put(skb, data_len);
+#if IS_ENABLED(CONFIG_NF_TABLES)
+	skb->nf_dup_netdev = xdp_buff_get_nf_dup_netdev(xdp);
+#endif
 
 	metasize = xdp->data - xdp->data_meta;
 	metasize = metasize > 0 ? metasize : 0;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a3ff380d43f0..45eb9aeabfe7 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -815,6 +815,7 @@ enum skb_tstamp_type {
  *	@peeked: this packet has been seen already, so stats have been
  *		done for it, don't do them again
  *	@nf_trace: netfilter packet trace flag
+ *	@nf_dup_netdev: netdev duplication depth
  *	@protocol: Packet protocol from driver
  *	@destructor: Destruct function
  *	@tcp_tsorted_anchor: list structure for TCP (tp->tsorted_sent_queue)
@@ -1012,6 +1013,9 @@ struct sk_buff {
 #if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || IS_ENABLED(CONFIG_NF_TABLES)
 	__u8			nf_trace:1;
 #endif
+#if IS_ENABLED(CONFIG_NF_TABLES)
+	__u8			nf_dup_netdev:2;	/* netdev duplication depth */
+#endif
 #ifdef CONFIG_NET_SWITCHDEV
 	__u8			offload_fwd_mark:1;
 	__u8			offload_l3_fwd_mark:1;
@@ -4602,6 +4606,11 @@ static inline bool skb_metadata_differs(const struct sk_buff *skb_a,
 	u8 len_a = skb_metadata_len(skb_a);
 	u8 len_b = skb_metadata_len(skb_b);
 
+#if IS_ENABLED(CONFIG_NF_TABLES)
+	if (skb_a->nf_dup_netdev != skb_b->nf_dup_netdev)
+		return true;
+#endif
+
 	if (!(len_a | len_b))
 		return false;
 
diff --git a/include/net/libeth/xdp.h b/include/net/libeth/xdp.h
index 898723ab62e8..bccc244c19b9 100644
--- a/include/net/libeth/xdp.h
+++ b/include/net/libeth/xdp.h
@@ -1181,10 +1181,12 @@ libeth_xdp_init_buff(struct libeth_xdp_buff *dst,
 		     const struct libeth_xdp_buff_stash *src,
 		     struct xdp_rxq_info *rxq)
 {
-	if (likely(!src->data))
+	if (likely(!src->data)) {
 		dst->data = NULL;
-	else
+		dst->base.flags = 0;
+	} else {
 		libeth_xdp_load_stash(dst, src);
+	}
 
 	dst->base.rxq = rxq;
 }
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 07231adfb5f8..40ca174bb6b1 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -81,6 +81,9 @@ enum xdp_buff_flags {
 	 * XDP program is not attached.
 	 */
 	XDP_FLAGS_FRAGS_UNREADABLE	= BIT(2),
+	/* Netfilter netdev-dup recursion depth, carried through XDP frames. */
+	XDP_FLAGS_NF_DUP_NETDEV_SHIFT	= 3,
+	XDP_FLAGS_NF_DUP_NETDEV_MASK	= 3U << XDP_FLAGS_NF_DUP_NETDEV_SHIFT,
 };
 
 struct xdp_buff {
@@ -106,6 +109,21 @@ struct xdp_buff {
 	};
 };
 
+static __always_inline u8
+xdp_buff_get_nf_dup_netdev(const struct xdp_buff *xdp)
+{
+	return (xdp->flags & XDP_FLAGS_NF_DUP_NETDEV_MASK) >>
+		XDP_FLAGS_NF_DUP_NETDEV_SHIFT;
+}
+
+static __always_inline void
+xdp_buff_set_nf_dup_netdev(struct xdp_buff *xdp, u8 depth)
+{
+	xdp->flags &= ~XDP_FLAGS_NF_DUP_NETDEV_MASK;
+	xdp->flags |= (depth << XDP_FLAGS_NF_DUP_NETDEV_SHIFT) &
+		      XDP_FLAGS_NF_DUP_NETDEV_MASK;
+}
+
 static __always_inline void xdp_reinit_buff(struct xdp_buff *xdp)
 {
 	xdp->flags = 0;
@@ -310,6 +328,13 @@ struct xdp_frame {
 	u32 flags; /* supported values defined in xdp_buff_flags */
 };
 
+static __always_inline u8
+xdp_frame_get_nf_dup_netdev(const struct xdp_frame *frame)
+{
+	return (frame->flags & XDP_FLAGS_NF_DUP_NETDEV_MASK) >>
+		XDP_FLAGS_NF_DUP_NETDEV_SHIFT;
+}
+
 static __always_inline bool xdp_frame_has_frags(const struct xdp_frame *frame)
 {
 	return !!(frame->flags & XDP_FLAGS_HAS_FRAGS);
diff --git a/net/core/gro.c b/net/core/gro.c
index 29b4d02bf519..71044dba7cc2 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -671,6 +671,9 @@ static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
 
 	skb->encapsulation = 0;
 	skb->ip_summed = CHECKSUM_NONE;
+#if IS_ENABLED(CONFIG_NF_TABLES)
+	skb->nf_dup_netdev = 0;
+#endif
 
 	shinfo = skb_shinfo(skb);
 	shinfo->gso_type = 0;
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 1d679e8fd649..e9c66525c955 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -605,6 +605,7 @@ struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp)
 	xdpf->headroom = metasize;
 	xdpf->metasize = metasize;
 	xdpf->frame_sz = PAGE_SIZE;
+	xdpf->flags = xdp->flags & XDP_FLAGS_NF_DUP_NETDEV_MASK;
 	xdpf->mem_type = MEM_TYPE_PAGE_ORDER0;
 
 	xsk_buff_free(xdp);
@@ -658,6 +659,9 @@ struct sk_buff *xdp_build_skb_from_buff(const struct xdp_buff *xdp)
 		skb_mark_for_recycle(skb);
 
 	skb_record_rx_queue(skb, rxq->queue_index);
+#if IS_ENABLED(CONFIG_NF_TABLES)
+	skb->nf_dup_netdev = xdp_buff_get_nf_dup_netdev(xdp);
+#endif
 
 	if (unlikely(nr_frags)) {
 		u32 tsize;
@@ -773,6 +777,9 @@ struct sk_buff *xdp_build_skb_from_zc(struct xdp_buff *xdp)
 	}
 
 	skb_record_rx_queue(skb, rxq->queue_index);
+#if IS_ENABLED(CONFIG_NF_TABLES)
+	skb->nf_dup_netdev = xdp_buff_get_nf_dup_netdev(xdp);
+#endif
 
 	if (unlikely(xdp_buff_has_frags(xdp)) &&
 	    unlikely(!xdp_copy_frags_from_zc(skb, xdp, pp))) {
@@ -819,6 +826,9 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 
 	skb_reserve(skb, headroom);
 	__skb_put(skb, xdpf->len);
+#if IS_ENABLED(CONFIG_NF_TABLES)
+	skb->nf_dup_netdev = xdp_frame_get_nf_dup_netdev(xdpf);
+#endif
 	if (xdpf->metasize)
 		skb_metadata_set(skb, xdpf->metasize);
 
diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index c6bd5c29bed6..0671df72fbfa 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -58,13 +58,18 @@ void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif)
 	struct net_device *dev;
 	struct sk_buff *skb;
 
+	if (pkt->skb->nf_dup_netdev > NF_RECURSION_LIMIT)
+		return;
+
 	dev = dev_get_by_index_rcu(nft_net(pkt), oif);
 	if (dev == NULL)
 		return;
 
 	skb = skb_clone(pkt->skb, GFP_ATOMIC);
-	if (skb)
+	if (skb) {
+		skb->nf_dup_netdev = pkt->skb->nf_dup_netdev + 1;
 		nf_do_netdev_egress(skb, dev, nft_hook(pkt));
+	}
 }
 EXPORT_SYMBOL_GPL(nf_dup_netdev_egress);
 
@@ -75,6 +80,10 @@ int nft_fwd_dup_netdev_offload(struct nft_offload_ctx *ctx,
 	struct flow_action_entry *entry;
 	struct net_device *dev;
 
+	/* The netdev duplication limit is carried in the skb. */
+	if (id == FLOW_ACTION_MIRRED)
+		return -EOPNOTSUPP;
+
 	dev = dev_get_by_index(ctx->net, oif);
 	if (!dev)
 		return -EOPNOTSUPP;
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 9d2d94f1fb75..db46901a7ca6 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -633,6 +633,7 @@ static u32 xp_alloc_new_from_fq(struct xsk_buff_pool *pool, struct xdp_buff **xd
 		}
 
 		xskb = xp_get_xskb(pool, addr);
+		xskb->xdp.flags = 0;
 
 		*xdp = &xskb->xdp;
 		xdp++;
@@ -653,6 +654,7 @@ static u32 xp_alloc_reused(struct xsk_buff_pool *pool, struct xdp_buff **xdp, u3
 	while (i--) {
 		xskb = list_first_entry(&pool->free_list, struct xdp_buff_xsk, list_node);
 		list_del_init(&xskb->list_node);
+		xskb->xdp.flags = 0;
 
 		*xdp = &xskb->xdp;
 		xdp++;
-- 
2.43.0

