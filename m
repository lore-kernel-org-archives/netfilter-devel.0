Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E58A2882BC
	for <netfilter-devel@vger.kernel.org>; Thu, 22 May 2025 13:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747922117; cv=none; b=Rk5kp7+CsRfdcuEECRJR5R+SeZbqw3coLjQTyTvpxTwE2BE0LxvoRx7hwDiNWpUu6RpUft9eM5KemEexMWVLWSJ6TurKcpYZigRmQN+oHMHAvYxsjov0Ln7g6RymwUR0Ie7yc5sXQE65N6OuiUNBdhJAUcGJQTL6PjPJRjJDBEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747922117; c=relaxed/simple;
	bh=LIt4xApWVkO86o4r4xe1GxprTaygq4c6+rnO54AsJdY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z60iwBn0hQxkrTDJAIcY9XIislCVwBJ/wWm22PpcpH+XT5yL6o4U0fKZ8TUgFfyyPTpg9GDBw8rKllvpdsPUT0bmhFph9WP9DyLxRBjXraQW+LIUOuHpgRDDEVW7AY/1KTeiJIcTZ3GRxP89/2QYaCOKhyN8HOeaMECd+eQCp1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8C4BA6015E; Thu, 22 May 2025 15:55:12 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl v2] trace: add support for TRACE_CT information
Date: Thu, 22 May 2025 15:51:15 +0200
Message-ID: <20250522135119.30469-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Decode direction/id/state/status information.
This will be used by 'nftables monitor trace' to print a packets
conntrack state.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: adjust userspace side to reflect the change in the netlink
     message format -- flat attributes only.

 include/libnftnl/trace.h            |  4 +++
 include/linux/netfilter/nf_tables.h | 12 ++++++++
 src/trace.c                         | 46 +++++++++++++++++++++++++++++
 3 files changed, 62 insertions(+)

