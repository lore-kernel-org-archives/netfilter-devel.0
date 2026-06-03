Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54ADF48BD21
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Jun 2026 19:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780514974; cv=none; b=AAk087QzZsb4J3JBfN7lJjBIumi8rYIoTr7OHqnpGq5sx64yzTqzsrQwSaRqHH8GaRz6p0qT1nRDce7xF7DY7lRwRYyt0/BQYqk6ivQRp1jVllvgSIwedT/HUTGemWJD6frfsVP2DrFQD2MCD6ysBc/TTrcl1z/fXngroSiuq0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780514974; c=relaxed/simple;
	bh=IrgOH9iORTVtmENBbIj/Q5sPzIJ2HqopPG7YrMlt8ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwhudfXNktNgBtBbV0CAGhtVTuvAJiS+tb8Ei+gRRJU+VEOgMOs7UOM/78nBi4zQksd8775hdonhji9k6Q4sZXSzQhmp8yaCqXcflS7RVdTPucVuOU0SMQgJektell+GhXdZTL4gPFe56ZOdfut1wFqmczWcZUX/yTi8wTixsas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=jnDOcv67; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="jnDOcv67"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=upR0ilaS47n/XHMV7PNh+azvIb0GZV6nO4fp5AzBq/8=; b=jnDOcv67yNlBtDqwCZw4UMm+U0
	6zoid7Nb7ErY2hD4pr4ECc5dkgVLZ0kiw4ExdL6de2sj2/mnHyslwtV2zkgaKSkVpZ/dyldqhgeKT
	uhQwNJ/9N9VwIkPOXTjN5KfvAOBDjWtPwraE75mlth1a9p5pn5WuC2W07jROk/XH27bZhK8zx1bi/
	K8pJXIhNWdB/3Km2DlBXpRUkPZqj2qizSkUAq3iRiYT/XCVE6P6yy0WUMP0O1oYld/dMzjx73ZHOC
	1HyF8z3ILRwsAiKQY1YAbPzUjYcMZYYnEolC7GdVJoSkv824UkVlp85L9JNW7d0VPtW/UlvrAShRH
	Kn511fyg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wUrHO-00000000345-3dG2;
	Wed, 03 Jun 2026 21:29:30 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 5/6] src: Avoid variable declarations in switch cases
Date: Wed,  3 Jun 2026 21:29:22 +0200
Message-ID: <20260603192923.1378815-6-phil@nwl.cc>
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

Older compilers reject this, so fix up the remaining two cases after
previous patches.

Fixes: 59f03bf14835f ("tunnel: add geneve support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/mnl.c     |  3 +--
 src/netlink.c | 11 +++++------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index b9efd3cfd3cea..364773c5642c6 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1544,6 +1544,7 @@ static void obj_tunnel_add_opts(struct nftnl_obj *nlo, struct tunnel *tunnel)
 {
 	struct nftnl_tunnel_opts *opts;
 	struct nftnl_tunnel_opt *opt;
+	struct tunnel_geneve *geneve;
 
 	switch (tunnel->type) {
 	case TUNNEL_ERSPAN:
@@ -1594,8 +1595,6 @@ static void obj_tunnel_add_opts(struct nftnl_obj *nlo, struct tunnel *tunnel)
 		nftnl_obj_set_data(nlo, NFTNL_OBJ_TUNNEL_OPTS, &opts, sizeof(struct nftnl_tunnel_opts *));
 		break;
 	case TUNNEL_GENEVE:
-		struct tunnel_geneve *geneve;
-
 		opts = nftnl_tunnel_opts_alloc(NFTNL_TUNNEL_TYPE_GENEVE);
 		if (!opts)
 			memory_allocation_error();
diff --git a/src/netlink.c b/src/netlink.c
index 5e59cb7b2d8f2..5c263f39791f1 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1905,7 +1905,9 @@ static int obj_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 
 static int tunnel_parse_opt_cb(struct nftnl_tunnel_opt *opt, void *data) {
 
+	struct tunnel_geneve *geneve;
 	struct obj *obj = data;
+	const void *gnv_data;
 
 	switch (nftnl_tunnel_opt_get_type(opt)) {
 	case NFTNL_TUNNEL_TYPE_ERSPAN:
@@ -1939,9 +1941,6 @@ static int tunnel_parse_opt_cb(struct nftnl_tunnel_opt *opt, void *data) {
 		}
 		break;
 	case NFTNL_TUNNEL_TYPE_GENEVE:
-		struct tunnel_geneve *geneve;
-		const void *data;
-
 		if (!obj->tunnel.type) {
 			init_list_head(&obj->tunnel.geneve_opts);
 			obj->tunnel.type = TUNNEL_GENEVE;
@@ -1958,11 +1957,11 @@ static int tunnel_parse_opt_cb(struct nftnl_tunnel_opt *opt, void *data) {
 			geneve->geneve_class = nftnl_tunnel_opt_get_u16(opt, NFTNL_TUNNEL_GENEVE_CLASS);
 
 		if (nftnl_tunnel_opt_get_flags(opt) & (1 << NFTNL_TUNNEL_GENEVE_DATA)) {
-			data = nftnl_tunnel_opt_get_data(opt, NFTNL_TUNNEL_GENEVE_DATA,
+			gnv_data = nftnl_tunnel_opt_get_data(opt, NFTNL_TUNNEL_GENEVE_DATA,
 							 &geneve->data_len);
-			if (!data)
+			if (!gnv_data)
 				return -1;
-			memcpy(&geneve->data, data, geneve->data_len);
+			memcpy(&geneve->data, gnv_data, geneve->data_len);
 		}
 
 		list_add_tail(&geneve->list, &obj->tunnel.geneve_opts);
-- 
2.54.0

