Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Qbwq54MR"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F9910A
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Dec 2023 11:02:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ldwi0LbYMG0Xj2Xp/yTISQqkbRkNFDdXXO7Go+y0KKw=; b=Qbwq54MRRiDPRKi6owsrPk1iEO
	9UCQDzeiEP3+wgWpKF+2BsCc7JbvT43WuoieWKZO356EGGV6yRzwvmzTsd8DKiB2dtOCOQhNc/hLP
	nes/ADOFXVG4sPN3yPjtKZPN/g8Fa2FZq3ryaUtRph/9O/6kT9De+wUR/TAtY3MBLHBg6F8VGj3e8
	ELNGK4ywoiEkaBGTI9K9Y1sbn/l6gdIzDlTRp8j77T+NSd7FiDG7YQBwWyRKVVBE5haoZpeq70RV6
	Gk0aSOyu/ZM2pL7jMSyszV8VSZPQse8f1pOY5J6oXYkWxxtXoI6vDXj0/n3/0BW+C8ZnChSQNcybn
	40y73XsA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rDUV2-0006PF-2A; Wed, 13 Dec 2023 20:02:28 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: [libnftnl RFC 2/2] expr: Introduce struct expr_ops::attr_policy
Date: Wed, 13 Dec 2023 20:02:22 +0100
Message-ID: <20231213190222.3681-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231213190222.3681-1-phil@nwl.cc>
References: <20231213190222.3681-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Similar to kernel's nla_policy, enable expressions to inform about
restrictions on attribute use. This allows the generic expression code
to perform sanity checks before dispatching to expression ops.

For now, this holds only the maximum data len which may be passed to
nftnl_expr_set().

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/expr_ops.h   |  5 +++++
 src/expr.c           |  6 ++++++
 src/expr/bitwise.c   | 11 +++++++++++
 src/expr/byteorder.c |  9 +++++++++
 src/expr/immediate.c |  9 +++++++++
 5 files changed, 40 insertions(+)

diff --git a/include/expr_ops.h b/include/expr_ops.h
index 51b221483552c..6c95297bfcd58 100644
--- a/include/expr_ops.h
+++ b/include/expr_ops.h
@@ -8,10 +8,15 @@ struct nlattr;
 struct nlmsghdr;
 struct nftnl_expr;
 
