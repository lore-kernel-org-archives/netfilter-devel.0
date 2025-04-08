Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B452E1CDA0B
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Apr 2025 14:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744122143; cv=none; b=L+2vVqEb2Ntvb4SPqK/6EIgMFfz4RveQGVlYS60ZCZkbyZieTyqDwvOWgcBNw7QF5Kho7rzvmx+C56pmUxDDQw66lpmYLTK7JFHKcUPZsuqfHObbuB3LyJlxrUb+8IfmwlUsnHF9MPbN2ZqJuCR02f6RM0H/51g37b3ky5rNLC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744122143; c=relaxed/simple;
	bh=jWjQk2OExU2xYGhKX1QWTYPX9/ONEtyAZd+RkpClKsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdtAR/nMAqu1u8u36xw9oScWKTdSqNiDg5Wa23/0fh+iAfquRCv2cSdRv+Ug0g1+5XlxwZXXGXxp/ssk5XvvaW5geO8HMjqlArcPlkW7DsREq9i0yyXcLpXlqu8NNyGKk6GKOq60RIYIYBdxTyVLRC8NUvZbP7XKaE5d3upqxHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1u29qF-0002xx-RB; Tue, 08 Apr 2025 16:22:19 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v2 nftables 3/4] src: print count variable in normal set listings
Date: Tue,  8 Apr 2025 16:21:31 +0200
Message-ID: <20250408142135.23000-4-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408142135.23000-1-fw@strlen.de>
References: <20250408142135.23000-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Also print the number of allocated set elements if the set provided
an upper size limit and there is at least one element.

Example:

table ip t {
   set s {
       type ipv4_addr
       size 65535      # count 1
       flags dynamic
       counter
       elements = { 1.1.1.1 counter packets 1 bytes 11 }
   }
   ...

JSON output is unchanged as this only has informational purposes.

This change breaks tests, followup patch addresses this.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/rule.h | 2 ++
 src/netlink.c  | 3 +++
 src/rule.c     | 9 ++++++---
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 85a0d9c0b524..5c8870032472 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -321,6 +321,7 @@ void rule_stmt_insert_at(struct rule *rule, struct stmt *nstmt,
  * @refcnt:	reference count
  * @flags:	bitmask of set flags
  * @gc_int:	garbage collection interval
+ * @count:	count of kernel-allocated elements
  * @timeout:	default timeout value
  * @key:	key expression (data type, length))
  * @data:	mapping data expression
@@ -345,6 +346,7 @@ struct set {
 	unsigned int		refcnt;
 	uint32_t		flags;
 	uint32_t		gc_int;
+	uint32_t		count;
 	uint64_t		timeout;
 	struct expr		*key;
 	struct expr		*data;
diff --git a/src/netlink.c b/src/netlink.c
index 98ec3cdba996..9b197f089d40 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1129,6 +1129,9 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	if (nftnl_set_is_set(nls, NFTNL_SET_DESC_SIZE))
 		set->desc.size = nftnl_set_get_u32(nls, NFTNL_SET_DESC_SIZE);
 
+	if (nftnl_set_is_set(nls, NFTNL_SET_COUNT))
+		set->count = nftnl_set_get_u32(nls, NFTNL_SET_COUNT);
+
 	if (nftnl_set_is_set(nls, NFTNL_SET_DESC_CONCAT)) {
 		uint32_t len = NFT_REG32_COUNT;
 		const uint8_t *data;
diff --git a/src/rule.c b/src/rule.c
index 80315837baf0..6af8d57eddb6 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -335,10 +335,13 @@ static void set_print_declaration(const struct set *set,
 		}
 
 		if (set->desc.size > 0) {
-			nft_print(octx, "%s%ssize %u%s",
+			nft_print(octx, "%s%ssize %u",
 				  opts->tab, opts->tab,
-				  set->desc.size,
-				  opts->stmt_separator);
+				  set->desc.size);
+			if (set->count > 0)
+				nft_print(octx, "%s# count %u", opts->tab,
+					  set->count);
+			nft_print(octx, "%s", opts->stmt_separator);
 		}
 	}
 
-- 
2.49.0

