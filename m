Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 371E219EEAF
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2024 11:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723636291; cv=none; b=R8NIAjodMLtaPSv6fKSw/VOhu7hI7Yxt3IivSLN3m+/3AVLVfjzRykt9ChFqIe60L7uvdgMvadBRlL0NwsCBZwC2WBspiFlEV6KXaE6K5H+16YgP8Bn0VpmSIn7DNY+xZI7BmjtxwNjiXZzCqpU6J+MNpLq6vDQBi3ZCcm6K+Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723636291; c=relaxed/simple;
	bh=ST7d80eua2AeyB50EWivcYO72kqvPaYj/cabc5JRSd8=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=Fms27L5OOiu9Xs+eZlcvyi11UH2mXAlet/yY19cYUcn/6D4yNpZSgqlQrTx++ndX7jvx9X3m9rFJyjqTYkWVs0eBAt2J/jHSM3z+oGJShAQl7SBTb2GGKncPRG6atitcdHYl0X9q16JK2FuxZOyJX0GFFJNGZVaQuR27ZDcQrhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 1/2] datatype: reject rate in quota statement
Date: Wed, 14 Aug 2024 13:51:21 +0200
Message-Id: <20240814115122.279041-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bail out if rate are used:

 ruleset.nft:5:77-106: Error: Wrong rate format, expecting bytes or kbytes or mbytes
 add rule netdev firewall PROTECTED_IPS update @quota_temp_before { ip daddr quota over 45000 mbytes/second } add @quota_trigger { ip daddr }
                                                                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

improve error reporting while at this.

Fixes: 6615676d825e ("src: add per-bytes limit")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: - change patch subject
    - use strndup() to fetch units in rate_parse() so limit rate does not break.

 src/datatype.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index d398a9c8c618..297c5d0409d5 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1485,14 +1485,14 @@ static struct error_record *time_unit_parse(const struct location *loc,
 struct error_record *data_unit_parse(const struct location *loc,
 				     const char *str, uint64_t *rate)
 {
-	if (strncmp(str, "bytes", strlen("bytes")) == 0)
+	if (strcmp(str, "bytes") == 0)
 		*rate = 1ULL;
-	else if (strncmp(str, "kbytes", strlen("kbytes")) == 0)
+	else if (strcmp(str, "kbytes") == 0)
 		*rate = 1024;
-	else if (strncmp(str, "mbytes", strlen("mbytes")) == 0)
+	else if (strcmp(str, "mbytes") == 0)
 		*rate = 1024 * 1024;
 	else
-		return error(loc, "Wrong rate format");
+		return error(loc, "Wrong unit format, expecting bytes, kbytes or mbytes");
 
 	return NULL;
 }
@@ -1500,14 +1500,20 @@ struct error_record *data_unit_parse(const struct location *loc,
 struct error_record *rate_parse(const struct location *loc, const char *str,
 				uint64_t *rate, uint64_t *unit)
 {
+	const char *slash, *rate_str;
 	struct error_record *erec;
-	const char *slash;
 
 	slash = strchr(str, '/');
 	if (!slash)
-		return error(loc, "wrong rate format");
+		return error(loc, "wrong rate format, expecting {bytes,kbytes,mbytes}/{second,minute,hour,day,week}");
+
+	rate_str = strndup(str, slash - str);
+	if (!rate_str)
+		memory_allocation_error();
+
+	erec = data_unit_parse(loc, rate_str, rate);
+	free_const(rate_str);
 
-	erec = data_unit_parse(loc, str, rate);
 	if (erec != NULL)
 		return erec;
 
-- 
2.30.2

