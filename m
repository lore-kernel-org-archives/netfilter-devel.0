Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F17A3DD52D;
	Wed, 25 Mar 2026 13:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774444365; cv=none; b=AVeCcscLKCQGBwrk/a/+5MQIdJn3nqEc4lfWRtNhj8CmHEqFkdYf5xW0dprI+suHXsFr0W3nDhoTJmM6cUMmTsP9s5Q4zkymATttJdiYhvkrmXJSi3jolwcPfLhjuOzVU1YkqXl5uTe5sPo5CRvrZK+WHVMzuRmUmjskvegJmtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774444365; c=relaxed/simple;
	bh=7/wgadVitLUg3Lz74GQhOpohsncTiCNmt1zIiAtL8PM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTNKqVlGFD+eJijiEOccTF+w0JK/GpmjHouPzzpGlQLTNu1EvMn9vjzjRwZMbep1gjZhvmaXF4jw12z05cQ44TJUOD2uqnuWZeC2SnCCJ1DJbbmKtTwbN+Vujt8PjJZb6oBBbdQFc6uZYdSuTTlgVAu2KsnYKN428qgkiVrFwPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7042460CA9; Wed, 25 Mar 2026 14:12:34 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 14/14] netfilter: ctnetlink: use netlink policy range checks
Date: Wed, 25 Mar 2026 14:11:08 +0100
Message-ID: <20260325131108.23045-15-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260325131108.23045-1-fw@strlen.de>
References: <20260325131108.23045-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Carlier <devnexen@gmail.com>

Replace manual range and mask validations with netlink policy
annotations in ctnetlink code paths, so that the netlink core rejects
invalid values early and can generate extack errors.

- CTA_PROTOINFO_TCP_STATE: reject values > TCP_CONNTRACK_SYN_SENT2 at
  policy level, removing the manual >= TCP_CONNTRACK_MAX check.
- CTA_PROTOINFO_TCP_WSCALE_ORIGINAL/REPLY: reject values > TCP_MAX_WSCALE
  (14). The normal TCP option parsing path already clamps to this value,
  but the ctnetlink path accepted 0-255, causing undefined behavior when
  used as a u32 shift count.
- CTA_FILTER_ORIG_FLAGS/REPLY_FLAGS: use NLA_POLICY_MASK with
  CTA_FILTER_F_ALL, removing the manual mask checks.
- CTA_EXPECT_FLAGS: use NLA_POLICY_MASK with NF_CT_EXPECT_MASK, adding
  a new mask define grouping all valid expect flags.

Extracted from a broader nf-next patch by Florian Westphal, scoped to
ctnetlink for the fixes tree.

Fixes: c8e2078cfe41 ("[NETFILTER]: ctnetlink: add support for internal tcp connection tracking flags handling")
Signed-off-by: David Carlier <devnexen@gmail.com>
Co-developed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../uapi/linux/netfilter/nf_conntrack_common.h   |  4 ++++
 net/netfilter/nf_conntrack_netlink.c             | 16 +++++-----------
 net/netfilter/nf_conntrack_proto_tcp.c           | 10 +++-------
 3 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
