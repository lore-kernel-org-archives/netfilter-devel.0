Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA09636896F
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 15:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779809848; cv=none; b=U5FhI8CRjEvJuPzbKNOBJFsH0po8b4ksq0bz1q44LxXPTy9pC+3TsMRg9msz6QgmHy0XGoTEHQLkr3VL3cS4m33GOWpNv1WPaBtnzYg/UKqw6F3diUudWyLYh77qlMNBvnK/QtH/aut+4krtw4qwSOFwguKpZ+OEKZHuuGdGYis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779809848; c=relaxed/simple;
	bh=VhjFRgrOE/Yr9rD+jFPbkuXk41T6XFz1vqjlVnbwOrc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rcEpZiUBTvWcXS6tO/o03mV0tmhW5Jd1Fh0d6J93uHVCRW/tfHrRHKywrz///MeCFDsTGIvVpQuSOHHWaKidwudZlinnmRKrt2lo4U7ViildsbZFq8tCjNR93zq6YPrQPzcmMv2Eio9d9FmBNYwRLkoqdzM8ikDihTcumGOhpg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Syw9Gz+6; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Syw9Gz+6"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4903997fcb5so52228605e9.2
        for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 08:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779809845; x=1780414645; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/vjPz0DmyFpSASa6mS0vdkZOs2FKmbSch4i9h1Pv3x0=;
        b=Syw9Gz+6My4UCDlXnGVE9gD8Sty5486C8Q7fkma2wJyT+QWVW8W0Dx1Hs1DgRR8waS
         Vz71kAn377a3oFyrzJ/lMxE7/4KGUCcUE5p4e4eILaCgFUhSyYKQifI41ReyQ9QA4Agh
         W5GjYb1tcCb4VuVDurJIRlzPqZ9QGsHP2dlq1yr4nlxqbFOirVTJw6k/CJiceosi6YKR
         Ag+5+VYKECXfuLb3KH8vpQQe/IMSsXV4i4u6yEZoGf4aMnechi0EJ2osuzZnz0q1+cxI
         86NqRgYdFagPWrR1gG/7OolHhdIV4RUjonK62ClmxVZKITF4Wp5Ge6m24X1X+l9nvWAy
         00gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779809845; x=1780414645;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/vjPz0DmyFpSASa6mS0vdkZOs2FKmbSch4i9h1Pv3x0=;
        b=DaFBkMKpnEl4LgbmOu0T6iPZ3lX5u8NtmPmBAPRHJCXMLXNXKeBf/JB3KA5PwsS5W2
         QL4yDCmGTnbtVe+Ds/CAbaPE/bWjptEYqTaffq7sgDbZ5dOyYsUbXKq4ZjOakKAoEcGB
         iKnzzmOycSqoq/7CB82co2B/R5cQviQv6DZvAxFKHDgS6KV20bdFqawVew3OyzYZX4X5
         UIeuprW7mIM/BCyqf9u89zxB0bn9A9wthS5MqowrQpNCBUjXtgCXQq/9Uvu3H/O5st4x
         GbbpYL7zrpQgueZ8gOyRKAB1uUzn3v5yIgUMRA/g2QJcapOPfx3ZxWnNuXM7mbIVk8vd
         sn5A==
X-Forwarded-Encrypted: i=1; AFNElJ8u5aFn+dx26+7I41Qt3T8iXv2KElryBKl7GF40/3T4m4na9jJMsNkqlkBm6ITJ+TVb2U5yAp/DrwU8t4fRYn0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxL0INElISSeVQFjt7oQjqNfkyPwbck40htfUqu+Q92AlVVTw0t
	2YrRCqdso1ioxGos5+SI0TbzKXTP7+UPUr6sTSOzkvvmEbDa+2GvqKMW
X-Gm-Gg: Acq92OEd3Rrm5pSLbehg/VQ59JO1ZCKKQLRZV4EzTmFa/1pmJPaR307zmEFLSoe697B
	j20EPNN1RuSwNL7q65utn6VaHzGD06VQZNg8eK7lidhHFQcnxqwke3UAmsYVcvOFO/7ra8GXEo9
	qhuW9+I6BCtd1Pgtr5i35SwbZniaoX/eVUypcs7sRIRraptYEIJTlA2g8DlzxtNw35xGz7+Wpnk
	a9M6WHeEThd4i8Szzlgeu4BJZdraxZwIVsIjWQSjx0QM0bGpDt2xsqaRwv0LruXRSQ3y0RwT3v/
	blcGxOEiXqQ3jn66Np0aeb8HsQC9lgWDcmkswMW6jp9pvc1cv6KoXkzDZcJRvCVBPpDHVrIrq6P
	Ksh427dzy0lLuT7lWZ5AZppyaWcuj85CvAq8mxYZPNJ2ja2t3ZyhPxaI6kilGQkdVySwX0oJGVH
	jzNsVPHvS3LYIIxK9BqDQXaCgUa9fyvpMhOy076TxbXoNzKqqz
X-Received: by 2002:a05:600c:4583:b0:489:1b10:d896 with SMTP id 5b1f17b1804b1-49042252732mr317911715e9.0.1779809844968;
        Tue, 26 May 2026 08:37:24 -0700 (PDT)
Received: from mtardy-friendly-lvh-runner.local ([2600:1900:4010:1a8::])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4907df9edeasm1083655e9.9.2026.05.26.08.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 08:37:24 -0700 (PDT)
From: Mahe Tardy <mahe.tardy@gmail.com>
To: bpf@vger.kernel.org
Cc: martin.lau@linux.dev,
	daniel@iogearbox.net,
	john.fastabend@gmail.com,
	ast@kernel.org,
	andrii@kernel.org,
	yonghong.song@linux.dev,
	jordan@jrife.io,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	Mahe Tardy <mahe.tardy@gmail.com>
Subject: [PATCH bpf-next v7 1/7] net: move netfilter nf_reject_fill_skb_dst to core ipv4
Date: Tue, 26 May 2026 15:37:02 +0000
Message-Id: <20260526153708.279717-2-mahe.tardy@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260526153708.279717-1-mahe.tardy@gmail.com>
References: <20260526153708.279717-1-mahe.tardy@gmail.com>
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
index bc1296f0ea69..1f031c5ef554 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2945,6 +2945,21 @@ struct rtable *ip_route_output_flow(struct net *net, struct flowi4 *flp4,
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

