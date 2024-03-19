Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A782B9B8
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2024 17:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710868353; cv=none; b=oAfmSoasxxJBssw33oLDSfHFSIDgklzX5CGhnnHJVHDNZdtQeGVQcXaEXr0JoRlZTd7FbEBIictgzhw9Ym4MAUCXROHmsTxBEbH0XQLzW2JzOm8vfh7CfM2ASqNgGWyhXJaoTp/ElkRwcFA+8QSkpx2MGBmIWTVDdcTLsJYtRZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710868353; c=relaxed/simple;
	bh=c9JlJzxkggqE4WPrMycloVCZFPDHoIYLJ/kc28bmLIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJBfhKP7hPO2pmNzjAtmwXV1/fbbtSaNqYoZ2vo2hRfEM2FwSFrqF/EN0P7wKE9BIly21nwh/bWhe3GhNel/CEQIttOMToi54cV7EFO+2s0RfRDxvK7EFCyKm/UpiTDGLJycNiBU/O4DNJ9UV3/QXDWcKimjOI/UjHLG7m3oOM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=cK2PSB8C; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="cK2PSB8C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/jy9wyeXyeT342fePO1m8rJRSAN2HmgH5xK960/57m4=; b=cK2PSB8CELcHVjb172Wjs8RCAq
	z+4wGVGG/Yzjxp4Pezy5UFf/d2LdfmgKEG/twLzgt1HyKiXLZGLKmXc8kz1k3g7NtmMEOntq/fDGM
	T/7lEyIy8OkSE/2J1rNA70Vml/8sBcPHI6bbFPn2G5mTuPRNrlsUwcXZ4BiZUd//Vz1S0HGtedZ79
	y/xhS+sG0/owmIwRovtVlXReMLyPWihrHrpMYX4RXstmaoU2+gu2VODk2XO8/ayy6q5hXisVW63qr
	2+6Csj+SLDEjaYqc3hzTtEv+v4BrYPSsMiWyr4Dg9Utp/DUlHDqQRdM+5saU+mtDJi2xbJ6/6WDGh
	2XT67eFA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rmd0n-000000007fh-3p9A;
	Tue, 19 Mar 2024 18:12:29 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 11/17] obj: Repurpose struct obj_ops::max_attr field
Date: Tue, 19 Mar 2024 18:12:18 +0100
Message-ID: <20240319171224.18064-12-phil@nwl.cc>
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

Just like with struct expr_ops::max_attr, make it hold the maximum
object attribute (NFTNL_OBJ_*) value supported by this object type.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/libnftnl/object.h | 9 +++++++++
 include/obj.h             | 2 +-
 src/obj/counter.c         | 2 +-
 src/obj/ct_expect.c       | 2 +-
 src/obj/ct_helper.c       | 2 +-
 src/obj/ct_timeout.c      | 2 +-
 src/obj/limit.c           | 2 +-
 src/obj/quota.c           | 2 +-
 src/obj/secmark.c         | 2 +-
 src/obj/synproxy.c        | 2 +-
 src/obj/tunnel.c          | 2 +-
 11 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/include/libnftnl/object.h b/include/libnftnl/object.h
