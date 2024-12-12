Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEF201D7E5F
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Dec 2024 23:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734045240; cv=none; b=VCQwBSocm1WB5QEcMs/XQaPvF+U4iXvfaSD/oCHOxEZE4QMWZZhbPDGqZCRpVGibtRU6EpZWQ7xITQMbvBgyjxmE0ybGhI7gn++XeqLWjC/lv/JHBYmjJ+VU9odF+BCZTWM+j67Tz/wb0qp0M2V732rrFaTUiyrGlpYipTue5ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734045240; c=relaxed/simple;
	bh=kppPNkM/Z1QG1rEhpqoehsDZO4jMTiILOyTehPYHols=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h/tL9jk/g8/EwUKW3RCUZC8KEuO6laKliLTR8HTIdl6lLchObjpsUnAw9qsQNMZNJY4WdRv8pna4c7A6NipdANYAZ2xStxBBlfzQW/TNm2kx2HKFooWFCQ6GUNlUZ9gU7Txau8/dfBO5bB6BkmhvXjC+Bslq/nq/91D7W9KDlSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] src: shrink line_offset in struct location to 4 bytes
Date: Fri, 13 Dec 2024 00:13:46 +0100
Message-Id: <20241212231346.181221-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241212231346.181221-1-pablo@netfilter.org>
References: <20241212231346.181221-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

line_offset of 2^32 bytes should be enough.

This requires the removal of the last_line field (in a previous patch) to
shrink struct expr to 112 bytes.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/nftables.h | 3 +--
 src/scanner.l      | 9 ++++++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index a6f0e6128887..2e0d91486a29 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -158,8 +158,7 @@ struct location {
 	const struct input_descriptor		*indesc;
 	union {
 		struct {
-			off_t			line_offset;
-
+			unsigned int 		line_offset;
 			unsigned int		first_line;
 			unsigned int		first_column;
 			unsigned int		last_column;
diff --git a/src/scanner.l b/src/scanner.l
index 4a340b00fdc6..9ccbc22d2120 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -88,8 +88,15 @@ static void update_pos(struct parser_state *state, struct location *loc,
 static void update_offset(struct parser_state *state, struct location *loc,
 			  unsigned int len)
 {
+	uint32_t line_offset;
+
 	state->indesc->token_offset	+= len;
-	loc->line_offset		= state->indesc->line_offset;
+	if (state->indesc->line_offset > UINT32_MAX)
+		line_offset = UINT32_MAX;
+	else
+		line_offset = state->indesc->line_offset;
+
+	loc->line_offset		= line_offset;
 }
 
 static void reset_pos(struct parser_state *state, struct location *loc)
-- 
2.30.2

