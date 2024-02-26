Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07F1812C81A
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Feb 2024 17:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708967496; cv=none; b=Whel6Ke6GBFPSXptaW6H7g5tAqZjYxGdcZW9fJYn55EC0d1hDbN/vEZerDXJNpYT3likshVUvVyd2tPfZFGKfcByaQ5nvM8YYkOnmF9LjrtB1q2ZrpP4poWhXw9xUIDH/mruCCGFkktQxZ9c/R+o5niTBUfvTphVjjiYQtFsqwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708967496; c=relaxed/simple;
	bh=7l39MpecHDtufW9ZjwULicpR/xbQ8ffhx8kcOvWYb08=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=sHOdytsh3nAEV3IlG3B+u64YBJax4dMCYyjeN+pC6TS6Ww7hJKdr2qil+6S2cCD6cnLxGtnEuv98YncXIVBoF2yWAeGP+mtql6vBpSLL0dvw4WDiQgVvHd59xmLf0IFdJedfE1Jo0UZbuUX71GI77zpTsc7hi+GpzFrYn4ZjytM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl 1/3] expr: immediate: check for chain attribute to release chain name
Date: Mon, 26 Feb 2024 18:11:25 +0100
Message-Id: <20240226171127.256640-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Check for chain name attribute to release chain name, for consistency
with other existing attributes.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/data_reg.h   |  2 --
 src/expr/data_reg.c  | 12 ------------
 src/expr/immediate.c |  4 ++--
 3 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/include/data_reg.h b/include/data_reg.h
index 5ee7080daef0..946354dc9881 100644
--- a/include/data_reg.h
+++ b/include/data_reg.h
@@ -35,8 +35,6 @@ int nftnl_data_reg_snprintf(char *buf, size_t size,
 struct nlattr;
 
 int nftnl_parse_data(union nftnl_data_reg *data, struct nlattr *attr, int *type);
-void nftnl_free_verdict(const union nftnl_data_reg *data);
-
 int nftnl_data_cpy(union nftnl_data_reg *dreg, const void *src, uint32_t len);
 
 #endif
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 690b23dbad6c..d2ccf2e8dc68 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -206,18 +206,6 @@ int nftnl_parse_data(union nftnl_data_reg *data, struct nlattr *attr, int *type)
 	return ret;
 }
 
-void nftnl_free_verdict(const union nftnl_data_reg *data)
-{
-	switch(data->verdict) {
-	case NFT_JUMP:
-	case NFT_GOTO:
-		xfree(data->chain);
-		break;
-	default:
-		break;
-	}
-}
-
 int nftnl_data_cpy(union nftnl_data_reg *dreg, const void *src, uint32_t len)
 {
 	int ret = 0;
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index f56aa8fd6999..acc01a10154e 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -214,8 +214,8 @@ static void nftnl_expr_immediate_free(const struct nftnl_expr *e)
 {
 	struct nftnl_expr_immediate *imm = nftnl_expr_data(e);
 
-	if (e->flags & (1 << NFTNL_EXPR_IMM_VERDICT))
-		nftnl_free_verdict(&imm->data);
+	if (e->flags & (1 << NFTNL_EXPR_IMM_CHAIN))
+		xfree(imm->data.chain);
 }
 
 struct expr_ops expr_ops_immediate = {
-- 
2.30.2

