Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793945474;
	b=ks73vkrNberWNhLQ0xBTF52zSyVkEb7RRsbWxWNeiBLE8HZkW+ss7+3qWXcM6K1MN7sB
	 iRkSJd72qikcODHtf+gSx9JhuEvVagq1IrP/Z8d1jPQ9+nmqGUAuk8dGjP8mXURqcrgsu
	 5D8LWczWCpjDjl+2tHh+Z+sf+p3LavQ3FOYhDAPjkpzULZMXDuIUpzLw2Hkx6fncaOBvQ
	 Loep8iPL+5HG43v+A4wgF+LrlizwToex5t5vsAd9MZ5aO5ZudrHBLy1MyXYTmz7ondoX3
	 c4p70A45qlM3MbiAxbgk7IHi+4hEP5Fc9QUNKq8kRO3i8/YGooWlBHgGNDE1PkZ8H0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793945474;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=8YF17ywi0dWJGRvCkQz9HkVWfG/t9IghxQFLb2psZSk=;
	b=xAFCtv42C5nZ5qVJOiemF1vLpLTBjNLe3LPtJgyTcQTN+79v8Vb23b8S9rwDzLxyaKd1
	 MNLPWO1BuDX1yzCrpTJ9pYmkScIzhFj+T4mt9uwia6PWWt2uM/nyQJNXDmyr/BRGGV+LD
	 r8JP1Smy4867ZxRhJq0cu6E7I3E/mzWb/l1ReVCkZCynAlP7/WeNt33Gg1I8/IiUs45cI
	 eWHZy3SsDEzGima4VBOZjIALGwrCvBUkUVjjcAycy2Zg9zlhc2kVmN1e1irdaUwVSksQC
	 pdXeZm+K10fAs/6T4uI8LwuEGaw6OKKHdlEIMpBAWU9eyr6xPEFrCEX+VbPN4zQr2IA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=YgMup7zM;
	arc=none smtp.remote-ip=117.135.210.4
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81847606A328;
	Fri,  6 Nov 2026 06:11:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81847606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=YgMup7zM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=8Y
	F17ywi0dWJGRvCkQz9HkVWfG/t9IghxQFLb2psZSk=; b=YgMup7zM/fedPmb4Q8
	ElAARwa4KSD9cPFRztZHcTWbK4j27JwOQ8lcd9KzYWU4HV8QKRJCXGgzBSHneIMV
	nuCjwbTbErUdXZhKM5dPqzldr4t6um8IUgBdgbG4yVWX3oCSwDQTU2lezvRWHc4x
	aJmJbRC9+jEq2TV6gVLthxnBg=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wD3fxMtb+1qBVQ1FA--.50369S2;
	Fri, 06 Nov 2026 14:09:51 +0800 (CST)
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
Subject: [PATCH net v2 1/2] netfilter: conntrack: avoid secs-to-jiffies overflow in SIP helper
Date: Fri,  6 Nov 2026 14:09:47 +0800
Message-Id: <20261106060948.540233-1-l1138897701@163.com>
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
X-CM-TRANSID:_____wD3fxMtb+1qBVQ1FA--.50369S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxCr47Zr4fAryUAF45ZF48Crg_yoW5tw4DpF
	Z5t34Syr47XF4Fya1kCwn7A3Z8Ww4fGa4fWFWYk3yrCan8JF1rtFZ5Kry2qa4DJr4ktry3
	Xay5Wr1jkF1kAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U6q2_UUUUU=
X-CM-SenderInfo: jorrjmiyzxliqr6rljoofrz/xtbC3Q-8QWrtby-JUwAA3y

From: Qing Luo <luoqing@kylinos.cn>

refresh_signalling_expectation() converts the expiry from a SIP
REGISTER 2xx response with "expires * HZ" in 32-bit arithmetic and
stores it in a u32.  sip_strtouint() only rejects values above
UINT_MAX, so the answering registrar controls the input.

Expectations are reaped with "(__s32)(exp->timeout - nfct_time_stamp)
<= 0".  A wrapped product can only cut the lifetime short, never
extend it: at HZ=1000 an expiry of 2147484 seconds (24.9 days)
crosses 2^31, so the expectation is born expired and registration
refreshes break, while 4294968 seconds wraps to 704 jiffies and the
expectation is reaped almost immediately.

Add nf_ct_secs_to_jiffies(), which multiplies in u64 and saturates at
INT_MAX so the signed expiry test stays positive, and use it for the
SIP expectation refresh.  Oversized expiries now saturate to the
INT_MAX jiffies ceiling - about 24.8 days at HZ=1000 and 248 days at
HZ=100 - which is the same maximum a registrar could already request
with the largest non-wrapping value; the longest lifetime does not
change.

Sweeping all 2^32-1 inputs at HZ=1000, the helper never wraps, never
yields a value that reads as expired, and matches the old expression
up to INT_MAX / HZ.

Fixes: 0f32a40fc91a ("[NETFILTER]: nf_conntrack_sip: create signalling expectations")
Cc: stable@vger.kernel.org
Signed-off-by: Qing Luo <luoqing@kylinos.cn>
---

v2: 
- Clarified in the commit message that this patch introduces the
  nf_ct_secs_to_jiffies() helper, which the subsequent H.323 patch depends on.
- Added a note about the stable backporting dependency for the helper.
- Addressed the Sashiko AI review comments.

v1: https://lore.kernel.org/all/20261104085925.773471-1-l1138897701@163.com/

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

