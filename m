Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB73A37883C
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2026 12:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782129931; cv=none; b=cjhRuerueoV29t432+PNSaoFSeA6MSFg1ANaMyNcb9TH0694wuKShNdubLU1YcjBxzrEHeKIxelkU7lGFWt+RZMPmCdYIDqeDjDeK2ewWBVEN5hSpI7gxzh6kW2+2HHCxF0QhXB2zpxayYbjtsJ0cniYNnpwHvvf4nTV8A4vm1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782129931; c=relaxed/simple;
	bh=jq2Q7kF2niLdJHIw0DqhPfXbN3I9G2RrHLnNNIj0aVs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RyZjfSXljVnjzSLpSpya6AQmdycZ/8ClFlNMPxtHepvbVsMgYyjnyJRoHYTu9C0oS+jima1hqH1eo82zAjBXGwQ8Zs7CrdmdmRZEO9XB6UvmS+nwVN1RBDesl8oxrgRmy9x9Dzvv5JCbaf1c4PVJbk7KWEysBKmWTIJV3xQPnfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VLwhaMa1; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VLwhaMa1"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490b211ee6aso29523285e9.3
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2026 05:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782129928; x=1782734728; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LmxexLRgCg6Lmd6HPPcx8J9aTH3v2szSsHJ7h8NrQDY=;
        b=VLwhaMa1OG1Gd7EZ1pGpyswFaThbgKepoqzUGiRA36PrOUgXlDp5zlgpWlzZUdCWq6
         8n3C16/sY9Nre3WKaTru4IBT7FpH8ZGFrHuODq/NhmieHoNg5ctYkevGGjXFD5kMS/3U
         Jv1M+ydmmJ9+DEB8LvdzyRWB/KDFDVRIWZ4L8i1HtpGHRSTDx0fikgLKgDYGe6jhuvy2
         leufWbwJZFlkl0KVkKr3QcVP4krNqMmWQEfp04NB47LD2sG3UGzNaNf281m0zo7GtmnO
         FBeEeOqkCOz0PxAq1DILfhR6wFFr95k7GNJV1Q36RP2lDC6O8Kx8r6RevSUL4c6ikvHs
         DSVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782129928; x=1782734728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LmxexLRgCg6Lmd6HPPcx8J9aTH3v2szSsHJ7h8NrQDY=;
        b=B+yQ1xkydPPHSfc+F/rTQl53knoATmb1htunlf5J4Uxa/Zk1/1OS5DqI51ziwpKK2x
         u/4AjhjfVzB4PrRefg86mMsJ/GcEhgQu/flU84AGppWLuSFlT50oLLw748Y1upN96zR/
         nc5CA6mKRauOQxafHnTJEKsSGnOxmss9GtCFPn8KAnDPKCoGXHfhWEfftwzpiSBqOY+x
         avhPpjjrB9+6zuP7cl7aVBkvps1kc7rxnQkZqaZlT3K7wMgQFdIZWwod331RaMZrrFX/
         1hAnuAsbKNj+Jgaj4WDTfuljleln6GwC5SbZ6NHktigKO6MKXiI4d3cRJZ4TQIA2od8z
         Pzdw==
X-Forwarded-Encrypted: i=1; AFNElJ+prwnSHpMqDzu7iO/zu1THnN6RwqVr4QUajpp8OOirYrjtIXOFbX08PWBbNRTd3p+8VEkAi4hxEiHQrYK+AG8=@vger.kernel.org
X-Gm-Message-State: AOJu0YywnM45Hj4duYoUPVZ00Wg5GFc8XoAepqq5SQQGtvo2KzSy0v6n
	9jgAkJK0tZqpj7ERYOJxsLRUQ2+SMIB3QWvWA3b76Y7W34rsfqIXvBSU
X-Gm-Gg: AfdE7ckSPSaLVejH6MVZR5iKEUa4/0racNn5CVQofyO/qF+yNLNJi3PocDPS9Ci5xSU
	kDZO8KccXipfF5d6/5ZjjQbAYWFd7HP7LV1waLTkRkM7+tj11xF4lOHiSvv6KZMybJeYKTq1Yhv
	C+V65ExAM9fdtTIfoH2xNFESm6Ns4CzviDFdzMvRwrGa6Ytz7lwTjbXo5hAFuBpbCb1PcLTLB3H
	7s1fcQOfxedQbJT4LPIz0HMopF9T02H9BnXoKoAR8BSOXGebUnx8Gz1lGUEVmmiHo/wPFMubf0h
	tmDmvrMNLrjwgBkAXqqBCNNTxjziXHAgHlQ3X6fen6KBJuBHoC7wyCM6NWnISEeV8pR25/nEaXX
	VdCiXPKBDTS/dJgeloLAVV1J8MtVQgepoUVd4JxWXnq3dBUTZCdCbcR9Bg1eRpiEPIRpYMwDnG2
	bNVAjo+picE9kiBq+pNQlCuEBknbo=
