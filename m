Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D3A19479
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2024 17:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710868355; cv=none; b=MoDmYN4VS6rnGABqcTJ7sbUdtWZeUHyNc7JUbLEBldm6yTTn2A6Hnou08MPe4fKyCBkHhNYBAO424+jA2A1WYMbYb/v4wbrAZN1XBSMlSmRpH0tsdKoJTTs3wGdj5vYE+NcfZNvsbnjS6pMSpU3aY+pb9Ft+cdaeGVSWWCvqJDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710868355; c=relaxed/simple;
	bh=8L5XdUFrEOh0h7XdH23L/6cSjxk7oxopulzsBLjVT10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p4Gxxog3WE2PRKJbdXgajdiLQsIDB5mcPuoOtdOwXWg6p5IfXrq1L4V3rWvO4u80VBeIXOJchkvyNsxbXx/omiUtvjNopkMKlV3e0hwwNHewI2cSz7Odhyp8labKzYwwN5K0zl7ZzoAQiH1hdZQoZmr1Qb9XwYPeHrmdfwsTSD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=pKZtXyF7; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="pKZtXyF7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lC7E3iZwUuVoDwNqw+RUaRCPEpq6RaNSwntlPYJCNNU=; b=pKZtXyF75xyDne4bEcGjbOa/Vj
	ttuAni0vivwDZln0eSxuHavhHHZgSQy8hca7QPtJVRKw9xid1dlLtNTHrFdTLzs/LX0xIbZkPPXt8
	vhnv4u0KYZ64xnKYPK6GKe1LlxSW5eL1sqHdNeTBAOpSMZcw7/BtIWvBh1ioWUsD1BTUkNZcDo7LU
	aq8lCsIDvkmT9c7HXGdFaKBoyKBKarOjh6rJ17+c2H5LGj+NIrauVsMgwGh0ZVRJlZiYaniNqFJf0
	Sr1U/KrwPkJHksm021OcWk4Pxs13JX5cNmV9dkQ53tXw5s2u9/1DkMVl9aLW8uQ2iVNyfQO+AqQX8
	wUAg8sOQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rmd0p-000000007fw-2Vl4;
	Tue, 19 Mar 2024 18:12:31 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 13/17] obj: Introduce struct obj_ops::attr_policy
Date: Tue, 19 Mar 2024 18:12:20 +0100
Message-ID: <20240319171224.18064-14-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240319171224.18064-1-phil@nwl.cc>
References: <20240319171224.18064-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Just like with struct expr_ops::attr_policy, enable object types to
inform about restrictions on attribute use. This way generic object code
may perform sanity checks before dispatching to object ops.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/obj.h        |  1 +
 src/obj/counter.c    |  6 ++++++
 src/obj/ct_expect.c  | 10 ++++++++++
 src/obj/ct_helper.c  | 11 +++++++++++
 src/obj/ct_timeout.c |  7 +++++++
 src/obj/limit.c      |  9 +++++++++
 src/obj/quota.c      |  7 +++++++
 src/obj/secmark.c    |  5 +++++
 src/obj/synproxy.c   |  7 +++++++
 src/obj/tunnel.c     | 20 ++++++++++++++++++++
 10 files changed, 83 insertions(+)

diff --git a/include/obj.h b/include/obj.h
index 6d2af8d5527d3..d2177377860d6 100644
--- a/include/obj.h
+++ b/include/obj.h
@@ -105,6 +105,7 @@ struct obj_ops {
 	uint32_t type;
 	size_t	alloc_len;
 	int	nftnl_max_attr;
+	struct attr_policy *attr_policy;
 	int	(*set)(struct nftnl_obj *e, uint16_t type, const void *data, uint32_t data_len);
 	const void *(*get)(const struct nftnl_obj *e, uint16_t type, uint32_t *data_len);
 	int	(*parse)(struct nftnl_obj *e, struct nlattr *attr);
diff --git a/src/obj/counter.c b/src/obj/counter.c
index 982da2c6678e5..44524d71b1698 100644
--- a/src/obj/counter.c
+++ b/src/obj/counter.c
@@ -116,11 +116,17 @@ static int nftnl_obj_counter_snprintf(char *buf, size_t len, uint32_t flags,
 			ctr->pkts, ctr->bytes);
 }
 
