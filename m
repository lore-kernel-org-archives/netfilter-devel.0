Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F83C2F8BF7;
	Tue, 12 Aug 2025 15:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755013972; cv=none; b=T/0Y9xJHEEvJ6EjFvOtSKI0YnqQVyGAEID9sEtkHphAQh8V8Zp3oTx/Gct8jghNy6N5v1m/TXjoGXzzHbR6tEHL+iaPp+UBs8EV2x6EEy1e5gL7bXDTmdHiYih2uyVO8FtVoHxQu0CduAkz1AW7v4RIg9sgrd0TV4CuQv06ujuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755013972; c=relaxed/simple;
	bh=fXCtUvE3yZ8Ta3ENIVmkZfYuYynYoj4o1BaMKekS+tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0cwxyEuuZl0vtqDA0E+ZQ7RhJ3umSqGj2JoKB6jBxnYhFCePgS+QOkTkKxsKmVnM42G4dm6dlW0UEW3jYIewau2YzPis1eoaBxWh3ZxPsVmqx/1X2iXawQMluZyrjQNv1Llns+V2iRQRnF/vmzl8dPt5ICYdloY0t8Bf8E5d4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-31ecd40352fso5001553a91.2;
        Tue, 12 Aug 2025 08:52:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755013969; x=1755618769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gZ2PNbTnzBBRXiHAIHDOCvJVs332KZDFwAXo2dsewkU=;
        b=EougUcT86cWxInPR9oxemeZ2y4RYjfJffsN0ILS56dYusLJUyy2c/6r7bE5iouKCjw
         7LQdjJeP2tHLErnv+rLu+tq0ltadvfYQ+rLbxbvIMIzqTEk+OtnjevaEWeD11j2sRGp3
         kUgQVpgHGovqoUsjbVNfe/HvX4SYjDYN/BiAUnMpuKMwk5s1Q3SNSKLwFXT83lJMnlT3
         7W5FG7qDjp0tLAO5bAqoXy/n3BhR+WpKX+5pA/RomyNp4ltDIg0vTj+TfnxllRmqfWHo
         gyfSmKW7B5+87mYLoVNDqNiqf1TsEbEPFptJ9jLPcEbhS+GXkmwgU/TVx0QWVATpwR6i
         MmgQ==
X-Forwarded-Encrypted: i=1; AJvYcCVESpRdBbuMAryK0yvzNvvZB68kv91AEQSCM1Bv2Z6TuC210hZgQGxGshwQkrJUyhfVQKMnupnwXIlb5JQ=@vger.kernel.org, AJvYcCWl4EqJOADLBFfTKXzJuW50Na04d1gHMpQUNsz3Wm0TJHs8FFaWYqvNwNxjgJax4JnivdJ4+a6EOIxiplRT+uSN@vger.kernel.org
X-Gm-Message-State: AOJu0Yyzo96kxrK8L6ZTJhYSCr++zHi0MlBW0+ZQ2PTI8uqG1tEan/Tw
	AquLAdIEw4p6oflBad6eYo6K9STSeRTs8tW7r7lLxydLZUHiucQQG+Uehos3
X-Gm-Gg: ASbGncviSUcSBB0nYcIQaUMJQjz/v4OVoP4rKNgw8Zpv9q5EyOGujatKMY54IyXu9K7
	R6R/vRYFBCFacaMpJ8XULmixyCSarg3oyEKAXsSnQrcjvAhRXqeRErgm017FZBqHA/eSQNoBS3H
	2SjgyBXNQukOFmy91hUwCjrDbdclutOH+TyS2lCn9m0FaM1eZzfq0sOHcOlY9xKzsvruKSBsGeO
	dxuk17ltt/awG+/2wxF83X5UApCq9N6rrsjipNE0aLenb5y2bN4eDUC55CmkFjcVX/EWTyeObLr
	nTP5AlBq5rDdhE3NheqL6ZPoJB2Bh/05Pi1nOWGUq6xI969eDOGSc55pLTIfrRTQCs8mFmqFC8h
	LGiLr/fxqDoRAWVriVdj8IwH5F6AbbnJ5NrTmXfUCLwieHaHktio/AedeeZA=
