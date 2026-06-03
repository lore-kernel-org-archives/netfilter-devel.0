Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4B137416F
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Jun 2026 19:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780514973; cv=none; b=Q+NVW8GA12fO8p6cneChlPAN6OcED0YOVULJe/O6+HNx4rKELEVQ128pHnMF4JTxLlvBXLgOn3kNIRsmOkNd89Na/N4W5dt/fVAyKMb5icNUhqVzx4iM406dLXaeEz1BGU+5KYhnUjqmh1cfNDsVjRnO/DGsXnhBRJYeZ2khgXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780514973; c=relaxed/simple;
	bh=8IuxgfH3GERfiZVIfJ12M2K4YzyLVkjx3a/60fvwS4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMjXGZ36j1mH11xPLUz1t4KZGoqSdSoh4HBxlJTCk5IgBwiaDkwf/x8Hz49c97iX6ubiaDDRiKsqbfLrpyyvlD/BT3h6M7PobedbwxTXH9e+d+UIeJ//Js43HCU6EuW5f2fE/YCTzAjQLqEKUZ+vg3myt50K1u3sH7j6UYBQQF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=GSWK6HRy; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="GSWK6HRy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6reOtMFAhkBrj06Lao48XDgMpzQ0dRYQ5hrN3kpV5co=; b=GSWK6HRyMtGIFUhjJ/ZO3SOT/O
	+KwZLoojPNN/duMEB5PrTYKBdkCxUOZFNaB8q/SFxgVYWux64F8/TOePNr2mVHvvjnnMZwkDlKSQL
	K5XWlsysrjLPGthnAEAUqUhs7K6ekFM5At6rEM2pdYAdMFmkCASuOr6hkt5/1lZrxs8A0WiR2LWHv
	W+hFQPinMBgThPFVs9G5jomoYrabNtHo3KtEs3pr0MxpWcfqjBECLYCxmev5bmPTT92pVw4SF9pis
	9CZJKHP988ouYp2g6x8B3s9eC0vomi/OOEuSjZ148hp7qmfC9Xxz0yucd0vy3o3lb97mA3eduluam
	0pm1DnrQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wUrHN-0000000033q-1gQ5;
	Wed, 03 Jun 2026 21:29:29 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 3/6] rule: Turn obj_print_comment() into obj_print_header()
Date: Wed,  3 Jun 2026 21:29:20 +0200
Message-ID: <20260603192923.1378815-4-phil@nwl.cc>
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

All tunnel types print the same heading, merge the duplicate code.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/rule.c | 64 ++++++++++++++----------------------------------------
 1 file changed, 16 insertions(+), 48 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index c32e08319d149..6a6d8f880d7b9 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1833,10 +1833,14 @@ int tunnel_geneve_data_str2array(const char *hexstr,
 	return 0;
 }
 
