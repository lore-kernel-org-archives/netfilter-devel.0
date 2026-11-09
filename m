Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794203678;
	b=c/VxAYttGX9g5ZeFdb/JCnLFSlcxcj77tOaNMPJ1XUW8Gsvg1BtSMzI6oRKZCbhpN6Nr
	 yY7Y/QvwVo6/h1biS/da5aKoGfqUWhKsX5UIqp09XeXpKGSLulrSWk+EeHg4sMPInrn9L
	 cxBo/D9GUVqQq2o05FFxUdhO0teDmRz57MSxtbOll2xHktkTvXJzNdej54/fEVg8qVP3V
	 NXDlqqEGKKA5fK7SIqJ1PY47JQbQe2Ds9Nnv0QrPCWaHe2usRvAYX5G3hNPHHzq358bya
	 ukC5s0TMQ6JwxYA749YMLYcZT7Aet+0Y7xKuN/3iT7odI8CmI3znTIZ3jPfK/ezopLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794203678;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=5+odt879/va85pZrodnnc/2GCO8t5B5tuWVaCuFrTbg=;
	b=AnfO8Z2ln4PMC02rBFJw3l8qWt9MsN0Kbp63FcR0lLK6jY4o8fVV/GCiz+d0GH5uTBrf
	 V1uaEqHtu/wCmyBEfMLOOUO9+hYSiGD9QFLXpfUJ7Iz9x94qkDAbLzPGA7+B1Zu2UMzqt
	 z9dUx4OLT5JmcW8qAuCLeFmQKYSBvyxZZT+5g8877fhaRhOpJvE0fQD2QBDdj7bcov4E5
	 M6lmeypDsyQCJ8FGxcSk/JKo7710IqEGCY+gELYiQMrzLfnpRtBzRDzhkqCTqrP6ObkaX
	 2DIHYyRrVhVWUpqtI1WGPdykUlWpwdC8n0QhpaEC0jyCsGsWZHFlQ1ihyrMU8Nox61w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=CUyxPMPk;
	arc=none smtp.remote-ip=117.135.210.5
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942AE606A321;
	Mon,  9 Nov 2026 05:54:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 942AE606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=CUyxPMPk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=5+
	odt879/va85pZrodnnc/2GCO8t5B5tuWVaCuFrTbg=; b=CUyxPMPkyQFm4aovwP
	QcizX/Eka5iPuA+guUfKBixGWjqRyAJTszsd9HodnqMg8DE+6ZSy9in96dtz1w1E
	WWCJ6HgO1unXMg5KtE7VyvSPpfpz72/sTNjNc2aELEdFpN5yDh0yEd1XiHzPTCts
	2vwVCPpAkWyIxTY2P/h1Xi/Y8=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgCnH57FX_FqLONMEw--.40637S3;
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
Subject: [PATCH nf-next v3 2/2] netfilter: h323: avoid secs-to-jiffies overflow in RAS timeout
Date: Mon,  9 Nov 2026 13:53:09 +0800
Message-Id: <20261109055309.512876-2-l1138897701@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261109055309.512876-1-l1138897701@163.com>
References: <20261109055309.512876-1-l1138897701@163.com>
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
X-CM-TRANSID:QCgvCgCnH57FX_FqLONMEw--.40637S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxGFyDGF4kXw4UKr47GF45KFg_yoWrGw1DpF
	W8K3srKw4kJr4Yk3W093WkCFWDZws5Gay5Crn8G3yrCwnxJrsayFWfKF9F9a4UJrs7Wr4j
	qF4jqw17C3W0yFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jbdbbUUUUU=
X-CM-SenderInfo: jorrjmiyzxliqr6rljoofrz/xtbC3QcgZGrxX8e4-wAA3a

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
v3:
- Retargeted to nf-next.git as suggested by Pablo.
- Rebased onto nf-next/master.

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

