Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D46C208C1
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2024 17:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710868357; cv=none; b=ep4ZzIQhdMlHGQ6Se804JG3lALP+6JBlRNbGb3Op6idN5dOUXwxbQ8WUnoadqL8qArN5JmMQND5QWcx3csr+awhs7nm1XQyFr2b/AYuveTvcbLLv5pdKNrtXr8IquD26S8sBJWafyO07bqtD/7+3Ywq4m+AxLkhfb3OhIX8rZHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710868357; c=relaxed/simple;
	bh=4eUEt/3/jypg96/Rg4LykBDQwPNKDDBRuKgM0DGHik0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i57A8jJYqhxYLXIEr/SG0F1UXDoLxh6kdlJdK0fNg7Qk0gNR6SXC/vvaWoEXIzpKe3s+p2WqGX/OwNmZLDljAB6uTWtRG1f4xH3KOrBwXiqr3YBlMH1qbseHpD1NxQQ2tCk5sQLzDleLplXMAOlTxqCWT1IH9SjXSMvlEaYlWZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Xqmm+WoP; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Xqmm+WoP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Ql/qB7X8N/Olksp8PNnDtIkDwrZvROZhsckZaA6bX5A=; b=Xqmm+WoP3qvos6wJKWpvLwp4pU
	WiklZYbUAJkl/CnpEYKnUoyb/zN5Wnjc70D+r9jJYsZEWNL/gNYBDz5Opq0SWEzsZ7du605s4DXxI
	ybKgIHby7m2/+G5FuFSXokIvrBbu0SDcF4hX0Qefn2UJjf1nM88d9lG0aiHGI1ubhwVgjmph/0Hk4
	1igv9ALHpoZu50boJ3c5AEcqsNLPwTB40rhcP6jXEjs/SgTHSh2rihLaoyfGwqqing8OkSy9F+zQQ
	/v6gNOPTqykNnmnT8nmQMtdqSkCebWaqLeT/HvZX9+qkaxNjtSu5scFcJE/HaVJsUN/x9jdQTSzxO
	GAp9qNUw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rmd0s-000000007gJ-0tf8;
	Tue, 19 Mar 2024 18:12:34 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 16/17] obj: Respect data_len when setting attributes
Date: Tue, 19 Mar 2024 18:12:23 +0100
Message-ID: <20240319171224.18064-17-phil@nwl.cc>
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

With attr_policy in place, data_len has an upper boundary. Use it for
memcpy() calls to cover for caller passing data with lower size than the
attribute's storage.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/obj/counter.c    |  4 ++--
 src/obj/ct_expect.c  | 10 +++++-----
 src/obj/ct_helper.c  |  4 ++--
 src/obj/ct_timeout.c |  4 ++--
 src/obj/limit.c      | 10 +++++-----
 src/obj/quota.c      |  6 +++---
 src/obj/tunnel.c     | 32 ++++++++++++++++----------------
 7 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/src/obj/counter.c b/src/obj/counter.c
