Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5916F48B373
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Jun 2026 19:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780514974; cv=none; b=TsMFpsNxl6dW6aDDQqJDCeTAD0WQzB9OQ+ALzTUCpRX3JP6Z7HQmVieM57suHb1dn6JGV5th1veXxoaaXZa4AM73FnBFkZRoSSAflFDFAPkVcRQz0mw3aiiufj6RLVJ9LJEBPwhp3UUbbRZ1MA0GOPk3na6TNLuN6l7WeepXwFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780514974; c=relaxed/simple;
	bh=8LIg1bHP2gZjXz+nW6xDyz7GsIoFYc3lgJ1e8pbwpSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCYN29DyeIYlQ/4D3aeKYLrYXXRF7MxW7YYXtNXA3ieheo0GX4Lfw3SvW4gzkAcehgfPj1DSgmHFi3x1V/V5c7s1hSo3sB9SdUkIN0iMUaN9mHnGaMiGgApsMEgxpbEPMXTDlQYSivK2VHAdtmLUpBTSgurfg4Hx5trWAW56lvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=fpJvrXuf; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="fpJvrXuf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pLuUSIQ56JLPVpWeQv5thhKz31V3nD/t9kVHhWzZfPw=; b=fpJvrXufMRPR2y7W3se5jKpE1v
	ol8f6KIjaaBoXrcKZc0Y/JsMgfmA5fdbdEo0d3z1PIKty3JPNallHE/l5cZylZn61s5vnC/DGI6pF
	tR+NAhO8shz8/ZObZVVSeBoa6PtN9+D88Y0cA4UhBA6+pIn+HD/kMhlF3msR3LmXvdvpdjws0Y/gq
	FQ+mRoR9yToNGzpAGkGm/QU3TlPrIFnwViUBEos0o8VpcbFBEy+ZfEXuh2JcSQLG8vybdTbeY6eOq
	DK0D+wjoX3W+iUAt2nW7RvnK3gi7aAwoc9ea3eqMwkbOiEc+NjnMbFtf2+515c68rs10FvJcvYwdC
	MomUlH/Q==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wUrHN-0000000033v-3lfy;
	Wed, 03 Jun 2026 21:29:29 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 4/6] rule: Introduce tunnel_obj_print_data()
Date: Wed,  3 Jun 2026 21:29:21 +0200
Message-ID: <20260603192923.1378815-5-phil@nwl.cc>
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

Move tunnel object printing into its own function to reduce size of
obj_print_data().

While at it, merge closing brace printing which also fixes broken syntax
in case of unexpected tunnel type.

Also move declaration of 'geneve' variable on top of the function. Older
compilers complain about the declaration inside a switch-case.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/rule.c | 210 +++++++++++++++++++++++++++--------------------------
 1 file changed, 106 insertions(+), 104 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 6a6d8f880d7b9..579e65ba19271 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1847,6 +1847,111 @@ static void obj_print_header(const struct obj *obj,
 			  obj->comment);
 }
 
