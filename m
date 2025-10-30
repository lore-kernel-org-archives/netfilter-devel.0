Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2CF2D7D47;
	Thu, 30 Oct 2025 12:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761826817; cv=none; b=NooPA97du1z2RBXpiWBVirDMZjx+fmTc2Ih3x2CBdKrE3boQiQYvF9/XsTEqO+mbGvCLzxvONds4/ujOys9N8BFu6bdHYbpcoCDG2W1BSJvxNhJfmWTzAuhQJyXVsFcKqVA5/HBbJd3hihIWGOqWADGLIY+YUMTH3BfkxfTC9qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761826817; c=relaxed/simple;
	bh=KvCNMJ41WMHCtfFFtPaP89wgEn8vdWkxz03yeosUtdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nOG4nUaUGgbnCTT91At5WKxRBI5vjMTVs4N5Ba2cEBSUObcswNSQoxdOL4mJxOeWrbLcb3oj6UKJfU/w7mcCA9IP5JsGINoKiJ9L5fNXGL2XBWy00B0SEN551q/lDf6fig/cwR2mMMk2WngGYozzNQfMiZzzhV5Z3EL9SJFV/uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7015060202; Thu, 30 Oct 2025 13:20:12 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 3/3] netfilter: fix typo in nf_conntrack_l4proto.h comment
Date: Thu, 30 Oct 2025 13:19:54 +0100
Message-ID: <20251030121954.29175-4-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251030121954.29175-1-fw@strlen.de>
References: <20251030121954.29175-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "caivive (Weibiao Tu)" <cavivie@gmail.com>

In the comment for nf_conntrack_l4proto.h, the word "nfnetink" was
incorrectly spelled. It has been corrected to "nfnetlink".

Fixes a typo to enhance readability and ensure consistency.

Signed-off-by: caivive (Weibiao Tu) <cavivie@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_l4proto.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 6929f8daf1ed..cd5020835a6d 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -30,7 +30,7 @@ struct nf_conntrack_l4proto {
 	/* called by gc worker if table is full */
 	bool (*can_early_drop)(const struct nf_conn *ct);
 
-	/* convert protoinfo to nfnetink attributes */
+	/* convert protoinfo to nfnetlink attributes */
 	int (*to_nlattr)(struct sk_buff *skb, struct nlattr *nla,
 			 struct nf_conn *ct, bool destroy);
 
-- 
2.51.0