index 44524d71b1698..19e09ed41a94a 100644
--- a/src/obj/counter.c
+++ b/src/obj/counter.c
@@ -29,10 +29,10 @@ nftnl_obj_counter_set(struct nftnl_obj *e, uint16_t type,
 
 	switch(type) {
 	case NFTNL_OBJ_CTR_BYTES:
-		memcpy(&ctr->bytes, data, sizeof(ctr->bytes));
+		memcpy(&ctr->bytes, data, data_len);
 		break;
 	case NFTNL_OBJ_CTR_PKTS:
-		memcpy(&ctr->pkts, data, sizeof(ctr->pkts));
+		memcpy(&ctr->pkts, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/obj/ct_expect.c b/src/obj/ct_expect.c
index 978af152c5a8e..b4d6faa810eab 100644
--- a/src/obj/ct_expect.c
+++ b/src/obj/ct_expect.c
@@ -21,19 +21,19 @@ static int nftnl_obj_ct_expect_set(struct nftnl_obj *e, uint16_t type,
 
 	switch (type) {
 	case NFTNL_OBJ_CT_EXPECT_L3PROTO:
-		memcpy(&exp->l3proto, data, sizeof(exp->l3proto));
+		memcpy(&exp->l3proto, data, data_len);
 		break;
 	case NFTNL_OBJ_CT_EXPECT_L4PROTO:
-		memcpy(&exp->l4proto, data, sizeof(exp->l4proto));
+		memcpy(&exp->l4proto, data, data_len);
 		break;
 	case NFTNL_OBJ_CT_EXPECT_DPORT:
-		memcpy(&exp->dport, data, sizeof(exp->dport));
+		memcpy(&exp->dport, data, data_len);
 		break;
 	case NFTNL_OBJ_CT_EXPECT_TIMEOUT:
-		memcpy(&exp->timeout, data, sizeof(exp->timeout));
+		memcpy(&exp->timeout, data, data_len);
 		break;
 	case NFTNL_OBJ_CT_EXPECT_SIZE:
-		memcpy(&exp->size, data, sizeof(exp->size));
+		memcpy(&exp->size, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/obj/ct_helper.c b/src/obj/ct_helper.c
index aa8e9262ec5aa..1feccf20b01b2 100644
--- a/src/obj/ct_helper.c
+++ b/src/obj/ct_helper.c
@@ -32,10 +32,10 @@ static int nftnl_obj_ct_helper_set(struct nftnl_obj *e, uint16_t type,
 		snprintf(helper->name, sizeof(helper->name), "%s", (const char *)data);
 		break;
 	case NFTNL_OBJ_CT_HELPER_L3PROTO:
-		memcpy(&helper->l3proto, data, sizeof(helper->l3proto));
+		memcpy(&helper->l3proto, data, data_len);
 		break;
 	case NFTNL_OBJ_CT_HELPER_L4PROTO:
-		memcpy(&helper->l4proto, data, sizeof(helper->l4proto));
+		memcpy(&helper->l4proto, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/obj/ct_timeout.c b/src/obj/ct_timeout.c
index 88522d8c89bce..b9b688ec7c4bc 100644
--- a/src/obj/ct_timeout.c
+++ b/src/obj/ct_timeout.c
@@ -150,10 +150,10 @@ static int nftnl_obj_ct_timeout_set(struct nftnl_obj *e, uint16_t type,
 
 	switch (type) {
 	case NFTNL_OBJ_CT_TIMEOUT_L3PROTO:
-		memcpy(&timeout->l3proto, data, sizeof(timeout->l3proto));
+		memcpy(&timeout->l3proto, data, data_len);
 		break;
 	case NFTNL_OBJ_CT_TIMEOUT_L4PROTO:
-		memcpy(&timeout->l4proto, data, sizeof(timeout->l4proto));
+		memcpy(&timeout->l4proto, data, data_len);
 		break;
 	case NFTNL_OBJ_CT_TIMEOUT_ARRAY:
 		if (data_len < sizeof(uint32_t) * NFTNL_CTTIMEOUT_ARRAY_MAX)
diff --git a/src/obj/limit.c b/src/obj/limit.c
index 0c7362e55e682..cbf30b480b8fa 100644
--- a/src/obj/limit.c
+++ b/src/obj/limit.c
@@ -28,19 +28,19 @@ static int nftnl_obj_limit_set(struct nftnl_obj *e, uint16_t type,
 
 	switch (type) {
 	case NFTNL_OBJ_LIMIT_RATE:
-		memcpy(&limit->rate, data, sizeof(limit->rate));
+		memcpy(&limit->rate, data, data_len);
 		break;
 	case NFTNL_OBJ_LIMIT_UNIT:
-		memcpy(&limit->unit, data, sizeof(limit->unit));
+		memcpy(&limit->unit, data, data_len);
 		break;
 	case NFTNL_OBJ_LIMIT_BURST:
-		memcpy(&limit->burst, data, sizeof(limit->burst));
+		memcpy(&limit->burst, data, data_len);
 		break;
 	case NFTNL_OBJ_LIMIT_TYPE:
-		memcpy(&limit->type, data, sizeof(limit->type));
+		memcpy(&limit->type, data, data_len);
 		break;
 	case NFTNL_OBJ_LIMIT_FLAGS:
-		memcpy(&limit->flags, data, sizeof(limit->flags));
+		memcpy(&limit->flags, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/obj/quota.c b/src/obj/quota.c
index b48ba91a4df11..526db8e42caa8 100644
--- a/src/obj/quota.c
+++ b/src/obj/quota.c
@@ -28,13 +28,13 @@ static int nftnl_obj_quota_set(struct nftnl_obj *e, uint16_t type,
 
 	switch (type) {
 	case NFTNL_OBJ_QUOTA_BYTES:
-		memcpy(&quota->bytes, data, sizeof(quota->bytes));
+		memcpy(&quota->bytes, data, data_len);
 		break;
 	case NFTNL_OBJ_QUOTA_CONSUMED:
-		memcpy(&quota->consumed, data, sizeof(quota->consumed));
+		memcpy(&quota->consumed, data, data_len);
 		break;
 	case NFTNL_OBJ_QUOTA_FLAGS:
-		memcpy(&quota->flags, data, sizeof(quota->flags));
+		memcpy(&quota->flags, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/obj/tunnel.c b/src/obj/tunnel.c
index 07b3b2ac0cb86..03094109db442 100644
--- a/src/obj/tunnel.c
+++ b/src/obj/tunnel.c
@@ -29,52 +29,52 @@ nftnl_obj_tunnel_set(struct nftnl_obj *e, uint16_t type,
 
 	switch (type) {
 	case NFTNL_OBJ_TUNNEL_ID:
-		memcpy(&tun->id, data, sizeof(tun->id));
+		memcpy(&tun->id, data, data_len);
 		break;
 	case NFTNL_OBJ_TUNNEL_IPV4_SRC:
-		memcpy(&tun->src_v4, data, sizeof(tun->src_v4));
+		memcpy(&tun->src_v4, data, data_len);
 		break;
 	case NFTNL_OBJ_TUNNEL_IPV4_DST:
-		memcpy(&tun->dst_v4, data, sizeof(tun->dst_v4));
+		memcpy(&tun->dst_v4, data, data_len);
 		break;
 	case NFTNL_OBJ_TUNNEL_IPV6_SRC:
-		memcpy(&tun->src_v6, data, sizeof(struct in6_addr));
+		memcpy(&tun->src_v6, data, data_len);
 		break;
 	case NFTNL_OBJ_TUNNEL_IPV6_DST:
-		memcpy(&tun->dst_v6, data, sizeof(struct in6_addr));
+		memcpy(&tun->dst_v6, data, data_len);
 		break;
 	case NFTNL_OBJ_TUNNEL_IPV6_FLOWLABEL:
-		memcpy(&tun->flowlabel, data, sizeof(tun->flowlabel));
+		memcpy(&tun->flowlabel, data, data_len);
 		break;
 	case NFTNL_OBJ_TUNNEL_SPORT:
-		memcpy(&tun->sport, data, sizeof(tun->sport));
+		memcpy(&tun->sport, data, data_len);
 		break;
 	case NFTNL_OBJ_TUNNEL_DPORT:
-		memcpy(&tun->dport, data, sizeof(tun->dport));
+		memcpy(&tun->dport, data, data_len);
 		break;
 	case NFTNL_OBJ_TUNNEL_FLAGS:
-		memcpy(&tun->tun_flags, data, sizeof(tun->tun_flags));
+		memcpy(&tun->tun_flags, data, data_len);
 		break;
 	case NFTNL_OBJ_TUNNEL_TOS:
-		memcpy(&tun->tun_tos, data, sizeof(tun->tun_tos));
+		memcpy(&tun->tun_tos, data, data_len);
 		break;
 	case NFTNL_OBJ_TUNNEL_TTL:
-		memcpy(&tun->tun_ttl, data, sizeof(tun->tun_ttl));
+		memcpy(&tun->tun_ttl, data, data_len);
 		break;
 	case NFTNL_OBJ_TUNNEL_VXLAN_GBP:
-		memcpy(&tun->u.tun_vxlan.gbp, data, sizeof(tun->u.tun_vxlan.gbp));
+		memcpy(&tun->u.tun_vxlan.gbp, data, data_len);
 		break;
 	case NFTNL_OBJ_TUNNEL_ERSPAN_VERSION:
-		memcpy(&tun->u.tun_erspan.version, data, sizeof(tun->u.tun_erspan.version));
+		memcpy(&tun->u.tun_erspan.version, data, data_len);
 		break;
 	case NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX:
-		memcpy(&tun->u.tun_erspan.u.v1_index, data, sizeof(tun->u.tun_erspan.u.v1_index));
+		memcpy(&tun->u.tun_erspan.u.v1_index, data, data_len);
 		break;
 	case NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID:
-		memcpy(&tun->u.tun_erspan.u.v2.hwid, data, sizeof(tun->u.tun_erspan.u.v2.hwid));
+		memcpy(&tun->u.tun_erspan.u.v2.hwid, data, data_len);
 		break;
 	case NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR:
-		memcpy(&tun->u.tun_erspan.u.v2.dir, data, sizeof(tun->u.tun_erspan.u.v2.dir));
+		memcpy(&tun->u.tun_erspan.u.v2.dir, data, data_len);
 		break;
 	}
 	return 0;
-- 
2.43.0

