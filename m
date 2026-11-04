Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782839;
	b=5FcY0UcmvFDbi9MwyNigm9Gx7fTdAZbEXofy+ue8jLloCoITZU+jyyiW2t7Wavkjnkcr
	 F7dO7KXtRJ8grbrs6MrxIM4N5M2EDiWmk01ZDpb5jQIo/xeUcOEhoUqccPcd/RoAJQ7/a
	 23HqzzbAcldKXqWSGAVyPcWRTVFmkHoOJUepvYp+yxHJvhXZCRVaFYjCrtvARxGNksRvr
	 4CxlvsXwWz1NpKSRQOz5T/hBU9r/ZxNinBhzJKA7b8VnWuXq3cz3Twrf9j5m1mN9g49G6
	 1ylky73AEyDw8+jfuj4brs/ad1IAzx7KFe1/t6bcDiBM1mguRm1YbPRZ22Jp1NNkR9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782839;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=vtX9eU8J3Lmk3qBwxV4wOykn6nF9IeBVyI8Jpue03zQ=;
	b=LX+JpXcLHS9U8rWQTdwQY3gmneaIhAjbw/21lj4uNw1er2U8vyHUyS2sYl/6plPzXHGo
	 kiGyIvt6xV2Nlw5wQdfbPe1Ne73fea/ICiNf4lg6/jU5fu213vUiHgFltKTRwd1Ry6Yc3
	 LiciwwaVK3aoG/bmrXDeukFt9VYmsbT53Voj4WQ8124vgBSO1FKhRXflmm/a6OFbuIyhq
	 s9j4nywSJR9PFATBfdhpVqp74aaOPycjSloijXL7bJ+WrE/FMgxmmhCKU5vy25nV1b+iS
	 7WyZwI6JZHHdD3yx/FRM/XyTgJ7MV6tR+47bhL4C66VDhwrIQNwQbKCLE26+EVOci4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=Z8N3njDk;
	arc=none smtp.remote-ip=220.197.31.2
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54CD606A328;
	Wed,  4 Nov 2026 09:00:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E54CD606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=Z8N3njDk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=vt
	X9eU8J3Lmk3qBwxV4wOykn6nF9IeBVyI8Jpue03zQ=; b=Z8N3njDkiP2htBS7bb
	wriQDgLiqr4BvEkFrWDySTYVRO+98VECIHKn+p8egmdEiZbBY9JgcC4gdcEzaHwl
	+VMLq884eeIQUUumMe9xE5Rx+lIRqiofZLj5KS1l/UenaTXMTdnP6p2KtjTsL45q
	bSr3ndJDwBOyJYYDgquZmZWGw=
Received: from localhost.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgB3LJju8+pqEDm4Dw--.32829S2;
	Wed, 04 Nov 2026 16:59:27 +0800 (CST)
From: luoqing <l1138897701@163.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net 1/2] netfilter: conntrack: avoid secs-to-jiffies overflow in SIP helper
Date: Wed,  4 Nov 2026 16:59:24 +0800
Message-Id: <20261104085925.773471-1-l1138897701@163.com>
X-Mailer: git-send-email 2.25.1
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgB3LJju8+pqEDm4Dw--.32829S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxCr47Zr4rtFyrAF4DCw4xtFb_yoW5WrW5pF
	Z3t34SyrWxJF4Yya18Cw1kA3Z8Ww4fGa4fWrWYkayrCan8JF1YkFZYgry2qa4kJr4ktr13
	Za15Wr4jkFn5ArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Uq-erUUUUU=
X-CM-SenderInfo: jorrjmiyzxliqr6rljoofrz/xtbC+Q+N0Wrq8+9h1wAA3A

From: Qing Luo <luoqing@kylinos.cn>

refresh_signalling_expectation() converts the expiry from a SIP
REGISTER 2xx response with "expires * HZ" in 32-bit arithmetic and
stores it in a u32.  sip_strtouint() only rejects values above
UINT_MAX, so the answering registrar controls the input.

Expectations are reaped with "(__s32)(exp->timeout - nfct_time_stamp)
<= 0".  At HZ=1000 an expiry of 2147484 seconds (24.9 days) crosses
2^31 and the expectation is born expired, while 4294968 seconds wraps
to 704 jiffies.  Registration refreshes break, or a signalling
expectation stays pinned for days.

Add nf_ct_secs_to_jiffies(), which multiplies in u64 and saturates at
INT_MAX so the signed expiry test stays positive, and use it for the
SIP expectation refresh.

Sweeping all 2^32-1 inputs at HZ=1000, the helper never wraps, never
yields a value that reads as expired, and matches the old expression
up to INT_MAX / HZ.

Fixes: 0f32a40fc91a ("[NETFILTER]: nf_conntrack_sip: create signalling expectations")
Cc: stable@vger.kernel.org
Signed-off-by: Qing Luo <luoqing@kylinos.cn>
---
 include/net/netfilter/nf_conntrack.h | 10 ++++++++++
 net/netfilter/nf_conntrack_sip.c     |  3 ++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index c39425e54d87..b32716084ea8 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -210,6 +210,16 @@ bool nf_ct_get_tuplepr(const struct sk_buff *skb, unsigned int nhoff,
 void __nf_ct_refresh_acct(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 			  u32 extra_jiffies, unsigned int bytes);
 
+/* Convert a timeout in seconds to jiffies, saturating at INT_MAX instead of
+ * wrapping the "secs * HZ" product in u32.
+ */
+static inline u32 nf_ct_secs_to_jiffies(u32 secs)
+{
+	u64 delta = (u64)secs * HZ;
+
+	return delta > INT_MAX ? INT_MAX : (u32)delta;
+}
+
 /* Refresh conntrack for this many jiffies and do accounting */
 static inline void nf_ct_refresh_acct(struct nf_conn *ct,
 				      enum ip_conntrack_info ctinfo,
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 64bc440b1181..e2fd97f53386 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -891,7 +891,8 @@ static int refresh_signalling_expectation(struct nf_conn *ct,
 		    exp->tuple.dst.protonum != proto ||
 		    exp->tuple.dst.u.udp.port != port)
 			continue;
-		WRITE_ONCE(exp->timeout, nfct_time_stamp + (expires * HZ));
+		WRITE_ONCE(exp->timeout,
+			   nfct_time_stamp + nf_ct_secs_to_jiffies(expires));
 		WRITE_ONCE(exp->flags, exp->flags & ~NF_CT_EXPECT_INACTIVE);
 		found = 1;
 		break;
-- 
2.25.1

