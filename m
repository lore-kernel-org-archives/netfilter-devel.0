Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBE539E176
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Jun 2026 19:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780514974; cv=none; b=uAb8N6EG/sNWppuUkXHZ4cHWQQrhIN7Mpx7Oq92HD+cZTxnqChWlfUOKSXvF8PSn+X89FEdyslGWd0FIAuuLc0qOckk2ZXX/z5mMOnWOYBSVSoPTGWIKQdcmMmWJmMKYAmaYG8GsmOVtjdc+RBtGLZhfvdlUJBLcCUXUIIwJopE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780514974; c=relaxed/simple;
	bh=IEbjiJA5bnQaWyLwl601i2OOjjiyikkgGGSsHUhr4uQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhFHAUh71fhWFw2nIrkwYRYN6nadMtjHPTFAake45UmFzOkuBvkQnU3z9PnwfhLZwIOX4xM/HbLME6tEtFtmsU1WtWaimlGudoYoJD4ihTZQI+TNiUjK8UcmqFbZ5RTSAgcbsxN9SPVERtXiCW8GChopMZlQQAf0ixpd7UZ2u6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=WVtl2Tfy; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="WVtl2Tfy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ymSo7eidDIXfto9PZdMYwvkViYh3s5CQ4NXQgSlUtk8=; b=WVtl2TfyJYe+HIKj9OS4eNvM4+
	PvEj/El8FKXDPwH7viQN8iYK01PP4Ijeif42a9bJG2X7Gl4KhujOj6WZAbfufYc9fUJyci4HxrVlo
	yCLv+yO6pcWfcx9GkoHAQ9tU4QfSux4kt24WqZ3RgwUlQVGAC9IhGDtQTQ49k4EEXoXzJIFN1mT4c
	e013kE076ZTq6ict08495sqHJYT20zAKabTTJWUfAEg2lNnO631cWammJgBVdFUycVs8IORK5i1D7
	sdTQY1UyTRWRC/lDCsVwUcmOy7okriYh9YRENcG5wB3v8jd7W3XwTn8uAOdRR2bhs3WtIxjex5UDI
	m6JTt7MQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wUrHO-00000000340-1ajm;
	Wed, 03 Jun 2026 21:29:30 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 6/6] netlink: Call tunnel getters unconditionally
Date: Wed,  3 Jun 2026 21:29:23 +0200
Message-ID: <20260603192923.1378815-7-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260603192923.1378815-1-phil@nwl.cc>
References: <20260603192923.1378815-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All the nftnl_obj_get_u*() and nftnl_tunnel_opt_get_u*() functions
return 0 if the attribute is not present. Since 'obj' is zeroed upon
allocation and no unions are used within per object or tunnel type data,
assigning that value won't change behaviour.

Keep the check before calling nftnl_obj_tunnel_opts_foreach though. It
looks like that function does not check tun->tun_opts before
dereferencing it.

Also make sure obj->tunnel.{src,dst} is not initialized twice (once for
IPv4 and once for IPv6) which happens if merely the _is_set() check is
removed. Let netlink_obj_tunnel_parse_addr() choose between two
attributes to use and so assign just once to each of the fields.

