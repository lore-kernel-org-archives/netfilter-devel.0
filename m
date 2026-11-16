Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788219;
	b=J0xzqA0w+BwULwoBNDs0wAHBjr6JeNczaz4TzummzeF//1A1DiMM5KlrWajC+c/dUWOE
	 EjPJR1KXJ4b2w/KvGEwDlOrY9ItYBsYN+5HuCE8R+psP+DHgqbVQa5oSOGyDwgWNhoddG
	 voDM/Tx/PJmB3kbZ5SgEHKVMYj6IoNNtXw0C6Y3HikzQDd4lPh1sMc4lygw0uWwk81tnc
	 AnznuYEPb3AgutKRtFDODf+hg4ivaIgByVbyzrej/JuxVYWAF8na7X2YSNoFCoV3JplR1
	 tg/wBwFjXQsy/8WjIjqbLNatDITBnHNTXNQDMl8NqeKG9OTJlFxOJHRTqPvJVKNNbxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788219;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=WelIR0F7YD/FJ/8bWUoOOir8JE2QhOx6M1KWLomVR3Q=;
	b=2zejTN0h6DsIviS4FQ7l3SbSuH2GtL35P0CQOB+3zs+/IJsBWa5vechhrW9US5YR+oos
	 ItfOYs0SCudBxdio8gOhTWU0RsA3hpGO8qIBfeTUJMnaUozFTgKmdd5i0tFWysr/6PBtZ
	 C+jGL6v7td3naVwkQ7voXhc8w20RQnMrAqblbZgEGZjAp/bC6giHkv7ihdXZSP8UE34oA
	 bRqdAgta1MEyNS1xzvqjcd3fD3C6Fhqm6n2YfG+1+dEw/7oOFPuFiMah+43hJXTi9MYcb
	 tjBpH8yzwrite5LdbZzRuIhF0lUqEGf7LbHn+PUZ8uGdxBNrT2eK+QuEIPBeclF087g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=S3s7Ycyy;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57113606A329;
	Mon, 16 Nov 2026 00:16:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57113606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=S3s7Ycyy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794788217;
	bh=WelIR0F7YD/FJ/8bWUoOOir8JE2QhOx6M1KWLomVR3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S3s7YcyylrXi2KmaXare+v9sAJ7Fku7l+p952gdDibNW49SJwGksv00BEo7n5/XXQ
	 TfuvrwZdeen2HjUsoqZP8PBjxUbsEEjye98PvXoGH80CVfc//TgVreFU1l4ByX2MMr
	 557b5/UGoCkrpmWeFMF/iJ5SmTH9J4kDd96k2C1NEvkcJb4va7TPElOr74upCA5h9T
	 Xt/pTOOA7dAdRUQskrvmxCt4FLvm5TpuEfSdBEcUM+jzbhMt+SF15k25j2LPvXkBWo
	 JbUxuI5wQxI7CzuFM4GA/Dw4Ndozoc2bFWNYkOdYr91RXtyP2LattckX5dotigsviY
	 IGiLJaugirsfQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 03E9860081;
	Mon, 16 Nov 2026 01:16:56 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 08/13] selftests: netfilter: nf_queue: drop the no-op loop initializer
Date: Mon, 16 Nov 2026 01:16:07 +0100
Message-ID: <20261116001612.2806263-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116001612.2806263-1-pablo@netfilter.org>
References: <20261116001612.2806263-1-pablo@netfilter.org>
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

From: Sasha Levin <sashal@kernel.org>

The out-of-order verdict loop starts with "for (ooo_count; ...", and
clang warns about the unused expression:

  nf_queue.c:354:10: warning: expression result unused [-Wunused-value]

Leave the initializer empty.

Signed-off-by: Sasha Levin <sashal@kernel.org>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/net/netfilter/nf_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/nf_queue.c b/tools/testing/selftests/net/netfilter/nf_queue.c
index cca6c3cfa9e4..bc0b2f601a0a 100644
--- a/tools/testing/selftests/net/netfilter/nf_queue.c
+++ b/tools/testing/selftests/net/netfilter/nf_queue.c
@@ -351,7 +351,7 @@ static int mainloop(void)
 		if (opts.out_of_order) {
 			ooo_ids[ooo_count] = id;
 			if (ooo_count >= 15) {
-				for (ooo_count; ooo_count >= 0; ooo_count--) {
+				for (; ooo_count >= 0; ooo_count--) {
 					nlh = nfq_build_verdict(buf, ooo_ids[ooo_count],
 								opts.queue_num, opts.verdict);
 					if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-- 
2.47.3

