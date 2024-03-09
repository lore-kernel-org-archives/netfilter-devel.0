Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A2C2E3F2
	for <netfilter-devel@vger.kernel.org>; Sat,  9 Mar 2024 11:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709984136; cv=none; b=uqU+vXqg08eoOX6gjxVkJx/hW8OlOY9slTlXnmNVmldahmj2g4wmclIwYzL9hxNv7SzK8QnIlhyFShYdeh0YcnRBxsM9CjpnrjWCvcUOBbWOnG/KivxUY86+ppnf4ldMrulhE7nRkqfVKBrdamfQS1KPfX/iUw9lHjpKjE3zQJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709984136; c=relaxed/simple;
	bh=5cD9fON8ZM2XksZ2DtF2ERaRqjz+2uF7xsDjCcuEJg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CPord1a37t7Pjc5IGA+56yTE/4cajDvxc/lxwns3T2f0RzHtS0QEAQTp5dW7wocNEJpjdGDlgZ5fhOJPmL/53E0gKjgS95YCC+Up9xuY2/wbGiRuF56tGJpxjUYF5CE/lrmo7ixPKzTMn1cGz9Udn9bJ0mTARbeEB4wQZFCmYIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Pp+72H8d; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Pp+72H8d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hCh+gjVz77p7Ah9VCxqiS5Isu5WslhOiaQp+AA35phc=; b=Pp+72H8dbZ1BIJJ+vjPhJWJL0R
	mHP0peKHJNDvC1P2Aiw/qOytV231QuZ7PnDAXT6zQ6S6NZqcrtuTM5I+oXDsa80xRoqkoIsyfkTtp
	ebkM+Ns4LnY0QB2oI0DpmtkJgOpTmvXSnwOk3vUwCc/spL+Lkzy875yN9LEcemUvOnmYHrfEpXrNt
	TgnSmtsCKjvf/qdBHx7iHVh28E7XoqTnOfG2VdoiaY2wPxtmv+h4LYo/TQxqI1LY9/bv2fvslPaHx
	+bQ84gMhnI3R1+/jylnssIihkq6wHGuZgX+7u2l2WOu0smE9TbGUTw773Ofsl+YTYUvb1pUxEiP1B
	ityl97ZA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1riuzE-000000003hD-2wOj;
	Sat, 09 Mar 2024 12:35:32 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 3/7] json: Order output like nft_cmd_expand()
Date: Sat,  9 Mar 2024 12:35:23 +0100
Message-ID: <20240309113527.8723-4-phil@nwl.cc>
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

Print empty chain add commands early in list so following verdict maps
and rules referring to them won't cause spurious errors when loading the
resulting ruleset dump.

Fixes: e70354f53e9f6 ("libnftables: Implement JSON output support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/json.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/src/json.c b/src/json.c
index b3e1e4e14a5f9..bb515164d2587 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1704,6 +1704,11 @@ static json_t *table_print_json_full(struct netlink_ctx *ctx,
 	tmp = table_print_json(table);
 	json_array_append_new(root, tmp);
 
+	/* both maps and rules may refer to chains, list them first */
+	list_for_each_entry(chain, &table->chain_cache.list, cache.list) {
+		tmp = chain_print_json(chain);
+		json_array_append_new(root, tmp);
+	}
 	list_for_each_entry(obj, &table->obj_cache.list, cache.list) {
 		tmp = obj_print_json(obj);
 		json_array_append_new(root, tmp);
@@ -1719,9 +1724,6 @@ static json_t *table_print_json_full(struct netlink_ctx *ctx,
 		json_array_append_new(root, tmp);
 	}
 	list_for_each_entry(chain, &table->chain_cache.list, cache.list) {
-		tmp = chain_print_json(chain);
-		json_array_append_new(root, tmp);
-
 		list_for_each_entry(rule, &chain->rules, list) {
 			tmp = rule_print_json(&ctx->nft->output, rule);
 			json_array_append_new(rules, tmp);
-- 
2.43.0

