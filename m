Received: from mail-vs2-f12.google.com (mail-vs2-f12.google.com [74.125.227.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD21E41D13D
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Sep 2026 20:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789591845; cv=none; b=bfl7YaQNBf4pPTNZnLQmL4Ar4C44FJRzkLR+ZsMovijjVqORyuT956Mj55zA4vcyBPGWpHzOjD5+Tj+sW2CcngshuBPTDX6AYfY3cl3DFkD8Xaeg8QWfPPgMCWXKv0Tfgi7kabDR4CXm8rUrymaWoYoGDkwYPNH1b3iirmROY6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789591845; c=relaxed/simple;
	bh=r4G5Ta8DgCpNKxXd+Tmp2CKseIRyFZZjfIzJ3sbKUC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjc4PTrsw1ltMiUHw1nAqAToMpFpkvDIGodcxfGKE6ouIpz9DTvBYQm7QajHRCDDpSrz3rBa0E9vXH7pAy10FvmRj/XuXh940wjJEraCZUJoYYeDdT9EaQZUFdb8MbSX0y4Alt3QqnuMLNmF9YPArmKNGo69N5ItnGm34ayXN54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AcCB7A90; arc=none smtp.client-ip=74.125.227.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AcCB7A90"
Received: by mail-vs2-f12.google.com with SMTP id ada2fe7eead31-785686d2112so46054137.3
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Sep 2026 13:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789591828; x=1790196628; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HSr0kw5vQg14RdBAH3z3ZmTLwP6SZgfcuyqihKeKt2U=;
        b=AcCB7A90RXmTOiPQFMW3SPPCkzaWVe4pHvC0LQq1VQOXzdJVz7ziHkjWmnToVUSERZ
         mXkq/7xTHDQN7VjYmHwHaKgLH23IAalRbJWXCmX5jyt1Y6H27KoMA0ZajKbsXf2pn1Oy
         91GqAEMvkIBzFJ5Yh01JddAjIstioH6YcYKDY2duina3s5TMxzN6ovc4y4O2ak8BUUg5
         JU1ssB3HwBFX8jb85MkO1pCa62zp9nbTg+VjllAKotDfV1safHXglObHxjWf2HXdKGce
         4kfd7urAOoLAe8oXk4yjG98gCxe6MbrtUIVV60z5icDUyBILoB/kAQ4+DWZKskQ5W+ox
         Y5bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789591828; x=1790196628;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HSr0kw5vQg14RdBAH3z3ZmTLwP6SZgfcuyqihKeKt2U=;
        b=EwZ5zYW5TpQgWPOJI79pvwybztm6W+bQtKlwTPSMXdNlHe00i/tuJmhw7AJxttAch5
         UqpQ2jR4WVNy29JfUifN4c7JCNy5XkN+pXHTwl4Nys+6itxOMP2fb1anGWlw/YnKbpLh
         8L5FL7AXqTXpQ90WUxDOaPmDZ/oxbDMc6R/ieOCiDKlnJ4IluFOkr5WdizlH5i9Nfl3A
         La4lJ69I9uMOG937wy+uFD6KEBqupdq4eEATv+oM1yrOFHPTxhitBvxX7AQeCw7vxi3Q
         L0obhUCvb8RDPrg5ONU2DirH4XkMeAq5cLm5oUSUpxF8XavqEzKVr1iR3VQ+7KYm4Sab
         8EAw==
X-Forwarded-Encrypted: i=1; AKwUvBzIFwoB38so7s5HyIncij48M8yPZv6ipclhKSvziW7pepCQge0W4ipbREDQgtmZB5zznLmUboTBwIWiA9hQi1Y=@vger.kernel.org
X-Gm-Message-State: AFuF++mBuIR4iysTfbUJmIYIY4iqFl35xJke1e+8Y4X/PwLUKf5SG5Sk
	YYQeJWA2GUVfsYA3V1qCyX+6ver/Ouy+6RP+G+drXkI386wLg+MaBBqM
X-Gm-Gg: AYBFou229gK8qv8gIGVCczp1CO9J0oZlqBF5tf+jR1018Hgc3hEnGQXPjK5fBqlYiRQ
	tHuNzxxZG114Vmu3JBocQIrvFga1ia5bzBTSdjclvovMFSvRE0OhidFI44OnIoDgXs4w39n0xTy
	YY6hZ4mYeT1o6aWzcZWsBg9n+N021kMG08//NXxvHVioU3g2s9FqaWbg9losgtwXwutkVYBgdnh
	ua/bIKdjy/CW9V2cVjX2xrnoBXYl7dYwVafTaIJPoGXj8jc+kBTM6hwQxlwKvQNaH7rTC5TVW6+
	b2tTTeWYQAKP3GogWdkzzecyhDAt9r3QG7ZkDWS9lbReR7RAHS/7uS2LRW67s+SCsFjJJDVpJXX
	rvn9zU2vBBQCk28E3gw+JXIFUREMqXklFJ7/ULwo3Rhsp7ZEibD8iZsEC/+TNuzFUHzs5+FkRkq
	kcx+OkIDbZcFFDZ4RdjAZ6V9m9VBAeviHJaUjCUNU3bKkqVd0nYzrxUCDCi2Ol6CWJ
X-Received: by 2002:a05:6102:f9c:b0:7a1:f7d2:e80d with SMTP id ada2fe7eead31-7a1f7e27e6bmr657555137.21.1789591828210;
        Wed, 16 Sep 2026 13:50:28 -0700 (PDT)
Received: from adriano ([190.215.95.120])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-9832354a8aasm947799241.10.2026.09.16.13.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 13:50:27 -0700 (PDT)
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
Subject: [PATCH v3 nf-next 1/3] ipvs: add flags for per-service secure TCP state table
Date: Wed, 16 Sep 2026 17:50:02 -0300
Message-ID: <20260916205004.647194-2-adrianox@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260916205004.647194-1-adrianox@gmail.com>
References: <20260916205004.647194-1-adrianox@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add IP_VS_SVC_F_SECURE_TCP to mark a virtual service for the
DoS-hardened TCP connection state table, and
IP_VS_CONN_F_SECURE_TCP to carry that capability on a connection
so the TCP state machine can select the hardened table for it.

The service flag is 0x0100: bits 0x0008/0x0010/0x0020 are the
scheduler bits, so leave 0x0040/0x0080 free for schedulers.

Set IP_VS_CONN_F_SECURE_TCP on every connection bound to a
destination whose service carries IP_VS_SVC_F_SECURE_TCP.

Signed-off-by: Adriano Cordova <adrianox@gmail.com>
---
Changes in v2:
- Let IP_VS_SVC_F_SECURE_TCP be 0x0100, leaving 0x0040/0x0080 free for
  scheduler flags.
- Let IP_VS_CONN_F_SECURE_TCP be (1 << 17) and drop it from
  IP_VS_CONN_F_BACKUP_MASK.
- Set the flag in ip_vs_bind_dest() instead of at every ip_vs_conn_new()
  call site.

(no changes since v2)

 include/uapi/linux/ip_vs.h      | 2 ++
 net/netfilter/ipvs/ip_vs_conn.c | 4 ++++
 net/netfilter/ipvs/ip_vs_core.c | 3 +++
 3 files changed, 9 insertions(+)

diff --git a/include/uapi/linux/ip_vs.h b/include/uapi/linux/ip_vs.h
index 2c37c6ac7525..ade170109ff4 100644
--- a/include/uapi/linux/ip_vs.h
+++ b/include/uapi/linux/ip_vs.h
@@ -27,6 +27,7 @@
 
 #define IP_VS_SVC_F_SCHED_SH_FALLBACK	IP_VS_SVC_F_SCHED1 /* SH fallback */
 #define IP_VS_SVC_F_SCHED_SH_PORT	IP_VS_SVC_F_SCHED2 /* SH use port */
+#define IP_VS_SVC_F_SECURE_TCP	0x0100		/* use the hardened TCP table */
 
 /*
  *      IPVS sync daemon states
@@ -105,6 +106,7 @@
 
 /* Flags that are not sent to backup server start from bit 16 */
 #define IP_VS_CONN_F_NFCT	(1 << 16)	/* use netfilter conntrack */
+#define IP_VS_CONN_F_SECURE_TCP	(1 << 17)	/* use the hardened TCP table */
 
 /* Connection flags from destination that can be changed by user space */
 #define IP_VS_CONN_F_DEST_MASK (IP_VS_CONN_F_FWD_MASK | \
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

