Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59B9E194A51
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Nov 2024 12:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731932489; cv=none; b=sO4DuOw84/J0BbttadYJ2crMq/RPPjIi/+XBoN60rds9jlVphWZnlauw8zjNNtKgOcngdU9HOHqWO0svX2uRHlkLs9HJTDDIkByNW3njwrCnA5CPlaLA6DXZQvXCZpKWBuFqO2fo1f+Vdo/nUns3LVqOtLtbxMxpsw5+CWIxjlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731932489; c=relaxed/simple;
	bh=106UcuAqbYQx/4gFyDR/YXr3SMwLDwaeWGaSGklbqas=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=H4Cvo1gcGTETNW3zWgwBrnXWAWo/gOIEAgbnGjWXiyjJwViJsCb/Iy29dzqoz1MLPkKhrIUTe95I+DlSXS3z+VnmdfAcUbziNCGQRPZIYnGctu52EMqN8Tqo/8apqabKOURU78sdN9vmkh7oHg9caSgaa6eLxK9PoUZj1L2prSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] optimize: compare expression length
Date: Mon, 18 Nov 2024 13:21:14 +0100
Message-Id: <20241118122114.178991-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

do not merge raw payload expressions with different length.

Other expression rely on key comparison which is assumed to have the
same length already.

Fixes: 60dcc01d6351 ("optimize: add __expr_cmp()")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c                                      |  2 ++
 .../testcases/optimizations/nomerge_raw_payload     | 13 +++++++++++++
 2 files changed, 15 insertions(+)
 create mode 100755 tests/shell/testcases/optimizations/nomerge_raw_payload

diff --git a/src/optimize.c b/src/optimize.c
index 224c6a526f56..03c8bad234e2 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -38,6 +38,8 @@ static bool __expr_cmp(const struct expr *expr_a, const struct expr *expr_b)
 {
 	if (expr_a->etype != expr_b->etype)
 		return false;
+	if (expr_a->len != expr_b->len)
+		return false;
 
 	switch (expr_a->etype) {
 	case EXPR_PAYLOAD:
diff --git a/tests/shell/testcases/optimizations/nomerge_raw_payload b/tests/shell/testcases/optimizations/nomerge_raw_payload
new file mode 100755
index 000000000000..bb8678ac2ed0
--- /dev/null
+++ b/tests/shell/testcases/optimizations/nomerge_raw_payload
@@ -0,0 +1,13 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table ip x {
+        chain y {
+                type filter hook prerouting priority raw; policy accept;
+                @th,160,32 0x02736c00 drop comment \"sl\"
+                @th,160,112 0x870697a7a6173656f03636f6d00 drop comment \"pizzaseo.com\"
+        }
+}"
+
+$NFT -o -f - <<< $RULESET
-- 
2.30.2

