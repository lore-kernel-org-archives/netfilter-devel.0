Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8181E500C
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Jun 2025 10:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749981628; cv=none; b=XglQAZ4YhtSbxcdBaleSIOojFkAqx5tydF0g+6yep0TEQWCFEvYqxN9iNTgr0g7RaeHLHCLiwcq5KtmbnOC45XGufU7a7uYPKYUYoacMQMzKFLhUqkBAISbkizDWaYKiqvme50M3lu4g4cpnGj27xr3SxvyWnTY6Be2T78WZP4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749981628; c=relaxed/simple;
	bh=Ijuv9UeBQvQuHeB5uCkvlQ4oTxOwqdRqiRiyBQ/yv8I=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Mk7BO1TALgjSDyDnMiqceV2poiXHyLnEqpK7iVbNqZBmw4Ytht7fLnGx8ozIB3gdeQYIC95PwxWhDjn6gx6AMo1rHIlIZ3/R1c4Pa3VGHTiZ8Vj13xVTXW/RNHgd+N5GfSf0wrwIx+of2pEl1CjUrSjkg+qeEnM+vMCiIeKeWyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SxD0b620; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SxD0b620; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SxD0b620";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SxD0b620"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 735FA602BF; Sun, 15 Jun 2025 12:00:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749981624;
	bh=I+fSiraOz/4mzb8xcLkflT7XbTq+c4pNRD2AYR5QFrg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=SxD0b620lJj06B7R8DJm2cz023tFDhS4xf1ilrsebZXkylTxdee0bhSF4E6wXiwQo
	 5R8mHvelD8n53pvG6Ux8yQ2kUOoT5a8QwN/oST4oI3fTlpZ6au20ULYhjqGWYLH4wH
	 Txxf2E+E2i13xaV52AiHF2aEy5nWNtd69HpDB58lWxMWwXbdm0HogmIV9w0GSZFwEO
	 VA2oZuSQyHp62Qkggtuy3cKxe1BNe5+fOf03XAoOaccYEzr5liM6iccHvilQzq3lid
	 CX8aoYLHEo5ZaMPFTDlLuciGXVQVbK+/v5JeJKKO74HrdtEa/heXc3XFF3p2jV6oxF
	 C9RrEfeICrHJQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 05860602BC
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Jun 2025 12:00:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749981624;
	bh=I+fSiraOz/4mzb8xcLkflT7XbTq+c4pNRD2AYR5QFrg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=SxD0b620lJj06B7R8DJm2cz023tFDhS4xf1ilrsebZXkylTxdee0bhSF4E6wXiwQo
	 5R8mHvelD8n53pvG6Ux8yQ2kUOoT5a8QwN/oST4oI3fTlpZ6au20ULYhjqGWYLH4wH
	 Txxf2E+E2i13xaV52AiHF2aEy5nWNtd69HpDB58lWxMWwXbdm0HogmIV9w0GSZFwEO
	 VA2oZuSQyHp62Qkggtuy3cKxe1BNe5+fOf03XAoOaccYEzr5liM6iccHvilQzq3lid
	 CX8aoYLHEo5ZaMPFTDlLuciGXVQVbK+/v5JeJKKO74HrdtEa/heXc3XFF3p2jV6oxF
	 C9RrEfeICrHJQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/5] rule: skip fuzzy lookup if object name is not available
Date: Sun, 15 Jun 2025 12:00:15 +0200
Message-Id: <20250615100019.2988872-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250615100019.2988872-1-pablo@netfilter.org>
References: <20250615100019.2988872-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Skip fuzzy lookup for suggestions when handles are used.

Note that 4cf97abfee61 ("rule: Avoid segfault with anonymous chains")
already skips it for chain.

Fixes: 285bb67a11ad ("src: introduce simple hints on incorrect set")
Fixes: 9f7817a4e022 ("src: introduce simple hints on incorrect chain")
Fixes: d7476ddd5f7d ("src: introduce simple hints on incorrect table")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/src/rule.c b/src/rule.c
index 80315837baf0..a5a668f9992c 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -211,6 +211,9 @@ struct set *set_lookup_fuzzy(const char *set_name,
 	struct table *table;
 	struct set *set;
 
+	if (!set_name)
+		return NULL;
+
 	string_misspell_init(&st);
 
 	list_for_each_entry(table, &cache->table_cache.list, cache.list) {
@@ -1214,6 +1217,9 @@ struct table *table_lookup_fuzzy(const struct handle *h,
 	struct string_misspell_state st;
 	struct table *table;
 
+	if (!h->table.name)
+		return NULL;
+
 	string_misspell_init(&st);
 
 	list_for_each_entry(table, &cache->table_cache.list, cache.list) {
@@ -1696,6 +1702,9 @@ struct obj *obj_lookup_fuzzy(const char *obj_name,
 	struct table *table;
 	struct obj *obj;
 
+	if (!obj_name)
+		return NULL;
+
 	string_misspell_init(&st);
 
 	list_for_each_entry(table, &cache->table_cache.list, cache.list) {
@@ -2191,6 +2200,9 @@ struct flowtable *flowtable_lookup_fuzzy(const char *ft_name,
 	struct table *table;
 	struct flowtable *ft;
 
+	if (!ft_name)
+		return NULL;
+
 	string_misspell_init(&st);
 
 	list_for_each_entry(table, &cache->table_cache.list, cache.list) {
-- 
2.30.2

