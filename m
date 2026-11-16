Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794789466;
	b=Lq6cZJ1sILNemNT9NBZNVa+1HZb5USsFcZu2ewjejl+n0weX4Qb8T/8cDuoOfl6NMfMd
	 PZVn8UH/uCQPRUUBKfajy+37C3h/VrjYAoHEY6Id8NdM7b8x6qXAfCtFYAaUE1GmMZGN+
	 EoJ+W5CCTMxQ38j5Bo/wIOwiVJAVaVO9sTK23bLwzbzo/Gs0sMr1c3JnCwyLkLATn8jdt
	 Q2GV2oVqN+nMytWnisxzPuvYeSvnimeHZVv9wXCtrrXvNKNunG5JxG1rHlA/6LPgbZIlN
	 KeqcAvFuDWcjt0BbXHMui9YA7b/5oEDjWVycn9EbLn9pfU/N85YGdoiOdtKTQtfABHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794789466;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=X3ptxyAEZ1pIvJDKGN+LRJWHzIWzZPGUii5Z+BeWnus=;
	b=pvV4OwzPsA386ULUm7RC8QV1XAeSAWI3lqJYKg2/Y/yjvxZymXdZSdOzv5XgYpAPcC33
	 pPAzSs0vn97fxBc8Vdoek8dR+UzAhKYvO+2gflB/P1onc4s6b/YyovU9g1az7dxYnxcc1
	 GT5P3muuCI/0BkfYmz52sR8QKY9cTRieGtPWYkeqDbUtS1+JIs6918xwsRf5cK/lrpfp7
	 caBhx/cJxL+x3IW3d95eVis5+mXqMgE1IDsj6InysBfQZyLqICbWQsBmMEhQiYURKSsBA
	 B6KDp7Worx2BUcUZcSXN/I9By8fmftrako3t7BCnPrrgOX8AMF9qM2iHnNwO75j/qDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=UVlJg9Ng;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7E7606A331
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 00:37:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB7E7606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=UVlJg9Ng
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794789464;
	bh=X3ptxyAEZ1pIvJDKGN+LRJWHzIWzZPGUii5Z+BeWnus=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=UVlJg9NgIwmunRK850+EfY9RHvRQfn6H/Gva+vL25JOCzvpmefsP2AcnV9eEKWKiz
	 nPsVt0NpyjT7HtCgSMydVzNgvHbXXhGOQ7ZU3V9zW2Pu6ripYuQVNimq9eqpjwk9uY
	 thI1cArtiaSlLsNLnQwOhDzSFl6myXdJgv9yE6V89U+IYcs3i5ZTGZ0jr9jshmDjAb
	 Euj6p0pX6ZhsHQwdNyMxfVPUlllpy8atDdvBio/ySvWUI+Mbl4kkswQwxtOURGTyt8
	 GbBYZ4AvVkVMqVCpaA+54Zxz2zEaZXmoDs9yhvb5AM8Fzt+NErO/mrrg46D4Wh2Id0
	 qr40URa6uKvgA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1316460076
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 01:37:44 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v8 6/7] netfilter: nfnetlink_queue: restrict upper verdict bitmask to queue and drop
Date: Mon, 16 Nov 2026 01:37:32 +0100
Message-ID: <20261116003733.2820132-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116003733.2820132-1-pablo@netfilter.org>
References: <20261116003733.2820132-1-pablo@netfilter.org>
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

NF_QUEUE and NF_DROP use upper bits in the verdict mask to store
the bypass flags as well as the queue numbers. Reject any other use.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v8: no changes

 net/netfilter/nfnetlink_queue.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 2e0081fbcc5e..c52ac4a3dd80 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1768,15 +1768,21 @@ static struct nfqnl_msg_verdict_hdr*
 verdicthdr_get(const struct nlattr * const nfqa[])
 {
 	struct nfqnl_msg_verdict_hdr *vhdr;
-	unsigned int verdict;
+	unsigned int verdict, verdict_mask;
 
 	if (!nfqa[NFQA_VERDICT_HDR])
 		return NULL;
 
 	vhdr = nla_data(nfqa[NFQA_VERDICT_HDR]);
-	verdict = ntohl(vhdr->verdict) & NF_VERDICT_MASK;
-	if (verdict > NF_MAX_VERDICT || verdict == NF_STOLEN)
+	verdict = ntohl(vhdr->verdict);
+	verdict_mask = verdict & NF_VERDICT_MASK;
+	if (verdict_mask > NF_MAX_VERDICT || verdict_mask == NF_STOLEN)
 		return NULL;
+	if (verdict_mask != NF_QUEUE &&
+	    verdict_mask != NF_DROP &&
+	    verdict & ~NF_VERDICT_MASK)
+		return NULL;
+
 	return vhdr;
 }
 
-- 
2.47.3

