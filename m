Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE52936F430
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 15:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779809849; cv=none; b=LeVF5OqSJljXMb4KDubU7sAdlwTy3GbWshvWIgn5RycthdocCaaW6yC9pQAFppP9CtFqJLSDoc20v0VwezFc8pU3bkt5J2JpaTLNzuYIgzq4TxGd+B8/EZCJbZtEeBAfaO4y0pRdR+yX4olxD+UZAbNiVY7E7z4MZAW21CsvUVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779809849; c=relaxed/simple;
	bh=ov6+gI2FLpcVjn6o4KEEVsXvNT4PPkAZoGWX5AxLtwA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TmqyRwUoSIRH1FL2Xgm7/0hDlnhUGHsihbwiLXBvrzSKgSrD695VMYlrs4BfOFrmLy6iVATevhoE2IR3HJKYFTp1a4m9MAkVeIjPeFmXfkK5rssUdYYbcEGZqBmq923oyThZSsa+fF0PNr1uJHUXrDliP5hpo1Gz07XvKqsLjaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qUzjdB/E; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qUzjdB/E"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49039a8851fso52138365e9.2
        for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 08:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779809846; x=1780414646; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yuw5xtr2C0czpVUWTefIMp0AVKJYHgH7hJ3FkPC09qM=;
        b=qUzjdB/Ekp5/EDPQLZDgXhY22H/264L6qn0ZqQP33EGh8TphndCVBdTfOdeyeS9kcl
         pkCFr7MH0M9K1WJYn0MceoeynTreZ/19d5SztIk1OeVGLc0cbjCTqfcjPLqeVCS9DgDf
         B+HJPjodKThi/zDVoZZZxpM5EGqQmQ+/JRE2MLVybmE+tju0gZlBwOrIGu6WHwCv3QI6
         n2NV3smEbuAzpdsGfbLRLXVNZAvsbGbqn0ZbKDUqIKHUxLnMJFYu+LTxJCJlkz8RVV/Z
         WIzEPncGHOoN2KSADk+4QeqdTR7mjJUjiKWqGZJosAl9mpV1KpDDoJJiCmjUD9JgqLS+
         53Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779809846; x=1780414646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yuw5xtr2C0czpVUWTefIMp0AVKJYHgH7hJ3FkPC09qM=;
        b=jmjfCPtB4quiJeriMfWZ4SjHzGybAaIEhOuk2o47iUd42Y8sjeFD4OfXevMZ8SpN+a
         VmjvhiW+tD4jdod+Gg2rp5Ty1GmLfStua6ecNB0wMY87iVj4dbdCbXFEVutwkWBelESv
         +1deh8jKdX5MjdlZzGztTPxojd97i0zV0/v69ZC5LiQzX7fPJsu/cxLHjOQ5YiiA1YXG
         bOrhyivoTRMskFqGh5z6SwY4MMu0ghfh8RnaRUoowe4Nrq5MXabo0h0aLtwrn33B8qDU
         ONFsKOQaG8nrRX59xLZ3wvyWtCwwpp4izAlhJgrmnmpRvmoPPcjpZJAV/aVMHkfWcfah
         Q8tw==
X-Forwarded-Encrypted: i=1; AFNElJ+On5Ob1Po3y/+1iFROdUr2FMYDQenOH/N9eTuS8HodtrOmribY9MuokYEVaeIw/nxTq4uCOfPQ3nKf0WaZUCw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHfnT1O6AYtONejJV54bJtm14KVVZP0TAo+a+grocfL8eo3Cnr
	ipVWSJ5r/YOKKIvpzFvJfSBQXclwUKyyYank/mRknDwNRUGoZQTxcpzy
X-Gm-Gg: Acq92OGhOl1sT5E5hRrU6no10SEfOPeTxGZsX+FBajaPEkk0mk18CrPrsKpvhhf+iT4
	orTdHM6OZKjDhrlk4sN1+/Jj5Ffoe3et14FToFdX1QxsCryMeCfrMcoZzUmXLYYTv2cCJYi+i7K
	tqHFv95vk3wOu5e3LbXgYtHWH9eKQVC6lPvojzPtEibBFRpi8LUrUyiIhdNn8LeEZATR11Asl+W
	PBNUeDm4i2y4ZEIv6x4HBbQOeyZWtnCvLCnAoBE7ijbNqxH7bicBd4jJOGBMrsAgtSs7SPJXz+J
	Os6+GdoAKCTzLb/4FoKuQVYFyu+urpGtygbMoHemxPstu1JyQbfmV2rW8PvOTqSyPj4yO7SbaaM
	nKgX7/ryEeIGDdeKaZqJad737T3fgsE8famz+VK46ICNKwjY7aHiHSPbSUDoe0SOVwH8tL62NIg
	LRyb5a74wXtr6IW3jbnN8adqCxlIk=
