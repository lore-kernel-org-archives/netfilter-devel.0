Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69A83CFF44
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jul 2026 10:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782900625; cv=none; b=UlDee762R6R7wQ+rcSSLvT8YqH/xOWOkcnTA6K6ZREE7+duao4YywOXPStnwfLEDnJuIXOkeEB6Cl9y4FJi/JmdIy/XiNNV7HfOIGy7lJ4XLHDorN37YFrW9vBgje1rt3Wlzko1PbtAZgbTS9w+t2pRgwO8msuPcS41XwN1f81Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782900625; c=relaxed/simple;
	bh=jmfvhgrtNdU3m6gyAhjUPNDiaPo9cS3sSJZSuYijSs0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Oo3xW7gItGZGI/LFzds5AbnVBfxrPZrrVwIqSxdY5bOfMZpFcEXu3fKWfKjSFHM0vbqvoJ5NzwdcmbXP0OU3nn8LKwU90TpYGGRKuvo8tWl/bTVLreRQhxzGlBC0sKfRqysv7sukCb7pYxUgaBMNUNEwQ/yHno8B/fGh+BrRLW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VLnGmvdY; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VLnGmvdY"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3804fd3cf71so222246a91.0
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Jul 2026 03:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782900622; x=1783505422; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EGOpzjLwG2qHNqnpr9AH3FOmYtQjFdDLV2ovZbwXKfA=;
        b=VLnGmvdY198P6jHJUGoQJ6UdHfJYYYnLBt1fjR6fM7rHc+t0flxxszs0kJ8I4/q8lP
         P6nRGq/HcbdHD0l04gDtyU7sLifMcnUWY585ONlowNmyshqjRa0Sb+yEHhPeCQKTkEnY
         hDIBC1N0zihbE3zNHJrh0m2Vc91Z4Pg8llO1IPJrXu85ryRRuLQsBkJhmWn0+IeN0Rcx
         Cp9kU4OTQBPWT2JgxoHFdHb/9qMSSl/gokBJVR4KzKXh+jbumZl2O8wIf7AX8560mg71
         1cxvpqj/YExQtFGYvK+oAvz2c7N7LM5323aF5+/dFioylcX9O5dZzsmdXZyzCVaeZCIA
         iLmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782900622; x=1783505422;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EGOpzjLwG2qHNqnpr9AH3FOmYtQjFdDLV2ovZbwXKfA=;
        b=PD5HcqVC0x92CbBDr/iI1BU6/NuFJt47Nvpe8shZFQa21VLOYwW/e7cbVeNC3cjnu+
         jQdF52VekAJ0TqrGiXXPzlVO7fi4OdZ3Wh2YSiHBANj5wrwRSyaa0xpjQL3SbdBeKlu8
         PMwzJjM6LIiVFTlvSfjacz/QKO28tpuKJk03SDSJl6sj9YDuHHDvFEciAZU58pH8ADgA
         mn5w5MHITD/gJBW8yepJGVfknQ/cYVgTEaPZMaeTHB/DySwLZnckkPXuQRbSjh5j1Aq1
         EcbW8vAygelH+pcidEdAe6xR+3TdeZy2OA8hO21y/N+SnnPnPn8rOukJBHk81SuftgRS
         b4Ew==
X-Forwarded-Encrypted: i=1; AHgh+RrQQuz2pO7EdrWm4ncd1DZHu5U34f0tphWQtFwC0ZnuI///IY8AaYpnV0TJWIeuvBdG8rY4RoSle1bm4R8aVok=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0vEl6p4Cj/onwnpLsY2RwzsAg6C88JZqXmubkgXuRd3ZdI3YP
	LdGyt+510B+T/TpRPU5AdapU4cqGqPqK7AxwdOv9RT5gnCO/hMQydYUp
