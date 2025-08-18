Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D6232145D;
	Mon, 18 Aug 2025 15:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755531642; cv=none; b=BdXDAgE40naPeEUBrFk/RgoAjv8QhXoEXcsm5rqhpGMYXJdVvk/Ec592XZbN4A/TgEbvMYY/umE9BIQJQD6s14TfT4J01O6mygn2skLXwZNHezGT3MOA81adelTA2rxFfTq2YQs7e/Iku3DY25u568/vGuAWxzOCJKeJtra4CR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755531642; c=relaxed/simple;
	bh=yx4/gncC8/kNv9BYML7mQpQ1qDBOLCtw0VSWH3Enhvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smAV+AU1gNTT6Q+2jTTcSmXW+8MsBepISBn8yzqfkqn9WjjGgwGi5ra6JGxhRPzsASzqaYVqpWMJ1omPkB6eCVprU5oc2qdTYQvfEyCzsvWjqVj2WW/HfbmSX83AE76DVd3mTqGtPraCtJ9a6JMLyQG4vRbAf8RI27/zZuedSvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-32372c05c5dso868668a91.0;
        Mon, 18 Aug 2025 08:40:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755531640; x=1756136440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2ZiDhH8lJYpxsMwsOULjJgcF6kHMw4SKOMZiQSRJphw=;
        b=ZeWC77+SWoV18vnG/7frLcCexKI7pYeXWt6TOU3D99tzssRceHNO1iKNVQBB6IXK8P
         DBalFx5KgedWYfEKXMNoGOqH/3UtnNIokEBX+J6NdMdadYijgR1pVcD6+fO6qlHsLAmc
         NCN3TWic61xaE8sPg7ux0suyEoAXmEkEG7ya4/SM1XcGqlj8LzpPZavNCrt6Ikzz3bhP
         YRJwGNR1UZNi2Z9sJwSejaXoOMd21EzuvFLkGUhFT+WVk+Cc9XZYPoFzSC+QoAE4DEp0
         4RxhsZ++uunrCNcw9g+U/iPVwdnzFE9BsAFOWIAXVo2DusGf1qOv7B/NrPEFO9Z1gMpr
         JODg==
X-Forwarded-Encrypted: i=1; AJvYcCWfLTEBxxYSxBPtx1J2j0wcxjXbaFm5z77zdA9WHpN7K0Oqk7rdn9vAEzkBvmKlsB8yaopdh8T05w+8eQASa+O7@vger.kernel.org, AJvYcCXzdQZIb55UlZNHMcu4QOmHC8wvcNpLyS2ysD0Nnp19f1XNhgU/5b7ILlJ2A8qykjxVortUDj0Tcf1Oo24=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywusq+ujTsVFpiKauDbI+9vKBq3BvTaGv8wNklP7BHBHEejEuQd
	23lSdl8eH0K+0nzdZE7IluZqaX5tw+lcHLlpmf6E2ymHTXI8+o+PW1S4vmol
X-Gm-Gg: ASbGncsmCQbvE6qtbrpCA7LV3Stj00j3ySBskgWzp7KwDwUyycsW5lX42/CnIcLARpV
	mfjlYxA10AJHHvNS+40cy27wwD1Q3BzVaa89+9HrDaR34xjnOa+s09mIUnF55lkAOze2To51fUr
	MQZVBOkFha24jBzTEW/zoajTutrgzMuszGt4ifetDzvkGjX7t0dYRYuSj04M+EO7sZkYzOqOYbQ
	ZJcwhLC2Tp8shC9GYjbuGHIqsy4lLNunlDcgnz4J1ecY7LpVL7bWHgb+Lw8UjkV30an+zlIEzp7
	Oa5K3C3HFH+saPuX28nMjgYFAeLgKddbHYI8H6qw3PyLZ2GfmK39eeR9gy48KnozfQPpbJaZOXy
	JTXObj/CBuYx+UkXYtp1mPmqPdiJnISp82z1bIcMp7L4L2DqutReMw4glR80=
X-Google-Smtp-Source: AGHT+IFmU512VBEKl8tKUHinnvnnzctYutH9GE6lRXZ0n1MBwajOvk6R1sR7fEQLQmsj+Iy0n1218Q==
X-Received: by 2002:a17:90b:52c6:b0:31c:15d9:8ae with SMTP id 98e67ed59e1d1-3234218df88mr19443955a91.33.1755531640116;
        Mon, 18 Aug 2025 08:40:40 -0700 (PDT)
Received: from localhost (c-73-158-218-242.hsd1.ca.comcast.net. [73.158.218.242])
        by smtp.gmail.com with UTF8SMTPSA id 41be03b00d2f7-b472d5a7a35sm8507826a12.10.2025.08.18.08.40.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 08:40:39 -0700 (PDT)
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
	fw@strlen.de,
	steffen.klassert@secunet.com,
	sdf@fomichev.me,
	mhal@rbox.co,
	abhishektamboli9@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-staging@lists.linux.dev,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	herbert@gondor.apana.org.au
Subject: [PATCH net-next v2 7/7] net: Add skb_dst_check_unset
Date: Mon, 18 Aug 2025 08:40:32 -0700
Message-ID: <20250818154032.3173645-8-sdf@fomichev.me>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818154032.3173645-1-sdf@fomichev.me>
References: <20250818154032.3173645-1-sdf@fomichev.me>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To prevent dst_entry leaks, add warning when the non-NULL dst_entry
is rewritten.

Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
---
 include/linux/skbuff.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 7538ca507ee9..ca8be45dd8be 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1159,6 +1159,12 @@ static inline struct dst_entry *skb_dst(const struct sk_buff *skb)
 	return (struct dst_entry *)(skb->_skb_refdst & SKB_DST_PTRMASK);
 }
 
+static inline void skb_dst_check_unset(struct sk_buff *skb)
+{
+	DEBUG_NET_WARN_ON_ONCE((skb->_skb_refdst & SKB_DST_PTRMASK) &&
+			       !(skb->_skb_refdst & SKB_DST_NOREF));
+}
+
 /**
  * skb_dstref_steal() - return current dst_entry value and clear it
  * @skb: buffer
@@ -1188,6 +1194,7 @@ static inline unsigned long skb_dstref_steal(struct sk_buff *skb)
  */
 static inline void skb_dstref_restore(struct sk_buff *skb, unsigned long refdst)
 {
+	skb_dst_check_unset(skb);
 	skb->_skb_refdst = refdst;
 }
 
@@ -1201,6 +1208,7 @@ static inline void skb_dstref_restore(struct sk_buff *skb, unsigned long refdst)
  */
 static inline void skb_dst_set(struct sk_buff *skb, struct dst_entry *dst)
 {
+	skb_dst_check_unset(skb);
 	skb->slow_gro |= !!dst;
 	skb->_skb_refdst = (unsigned long)dst;
 }
@@ -1217,6 +1225,7 @@ static inline void skb_dst_set(struct sk_buff *skb, struct dst_entry *dst)
  */
 static inline void skb_dst_set_noref(struct sk_buff *skb, struct dst_entry *dst)
 {
+	skb_dst_check_unset(skb);
 	WARN_ON(!rcu_read_lock_held() && !rcu_read_lock_bh_held());
 	skb->slow_gro |= !!dst;
 	skb->_skb_refdst = (unsigned long)dst | SKB_DST_NOREF;
-- 
2.50.1

