Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6D831E115;
	Mon, 18 Aug 2025 15:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755531642; cv=none; b=YvoTep2f7kNvvOOuUhxqzdV+RNEvFEiWl3BYfK89aA3cQAVLdRIr58+UbI6iXuTBAUvn31vuTuGUmBWbeOP0hrvMD/xCjZodvbGCcuUM/xkYugLAhPC+pnhxeMNF7bPf2uJVnVMhM07un4CA3XlLkxifTH+qpwMvPJHzIsHjl4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755531642; c=relaxed/simple;
	bh=SsY5sl/7Ca92dz3Qp7HpP8+SYaQy40ISIcYTwzL6rZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cKwwnFzlmYUz4C2el5Q8ZmHaN81XrfpRGI6WMfWmjjTGyOneqYHNmC2nZRQL+Mx1c3XPTQDk0+bS0qhx1uQQ0p9rOJBVTHWMlCAooXg8iBHSVP1IVnkHe8TVEGhzoXcUhU9QZpPhPG87UoF4Nr93atEEEfJZWV6igBoRBi9swSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-244581d9866so35330895ad.2;
        Mon, 18 Aug 2025 08:40:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755531639; x=1756136439;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G7ZlQs5RoXi9haultf5dqnNcftoZY1H3XDCLA/FcF+Q=;
        b=f+16gxVIQv8LuuSZznzr5I3ksv32gTmhMnnHCk6RWM6tkGvkz9TlWD22MSwIA4igVV
         WznN/c1HsWSVH1C92G22QcTNFSG3tZdcmanlFuIvM+biBw7hvsXar4wn3cznuv0EZSam
         bL8CZrWnkhqq2Kid5Dhs5TWovb3GHoo9WZCF06ywxGy0fb2mUMK3taJTBS7+Vhi3g+NL
         pL/sAxl2OjI2dfTRwxFhW1Wdvy3wve7iy8vCQ4u05bTk0lkzqjr8u3iB8Fy4qwalG4LC
         LGvOU5zkdJH+9aipCGO7ZiGWW+FqX1vb71JphCzWiV+fV+Dsy4e/06qW5k/7e412E5ve
         kh3w==
X-Forwarded-Encrypted: i=1; AJvYcCVk+raSIwFVvn2fUOHJo6JIG/8dWo8aQRXz278TKsdRkULG1fsegVDY16KtROifWG6mj3uK2lEQeDbYvXI=@vger.kernel.org, AJvYcCWQHSho4AZuRcJ+idobjI2KetjbpGNTB2htSDLNFT+LAkbteXXzQzS3uB8VlbSsYB/FxpQETxgdARnLQjYi4eF3@vger.kernel.org
X-Gm-Message-State: AOJu0YzXwSAA0nGDnM/CJTUa6LpMl9lC+RauJPC+P/uXOEfHTTdYRwNo
	tqUo2nhFafwRj9pxlGqEKdmlM/R4ZR7vtjJzTz0aoHqZDDGr7+8ScfwkyoNi
X-Gm-Gg: ASbGncuLic1gBCX/HDQ/mVNobyArLAM2MwDnvRscCg+Cm8w3kuZMdfrG22lAMeh5Ra7
	BwV0uO+bL4h7oLdJYep1Ll5q2MfrhDzT20/KhulVLgj6/QmnDn+gv4BaT3eNdstivaFbzVXCZUb
	ijYwin7X1tRh2zgs4+jqnz++XsmmLIOsoGXK0GZML420l/H4c0ZfuGTY4Bp+eLjUTCPyhE13BPf
	XHO25Oe7aqPbs5NZKuIjY+6tKJ6HdkW7C834rWStYM7EAz4ANKu5oWxjz0eLphVYfJMVN4oOZzu
	s9sNYqXORJndgqwrtL6VGLOO2TRg2+hGoDat6ste62qAv51f2uk6JzRKl0oQH86CUqbUMYdCuAs
	EpyK/a6wp0ny38ZTbuoo/UtyOIBn3EwOuSk3R0GvDBBSxRHhelZTiW5dy6Fk=
X-Google-Smtp-Source: AGHT+IHFrVJ2I69jC+NHZzoCi8+QOllriQ0LPquSAPR77h5OF5Qv0KgzG/8bmcIayeieUXiXjPi9Fg==
X-Received: by 2002:a17:903:41c8:b0:240:92f9:7b85 with SMTP id d9443c01a7336-2446cb8d3c6mr193477365ad.0.1755531639142;
        Mon, 18 Aug 2025 08:40:39 -0700 (PDT)