-static void obj_print_comment(const struct obj *obj,
-			      struct print_fmt_options *opts,
-			      struct output_ctx *octx)
+static void obj_print_header(const struct obj *obj,
+			     struct print_fmt_options *opts,
+			     struct output_ctx *octx)
 {
+	nft_print(octx, " %s {", obj->handle.obj.name);
+	if (nft_output_handle(octx))
+		nft_print(octx, " # handle %" PRIu64, obj->handle.handle.id);
+
 	if (obj->comment)
 		nft_print(octx, "%s%s%scomment \"%s\"",
 			  opts->nl, opts->tab, opts->tab,
@@ -1849,11 +1853,7 @@ static void obj_print_data(const struct obj *obj,
 {
 	switch (obj->type) {
 	case NFT_OBJECT_COUNTER:
-		nft_print(octx, " %s {", obj->handle.obj.name);
-		if (nft_output_handle(octx))
-			nft_print(octx, " # handle %" PRIu64, obj->handle.handle.id);
-
-		obj_print_comment(obj, opts, octx);
+		obj_print_header(obj, opts, octx);
 		if (nft_output_stateless(octx))
 			nft_print(octx, "%s", opts->nl);
 		else
@@ -1865,11 +1865,7 @@ static void obj_print_data(const struct obj *obj,
 		const char *data_unit;
 		uint64_t bytes;
 
-		nft_print(octx, " %s {", obj->handle.obj.name);
-		if (nft_output_handle(octx))
-			nft_print(octx, " # handle %" PRIu64, obj->handle.handle.id);
-
-		obj_print_comment(obj, opts, octx);
+		obj_print_header(obj, opts, octx);
 		nft_print(octx, "%s%s%s", opts->nl, opts->tab, opts->tab);
 		data_unit = get_rate(obj->quota.bytes, &bytes);
 		nft_print(octx, "%s%" PRIu64 " %s",
@@ -1884,20 +1880,12 @@ static void obj_print_data(const struct obj *obj,
 		}
 		break;
 	case NFT_OBJECT_SECMARK:
-		nft_print(octx, " %s {", obj->handle.obj.name);
-		if (nft_output_handle(octx))
-			nft_print(octx, " # handle %" PRIu64, obj->handle.handle.id);
-
-		obj_print_comment(obj, opts, octx);
+		obj_print_header(obj, opts, octx);
 		nft_print(octx, "%s%s%s", opts->nl, opts->tab, opts->tab);
 		nft_print(octx, "\"%s\"%s", obj->secmark.ctx, opts->nl);
 		break;
 	case NFT_OBJECT_CT_HELPER:
-		nft_print(octx, " %s {", obj->handle.obj.name);
-		if (nft_output_handle(octx))
-			nft_print(octx, " # handle %" PRIu64, obj->handle.handle.id);
-
-		obj_print_comment(obj, opts, octx);
+		obj_print_header(obj, opts, octx);
 		nft_print(octx, "%s", opts->nl);
 		nft_print(octx, "%s%stype \"%s\" protocol ",
 			  opts->tab, opts->tab, obj->ct_helper.name);
@@ -1909,11 +1897,7 @@ static void obj_print_data(const struct obj *obj,
 			  opts->stmt_separator);
 		break;
 	case NFT_OBJECT_CT_TIMEOUT:
-		nft_print(octx, " %s {", obj->handle.obj.name);
-		if (nft_output_handle(octx))
-			nft_print(octx, " # handle %" PRIu64, obj->handle.handle.id);
-
-		obj_print_comment(obj, opts, octx);
+		obj_print_header(obj, opts, octx);
 		nft_print(octx, "%s", opts->nl);
 		nft_print(octx, "%s%sprotocol ", opts->tab, opts->tab);
 		print_proto_name_proto(obj->ct_timeout.l4proto, octx);
@@ -1926,11 +1910,7 @@ static void obj_print_data(const struct obj *obj,
 					   obj->ct_timeout.timeout, opts, octx);
 		break;
 	case NFT_OBJECT_CT_EXPECT:
-		nft_print(octx, " %s {", obj->handle.obj.name);
-		if (nft_output_handle(octx))
-			nft_print(octx, " # handle %" PRIu64, obj->handle.handle.id);
-
-		obj_print_comment(obj, opts, octx);
+		obj_print_header(obj, opts, octx);
 		nft_print(octx, "%s", opts->nl);
 		nft_print(octx, "%s%sprotocol ", opts->tab, opts->tab);
 		print_proto_name_proto(obj->ct_expect.l4proto, octx);
@@ -1956,11 +1936,7 @@ static void obj_print_data(const struct obj *obj,
 		const char *data_unit;
 		uint64_t rate;
 
-		nft_print(octx, " %s {", obj->handle.obj.name);
-		if (nft_output_handle(octx))
-			nft_print(octx, " # handle %" PRIu64, obj->handle.handle.id);
-
-		obj_print_comment(obj, opts, octx);
+		obj_print_header(obj, opts, octx);
 		nft_print(octx, "%s%s%s", opts->nl, opts->tab, opts->tab);
 		switch (obj->limit.type) {
 		case NFT_LIMIT_PKTS:
@@ -1994,11 +1970,7 @@ static void obj_print_data(const struct obj *obj,
 		const char *sack_str = synproxy_sack_to_str(flags);
 		const char *ts_str = synproxy_timestamp_to_str(flags);
 
-		nft_print(octx, " %s {", obj->handle.obj.name);
-		if (nft_output_handle(octx))
-			nft_print(octx, " # handle %" PRIu64, obj->handle.handle.id);
-
-		obj_print_comment(obj, opts, octx);
+		obj_print_header(obj, opts, octx);
 
 		if (flags & NF_SYNPROXY_OPT_MSS) {
 			nft_print(octx, "%s%s%s", opts->nl, opts->tab, opts->tab);
@@ -2016,11 +1988,7 @@ static void obj_print_data(const struct obj *obj,
 		}
 		break;
 	case NFT_OBJECT_TUNNEL:
-		nft_print(octx, " %s {", obj->handle.obj.name);
-		if (nft_output_handle(octx))
-			nft_print(octx, " # handle %" PRIu64, obj->handle.handle.id);
-
-		obj_print_comment(obj, opts, octx);
+		obj_print_header(obj, opts, octx);
 
 		nft_print(octx, "%s%s%sid %u",
 			  opts->nl, opts->tab, opts->tab, obj->tunnel.id);
-- 
2.54.0