+static struct attr_policy obj_ctr_attr_policy[__NFTNL_OBJ_CTR_MAX] = {
+	[NFTNL_OBJ_CTR_BYTES]	= { .maxlen = sizeof(uint64_t) },
+	[NFTNL_OBJ_CTR_PKTS]	= { .maxlen = sizeof(uint64_t) },
+};
+
 struct obj_ops obj_ops_counter = {
 	.name		= "counter",
 	.type		= NFT_OBJECT_COUNTER,
 	.alloc_len	= sizeof(struct nftnl_obj_counter),
 	.nftnl_max_attr	= __NFTNL_OBJ_CTR_MAX - 1,
+	.attr_policy	= obj_ctr_attr_policy,
 	.set		= nftnl_obj_counter_set,
 	.get		= nftnl_obj_counter_get,
 	.parse		= nftnl_obj_counter_parse,
diff --git a/src/obj/ct_expect.c b/src/obj/ct_expect.c
index 60014dc9848b5..978af152c5a8e 100644
--- a/src/obj/ct_expect.c
+++ b/src/obj/ct_expect.c
@@ -185,11 +185,21 @@ static int nftnl_obj_ct_expect_snprintf(char *buf, size_t remain,
 	return offset;
 }
 
+static struct attr_policy
+obj_ct_expect_attr_policy[__NFTNL_OBJ_CT_EXPECT_MAX] = {
+	[NFTNL_OBJ_CT_EXPECT_L3PROTO]	= { .maxlen = sizeof(uint16_t) },
+	[NFTNL_OBJ_CT_EXPECT_L4PROTO]	= { .maxlen = sizeof(uint8_t) },
+	[NFTNL_OBJ_CT_EXPECT_DPORT]	= { .maxlen = sizeof(uint16_t) },
+	[NFTNL_OBJ_CT_EXPECT_TIMEOUT]	= { .maxlen = sizeof(uint32_t) },
+	[NFTNL_OBJ_CT_EXPECT_SIZE]	= { .maxlen = sizeof(uint8_t) },
+};
+
 struct obj_ops obj_ops_ct_expect = {
 	.name		= "ct_expect",
 	.type		= NFT_OBJECT_CT_EXPECT,
 	.alloc_len	= sizeof(struct nftnl_obj_ct_expect),
 	.nftnl_max_attr	= __NFTNL_OBJ_CT_EXPECT_MAX - 1,
+	.attr_policy	= obj_ct_expect_attr_policy,
 	.set		= nftnl_obj_ct_expect_set,
 	.get		= nftnl_obj_ct_expect_get,
 	.parse		= nftnl_obj_ct_expect_parse,
diff --git a/src/obj/ct_helper.c b/src/obj/ct_helper.c
index b8b05fd9eee8c..aa8e9262ec5aa 100644
--- a/src/obj/ct_helper.c
+++ b/src/obj/ct_helper.c
@@ -139,11 +139,22 @@ static int nftnl_obj_ct_helper_snprintf(char *buf, size_t len,
 			helper->name, helper->l3proto, helper->l4proto);
 }
 
+/* from kernel's include/net/netfilter/nf_conntrack_helper.h */
+#define NF_CT_HELPER_NAME_LEN	16
+
+static struct attr_policy
+obj_ct_helper_attr_policy[__NFTNL_OBJ_CT_HELPER_MAX] = {
+	[NFTNL_OBJ_CT_HELPER_NAME]	= { .maxlen = NF_CT_HELPER_NAME_LEN },
+	[NFTNL_OBJ_CT_HELPER_L3PROTO]	= { .maxlen = sizeof(uint16_t) },
+	[NFTNL_OBJ_CT_HELPER_L4PROTO]	= { .maxlen = sizeof(uint8_t) },
+};
+
 struct obj_ops obj_ops_ct_helper = {
 	.name		= "ct_helper",
 	.type		= NFT_OBJECT_CT_HELPER,
 	.alloc_len	= sizeof(struct nftnl_obj_ct_helper),
 	.nftnl_max_attr	= __NFTNL_OBJ_CT_HELPER_MAX - 1,
+	.attr_policy	= obj_ct_helper_attr_policy,
 	.set		= nftnl_obj_ct_helper_set,
 	.get		= nftnl_obj_ct_helper_get,
 	.parse		= nftnl_obj_ct_helper_parse,
diff --git a/src/obj/ct_timeout.c b/src/obj/ct_timeout.c
index 011d92867a077..88522d8c89bce 100644
--- a/src/obj/ct_timeout.c
+++ b/src/obj/ct_timeout.c
@@ -308,11 +308,18 @@ static int nftnl_obj_ct_timeout_snprintf(char *buf, size_t remain,
 	return offset;
 }
 
+static struct attr_policy
+obj_ct_timeout_attr_policy[__NFTNL_OBJ_CT_TIMEOUT_MAX] = {
+	[NFTNL_OBJ_CT_TIMEOUT_L3PROTO]	= { .maxlen = sizeof(uint16_t) },
+	[NFTNL_OBJ_CT_TIMEOUT_L4PROTO]	= { .maxlen = sizeof(uint8_t) },
+};
+
 struct obj_ops obj_ops_ct_timeout = {
 	.name		= "ct_timeout",
 	.type		= NFT_OBJECT_CT_TIMEOUT,
 	.alloc_len	= sizeof(struct nftnl_obj_ct_timeout),
 	.nftnl_max_attr	= __NFTNL_OBJ_CT_TIMEOUT_MAX - 1,
+	.attr_policy	= obj_ct_timeout_attr_policy,
 	.set		= nftnl_obj_ct_timeout_set,
 	.get		= nftnl_obj_ct_timeout_get,
 	.parse		= nftnl_obj_ct_timeout_parse,
diff --git a/src/obj/limit.c b/src/obj/limit.c
index 83cb1935fc8e9..0c7362e55e682 100644
--- a/src/obj/limit.c
+++ b/src/obj/limit.c
@@ -157,11 +157,20 @@ static int nftnl_obj_limit_snprintf(char *buf, size_t len,
 			limit->burst, limit->type, limit->flags);
 }
 
+static struct attr_policy obj_limit_attr_policy[__NFTNL_OBJ_LIMIT_MAX] = {
+	[NFTNL_OBJ_LIMIT_RATE]	= { .maxlen = sizeof(uint64_t) },
+	[NFTNL_OBJ_LIMIT_UNIT]	= { .maxlen = sizeof(uint64_t) },
+	[NFTNL_OBJ_LIMIT_BURST]	= { .maxlen = sizeof(uint32_t) },
+	[NFTNL_OBJ_LIMIT_TYPE]	= { .maxlen = sizeof(uint32_t) },
+	[NFTNL_OBJ_LIMIT_FLAGS]	= { .maxlen = sizeof(uint32_t) },
+};
+
 struct obj_ops obj_ops_limit = {
 	.name		= "limit",
 	.type		= NFT_OBJECT_LIMIT,
 	.alloc_len	= sizeof(struct nftnl_obj_limit),
 	.nftnl_max_attr	= __NFTNL_OBJ_LIMIT_MAX - 1,
+	.attr_policy	= obj_limit_attr_policy,
 	.set		= nftnl_obj_limit_set,
 	.get		= nftnl_obj_limit_get,
 	.parse		= nftnl_obj_limit_parse,
diff --git a/src/obj/quota.c b/src/obj/quota.c
index 665d7caf4a5d5..b48ba91a4df11 100644
--- a/src/obj/quota.c
+++ b/src/obj/quota.c
@@ -133,11 +133,18 @@ static int nftnl_obj_quota_snprintf(char *buf, size_t len,
 			quota->bytes, quota->flags);
 }
 
+static struct attr_policy obj_quota_attr_policy[__NFTNL_OBJ_QUOTA_MAX] = {
+	[NFTNL_OBJ_QUOTA_BYTES]		= { .maxlen = sizeof(uint64_t) },
+	[NFTNL_OBJ_QUOTA_CONSUMED]	= { .maxlen = sizeof(uint64_t) },
+	[NFTNL_OBJ_QUOTA_FLAGS]		= { .maxlen = sizeof(uint32_t) },
+};
+
 struct obj_ops obj_ops_quota = {
 	.name		= "quota",
 	.type		= NFT_OBJECT_QUOTA,
 	.alloc_len	= sizeof(struct nftnl_obj_quota),
 	.nftnl_max_attr	= __NFTNL_OBJ_QUOTA_MAX - 1,
+	.attr_policy	= obj_quota_attr_policy,
 	.set		= nftnl_obj_quota_set,
 	.get		= nftnl_obj_quota_get,
 	.parse		= nftnl_obj_quota_parse,
diff --git a/src/obj/secmark.c b/src/obj/secmark.c
index 83cd1dc2264ed..eea96647cff72 100644
--- a/src/obj/secmark.c
+++ b/src/obj/secmark.c
@@ -105,11 +105,16 @@ static int nftnl_obj_secmark_snprintf(char *buf, size_t len,
 	return snprintf(buf, len, "context %s ", secmark->ctx);
 }
 
+static struct attr_policy obj_secmark_attr_policy[__NFTNL_OBJ_SECMARK_MAX] = {
+	[NFTNL_OBJ_SECMARK_CTX]	= { .maxlen = NFT_SECMARK_CTX_MAXLEN },
+};
+
 struct obj_ops obj_ops_secmark = {
 	.name		= "secmark",
 	.type		= NFT_OBJECT_SECMARK,
 	.alloc_len	= sizeof(struct nftnl_obj_secmark),
 	.nftnl_max_attr	= __NFTNL_OBJ_SECMARK_MAX - 1,
+	.attr_policy	= obj_secmark_attr_policy,
 	.set		= nftnl_obj_secmark_set,
 	.get		= nftnl_obj_secmark_get,
 	.parse		= nftnl_obj_secmark_parse,
diff --git a/src/obj/synproxy.c b/src/obj/synproxy.c
index f7c77627b56e9..65fbcf76629ad 100644
--- a/src/obj/synproxy.c
+++ b/src/obj/synproxy.c
@@ -132,11 +132,18 @@ static int nftnl_obj_synproxy_snprintf(char *buf, size_t len,
         return offset;
 }
 
+static struct attr_policy obj_synproxy_attr_policy[__NFTNL_OBJ_SYNPROXY_MAX] = {
+	[NFTNL_OBJ_SYNPROXY_MSS]	= { .maxlen = sizeof(uint16_t) },
+	[NFTNL_OBJ_SYNPROXY_WSCALE]	= { .maxlen = sizeof(uint8_t) },
+	[NFTNL_OBJ_SYNPROXY_FLAGS]	= { .maxlen = sizeof(uint32_t) },
+};
+
 struct obj_ops obj_ops_synproxy = {
 	.name		= "synproxy",
 	.type		= NFT_OBJECT_SYNPROXY,
 	.alloc_len	= sizeof(struct nftnl_obj_synproxy),
 	.nftnl_max_attr	= __NFTNL_OBJ_SYNPROXY_MAX - 1,
+	.attr_policy	= obj_synproxy_attr_policy,
 	.set		= nftnl_obj_synproxy_set,
 	.get		= nftnl_obj_synproxy_get,
 	.parse		= nftnl_obj_synproxy_parse,
diff --git a/src/obj/tunnel.c b/src/obj/tunnel.c
index 72985eeb761cd..07b3b2ac0cb86 100644
--- a/src/obj/tunnel.c
+++ b/src/obj/tunnel.c
@@ -536,11 +536,31 @@ static int nftnl_obj_tunnel_snprintf(char *buf, size_t len,
 	return snprintf(buf, len, "id %u ", tun->id);
 }
 
+static struct attr_policy obj_tunnel_attr_policy[__NFTNL_OBJ_TUNNEL_MAX] = {
+	[NFTNL_OBJ_TUNNEL_ID]		= { .maxlen = sizeof(uint32_t) },
+	[NFTNL_OBJ_TUNNEL_IPV4_SRC]	= { .maxlen = sizeof(uint32_t) },
+	[NFTNL_OBJ_TUNNEL_IPV4_DST]	= { .maxlen = sizeof(uint32_t) },
+	[NFTNL_OBJ_TUNNEL_IPV6_SRC]	= { .maxlen = sizeof(struct in6_addr) },
+	[NFTNL_OBJ_TUNNEL_IPV6_DST]	= { .maxlen = sizeof(struct in6_addr) },
+	[NFTNL_OBJ_TUNNEL_IPV6_FLOWLABEL] = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_OBJ_TUNNEL_SPORT]	= { .maxlen = sizeof(uint16_t) },
+	[NFTNL_OBJ_TUNNEL_DPORT]	= { .maxlen = sizeof(uint16_t) },
+	[NFTNL_OBJ_TUNNEL_FLAGS]	= { .maxlen = sizeof(uint32_t) },
+	[NFTNL_OBJ_TUNNEL_TOS]		= { .maxlen = sizeof(uint8_t) },
+	[NFTNL_OBJ_TUNNEL_TTL]		= { .maxlen = sizeof(uint8_t) },
+	[NFTNL_OBJ_TUNNEL_VXLAN_GBP]	= { .maxlen = sizeof(uint32_t) },
+	[NFTNL_OBJ_TUNNEL_ERSPAN_VERSION] = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX] = { .maxlen = sizeof(uint32_t) },
+	[NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID] = { .maxlen = sizeof(uint8_t) },
+	[NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR] = { .maxlen = sizeof(uint8_t) },
+};
+
 struct obj_ops obj_ops_tunnel = {
 	.name		= "tunnel",
 	.type		= NFT_OBJECT_TUNNEL,
 	.alloc_len	= sizeof(struct nftnl_obj_tunnel),
 	.nftnl_max_attr	= __NFTNL_OBJ_TUNNEL_MAX - 1,
+	.attr_policy	= obj_tunnel_attr_policy,
 	.set		= nftnl_obj_tunnel_set,
 	.get		= nftnl_obj_tunnel_get,
 	.parse		= nftnl_obj_tunnel_parse,
-- 
2.43.0

