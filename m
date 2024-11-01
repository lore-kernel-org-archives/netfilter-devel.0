Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4513149620;
	Fri,  1 Nov 2024 14:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730471535; cv=none; b=li8mxPbGJOcEurG0/YNyQ6EnpYkPOYxLJv5rJ6BbypstSjrexhBlRSLj/PpixPTKxTjn+nmNRorCkuB4ATV+Up1tE2rQKKey8PF0K+kgSSdC8hZHDsZ06zq8EEmsPexFkEpwVb2j3Na0qFsoTod+shL3ay0hP58eIohElpkXmtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730471535; c=relaxed/simple;
	bh=Ye+OnA3pcBCvTB594Gt6ixWt++CfWAxTqEQjPllTXqA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tFZJTBlGKrUB0PL5ImavFo0c5GWYMINftq9lvIf2SMCRcFKM9fxaPQwhzd7+Y6DnXNP0fD1EyW915WqmCfz/isYBAe7AgOnfNO5ad/UrT5rRpSJi0a7cyn3DKVzvQoT6wmbaNu6g3WTdCgx4JSRNCBNVZ6d9hy83CxzAYSHyNVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AtNJsz9o; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AtNJsz9o"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4314c4cb752so17951725e9.2;
        Fri, 01 Nov 2024 07:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730471531; x=1731076331; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BzMHOq/iCf0mTo6/esKAisiJt3XWXmE/BAGapCEWblg=;
        b=AtNJsz9oaJgofjW7xrsYYbwZpkstg2c7c4VRyT2LyIQzGQYVSzSLIB4+0CQjmyyV22
         p6oDMAoA5iIh5/C1qpTT3bpZMPwGXS5874n2JyNjc0xAWrFZYq5vReEJQu0gJo0n3ANg
         6f/H10dTVUxlqzC4jld/zDuNBqzfgS3P3G7nJAdp9GPBszJvF2RH/jBgEMyj8wbcQ0om
         d7jz/bc04Rp3IWmdxlslokr1qKkE0Hq+/LFLr3o9ig//ssYmPPDvlBHOxYtg0Xh2BU/5
         /YDtWvLznG7PhPFNzjKCNpsf9y+yVEFXj44q8h4x1kvt1tMuDPWPZAx/5+sBknn3p2pa
         m5gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730471531; x=1731076331;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BzMHOq/iCf0mTo6/esKAisiJt3XWXmE/BAGapCEWblg=;
        b=qU5lJKFK6nX5roFEyX77RkVKqk+i7pifqYL3ruzTFAdDHBM0/25FyiJ1+XBnFRBSOc
         kxVlKh0Z4WqeurKbr6ujdxjfwz6b/6s+/zoUo/mbIiP9+iqs7K2ngTxtHTYn/aXZRgNd
         EUssxOwxbev4uKVw88cIusVIliQ19bHDFzanXoAi70VQAPaIZOy4aPlueaDBIqu8wwge
         RFPhuEStRhaxBp9WtIRAbsIo4w9430uKyie9BtqPL+xUAl4/kn4X5DZtG7PRHK61grcd
         FN/riP7KIxMeT+49Y77VMbQ6E9PegfAqJOo8JRuPPzMxWPgIeOgCPwjyuijTlaumJlJJ
         zDbQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/MHY6bnMeGPi9AKHLmZyUj/QP/lMTnPaduh3FOuCLY31K+5hpmlfZWRSLyVPpPoLZdfBpMQk=@vger.kernel.org, AJvYcCW+hgN78Nh6+keAFHLAgFl1u6A+f0Nn9B2GvWVb+eNaa/68K2SNg89UZQX/ZtgwMpYKpv/NkO0JEIBcg9jSOrwI@vger.kernel.org
X-Gm-Message-State: AOJu0YwWB1D2MvGfa8+IUCnWsqlF24cC2t/4OKWdI6WmJfPrDRzfaNXG
	RZebbxvNF5hbjT7DKgGWG2yyW9VZQvlcS2n3qtoDmsoaq74l1nr6
X-Google-Smtp-Source: AGHT+IHvtpZn7d8vB942r4zuG2RQkp0979/qnUzdbg1tJcN0Dzoy0ix9aImEY0F4ebHBwiv1isfxug==
X-Received: by 2002:a05:600c:5115:b0:431:7c78:b885 with SMTP id 5b1f17b1804b1-4327b6f954emr61643485e9.4.1730471531352;
        Fri, 01 Nov 2024 07:32:11 -0700 (PDT)
Received: from imac.lan ([2a02:8010:60a0:0:5575:fafa:8c58:48a3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431bd9a99c8sm93675215e9.29.2024.11.01.07.32.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2024 07:32:10 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
Cc: donald.hunter@redhat.com,
	Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH nf v1] netfilter: netlink: Report extack policy errors for batched ops
Date: Fri,  1 Nov 2024 14:32:07 +0000
Message-ID: <20241101143207.42408-1-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The nftables batch processing does not currently populate extack with
policy errors. Fix this by passing extack when parsing batch messages.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 net/netfilter/nfnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 7784ec094097..e598a2a252b0 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -517,7 +517,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 			err = nla_parse_deprecated(cda,
 						   ss->cb[cb_id].attr_count,
 						   attr, attrlen,
-						   ss->cb[cb_id].policy, NULL);
+						   ss->cb[cb_id].policy, &extack);
 			if (err < 0)
 				goto ack;
 
-- 
2.47.0

