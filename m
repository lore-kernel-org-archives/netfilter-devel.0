Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980903290D9
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 07:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776152765; cv=none; b=jnZVVWZB4Tvia9mNYqQPZrvEbl71lrbcLXP4Fkr1Q4yjtJmqoQ+KwnhqTouxRgQG6BB2Okzj9II1ZlpHN9j4m8oPOyScbb5Fy4x3ysWTfhITLbJlp++qbs+m7CHX7OJ4UPnBc1fIizrkbZmhiapEnxXxgYlkOfwMYyeCaviFnx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776152765; c=relaxed/simple;
	bh=DfB0mirF1DEkQjuoNptFwzK6i/M1Tn12oXTw9xXN1to=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bTtYNttMMGjH/XA1i+JwM9zkls0YZvbSbJcMTWeFXcv+99qaV9MnJauNbh2RcvXu4yi3mdEp+I9fopQXOxC1EM0cFRnl53IG82MH3TM48RC8l/foH3hU2i3BH7/tDQHaRYXdrn9Q0L/tOvc7Kc99LT9Ztm/GwWiJA4jCShKqRpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cztyEdwS; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cztyEdwS"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2b2494440f3so17849225ad.2
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 00:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776152764; x=1776757564; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dBkAfCIQelOdIl4mYrxfodBgX+TU3tBvysXFS7GqOZs=;
        b=cztyEdwSWAMqhLeokF4PROuM52kLFXgeJfdy/Uyjp8HZETZ/v6yEhOXywatbVHod3N
         OGednMgtSNqxl5lmQNpadxh4THgQQoTcD1sw8jQxbk3dyAt0xRXpId9/1otcsRPzMhVB
         NBhn1hle5XZtN9bbIVtRGd0g9TYdvOqAhzN7mBTRYaIpxiBeva7YgUnW4ZQO7WF+tdQO
         3ztyGuTAa0TobtJLZ6/O07UNLDXGo3TCoqdAf1Fpeza8jb/JSUX/MN21NjPf7ELOQylX
         DSj2DH6oW4uqbqcwqeCS2eERRItUzWE1brPzsP/zF8tKvm2njXRN8lRQKzmuoeOe6Ryi
         EhaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776152764; x=1776757564;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dBkAfCIQelOdIl4mYrxfodBgX+TU3tBvysXFS7GqOZs=;
        b=ptAxYrQywAkw7e+LpMjqrQHqd8xzHBfHxn0akc11ZYkS3kzGB/Znl6xytYeniBovEA
         Zbv1EOA2IHZRXqIgEC8MTI+dKPbqLfgFxlZKjeoMPgVhyu651H9fZ07YHkrH8CDw5Viy
         w/6kHKRGbU/nMBmKoYD11wvBdUcOK4ghAfJnYARq8HU7cYraDPq+pvPismC4KrrfHfVl
         7X1KhPPqJNNNGW2LujEfNn2OPDNAVKbUYQBaHkjSAXBeGAPO5ObEeLSPjtPeGPbLMBiO
         BYQvWjpgplyDDypnvY8qDZEWm4sxggEAGUv0uo80a94WCnpXHC67gJptV43Avvl8eIyQ
         q90w==
X-Forwarded-Encrypted: i=1; AFNElJ/RMsdJpgwnvn3ltgjN16ZVwNhVHqCc3xItP2O1CV4AJb5iwFJahnuQNmXw3ItHCk4TSLEsFmIjuqdnSzWA2a0=@vger.kernel.org
X-Gm-Message-State: AOJu0YynqnOWlhD92PD/kGxWNynOBOz0FNiRCdbpB6ixrXzN6UBClCYU
	/DaismMs11sLdUiDJZ8X2UaRWZ+/3gjGXDM8MH9ixI7lMH6TLKlhw0Iw
