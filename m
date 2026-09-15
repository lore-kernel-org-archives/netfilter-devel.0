Received: from mail-vs2-f12.google.com (mail-vs2-f12.google.com [74.125.227.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43F3457E47
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Sep 2026 22:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789512099; cv=none; b=UOmSS+hZwS/TFWaPNEPMdMRT3EL3oYKfHISfVlpe8CuMxhJc0CnGe9IRplsYgHUJ0SUmMQO8XaskxHLIV7mK9H9XDvCRIikBX8aCzt37L5i9nn0GvfDbUgD7lXayPpFVOHLrnEteb5NtibfoXtPJccwzD0exUUFgV2568C1V2lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789512099; c=relaxed/simple;
	bh=b5HK13t+01lwgK8AZFDZ/c6dAg/YzLEfRUoQx1+pzkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQSI00Uusxf7wLGvXkG60BHpkb/8CERff7jBbrI7PL5zb5gNSLHqyUN3My7z5hwzdJmPg5niJXTddztzang5AMix5Z43kVNBE0CUCV/KHTbvNY1lmP5c7eUKs+lrjJ0t4ZvpcnTG0aSopEtc8fI0PowzDIQQFKU8bAqDO0BHAb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GXqLpPGs; arc=none smtp.client-ip=74.125.227.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GXqLpPGs"
Received: by mail-vs2-f12.google.com with SMTP id 71dfb90a1353d-5c67e2ff27eso222127e0c.0
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Sep 2026 15:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789512097; x=1790116897; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dv7QSeB8GfKRYOXWHXl+MRBO8PNA3iqQd4syPlAQa2E=;
        b=GXqLpPGsdfhKOjl1gaEAsnDI7Mp+MYioj9hqxB3IKIJ+icU0z8gGvlLsCgFOHZposs
         TkkK2Hx0ddpO2e+O2f93gZCGzcssXMriDekgqFMV0QtB9bRexQya675lnyJcbQW5cm/G
         DBtKIM/xj2WxnEp2wcy6PlFqVmN1MKk3PZ1LC8gcBNgHBRmkMdTmmQ2FNou4cxU5qxsk
         G8XrNpsCyWKXH9u6a/e3jr3sE2ZHebjdSuOA4ORFTV5VTFYeT7YAc9LKpKyEuwylCYLU
         YfxqMizG/Ks/OilIEUtNoTJ89q74CBImr4E44/WV4+r1BnGiuZCQWBcFMAGpevaClpFP
         DeXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789512097; x=1790116897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dv7QSeB8GfKRYOXWHXl+MRBO8PNA3iqQd4syPlAQa2E=;
        b=v3qEOHo6COYoljnrmtORF+ktXFzGDRovAlcsZ38LqgSZJ/ryyLs1/dlwGG/LkBsJD+
         /tSYZhxZCPeZEs6d7juWYKwscYYvaC/wCcm0FJqIGPl6G25A7Ec9YKUflPjPPaqHn/Qz
         PFBfZGp3dNH/ozxbyHtzo51OvMyk29J5cqRkzn+MPTmfw6DpqJOENGDW/DL0pQyT+h70
         ZnYX1UNa3c6HSciG8d0IFOFhWQoLPHFOomY+wv4WKa+1/aDUbQheYJieJtW+BjZZi/6h
         Xbjo1wMBhnE7yzks1A9siQnJ1+JjPzs9EbZo6P0G2hJK88Cf6a5XSxShyGTlhzj1ZrPN
         s1rQ==
X-Forwarded-Encrypted: i=1; AKwUvBxEfqveW7TSp/PWZb8CA9Ft4ja/q0w00eIWUpnjC8cXEpCiA6xjy3CgwHsW8Vi2ZylQuD6dqcaW7TEmsQA9lKk=@vger.kernel.org
X-Gm-Message-State: AFuF++lqRJv8AfGqLBfVeoZL7b79B/PTEGkpxh7hsKxq4GZXOrX9QBDI
	74DVQna7V0/stYQ28/Cj7MFzdJDKI+Xf/J4srhRSFVLGACZbvspytKI6
X-Gm-Gg: AYBFou0gKjatTdYcfB8ltQECqGkqoHCB7VD4ior/pM1TDgPkdzpiMduZps5vCQci2PS
	T0+TB72DjsXI6HQ8sMq0bRDz3tOSiNf5MqcQIEq+VnQbh1LoYnBx1sZ2hh3q/aNhjdUJUvlsUjT
	W1Qw8whOsGabTyMpaTGDuOwUXprBtVKb2FcNRZH8c0MUZAkKf5iWplwmyMhS0wkJd9Pp/NaTUOY
	F5sLPazyGo/XqNzkzSTWkOmd/7LKcUFtXZj+BlfqAKVFocxAatwOCqEIkuo35dBA6DjwwpN82Rs
	7CtzVqQLXa5Lu6aHNwpdq9sucsk6fLMpuNyLkxZLUGqA4mM7qQlb5Y+t7jmirbnb3gboaQ2iZnm
	qdgCdy/2lOYBchhvb3KtaPKxSeRU2g74JEf262Y7EBXFQLxxgpcZ4dq5cgXnlzgqJqb8p7A05XV
	nj2UYYT+FeCpNHdryhZSwbhOoICPj90HxMCsE1ZJNLjw9yELGAry6e5b/F7s17JfA=
X-Received: by 2002:a05:6122:d24:b0:5c7:fbb5:6ea0 with SMTP id 71dfb90a1353d-5c99ae061c4mr302570e0c.4.1789512096679;
        Tue, 15 Sep 2026 15:41:36 -0700 (PDT)
Received: from adriano ([190.215.95.120])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c9988e5f27sm974975e0c.1.2026.09.15.15.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 15:41:36 -0700 (PDT)
From: Adriano Cordova <adrianox@gmail.com>
To: Simon Horman <horms@verge.net.au>,
	Julian Anastasov <ja@ssi.bg>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	netdev@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	Adriano Cordova <adrianox@gmail.com>
Subject: [PATCH v2 2/4] ipvs: stamp per-service secure_tcp on connections
Date: Tue, 15 Sep 2026 19:41:02 -0300
Message-ID: <20260915224104.639985-3-adrianox@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260915224104.639985-1-adrianox@gmail.com>
References: <20260915224104.639985-1-adrianox@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Set IP_VS_CONN_F_SECURE_TCP on every connection bound to a
destination whose service carries IP_VS_SVC_F_SECURE_TCP.

Signed-off-by: Adriano Cordova <adrianox@gmail.com>
---
Changes in v2:
- Set the flag in ip_vs_bind_dest() instead of at every ip_vs_conn_new()
  call site.

 net/netfilter/ipvs/ip_vs_conn.c | 4 ++++
 net/netfilter/ipvs/ip_vs_core.c | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 6fa3e1dc534c..0b465298b64b 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1090,6 +1090,7 @@ ip_vs_bind_dest(struct ip_vs_conn *cp, struct ip_vs_dest *dest)
 {
 	unsigned int conn_flags;
 	__u32 flags;
+	struct ip_vs_service *svc;
 
 	/* if dest is NULL, then return directly */
 	if (!dest)
@@ -1102,6 +1103,9 @@ ip_vs_bind_dest(struct ip_vs_conn *cp, struct ip_vs_dest *dest)
 	if (cp->protocol != IPPROTO_UDP)
 		conn_flags &= ~IP_VS_CONN_F_ONE_PACKET;
 	flags = cp->flags;
+	svc = rcu_dereference(dest->svc);
+	if (svc && (svc->flags & IP_VS_SVC_F_SECURE_TCP))
+		flags |= IP_VS_CONN_F_SECURE_TCP;
 	/* Bind with the destination and its corresponding transmitter */
 	if (flags & IP_VS_CONN_F_SYNC) {
 		/* Synced conns are hashed, so they can not get this flag */
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index ba0957798bad..aa8a3a964ffd 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -784,6 +784,9 @@ int ip_vs_leave(struct ip_vs_service *svc, struct sk_buff *skb,
 				      IP_VS_CONN_F_ONE_PACKET : 0;
 		union nf_inet_addr daddr = { .all = { 0, 0, 0, 0 } };
 
+		if (svc->flags & IP_VS_SVC_F_SECURE_TCP)
+			flags |= IP_VS_CONN_F_SECURE_TCP;
+
 		/* create a new connection entry */
 		IP_VS_DBG(6, "%s(): create a cache_bypass entry\n", __func__);
 		{
-- 
2.51.0