index 26071021e986..56b6b60a814f 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
@@ -159,5 +159,9 @@ enum ip_conntrack_expect_events {
 #define NF_CT_EXPECT_INACTIVE		0x2
 #define NF_CT_EXPECT_USERSPACE		0x4
 
+#ifdef __KERNEL__
+#define NF_CT_EXPECT_MASK	(NF_CT_EXPECT_PERMANENT | NF_CT_EXPECT_INACTIVE | \
+				 NF_CT_EXPECT_USERSPACE)
+#endif
 
 #endif /* _UAPI_NF_CONNTRACK_COMMON_H */
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 2ec33c0518e9..e99f15cdcc5a 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -910,8 +910,8 @@ struct ctnetlink_filter {
 };
 
 static const struct nla_policy cta_filter_nla_policy[CTA_FILTER_MAX + 1] = {
-	[CTA_FILTER_ORIG_FLAGS]		= { .type = NLA_U32 },
-	[CTA_FILTER_REPLY_FLAGS]	= { .type = NLA_U32 },
+	[CTA_FILTER_ORIG_FLAGS]		= NLA_POLICY_MASK(NLA_U32, CTA_FILTER_F_ALL),
+	[CTA_FILTER_REPLY_FLAGS]	= NLA_POLICY_MASK(NLA_U32, CTA_FILTER_F_ALL),
 };
 
 static int ctnetlink_parse_filter(const struct nlattr *attr,
@@ -925,17 +925,11 @@ static int ctnetlink_parse_filter(const struct nlattr *attr,
 	if (ret)
 		return ret;
 
-	if (tb[CTA_FILTER_ORIG_FLAGS]) {
+	if (tb[CTA_FILTER_ORIG_FLAGS])
 		filter->orig_flags = nla_get_u32(tb[CTA_FILTER_ORIG_FLAGS]);
-		if (filter->orig_flags & ~CTA_FILTER_F_ALL)
-			return -EOPNOTSUPP;
-	}
 
-	if (tb[CTA_FILTER_REPLY_FLAGS]) {
+	if (tb[CTA_FILTER_REPLY_FLAGS])
 		filter->reply_flags = nla_get_u32(tb[CTA_FILTER_REPLY_FLAGS]);
-		if (filter->reply_flags & ~CTA_FILTER_F_ALL)
-			return -EOPNOTSUPP;
-	}
 
 	return 0;
 }
@@ -2634,7 +2628,7 @@ static const struct nla_policy exp_nla_policy[CTA_EXPECT_MAX+1] = {
 	[CTA_EXPECT_HELP_NAME]	= { .type = NLA_NUL_STRING,
 				    .len = NF_CT_HELPER_NAME_LEN - 1 },
 	[CTA_EXPECT_ZONE]	= { .type = NLA_U16 },
-	[CTA_EXPECT_FLAGS]	= { .type = NLA_U32 },
+	[CTA_EXPECT_FLAGS]	= NLA_POLICY_MASK(NLA_BE32, NF_CT_EXPECT_MASK),
 	[CTA_EXPECT_CLASS]	= { .type = NLA_U32 },
 	[CTA_EXPECT_NAT]	= { .type = NLA_NESTED },
 	[CTA_EXPECT_FN]		= { .type = NLA_NUL_STRING },
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 0c1d086e96cb..b67426c2189b 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1385,9 +1385,9 @@ static int tcp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
 }
 
 static const struct nla_policy tcp_nla_policy[CTA_PROTOINFO_TCP_MAX+1] = {
-	[CTA_PROTOINFO_TCP_STATE]	    = { .type = NLA_U8 },
-	[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL] = { .type = NLA_U8 },
-	[CTA_PROTOINFO_TCP_WSCALE_REPLY]    = { .type = NLA_U8 },
+	[CTA_PROTOINFO_TCP_STATE]	    = NLA_POLICY_MAX(NLA_U8, TCP_CONNTRACK_SYN_SENT2),
+	[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL] = NLA_POLICY_MAX(NLA_U8, TCP_MAX_WSCALE),
+	[CTA_PROTOINFO_TCP_WSCALE_REPLY]    = NLA_POLICY_MAX(NLA_U8, TCP_MAX_WSCALE),
 	[CTA_PROTOINFO_TCP_FLAGS_ORIGINAL]  = { .len = sizeof(struct nf_ct_tcp_flags) },
 	[CTA_PROTOINFO_TCP_FLAGS_REPLY]	    = { .len = sizeof(struct nf_ct_tcp_flags) },
 };
@@ -1414,10 +1414,6 @@ static int nlattr_to_tcp(struct nlattr *cda[], struct nf_conn *ct)
 	if (err < 0)
 		return err;
 
-	if (tb[CTA_PROTOINFO_TCP_STATE] &&
-	    nla_get_u8(tb[CTA_PROTOINFO_TCP_STATE]) >= TCP_CONNTRACK_MAX)
-		return -EINVAL;
-
 	spin_lock_bh(&ct->lock);
 	if (tb[CTA_PROTOINFO_TCP_STATE])
 		ct->proto.tcp.state = nla_get_u8(tb[CTA_PROTOINFO_TCP_STATE]);
-- 
2.52.0

