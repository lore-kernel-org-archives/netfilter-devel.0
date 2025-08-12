Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90E192E7655;
	Tue, 12 Aug 2025 10:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754994039; cv=none; b=b9rjLwF9OZT/x2UaiRpQRJvCzXhu80y6SKQYV6AHfhvfcWmcoLsCbpNXvV4J8lMed51VEIict0NADJRuHNe2CtAYCHf2gEomZ0RNSMRx4csP8KqBqYaQkpBzza9VhnguP0kghOvKE/0L8zXb/vbpAgQhnEZP3rgnbqgUmc6YI9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754994039; c=relaxed/simple;
	bh=fnjkTMpHaMrjN4OxTc0IQuRSEUImxanXcaUE83Nr2sM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P5Z2Zhtu2ui5N91cAI6D4FJe018vtJad/k5ZAsbaR5vUtonPDHH/Ius3ONUFuglNYmTq3HyGxa/vOs7R6SdaRIH5cPsTEWbMyb4dF//qA7fAJ4ufX/wdJHZ0BvP68NPtBaBxRqG6z32FxgZ+9W/EHZYSqFDSQQHjCCsL86839oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4c1Rmc0VDzz9sSv;
	Tue, 12 Aug 2025 11:59:12 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uCvqS6JyTlcz; Tue, 12 Aug 2025 11:59:11 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4c1Rmb6nyZz9sSt;
	Tue, 12 Aug 2025 11:59:11 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id D261F8B764;
	Tue, 12 Aug 2025 11:59:11 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id oAUcpft48cYK; Tue, 12 Aug 2025 11:59:11 +0200 (CEST)
Received: from PO20335.idsi0.si.c-s.fr (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 3C8508B763;
	Tue, 12 Aug 2025 11:59:11 +0200 (CEST)
From: Christophe Leroy <christophe.leroy@csgroup.eu>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next] netfilter: nft_payload: Use csum_replace4() instead of opencoding
Date: Tue, 12 Aug 2025 11:58:43 +0200
Message-ID: <e98467a942d65d2dc45dcf8ff809b43d4a3769eb.1754992552.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754992724; l=787; i=christophe.leroy@csgroup.eu; s=20211009; h=from:subject:message-id; bh=fnjkTMpHaMrjN4OxTc0IQuRSEUImxanXcaUE83Nr2sM=; b=65Dcm5lghOX/0eg2EkZqziHU3u86WpdytVlO74lR4bnX8+rMJzqv8sQwdWxk96qp76uPwnPWf /ze/vZFHNzxCDPfEWcbEqJwYux904Vr/Ui0bD376y7eFPTZybNVMbld
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit

Open coded calculation can be avoided and replaced by the
equivalent csum_replace4() in nft_csum_replace().

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 net/netfilter/nft_payload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 7dfc5343dae46..e279b54ed7116 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -684,7 +684,7 @@ static const struct nft_expr_ops nft_payload_inner_ops = {
 
 static inline void nft_csum_replace(__sum16 *sum, __wsum fsum, __wsum tsum)
 {
-	*sum = csum_fold(csum_add(csum_sub(~csum_unfold(*sum), fsum), tsum));
+	csum_replace4(sum, fsum, tsum);
 	if (*sum == 0)
 		*sum = CSUM_MANGLED_0;
 }
-- 
2.49.0

