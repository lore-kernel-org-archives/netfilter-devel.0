Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782843;
	b=cQNkyFPuqsRs2jhM0SkraNVF/6TPT+OxoO7IJF0TpKFEoUtEMPwfcMN18zCNx7GapmU0
	 fgUC8JSYVnDXETZIPJUp+hoccusEQJ7mrosj8daMNkcz27iiMQZrHOgbh9lhcCmBQdRYg
	 RU1Sqz7/pWuHrd4V4H9S26JX7rZAoG3QRk5KVMuBXqKsVBeliFY+jA1bjQOg9HLZlFq5L
	 ZQdjej8df8srvY2PU+FXOHUwx+C6q+CDSQ7ldCWx77Yot0nQYapC5mYfBunVjH5AfjiA4
	 57ZcFVEY3+EWoNnCKh0yJrN9OH5KNAVMt0tbW/DzNm1zu2ldcQ0rov526OFpVNVVABg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782843;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=8H9Y/J3F3inFdF+nnaPoG+JnVtlCMIQn9GwvVhWehH4=;
	b=DEvgEyVE6qSFeqOfwkxa/Wdzmc+k+wdlY/qOSawjiSWQsxGO5Y5hLSmrOVc/0c2wUtxU
	 oM+zq2vmrfPXU1Nc3153i2nicnbhhTn8Hq9o6pACFP18uEJLfkVavBkitvWWMOV/rk0kb
	 SMtS8R0frmi6/Eg5o6UBVa5rlAVjFImL918Rxaa1c2rULvtoKrMSl/s8V6e8ub8XopbEk
	 r4MMmfDOBck/30gDUoOO9g5/E+ubUKhlHn/xeXAJ/FjBz8DLoXJ4OAfZvAm1537y80Q33
	 AoYfEEhgtcwcsbL/fWQZeQ7Gb31nkKGkADzvQ92PyBKsLFM4IAKQcyNHu6oyzBVO+7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=hgxgTSLT;
	arc=none smtp.remote-ip=117.135.210.4
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1627B606A326;
	Wed,  4 Nov 2026 09:00:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1627B606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=hgxgTSLT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=8H
	9Y/J3F3inFdF+nnaPoG+JnVtlCMIQn9GwvVhWehH4=; b=hgxgTSLTlOtbH4xmAG
	UeEOUQSBj435U8QuDQbvp/AilR1VxktQgQTbB1JtnGkr4KZz+ReyynSkkcol3t0M
	R5BsH7TFN2gGTi6Vcyuvep1BXu5g4ZEEDcxF6KTXaKD2BHf0+5KDmbCBkXG6kKnc
	x55727gvJ4Rw/u4ir71dpvkS8=
Received: from localhost.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgB3LJju8+pqEDm4Dw--.32829S3;
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
Subject: [PATCH net 2/2] netfilter: h323: avoid secs-to-jiffies overflow in RAS timeout
Date: Wed,  4 Nov 2026 16:59:25 +0800
Message-Id: <20261104085925.773471-2-l1138897701@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261104085925.773471-1-l1138897701@163.com>
References: <20261104085925.773471-1-l1138897701@163.com>
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
X-CM-TRANSID:PygvCgB3LJju8+pqEDm4Dw--.32829S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7CFWrXF18Gr1kZryUJw4rAFb_yoW8Kw1xpF
	W5K3srKw4xJr4Yk3Wvk3WkAF4DXw4fGF45Crn8KayrCwn8Jr1v9FWFk3s2ga47trs3Xr43
	ZF4jqw17G3W0yFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j1PfQUUUUU=
X-CM-SenderInfo: jorrjmiyzxliqr6rljoofrz/xtbC3Q+N0Wrq8+9HUAAA3F

From: Qing Luo <luoqing@kylinos.cn>

process_rcf() converts info->timeout with "* HZ" twice, once for the
conntrack refresh and once for the Q.931 expectation, both in 32-bit
arithmetic.  info->timeout is a u32 decoded from the ASN.1 timeToLive
field and only checked for being non-zero, so it is remote-controlled
by both the endpoint (RegistrationRequest) and the gatekeeper
(RegistrationConfirm).

With the signed expiry test "(__s32)(ct->timeout - nfct_time_stamp)
<= 0", a timeout of 2147484 seconds (24.9 days) at HZ=1000 is born
expired, and 4294968 seconds wraps to 704 jiffies.  The RAS connection
therefore drops mid-call, or the Q.931 expectation stays pinned for
days after the peer is gone.

Reuse nf_ct_secs_to_jiffies() for both conversions and compute the
value once.

Sweeping all 2^32-1 inputs at HZ=1000, the helper never wraps, never
yields a value that reads as expired, and matches the old expression
up to INT_MAX / HZ; objdump shows the two 32-bit "imul $0x3e8" in
ras_help() replaced by a 64-bit multiply plus cmp/cmova saturation.

Fixes: f587de0e2feb ("[NETFILTER]: nf_conntrack/nf_nat: add H.323 helper port")
Cc: stable@vger.kernel.org
Signed-off-by: Qing Luo <luoqing@kylinos.cn>
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

