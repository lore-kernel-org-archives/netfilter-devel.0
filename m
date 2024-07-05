Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83AC714A4C1
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Jul 2024 15:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720192923; cv=none; b=IogDNwMfIPZqqgwbHEykc2F2Wj6CDjQvNDZkGTg31yPBLehMxPkXiUCGGc8M9uJG+M7gN9jl54njrF4a6yfMeK25/8u0xuEbcB6MAVZjnohNbEMeEpAkW2ZBKe0iqwHQ67NrqJu7Vo6XjiSyrm9iiHoqkCeGgC0DXxua6l0Ag54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720192923; c=relaxed/simple;
	bh=3Pl5mHG2XWogAUPvKNqWjRTZOn1GQTnpz9rcbjCt9gQ=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=pAK80KWEYRCTDThkuJ1UTQ3brPv5oYPeQf20WxEh7tnvIjar1UACY7IXI7YGZrHT6ssZiyng1pOrxM79SFxRx4YmD6hGIDz5lNy/Dy1JZI4E7HgQrP451N3FCi+XHc10T50Z2ywPF1tyDvwwxJVGjLKDGItnxV7tlQ3MxJYS4us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl] expr: use NFTA_* netlink attributes to build fields, not NFTNL_EXPR_*
Date: Fri,  5 Jul 2024 17:21:56 +0200
Message-Id: <20240705152156.464505-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Coincidentally NFTNL_EXPR_BASE starts at 1 which comes right after
NFTA_*_UNSPEC which is zero. And NFTNL_EXPR_ attribute values were
mapping to NFTA_* attributes.

Use NFTA_* for netlink attribute types instead.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expr/osf.c      | 6 +++---
 src/expr/synproxy.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/expr/osf.c b/src/expr/osf.c
index 060394b30329..293a81420a32 100644
--- a/src/expr/osf.c
+++ b/src/expr/osf.c
@@ -89,12 +89,12 @@ nftnl_expr_osf_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 	struct nftnl_expr_osf *osf = nftnl_expr_data(e);
 
 	if (e->flags & (1 << NFTNL_EXPR_OSF_DREG))
-		mnl_attr_put_u32(nlh, NFTNL_EXPR_OSF_DREG, htonl(osf->dreg));
+		mnl_attr_put_u32(nlh, NFTA_OSF_DREG, htonl(osf->dreg));
 	if (e->flags & (1 << NFTNL_EXPR_OSF_TTL))
-		mnl_attr_put_u8(nlh, NFTNL_EXPR_OSF_TTL, osf->ttl);
+		mnl_attr_put_u8(nlh, NFTA_OSF_TTL, osf->ttl);
 	if (e->flags & (1 << NFTNL_EXPR_OSF_FLAGS))
 		if (osf->flags)
-			mnl_attr_put_u32(nlh, NFTNL_EXPR_OSF_FLAGS, htonl(osf->flags));
+			mnl_attr_put_u32(nlh, NFTA_OSF_FLAGS, htonl(osf->flags));
 }
 
 static int
diff --git a/src/expr/synproxy.c b/src/expr/synproxy.c
index 97c321b994fe..b5a1fef9f406 100644
--- a/src/expr/synproxy.c
+++ b/src/expr/synproxy.c
@@ -90,13 +90,13 @@ nftnl_expr_synproxy_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 	struct nftnl_expr_synproxy *synproxy = nftnl_expr_data(e);
 
 	if (e->flags & (1 << NFTNL_EXPR_SYNPROXY_MSS))
-		mnl_attr_put_u16(nlh, NFTNL_EXPR_SYNPROXY_MSS,
+		mnl_attr_put_u16(nlh, NFTA_SYNPROXY_MSS,
 				 htons(synproxy->mss));
 	if (e->flags & (1 << NFTNL_EXPR_SYNPROXY_WSCALE))
-		mnl_attr_put_u8(nlh, NFTNL_EXPR_SYNPROXY_WSCALE,
+		mnl_attr_put_u8(nlh, NFTA_SYNPROXY_WSCALE,
 				synproxy->wscale);
 	if (e->flags & (1 << NFTNL_EXPR_SYNPROXY_FLAGS))
-		mnl_attr_put_u32(nlh, NFTNL_EXPR_SYNPROXY_FLAGS,
+		mnl_attr_put_u32(nlh, NFTA_SYNPROXY_FLAGS,
 				 htonl(synproxy->flags));
 }
 
-- 
2.30.2