Received: from localhost (c-73-158-218-242.hsd1.ca.comcast.net. [73.158.218.242])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-2446d54f8b9sm84736575ad.130.2025.08.18.08.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 08:40:38 -0700 (PDT)
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
Subject: [PATCH net-next v2 6/7] chtls: Convert to skb_dst_reset
Date: Mon, 18 Aug 2025 08:40:31 -0700
Message-ID: <20250818154032.3173645-7-sdf@fomichev.me>
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

Going forward skb_dst_set will assert that skb dst_entry
is empty during skb_dst_set. skb_dstref_steal is added to reset
existing entry without doing refcnt. Chelsio driver is
doing extra dst management via skb_dst_set(NULL). Replace
these calls with skb_dstref_steal.

Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
---
 .../ethernet/chelsio/inline_crypto/chtls/chtls_cm.c    | 10 +++++-----
 .../ethernet/chelsio/inline_crypto/chtls/chtls_cm.h    |  4 ++--
 .../ethernet/chelsio/inline_crypto/chtls/chtls_io.c    |  2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index 6f6525983130..2e7c2691a193 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -171,7 +171,7 @@ static void chtls_purge_receive_queue(struct sock *sk)
 	struct sk_buff *skb;
 
 	while ((skb = __skb_dequeue(&sk->sk_receive_queue)) != NULL) {
-		skb_dst_set(skb, (void *)NULL);
+		skb_dstref_steal(skb);
 		kfree_skb(skb);
 	}
 }
@@ -194,7 +194,7 @@ static void chtls_purge_recv_queue(struct sock *sk)
 	struct sk_buff *skb;
 
 	while ((skb = __skb_dequeue(&tlsk->sk_recv_queue)) != NULL) {
-		skb_dst_set(skb, NULL);
+		skb_dstref_steal(skb);
 		kfree_skb(skb);
 	}
 }
@@ -1734,7 +1734,7 @@ static int chtls_rx_data(struct chtls_dev *cdev, struct sk_buff *skb)
 		pr_err("can't find conn. for hwtid %u.\n", hwtid);
 		return -EINVAL;
 	}
-	skb_dst_set(skb, NULL);
+	skb_dstref_steal(skb);
 	process_cpl_msg(chtls_recv_data, sk, skb);
 	return 0;
 }
@@ -1786,7 +1786,7 @@ static int chtls_rx_pdu(struct chtls_dev *cdev, struct sk_buff *skb)
 		pr_err("can't find conn. for hwtid %u.\n", hwtid);
 		return -EINVAL;
 	}
-	skb_dst_set(skb, NULL);
+	skb_dstref_steal(skb);
 	process_cpl_msg(chtls_recv_pdu, sk, skb);
 	return 0;
 }
@@ -1855,7 +1855,7 @@ static int chtls_rx_cmp(struct chtls_dev *cdev, struct sk_buff *skb)
 		pr_err("can't find conn. for hwtid %u.\n", hwtid);
 		return -EINVAL;
 	}
-	skb_dst_set(skb, NULL);
+	skb_dstref_steal(skb);
 	process_cpl_msg(chtls_rx_hdr, sk, skb);
 
 	return 0;
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.h b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.h
index f61ca657601c..2285cf2df251 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.h
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.h
@@ -171,14 +171,14 @@ static inline void chtls_set_req_addr(struct request_sock *oreq,
 
 static inline void chtls_free_skb(struct sock *sk, struct sk_buff *skb)
 {
-	skb_dst_set(skb, NULL);
+	skb_dstref_steal(skb);
 	__skb_unlink(skb, &sk->sk_receive_queue);
 	__kfree_skb(skb);
 }
 
 static inline void chtls_kfree_skb(struct sock *sk, struct sk_buff *skb)
 {
-	skb_dst_set(skb, NULL);
+	skb_dstref_steal(skb);
 	__skb_unlink(skb, &sk->sk_receive_queue);
 	kfree_skb(skb);
 }
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
index 465fa8077964..4036db466e18 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
@@ -1434,7 +1434,7 @@ static int chtls_pt_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		continue;
 found_ok_skb:
 		if (!skb->len) {
-			skb_dst_set(skb, NULL);
+			skb_dstref_steal(skb);
 			__skb_unlink(skb, &sk->sk_receive_queue);
 			kfree_skb(skb);
 
-- 
2.50.1

