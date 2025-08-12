Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19A13093B7;
	Tue, 12 Aug 2025 15:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755013975; cv=none; b=ajXUnYgfm7emKjEmg5LaCLeLLZfwVhJmE323uwtZU2IT2fCtVzT9u3RVsa8VeNsTb5GGIuoCF2mNayCPcB5VkKpyeAsOt+y0mxJA3yf7dHlk12qD5GRlYdtbov+hUx7cwKL08nDFB+Fh3uID/SfprpB+9Y7FuWr1gvNmXaq5u3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755013975; c=relaxed/simple;
	bh=n0sQUuKqf3jLXpNCjqUW24KyPE8yGVDwJlEFI3R/YWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qFpZWsFjDa9uf9R8Y9teUOM46+EzGquw+Ro7BF9FezP2kdAYIOF04dDF6eqHiQYlxgL083sG605+IUOeYPmsvLxPGqzAFuy+G/8WrkH7VHIyOl6ErhArEnqIO/qAfaVUqKa+EBpZy5IvB6aVlRQ80lUiqn3LDP1OED0+5s4shQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-76bed310fa1so4853914b3a.2;
        Tue, 12 Aug 2025 08:52:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755013973; x=1755618773;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dZz85zxG1Fdx2Dk3+7K6+fby+2lWmdMlXym1/uID5+g=;
        b=tYzbO33YSCGHMb7VV+rCVtUBBZChkv3FDyRoUMS5YA/55ihbUoX58t5STVYoyJ3yF6
         mexMdFyagSDyic1dmWb2WjpdvTqXyzFGQX17fFFv192+77l9IZEsCpYVEkWRg6jUscLp
         mR0mh7odkzgO/d2yWn4Dh/3H1ZkqbxBntDQPyJdzLr9ebExN7XQCiXPWYo75wGlZv5+M
         EgJTUeuErmWzvW2QHKoCaH+DBNFkEhwllgfVXHqx6dJN9wvJGKPaazgZy/BbCAiwLs+S
         mlNPSSozZV1yyg2fginMjRCgjKEwtXl1n7G8tNgu5ansPCkNmOEVZidSEPplQGyoPmwS
         h0rQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQMunbWqYwWCeRri/lzeCMU4GN4M4WI7f7110LqSJ2htUfYqJrfnLcvqrPJQYsV4amJCqznGCnqbbDX9yxOD29@vger.kernel.org, AJvYcCWTylQjfjuJf8uILJJJV14nx3W+iqLUqx9W5l3mCUsL2rkyln+rirVVt/8I/T9GM0WrcOt+1PKgfwOCXrs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxrr09dFHGPAER7mmXtnoAoQMvnWvrryO6kcZP/YgnpkJPZStHY
	BzXI0fKoBwlLMOm/DYuM1nTbPF7SKAq4GyIHZsSg1RstezTMZzCpU0Wj/KpK
X-Gm-Gg: ASbGncukl/qF8b+79NzuP9OAHlJY2dtXxOCxw8h+TYKmSZSnpiDAL/hLhZJgbElukDX
	Q7bSjnk1F2uXx0AHQ7BEHPt9A9BqRv5ce6XR2lzAb8CB/Rr3JLkSfwge4gsFk1nlNH1YAA75rn5
	HD/YykkEAcO8vP3pdpHvi/wokuWbZJaSwWYxr4WxvbIFzko5KvRxXdeVDhO3DVNh6+DHlWW/lBl
	WJDxnRZvlE1xVYlOWAN7tauGdG+gF+BjYz4Bb6JzImPwklbVO8laXIFRnWfJqUDOUR2yeaxQ3ad
	XmhOtMYPa+6q1Kx6JrcLaAY0RNgQSzpUDv80hvmwrviNa23+xJmhaWK86MQ351rnCc4trli91xh
	LWeBP5usSlwkx9Ux02V3WDe2NAFkhMOOZRPfAqaoKRJ3i7vbriVy701/Tc08=
X-Google-Smtp-Source: AGHT+IEO5Z5M/KtjpW0VLb1+nruS8V4gTPoqbW8FOI4fKlCjaJC6j7Dcr7qiVY+6B9jvyJru9WYgYw==
X-Received: by 2002:a17:902:da8c:b0:242:a3fa:edb4 with SMTP id d9443c01a7336-2430c133180mr2455155ad.44.1755013972729;
        Tue, 12 Aug 2025 08:52:52 -0700 (PDT)