diff --git a/include/libnftnl/trace.h b/include/libnftnl/trace.h
index 18ab0c3baef7..5d66b50b2d31 100644
--- a/include/libnftnl/trace.h
+++ b/include/libnftnl/trace.h
@@ -28,6 +28,10 @@ enum nftnl_trace_attr {
 	NFTNL_TRACE_VERDICT,
 	NFTNL_TRACE_NFPROTO,
 	NFTNL_TRACE_POLICY,
+	NFTNL_TRACE_CT_DIRECTION,
+	NFTNL_TRACE_CT_ID,
+	NFTNL_TRACE_CT_STATE,
+	NFTNL_TRACE_CT_STATUS,
 	__NFTNL_TRACE_MAX,
 };
 #define NFTNL_TRACE_MAX (__NFTNL_TRACE_MAX - 1)
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 49c944e78463..3c044e4fd6c7 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -394,6 +394,10 @@ enum nft_set_field_attributes {
  * @NFTA_SET_HANDLE: set handle (NLA_U64)
  * @NFTA_SET_EXPR: set expression (NLA_NESTED: nft_expr_attributes)
  * @NFTA_SET_EXPRESSIONS: list of expressions (NLA_NESTED: nft_list_attributes)
+ * @NFTA_TRACE_CT_ID: conntrack id (NLA_U32)
+ * @NFTA_TRACE_CT_DIRECTION: packets direction (NLA_U8)
+ * @NFTA_TRACE_CT_STATUS: conntrack status (NLA_U32)
+ * @NFTA_TRACE_CT_STATE: packet state (new, established, ...) (NLA_U32)
  */
 enum nft_set_attributes {
 	NFTA_SET_UNSPEC,
@@ -1837,6 +1841,10 @@ enum nft_xfrm_keys {
  * @NFTA_TRACE_MARK: nfmark (NLA_U32)
  * @NFTA_TRACE_NFPROTO: nf protocol processed (NLA_U32)
  * @NFTA_TRACE_POLICY: policy that decided fate of packet (NLA_U32)
+ * @NFTA_TRACE_CT_ID: conntrack id (NLA_U32)
+ * @NFTA_TRACE_CT_DIRECTION: packets direction (NLA_U8)
+ * @NFTA_TRACE_CT_STATUS: conntrack status (NLA_U32)
+ * @NFTA_TRACE_CT_STATE: packet state (new, established, ...) (NLA_U32)
  */
 enum nft_trace_attributes {
 	NFTA_TRACE_UNSPEC,
@@ -1857,6 +1865,10 @@ enum nft_trace_attributes {
 	NFTA_TRACE_NFPROTO,
 	NFTA_TRACE_POLICY,
 	NFTA_TRACE_PAD,
+	NFTA_TRACE_CT_ID,
+	NFTA_TRACE_CT_DIRECTION,
+	NFTA_TRACE_CT_STATUS,
+	NFTA_TRACE_CT_STATE,
 	__NFTA_TRACE_MAX
 };
 #define NFTA_TRACE_MAX (__NFTA_TRACE_MAX - 1)
diff --git a/src/trace.c b/src/trace.c
index f7eb45ed6704..d67e11408266 100644
--- a/src/trace.c
+++ b/src/trace.c
@@ -44,6 +44,12 @@ struct nftnl_trace {
 	uint32_t policy;
 	uint16_t iiftype;
 	uint16_t oiftype;
+	struct {
+		uint16_t dir;
+		uint32_t id;
+		uint32_t state;
+		uint32_t status;
+	} ct;
 
 	uint32_t flags;
 };
@@ -88,6 +94,10 @@ static int nftnl_trace_parse_attr_cb(const struct nlattr *attr, void *data)
                 if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
 			abi_breakage();
 		break;
+	case NFTA_TRACE_CT_DIRECTION:
+		if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0)
+			abi_breakage();
+		break;
 	case NFTA_TRACE_IIFTYPE:
 	case NFTA_TRACE_OIFTYPE:
 		if (mnl_attr_validate(attr, MNL_TYPE_U16) < 0)
@@ -100,6 +110,9 @@ static int nftnl_trace_parse_attr_cb(const struct nlattr *attr, void *data)
 	case NFTA_TRACE_POLICY:
 	case NFTA_TRACE_NFPROTO:
 	case NFTA_TRACE_TYPE:
+	case NFTA_TRACE_CT_ID:
+	case NFTA_TRACE_CT_STATE:
+	case NFTA_TRACE_CT_STATUS:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
@@ -190,6 +203,18 @@ const void *nftnl_trace_get_data(const struct nftnl_trace *trace,
 	case NFTNL_TRACE_POLICY:
 		*data_len = sizeof(uint32_t);
 		return &trace->policy;
+	case NFTNL_TRACE_CT_DIRECTION:
+		*data_len = sizeof(uint16_t);
+		return &trace->ct.dir;
+	case NFTNL_TRACE_CT_ID:
+		*data_len = sizeof(uint32_t);
+		return &trace->ct.id;
+	case NFTNL_TRACE_CT_STATE:
+		*data_len = sizeof(uint32_t);
+		return &trace->ct.state;
+	case NFTNL_TRACE_CT_STATUS:
+		*data_len = sizeof(uint32_t);
+		return &trace->ct.status;
 	case __NFTNL_TRACE_MAX:
 		break;
 	}
@@ -419,5 +444,26 @@ int nftnl_trace_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_trace *t)
 		t->flags |= (1 << NFTNL_TRACE_MARK);
 	}
 
+	if (tb[NFTA_TRACE_CT_DIRECTION]) {
+		t->ct.dir = mnl_attr_get_u8(tb[NFTA_TRACE_CT_DIRECTION]);
+		t->flags |= (1 << NFTNL_TRACE_CT_DIRECTION);
+	}
+
+	if (tb[NFTA_TRACE_CT_ID]) {
+		/* NFT_CT_ID is expected to be in big endian */
+		t->ct.id = mnl_attr_get_u32(tb[NFTA_TRACE_CT_ID]);
+		t->flags |= (1 << NFTNL_TRACE_CT_ID);
+	}
+
+	if (tb[NFTA_TRACE_CT_STATE]) {
+		t->ct.state = ntohl(mnl_attr_get_u32(tb[NFTA_TRACE_CT_STATE]));
+		t->flags |= (1 << NFTNL_TRACE_CT_STATE);
+	}
+
+	if (tb[NFTA_TRACE_CT_STATUS]) {
+		t->ct.status = ntohl(mnl_attr_get_u32(tb[NFTA_TRACE_CT_STATUS]));
+		t->flags |= (1 << NFTNL_TRACE_CT_STATUS);
+	}
+
 	return 0;
 }
-- 
2.49.0