X-Received: by 2002:a05:600d:4448:20b0:490:da12:f1fa with SMTP id 5b1f17b1804b1-49240ea7f99mr191740295e9.31.1782129928229;
        Mon, 22 Jun 2026 05:05:28 -0700 (PDT)
Received: from mtardy-friendly-lvh-runner.local ([2600:1900:4010:1a8::])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4923fc47720sm491083105e9.0.2026.06.22.05.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 05:05:27 -0700 (PDT)
From: Mahe Tardy <mahe.tardy@gmail.com>
To: bpf@vger.kernel.org
Cc: andrii@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	edumazet@google.com,
	john.fastabend@gmail.com,
	jordan@jrife.io,
	kuba@kernel.org,
	martin.lau@linux.dev,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	pabeni@redhat.com,
	yonghong.song@linux.dev,
	Mahe Tardy <mahe.tardy@gmail.com>
Subject: [PATCH bpf-next v8 1/7] net: move netfilter nf_reject_fill_skb_dst to core ipv4
Date: Mon, 22 Jun 2026 12:05:09 +0000
Message-Id: <20260622120515.137082-2-mahe.tardy@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260622120515.137082-1-mahe.tardy@gmail.com>
References: <20260622120515.137082-1-mahe.tardy@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move and rename nf_reject_fill_skb_dst from
ipv4/netfilter/nf_reject_ipv4 to ip_route_reply_fill_dst in ipv4/route.c
so that it can be reused in the following patches by BPF kfuncs.

Netfilter uses nf_ip_route that is almost a transparent wrapper around
ip_route_output_key so this patch inlines it.

Reviewed-by: Jordan Rife <jordan@jrife.io>
Signed-off-by: Mahe Tardy <mahe.tardy@gmail.com>
---
 include/net/route.h                 |  1 +
 net/ipv4/netfilter/nf_reject_ipv4.c | 19 ++-----------------
 net/ipv4/route.c                    | 15 +++++++++++++++
 3 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/include/net/route.h b/include/net/route.h
index f90106f383c5..300d292cd9a1 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -173,6 +173,7 @@ struct rtable *ip_route_output_flow(struct net *, struct flowi4 *flp,
 				    const struct sock *sk);
 struct dst_entry *ipv4_blackhole_route(struct net *net,
 				       struct dst_entry *dst_orig);
+int ip_route_reply_fill_dst(struct sk_buff *skb);

 static inline struct rtable *ip_route_output_key(struct net *net, struct flowi4 *flp)
 {
diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index fecf6621f679..c1c0724e4d4d 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -252,21 +252,6 @@ static void nf_reject_ip_tcphdr_put(struct sk_buff *nskb, const struct sk_buff *
 	nskb->csum_offset = offsetof(struct tcphdr, check);
 }

-static int nf_reject_fill_skb_dst(struct sk_buff *skb_in)
-{
-	struct dst_entry *dst = NULL;
-	struct flowi fl;
-
-	memset(&fl, 0, sizeof(struct flowi));
-	fl.u.ip4.daddr = ip_hdr(skb_in)->saddr;
-	nf_ip_route(dev_net(skb_in->dev), &dst, &fl, false);
-	if (!dst)
-		return -1;
-
-	skb_dst_set(skb_in, dst);
-	return 0;
-}
-
 /* Send RST reply */
 void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 		   int hook)
@@ -279,7 +264,7 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	if (!oth)
 		return;

-	if (!skb_dst(oldskb) && nf_reject_fill_skb_dst(oldskb) < 0)
+	if (!skb_dst(oldskb) && ip_route_reply_fill_dst(oldskb) < 0)
 		return;

 	if (skb_rtable(oldskb)->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
@@ -352,7 +337,7 @@ void nf_send_unreach(struct sk_buff *skb_in, int code, int hook)
 	if (iph->frag_off & htons(IP_OFFSET))
 		return;

-	if (!skb_dst(skb_in) && nf_reject_fill_skb_dst(skb_in) < 0)
+	if (!skb_dst(skb_in) && ip_route_reply_fill_dst(skb_in) < 0)
 		return;

 	if (skb_csum_unnecessary(skb_in) ||
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 3f3de5164d6e..f24609933fbe 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2942,6 +2942,21 @@ struct rtable *ip_route_output_flow(struct net *net, struct flowi4 *flp4,
 }
 EXPORT_SYMBOL_GPL(ip_route_output_flow);

+int ip_route_reply_fill_dst(struct sk_buff *skb)
+{
+	struct rtable *rt;
+	struct flowi4 fl4 = {
+		.daddr = ip_hdr(skb)->saddr
+	};
+
+	rt = ip_route_output_key(dev_net(skb->dev), &fl4);
+	if (IS_ERR(rt))
+		return PTR_ERR(rt);
+	skb_dst_set(skb, &rt->dst);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ip_route_reply_fill_dst);
+
 /* called with rcu_read_lock held */
 static int rt_fill_info(struct net *net, __be32 dst, __be32 src,
 			struct rtable *rt, u32 table_id, dscp_t dscp,
--
2.34.1

