Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5691F7902
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Apr 2025 23:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743635433; cv=none; b=rxorInctNfRE/sI0dDdyfD6Jxw/f+x7koEx3cOurMEPYWdVu2cnrs8n4Dtq3tJ/9GxKInUs8K1bMCzBgGMY3ABs0Euh8/PuYlKHDdX/g2Y4ll7EEHRRqwuNzuZHvL4q7iYVOCNn3uuYmg/ObYcS8cZTqK41BWubNzs4LGOL5LHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743635433; c=relaxed/simple;
	bh=D0Zz+9b3gdcys1ZHHV/5ENYDXrSV63rSUMmBTgbJZbc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JPFMQUB8tv6P115EGphZFFkfkcv1i6L8SH+CaMkBftLWn92UODnxm3eIYMENjUv4r1cBGp/LnrWJmGFhRQuP6zuD1Wl95c1e3O8LmBPbR+WYif1GJYaRPKoeQ37aTnv7aLxwMdufKbpbbf5PktpM5pA2yJXzIIK7Jd5+jdEg8T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1u07E4-0007MK-NL; Thu, 03 Apr 2025 01:10:28 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: bail out if ct saddr/daddr dependency cannot be inserted
Date: Thu,  3 Apr 2025 01:09:22 +0200
Message-ID: <20250402230930.28757-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If we have an incomplete rule like "ct original saddr" in inet
family, this function generates an error because it can't determine the required protocol
dependency, hinting at missing ip/ip6 keyword.

We should not go on in this case to avoid a redundant followup error:

nft add rule inet f c ct original saddr 1.2.3.4
Error: cannot determine ip protocol version, use "ip saddr" or "ip6 saddr" instead
add rule inet f c ct original saddr 1.2.3.4
                  ^^^^^^^^^^^^^^^^^
Error: Could not parse symbolic invalid expression
add rule inet f c ct original saddr 1.2.3.4

After this change only the first error is shown.

Fixes: 2b29ea5f3c3e ("src: ct: add eval part to inject dependencies for ct saddr/daddr")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 0c8af09492d1..d6bb18ba2aa0 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1190,7 +1190,8 @@ static int expr_evaluate_ct(struct eval_ctx *ctx, struct expr **expr)
 	switch (ct->ct.key) {
 	case NFT_CT_SRC:
 	case NFT_CT_DST:
-		ct_gen_nh_dependency(ctx, ct);
+		if (ct_gen_nh_dependency(ctx, ct) < 0)
+			return -1;
 		break;
 	case NFT_CT_SRC_IP:
 	case NFT_CT_DST_IP:
-- 
2.49.0