+static void tunnel_obj_print_data(const struct obj *obj,
+				  struct print_fmt_options *opts,
+				  struct output_ctx *octx)
+{
+	struct tunnel_geneve *geneve;
+
+	obj_print_header(obj, opts, octx);
+
+	nft_print(octx, "%s%s%sid %u",
+		  opts->nl, opts->tab, opts->tab, obj->tunnel.id);
+
+	if (obj->tunnel.src) {
+		if (obj->tunnel.src->len == 32) {
+			nft_print(octx, "%s%s%sip saddr ",
+				  opts->nl, opts->tab, opts->tab);
+			expr_print(obj->tunnel.src, octx);
+		} else if (obj->tunnel.src->len == 128) {
+			nft_print(octx, "%s%s%sip6 saddr ",
+				  opts->nl, opts->tab, opts->tab);
+			expr_print(obj->tunnel.src, octx);
+		}
+	}
+	if (obj->tunnel.dst) {
+		if (obj->tunnel.dst->len == 32) {
+			nft_print(octx, "%s%s%sip daddr ",
+				  opts->nl, opts->tab, opts->tab);
+			expr_print(obj->tunnel.dst, octx);
+		} else if (obj->tunnel.dst->len == 128) {
+			nft_print(octx, "%s%s%sip6 daddr ",
+				  opts->nl, opts->tab, opts->tab);
+			expr_print(obj->tunnel.dst, octx);
+		}
+	}
+	if (obj->tunnel.sport) {
+		nft_print(octx, "%s%s%ssport %u",
+			  opts->nl, opts->tab, opts->tab,
+			  obj->tunnel.sport);
+	}
+	if (obj->tunnel.dport) {
+		nft_print(octx, "%s%s%sdport %u",
+			  opts->nl, opts->tab, opts->tab,
+			  obj->tunnel.dport);
+	}
+	if (obj->tunnel.tos) {
+		nft_print(octx, "%s%s%stos %u",
+			  opts->nl, opts->tab, opts->tab,
+			  obj->tunnel.tos);
+	}
+	if (obj->tunnel.ttl) {
+		nft_print(octx, "%s%s%sttl %u",
+			  opts->nl, opts->tab, opts->tab,
+			  obj->tunnel.ttl);
+	}
+	switch (obj->tunnel.type) {
+	case TUNNEL_ERSPAN:
+		nft_print(octx, "%s%s%serspan {",
+			  opts->nl, opts->tab, opts->tab);
+		nft_print(octx, "%s%s%s%sversion %u",
+			  opts->nl, opts->tab, opts->tab, opts->tab,
+			  obj->tunnel.erspan.version);
+		if (obj->tunnel.erspan.version == 1) {
+			nft_print(octx, "%s%s%s%sindex %u",
+				  opts->nl, opts->tab, opts->tab, opts->tab,
+				  obj->tunnel.erspan.v1.index);
+		} else {
+			nft_print(octx, "%s%s%s%sdirection %s",
+				  opts->nl, opts->tab, opts->tab, opts->tab,
+				  obj->tunnel.erspan.v2.direction ? "egress"
+								  : "ingress");
+			nft_print(octx, "%s%s%s%sid %u",
+				  opts->nl, opts->tab, opts->tab, opts->tab,
+				  obj->tunnel.erspan.v2.hwid);
+		}
+		break;
+	case TUNNEL_VXLAN:
+		nft_print(octx, "%s%s%svxlan {",
+			  opts->nl, opts->tab, opts->tab);
+		nft_print(octx, "%s%s%s%sgbp %u",
+			  opts->nl, opts->tab, opts->tab, opts->tab,
+			  obj->tunnel.vxlan.gbp);
+		break;
+	case TUNNEL_GENEVE:
+		nft_print(octx, "%s%s%sgeneve {", opts->nl, opts->tab, opts->tab);
+		list_for_each_entry(geneve, &obj->tunnel.geneve_opts, list) {
+			char data_str[256];
+			int offset = 0;
+
+			for (uint32_t i = 0; i < geneve->data_len; i++) {
+				offset += snprintf(data_str + offset,
+						   geneve->data_len,
+						   "%x",
+						   geneve->data[i]);
+			}
+			nft_print(octx, "%s%s%s%sclass 0x%x opt-type 0x%x data \"0x%s\"",
+				  opts->nl, opts->tab, opts->tab, opts->tab,
+				  geneve->geneve_class, geneve->type, data_str);
+
+		}
+		break;
+	default:
+		break;
+	}
+	nft_print(octx, "%s%s%s}", opts->nl, opts->tab, opts->tab);
+}
+
 static void obj_print_data(const struct obj *obj,
 			   struct print_fmt_options *opts,
 			   struct output_ctx *octx)
@@ -1988,110 +2093,7 @@ static void obj_print_data(const struct obj *obj,
 		}
 		break;
 	case NFT_OBJECT_TUNNEL:
