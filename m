Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEF0221F34
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2025 11:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749729154; cv=none; b=ASOB+u9YQ+TVog/ufXEAH2OHrV+FHju0O3x9nkWueQIdJGEJnuLpBz6Ep2toPSWRn9WLEN8lmHZcqedkKqBoEq8s4/tfaTHGj1ApITbVEohPmul4s+9q8cpoVfSP3d5CilGS+Z0fXLGhtPwc8Piqi+Z+dWBUlubLlEdRXGbbKOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749729154; c=relaxed/simple;
	bh=rblAFFMtzv3ju70Heznr29c3qLSzGF/mnKiU+D3tDwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=esyf1mm7gR/8noQJtVrd4FKLi5Lew6TbkYmwSpePuUJejkA7GonwTF/5smR4I62mb58F8vGr4meibHzhjQfw9PDFypEnEDnQIBsC3i417U2fkbMaJCRduoBlcRosMthOtVRT5wAzAPaOPjcacu5PnmkJEMTyQnc2cnWLK0AC0i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Tc9hgsWk; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Tc9hgsWk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ItTgJ+jRiQWjbWAih6bdgecuRLuRYTKYPyMu+bJQMKs=; b=Tc9hgsWkgQq0bol3Iiq0hg3h4n
	cKqdlJuJ97ySVIG8IQGU5vzMcrzShlm87d+mwlZ4MkT5jSwcOVFOQNRmuPeeZ/mDW/9ooXVM3Gl/X
	2fPveA2xJUZ1hQ/Hyng2SmQg/mE2pqiBXd0HvgDIMZmbZB+R3mSVC6hDnA0iEHVPXFgwxqFlF3f5P
	7cw4dZc0jJMvgMLTtx873jBJXY56DcRqmFL/xvSoDuG7THWJTuRzFnrGHyBoF7jWaHnKxtmZ1q/7l
	uYCVMhVd0s0XWfuBK0XbCon1Y40fbR6N4qxZiYkb+G2brakQMPzonKmUL2U3Ctemh06vwKt+sHxKI
	QuR6hSdw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uPgTu-000000006GB-2zSC;
	Thu, 12 Jun 2025 13:52:30 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 4/7] json: Dump flowtable hook spec only if present
Date: Thu, 12 Jun 2025 13:52:15 +0200
Message-ID: <20250612115218.4066-5-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250612115218.4066-1-phil@nwl.cc>
References: <20250612115218.4066-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If there is no priority.expr set, assume hook.num is bogus, too.

While this is fixing JSON output, it's hard to tell what commit this is
actually fixing: Before commit 627c451b23513 ("src: allow variables in
the chain priority specification"), there was no way to detect
flowtables missing hook specs (e.g. when printing flowtable delete
monitor event).

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/json.c                                 | 22 ++++++++++++++--------
 tests/monitor/testcases/flowtable-simple.t |  2 +-
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/src/json.c b/src/json.c
index a46aed279167b..5bd5daf3f7fa6 100644
--- a/src/json.c
+++ b/src/json.c
@@ -493,18 +493,24 @@ static json_t *flowtable_print_json(const struct flowtable *ftable)
 	json_t *root, *devs = NULL;
 	int i, priority = 0;
 
+	root = nft_json_pack("{s:s, s:s, s:s, s:I}",
+			"family", family2str(ftable->handle.family),
+			"name", ftable->handle.flowtable.name,
+			"table", ftable->handle.table.name,
+			"handle", ftable->handle.handle.id);
+
 	if (ftable->priority.expr) {
+		json_t *tmp;
+
 		mpz_export_data(&priority, ftable->priority.expr->value,
 				BYTEORDER_HOST_ENDIAN, sizeof(int));
-	}
 
-	root = nft_json_pack("{s:s, s:s, s:s, s:I, s:s, s:i}",
-			"family", family2str(ftable->handle.family),
-			"name", ftable->handle.flowtable.name,
-			"table", ftable->handle.table.name,
-			"handle", ftable->handle.handle.id,
-			"hook", hooknum2str(NFPROTO_NETDEV, ftable->hook.num),
-			"prio", priority);
+		tmp = nft_json_pack("{s:s, s:i}",
+				    "hook", hooknum2str(NFPROTO_NETDEV,
+							ftable->hook.num),
+				    "prio", priority);
+		json_object_update_new(root, tmp);
+	}
 
 	for (i = 0; i < ftable->dev_array_len; i++) {
 		const char *dev = ftable->dev_array[i];
diff --git a/tests/monitor/testcases/flowtable-simple.t b/tests/monitor/testcases/flowtable-simple.t
index df8eccbd91e0a..b373cca2e0d61 100644
--- a/tests/monitor/testcases/flowtable-simple.t
+++ b/tests/monitor/testcases/flowtable-simple.t
@@ -7,4 +7,4 @@ J {"add": {"flowtable": {"family": "ip", "name": "ft", "table": "t", "handle": 0
 
 I delete flowtable ip t ft
 O -
-J {"delete": {"flowtable": {"family": "ip", "name": "ft", "table": "t", "handle": 0, "hook": "ingress", "prio": 0, "dev": "lo"}}}
+J {"delete": {"flowtable": {"family": "ip", "name": "ft", "table": "t", "handle": 0}}}
-- 
2.49.0

