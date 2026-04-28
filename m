Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8F03E2759;
	Tue, 28 Apr 2026 09:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777370337; cv=none; b=j+TgDPEu5OkQaACxiaSLXMeKRekMwO0tlW9A6eIF71vUPNHpW/xL146tp7xCdf5SsadFF1NrfCiYfQXDFhfyLLjVa8/G0WZ4unZSzkOh5led1xlL0zhE921+DGjstA9Wj2DhQ7C8XWBAO/c0gSQ3TMF1EYkvSBr3L2kJAaROsQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777370337; c=relaxed/simple;
	bh=028gpVSnt0h4/WQhaGMCn9U2LguktmS13hyrI6Ir5yU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UrOz0n1xQdDtFtI0h7YzJgaGnhAZIiSMLB/KhnWVuVE0XtjK+HuWPBw3MweUOfdiXv2AFY1XYlKcZN+Y3PLrXJd4k35wJdLm/oqZbcUzkxRvTFm929GUYJejbS5MFoJBVH3yi40InDAkWurXv28wO4L211xm6juseIF9nfHhYX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OVxkaC2k; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OVxkaC2k"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id F235960254;
	Tue, 28 Apr 2026 11:58:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777370334;
	bh=ATsz83rZMAw5OYOOuuCL9l+aXZu+YgWCziiIs7DSmG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OVxkaC2kH5UJLZz7h0edA1yaxCawFiT/RLPtzA00q76pL+AoOSUZo9B8WUUua4w3e
	 E/9tnvN+JZApTcRpBZCZo/+no9B/92Ph0wRW9g4yNHJVyoirutow9lZ52V6yjs1CB7
	 U2l9Rxro3Q0QaAoZurJ1WxFb/+FXjx80nn0F6/6xTg2G0vvZURwku9vHgOyJ4Omd9x
	 oO6OWFFnMqUuIBUc3CQpIFgptZCYScvIDvtp5ufOe+fL8uxJ3P/fKer+cnmgBDPObo
	 23fFnTBGq+CmzJPJ/WlXQIQXL7tNrMsGdW8efd3iH9RO1CWrQWZLKbJoLzO+LUu8Bc
	 c2Nc+XvYH2XFA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 6/8] netfilter: xt_policy: fix strict mode inbound policy matching
Date: Tue, 28 Apr 2026 11:58:37 +0200
Message-ID: <20260428095840.51961-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260428095840.51961-1-pablo@netfilter.org>
References: <20260428095840.51961-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jiexun Wang <wangjiexun2025@gmail.com>

match_policy_in() walks sec_path entries from the last transform to the
first one, but strict policy matching needs to consume info->pol[] in
the same forward order as the rule layout.

Derive the strict-match policy position from the number of transforms
already consumed so that multi-element inbound rules are matched
consistently.

Fixes: c4b885139203 ("[NETFILTER]: x_tables: replace IPv4/IPv6 policy match by address family independant version")
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Jiexun Wang <wangjiexun2025@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_policy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
index cb6e8279010a..b5fa65558318 100644
--- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -63,7 +63,7 @@ match_policy_in(const struct sk_buff *skb, const struct xt_policy_info *info,
 		return 0;
 
 	for (i = sp->len - 1; i >= 0; i--) {
-		pos = strict ? i - sp->len + 1 : 0;
+		pos = strict ? sp->len - i - 1 : 0;
 		if (pos >= info->len)
 			return 0;
 		e = &info->pol[pos];
-- 
2.47.3

