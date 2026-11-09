Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794203686;
	b=ldhui/4dmxNQLWEpbJTnXQ+8cNAnehkTfFm9mRtvu3MhFfP0RbmYGtNfVl5I3JWL2GSk
	 cCkOvCjFAEL+qes6D3zv9zvhsAmt9NimIBEkBfbqddecEdjPoXVcGblWAwi2ldLz0Jsgq
	 zbVhKoqPCwcfDVHy1aC8W4ciyEr3mMOz1hodoCnwVnQEVe/kAyZFdWmjwn1lZdkEN5SGm
	 BDUlBo20/ggClF+Qxyydlqz+y7m3H8ODJ5pjz0Dtkiyo9xfOD8HKcy3ki2LGNqwO/SNfy
	 5YD5dnxY3w7Z0VYflasc7NPqOYzI4geIfFL+TXmPdEKL/NAvkAHH0CRlwjth/h7cFOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794203686;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=4vpGeLeIeYKZwhRX632ZaQaeUd4pqX7ikOfK30oZWrU=;
	b=dvHG5MY2t44nTZ42dXWV6i1p4KOsrSGQhqvZOCyFHwmRm1vAanMA0KlJiGHylFm15X/p
	 5oj7uHe/itAPYkGwSfpcKKS71ZXw27args1+ke9b+kcB7L4bgl2Qy05tq41PIR9v/Ej8L
	 m1fidwcBuy0/6QKLXIAapZglW4hGFtwOn8JI0OfsPbwDea6RK3cvQUhULnzDYXEGYEfTD
	 QIxi3xhtYf8m99yNCWOF3dyo1jnGnp+4veN69GD1HU+fGMz1DWyWcc8mat08g5oqsawHL
	 ZBdRDXzGxbVPXXr9h7MMzsbwPnHtUUMCt/SJHevETeSmQC+9YjnhLhQqMVeU1Ts4SpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b="Frq8lN/0";
	arc=none smtp.remote-ip=117.135.210.4
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5A3606A322;
	Mon,  9 Nov 2026 05:54:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A5A3606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=Frq8lN/0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=4v
	pGeLeIeYKZwhRX632ZaQaeUd4pqX7ikOfK30oZWrU=; b=Frq8lN/0a9nWkGTscR
	mZ+0pAEoHPzJsNoHAz9AO7hq8QlZzM78heafuW+ZTEpvbME6/5eCi3g2VbdIDF46
	F+WMLCMXxAyEDCAyTskcSKWhjWoYHEt0jtAeidYbIDipmBYiQATA8Y9/FWd5Dt6Z
	6Eou9nW7ESbCoRp9WjYO0zIsU=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgCnH57FX_FqLONMEw--.40637S2;
	Mon, 09 Nov 2026 13:53:11 +0800 (CST)
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
Subject: [PATCH nf-next v3 1/2] netfilter: conntrack: avoid secs-to-jiffies overflow in SIP helper
Date: Mon,  9 Nov 2026 13:53:08 +0800
Message-Id: <20261109055309.512876-1-l1138897701@163.com>
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
X-CM-TRANSID:QCgvCgCnH57FX_FqLONMEw--.40637S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxCr47Zr4fAryUAF45ZF48Crg_yoWrJF1rpF
	Wrt34Skr4xXF4Sya1kCwn7Aas8Ww4fGa4fWFWYk3yrCanxJF1rKFZagry2qa4DJrWktF13
	Xa15Wr1jkF1kAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U6q2_UUUUU=
X-CM-SenderInfo: jorrjmiyzxliqr6rljoofrz/xtbC3QcgZGrxX8e49wAA3S

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
v3:
- Retargeted to nf-next.git as suggested by Pablo.
- Rebased onto nf-next/master.
  
v2:
- Clarified in the commit message that this patch introduces the
  nf_ct_secs_to_jiffies() helper, which the subsequent H.323 patch depends on.
- Added a note about the stable backporting dependency for the helper.
- Addressed the Sashiko AI review comments.
https://lore.kernel.org/all/20261106060948.540233-1-l1138897701@163.com/

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

