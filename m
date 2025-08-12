Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E2C2F8BC8;
	Tue, 12 Aug 2025 15:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755013969; cv=none; b=llfrNiVq28u0tXDr3p0sm5Yg1PSL6HEl82Xx2fjTJOarmpjLcLr0xCvb6uvJa9YgXBSyhzMswGybo9lUpksTlwEynr/aIEGBwTKY6bwV6sYAQJRSeEu0UsB0SwcCPOxIBSENHYOjTieDV7JLAa6okZtGDxoeGgdMXQHEyTLY8kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755013969; c=relaxed/simple;
	bh=vr6rzmd2aRCICZEtZpVHst+woIY2PdLz8GDn9zbiJmk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IFXR5/leUGUaJPH+7MPBtQxNJX9qUz7ppDndkIpWxz7zYjETwVhfhfDs4pjr/V8847j1Qan2W3ba6KHI+yAbcPcE3yCWb+zhSfoHJmV5LSFXxuCreLzrpcPoujJEcvsYjmLVUJHQ4NTPFbrRRWKzQcZbAmBuVp9kOGNy8y1J4Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2406fe901c4so35499905ad.1;
        Tue, 12 Aug 2025 08:52:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755013967; x=1755618767;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UIYsgiGJtw7YJeoAHTICW+FIrcnnXVaB1cAoAuVZ/CM=;
        b=j6qy4wcVFzN/kqGdl+s2QRmFKvkcXTCK0xYyOi0itgM5PJ3FYaDW6fJ8HGeZ/P6dgu
         cucBp6e17isM7JgxDchL0L5wdFK0RonJbDPanWbheyeWDjIXPINuaE/SVHtHmxdRhNfq
         mm5a2Heb2+46MraD/u9jzdjg9+HiYuU+ppsC+9AqTutCPJnKqpbSeFFSUzhnBH/bz/0+
         RdWnYinJwVhLIhtEPYhU/K6Mh0Yw+eSw0+VrBQbpUbpPtf6zQmRfFyb4nklliqdXQilC
         He9l6P0DlvFNmVsvN1jJlrR8cydptF1pZcabOmflEMa9q3x8xXfpuLk11AU1rg+vS41J
         5dPg==
X-Forwarded-Encrypted: i=1; AJvYcCUzZaAeLtDMgZ/VIOHlD65J7/JriyWJKu0OkfRsNAw2Fd2Q//R9ibKpRWmCzF3TEqbZx/PrSR7c4LYkbbxGIu9D@vger.kernel.org, AJvYcCW/tf+ZxVuSc+n0d+stMjYvCEkzxaLXoh2+j3DcZV9Fm94dO4vI0wLJWd8VlmQWf5i6br3QpQ+AZCh9MZA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFO7GOb5li9Rx2G5R8vYEM/5RDDpudA0X/JM71S2tme1HrEieB
	KIwn4o3doDEmjBAxU4cezUFQySQdhHyAQ4TuoYRgXziHAeFuacuZCWZjpGV9
X-Gm-Gg: ASbGncuIkknVlvybAJ70kqgEto330G+BylwZNmz3QmuZrYM4MhZ0JJnRqfeXt8VQO3G
	OVktwnjaOwsa9rEHGhKB+J5leVcfEQ9MvhHRk7CN7SE9pbxTC6+msjKPm62HZx5VSFWtSpPzt+D
	fWBfdyUmrg7fGhSP2Wnw705z165oP/uNlZf9jh7e4UBmlH5LLO/7wIa23AXIhj9YtoWNno1cV44
	wOdr0h13RSHixzkLgLBImxpAk8dLmhQjDdY6QjhWc8s7pkfPzuUsTdJxWFh4CT8z2ApYWEREdqB
	j1ka85z6IMcsktqIOVAUhGaE5MztRhKtksWvdBHGaiRQnMnxQHkDYEN5n0G2hcVscFedKit6b0F
	EF0L/Blq/VADtztSPpjEGWXriINZruZ8QHd4KkzvQzxt3ZHooE4k3/WSDh2hcuspmC2cqcw==
X-Google-Smtp-Source: AGHT+IGI1Feslups0/3dIst5xuXnrjwfAXnfJotUgLxW8sNuLdQxHyRUl2S+Gs8wn5Hrn4dfEJ/LMQ==
X-Received: by 2002:a17:902:e808:b0:23f:f6ca:6a3 with SMTP id d9443c01a7336-2430c10a418mr2367235ad.43.1755013966573;
        Tue, 12 Aug 2025 08:52:46 -0700 (PDT)
Received: from localhost (c-73-158-218-242.hsd1.ca.comcast.net. [73.158.218.242])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-241d1ef7562sm302042475ad.24.2025.08.12.08.52.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 08:52:46 -0700 (PDT)
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
Subject: [PATCH net-next 0/7] net: Convert to skb_dst_reset and skb_dst_restore
Date: Tue, 12 Aug 2025 08:52:38 -0700
Message-ID: <20250812155245.507012-1-sdf@fomichev.me>
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
reset and restored: skb_dst_reset/skb_dst_restore. The bulk of
the patches in the series converts manual _skb_refst manipulations
to these new helpers.

0: https://lore.kernel.org/netdev/20250723224625.1340224-1-sdf@fomichev.me/T/#u

Stanislav Fomichev (7):
  net: Add skb_dst_reset and skb_dst_restore
  xfrm: Switch to skb_dst_reset to clear dst_entry
  netfilter: Switch to skb_dst_reset to clear dst_entry
  net: Switch to skb_dst_reset/skb_dst_restore for ip_route_input
    callers
  staging: octeon: Convert to skb_dst_drop
  chtls: Convert to skb_dst_reset
  net: Add skb_dst_check_unset

 .../chelsio/inline_crypto/chtls/chtls_cm.c    | 10 ++---
 .../chelsio/inline_crypto/chtls/chtls_cm.h    |  4 +-
 .../chelsio/inline_crypto/chtls/chtls_io.c    |  2 +-
 drivers/staging/octeon/ethernet-tx.c          |  3 +-
 include/linux/skbuff.h                        | 40 +++++++++++++++++++
 net/ipv4/icmp.c                               |  7 ++--
 net/ipv4/ip_options.c                         |  5 +--
 net/ipv4/netfilter.c                          |  5 ++-
 net/ipv6/netfilter.c                          |  5 ++-
 net/xfrm/xfrm_policy.c                        | 10 ++++-
 10 files changed, 71 insertions(+), 20 deletions(-)

-- 
2.50.1

