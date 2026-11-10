Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794347691;
	b=L1kYxO7np20A3uPs22t3jkccyexhc7NKhvvRwCg+4jqoWyzDq5KKIs/QqGU+c2E1Hjgs
	 bN0JvZOVV8rykobqGmZ8BMM6TuzP/RfYQFDDOFkPEDy2qh62ZOEUSF3UzAxml7C0f82mt
	 LJl5FJdr0znp/8aIBiN1+QhlCOWM708DmdnK61iAvDOOuRYgc2nnJRUy9VSJSpHh5cBjq
	 ll1B6B2sPcm4cX1VUV1v57E42UMHE7k6Sj9KdzVH55BYiCFl11uiiv+BJKMtJgTqHjwqv
	 3miT8/8aDgWNoLByvLTsYRaY13uqRea5CtqrjG+uu4oB1U8hXS8rE99yzW0B8YJ7UTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794347691;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=JOoH7GVngX1bw0mDJ44lSDyfIbs+8ZI6mGbkVX5wI5Y=;
	b=4iv94YfHCDPx9S2tQ4baB448kU0Z6p2eEoSrMBIr9bimBo6OJpYkbVvyCExSxObSL0MQ
	 58rzE4SzKfiPhtmVeL91v4eLp3lc2pCWGWtqE5AJa6RsoMJ74lolYwGtvSpiONUQ+eOUG
	 rI8N2EzGxWVyX1ogqimxwM0I69jlOoP207K2YLqd/vhDxHRyvY6wtSyRyvAs0GLk7KbQ2
	 WT5nT/iL7QqrcNTOiwNrqeridRWOy9AW9mc5DInIz/25+NRt7HHx5YGnZ9NL0thcPowoC
	 HRaAZxY/G3L8KGNccFdaGRciW+kT5A6QzyVX6yrwMFf0qff/fiqecblTh6uHTjr3CSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=IL9DKuGv;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FB4606A32D
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 21:54:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50FB4606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=IL9DKuGv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794347689;
	bh=JOoH7GVngX1bw0mDJ44lSDyfIbs+8ZI6mGbkVX5wI5Y=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=IL9DKuGv4tovyQSEyfh/f0e9nA8FOWoWWkKw+YUjYkBNcozDb23a4J/ptzjWQ7qjp
	 LeH0jIR4lEB4eXunPSLvIRGsn/U97P0ZIx9GKO9XkHKNsSN5tQVV9YWsTO1etazwO8
	 2dD0lO7kSQWC9zZvUP31QxN6ZrC/mYUeTgZlgcpuk2sr2h9CN5FissziKIi5usoEzM
	 Xtf+iCEdZfHPHsbtxQ2wzjOw8hBN61ODusrmd6VndV1OtbJj7Njf0b4VNec0XNqWge
	 t9wuM7I6AoaSzISIMa37GKTUS6CehOwLzpBHxgU/C4PoAK6HTd5UtF00lJKEr6SYLy
	 CiUu3ePjMp4FQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B780360304
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 22:54:49 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v6 6/7] netfilter: nfnetlink_queue: restrict upper verdict bitmask to queue and drop
Date: Tue, 10 Nov 2026 22:54:38 +0100
Message-ID: <20261110215439.1958120-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261110215439.1958120-1-pablo@netfilter.org>
References: <20261110215439.1958120-1-pablo@netfilter.org>
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
v6: new in this series

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