Fixes: 35d9c77c57452 ("src: add tunnel template support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/netlink.c | 106 ++++++++++++++++++++------------------------------
 1 file changed, 42 insertions(+), 64 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 5c263f39791f1..57f4b7c0edea1 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1842,7 +1842,7 @@ void netlink_dump_obj(struct nftnl_obj *nln, struct netlink_ctx *ctx)
 static struct in6_addr all_zeroes;
 
 static struct expr *
-netlink_obj_tunnel_parse_addr(struct nftnl_obj *nlo, int attr)
+netlink_obj_tunnel_parse_addr(struct nftnl_obj *nlo, int attr, int alt_attr)
 {
 	struct nft_data_delinearize nld;
 	const struct datatype *dtype;
@@ -1850,6 +1850,13 @@ netlink_obj_tunnel_parse_addr(struct nftnl_obj *nlo, int attr)
 	struct expr *expr;
 	uint32_t addr;
 
+	if (!nftnl_obj_is_set(nlo, attr)) {
+		if (!nftnl_obj_is_set(nlo, alt_attr))
+			return NULL;
+		else
+			attr = alt_attr;
+	}
+
 	memset(&nld, 0, sizeof(nld));
 
 	switch (attr) {
@@ -1912,33 +1919,23 @@ static int tunnel_parse_opt_cb(struct nftnl_tunnel_opt *opt, void *data) {
 	switch (nftnl_tunnel_opt_get_type(opt)) {
 	case NFTNL_TUNNEL_TYPE_ERSPAN:
 		obj->tunnel.type = TUNNEL_ERSPAN;
-		if (nftnl_tunnel_opt_get_flags(opt) & (1 << NFTNL_TUNNEL_ERSPAN_VERSION)) {
-			obj->tunnel.erspan.version =
-				nftnl_tunnel_opt_get_u32(opt,
-							 NFTNL_TUNNEL_ERSPAN_VERSION);
-		}
-		if (nftnl_tunnel_opt_get_flags(opt) & (1 << NFTNL_TUNNEL_ERSPAN_V1_INDEX)) {
-			obj->tunnel.erspan.v1.index =
-				nftnl_tunnel_opt_get_u32(opt,
-							 NFTNL_TUNNEL_ERSPAN_V1_INDEX);
-		}
-		if (nftnl_tunnel_opt_get_flags(opt) & (1 << NFTNL_TUNNEL_ERSPAN_V2_HWID)) {
-			obj->tunnel.erspan.v2.hwid =
-				nftnl_tunnel_opt_get_u8(opt,
-							NFTNL_TUNNEL_ERSPAN_V2_HWID);
-		}
-		if (nftnl_tunnel_opt_get_flags(opt) & (1 << NFTNL_TUNNEL_ERSPAN_V2_DIR)) {
-			obj->tunnel.erspan.v2.direction =
-				nftnl_tunnel_opt_get_u8(opt,
-							NFTNL_TUNNEL_ERSPAN_V2_DIR);
-		}
+		obj->tunnel.erspan.version =
+			nftnl_tunnel_opt_get_u32(opt,
+						 NFTNL_TUNNEL_ERSPAN_VERSION);
+		obj->tunnel.erspan.v1.index =
+			nftnl_tunnel_opt_get_u32(opt,
+						 NFTNL_TUNNEL_ERSPAN_V1_INDEX);
+		obj->tunnel.erspan.v2.hwid =
+			nftnl_tunnel_opt_get_u8(opt,
+						NFTNL_TUNNEL_ERSPAN_V2_HWID);
+		obj->tunnel.erspan.v2.direction =
+			nftnl_tunnel_opt_get_u8(opt,
+						NFTNL_TUNNEL_ERSPAN_V2_DIR);
 		break;
 	case NFTNL_TUNNEL_TYPE_VXLAN:
 		obj->tunnel.type = TUNNEL_VXLAN;
-		if (nftnl_tunnel_opt_get_flags(opt) & (1 << NFTNL_TUNNEL_VXLAN_GBP)) {
-			obj->tunnel.type = TUNNEL_VXLAN;
-			obj->tunnel.vxlan.gbp = nftnl_tunnel_opt_get_u32(opt, NFTNL_TUNNEL_VXLAN_GBP);
-		}
+		obj->tunnel.vxlan.gbp =
+			nftnl_tunnel_opt_get_u32(opt, NFTNL_TUNNEL_VXLAN_GBP);
 		break;
 	case NFTNL_TUNNEL_TYPE_GENEVE:
 		if (!obj->tunnel.type) {
@@ -1950,11 +1947,11 @@ static int tunnel_parse_opt_cb(struct nftnl_tunnel_opt *opt, void *data) {
 		if (!geneve)
 			memory_allocation_error();
 
-		if (nftnl_tunnel_opt_get_flags(opt) & (1 << NFTNL_TUNNEL_GENEVE_TYPE))
-			geneve->type = nftnl_tunnel_opt_get_u8(opt, NFTNL_TUNNEL_GENEVE_TYPE);
-
-		if (nftnl_tunnel_opt_get_flags(opt) & (1 << NFTNL_TUNNEL_GENEVE_CLASS))
-			geneve->geneve_class = nftnl_tunnel_opt_get_u16(opt, NFTNL_TUNNEL_GENEVE_CLASS);
+		geneve->type =
+			nftnl_tunnel_opt_get_u8(opt, NFTNL_TUNNEL_GENEVE_TYPE);
+		geneve->geneve_class =
+			nftnl_tunnel_opt_get_u16(opt,
+						 NFTNL_TUNNEL_GENEVE_CLASS);
 
 		if (nftnl_tunnel_opt_get_flags(opt) & (1 << NFTNL_TUNNEL_GENEVE_DATA)) {
 			gnv_data = nftnl_tunnel_opt_get_data(opt, NFTNL_TUNNEL_GENEVE_DATA,
@@ -2069,40 +2066,21 @@ struct obj *netlink_delinearize_obj(struct netlink_ctx *ctx,
 			nftnl_obj_get_u32(nlo, NFTNL_OBJ_SYNPROXY_FLAGS);
 		break;
 	case NFT_OBJECT_TUNNEL:
-		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_ID))
-			obj->tunnel.id = nftnl_obj_get_u32(nlo, NFTNL_OBJ_TUNNEL_ID);
-		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_SPORT)) {
-			obj->tunnel.sport =
-				nftnl_obj_get_u16(nlo, NFTNL_OBJ_TUNNEL_SPORT);
-		}
-		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_DPORT)) {
-			obj->tunnel.dport =
-				nftnl_obj_get_u16(nlo, NFTNL_OBJ_TUNNEL_DPORT);
-		}
-		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_TOS)) {
-			obj->tunnel.tos =
-				nftnl_obj_get_u8(nlo, NFTNL_OBJ_TUNNEL_TOS);
-		}
-		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_TTL)) {
-			obj->tunnel.ttl =
-				nftnl_obj_get_u8(nlo, NFTNL_OBJ_TUNNEL_TTL);
-		}
-		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_IPV4_SRC)) {
-			obj->tunnel.src =
-				netlink_obj_tunnel_parse_addr(nlo, NFTNL_OBJ_TUNNEL_IPV4_SRC);
-		}
-		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_IPV4_DST)) {
-			obj->tunnel.dst =
-				netlink_obj_tunnel_parse_addr(nlo, NFTNL_OBJ_TUNNEL_IPV4_DST);
-		}
-		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_IPV6_SRC)) {
-			obj->tunnel.src =
-				netlink_obj_tunnel_parse_addr(nlo, NFTNL_OBJ_TUNNEL_IPV6_SRC);
-		}
-		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_IPV6_DST)) {
-			obj->tunnel.dst =
-				netlink_obj_tunnel_parse_addr(nlo, NFTNL_OBJ_TUNNEL_IPV6_DST);
-		}
+		obj->tunnel.id = nftnl_obj_get_u32(nlo, NFTNL_OBJ_TUNNEL_ID);
+		obj->tunnel.sport =
+			nftnl_obj_get_u16(nlo, NFTNL_OBJ_TUNNEL_SPORT);
+		obj->tunnel.dport =
+			nftnl_obj_get_u16(nlo, NFTNL_OBJ_TUNNEL_DPORT);
+		obj->tunnel.tos = nftnl_obj_get_u8(nlo, NFTNL_OBJ_TUNNEL_TOS);
+		obj->tunnel.ttl = nftnl_obj_get_u8(nlo, NFTNL_OBJ_TUNNEL_TTL);
+		obj->tunnel.src =
+			netlink_obj_tunnel_parse_addr(nlo,
+						      NFTNL_OBJ_TUNNEL_IPV6_SRC,
+						      NFTNL_OBJ_TUNNEL_IPV4_SRC);
+		obj->tunnel.dst =
+			netlink_obj_tunnel_parse_addr(nlo,
+						      NFTNL_OBJ_TUNNEL_IPV6_DST,
+						      NFTNL_OBJ_TUNNEL_IPV4_DST);
 		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_OPTS)) {
 			nftnl_obj_tunnel_opts_foreach(nlo, tunnel_parse_opt_cb, obj);
 		}
-- 
2.54.0

