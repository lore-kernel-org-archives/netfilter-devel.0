Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0EB121343;
	Wed, 17 Jan 2024 16:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705507249; cv=none; b=XXQg7sfYAHUVzExW9UQdnWNWP0pvN4TmFX6F5HWwDpZHpod2AGY9ryMzo7uIgrdmxP0Zq8aAl8Se36hR+ylN8wqlJ1X7zlvRdlU4QzMj1qlJLqM7PA5wWPd/OiNYdbZZZ+r9jCrDHBWaT5+2LbewYpmz1FFqic5DAaBm9OL2CLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705507249; c=relaxed/simple;
	bh=m4VeRz3aCUPlhzMWpHbZ+htqsl/7a4Cmez1+3l76l/g=;
	h=From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding; b=oxFKh3QsQK4QL/BpVTjARJdQ+I/iSaZSz1aT27XRJ2zcraMfn6p/8fnfsbYi9/MWphDkfc/x329xy5Oo3v9v9zyYSx1E+qNCCyJztK5AG620oNope+HH5SGnU7UHNptDKlgs/kGjmoV5vJqw/pQG2FwYL3IL9KAWjbq5KVybUIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 01/14] netfilter: nf_tables: reject invalid set policy
Date: Wed, 17 Jan 2024 17:00:17 +0100
Message-Id: <20240117160030.140264-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240117160030.140264-1-pablo@netfilter.org>
References: <20240117160030.140264-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Report -EINVAL in case userspace provides a unsupported set backend
policy.

Fixes: c50b960ccc59 ("netfilter: nf_tables: implement proper set selection")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8438a8922e4a..a90a364f5be5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5048,8 +5048,16 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	}
 
 	desc.policy = NFT_SET_POL_PERFORMANCE;
-	if (nla[NFTA_SET_POLICY] != NULL)
+	if (nla[NFTA_SET_POLICY] != NULL) {
 		desc.policy = ntohl(nla_get_be32(nla[NFTA_SET_POLICY]));
+		switch (desc.policy) {
+		case NFT_SET_POL_PERFORMANCE:
+		case NFT_SET_POL_MEMORY:
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
+	}
 
 	if (nla[NFTA_SET_DESC] != NULL) {
 		err = nf_tables_set_desc_parse(&desc, nla[NFTA_SET_DESC]);
-- 
2.30.2

