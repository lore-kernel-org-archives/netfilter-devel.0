Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47BB270EB6
	for <netfilter-devel@vger.kernel.org>; Thu,  8 May 2025 15:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746718036; cv=none; b=HA301AuSn4kpckklwch5Gl4oysAlwQnLbJ794cqewttzYIWnG6HLvj3boUW1Qn0kfQYpJwc+VEDYjUv9E+BTbN+EuQ7MIL8D/mmGkRHNPEEMsEFoQtdtKjjq1dKR9MpicCHNJHy/CALb1B8oS/v+Zrk2eOZdB6dMj/1LFgCpvJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746718036; c=relaxed/simple;
	bh=CvUboLN6taNwcmU332GUPSJhyVJfM4HcDiBYIPdvyYM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oiQ74+zwHeMLM9gd4W3srzlDoWavnDRVyxAtoTmfeFNzKB4FqdFhwIjCJrSZQ9cTUbqyz6RWzRA7rd2sG1ZTJHt9xkCXK6DRg7AALtyvGRVvZpArSqxMXskOXaymtaL2A2i/9YwfGe1Jd6sA9eU4rAuuLFqVyGJXjZMIWTM3T7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1uD39U-00052V-UB; Thu, 08 May 2025 17:27:12 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl] trace: add support for TRACE_CT information
Date: Thu,  8 May 2025 17:26:29 +0200
Message-ID: <20250508152632.7520-1-fw@strlen.de>
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
 include/libnftnl/trace.h            |  4 ++
 include/linux/netfilter/nf_tables.h |  2 +
 src/trace.c                         | 78 +++++++++++++++++++++++++++++
 3 files changed, 84 insertions(+)

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
index 49c944e78463..5a00ec9a4879 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1837,6 +1837,7 @@ enum nft_xfrm_keys {
  * @NFTA_TRACE_MARK: nfmark (NLA_U32)
  * @NFTA_TRACE_NFPROTO: nf protocol processed (NLA_U32)
  * @NFTA_TRACE_POLICY: policy that decided fate of packet (NLA_U32)
+ * @NFTA_TRACE_CT: connection tracking information (NLA_NESTED: nft_ct_keys)
  */
 enum nft_trace_attributes {
 	NFTA_TRACE_UNSPEC,
@@ -1857,6 +1858,7 @@ enum nft_trace_attributes {
 	NFTA_TRACE_NFPROTO,
 	NFTA_TRACE_POLICY,
 	NFTA_TRACE_PAD,
+	NFTA_TRACE_CT,
 	__NFTA_TRACE_MAX
 };
 #define NFTA_TRACE_MAX (__NFTA_TRACE_MAX - 1)
diff --git a/src/trace.c b/src/trace.c
index f7eb45ed6704..a218289ceb25 100644
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
@@ -85,6 +91,7 @@ static int nftnl_trace_parse_attr_cb(const struct nlattr *attr, void *data)
 	case __NFTA_TRACE_MAX:
 		break;
 	case NFTA_TRACE_VERDICT:
+	case NFTA_TRACE_CT:
                 if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
 			abi_breakage();
 		break;
@@ -190,6 +197,18 @@ const void *nftnl_trace_get_data(const struct nftnl_trace *trace,
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
@@ -321,6 +340,61 @@ static int nftnl_trace_parse_verdict(const struct nlattr *attr,
 	return 0;
 }
 
+static int nftnl_trace_parse_ct_cb(const struct nlattr *attr, void *data)
+{
+	int type = mnl_attr_get_type(attr);
+	const struct nlattr **tb = data;
+
+	switch (type) {
+	case NFT_CT_DIRECTION:
+		if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0)
+			abi_breakage();
+		tb[type] = attr;
+		break;
+	case NFT_CT_STATE:
+	case NFT_CT_STATUS:
+	case NFT_CT_ID:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
+		tb[type] = attr;
+		break;
+	}
+
+	return MNL_CB_OK;
+}
+
+static int nftnl_trace_parse_ct(const struct nlattr *attr,
+				struct nftnl_trace *t)
+{
+	struct nlattr *tb[NFT_CT_MAX+1] = {};
+
+	if (mnl_attr_parse_nested(attr, nftnl_trace_parse_ct_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFT_CT_DIRECTION]) {
+		t->ct.dir = mnl_attr_get_u8(tb[NFT_CT_DIRECTION]);
+		t->flags |= (1 << NFTNL_TRACE_CT_DIRECTION);
+	}
+
+	if (tb[NFT_CT_ID]) {
+		/* NFT_CT_ID is expected to be in big endian */
+		t->ct.id = mnl_attr_get_u32(tb[NFT_CT_ID]);
+		t->flags |= (1 << NFTNL_TRACE_CT_ID);
+	}
+
+	if (tb[NFT_CT_STATE]) {
+		t->ct.state = ntohl(mnl_attr_get_u32(tb[NFT_CT_STATE]));
+		t->flags |= (1 << NFTNL_TRACE_CT_STATE);
+	}
+
+	if (tb[NFT_CT_STATUS]) {
+		t->ct.status = ntohl(mnl_attr_get_u32(tb[NFT_CT_STATUS]));
+		t->flags |= (1 << NFTNL_TRACE_CT_STATUS);
+	}
+
+	return 0;
+}
+
 EXPORT_SYMBOL(nftnl_trace_nlmsg_parse);
 int nftnl_trace_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_trace *t)
 {
@@ -419,5 +493,9 @@ int nftnl_trace_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_trace *t)
 		t->flags |= (1 << NFTNL_TRACE_MARK);
 	}
 
+	if (tb[NFTA_TRACE_CT] &&
+	    nftnl_trace_parse_ct(tb[NFTA_TRACE_CT], t) < 0)
+		return -1;
+
 	return 0;
 }
-- 
2.49.0

