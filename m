Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3288C28C5A9;
	Tue, 17 Jun 2025 07:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750143626; cv=none; b=s+hK5t0Vn9xkJ5Lw8vwQe9vUdtIuNNDpy9sEw50GHKHecRi2KpaMyLRi6iqSlRnZoXJp6K9fJYgw4b+JiH5eBMYE6XDNZjbuEyys0UXjbsZh+CHCBMqlcplhvpZEjdBREk9s6o5NREcTrwxUTABBoM3cCI+RP3HR2GTgLzbZMgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750143626; c=relaxed/simple;
	bh=EZJG11e4pWpqrTF5AUNg7CFYWOk3WqLPNIo7rSIH9ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ja3KrKfH52MNQsUjrWO0p2Nw1GxRC45SvghzYa1lJCrYOS8QrAQEv8wwqyOIrheogfzWfscaDqFiuPe/8V6b1Zod8PT5KA0CHYw0a5lCnUpeHRfX8IK80w8Ht7M00gjEXhDsmNTN8DJeqeNTubS9V9qfMioMlfDTF6BViNxcPSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TDprnsY6; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TDprnsY6"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-acae7e7587dso811931366b.2;
        Tue, 17 Jun 2025 00:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750143623; x=1750748423; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SMox0MpwPKygAR/vnpy2GVz1YAIGJ060oJ50J1k9QBo=;
        b=TDprnsY6W7GflWn0XE6L7pK4wMnG6EfvSvb9cG17EozA36u7COdt2YYzQHTodT1Lr+
         gnltsEzOHr0eDYuUISJ2H95DyAwDWA4Xpyil+9aNNyGDUWM76Vyvpgquj7cZ2avbpTi6
         oxUeoeA17hPfV1nnOmJ7HTgX1aaaRKKksKpCQ7Kd2DWfLG52brng+ovwZ4JFdjIV1beH
         AyDVYO2NBkof1hF1lKkG5uIj1uUrnZMHS37DLrt6jyoJEvm1Lm2jGKrrRhiStmLwiI2s
         3ZeV5DCc3yWO1oR1/8FJhs3kv9WcB4bneClvvlepUkDeTGLZn+V69yXZi7JoQzj4IixM
         cbxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750143623; x=1750748423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SMox0MpwPKygAR/vnpy2GVz1YAIGJ060oJ50J1k9QBo=;
        b=DVzDfLNF50oQiw15FKRT9QQEf6o8UMGZAWEOaaTu07b0qnqRDhULvC+7K4OwQpMAzD
         uSWEB8bC8YwnY0fSjnLOfR8kS/a/HJrKhorSsXTBAK3EQdQoqreikQK8tE+fUVx8yXyX
         AgeAkvy6c1m9Z2W0+28Y/9uPxe5N6QZiJwFi25XsXgNy+OteJPv52PVs+0vhw3NVwioZ
         l+o5Uun5I3o6hP4zMA8l4xdc0hQMxHlPxvxSsJr0tQU/9KkAe32z2V2V80RfgrLvXtFm
         V+bFRCMUeJXxB/Pmz9e6EeHkX18GAlhiF1Z9NfotaCh9KayMQx9CqyPBb0F8mAAJUcUo
         /6dw==
X-Forwarded-Encrypted: i=1; AJvYcCVHMFs/xoy6y0Zvf7+ypKJVvjloHk01IWChFDmD5dY5vMbzC3pN64F0h9OT40douU1RUNPpKig=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywykcqenkh0mVjvE6oaTV/HuNwET0Bxj33BycJ7wT/HrlPyOaAf
	Bkuq6Ibn2B3MGHIY8ABw05WYYQhPL/bpxgO62UoHRcQmn9ZgkVd5o0de
X-Gm-Gg: ASbGncsI8sWm5+JRFd8SheP9qKAUFy9+x/V9fE6dqoQZq2zgnaNZD+Sb8TXBhuIBCtv
	y8pLlrnGp0iq2uNqxIT0hbAFEO8TqPgHwCmPgPH7HS9fjFGC9prybPLEKLA5yrPOYyS5bI4vO7l
	uSqtCctl+QiQMPOGLBxCGcSpIYjAAoXl+ZkJF8Xljz1HL9YXMLmWM/BibGI3cOTT6mSG1i9K38t
	eq3rmDRdJ5eMOUYzrogXS8Fp1QCWxnDPvt14JT+TWrstaODh+2RqfzI2KBOF+WSVosuP38qKr7u
	qNf9tT9cbCGiqB+5Jp/gV0ojD/eW5L+x/Wwrk2s205oVkm5uOl53Y/9aRVJB6BPC575a+Y4CK7t
	nPB72F8LQx4BCu9I/LNbTmerZKHMf7PzPUVrhrTizIjUnAv+q5FcjWxjK7ZJUTHGrLOikyoe3GF
	8222PD
X-Google-Smtp-Source: AGHT+IG/cgpbEdoHbmAHFosZet4Q31av0Fyi15tiHrgYeewEF3HhOE3WMKRoWF0jKeLc8Rstwt9KjA==
X-Received: by 2002:a17:906:c105:b0:ad9:85d3:e141 with SMTP id a640c23a62f3a-adfad52b9e4mr1177113166b.53.1750143623241;
        Tue, 17 Jun 2025 00:00:23 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adec8158d4dsm800843066b.28.2025.06.17.00.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 00:00:22 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v3 nf-next 3/3] netfilter: nf_flow_table_ip: don't follow fastpath when marked teardown
Date: Tue, 17 Jun 2025 09:00:07 +0200
Message-ID: <20250617070007.23812-4-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250617070007.23812-1-ericwouds@gmail.com>
References: <20250617070007.23812-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a flow is marked for teardown, because the destination is not valid
any more, the software fastpath may still be in effect and traffic is
still send to the wrong destination. Change the ip/ipv6 hooks to not use
the software fastpath for a flow that is marked to be teared down and let
the packet continue along the normal path.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nf_flow_table_ip.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 64a12b9668e7..f9bf2b466ca8 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -542,6 +542,9 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
+	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags))
+		return NF_ACCEPT;
+
 	switch (tuplehash->tuple.xmit_type) {
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		rt = dst_rtable(tuplehash->tuple.dst_cache);
@@ -838,6 +841,9 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
+	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags))
+		return NF_ACCEPT;
+
 	switch (tuplehash->tuple.xmit_type) {
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		rt = dst_rt6_info(tuplehash->tuple.dst_cache);
-- 
2.47.1