+struct attr_policy {
+	size_t maxlen;
+};
+
 struct expr_ops {
 	const char *name;
 	uint32_t alloc_len;
 	int	nftnl_max_attr;
+	struct attr_policy *attr_policy;
 	void	(*init)(const struct nftnl_expr *e);
 	void	(*free)(const struct nftnl_expr *e);
 	int	(*set)(struct nftnl_expr *e, uint16_t type, const void *data, uint32_t data_len);
diff --git a/src/expr.c b/src/expr.c
index b4581f1a79ff6..3e06c48aeb5f3 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -71,6 +71,12 @@ int nftnl_expr_set(struct nftnl_expr *expr, uint16_t type,
 	case NFTNL_EXPR_NAME:	/* cannot be modified */
 		return 0;
 	default:
+		if (expr->ops->attr_policy &&
+		    type <= expr->ops->nftnl_max_attr &&
+		    expr->ops->attr_policy[type].maxlen &&
+		    expr->ops->attr_policy[type].maxlen < data_len)
+			return -1;
+
 		if (expr->ops->set(expr, type, data, data_len) < 0)
 			return -1;
 	}
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index d11272fbd37b0..0a881eb3545dd 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -274,10 +274,21 @@ nftnl_expr_bitwise_snprintf(char *buf, size_t size,
 	return err;
 }
 
+static struct attr_policy bitwise_attr_policy[__NFTNL_EXPR_BITWISE_MAX] = {
+	[NFTNL_EXPR_BITWISE_SREG] = { .maxlen = sizeof(enum nft_registers) },
+	[NFTNL_EXPR_BITWISE_DREG] = { .maxlen = sizeof(enum nft_registers) },
+	[NFTNL_EXPR_BITWISE_LEN] = { .maxlen = sizeof(uint8_t) },
+	[NFTNL_EXPR_BITWISE_MASK] = { .maxlen = NFT_DATA_VALUE_MAXLEN },
+	[NFTNL_EXPR_BITWISE_XOR] = { .maxlen = NFT_DATA_VALUE_MAXLEN },
+	[NFTNL_EXPR_BITWISE_OP] = { .maxlen = sizeof(enum nft_bitwise_ops) },
+	[NFTNL_EXPR_BITWISE_DATA] = { .maxlen = NFT_DATA_VALUE_MAXLEN },
+};
+
 struct expr_ops expr_ops_bitwise = {
 	.name		= "bitwise",
 	.alloc_len	= sizeof(struct nftnl_expr_bitwise),
 	.nftnl_max_attr	= __NFTNL_EXPR_BITWISE_MAX - 1,
+	.attr_policy	= bitwise_attr_policy,
 	.set		= nftnl_expr_bitwise_set,
 	.get		= nftnl_expr_bitwise_get,
 	.parse		= nftnl_expr_bitwise_parse,
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index f05ae59b688eb..6d085197b40c7 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -212,10 +212,19 @@ nftnl_expr_byteorder_snprintf(char *buf, size_t remain,
 	return offset;
 }
 
+static struct attr_policy byteorder_attr_policy[__NFTNL_EXPR_BYTEORDER_MAX] = {
+	[NFTNL_EXPR_BYTEORDER_DREG] = { .maxlen = sizeof(enum nft_registers) },
+	[NFTNL_EXPR_BYTEORDER_SREG] = { .maxlen = sizeof(enum nft_registers) },
+	[NFTNL_EXPR_BYTEORDER_OP] = { .maxlen = sizeof(enum nft_byteorder_ops) },
+	[NFTNL_EXPR_BYTEORDER_LEN] = { .maxlen = sizeof(uint8_t) },
+	[NFTNL_EXPR_BYTEORDER_SIZE] = { .maxlen = sizeof(uint8_t) },
+};
+
 struct expr_ops expr_ops_byteorder = {
 	.name		= "byteorder",
 	.alloc_len	= sizeof(struct nftnl_expr_byteorder),
 	.nftnl_max_attr	= __NFTNL_EXPR_BYTEORDER_MAX - 1,
+	.attr_policy	= byteorder_attr_policy,
 	.set		= nftnl_expr_byteorder_set,
 	.get		= nftnl_expr_byteorder_get,
 	.parse		= nftnl_expr_byteorder_parse,
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 2ffa0c5e9ebc3..774ed3dcfea7e 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -220,10 +220,19 @@ static void nftnl_expr_immediate_free(const struct nftnl_expr *e)
 		nftnl_free_verdict(&imm->data);
 }
 
+static struct attr_policy immediate_attr_policy[__NFTNL_EXPR_IMM_MAX] = {
+	[NFTNL_EXPR_IMM_DREG] = { .maxlen = sizeof(enum nft_registers) },
+	[NFTNL_EXPR_IMM_DATA] = { .maxlen = NFT_DATA_VALUE_MAXLEN },
+	[NFTNL_EXPR_IMM_VERDICT] = { .maxlen = sizeof(uint32_t) },
+	/*[NFTNL_EXPR_IMM_CHAIN] = { .maxlen = NFT_CHAIN_MAXNAMELEN },*/
+	[NFTNL_EXPR_IMM_CHAIN_ID] = { .maxlen = sizeof(uint32_t) },
+};
+
 struct expr_ops expr_ops_immediate = {
 	.name		= "immediate",
 	.alloc_len	= sizeof(struct nftnl_expr_immediate),
 	.nftnl_max_attr	= __NFTNL_EXPR_IMM_MAX - 1,
+	.attr_policy	= immediate_attr_policy,
 	.free		= nftnl_expr_immediate_free,
 	.set		= nftnl_expr_immediate_set,
 	.get		= nftnl_expr_immediate_get,
-- 
2.43.0

