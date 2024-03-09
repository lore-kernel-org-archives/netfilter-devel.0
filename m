Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC577374D4
	for <netfilter-devel@vger.kernel.org>; Sat,  9 Mar 2024 11:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709984138; cv=none; b=mlQC9/xP20GPx/8pBaeilT6Xe9feLL7fgt5/d4edfQFO3815WBSgCfXINER/Kh3Nve/fuZIZWnC/0goWV6S8b3og5lxZJmW8afAHNrPdBUfQCcJ0+eAZpoZNPfkscsCFIJQfX0hHn3VBjFk5E7OzRQmYwM3Q5lYnum8KH0yCOxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709984138; c=relaxed/simple;
	bh=OTRI94HLC5NUDwpj5wkAsbG+7UPVtPM3F1kGQUOneq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WY0Rm1H0iAo684IXLoHTFl8DcXrQPaMLHba4lVww3KLtmtdGTkDAqAhzwtzg0gYVNxQDmcdn7boOWuZJCSPkygWpcSuKEilhbzP/349+X4s6AEfDhj2rZZm6aMVKmebvi/Doj9XgMokNXAW2RDB0d6wjQH5c4O0Z9cAdnNETbHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=LI0B3nkZ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="LI0B3nkZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+9hQfpVzdZ5WdJG5aL4t/QWSL6efH9Ufzveau65wngI=; b=LI0B3nkZ//MN2+hZ2CgziKoE3J
	ir+JyT0NJ6F//3uVeAyPGA18jtf9wwNwx/RFPGTaLqadMPuxibm6NCmgxaCVssY2LR8mF5zMujAx0
	GfxpLXlfuL7+lucBDltyoqMHuogDTghx7cOCNFhP/MQLvOjP/d+5A2obqoqd5nOp0CRDcGuFsGmBf
	Li1S88lp2LL6LxZPY2/t3+N7ybCwO2F0FHZ+KFtzZrD7NsvnFYoZ+wl3UVe51NvevxdnHyBt96zal
	tmkl8FEbA/P6s4rY54qDE9Lv7y0wHbsWyjNlvxL4uvsT4mhkWMEG3UggiX6eOVoYnFglYVJY5yj38
	718jGfZg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1riuzH-000000003hb-0D3L;
	Sat, 09 Mar 2024 12:35:35 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 6/7] parser: json: Support for synproxy objects
Date: Sat,  9 Mar 2024 12:35:26 +0100
Message-ID: <20240309113527.8723-7-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240309113527.8723-1-phil@nwl.cc>
References: <20240309113527.8723-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Parsing code was there already, merely the entry in json_parse_cmd_add()
missing.

To support maps with synproxy target, an entry in string_to_nft_object()
is required. While being at it, add other missing entries as well.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_json.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index bb027448319c5..4fc0479cf4972 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3217,14 +3217,18 @@ static struct cmd *json_parse_cmd_add_rule(struct json_ctx *ctx, json_t *root,
 static int string_to_nft_object(const char *str)
 {
 	const char *obj_tbl[__NFT_OBJECT_MAX] = {
-		[NFT_OBJECT_COUNTER] = "counter",
-		[NFT_OBJECT_QUOTA] = "quota",
-		[NFT_OBJECT_LIMIT] = "limit",
-		[NFT_OBJECT_SECMARK] = "secmark",
+		[NFT_OBJECT_COUNTER]	= "counter",
+		[NFT_OBJECT_QUOTA]	= "quota",
+		[NFT_OBJECT_CT_HELPER]	= "ct helper",
+		[NFT_OBJECT_LIMIT]	= "limit",
+		[NFT_OBJECT_CT_TIMEOUT]	= "ct timeout",
+		[NFT_OBJECT_SECMARK]	= "secmark",
+		[NFT_OBJECT_CT_EXPECT]	= "ct expectation",
+		[NFT_OBJECT_SYNPROXY]	= "synproxy",
 	};
 	unsigned int i;
 
-	for (i = 0; i < NFT_OBJECT_MAX; i++) {
+	for (i = 0; i <= NFT_OBJECT_MAX; i++) {
 		if (obj_tbl[i] && !strcmp(str, obj_tbl[i]))
 			return i;
 	}
@@ -3759,7 +3763,8 @@ static struct cmd *json_parse_cmd_add(struct json_ctx *ctx,
 		{ "ct timeout", NFT_OBJECT_CT_TIMEOUT, json_parse_cmd_add_object },
 		{ "ct expectation", NFT_OBJECT_CT_EXPECT, json_parse_cmd_add_object },
 		{ "limit", CMD_OBJ_LIMIT, json_parse_cmd_add_object },
-		{ "secmark", CMD_OBJ_SECMARK, json_parse_cmd_add_object }
+		{ "secmark", CMD_OBJ_SECMARK, json_parse_cmd_add_object },
+		{ "synproxy", CMD_OBJ_SYNPROXY, json_parse_cmd_add_object }
 	};
 	unsigned int i;
 	json_t *tmp;
-- 
2.43.0

