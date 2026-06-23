Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE46369D65
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2026 05:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782193604; cv=none; b=sWop4ruehmPtYFK6iXX4MAIiVZRsK4S+Hi4xkb6wJZeR5i/fXN5CS42itTG/bg0TglwVabYvaNONZSa6qp6ErBGDarafkWvxFk+0tZzoiGUu37LJ08SNUrtPDErjDppi3WQmjDVBWjmItZd02CzATN/4Wl8Lji+vjl9hIEQF654=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782193604; c=relaxed/simple;
	bh=thxankseAyvoCnZfzBzW+4sqmtHFw2hSASAWtisq7RE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SXbY86lWE+O8qpX6bfDxnHU/TsLsZhzUA67/JE5zeD07ucKmvLLUU/mGM80uNRS33IYW74uuAY5GSqA5tGVjpsJl/Hx9o09nLXtFjp+l7N2NhoW0mvwh126y3hPhF6MNjshoeCK51ejiDjxMsVkMzt1WoUsRDuNdV8tMXPmOj34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Vt0KiXo9; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Vt0KiXo9"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 18584605A3
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2026 07:46:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782193601;
	bh=HzRuzPeA6yK+qaJ23cYFaU6R3YWkc8pLHMEQWYD6Bmo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Vt0KiXo9mOoJ0CO+FUIKxG6z1sbqWQfQ6Bx2Th6zxq7PREEv913na3XnMRZwQ8OVm
	 VEMOdhOawPTj9u5eQ2aWsEGyWXcW4hPfqLXlqhJMolwzzpzHjZH8y2H47ZlWZF5/0D
	 h7zmail57ZyNrZqZcIS8r3qurv2D1Amb6bJ1uBAlU0Zq2P7bPdkbnvIM2if1Cc9sO+
	 NhDjDzSRr6F6E0BzQ0hGYY3eRrWLCtEmW5tRsHmJJMTfbU0oYvQBrlV49rnYAFoCYh
	 78xO6fcjdAo2SsluqzmqPNsjkh9Mtp+Swqy3GcyFi/78kZPOja81MLRsU90kQi0fK+
	 SCJB5BHpjJ/3Q==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v1 3/4] netfilter: nf_conntrack_expect: run expectation eviction with no helper
Date: Tue, 23 Jun 2026 07:46:34 +0200
Message-ID: <20260623054635.335065-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260623054635.335065-1-pablo@netfilter.org>
References: <20260623054635.335065-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Run expectation eviction if no helper is specified to deal with the
nft_ct expectation support.

Cap the maximum expectation limit per master conntrack to
NF_CT_EXPECT_MAX_CNT (255).

Fixes: 857b46027d6f ("netfilter: nft_ct: add ct expectations support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v1: resend to let sashiko pick in with this batch.

 net/netfilter/nf_conntrack_expect.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 9454913e1b33..113bb1cb1683 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -499,6 +499,13 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect,
 		if (p->max_expected &&
 		    master_help->expecting[expect->class] >= p->max_expected)
 			evict_oldest_expect(master_help, expect, p);
+	} else {
+		const struct nf_conntrack_expect_policy default_exp_policy = {
+			.max_expected = NF_CT_EXPECT_MAX_CNT,
+		};
+
+		if (master_help->expecting[expect->class] >= default_exp_policy.max_expected)
+			evict_oldest_expect(master_help, expect, &default_exp_policy);
 	}
 
 	cnet = nf_ct_pernet(net);
-- 
2.47.3

