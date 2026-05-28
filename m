Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D517D33123F
	for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 07:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779952159; cv=none; b=PBYamhi+ZxNt//jTKnXyb27YUQq/sYwpUz/YBjWeXjQsAPDYSULEE5CTtNTCKMxvWyZiGzORKgSosp7NXoca0A1ntfP67WVhNBMghOn9MrjrnFECQoIv1bObVLaDnwzorvHn6aK2U6F8yola1c5oBtOWPmNN7N+gdqSIAKTTlqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779952159; c=relaxed/simple;
	bh=Lp2Ydd/vhQzgxvdtJ+PaO4rkfpJ1qSAj7X4wYdE5Rj8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mZx0Zbd3QZdajsy7SrbOrht3HxlmwUYL5Geugp9j9b1LeBf1TWNtlgh9hg+qIzqvqC4NKgy4BwothfFu1M7h1wX2Adv78P1ajog8UzDK/TBMmVi3md5w80f1+AcztroIDPvRqNfk93aqNXAUMvTKt9UnOyQRwek+dkPldmGT3Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NupAQkSK; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NupAQkSK"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-45e8a834cc2so7419739f8f.1
        for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 00:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779952155; x=1780556955; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AyhxEIcTaJ0tE2zF05eMkIwg9pnZjsy1bH02V+XNbGM=;
        b=NupAQkSKEzA0m2qsXXhFuz8Okjwzejoaz4ydIbB/bq3rv+A+V62RibeV/0eOWmSPgw
         EXhTRitsxrcyr+ZAGsyL7GWzyNBRhqXQucn28/glp2E18IvYYy3Y5OAI694/LpK74MOT
         QQO31oS0vF67DCMVNoE8xBj2L/7QoT5veFOA+ZvR4qO00qfoguRTT9BBPMRvxFKzv9aN
         w0TxZUYpH6DcYMnJd8KtDfhQ92LXqHpEgJS83jiTX/GGwGXJV6qrI2zjBtYOtYWI6Lxj
         d9CmxENw5x3wm2roPJN2GhpLcMwL19BiKvLebVlqlfNK7+OO45B+YLENrtTJcVeQDZMQ
         hveQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779952155; x=1780556955;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AyhxEIcTaJ0tE2zF05eMkIwg9pnZjsy1bH02V+XNbGM=;
        b=kbhdc+R04wMttSHWaAgx2oNZGhP60A6dhPhYBwfGOj/wnm8jkibXre1+TDZeGgVukz
         nP5rMC0Ra9M4PbZKBNLdvWlLx7JK1ZKGCguVAr9+8ZmzvAiyKBLhPeE9Xfaw4vzxvzEn
         gVL/Yo/CoywmKAd6ALBQsK2h0UF7YaHngUcxqEoemB5lHesSyE2QK6rTO7wN29y6tux5
         yURGmchnoJzjQuKWZK87F4dMG17byMX6Iuv9EgjF0mtQJDNtIaq/22ihSQf4FeB2RmuR
         dU0gmeFadktHpYUM/H8yLdIDlA+scYsh0zFQ827/8ItpY4WShnLwwuNs/9uqxiBOqzzk
         MO6Q==
X-Forwarded-Encrypted: i=1; AFNElJ+JjhU+d6eYXbvlmBC21g6ZuAJa52eQ4I8jEda1LAawtkoFIheBfYdbi5+ngE5aDS93jzvo+ZR/Lt26Ynuaw/M=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdpZ/7fNUj48r4Lei8JQ0nEqskMYsSXYOy/jTnzj/RHjf2Uy4m
	61F8AegZR8Lt5wVfzVsLIGCWzlZBWuM61wuyxluDT4VYxbYxo9WZ8CAD
X-Gm-Gg: Acq92OFNjJw177Bmgvc3hQlAuZNj7zEssypYjVbeFX6UDZGJUzJvNv3tf1S56kuvCqC
	t2+8GNJnaYdm9WuBKsxKVUbWiudAgsP+CjAeHWRde9dqrsG53mGlZHlpghMDkjsBsXQwNOUFPfj
	EhscujD94IZ4x+I1GGT41iYH67JdnmfqHOH2WGgXmh8Bqf8qNXlsef+5bcni+BwL0FIATkU8CgO
	oNOs/JQtPAud6Y8jAsINKeJtbHc6lNSDD9Ymqs/MaH7xN3qV+ZTmqzM/a6x9PmDFSi8MG1DeQH2
	AuJXnXkAZ0xdFjqZWXHkcPIB1OeXbIdSqSp45kbxPtHaNztudnYwQVAnQb0PgjmyBAZjz/dLI2e
	Y0zIQILr52/uHQjOnux36/sXoLMGoLfvvFWkgP81KVs07n1J3vVtuWlRxEtTjUfahcHnEWtzK4N
	vNcKjrPgjRuj1UIgzdrZOgpngd0LVuXM+Inay/AUGBHDhialZkQjdSTqH1QcAB9FLteDyyGhbUx
	PwAO03A7qu6dNs39hNZglV77xtr
