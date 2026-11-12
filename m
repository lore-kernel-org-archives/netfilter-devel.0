Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794521680;
	b=KF9dpBAhfOV7PfvsfGYUQiggfd4tQFwvnNPJgrlvh9HG6aMNK6p8fabyhOWZraGU1tvM
	 HYYLhV3CRPzDvcq+pmanF9Y+YVZpZsJdYUs7TddOOvOtfVFvQ0/BcBKvGX4DUDNIgMwaf
	 G34Kn3l0QJraF5ExXAufO0gbXk7omFLjTKhM5SAUadVYBazvUEZZBPr8EKsQXSrGgu5gZ
	 iUwVP+YmZUuQ17DgvumdeKpxBW0xRdME8zF5FHjgPKxF/MQgc2qy83QZiAFIaPymdb6Kp
	 yItORFf3U86ShNwYnsc5x2MUqRF7B7MWEDsmE1Kqe665xySbI9cSzPEOZ/+zxO4VaHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794521680;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=McwIM8K5jFFS2Rob58TOcRIVBt2cmGHmbpJKj6n9DSE=;
	b=ulg2b4pC+aNGKZUvNZAOEk0TIL84s3fQOhp1UXl2E/jjF65mok4htRzvBW36FQZa2H0W
	 jj0ELrYxwuumnXHsFFWRBVbYdljBxIMTEO2ZNebnzU2Bd00WCgfCiGhHkkQYoPs8bz/zT
	 Q6HOr6+TENy8Qr9Y2GmjjVZr03+DieAAAhOlPuBq88xpLTv1mUgmsQG1BBZWesMFksjLh
	 WPDWPzEfauOU3CoPF6Gl0hTJyvecoyx1CAbLfG+5drnJlT9QCpHqLTr2/6FtMAO6C7ufH
	 XnWH1OJbasAlrtXO4Oj6vRrvDBmUFVd597tieHTo4NDLg5IMzy1TuE36WbcuAIb74mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Br675wee;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F41606A32E
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 22:14:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79F41606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Br675wee
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794521678;
	bh=McwIM8K5jFFS2Rob58TOcRIVBt2cmGHmbpJKj6n9DSE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Br675weeN3Y1f+DI4IwksG7wTYc+rWti+Y/gel+CgiaZCcgDdhGoYctMZxeNHr57n
	 WzNgORAgGNEuPgUUNm+ycfI7JKM3Z9vKV5PuL54NxoNYoBXFJ7wK+qTRItxD2Nk+0P
	 GXo9x7/5IP+qWpZmaz8oYPe7JS/B7sZLO863qT3llqw4cRCgHDu2j56MiD2AXX0Dk6
	 pEDceJSIW3KmT8onBhsSz7ALThP7PO7HkiGFczqcvbHMzoFGZ4gmPOH9KD+mqg+Qjm
	 cSvQYQ/hRSJysyUJ4tqVkRNwxK7stvt+hY2vlXFuqCThY3tCy+oJL+sTQcqsP23JP9
	 UmPlPVGa8X/mg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D713A6005D
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 23:14:37 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v7 RESEND 6/7] netfilter: nfnetlink_queue: restrict upper verdict bitmask to queue and drop
Date: Thu, 12 Nov 2026 23:14:28 +0100
Message-ID: <20261112221429.2279193-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261112221429.2279193-1-pablo@netfilter.org>
References: <20261112221429.2279193-1-pablo@netfilter.org>
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
v7: no changes

 net/netfilter/nfnetlink_queue.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index c6ea584d5e9d..3f6b38776ff8 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1755,15 +1755,21 @@ static struct nfqnl_msg_verdict_hdr*
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

