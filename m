Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366402E11C6
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Jun 2025 14:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749825983; cv=none; b=pjG4Nz3z7DSBnIcx1SxKOnd0BxTIK7oZHNN0K+EEKPAR6950NzMbjdf5i9nXWotDVHQg0wgBVmliYEuvJnXtazLj7gsScvudoiiBE+yZmbGWr4c+nOdaSVBx3IClG1vEn5dHyirFM4N8C2eA5UITDKrqwYwiQAoWkzJMLPnnlw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749825983; c=relaxed/simple;
	bh=hoVPSLM9H/QWCsiXYDb1XYnVXpG4amCjApc8dwH8/Jc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aYQ0yzhyUx7sN02Idk7MqJj9Y4Cu5NlaOvIqv7FzWjGJNGr/1IxjTVFdpZrp7p2fJkZMttQSKkGGesd5iXWwTKuBhAWJrZ/kQGJ66mgQC3darHTVubcMh5kZCqDT181ehDIvp+ZFXpsXshZOf+9qj9tdzDmF2TaRuwbA31skK3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 04D74612C3; Fri, 13 Jun 2025 16:46:18 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evalute: don't BUG on unexpected base datatype
Date: Fri, 13 Jun 2025 16:46:06 +0200
Message-ID: <20250613144612.67704-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Included bogo will cause a crash but this is the evaluation
stage where we can just emit an error instead.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 I wonder if we should just replace all BUGs in evaluate.c
 with expr_error() calls, it avoids constant whack-a-mole.

 src/evaluate.c                                        |  3 ++-
 .../bogons/nft-f/invalid_basetype_verdict_assert      | 11 +++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/invalid_basetype_verdict_assert

diff --git a/src/evaluate.c b/src/evaluate.c
index 9c7f23cb080e..de054f82d55f 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -482,7 +482,8 @@ static int expr_evaluate_value(struct eval_ctx *ctx, struct expr **expr)
 			return -1;
 		break;
 	default:
-		BUG("invalid basetype %s\n", expr_basetype(*expr)->name);
+		return expr_error(ctx->msgs, *expr, "Unexpected basetype %s",
+				  expr_basetype(*expr)->name);
 	}
 	return 0;
 }
diff --git a/tests/shell/testcases/bogons/nft-f/invalid_basetype_verdict_assert b/tests/shell/testcases/bogons/nft-f/invalid_basetype_verdict_assert
new file mode 100644
index 000000000000..f85ce7fe342c
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/invalid_basetype_verdict_assert
@@ -0,0 +1,11 @@
+table ip t {
+	map m {
+		type ipv4_addr . inet_service : ipv4_addr .  verdict
+		elements = { 10.0.0.1 . 42 : 10.1.1.1 . 0 }
+	}
+
+	chain c {
+		type nat hook prerouting priority dstnat; policy accept;
+		dnat ip to ip saddr . tcp dport map @m
+	}
+}
-- 
2.49.0

