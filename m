Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BCBB2F8BC4;
	Tue, 12 Aug 2025 15:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755013970; cv=none; b=nKyED6qyX8k6hpz4XTXsyJqU89ao4+vEDsj5ExalxcoTDXhVSJjgTB09Pa6N2RfX3ffFf1q1C1SoC78+YLGJP8/aZ5P5fc6GsQmaFOdjddOFj518KEb4r14aL8bVZFJ3TVJG7/UWNVA02k7WtJ6HUPHElNPxphFzPtbWPXrmLWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755013970; c=relaxed/simple;
	bh=vvOHe9u+/zNDaZKxeW2eoRXHJCvHl2v5R/bFdM2LQis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifyF6LZySsez7NO35/TTWV/yHxjo333NXEfQ05gVXIQ+6bS+5p3HnDSvCLIKr8ZhCBp4Zxi2UQfjY3QJuFPwjkd1oI4isvwj169Qo4hRhHcbiaOU2dpWN4PPBGDiihjsZxLvucl3qNy7Q2qfMvQUr5WpNLiIe6bHSqsvfGebJd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-24306318aeeso5098455ad.1;
        Tue, 12 Aug 2025 08:52:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755013968; x=1755618768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5xhittB1Z3BFmPBedtymhQdJl4mLRLMPRy6NV0jWS1k=;
        b=VXU6sli/wmPCSRLf36NwMDbfAGGjy82gw+e/OpYski5x3Tj7/5FPPEj86hTKFP6KaJ
         qOyOZXgwY6cxiv/5n0TdtKEJsf7Bec5BVFACOFXDe1PT2bClFy0b5vXmWBiUTphV41j4
         Nx/ph3BZhSnemDay7rz7pjF6O71QylZ2AoGWejpI0soCyq//kQgmge2i9PZ6SpVdUfzs
         ZVGtXvheeXr+OpK0j8orOWiHM51ZdHe3NX/EEJuUhU36940xExbNMtKq1Y1BgihhJuR+
         MKR89pM20cVcTKZZzRQ56owuilwV1TDHqCW5wG5VFM8S2C/Ib3yB+nQ2k3VO9yroNPZA
         RQJw==
X-Forwarded-Encrypted: i=1; AJvYcCWKVeeAUmaO4r9GFN4fNLjNZpsj2dDgzVf1iUn3hbZyiGVwX7Zs4wWml9edGpY0QwIbXMKtT4l3vAxAaCw=@vger.kernel.org, AJvYcCXVIvwAFiCTUiJOQFA7bMYooASWQeJ4fNKIl//FsED+cG0f03RIzTljA74PgiRNepCekGJoBuVW1GOxFq3wHUUk@vger.kernel.org
X-Gm-Message-State: AOJu0YwsW/exyKQs3xs1KzW41ZW3cjSG+Ntbc7aY+ANPW13tV5ris6VU
	C+8PDZ77ZosTt5nb/clqZQrJQ9OqqFlZQ3pLkZ2S5zRU/HOqAXCweajV6JWh
X-Gm-Gg: ASbGncu8RL44rEN7876vKN3wlpe0vEQ7at/y69avMPLCPvkzP7exq5YCPqHo5fl797f
	jwxF6n7OcYTwkrMHrMWZK/AE0HRW0qucwRgPbhKFm3vvwyE+6CBj5q7QV4AlVi80xhlRPd3ARVT
	oSBwVGvBX0Y7XEwTyLHy4GX0GWFxy4RgMunDOUekaVpPXkiQkfV/aAqdvmKEWLA5+oJ0y41mM6U
	zBJ5mjx6YQWAfwYuy9x5zwtg8sezO951+nZ0GpH0UUeCVLm0cdBNacx7S6TMShRHeJ+Yzn6zDaA
	UQkqRELv/kELSsf3PRVi3ti/lNSoW2ip0w46t1cUG/xL6jb0leJ/mbSkw/8UDoQ600gAl7vbN9r
	8BauRoT24mJuz6poh2mT2obpNo7TD+rzwweoBZIdSK6jwK3j8KUnirgUEgY8=
X-Google-Smtp-Source: AGHT+IFoG9C56EZHwN/MxrzFFA3UJZXB7gFcizSUrt7Y/XjCXBdEhjPeu8ZIdfLSs1+cGeiDc4xfCg==
X-Received: by 2002:a17:903:1aac:b0:243:3da:17bb with SMTP id d9443c01a7336-2430c10d63fmr3177625ad.32.1755013967516;
        Tue, 12 Aug 2025 08:52:47 -0700 (PDT)
Received: from localhost (c-73-158-218-242.hsd1.ca.comcast.net. [73.158.218.242])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-241e899b4adsm304377985ad.132.2025.08.12.08.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 08:52:47 -0700 (PDT)
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
Subject: [PATCH net-next 1/7] net: Add skb_dst_reset and skb_dst_restore
Date: Tue, 12 Aug 2025 08:52:39 -0700
Message-ID: <20250812155245.507012-2-sdf@fomichev.me>
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
is empty during skb_dst_set to prevent potential leaks. There
are few places that still manually manage dst_entry not using
the helpers. Convert them to the following new helpers:
- skb_dst_reset that resets dst_entry and returns previous dst_entry
  value
- skb_dst_restore that restores dst_entry previously reset via skb_dst_restore

Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
---
 include/linux/skbuff.h | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 14b923ddb6df..8240e0826204 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1159,6 +1159,37 @@ static inline struct dst_entry *skb_dst(const struct sk_buff *skb)
 	return (struct dst_entry *)(skb->_skb_refdst & SKB_DST_PTRMASK);
 }
 
+/**
+ * skb_dst_reset() - return current dst_entry value and clear it
+ * @skb: buffer
+ *
+ * Resets skb dst_entry without adjusting its reference count. Useful in
+ * cases where dst_entry needs to be temporarily reset and restored.
+ * Note that the returned value cannot be used directly because it
+ * might contain SKB_DST_NOREF bit.
+ *
+ * When in doubt, prefer skb_dst_drop() over skb_dst_reset() to correctly
+ * handle dst_entry reference counting.
+ *
+ * Returns: original skb dst_entry.
+ */
+static inline unsigned long skb_dst_reset(struct sk_buff *skb)
+{
+	unsigned long refdst = skb->_skb_refdst;
+
+	skb->_skb_refdst = 0;
+	return refdst;
+}
+
+/**
+ * skb_dst_restore() - restore skb dst_entry saved via skb_dst_reset
+ * @skb: buffer
+ */
+static inline void skb_dst_restore(struct sk_buff *skb, unsigned long refdst)
+{
+	skb->_skb_refdst = refdst;
+}
+
 /**
  * skb_dst_set - sets skb dst
  * @skb: buffer
-- 
2.50.1

