Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D8C3D3CE4;
	Fri,  3 Jul 2026 12:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783083454; cv=none; b=NvET5Ce+sjWaoDveNItrthTUkXc1Uzwf00PDM+fAXEwCLb7m90UA7Mvyh1OypkNGMvgIqe1w9n/JfpMsNRHpFLZ7KNVQjXcNJ1H7u9E63Yf1q/5Y9UbBb6JfWCROSpnT/zDh8Sxc/C7hjSyenKU1ZFvd+lzkavBSFu0et1sjAhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783083454; c=relaxed/simple;
	bh=7Pqta0Hh0CAqZJGY1jS3W+iHh/H7rxzyjGRN7IjovJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/opNTNZXfW6XPut/YBI0qrUBdEsKbXdSXbJrlH2INtwI2es+zaHDRAPrlD8ahunORtcCdeyst0ZTvIz2rfRt/FLgmDY+K4nDzk8TnW/GGKwpQupZodDWYaHMF+laYcFPTwfDu5BUQPDj3Q2HfDWVhSB5EzJ7AziD2024g3Nul4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5FEDA60687; Fri, 03 Jul 2026 14:57:31 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 4/9] netfilter: nfnetlink_cthelper: cap to maximum number of expectation per master on updates
Date: Fri,  3 Jul 2026 14:57:04 +0200
Message-ID: <20260703125709.16493-5-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260703125709.16493-1-fw@strlen.de>
References: <20260703125709.16493-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

Really cap it to NF_CT_EXPECT_MAX_CNT (255) on updates.

The commit ("netfilter: nfnetlink_cthelper: cap to maximum number of
expectation per master") only covers creation of helpers, not updates.

Fixes: 397c8300972f ("netfilter: nf_conntrack_helper: cap maximum number of expectation at helper registration")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_cthelper.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 2cbcca9110db..f062ac210343 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -316,6 +316,8 @@ nfnl_cthelper_update_policy_one(const struct nf_conntrack_expect_policy *policy,
 
 	new_policy->max_expected =
 		ntohl(nla_get_be32(tb[NFCTH_POLICY_EXPECT_MAX]));
+	if (!new_policy->max_expected)
+		new_policy->max_expected = NF_CT_EXPECT_MAX_CNT;
 	if (new_policy->max_expected > NF_CT_EXPECT_MAX_CNT)
 		return -EINVAL;
 
-- 
2.54.0

