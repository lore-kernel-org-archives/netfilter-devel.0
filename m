Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312CC40DFDB
	for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2026 12:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779107342; cv=none; b=JsoIBecf+ZfqQ/0c5SSqCUlEpxQD2DHRakm+ExIyN02pap9y3U0RXruYogCjpkg869jAzQLCm0Fh5YI45BuLkzkQ1vsTqtz/0/ySgactb8lcAG1EFLX6EggfI4dlkIIWOdOjsIk+Uvnc4Z0HKXGLpXRpQIbM97vMKSlLedi2xkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779107342; c=relaxed/simple;
	bh=VhjFRgrOE/Yr9rD+jFPbkuXk41T6XFz1vqjlVnbwOrc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OnvIRDpz9iJ23SnJEBxlhD2rqfAjCc3pNoPlkpCu1BwlOyNXu5OGsIJ4AcMblouVdfIps4PRmUZ5RT44e6awVzuFZeoSMYGKdSINsuQFyWa1MEntK1HtDyN15xzceOYR/zWfKH2pOJdEffGlcreT5gpTBGoSJ1M3fSYo+dtrrPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yuom00P5; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yuom00P5"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4891e5b9c1fso18054765e9.2
        for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2026 05:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779107338; x=1779712138; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/vjPz0DmyFpSASa6mS0vdkZOs2FKmbSch4i9h1Pv3x0=;
        b=Yuom00P5T8iyrNaQiC6tl2KebVkReaOXMims0uEWPMRsBrdQk9qpujDU+D9kz0MyHY
         mPk6R7n2/Guu0RW+WRRzmeWU0CmIXiI9H4fz6YqjLUKV51xKEFoBp2vYjM3R+8ctlzqj
         WHafmV4+XnYTKQMkbM72z2WrDCl+P9u4FRk1JBBA1UmHpOalXLRPferYrkdkVnfvIjES
         1Q1kqb+PBxbgOWHmnT0R+5RqYgXKZXVvngEu7JrPc2Y+V/T3+68PQqVoofW5poOK56Ya
         gA6afkRhLViMq6/7StkH0WJ93vHVHpAsg15VaCxpmmPhzIpJhtFoNAr2v/Ofdik212XH
         bkzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779107338; x=1779712138;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/vjPz0DmyFpSASa6mS0vdkZOs2FKmbSch4i9h1Pv3x0=;
        b=hsuDEvSl3J6znvmOp6yv9RMo1YEITPAH7YxZ5ItvEjCF76X0PBXpLolHbpqtvmj2xL
         MiKmQs44o3XvfPSCKlvwN4EpCZgBZPCNvArbVePFKBGctYshRNDBjYkgXSPzrACaSXhe
         dJhtfO3CLB+FTte7uT7hd1B6+tNZGtJz9NPCWzBOTCvAhh3hJKYEUDOmeW+LVDqRAwGP
         r8XhBy1TYvI7DrIQNy2W2f6MH5+r/DLVU6fJsnZ4Lt5c8AsQ9OkXnowTaeSUuo0n1CbW
         6kDmt75N+T+q1IqdortG4uaDfL4RbqvEHJT5bEBVtjBIcGUUFY/apeZMByxhVkGd4Dlb
         b3iQ==
X-Forwarded-Encrypted: i=1; AFNElJ/QF3T1+OwlZgjOzMBcPYncmja6WxmiODQgsKsd7WYAuMXe25aA+SpVb23jBHP4XA9JiLu72inIch7X7j7fI6Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBsmmwAEQSveUiT5TLYKMPtJkVVzh21EbDrLyfZJp91A9+jTe/
	lg9qxBhlZerNEU/QdQamBWLn5eMrJKP2/0jzXyrCpkDeufBSQa74vgVa
X-Gm-Gg: Acq92OG288N30LJfmVghUdkt+zxCO2Lt6LRD4/CH2QJy5LWM8tuGEPw7pYuaKAVGH0z
	+MzWk/vPq/rYad7odJHipAIjYEkavVQd90SbZNMSpA7AA6/eVq2CW2BFG/XgWyP2I/hs40lRVy9
	Kn3o6U6UxjqyU2MzRhgTG14/IdC1+0eJ5PWp/iPM0tpOyj8SI0yRTed1PLMd4YOeoCSAhKfUqxJ
	4rB+hFZJKGslc0MvDf6h+zfG6WGAaBANWYlgtCi7y0xxDlElDftGvgcCGoAFIpLexJckVtehZEZ
	5fwd/iqPKoXMVLOfh4w8Flr6AGQ0Mbs+N1WkmNVg4Jyc464nFPx8kg4qg6pLykBqStpxuYL0BPw
	qNmEAm0BX+wxQ0BYJ7VIbWmX6u6vUY2sWgs0ag/RRB7OwLLmYPTN12C+jQJJBjtew3rh1xWQwUj
	vZg5r+tgvbnURZhunu03cQxraC2SE=
X-Received: by 2002:a05:600c:4695:b0:490:389:7648 with SMTP id 5b1f17b1804b1-49003897711mr105489705e9.20.1779107338182;
        Mon, 18 May 2026 05:28:58 -0700 (PDT)
Received: from mtardy-friendly-lvh-runner.local ([2600:1900:4010:1a8::])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-48ff2cb4ae0sm104304315e9.0.2026.05.18.05.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 05:28:57 -0700 (PDT)
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
Subject: [PATCH bpf-next v6 1/6] net: move netfilter nf_reject_fill_skb_dst to core ipv4
Date: Mon, 18 May 2026 12:28:37 +0000
Message-Id: <20260518122842.218522-2-mahe.tardy@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260518122842.218522-1-mahe.tardy@gmail.com>
References: <20260518122842.218522-1-mahe.tardy@gmail.com>
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

