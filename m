Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D605230E83B;
	Tue, 12 Aug 2025 15:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755013976; cv=none; b=vF3QrtqzFDySJIabitlo5aI3xYX5kf2t1MCoIxHa8JrPpbCGMn9gwiYeVrNjbKsS7I+7YSwktgxLIsyIvjmEKHPZ/wVatnvzodPseeutV3vy6v8hpniQnVpz6RTu8lfM274/cONLHQ7M8yIFdMzm7SbVdUe/d8744DCovCu2ljQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755013976; c=relaxed/simple;
	bh=jmLedCN4R2YU+yGCxHz2Yf4utVRQz3r3OsmD+iWWE6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDZ56vJFp32x6GREUUSxBj1STS34esan2eZKbrGsJ0WQUQMhOSpE9ZTh8eKeaVU2nUZNwq1EDWb8BKiD+U+6Hr+FQmFF9ExOvojKSiba9zlHMQ9pZOmsYlJ3Tr3yX+SNAMMJLv4hAhzIx51eJB2t7ODjwmuH1bdXzDCWr+9SEVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-76a3818eb9bso5273621b3a.3;
        Tue, 12 Aug 2025 08:52:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755013974; x=1755618774;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K1U24j3avMI496lsvK/FFAte0M6oHVilfdD7GVgxXmw=;
        b=wi5rmb4uxG0+uYszwPxIdBOlJGp+r2QFTGHAMQDkqAN2/akDzQ4Hc/B5iGIBmDbxUq
         k7ZJOoKKr9xTfLcuC1gorlOILpYynI2q0eaCGLFu0BNCChB6jiI1OtvZcAxkpSrEBgbJ
         rHmAQvMab5nyw1DPGWkZWz/SyZLkDXk3+u8N/ECPtsTqHskKwEXTF8GSf50M6prSLlF5
         8ULZCVA6tpcEJ89MBKpCQXLxCb06mHTcvL17EoQ5oPBzh8Q5VAUzZTa2oPStC79N4m38
         bz4v/P7AthGqY0O6E7A0FiDSn8DRbo5aXmvZgB5IrhAt9VLOEqvRBmCtorCbLZs81YGk
         JBqw==
X-Forwarded-Encrypted: i=1; AJvYcCVVGUheAv5zK8/uhiN1XFiuF3/7q5+SZZZPwMgxIBz+XJ1QRhvOUejyH5sWclrPHU8D9KSKtlqI3XwFi3zALhfe@vger.kernel.org, AJvYcCXqT4rDqwDK7VVwFFu36sTXMOpEJ8zSYuPO/cmlyW/sNEomO2Ncomgu1Bm+ALlxSco8okBIL+Xy6Lfv4hs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9sbmAzlq9t1K3pDL9g+A1ppl6FWeGPWMW1ynrkMyUqQY37D6Z
	Fe8yb+is4FXlCELpCel6oRtXRlph/qArXXePInIst4/SyIo0BK42vkAdpTj3
X-Gm-Gg: ASbGncuH9uQwglzV9pB7GwOyZmMTWe+d2B5phBuP83jhqxmJYDfKKE6Ae0TOeAWnoqM
	qbZzRRFKrMAcXIeN0W5VidlpoL8y3lhx7QrMsaQvB75eEdfyd/upZFvm4fELX5JLtTMnhustAQK
	saEj/4o8zdliZ+GpCEqPBcP93NmxBk4q2wBD9hwlmuaYLV3wvh3SfAbx8P2soeo8jjql/Lr4hj9
	Re+jsMm3dgeapkHuPRzDP4ru9T1lnVZjBet5Ap+Xc6+j4W9pBiApiCzOJO6yGACVKVlSHfdSucv
	2auSqtUYuGIlNfYx3VezUAGOjCm+vQi2qDEr4U0ki8Z6EYZp0e0Cjfo+4r02yVziuAhMrMm1mBa
	zBVYY5G3pObNPUWbev5rQSg7zQyNtPPGzWUwbqHaV2guQJFmFnTfuprPshrU=
X-Google-Smtp-Source: AGHT+IFUKvjZ3Rba9MvqVnh8vH8eFopfwTUPgEOJxRTkNbViqfPFICyo8rbbnicPKgPRyQnCxRtE3g==
X-Received: by 2002:aa7:88c8:0:b0:748:e1e4:71de with SMTP id d2e1a72fcca58-76e1fdb0881mr36267b3a.14.1755013973774;
        Tue, 12 Aug 2025 08:52:53 -0700 (PDT)
Received: from localhost (c-73-158-218-242.hsd1.ca.comcast.net. [73.158.218.242])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-76bccfbd98csm29585074b3a.67.2025.08.12.08.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 08:52:53 -0700 (PDT)
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
Subject: [PATCH net-next 7/7] net: Add skb_dst_check_unset
Date: Tue, 12 Aug 2025 08:52:45 -0700
Message-ID: <20250812155245.507012-8-sdf@fomichev.me>
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

To prevent dst_entry leaks, add warning when the non-NULL dst_entry
is rewritten.

Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
---
 include/linux/skbuff.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 8240e0826204..2f9dac54d627 100644
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
  * skb_dst_reset() - return current dst_entry value and clear it
  * @skb: buffer
@@ -1187,6 +1193,7 @@ static inline unsigned long skb_dst_reset(struct sk_buff *skb)
  */
 static inline void skb_dst_restore(struct sk_buff *skb, unsigned long refdst)
 {
+	skb_dst_check_unset(skb);
 	skb->_skb_refdst = refdst;
 }
 
@@ -1200,6 +1207,7 @@ static inline void skb_dst_restore(struct sk_buff *skb, unsigned long refdst)
  */
 static inline void skb_dst_set(struct sk_buff *skb, struct dst_entry *dst)
 {
+	skb_dst_check_unset(skb);
 	skb->slow_gro |= !!dst;
 	skb->_skb_refdst = (unsigned long)dst;
 }
@@ -1216,6 +1224,7 @@ static inline void skb_dst_set(struct sk_buff *skb, struct dst_entry *dst)
  */
 static inline void skb_dst_set_noref(struct sk_buff *skb, struct dst_entry *dst)
 {
+	skb_dst_check_unset(skb);
 	WARN_ON(!rcu_read_lock_held() && !rcu_read_lock_bh_held());
 	skb->slow_gro |= !!dst;
 	skb->_skb_refdst = (unsigned long)dst | SKB_DST_NOREF;
-- 
2.50.1