index e235fdf3b4d45..9930355bb8f0d 100644
--- a/include/libnftnl/object.h
+++ b/include/libnftnl/object.h
@@ -28,18 +28,21 @@ enum {
 enum {
 	NFTNL_OBJ_CTR_PKTS	= NFTNL_OBJ_BASE,
 	NFTNL_OBJ_CTR_BYTES,
+	__NFTNL_OBJ_CTR_MAX,
 };
 
 enum {
 	NFTNL_OBJ_QUOTA_BYTES	= NFTNL_OBJ_BASE,
 	NFTNL_OBJ_QUOTA_CONSUMED,
 	NFTNL_OBJ_QUOTA_FLAGS,
+	__NFTNL_OBJ_QUOTA_MAX,
 };
 
 enum {
 	NFTNL_OBJ_CT_HELPER_NAME = NFTNL_OBJ_BASE,
 	NFTNL_OBJ_CT_HELPER_L3PROTO,
 	NFTNL_OBJ_CT_HELPER_L4PROTO,
+	__NFTNL_OBJ_CT_HELPER_MAX,
 };
 
 enum nftnl_cttimeout_array_tcp {
@@ -69,6 +72,7 @@ enum {
 	NFTNL_OBJ_CT_TIMEOUT_L3PROTO = NFTNL_OBJ_BASE,
 	NFTNL_OBJ_CT_TIMEOUT_L4PROTO,
 	NFTNL_OBJ_CT_TIMEOUT_ARRAY,
+	__NFTNL_OBJ_CT_TIMEOUT_MAX,
 };
 
 enum {
@@ -77,6 +81,7 @@ enum {
 	NFTNL_OBJ_CT_EXPECT_DPORT,
 	NFTNL_OBJ_CT_EXPECT_TIMEOUT,
 	NFTNL_OBJ_CT_EXPECT_SIZE,
+	__NFTNL_OBJ_CT_EXPECT_MAX,
 };
 
 enum {
@@ -85,12 +90,14 @@ enum {
 	NFTNL_OBJ_LIMIT_BURST,
 	NFTNL_OBJ_LIMIT_TYPE,
 	NFTNL_OBJ_LIMIT_FLAGS,
+	__NFTNL_OBJ_LIMIT_MAX,
 };
 
 enum {
 	NFTNL_OBJ_SYNPROXY_MSS	= NFTNL_OBJ_BASE,
 	NFTNL_OBJ_SYNPROXY_WSCALE,
 	NFTNL_OBJ_SYNPROXY_FLAGS,
+	__NFTNL_OBJ_SYNPROXY_MAX,
 };
 
 enum {
@@ -110,10 +117,12 @@ enum {
 	NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX,
 	NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID,
 	NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR,
+	__NFTNL_OBJ_TUNNEL_MAX,
 };
 
 enum {
 	NFTNL_OBJ_SECMARK_CTX	= NFTNL_OBJ_BASE,
+	__NFTNL_OBJ_SECMARK_MAX,
 };
 
 struct nftnl_obj;
diff --git a/include/obj.h b/include/obj.h
index d848ac98979d9..6d2af8d5527d3 100644
--- a/include/obj.h
+++ b/include/obj.h
@@ -104,7 +104,7 @@ struct obj_ops {
 	const char *name;
 	uint32_t type;
 	size_t	alloc_len;
-	int	max_attr;
+	int	nftnl_max_attr;
 	int	(*set)(struct nftnl_obj *e, uint16_t type, const void *data, uint32_t data_len);
 	const void *(*get)(const struct nftnl_obj *e, uint16_t type, uint32_t *data_len);
 	int	(*parse)(struct nftnl_obj *e, struct nlattr *attr);
diff --git a/src/obj/counter.c b/src/obj/counter.c
index ebf3e74f96737..76a1b20f19c30 100644
--- a/src/obj/counter.c
+++ b/src/obj/counter.c
@@ -122,7 +122,7 @@ struct obj_ops obj_ops_counter = {
 	.name		= "counter",
 	.type		= NFT_OBJECT_COUNTER,
 	.alloc_len	= sizeof(struct nftnl_obj_counter),
-	.max_attr	= NFTA_COUNTER_MAX,
+	.nftnl_max_attr	= __NFTNL_OBJ_CTR_MAX - 1,
 	.set		= nftnl_obj_counter_set,
 	.get		= nftnl_obj_counter_get,
 	.parse		= nftnl_obj_counter_parse,
diff --git a/src/obj/ct_expect.c b/src/obj/ct_expect.c
index 810ba9af98ab8..7e9c5e1b9e48c 100644
--- a/src/obj/ct_expect.c
+++ b/src/obj/ct_expect.c
@@ -191,7 +191,7 @@ struct obj_ops obj_ops_ct_expect = {
 	.name		= "ct_expect",
 	.type		= NFT_OBJECT_CT_EXPECT,
 	.alloc_len	= sizeof(struct nftnl_obj_ct_expect),
-	.max_attr	= NFTA_CT_EXPECT_MAX,
+	.nftnl_max_attr	= __NFTNL_OBJ_CT_EXPECT_MAX - 1,
 	.set		= nftnl_obj_ct_expect_set,
 	.get		= nftnl_obj_ct_expect_get,
 	.parse		= nftnl_obj_ct_expect_parse,
diff --git a/src/obj/ct_helper.c b/src/obj/ct_helper.c
index a31bd6facccf9..f8aa73408839c 100644
--- a/src/obj/ct_helper.c
+++ b/src/obj/ct_helper.c
@@ -145,7 +145,7 @@ struct obj_ops obj_ops_ct_helper = {
 	.name		= "ct_helper",
 	.type		= NFT_OBJECT_CT_HELPER,
 	.alloc_len	= sizeof(struct nftnl_obj_ct_helper),
-	.max_attr	= NFTA_CT_HELPER_MAX,
+	.nftnl_max_attr	= __NFTNL_OBJ_CT_HELPER_MAX - 1,
 	.set		= nftnl_obj_ct_helper_set,
 	.get		= nftnl_obj_ct_helper_get,
 	.parse		= nftnl_obj_ct_helper_parse,
diff --git a/src/obj/ct_timeout.c b/src/obj/ct_timeout.c
index fedf9e38b7ac1..ee86231f42965 100644
--- a/src/obj/ct_timeout.c
+++ b/src/obj/ct_timeout.c
@@ -314,7 +314,7 @@ struct obj_ops obj_ops_ct_timeout = {
 	.name		= "ct_timeout",
 	.type		= NFT_OBJECT_CT_TIMEOUT,
 	.alloc_len	= sizeof(struct nftnl_obj_ct_timeout),
-	.max_attr	= NFTA_CT_TIMEOUT_MAX,
+	.nftnl_max_attr	= __NFTNL_OBJ_CT_TIMEOUT_MAX - 1,
 	.set		= nftnl_obj_ct_timeout_set,
 	.get		= nftnl_obj_ct_timeout_get,
 	.parse		= nftnl_obj_ct_timeout_parse,
diff --git a/src/obj/limit.c b/src/obj/limit.c
index d7b1aed830d82..1c54bbca72fef 100644
--- a/src/obj/limit.c
+++ b/src/obj/limit.c
@@ -163,7 +163,7 @@ struct obj_ops obj_ops_limit = {
 	.name		= "limit",
 	.type		= NFT_OBJECT_LIMIT,
 	.alloc_len	= sizeof(struct nftnl_obj_limit),
-	.max_attr	= NFTA_LIMIT_MAX,
+	.nftnl_max_attr	= __NFTNL_OBJ_LIMIT_MAX - 1,
 	.set		= nftnl_obj_limit_set,
 	.get		= nftnl_obj_limit_get,
 	.parse		= nftnl_obj_limit_parse,
diff --git a/src/obj/quota.c b/src/obj/quota.c
index 6c7559a2ce827..a39d552d923f2 100644
--- a/src/obj/quota.c
+++ b/src/obj/quota.c
@@ -139,7 +139,7 @@ struct obj_ops obj_ops_quota = {
 	.name		= "quota",
 	.type		= NFT_OBJECT_QUOTA,
 	.alloc_len	= sizeof(struct nftnl_obj_quota),
-	.max_attr	= NFTA_QUOTA_MAX,
+	.nftnl_max_attr	= __NFTNL_OBJ_QUOTA_MAX - 1,
 	.set		= nftnl_obj_quota_set,
 	.get		= nftnl_obj_quota_get,
 	.parse		= nftnl_obj_quota_parse,
diff --git a/src/obj/secmark.c b/src/obj/secmark.c
index e5c24b35a7eb6..c78e35f2c284f 100644
--- a/src/obj/secmark.c
+++ b/src/obj/secmark.c
@@ -111,7 +111,7 @@ struct obj_ops obj_ops_secmark = {
 	.name		= "secmark",
 	.type		= NFT_OBJECT_SECMARK,
 	.alloc_len	= sizeof(struct nftnl_obj_secmark),
-	.max_attr	= NFTA_SECMARK_MAX,
+	.nftnl_max_attr	= __NFTNL_OBJ_SECMARK_MAX - 1,
 	.set		= nftnl_obj_secmark_set,
 	.get		= nftnl_obj_secmark_get,
 	.parse		= nftnl_obj_secmark_parse,
diff --git a/src/obj/synproxy.c b/src/obj/synproxy.c
index 4ef97ece9306d..d259a517bebbf 100644
--- a/src/obj/synproxy.c
+++ b/src/obj/synproxy.c
@@ -138,7 +138,7 @@ struct obj_ops obj_ops_synproxy = {
 	.name		= "synproxy",
 	.type		= NFT_OBJECT_SYNPROXY,
 	.alloc_len	= sizeof(struct nftnl_obj_synproxy),
-	.max_attr	= NFTA_SYNPROXY_MAX,
+	.nftnl_max_attr	= __NFTNL_OBJ_SYNPROXY_MAX - 1,
 	.set		= nftnl_obj_synproxy_set,
 	.get		= nftnl_obj_synproxy_get,
 	.parse		= nftnl_obj_synproxy_parse,
diff --git a/src/obj/tunnel.c b/src/obj/tunnel.c
index d2503dccaf8dd..19a3639eafc01 100644
--- a/src/obj/tunnel.c
+++ b/src/obj/tunnel.c
@@ -542,7 +542,7 @@ struct obj_ops obj_ops_tunnel = {
 	.name		= "tunnel",
 	.type		= NFT_OBJECT_TUNNEL,
 	.alloc_len	= sizeof(struct nftnl_obj_tunnel),
-	.max_attr	= NFTA_TUNNEL_KEY_MAX,
+	.nftnl_max_attr	= __NFTNL_OBJ_TUNNEL_MAX - 1,
 	.set		= nftnl_obj_tunnel_set,
 	.get		= nftnl_obj_tunnel_get,
 	.parse		= nftnl_obj_tunnel_parse,
-- 
2.43.0

