Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6BD2F8BD8;
	Tue, 12 Aug 2025 15:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755013970; cv=none; b=c3YYqtgM4l1WrnNJkDsKF1fXAbJkfcarMNBDWNZre4QsFvfnM1/NwecBo6EKDg+rm1pb+oNZcycNa9YkvL2ebhA4PgJdQ2ivdwF19y22PGaUx9ntpup+/Aff8jLDWJphBMj6mcD7KIsCTDlsSk8nseJprW4LIFt6rT2ZRyG4KRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755013970; c=relaxed/simple;
	bh=Y6yt61AOmS8VLZtjJ1BuuUWNqePIcTOn+4ook9c6mRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQ+8hspQe6Kr6XSUWsBH20H8Rle1YXSDHgj5G/g1MyfZLQ4WUqlrNFEdnNtR5CrsOj0wU6SDMMm9mRjMqsg2QJs+1hx/Rbd+XyYkOVYHuaARLE4U7QJ99m6EATBSOdIgB1mIqUo4Da9xarFyXefnJUZXZoQBG5sOyjbyyBXu+bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-76bed310fa1so4853850b3a.2;
        Tue, 12 Aug 2025 08:52:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755013969; x=1755618769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qmQTgKFXI0yRI1h+Wuwej2H5g2T+K6OFKy/n9+ooPsI=;
        b=rkhiSYqB3SRqv63VXadYYzCCKq5om3JlN2SgnrKTmr47HNpFkS51eQOaWJ4XE53M1N
         o0/9mgCpwsFiCjwPoVhXfbZ3FZDexfBiCpSJ62wYGZPmvjUt1TYme18U5F8ES2929UEC
         C04t7uvUPyH0cWvzS0QU8JMXiFITdhuXEWsiy/usvYqn+hUAltGoquYwG9KidQVcUu4o
         5Ts0rYmsUD7nQxNj9LAsLbBKy+NjCSgvAeJm1znoKkRZm/koCCqgohzt8j6kX/w3GMj9
         UMyOHqvqxyDnkpUsz1Y/RK1wBbOfr8cHUkm2jmU+jF4GhOsQL9iciRvo9U8XQ3skvmy/
         D+FQ==
X-Forwarded-Encrypted: i=1; AJvYcCUoDFgyT76x68VYZXa3oJEnYVpmI+HpzuB3yoivc1Lk0kX8yOMR4RPVsFTRk6bjpUz/IGPejSoShEOrw1gZojfK@vger.kernel.org, AJvYcCVkdkClJC8Xd9d2ZUQatB2Uq01jOfZTQoYkydR+M/mmOiI3oWU9ioRUfVPtT2+ZQPaE9GXzCmPKVkNX6H8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOsEW4U7/m4FeY5f7+t7gKCX37GKSBQN+RTEfpTUlfLgQ90yLG
	ljGc5JFBQTexY1Hl/pZ0eYEFuTSB8KgJh10HTonFgauYUYwxWkH5mW9JJ6qv
X-Gm-Gg: ASbGnct1QIDYRsnI+NHBEHXwfuzx/Bo/eJTmexX3Aa063TAh7MBkBK/6a0MTY97Aoty
	fB0bevkX43OhESpRZKmp+PiMqxu20HDSZssxlF8YMiv6sp0svWsd4DZS2Zz3lTeButiPyE61Mf8
	tf8sdvX1bMzRwhzoulz7O0yp6fxIyfF8WSKWlSCCogNKP3yMgqntNN6C5kMWSqFnKXnoVwQAc0N
	PwQVMACEWVWALROwqPZXIrzfhXMVSePqR3OGggyJxJmL/gq9jR7TdPs6UzeZNVzRTwk2tu6VK9d
	sKGxGOF/P/CN23kwz7V6VPovN5wg8K5B4fnt/OZ04UzpEy9ej14EzRZKMvexcb65w5NFkgLeBnj
	LmB56poo4bulqUTFtqnzAzh9Q9n/woE3Jndsx+UAKArROAy0tgK9qBmGTX/4=
X-Google-Smtp-Source: AGHT+IGJSjbc3JsMK2uU2uNHTgltCW9hcJeoyzvVY/wYRm8KIQ5ucZ82mLJT2TdzcjIEdgViuEX/LA==
X-Received: by 2002:a17:902:c94f:b0:23f:f983:5ca1 with SMTP id d9443c01a7336-2430c01c8f1mr2953545ad.12.1755013968571;
        Tue, 12 Aug 2025 08:52:48 -0700 (PDT)
Received: from localhost (c-73-158-218-242.hsd1.ca.comcast.net. [73.158.218.242])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-241e899d347sm300038675ad.140.2025.08.12.08.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 08:52:48 -0700 (PDT)
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
Subject: [PATCH net-next 2/7] xfrm: Switch to skb_dst_reset to clear dst_entry
Date: Tue, 12 Aug 2025 08:52:40 -0700
Message-ID: <20250812155245.507012-3-sdf@fomichev.me>
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
in __xfrm_route_forward and add a comment on why it's safe
to skip skb_dst_restore.

Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
---
 net/xfrm/xfrm_policy.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index c5035a9bc3bb..a5ffe26b64d5 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3881,12 +3881,18 @@ int __xfrm_route_forward(struct sk_buff *skb, unsigned short family)
 	}
 
 	skb_dst_force(skb);
-	if (!skb_dst(skb)) {
+	dst = skb_dst(skb);
+	if (!dst) {
 		XFRM_INC_STATS(net, LINUX_MIB_XFRMFWDHDRERROR);
 		return 0;
 	}
 
-	dst = xfrm_lookup(net, skb_dst(skb), &fl, NULL, XFRM_LOOKUP_QUEUE);
+	/* ignore return value from skb_dst_reset, xfrm_lookup takes
+	 * care of dropping the refcnt if needed.
+	 */
+	skb_dst_reset(skb);
+
+	dst = xfrm_lookup(net, dst, &fl, NULL, XFRM_LOOKUP_QUEUE);
 	if (IS_ERR(dst)) {
 		res = 0;
 		dst = NULL;
-- 
2.50.1

