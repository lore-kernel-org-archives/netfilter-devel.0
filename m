Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794826785;
	b=1wdUsLdHUZ5WUECAniLTn3Z1ZGUXBhsnLWZGR3odh7iFgAbBlEUU8hrQMTiE/wCV0znl
	 lBGiDEbd58jY+LiBXHMBW0n4nCusI5mWOK71BpnUv56j6CPOi4ExkhruXvMj2VocMdGDb
	 3kfUW2RIHicKemLG2rSaGwuAtTLt+IO0ByeOszWFFQUj41ky8gcIUCzrBTn8zC9P2eWz0
	 qY8Xjw6Aa445+Z7nwe9cyBeiQxcXTe9xEuckovxmwRCfmiwO1t9jX8/AvtSU/61yjTIS1
	 KWEDX6y5S25qYGXDbvZkdeQc3h0nckjQlD0WHjCaHeKCdHQ6m6uZWUgTrI5fbfKJzXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794826785;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=tSphpjLbCLU5rrUiuAvtIE2/ljwXjgxybfvGuYDoUIM=;
	b=ZdafZHJG1DFYXTvxxerehr1G0G/sbVPLH9hwmHjT+e/IR5NKhTilK6niw+Dm+3qw9jDe
	 WzjpquHYhJ5uAY/JLYg3Gwov5DSwILPWFROQcs9I1yhnHkzZ+JonFZvobhSevZ8RnSzEg
	 TAzNfvRCccXbA3o+muhT63ikZAeE9b93vtLjTIVUQpiuMaEH3KTm+o0OMNJbw2bAn9Rn6
	 DLFpRUM+nnb8yZLj0XAJXPHoLBnxsUCI9NYb3Tf4c3FHsuvM/JpFvG4nbr9fxUNdajWoY
	 0E5vY4/0asiaDqK4pYanMIvWkyRBrTnuVSPPSrHld4L6ARfWcMdL8p93PHG1gbLYuNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=NLKwsyVs;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF068606A31C
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 10:59:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF068606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=NLKwsyVs
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794826781;
	bh=tSphpjLbCLU5rrUiuAvtIE2/ljwXjgxybfvGuYDoUIM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=NLKwsyVs2I727vDSfIkCGBRooERUOzvPgDITBLAFzGmn6n90OjMe0Zirj7FwNsm2w
	 YhY493S+Q95YHrP9jUSZnxnP2P3slfOpOSKqLebxN8skQz96Z+x5G1P5nvpXOaVUgi
	 7jWQDhm5k4Iva95aX7hSNVvPQClaOym6LxNJ5yxGw6/hnLJbzKmk3V0Js4xQ1x6N42
	 ChG1YudiL4enHcBsjWgYG+1t2CGGjhMraDbG2nQ95XaOiH1eRyCCLv+iSWGLSi0IeH
	 EspJPoDANY0Ed4VFjDCVvX3Ww+aNROjnP4/jsjyM01Oiy5V2jXruptOgVUUye9E3Bg
	 WySS2TG0Po+kA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C964F60092
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 11:59:41 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v9 6/7] netfilter: nfnetlink_queue: restrict upper verdict bitmask to queue and drop
Date: Mon, 16 Nov 2026 11:59:30 +0100
Message-ID: <20261116105931.2866911-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116105931.2866911-1-pablo@netfilter.org>
References: <20261116105931.2866911-1-pablo@netfilter.org>
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
v9: no changes

 net/netfilter/nfnetlink_queue.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index dad532ce6148..7e21a465d4c6 100644
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

