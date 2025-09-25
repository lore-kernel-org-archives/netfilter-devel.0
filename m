Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6F3314A7B
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 18:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758824851; cv=none; b=uBFHK2qnoLmveFz8L1Hn4mxV84avLbBR8bYXT7v0t3XcdsP+QX9ON3kN0wzycVgE5lYAIHOQPf/kSJvADefOyPAsa/BlJIrc0cho51iuy12dpvQp+gYf5qOJ6C7VwIeUBWq8whBg0sl6TaJLmKt4HdSXceYir/IwtgYBjD7ERHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758824851; c=relaxed/simple;
	bh=DUTkLmi0EzVTJ+AWe0OBq6K1RWiww/CFFXpG8VhXD98=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AcJymv84ViuqlEF7k7aFsSodmbPOzwG+D6jm6m2i+4fHNnQjmmQXFHF31roWzxZNAO0kVQY/9nkZk8wCjKrvQ7fbwyKKIr146Pe7rC8UE+xbyVOLlTD3v73CEr2nQ0mbc5/Xj+GOxJtEJEaQV0gGFHZXogFlbToQjXB43DBmE74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FxgN/ttP; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FxgN/ttP"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b30ead58e0cso224920566b.0
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 11:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758824848; x=1759429648; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JUT3SSvYenMhly8OZvczbE2TebLsubXvIlDVrfxllSg=;
        b=FxgN/ttPspWAZrp8ToX5a0XEFE6SsAsIsul994FKHjuLgXbghDJ8NHVC9LTAIAIMdU
         JRJk63KBujPDz1w0aT6COB6PuZP67pdMKVoy95QeD8vw+0sngRJXtvUks9MDPDhx8MZ0
         D79/pJoHnlTVADVpTW4hOnbc0OFcBN0Id9wt0ucli3kd7LTjD4SD8rZiUmEzOM+YFJXk
         lUc6HUfgtRyd5jZratOH3z2u+8jWFtoHsA7rYWi6APzUV5zL50AOk4jAKO1bPPc1M+7x
         RvAHdG7rzX12+zmCjEfFIjb042oEHjDhYlv4Ie8MWstM99PHdcTRrl/6DXK5n3R72Kki
         h/Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758824848; x=1759429648;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JUT3SSvYenMhly8OZvczbE2TebLsubXvIlDVrfxllSg=;
        b=B7gtCiQAHCpd08sUqpn4/QpTuOfXd6uw5J/bvzvEh4RlYIc6dl0LC9uwa0dKiZyNqS
         0mwUetmlOboBT6mlttlVsxk2qAAIPCxIIajqqpAHvBSGEpdwEdhEuGHiycIoLmPYobU8
         ymMyXTSatB1AIL2GbuW9MLAUxhs/n1/7zpQZ3aFbWEgRKjJ0RNTgBTUEOPi6TA/BU2Gk
         EbPgo+/wPswn0T38FQ3XURoRyfA/lF5YPvizY5kBqWGHt/UbJf0j/C27eE9v/xRW5mLU
         v/SJRwcvf9iqZo8FqUTapHy8QwE1p6IyMR6WhE0nFZUWDHBCdhCflGbRaFqlcbA/hvC2
         xZoA==
X-Gm-Message-State: AOJu0Yw9RRJIdpmr4n3T0Q1K0HYUATjjJeG4BXdEZGi1N5mANBf73+Jx
	uYkiDj/dc8hJ3wy4rnjl1USczOFqgMkQaVehyKXYuOA2dgcDrnR/i6O4
X-Gm-Gg: ASbGncuyTsYWeC1ppnsbD+myvVjbgqC+k7La6JcD+s+MyGOPLqgSHO4tRUYB2KEjL2Y
	VCzBymdjsQb64NYA/KVoSxVwmLAA5gJj7Q0DsTDnRxiJScymPQ06wCX6NxkIoLPzDDBTjTVDzL8
	Y1Z2DRlFj7yor5sZflv3hp6YrtKKINDT2XWD8GiTxJNOl9QV7ZKgwAhkRL1nM7hS6CTjQTXdQJ2
	v8qPcbprbZGIqrZ24dUrmTu0PQyXfuGTicUG0Gey6a7bVjsiUh+28+YTqZ5cDA8KvnGSGmTkeoJ
	D/vB9fFiu56dUjMopJVIpz2jJnba3Gg3WD8JKYxGCSf2ezBhQcwU8Qt8Mkt7Nj0hBvobEA0qiJt
	NNqyPLpcD98p/0JN326hkM+D4ZbLHa/tA0u6uCyNe7QLIR7BDCxydrYLTtLL9Czf1a6+nrGf26o
	VyGyllrC2W+SgYh03SGw==
X-Google-Smtp-Source: AGHT+IHGcH8Urk+2NZXPjBGTGYafzBqvtygm/aKjINig6LQec5XVExiMK3tDXWVjaGovy9FXplx0/A==
X-Received: by 2002:a17:907:25c1:b0:b2d:b5d3:962f with SMTP id a640c23a62f3a-b34bb418b41mr435432766b.44.1758824847493;
        Thu, 25 Sep 2025 11:27:27 -0700 (PDT)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-634a3650969sm1572902a12.19.2025.09.25.11.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 11:27:26 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v4 nf-next 0/2] flow offload teardown when layer 2 roaming
Date: Thu, 25 Sep 2025 20:26:21 +0200
Message-ID: <20250925182623.114045-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch-set can be reviewed separately from my submissions concerning
the bridge-fastpath.

In case of a bridge in the forward-fastpath or bridge-fastpath the fdb is
used to create the tuple. In case of roaming at layer 2 level, for example
802.11r, the destination device is changed in the fdb. The destination
device of a direct transmitting tuple is no longer valid and traffic is
send to the wrong destination. Also the hardware offloaded fastpath is not
valid anymore.

This flowentry needs to be torn down asap.

Changes in v4:
- Removed patch "don't follow fastpath when marked teardown".
- Use a work queue to process the event.

Changes in v3:
- static nf_flow_table_switchdev_nb.

Changes in v2:
- Unchanged, only tags RFC net-next to PATCH nf-next.

Eric Woudstra (2):
  netfilter: flow: Add bridge_vid member
  netfilter: nf_flow_table_core: teardown direct xmit when destination
    changed

 include/net/netfilter/nf_flow_table.h |  2 +
 net/netfilter/nf_flow_table_core.c    | 89 +++++++++++++++++++++++++++
 net/netfilter/nft_flow_offload.c      |  3 +
 3 files changed, 94 insertions(+)

-- 
2.50.0