X-Google-Smtp-Source: AGHT+IG5NYGRXdG18GJL96gJWerOeV9DFgASgRy1fmywR5uXPOGO/k6Sov9SDfx/URQS3SioUvKMIg==
X-Received: by 2002:a17:90b:48:b0:312:26d9:d5b2 with SMTP id 98e67ed59e1d1-321cf614e8amr157587a91.0.1755013969520;
        Tue, 12 Aug 2025 08:52:49 -0700 (PDT)
Received: from localhost (c-73-158-218-242.hsd1.ca.comcast.net. [73.158.218.242])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-321c2be2c2csm2278407a91.12.2025.08.12.08.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 08:52:49 -0700 (PDT)
From: Stanislav Fomichev <sdf@fomichev.me>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	ayush.sawal@chelsio.com,
	andrew+netdev@lunn.ch,
	gregkh@linuxfoundation.org,
	horms@kernel.org,
	dsahern@kernel.org,
	pablo@netfilter.org,
	kadlec@netfilter.org,
	steffen.klassert@secunet.com,
	sdf@fomichev.me,
	mhal@rbox.co,
	abhishektamboli9@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-staging@lists.linux.dev,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	herbert@gondor.apana.org.au
Subject: [PATCH net-next 3/7] netfilter: Switch to skb_dst_reset to clear dst_entry
Date: Tue, 12 Aug 2025 08:52:41 -0700
Message-ID: <20250812155245.507012-4-sdf@fomichev.me>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812155245.507012-1-sdf@fomichev.me>
References: <20250812155245.507012-1-sdf@fomichev.me>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Going forward skb_dst_set will assert that skb dst_entry
is empty during skb_dst_set. skb_dst_reset is added to reset
existing entry without doing refcnt. Switch to skb_dst_reset
in ip[6]_route_me_harder and add a comment on why it's safe
to skip skb_dst_restore.

Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
---
 net/ipv4/netfilter.c | 5 ++++-
 net/ipv6/netfilter.c | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index 0565f001120d..bda67bb0e63b 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -65,7 +65,10 @@ int ip_route_me_harder(struct net *net, struct sock *sk, struct sk_buff *skb, un
 	if (!(IPCB(skb)->flags & IPSKB_XFRM_TRANSFORMED) &&
 	    xfrm_decode_session(net, skb, flowi4_to_flowi(&fl4), AF_INET) == 0) {
 		struct dst_entry *dst = skb_dst(skb);
-		skb_dst_set(skb, NULL);
+		/* ignore return value from skb_dst_reset, xfrm_lookup takes
+		 * care of dropping the refcnt if needed.
+		 */
+		skb_dst_reset(skb);
 		dst = xfrm_lookup(net, dst, flowi4_to_flowi(&fl4), sk, 0);
 		if (IS_ERR(dst))
 			return PTR_ERR(dst);
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 45f9105f9ac1..6743c075133d 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -63,7 +63,10 @@ int ip6_route_me_harder(struct net *net, struct sock *sk_partial, struct sk_buff
 #ifdef CONFIG_XFRM
 	if (!(IP6CB(skb)->flags & IP6SKB_XFRM_TRANSFORMED) &&
 	    xfrm_decode_session(net, skb, flowi6_to_flowi(&fl6), AF_INET6) == 0) {
-		skb_dst_set(skb, NULL);
+		/* ignore return value from skb_dst_reset, xfrm_lookup takes
+		 * care of dropping the refcnt if needed.
+		 */
+		skb_dst_reset(skb);
 		dst = xfrm_lookup(net, dst, flowi6_to_flowi(&fl6), sk, 0);
 		if (IS_ERR(dst))
 			return PTR_ERR(dst);
-- 
2.50.1

