Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D5311987
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Dec 2023 06:34:39 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rBbw6-0007l7-82; Fri, 08 Dec 2023 15:34:38 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] netlink: add and use nft_data_memcpy helper
Date: Fri,  8 Dec 2023 15:34:29 +0100
Message-ID: <20231208143433.13962-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a stack overflow somewhere in this code, we end
up memcpy'ing a way too large expr into a fixed-size on-stack
buffer.

This is hard to diagnose, most of this code gets inlined so
the crash happens later on return from alloc_nftnl_setelem.

Condense the mempy into a helper and add a BUG so we can catch
the overflow before it occurs.

->value is too small (4, should be 16), but for normal
cases (well-formed data must fit into max reg space, i.e.
64 byte) the chain buffer that comes after value in the
structure provides a cushion.

In order to have the new BUG() not trigger on valid data,
bump value to the correct size, this is userspace so the additional
60 bytes of stack usage is no concern.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 This isn't a fix, I need to wait for afl to trigger this bug again.

 include/netlink.h |  2 +-
 src/netlink.c     | 25 +++++++++++++++----------
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index 6766d7e8563f..32f8a3e58aba 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -100,7 +100,7 @@ extern struct nftnl_rule *netlink_rule_alloc(const struct nlmsghdr *nlh);
 
 struct nft_data_linearize {
 	uint32_t	len;
-	uint32_t	value[4];
+	uint32_t	value[NFT_REG32_COUNT];
 	char		chain[NFT_CHAIN_MAXNAMELEN];
 	uint32_t	chain_id;
 	int		verdict;
diff --git a/src/netlink.c b/src/netlink.c
index 4b9722f9e495..76e6be58f8f7 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -307,6 +307,16 @@ static int __netlink_gen_concat_key(uint32_t flags, const struct expr *i,
 	return netlink_export_pad(data, i->value, i);
 }
 
+static void nft_data_memcpy(struct nft_data_linearize *nld,
+			    const void *src, unsigned int len)
+{
+	if (len > sizeof(nld->value))
+		BUG("nld buffer overflow: want to copy %u, max %u\n", len, (unsigned int)sizeof(nld->value));
+
+	memcpy(nld->value, src, len);
+	nld->len = len;
+}
+
 static void netlink_gen_concat_key(const struct expr *expr,
 				    struct nft_data_linearize *nld)
 {
@@ -319,8 +329,7 @@ static void netlink_gen_concat_key(const struct expr *expr,
 	list_for_each_entry(i, &expr->expressions, list)
 		offset += __netlink_gen_concat_key(expr->flags, i, data + offset);
 
-	memcpy(nld->value, data, len);
-	nld->len = len;
+	nft_data_memcpy(nld, data, len);
 }
 
 static int __netlink_gen_concat_data(int end, const struct expr *i,
@@ -366,8 +375,7 @@ static void __netlink_gen_concat_expand(const struct expr *expr,
 	list_for_each_entry(i, &expr->expressions, list)
 		offset += __netlink_gen_concat_data(true, i, data + offset);
 
-	memcpy(nld->value, data, len);
-	nld->len = len;
+	nft_data_memcpy(nld, data, len);
 }
 
 static void __netlink_gen_concat(const struct expr *expr,
@@ -382,8 +390,7 @@ static void __netlink_gen_concat(const struct expr *expr,
 	list_for_each_entry(i, &expr->expressions, list)
 		offset += __netlink_gen_concat_data(expr->flags, i, data + offset);
 
-	memcpy(nld->value, data, len);
-	nld->len = len;
+	nft_data_memcpy(nld, data, len);
 }
 
 static void netlink_gen_concat_data(const struct expr *expr,
@@ -452,8 +459,7 @@ static void netlink_gen_range(const struct expr *expr,
 	memset(data, 0, len);
 	offset = netlink_export_pad(data, expr->left->value, expr->left);
 	netlink_export_pad(data + offset, expr->right->value, expr->right);
-	memcpy(nld->value, data, len);
-	nld->len = len;
+	nft_data_memcpy(nld, data, len);
 }
 
 static void netlink_gen_prefix(const struct expr *expr,
@@ -470,8 +476,7 @@ static void netlink_gen_prefix(const struct expr *expr,
 	netlink_export_pad(data + offset, v, expr->prefix);
 	mpz_clear(v);
 
-	memcpy(nld->value, data, len);
-	nld->len = len;
+	nft_data_memcpy(nld, data, len);
 }
 
 static void netlink_gen_key(const struct expr *expr,
-- 
2.41.0

