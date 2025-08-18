Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A03D214807;
	Mon, 18 Aug 2025 15:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755531636; cv=none; b=TXWKe1786XUf/ftemJT2LjJpjicrKGeVzKE8Nnh2hImC4VkuDbCW3hgC22dfvjVOaY1mIZ3sJFIjf1BF7qQUN5tMl0OH51jpqm4/xpB+woxc1Tn1fj3TAmBXVZfAq6HxH5j7qHeM7skAdv4YqqeY2Ror0IulPF4Fd/awtOHeHas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755531636; c=relaxed/simple;
	bh=WEv2PQfVPI+9ejQt1JOoeGYCKznQPO8LDnUgsOnT2GY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Bm2aKQzBnZqm8bzMxcBSOOvl8ErRbYxZdrENuF7Zq6OyKWC7MwmKjREq/0UEa7MpiDLP7ZkZ7BslS6K3aYw5xpwMQf5OoGYgyGLURu8U8enT3S3yFvOQBo8TTxRjVyUAiwD60gFHUxHYkd1tezSWKLEeeCbcoGaDjAwxTo2Nl9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b47405591ceso1544293a12.3;
        Mon, 18 Aug 2025 08:40:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755531633; x=1756136433;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=05onlVW0XXyv0dQ8dN62N/saox8u4e4HZdWmUU3MZIw=;
        b=VrlaPBBolsMZMQWIVz/rvTIYkISimMj4BlGqQy5TiXuwAltSYFlST1zS5Rf+0iJca5
         QpmdqRD6uC2EPOElahFrTUnVdn2IW6xXvnbD1wWjw7jI27PDM91y1IilecrBk/NUnR34
         nvCvXP+0awBR/Dl1QVFA8pBb4+U6w06MRMGqA2U0iFxD2j5cebBiql9pWXfSR4QTNzG6
         GfrOX9OcNlxkT7bnSxL85J6V8su0Qq2nYqhVJeboJnrfHLFjnX9CXMwoB/83vYNij3km
         Cogg4dPLod60/spNT4+BOq7tzM5P9pzEhDRhcQKm7k2ina9C6tPShqpdPejRhkBWidyq
         xRwQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6jM1mIE40AUOD+C8zf4/Che0YphJy5EVr1ETdWAmUpNVCg3o5ul1D2I55bdpSMfD0qL9bfXn/RqsdkjQ=@vger.kernel.org, AJvYcCUayjS9UW23xFY3bOTfkTNS5dUZdvzITly2xP/4FAzvnRDo0fcv+/zFSwy8kIa+HAwGr50ukxdffLKj/N0BoBYG@vger.kernel.org
X-Gm-Message-State: AOJu0Ywlq8APgmHcHTj1EDzYU8PGzICniaqSJFsS4ABpieNhswgp1Uy7
	p2lXN1GVqkPQlFamVu3OZG4Z/yQnFhXGcI8F6P4woUI7/lwilPyJ69SHrHuS
X-Gm-Gg: ASbGncuwCwoqHPo2sqLY6vkEt9hYw9eG8+sfNld6PeS/HV3fwhtc+S7gLP1RBhTua7C
	gmj+kuhH1OhtlX+vd3laWTtlCgTkNeudzMqT6kBONalN1ZsCJqKK8obf4sK9N/Kuk+cPHfTrRbb
	H1+GcUd0x+V8oX/SNl6KXXBY6edJf4nzmdKQvwGyl0cq57fN7/UYnyMmZDNlwhYSJj0yhjW+D7P
	XwjPZkY8IXobV1QaiVvhzOQXOQGu1lotX5imxi6cpqiXR2vvUt9d8krOw0sp3/PD++KGJzAR9Gj
	VjOs0vMjzewwq+0MKVWLrFuU7XR1seMU00CwxJCRrivmPNpmZtGHLhSK4OkzAbi+0KAn8c3OQ4Z
	MmePk6EkJqqpgJccRta1Z4rHJhCpV3o5ypAhz72es7VbXNiW8oIahQxmKSlU=
X-Google-Smtp-Source: AGHT+IE2Pj5Ew6lBgyqgzz48L0gmUrnTfjQU1Y3HzmaVdoKRrzgV7rZc5UlY0kXH/5xhGcGN5tjsIw==
X-Received: by 2002:a17:903:f85:b0:244:99b4:b38e with SMTP id d9443c01a7336-24499b4b460mr18629385ad.24.1755531633443;
        Mon, 18 Aug 2025 08:40:33 -0700 (PDT)
Received: from localhost (c-73-158-218-242.hsd1.ca.comcast.net. [73.158.218.242])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-2446ca9e057sm84009905ad.3.2025.08.18.08.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 08:40:33 -0700 (PDT)
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
Subject: [PATCH net-next v2 0/7] net: Convert to skb_dstref_steal and skb_dstref_restore
Date: Mon, 18 Aug 2025 08:40:25 -0700
Message-ID: <20250818154032.3173645-1-sdf@fomichev.me>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To diagnose and prevent issues similar to [0], emit warning
(CONFIG_DEBUG_NET) from skb_dst_set and skb_dst_set_noref when
overwriting non-null reference-counted entry. Two new helpers
are added to handle special cases where the entry needs to be
reset and restored: skb_dstref_steal/skb_dstref_restore. The bulk of
the patches in the series converts manual _skb_refst manipulations
to these new helpers.

0: https://lore.kernel.org/netdev/20250723224625.1340224-1-sdf@fomichev.me/T/#u

v2:
- rename to skb_dstref_steal/skb_dstref_restore (Jakub)
- fix kdoc (Jakub)

Stanislav Fomichev (7):
  net: Add skb_dstref_steal and skb_dstref_restore
  xfrm: Switch to skb_dstref_steal to clear dst_entry
  netfilter: Switch to skb_dstref_steal to clear dst_entry
  net: Switch to skb_dstref_steal/skb_dstref_restore for ip_route_input
    callers
  staging: octeon: Convert to skb_dst_drop
  chtls: Convert to skb_dst_reset
  net: Add skb_dst_check_unset

 .../chelsio/inline_crypto/chtls/chtls_cm.c    | 10 ++---
 .../chelsio/inline_crypto/chtls/chtls_cm.h    |  4 +-
 .../chelsio/inline_crypto/chtls/chtls_io.c    |  2 +-
 drivers/staging/octeon/ethernet-tx.c          |  3 +-
 include/linux/skbuff.h                        | 41 +++++++++++++++++++
 net/ipv4/icmp.c                               |  7 ++--
 net/ipv4/ip_options.c                         |  5 +--
 net/ipv4/netfilter.c                          |  5 ++-
 net/ipv6/netfilter.c                          |  5 ++-
 net/xfrm/xfrm_policy.c                        | 10 ++++-
 10 files changed, 72 insertions(+), 20 deletions(-)

-- 
2.50.1

