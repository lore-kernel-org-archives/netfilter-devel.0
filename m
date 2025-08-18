Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A91F25B301;
	Mon, 18 Aug 2025 15:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755531637; cv=none; b=WVn3+WL9PD5URjHVsQajcObjSHNMvkGU1u8nNSR7XJE7c7ZxOhbRCuSgEyqqObttj7bEqSkYK7IHJaTvkyig5pib6YxB/kA74sC3rNWCWbpwOo6wXKQfp9Ex00YjwvqzxtTpCEVWmxrYQv8SBqXoGLe2W+TtOGX4JE8coMmzdy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755531637; c=relaxed/simple;
	bh=ZxyGscOHeqQ4OoQLuMcftJmNOcrzdMA3DnVbJ/3/Ji4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGGWFRc3Xb70D5AxR1a1zH/u3Lw4yhXo5Ydajf5wDMEMX+4zCsH9bdGUg+Gvw0qafURoSkRQYgK+MOMWbcIL/2qAX/G5FcB3Q0+sxUNJLyn6v8eYI5AyFFWa86Wb0yu2r0Cw0Bimu9xTdAtqCmNzErb0DYiYs1cl0ha14OaPB3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-76e2ea6ccb7so3142597b3a.2;
        Mon, 18 Aug 2025 08:40:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755531634; x=1756136434;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4jXoBQiGcML+O5CHFOk8NakzzuxAVed76FZQO5V7Zuo=;
        b=gJA6VXChO5cqHqitzYn7it9AyYllPa+knrNV91vrjE0A4FrostpS9OwzSyOh3e05PC
         0bOLnPKCa5ExAefDD4ShLXL3fQ9XW3VmciHuHyOoaVK6CJqAJMYx+d0Rcm13PMNLe3cP
         4IhIHIZWd5OmbJvgHp7Zlwktl+51QRll1+hFvwNlQj/pE0Y9fksqp9FNEVLF4Z8qHfcO
         zmLCbfFq11QSw0JF121HwfLvfR1cxBbA/+7Tde5pcIw23izp0dMTUvHLrDWKzoTlk12/
         3HggaZMTRIzg8nveq3ImXAcECFYcnf8mWNG3kYUcMoXOZcpFyAcovlFdYYbg/JmY3rrk
         5IEg==
X-Forwarded-Encrypted: i=1; AJvYcCWFFqrg/apJuTWGsDXBwyMzZez0ZF0WVUrOPQu1YoWHW/fceXKbuPJIG/HIIJH9nxRJt5hoydWIo4DBZYM=@vger.kernel.org, AJvYcCWhMhpww5cYVcL6HLPhIWll1dh7gl88ao2eRh0zIGwPhqvijyZRbic7LYEPfvksoaUrGvvdjq1xMO6cT56LIHrP@vger.kernel.org
X-Gm-Message-State: AOJu0YzvJOkEIyXHFUyDZntLiOxbv3KbWKNwmvAq0VIXvlz2Q8dxL2zG
	h8oLdBRjAHfHJB3Eqk938P935czAQsLzWB4vz1348Jp9xV51o17ZtZH1GQAB
X-Gm-Gg: ASbGncv3JAN3n4O6bITfkyQaqS6ep6GafihiLklMMaASKim6qIX8uQ7WQbpBrcvBAf6
	Qc//0onGBb4ByqvYlGp2/gGXTTNvZmhZnysVzpFyjszvgn+8o00hp2vv0L5Ez+Ji7+NxS8MRui4
	UrOZcKLZmoc4My+DmBWF7cL6nfZz70x9ghrYdwnfc4QwBVHBwAGSRKfo3Kp2nQG30W71nwoaCpw
	hY+B+tC054uUS8VXOI+pOKWmYkv0NPL6MDLyHAcwQXQ9ZimqVS4xks2u9u+O0FmdscYpu7JEIr7
	8Ebx+tPeQY+fk5XBzfZBLK7uab28bJo2v5z5dJSfZAmMIQrFlfkr0H94qocp5vU7/zcO/kOZYmO
	PDpmCOQUR4EBHopLRiLyayrLmhlKTDkWnCf6sIDqojNTM4gy8HCoqFVysywVLRdCT6spN0Q==
X-Google-Smtp-Source: AGHT+IF/N1PLy55109GC/Y7zY4a/TPzsoK+ogpED49iOqmUzUNQ5ofGeFk3sGZ2eemY8kdMbbgxW8A==
X-Received: by 2002:a05:6a00:17aa:b0:76b:e16f:ca91 with SMTP id d2e1a72fcca58-76e446adf03mr14527105b3a.1.1755531634478;
        Mon, 18 Aug 2025 08:40:34 -0700 (PDT)
Received: from localhost (c-73-158-218-242.hsd1.ca.comcast.net. [73.158.218.242])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-76e455ba020sm7502378b3a.109.2025.08.18.08.40.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 08:40:34 -0700 (PDT)
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
Subject: [PATCH net-next v2 1/7] net: Add skb_dstref_steal and skb_dstref_restore
Date: Mon, 18 Aug 2025 08:40:26 -0700
Message-ID: <20250818154032.3173645-2-sdf@fomichev.me>
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
is empty during skb_dst_set to prevent potential leaks. There
are few places that still manually manage dst_entry not using
the helpers. Convert them to the following new helpers:
- skb_dstref_steal that resets dst_entry and returns previous dst_entry
  value
- skb_dstref_restore that restores dst_entry previously reset via
  skb_dstref_steal

Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
---
 include/linux/skbuff.h | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 14b923ddb6df..7538ca507ee9 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1159,6 +1159,38 @@ static inline struct dst_entry *skb_dst(const struct sk_buff *skb)
 	return (struct dst_entry *)(skb->_skb_refdst & SKB_DST_PTRMASK);
 }
 
+/**
+ * skb_dstref_steal() - return current dst_entry value and clear it
+ * @skb: buffer
+ *
+ * Resets skb dst_entry without adjusting its reference count. Useful in
+ * cases where dst_entry needs to be temporarily reset and restored.
+ * Note that the returned value cannot be used directly because it
+ * might contain SKB_DST_NOREF bit.
+ *
+ * When in doubt, prefer skb_dst_drop() over skb_dstref_steal() to correctly
+ * handle dst_entry reference counting.
+ *
+ * Returns: original skb dst_entry.
+ */
+static inline unsigned long skb_dstref_steal(struct sk_buff *skb)
+{
+	unsigned long refdst = skb->_skb_refdst;
+
+	skb->_skb_refdst = 0;
+	return refdst;
+}
+
+/**
+ * skb_dstref_restore() - restore skb dst_entry removed via skb_dstref_steal()
+ * @skb: buffer
+ * @refdst: dst entry from a call to skb_dstref_steal()
+ */
+static inline void skb_dstref_restore(struct sk_buff *skb, unsigned long refdst)
+{
+	skb->_skb_refdst = refdst;
+}
+
 /**
  * skb_dst_set - sets skb dst
  * @skb: buffer
-- 
2.50.1

