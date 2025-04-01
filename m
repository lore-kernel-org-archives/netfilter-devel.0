Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15141204F71
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Apr 2025 14:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743517796; cv=none; b=HI7RojBAMtGHjn0rh1/VGkXyv6LU/kYqGt7gwd2vdLUsJgN3XgWhZ1NjSMVPfqOiUI2fXlmCGuMewL59AwSwmHL88OA8/WgeAiyIQZgNFCh/n/Y4qiKYXMiVzM+ZDQATAmEJk7110pl0+cW+Av3bbRRUcJahTHuZmGbdSuufbwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743517796; c=relaxed/simple;
	bh=86mWVheg+/qRDhb9I4bO4R2YgOSffb/bRHn+VO0OAFI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HtNAzzk0SMkDHsI8Uo5hUQ/DyjUMPq54VrUjHcOqB0+4L31aNP6zHLmGN98SeWyDqMdIKkeM0maOfD5P4pNdeJQUawE8jNC7xviifbN75QbEYTF87fj1Kx7GBe/OxlQwcibvg5vvY62+Egxf9YLauPVAcI3+0F66HszjnwDribo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tzcci-00088W-2I; Tue, 01 Apr 2025 16:29:52 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] cache: don't crash when filter is NULL
Date: Tue,  1 Apr 2025 16:29:14 +0200
Message-ID: <20250401142917.11171-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

a delete request will cause a crash in obj_cache_dump, move the deref
into the filter block.

Fixes: dbff26bfba83 ("cache: consolidate reset command")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/cache.c                                                 | 6 ++++--
 .../testcases/bogons/nft-f/delete_nonexistant_object_crash  | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/delete_nonexistant_object_crash

diff --git a/src/cache.c b/src/cache.c
index b75a5bf3283c..c0d96bd14a80 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -902,6 +902,7 @@ static struct nftnl_obj_list *obj_cache_dump(struct netlink_ctx *ctx,
 	int family = NFPROTO_UNSPEC;
 	const char *table = NULL;
 	const char *obj = NULL;
+	bool reset = false;
 	bool dump = true;
 
 	if (filter) {
@@ -914,9 +915,10 @@ static struct nftnl_obj_list *obj_cache_dump(struct netlink_ctx *ctx,
 		}
 		if (filter->list.obj_type)
 			type = filter->list.obj_type;
+
+		reset = filter->reset.obj;
 	}
-	obj_list = mnl_nft_obj_dump(ctx, family, table, obj, type, dump,
-				    filter->reset.obj);
+	obj_list = mnl_nft_obj_dump(ctx, family, table, obj, type, dump, reset);
 	if (!obj_list) {
                 if (errno == EINTR)
 			return NULL;
diff --git a/tests/shell/testcases/bogons/nft-f/delete_nonexistant_object_crash b/tests/shell/testcases/bogons/nft-f/delete_nonexistant_object_crash
new file mode 100644
index 000000000000..c369dec8c07d
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/delete_nonexistant_object_crash
@@ -0,0 +1 @@
+delete quota a b
-- 
2.49.0

