Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FDDE55A
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Oct 2025 11:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759835202; cv=none; b=gOk6lf/wNeKFrJqOTaQxleQTmXRvvphtRF1Mkkui7JWtw1kkVBYBpwEHpr610fol623VMonI0Pb5Ciktg9BhfT9wkE7G3qhauVNgq034dyYJxz10pgvmL+rZ7UoZuPyXKvIsgkldJm9XFBb6hN6YCi4LQEGgITcInj5uZV4vhi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759835202; c=relaxed/simple;
	bh=gGYtl4qQ23bvxONBhdSaBMHPKZgaZYZQi6G25nYu2cU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EEpjQypoYsJPS7fev+0DIjNf5X0+t+NvzeMSamRU6rZ0JdjBm83grdIxOS/2z83JAjB7NXUGJUtaQ8HWRedGJk6wM+8y1Lc9Y+DaSWDikLcEbacjR4ohGR0c2SxVVaILP/2MqB5vLYR4izgcagLhAg6QtStWpYlfv0mN28YUsiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B28756042E; Tue,  7 Oct 2025 13:06:38 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] src: tunnel: handle tunnel delete command
Date: Tue,  7 Oct 2025 13:06:31 +0200
Message-ID: <20251007110634.5143-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'delete tunnel foo bar' causes nft to bug out.

Fixes: 35d9c77c5745 ("src: add tunnel template support")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 322e91acf625..a5cc41819198 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -6134,6 +6134,9 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SYNPROXY:
 		obj_del_cache(ctx, cmd, NFT_OBJECT_SYNPROXY);
 		return 0;
+	case CMD_OBJ_TUNNEL:
+		obj_del_cache(ctx, cmd, NFT_OBJECT_TUNNEL);
+		return 0;
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
-- 
2.49.1

