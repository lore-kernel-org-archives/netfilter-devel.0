Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809092F7466;
	Tue, 12 Aug 2025 15:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755013974; cv=none; b=SBVrZBX11AhBZkJ1JUlOhvCL/1uWkCEAOk+WQntumph4uN8sE6CxUAwWaxbVIGcQ3WqD5knVy49d3WYaTWkhdAuqUG0ag9dRUfRj/YvYmH38vHyOm1MABP6TqZ4/TloYVlXCkwwGGMxWdN9ecQPRPEkZrsgEH6fQwUe/g8OaG/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755013974; c=relaxed/simple;
	bh=H8Qm7sDR6sFfmMhYO70q6TApPQXnFgsGJ5LF44w2Ni0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJGOeoARqSiHP8CxK00DHo+3ZUxvSiXQSFXExjWGHfn2bc3MPS1CvWPXrVojU0Q1c990bJ8gyBGaTVp9t+RoK+m7ff7ij7qNxQSt8yIG8eTXSRDSRNs8GPObMRXttnndt6zBwe2Kr+7047eqZocGIAvvuQC+aQz4aJTMuMnZKRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-76858e9e48aso4979739b3a.2;
        Tue, 12 Aug 2025 08:52:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755013972; x=1755618772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hw6APkuisRn1IO+Yq90b/XIN4JEuOM+T0XNRQV/DOFA=;
        b=r+CrILgIT4vpCrlMy/9JfpzS07jLENdKpo9xxG+yoMc+uOWnpKnVf3Cu5XQy0vzdJc
         QYO0oIPED3RnjX9Q8B/8BEC6BfQXHhMfSLe9tv3MQWP3+ntv7P2TX1HCV1CijLME5tHs
         IEASTvxjua8bnGVvYxFxPoMBF2hFGHo/xtu0Dd8ZIH+Ne5Ghjf/+5gl51Sr0NxwEdFmV
         XqW8r5u9QJ29BmBYVuZEMceVUkrBrOPy+ZLvI1kMyV1n0foucCl13AWWiB9jYG/hkkFP
         TNcyoovvsDiUPU5w2DPRUBdSKqcEVT+L4vHsDVLYBUQbx7Em762s/8AeOu+BLtvusjoI
         FgNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVssFLqx4VFrEr28GuMEd1pGIDDNGDkwYHpGkFxlT32d55/hO/DdNtrzXI+esSJDpp639w4fJVZ4Eqm9Ag=@vger.kernel.org, AJvYcCW5w4JQaNzLPPa0WV+PzaIDbWKNIhg2cMFzLyGvmZ1y6O5ArqGM3JaW9vQV0VyCJrBFomITCVKhgbRbq29YYBsm@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+dLAhqnfdjZpbXjQH6D8+btod5j6D+R630u++MS9rlm1BAOVx
	9z2AD3V9yc6QHa8VsLtUdexSs479c4mGpTmo/qrqwFgKME3X9+LveTeIG2oA
X-Gm-Gg: ASbGncvWaR9Z1XGuBDCjEeg/kXis4a2cCjDz+Xfs1X+2+iNNx0mAQEgD1F/xA6vdT93
	l3hX1nFmWKehKAkOe8CWJDwBfX6rE2wq90LpU/L0TFUXQ2DCUV39lV6IVK95cXe50BWwni8JNlP
	nBWrBb2fZ8AMR43M1/qa8o9cFO4/gomM4kE40wtAtjL4qgX8aaKbQVwXgzuyFSLevtNLpPZbe1M
	IOYHOnPlMLFXhU3cC6OKVEzwE8tOmqRW8AaHWg7sZp8YJBqiIU1Krq/K5hpaNraxliWQE7L1cva
	3P842rtM9GwCjZFQyfHe8ISpBuZis0W38MPvckqd1Xv2A9Oi1TCnNQ5xG6EDIC2Jp7Gc8dKljQ0
	jDO4JEP6XdBQNH68zgGhRgTw7FUAzNxGA7UAQTqCt1CEYMAJNcru73TGJtew=
X-Google-Smtp-Source: AGHT+IE9mqitrJgp0ti2dNmcFeTLvil3ZhGhwEi8BPipsrW15PJbfSzyXxpXrXvlwLEBV343ULlwnA==
X-Received: by 2002:a05:6a20:72a6:b0:240:1f14:f6a0 with SMTP id adf61e73a8af0-2409a97167cmr6622771637.25.1755013971622;
        Tue, 12 Aug 2025 08:52:51 -0700 (PDT)
Received: from localhost (c-73-158-218-242.hsd1.ca.comcast.net. [73.158.218.242])
        by smtp.gmail.com with UTF8SMTPSA id 41be03b00d2f7-b428ca11a67sm12235295a12.53.2025.08.12.08.52.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 08:52:51 -0700 (PDT)
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
Subject: [PATCH net-next 5/7] staging: octeon: Convert to skb_dst_drop
Date: Tue, 12 Aug 2025 08:52:43 -0700
Message-ID: <20250812155245.507012-6-sdf@fomichev.me>
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

Instead of doing dst_release and skb_dst_set, do skb_dst_drop which
should do the right thing.

Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
---
 drivers/staging/octeon/ethernet-tx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
index 261f8dbdc382..0ba240e634a1 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -346,8 +346,7 @@ netdev_tx_t cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev)
 	 * The skbuff will be reused without ever being freed. We must
 	 * cleanup a bunch of core things.
 	 */
-	dst_release(skb_dst(skb));
-	skb_dst_set(skb, NULL);
+	skb_dst_drop(skb);
 	skb_ext_reset(skb);
 	nf_reset_ct(skb);
 	skb_reset_redirect(skb);
-- 
2.50.1

