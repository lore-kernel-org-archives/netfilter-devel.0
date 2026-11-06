Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793945474;
	b=q1dSjiBMZejKWTEuQfVY+60W7k6PE2PrA1MF8E4dZq8f/13yRhiibqsZEQf38eqjw35I
	 DxS1VTEu8CIjui3yEIprmv8uBhgTACneFFYIJMtAO+67vDAd7ufdQ6rXUuc91q484+fxf
	 8g6BnPjYZN6whaAi6Y3v9/keCtbgalaE11poRlf2g/dTXSdmSOoOpug4eMiutZTJmKWqI
	 dbuGzG7CFHrxyxR6XfnVqDH27EnR/qCFxajPuj8HqoP1iDzqCClTE5Ln5NVj4Sn1lkicl
	 P2YELycA/aIg3glpKvHjujyXsTAT798wteJH0MkNZGp4o22g2vJqMC3ewFnFYRfUGKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793945474;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=NnkP5m19ojEmudDy7vOxxyPpI6m5O1F4PvgX0GrcFsE=;
	b=u49zhIG7ZPyuFID+rsfyKVGQBMlvpiCiPSTpQ8G7+CSgsGt+26EQVMuEAOzlkgKKbXcv
	 vzqUdZ7V3+xPyyHFCocf6wLzLGVw2wiO3SAn6eAOeypCRbflFlFTjxPu3RBTXRPGrE2RF
	 gIqJJgCMDV1LlCr3nEb7g618hpRVqrdfs4ngtoHkN7/UMTo7kirlDADLfsUBZivNHGEzu
	 Ly+dTytfcF9TWxGpoV3iDeskISkUHaaAUDkztblT4ngmHbumlnJ9QN9qmxmTJghDblYjh
	 z2xwIcg+cqI7K4WISxE2wQNgm55DWxFV/6KsEoxwU/vwVXNwVGxgtxhlev7LJychD6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=cTVD0L+6;
	arc=none smtp.remote-ip=117.135.210.2
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87238606A32D;
	Fri,  6 Nov 2026 06:11:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 87238606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=cTVD0L+6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Nn
	kP5m19ojEmudDy7vOxxyPpI6m5O1F4PvgX0GrcFsE=; b=cTVD0L+6BXitGqYHug
	MoqaPG6yUpfOvsdASceC4E+xL1/0Ljoq0R9CLZI2WKpSOkupdFH15ujg+v9RG1Tt
	bjF0KYF65WZdfzagQcr07BIOwMH/ccRp+eJfjr1VYba2xbpTWhHrl3uUSeQ1YyTK
	UkFdcmPT9fPsvBVpNMrstrgms=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wD3fxMtb+1qBVQ1FA--.50369S3;
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
Subject: [PATCH net v2 2/2] netfilter: h323: avoid secs-to-jiffies overflow in RAS timeout
Date: Fri,  6 Nov 2026 14:09:48 +0800
Message-Id: <20261106060948.540233-2-l1138897701@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261106060948.540233-1-l1138897701@163.com>
References: <20261106060948.540233-1-l1138897701@163.com>
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
X-CM-TRANSID:_____wD3fxMtb+1qBVQ1FA--.50369S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxGFyDGF4kXw4UKr47GF45KFg_yoWrGr4xpF
	W8K3srtw4kJr4Yk3W09w1kCFWDZws5Gay5urn8GayrCwnxXrsayFWfKFyj9a4UJrs7Wr4j
	qF42q3W7C3W0yFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jbdbbUUUUU=
X-CM-SenderInfo: jorrjmiyzxliqr6rljoofrz/xtbC3g-8QWrtby-rvwAA3-

From: Qing Luo <luoqing@kylinos.cn>

process_rcf() converts info->timeout with "* HZ" twice, once for the
conntrack refresh and once for the Q.931 expectation, both in 32-bit
arithmetic.  info->timeout is a u32 decoded from the ASN.1 timeToLive
field and only checked for being non-zero, so it is remote-controlled
by both the endpoint (RegistrationRequest) and the gatekeeper
(RegistrationConfirm).

With the signed expiry test "(__s32)(ct->timeout - nfct_time_stamp)
<= 0", a wrapped product can only cut the lifetime short, never
extend it: at HZ=1000 a timeToLive of 2147484 seconds (24.9 days)
crosses 2^31, so the entry is born expired and the RAS connection
drops mid-call, while 4294968 seconds wraps to 704 jiffies and the
Q.931 expectation is reaped almost immediately.  A peer that wants a
long Q.931 expectation can already get one by sending a non-wrapping
timeToLive, so the overflow is not what extends it.

Reuse nf_ct_secs_to_jiffies() for both conversions and compute the
value once.  The helper multiplies in u64 and saturates at INT_MAX,
so an oversized timeToLive now saturates to the INT_MAX jiffies
ceiling - about 24.8 days at HZ=1000 and 248 days at HZ=100 - which
is the same maximum the peer could already request with the largest
non-wrapping timeToLive (2147483 seconds at HZ=1000).  The longest
lifetime a remote peer can force on the RAS conntrack and the Q.931
expectation is therefore unchanged by this patch.

Sweeping all 2^32-1 inputs at HZ=1000, the helper never wraps, never
yields a value that reads as expired, and matches the old expression
up to INT_MAX / HZ; objdump shows the two 32-bit "imul $0x3e8" in
ras_help() replaced by a 64-bit multiply plus cmp/cmova saturation.

nf_ct_secs_to_jiffies() is added by the SIP helper patch earlier in
this series ("netfilter: conntrack: avoid secs-to-jiffies overflow in
SIP helper"), which carries a different Fixes: tag.  Backporting this
patch alone would not build; both patches are tagged for stable and
should be picked up together.

Fixes: f587de0e2feb ("[NETFILTER]: nf_conntrack/nf_nat: add H.323 helper port")
Cc: stable@vger.kernel.org
Signed-off-by: Qing Luo <luoqing@kylinos.cn>
---

v2:
- Removed the inaccurate "pinned for days" symptom from the commit message,
  as the 32-bit wrap can only shorten the lifetime, never extend it.
- Clarified that oversized TTLs now saturate to INT_MAX jiffies instead.
- Noted the build dependency on the SIP patch (1/2) for stable backports.

v1: https://lore.kernel.org/all/20261104085925.773471-2-l1138897701@163.com/

---
 net/netfilter/nf_conntrack_h323_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 4cb1665bba02..5e900037fa6f 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -1375,9 +1375,11 @@ static int process_rcf(struct sk_buff *skb, struct nf_conn *ct,
 	}
 
 	if (info->timeout > 0) {
+		u32 timeout = nf_ct_secs_to_jiffies(info->timeout);
+
 		pr_debug("nf_ct_ras: set RAS connection timeout to "
 			 "%u seconds\n", info->timeout);
-		nf_ct_refresh(ct, info->timeout * HZ);
+		nf_ct_refresh(ct, timeout);
 
 		/* Set expect timeout */
 		spin_lock_bh(&nf_conntrack_expect_lock);
@@ -1388,8 +1390,7 @@ static int process_rcf(struct sk_buff *skb, struct nf_conn *ct,
 				 "timeout to %u seconds for",
 				 info->timeout);
 			nf_ct_dump_tuple(&exp->tuple);
-			WRITE_ONCE(exp->timeout,
-				   nfct_time_stamp + (info->timeout * HZ));
+			WRITE_ONCE(exp->timeout, nfct_time_stamp + timeout);
 		}
 		spin_unlock_bh(&nf_conntrack_expect_lock);
 	}
-- 
2.25.1