X-Received: by 2002:a5d:5846:0:b0:45e:e5d1:8a74 with SMTP id ffacd0b85a97d-45ee5d18b41mr2471256f8f.14.1779952155005;
        Thu, 28 May 2026 00:09:15 -0700 (PDT)
Received: from localhost.localdomain ([188.27.64.216])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ee91c34bfsm2722402f8f.2.2026.05.28.00.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 00:09:14 -0700 (PDT)
From: Adrian Bente <adibente@gmail.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	nbd@nbd.name,
	sean.wang@mediatek.com,
	lorenzo@kernel.org,
	andrew+netdev@lunn.ch,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	daniel@makrotopia.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Adrian Bente <adibente@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 net] netfilter: flowtable: fix offloaded ct timeout never being extended
Date: Thu, 28 May 2026 10:08:51 +0300
Message-ID: <20260528070851.3913-1-adibente@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

OpenWrt has recently migrated many platforms to kernel 6.18. On the
MediaTek platform, which supports hardware network offloading, WiFi
connections accelerated via the WED path were observed to drop after
roughly 300 seconds.

After several debugging sessions, assisted by the Claude LLM, the
problem was narrowed down as follows:

nf_flow_table_extend_ct_timeout() extends ct->timeout for offloaded
flows using:

	cmpxchg(&ct->timeout, expires, new_timeout);

'expires' comes from nf_ct_expires(ct) and is a relative value, while
ct->timeout holds an absolute timestamp. The two are never equal, so
the cmpxchg always fails and the timeout is never extended.

This goes unnoticed for most flows, but a long-lived hardware (WED)
offloaded flow on MediaTek MT7986 eventually has ct->timeout decay to
zero, the conntrack entry is reaped and the connection breaks.

Open-code the relative value from a single READ_ONCE(ct->timeout)
snapshot and compare against that same absolute snapshot in the
cmpxchg, so the timeout extension actually takes effect while the
datapath remains authoritative if it updates ct->timeout concurrently.

Suggested-by: Florian Westphal <fw@strlen.de>
Fixes: 03428ca5cee9 ("netfilter: conntrack: rework offload nf_conn timeout extension logic")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Bente <adibente@gmail.com>
---
v2:
  - open-code expires from an absolute READ_ONCE(ct->timeout) snapshot
    instead of the relative nf_ct_expires() value (Florian Westphal)
  - change min_timeout to s32 to keep the comparison signed
  - initialise new_timeout to 1 instead of true

 net/netfilter/nf_flow_table_core.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 3313f82..a2d08e5 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -500,8 +500,13 @@
  */
 static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
 {
-	static const u32 min_timeout = 5 * 60 * HZ;
-	u32 expires = nf_ct_expires(ct);
+	static const s32 min_timeout = 5 * 60 * HZ;
+	u32 ct_timeout = READ_ONCE(ct->timeout);
+	s32 expires;
+
+	expires = ct_timeout - nfct_time_stamp;
+	if (expires <= 0) /* already expired */
+		return;
 
 	/* normal case: large enough timeout, nothing to do. */
 	if (likely(expires >= min_timeout))
@@ -519,7 +524,7 @@ static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
 	if (nf_ct_is_confirmed(ct) &&
 	    test_bit(IPS_OFFLOAD_BIT, &ct->status)) {
 		u8 l4proto = nf_ct_protonum(ct);
-		u32 new_timeout = true;
+		u32 new_timeout = 1;
 
 		switch (l4proto) {
 		case IPPROTO_UDP:
@@ -544,7 +549,7 @@ static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
 		 */
 		if (new_timeout) {
 			new_timeout += nfct_time_stamp;
-			cmpxchg(&ct->timeout, expires, new_timeout);
+			cmpxchg(&ct->timeout, ct_timeout, new_timeout);
 		}
 	}
 
-- 
2.43.0