-		obj_print_header(obj, opts, octx);
-
-		nft_print(octx, "%s%s%sid %u",
-			  opts->nl, opts->tab, opts->tab, obj->tunnel.id);
-
-		if (obj->tunnel.src) {
-			if (obj->tunnel.src->len == 32) {
-				nft_print(octx, "%s%s%sip saddr ",
-					  opts->nl, opts->tab, opts->tab);
-				expr_print(obj->tunnel.src, octx);
-			} else if (obj->tunnel.src->len == 128) {
-				nft_print(octx, "%s%s%sip6 saddr ",
-					  opts->nl, opts->tab, opts->tab);
-				expr_print(obj->tunnel.src, octx);
-			}
-		}
-		if (obj->tunnel.dst) {
-			if (obj->tunnel.dst->len == 32) {
-				nft_print(octx, "%s%s%sip daddr ",
-					  opts->nl, opts->tab, opts->tab);
-				expr_print(obj->tunnel.dst, octx);
-			} else if (obj->tunnel.dst->len == 128) {
-				nft_print(octx, "%s%s%sip6 daddr ",
-					  opts->nl, opts->tab, opts->tab);
-				expr_print(obj->tunnel.dst, octx);
-			}
-		}
-		if (obj->tunnel.sport) {
-			nft_print(octx, "%s%s%ssport %u",
-				  opts->nl, opts->tab, opts->tab,
-				  obj->tunnel.sport);
-		}
-		if (obj->tunnel.dport) {
-			nft_print(octx, "%s%s%sdport %u",
-				  opts->nl, opts->tab, opts->tab,
-				  obj->tunnel.dport);
-		}
-		if (obj->tunnel.tos) {
-			nft_print(octx, "%s%s%stos %u",
-				  opts->nl, opts->tab, opts->tab,
-				  obj->tunnel.tos);
-		}
-		if (obj->tunnel.ttl) {
-			nft_print(octx, "%s%s%sttl %u",
-				  opts->nl, opts->tab, opts->tab,
-				  obj->tunnel.ttl);
-		}
-		switch (obj->tunnel.type) {
-		case TUNNEL_ERSPAN:
-			nft_print(octx, "%s%s%serspan {",
-				  opts->nl, opts->tab, opts->tab);
-			nft_print(octx, "%s%s%s%sversion %u",
-				  opts->nl, opts->tab, opts->tab, opts->tab,
-				  obj->tunnel.erspan.version);
-			if (obj->tunnel.erspan.version == 1) {
-				nft_print(octx, "%s%s%s%sindex %u",
-					  opts->nl, opts->tab, opts->tab, opts->tab,
-					  obj->tunnel.erspan.v1.index);
-			} else {
-				nft_print(octx, "%s%s%s%sdirection %s",
-					  opts->nl, opts->tab, opts->tab, opts->tab,
-					  obj->tunnel.erspan.v2.direction ? "egress"
-									  : "ingress");
-				nft_print(octx, "%s%s%s%sid %u",
-					  opts->nl, opts->tab, opts->tab, opts->tab,
-					  obj->tunnel.erspan.v2.hwid);
-			}
-			nft_print(octx, "%s%s%s}",
-				  opts->nl, opts->tab, opts->tab);
-			break;
-		case TUNNEL_VXLAN:
-			nft_print(octx, "%s%s%svxlan {",
-				  opts->nl, opts->tab, opts->tab);
-			nft_print(octx, "%s%s%s%sgbp %u",
-				  opts->nl, opts->tab, opts->tab, opts->tab,
-				  obj->tunnel.vxlan.gbp);
-			nft_print(octx, "%s%s%s}",
-				  opts->nl, opts->tab, opts->tab);
-			break;
-		case TUNNEL_GENEVE:
-			struct tunnel_geneve *geneve;
-
-			nft_print(octx, "%s%s%sgeneve {", opts->nl, opts->tab, opts->tab);
-			list_for_each_entry(geneve, &obj->tunnel.geneve_opts, list) {
-				char data_str[256];
-				int offset = 0;
-
-				for (uint32_t i = 0; i < geneve->data_len; i++) {
-					offset += snprintf(data_str + offset,
-							   geneve->data_len,
-							   "%x",
-							   geneve->data[i]);
-				}
-				nft_print(octx, "%s%s%s%sclass 0x%x opt-type 0x%x data \"0x%s\"",
-					  opts->nl, opts->tab, opts->tab, opts->tab,
-					  geneve->geneve_class, geneve->type, data_str);
-
-			}
-			nft_print(octx, "%s%s%s}", opts->nl, opts->tab, opts->tab);
-			break;
-		default:
-			break;
-		}
-
+		tunnel_obj_print_data(obj, opts, octx);
 		nft_print(octx, "%s", opts->stmt_separator);
 		break;
 	default:
-- 
2.54.0