X-Received: by 2002:a05:600c:8b86:b0:490:58f4:ba2f with SMTP id 5b1f17b1804b1-49058f4bb2fmr221243485e9.23.1779809846361;
        Tue, 26 May 2026 08:37:26 -0700 (PDT)
Received: from mtardy-friendly-lvh-runner.local ([2600:1900:4010:1a8::])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4907df9edeasm1083655e9.9.2026.05.26.08.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 08:37:25 -0700 (PDT)
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
Subject: [PATCH bpf-next v7 2/7] net: move netfilter nf_reject6_fill_skb_dst to core ipv6
Date: Tue, 26 May 2026 15:37:03 +0000
Message-Id: <20260526153708.279717-3-mahe.tardy@gmail.com>
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

Move and rename nf_reject6_fill_skb_dst from
ipv6/netfilter/nf_reject_ipv6 to ip6_route_reply_fill_dst in
ipv6/route.c so that it can be reused in the following patches by BPF
kfuncs.

Netfilter uses nf_ip6_route that is almost a transparent wrapper around
ip6_route_output so this patch inlines it.

Signed-off-by: Mahe Tardy <mahe.tardy@gmail.com>
---
 include/net/ip6_route.h             |  2 ++
 net/ipv6/netfilter/nf_reject_ipv6.c | 17 +----------------
 net/ipv6/route.c                    | 18 ++++++++++++++++++
 3 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 09ffe0f13ce7..eb5a60d3babe 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -100,6 +100,8 @@ static inline struct dst_entry *ip6_route_output(struct net *net,
 	return ip6_route_output_flags(net, sk, fl6, 0);
 }

+int ip6_route_reply_fill_dst(struct sk_buff *skb);
+
 /* Only conditionally release dst if flags indicates
  * !RT6_LOOKUP_F_DST_NOREF or dst is in uncached_list.
  */
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index ef5b7e85cffa..7d2f577e72b8 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -293,21 +293,6 @@ nf_reject_ip6_tcphdr_put(struct sk_buff *nskb,
 						   sizeof(struct tcphdr), 0));
 }

-static int nf_reject6_fill_skb_dst(struct sk_buff *skb_in)
-{
-	struct dst_entry *dst = NULL;
-	struct flowi fl;
-
-	memset(&fl, 0, sizeof(struct flowi));
-	fl.u.ip6.daddr = ipv6_hdr(skb_in)->saddr;
-	nf_ip6_route(dev_net(skb_in->dev), &dst, &fl, false);
-	if (!dst)
-		return -1;
-
-	skb_dst_set(skb_in, dst);
-	return 0;
-}
-
 void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 		    int hook)
 {
@@ -440,7 +425,7 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
 	if (hooknum == NF_INET_LOCAL_OUT && skb_in->dev == NULL)
 		skb_in->dev = net->loopback_dev;

-	if (!skb_dst(skb_in) && nf_reject6_fill_skb_dst(skb_in) < 0)
+	if (!skb_dst(skb_in) && ip6_route_reply_fill_dst(skb_in) < 0)
 		return;

 	icmpv6_send(skb_in, ICMPV6_DEST_UNREACH, code, 0);
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index e3d355d1fbd6..37a7627a94de 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2725,6 +2725,24 @@ struct dst_entry *ip6_route_output_flags(struct net *net,
 }
 EXPORT_SYMBOL_GPL(ip6_route_output_flags);

+int ip6_route_reply_fill_dst(struct sk_buff *skb)
+{
+	struct dst_entry *result;
+	struct flowi6 fl = {
+		.daddr = ipv6_hdr(skb)->saddr
+	};
+	int err;
+
+	result = ip6_route_output(dev_net(skb->dev), NULL, &fl);
+	err = result->error;
+	if (err)
+		dst_release(result);
+	else
+		skb_dst_set(skb, result);
+	return err;
+}
+EXPORT_SYMBOL_GPL(ip6_route_reply_fill_dst);
+
 struct dst_entry *ip6_blackhole_route(struct net *net, struct dst_entry *dst_orig)
 {
 	struct rt6_info *rt, *ort = dst_rt6_info(dst_orig);
--
2.34.1

