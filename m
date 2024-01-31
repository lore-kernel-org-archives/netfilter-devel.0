Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58F769D22
	for <netfilter-devel@vger.kernel.org>; Wed, 31 Jan 2024 16:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706719293; cv=none; b=RbAj2/0+IAce0tz3/RKSnjT8ZkUqfXcJOTcqkUKyelRNbxYJU0n8kzB70w65zGi6/TISHUyAG67/+yZ9dvKHc7FfrO1v5r7hKAJT19oosYrk/0Nj7E0DIohfA08DYTcIOhIT8tPA+8qJklyIthH+e6fF24i+XNiDXpsnTWgVsQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706719293; c=relaxed/simple;
	bh=qziRQrd8HJeVhiMHekAt4JdQGF9G+uQDyYGWA8c4a8k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K3LmUhAv57dT7MyxBjWXgAx6EclC95vI8AnwxHeT4xNYi1O5VLHnOqgOQ2XUsbOq2tZLIl4TqO7+FVHdIDMgVAjNYWpkR6cIeQovHDeK1Q3Am7VdkGiOlKA5hNZg0Ir4D2BjL4oVV0EVdRjjC65w0AHltqiGdiUe4WRw5qRJUXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=BHCbQhSp; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="BHCbQhSp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bh9QMDP7lQJfrqBelrTqBiDTd/MIdxDIGn/M93S/tgQ=; b=BHCbQhSpdIf7N4ATGS8lrZk9eG
	h0rLvlL7e3dx2vLddH+IigwGe2PBNsel64caaTvApKCS027tGGVmYFd4QGYn1twwARZAx6/nULUCw
	niiwm/KdU3t8GrbTKhHfvbTByiMHeAdn4Y7czwIF81h8XaDE3aHStaf3jtK8WpCX9ewnC77wgPoEz
	T5ZCnarkR/z07Fn83MLhHm1OIS34vz/q39n5aoow2NrrGH2w8obQ5y1DvJrv0ULCGXGiXYIcc+tBZ
	aEwZ30+aNHvIuJmp6cPpd5M0PUE8UMr98VwpXR1iMXJ4z+vJNJbGOhH7e1f/6TXYDXdjJCDzucim8
	G0ckc4Tw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rVDeL-0000000089X-16nw;
	Wed, 31 Jan 2024 17:41:21 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] json: Support sets' auto-merge option
Date: Wed, 31 Jan 2024 17:41:20 +0100
Message-ID: <20240131164120.5208-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If enabled, list the option as additional attribute with boolean value.

Fixes: e70354f53e9f6 ("libnftables: Implement JSON output support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/libnftables-json.adoc | 8 ++++++--
 src/json.c                | 2 ++
 src/parser_json.c         | 1 +
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/doc/libnftables-json.adoc b/doc/libnftables-json.adoc
index ad3364e20816b..3948a0bad47c1 100644
--- a/doc/libnftables-json.adoc
+++ b/doc/libnftables-json.adoc
@@ -312,7 +312,8 @@ ____
 	"elem":* 'SET_ELEMENTS'*,
 	"timeout":* 'NUMBER'*,
 	"gc-interval":* 'NUMBER'*,
-	"size":* 'NUMBER'
+	"size":* 'NUMBER'*,
+	"auto-merge":* 'BOOLEAN'
 *}}*
 
 *{ "map": {
@@ -327,7 +328,8 @@ ____
 	"elem":* 'SET_ELEMENTS'*,
 	"timeout":* 'NUMBER'*,
 	"gc-interval":* 'NUMBER'*,
-	"size":* 'NUMBER'
+	"size":* 'NUMBER'*,
+	"auto-merge":* 'BOOLEAN'
 *}}*
 
 'SET_TYPE' := 'STRING' | *[* 'SET_TYPE_LIST' *]*
@@ -366,6 +368,8 @@ that they translate a unique key to a value.
 	Garbage collector interval in seconds.
 *size*::
 	Maximum number of elements supported.
+*auto-merge*::
+	Automatic merging of adjacent/overlapping set elements in interval sets.
 
 ==== TYPE
 The set type might be a string, such as *"ipv4_addr"* or an array
diff --git a/src/json.c b/src/json.c
index 6809cd50f0a87..b3e1e4e14a5f9 100644
--- a/src/json.c
+++ b/src/json.c
@@ -194,6 +194,8 @@ static json_t *set_print_json(struct output_ctx *octx, const struct set *set)
 		tmp = json_pack("i", set->gc_int / 1000);
 		json_object_set_new(root, "gc-interval", tmp);
 	}
+	if (set->automerge)
+		json_object_set_new(root, "auto-merge", json_true());
 
 	if (!nft_output_terse(octx) && set->init && set->init->size > 0) {
 		json_t *array = json_array();
diff --git a/src/parser_json.c b/src/parser_json.c
index f4eccc1788f8a..82f20cd6ddd4e 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3420,6 +3420,7 @@ static struct cmd *json_parse_cmd_add_set(struct json_ctx *ctx, json_t *root,
 	if (!json_unpack(root, "{s:i}", "gc-interval", &set->gc_int))
 		set->gc_int *= 1000;
 	json_unpack(root, "{s:i}", "size", &set->desc.size);
+	json_unpack(root, "{s:b}", "auto-merge", &set->automerge);
 
 	if (!json_unpack(root, "{s:o}", "stmt", &stmt_json))
 		json_parse_set_stmt_list(ctx, &set->stmt_list, stmt_json);
-- 
2.43.0