Received: from localhost (c-73-158-218-242.hsd1.ca.comcast.net. [73.158.218.242])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-241e899a81fsm302235345ad.120.2025.08.12.08.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 08:52:52 -0700 (PDT)
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
Subject: [PATCH net-next 6/7] chtls: Convert to skb_dst_reset
Date: Tue, 12 Aug 2025 08:52:44 -0700
Message-ID: <20250812155245.507012-7-sdf@fomichev.me>
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
existing entry without doing refcnt. Chelsio driver is
doing extra dst management via skb_dst_set(NULL). Replace
these calls with skb_dst_reset.

Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
---
 .../ethernet/chelsio/inline_crypto/chtls/chtls_cm.c    | 10 +++++-----
 .../ethernet/chelsio/inline_crypto/chtls/chtls_cm.h    |  4 ++--
 .../ethernet/chelsio/inline_crypto/chtls/chtls_io.c    |  2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index 6f6525983130..b333da3b21bf 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -171,7 +171,7 @@ static void chtls_purge_receive_queue(struct sock *sk)
 	struct sk_buff *skb;
 
 	while ((skb = __skb_dequeue(&sk->sk_receive_queue)) != NULL) {
-		skb_dst_set(skb, (void *)NULL);
+		skb_dst_reset(skb);
 		kfree_skb(skb);
 	}
 }
@@ -194,7 +194,7 @@ static void chtls_purge_recv_queue(struct sock *sk)
 	struct sk_buff *skb;
 
 	while ((skb = __skb_dequeue(&tlsk->sk_recv_queue)) != NULL) {
-		skb_dst_set(skb, NULL);
+		skb_dst_reset(skb);
 		kfree_skb(skb);
 	}
 }
@@ -1734,7 +1734,7 @@ static int chtls_rx_data(struct chtls_dev *cdev, struct sk_buff *skb)
 		pr_err("can't find conn. for hwtid %u.\n", hwtid);
 		return -EINVAL;
 	}
-	skb_dst_set(skb, NULL);
+	skb_dst_reset(skb);
 	process_cpl_msg(chtls_recv_data, sk, skb);
 	return 0;
 }
@@ -1786,7 +1786,7 @@ static int chtls_rx_pdu(struct chtls_dev *cdev, struct sk_buff *skb)
 		pr_err("can't find conn. for hwtid %u.\n", hwtid);
 		return -EINVAL;
 	}
-	skb_dst_set(skb, NULL);
+	skb_dst_reset(skb);
 	process_cpl_msg(chtls_recv_pdu, sk, skb);
 	return 0;
 }
@@ -1855,7 +1855,7 @@ static int chtls_rx_cmp(struct chtls_dev *cdev, struct sk_buff *skb)
 		pr_err("can't find conn. for hwtid %u.\n", hwtid);
 		return -EINVAL;
 	}
-	skb_dst_set(skb, NULL);
+	skb_dst_reset(skb);
 	process_cpl_msg(chtls_rx_hdr, sk, skb);
 
 	return 0;
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.h b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.h
index f61ca657601c..4ca919925455 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.h
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.h
@@ -171,14 +171,14 @@ static inline void chtls_set_req_addr(struct request_sock *oreq,
 
 static inline void chtls_free_skb(struct sock *sk, struct sk_buff *skb)
 {
-	skb_dst_set(skb, NULL);
+	skb_dst_reset(skb);
 	__skb_unlink(skb, &sk->sk_receive_queue);
 	__kfree_skb(skb);
 }
 
 static inline void chtls_kfree_skb(struct sock *sk, struct sk_buff *skb)
 {
-	skb_dst_set(skb, NULL);
+	skb_dst_reset(skb);
 	__skb_unlink(skb, &sk->sk_receive_queue);
 	kfree_skb(skb);
 }
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
index 465fa8077964..85e4d90efd5b 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
@@ -1434,7 +1434,7 @@ static int chtls_pt_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		continue;
 found_ok_skb:
 		if (!skb->len) {
-			skb_dst_set(skb, NULL);
+			skb_dst_reset(skb);
 			__skb_unlink(skb, &sk->sk_receive_queue);
 			kfree_skb(skb);
 
-- 
2.50.1