X-Gm-Gg: AfdE7cm+dvxHcdiuJisSCcVbs4PKvkBD0uzkzA8KnxI808WRobKJdeE9GSy37eBSp5O
	KaaF8/wlY2gUoWntnyvTkupVfjLgcNJyU1TbDNNThsybaWydm5HHa7vtcLrjJGHJc7tGdWn6HYu
	/jx7HmKHvM83p77eO7xPNsBM37zI2mRgSgXmhEBOshSNBlvzorDwy3t5fafnJ83pi4a/M734ck0
	+DsWc11cJky5LvVWr3QCemKRheiAk8z9IM2rFb3gF8njeVXVS93YFiESJ97Q45LXKRS5zP5gn5n
	8gyhXqeZVD9zM3usDqrrYhl23wVj5DHV6rYBiKD5oS5O1duOfJFpmEMedytGlKt1rd7mEk3UFAu
	sUVeYGkAdbt0Vv0+ksGVr0M2NtXBJfHkiL8G3/GHX3+5DAtrHCJprDvJDT6OzJmPvXnc56wx1SC
	dSBsJoVAa/VAtaisYuDEbT
X-Received: by 2002:a17:90a:d44b:b0:37c:7090:821b with SMTP id 98e67ed59e1d1-380aa0f436amr880037a91.10.1782900622075;
        Wed, 01 Jul 2026 03:10:22 -0700 (PDT)
Received: from c79ofce.localdomain ([204.3.140.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38095d6666esm1559442a91.6.2026.07.01.03.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 03:10:21 -0700 (PDT)
From: Zhixing Chen <running910@gmail.com>
To: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Zhixing Chen <running910@gmail.com>
Subject: [PATCH nf v2] netfilter: ip6tables: mark malformed IPv6 extension headers for hotdrop
Date: Wed,  1 Jul 2026 18:09:30 +0800
Message-Id: <20260701100930.2855-1-running910@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ah, hbh and rt matches check that the fixed extension header is
present, then use the header length field to derive the advertised
extension header length for matching.

For the ah match, add the missing advertised-length check. For hbh
and rt, update the existing advertised-length checks. In all three
cases, set hotdrop to true before returning false when the advertised
extension header length exceeds the available skb data.

Returning false treats the packet as a rule mismatch. Set hotdrop to
true and drop malformed packets so they cannot bypass rules intended
to drop packets with these IPv6 extension headers.

Signed-off-by: Zhixing Chen <running910@gmail.com>
---

Changes in v2:
- Set hotdrop to true before returning false for malformed packets.
- Apply the same handling to hbh and rt matches.

v1: https://lore.kernel.org/netfilter-devel/20260618125848.93550-1-running910@gmail.com/T/

---
 net/ipv6/netfilter/ip6t_ah.c  | 5 +++++
 net/ipv6/netfilter/ip6t_hbh.c | 1 +
 net/ipv6/netfilter/ip6t_rt.c  | 1 +
 3 files changed, 7 insertions(+)

diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
index 70da2f2ce064..1258783ed876 100644
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -56,6 +56,11 @@ static bool ah_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	}
 
 	hdrlen = ipv6_authlen(ah);
+	if (skb->len - ptr < hdrlen) {
+		/* Packet smaller than its length field */
+		par->hotdrop = true;
+		return false;
+	}
 
 	pr_debug("IPv6 AH LEN %u %u ", hdrlen, ah->hdrlen);
 	pr_debug("RES %04X ", ah->reserved);
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index 450dd53846a2..6d1a5d2026a6 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -75,6 +75,7 @@ hbh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	hdrlen = ipv6_optlen(oh);
 	if (skb->len - ptr < hdrlen) {
 		/* Packet smaller than it's length field */
+		par->hotdrop = true;
 		return false;
 	}
 
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 5561bd9cea81..e28caca759f3 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -57,6 +57,7 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	hdrlen = ipv6_optlen(rh);
 	if (skb->len - ptr < hdrlen) {
 		/* Pcket smaller than its length field */
+		par->hotdrop = true;
 		return false;
 	}
 
-- 
2.34.1