X-Gm-Gg: AeBDieuYFA6IMo5J9YD9QFJw4jcDSV6pTfuCNtLZV2ABiUcS/KlvNLGlGOjJCGdjtpT
	huzl6Ibc6wpxHKXIt0MOh37353sA7onKwsAdfLsRVX5Hxo6eygWt27Yd9eGQfD34osx2GoJd+ma
	IG9IFN4bLiSKvH22Q2/Ow7iyKHJvjggHuKdR9s6GUZ4CD4eLrYk00mphrmSmHJ9czQoym8xhsew
	WAscdSp+DEroQ+cKltaOoVjIRBzmb2MVha5Y9lS2MQDh5zXpPpQc9uiRV/+Bd9qbQArd2htREC+
	gvd4DCG67npOLSfwp33OgM6vSuyGeAO/R2A2vwY/Kw2a9buNc0EXJzlVVayUsp6Qqc3gZLSdy9D
	Lu0dMrVXLM1htbMCZJO+qCwU27SDn4hTxF7f1dlc58+dP7YNJAttzyMdTZjBtO9peQEl5A3h3sP
	UFNuBxNBuvz/Hb6Np8OeuEccYjV9lW9Lbs
X-Received: by 2002:a17:903:3d07:b0:2b0:ac1e:9737 with SMTP id d9443c01a7336-2b2d597d19fmr168198035ad.12.1776152763875;
        Tue, 14 Apr 2026 00:46:03 -0700 (PDT)
Received: from localhost.localdomain ([180.167.178.215])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2eae817fcsm97892455ad.44.2026.04.14.00.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 00:46:03 -0700 (PDT)
From: "Kito Xu (veritas501)" <hxzene@gmail.com>
To: pablo@netfilter.org
Cc: "Kito Xu (veritas501)" <hxzene@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Fernando Fernandez Mancera <ffmancera@riseup.net>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] netfilter: nfnetlink_osf: fix null-ptr-deref in nf_osf_ttl
Date: Tue, 14 Apr 2026 15:45:56 +0800
Message-ID: <20260414074556.2512750-1-hxzene@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nf_osf_ttl() calls __in_dev_get_rcu(skb->dev) and passes the result
to in_dev_for_each_ifa_rcu() without checking for NULL. When the
receiving device has no IPv4 configuration (ip_ptr is NULL),
__in_dev_get_rcu() returns NULL and in_dev_for_each_ifa_rcu()
dereferences it unconditionally, causing a kernel crash.

This can happen when a packet arrives on a device that has had its
IPv4 configuration removed (e.g., MTU set below IPV4_MIN_MTU causing
inetdev_destroy) or on a device that was never assigned an IPv4
address, while an xt_osf or nft_osf rule with TTL_LESS mode is
active and the packet TTL exceeds the fingerprint TTL.

Add a NULL check for in_dev before the iteration. When in_dev is
NULL, return 0 (no match) since source-address locality cannot be
determined without IPv4 addresses on the device.

KASAN: null-ptr-deref in range
 [0x0000000000000010-0x0000000000000017]
RIP: 0010:nf_osf_match_one+0x204/0xa70
Call Trace:
 <IRQ>
 nf_osf_match+0x2f8/0x780
 xt_osf_match_packet+0x11c/0x1f0
 ipt_do_table+0x7fe/0x12b0
 nf_hook_slow+0xac/0x1e0
 ip_rcv+0x123/0x370
 __netif_receive_skb_one_core+0x166/0x1b0
 process_backlog+0x197/0x590
 __napi_poll+0xa1/0x540
 net_rx_action+0x401/0xd80
 handle_softirqs+0x19f/0x610
 </IRQ>

Fixes: a218dc82f0b5 ("netfilter: nft_osf: Add ttl option support")
Signed-off-by: Kito Xu (veritas501) <hxzene@gmail.com>
---
 net/netfilter/nfnetlink_osf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index d64ce21c7b55..85dbd47dbbd4 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -43,6 +43,9 @@ static inline int nf_osf_ttl(const struct sk_buff *skb,
 	else if (ip->ttl <= f_ttl)
 		return 1;
 
+	if (!in_dev)
+		return 0;
+
 	in_dev_for_each_ifa_rcu(ifa, in_dev) {
 		if (inet_ifa_match(ip->saddr, ifa)) {
 			ret = (ip->ttl == f_ttl);
-- 
2.43.0

