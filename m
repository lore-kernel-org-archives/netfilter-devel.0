Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F1D39A047
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Aug 2026 23:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786578710; cv=none; b=pp6dpa6SlYSlPpRTzCpkG1N52RXikQ/3D/7o8tTZewv9SHPmAyPZ92ttO5d1a0EY3Db2iChux7iVzWYuIzZL0S402X5iO4xuw/YBUOawxpsCDK1s1Y5nBYsO/uWyw9wuPaOqHloKi94MlqF2rQVWAOK+1j2NLYd9EdPGCHSo1b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786578710; c=relaxed/simple;
	bh=aZ9c5EVb0FvRE9hxrxr7I5oBG5xd5Y8IDqb9Z+9ocEg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=VuFhTWSp5pu8gSjjnlq8BvvYy2MoH5AzPCbf6Iy3o6q2gqVgbjp95muRFKU/isOGrcuRsHJ9OWdN5b12ydfakhWOqYaw6DaLoXodOmMmOTfX/Ewd7tleD0XNaCGbueANT45qa3otHHkEy2qq7oFVzh+DA2WWlRbAqNVkju+sNSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vs0df7pX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vs0df7pX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786578705;
	bh=fLLVw5bvg7OsL8GbtxX7iMolgjuTNMiI5sGWxuvvGpA=;
	h=From:To:Subject:Date:From;
	b=vs0df7pX5jptQGuSO9Z48d3qC+ZzCsjO/3iWiWiCUf/wze8L2XRSCf9oEKycHwAmm
	 Z9ZThFSSQXQn9f8UB6F36OnpYbpWxJaGF9rOX/ynP38TDPJC37BXxK0687YvKRjDTs
	 AAUFEYQFDMerAGabTtRymOsEkNr++HvpHi9CdPxJgLvU11d4EuxwdwF/z432XU0Prr
	 YnVuYOroD0t1mgy3MUiqOC6LrW1z0/Te/71S7wGWYFMAQM71Bmrzj7wIGZb3f7hUm7
	 ffpm+exhyJHogb5c3bJ1rgeN8eaYrrg7q9cf58TsFKxdIP5wM42Sq0173H2E3WoSHy
	 J4Hb6ANWHox1w==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C7C466005D
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 01:51:45 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_tables: move hardware offload step after building the chain blob
Date: Thu, 13 Aug 2026 01:51:42 +0200
Message-ID: <20260812235142.1058409-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allocate the chain blob before the ruleset offload to reduce chances of
entering an inconsistent state where the offloaded ruleset in the nic
and the software ruleset differ.

Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9b6050f100d0..7c33b523f678 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10972,10 +10972,6 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		return -EAGAIN;
 	}
 
-	err = nft_flow_rule_offload_commit(net);
-	if (err < 0)
-		return err;
-
 	/* 1.  Allocate space for next generation rules_gen_X[] */
 	list_for_each_entry_safe(trans, next, &nft_net->commit_list, list) {
 		struct nft_table *table = trans->table;
@@ -11000,6 +10996,16 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		}
 	}
 
+	/* must be last, so audit and chain blob set up does not leave hardware
+	 * in consistent state.
+	 */
+	err = nft_flow_rule_offload_commit(net);
+	if (err < 0) {
+		nf_tables_commit_chain_prepare_cancel(net);
+		nf_tables_commit_audit_free(&adl);
+		return err;
+	}
+
 	/* step 2.  Make rules_gen_X visible to packet path */
 	nft_set_commit_update(&ctx, nft_net);
 
-- 
2.47.3

