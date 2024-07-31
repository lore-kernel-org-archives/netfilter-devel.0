Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2C21B140E
	for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2024 17:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722445768; cv=none; b=k5WC86JmPj7B/1yGePMlryQrHtxQeMff12Yidpm+U4q3VJtwi9vHIyQO6shUExP312tdPm1yDxMH44X7Xea8VGscQP+6lN7pSbUH5/bOXMYei3+/NfcVSVeBnjEmgMaWN/9YuYvg6B3daUyd47RSuMRctMN/nzDaNkaaOMZgoWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722445768; c=relaxed/simple;
	bh=YU7xWxU7pEKRXoV41lQqGBIXASqknmZFm+66wOFtHBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZM9T5if0PplutgBnditbAu2jNNF8wHeL4kMsjuZ1R7+EiJVUcDYTItRjR7rWWEoqxGfLCMU6f/d9pMNRzZ5HM+iKNIpr1z+onKMsZ/ATU5cxh/zCeJlLJlI3J5y4mMCVw+zOkexU1zC+5FnO5cGIqFl5WtqsVo+6c0vP+mDbhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sZCpI-0006ya-Sg; Wed, 31 Jul 2024 19:09:24 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v2 4/5] src: add egress support for 'list hooks'
Date: Wed, 31 Jul 2024 18:51:04 +0200
Message-ID: <20240731165111.32166-5-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
In-Reply-To: <20240731165111.32166-1-fw@strlen.de>
References: <20240731165111.32166-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This was missing:  Also include the egress hooks when listing
the netdev family (or unspec).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/mnl.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 1b424e427124..3cacb47e7242 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -2529,11 +2529,12 @@ static int mnl_nft_dump_nf_arp(struct netlink_ctx *ctx, int family,
 static int mnl_nft_dump_nf_netdev(struct netlink_ctx *ctx, int family,
 				  const char *devname, struct list_head *hook_list)
 {
-	int err;
+	int err1, err2;
 
-	err = __mnl_nft_dump_nf_hooks(ctx, family, NFPROTO_NETDEV, NF_NETDEV_INGRESS, devname, hook_list);
+	err1 = __mnl_nft_dump_nf_hooks(ctx, family, NFPROTO_NETDEV, NF_NETDEV_INGRESS, devname, hook_list);
+	err2 = __mnl_nft_dump_nf_hooks(ctx, family, NFPROTO_NETDEV, NF_NETDEV_EGRESS, devname, hook_list);
 
-	return err;
+	return err1 ? err2 : err1;
 }
 
 static void release_hook_list(struct list_head *hook_list)
-- 
2.44.2

