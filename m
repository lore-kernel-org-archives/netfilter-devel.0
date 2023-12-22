Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA97C241E9
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Dec 2023 16:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="hI0YOjdN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=heo6x1FC8eEkYwkVusqoFR3edS7wFZzJm/RZH/L4MHE=; b=hI0YOjdNWjqETbuu+j1XyGyYTG
	VOF23SZGGqpWsIncJdopNb1v3KR2/fLtYhcT0eHY80c/gvMUvHdvC0NcaEWeatXbFPQknqltc2HOB
	QfMhHvLt9Y7ZFzCU7p2sW6sOiEQs21BfhPJPFbkReqKyc0JPsn1NbpOPC7XkAtBx7vCXwRXD7CvxH
	x/CZ1Vi2MSKL3p4QdUQThKZ8ELaUFSqNQvcQMy+O9iI4CIZ6pBW5qSNiJskhRbk2xEiQs+KH6jdYF
	SaDEPH78zb6CwkgzSYfn4x4ZP3nYO/Nqp54wEQZW58e1UilN/iKS5xSzXCIrdvvwiGUz/aj/Zr+ls
	GoifERfw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rGiDk-0002fW-S6; Fri, 22 Dec 2023 17:17:56 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/2] datatype: Describe rt symbol tables
Date: Fri, 22 Dec 2023 17:17:47 +0100
Message-ID: <20231222161747.29265-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231222161747.29265-1-phil@nwl.cc>
References: <ZYV8YnXhwKoDD/o2@calendula>
 <20231222161747.29265-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement a symbol_table_print() wrapper for the run-time populated
rt_symbol_tables which formats output similar to expr_describe() and
includes the data source.

Since these tables reside in struct output_ctx there is no implicit
connection between data type and therefore providing callbacks for
relevant datat types which feed the data into said wrapper is a simpler
solution than extending expr_describe() itself.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/datatype.h |  3 +++
 src/ct.c           |  7 +++++++
 src/datatype.c     | 34 ++++++++++++++++++++++++++++++++++
 src/meta.c         |  7 +++++++
 src/rt.c           |  7 +++++++
 5 files changed, 58 insertions(+)

diff --git a/include/datatype.h b/include/datatype.h
index 09a7894567e4d..c4d6282d6f591 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -252,6 +252,9 @@ extern void symbol_table_print(const struct symbol_table *tbl,
 
 extern struct symbol_table *rt_symbol_table_init(const char *filename);
 extern void rt_symbol_table_free(const struct symbol_table *tbl);
+extern void rt_symbol_table_describe(struct output_ctx *octx, const char *name,
+				     const struct symbol_table *tbl,
+				     const struct datatype *type);
 
 extern const struct datatype invalid_type;
 extern const struct datatype verdict_type;
diff --git a/src/ct.c b/src/ct.c
index ebfd90a1ab0d3..6793464859cad 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -216,10 +216,17 @@ static struct error_record *ct_label_type_parse(struct parse_ctx *ctx,
 	return NULL;
 }
 
+static void ct_label_type_describe(struct output_ctx *octx)
+{
+	rt_symbol_table_describe(octx, CONNLABEL_CONF,
+				 octx->tbl.ct_label, &ct_label_type);
+}
+
 const struct datatype ct_label_type = {
 	.type		= TYPE_CT_LABEL,
 	.name		= "ct_label",
 	.desc		= "conntrack label",
+	.describe	= ct_label_type_describe,
 	.byteorder	= BYTEORDER_HOST_ENDIAN,
 	.size		= CT_LABEL_BIT_SIZE,
 	.basetype	= &bitmask_type,
diff --git a/src/datatype.c b/src/datatype.c
index 4d867798222be..3b19ae8ef52d8 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -946,6 +946,33 @@ void rt_symbol_table_free(const struct symbol_table *tbl)
 	free_const(tbl);
 }
 
+void rt_symbol_table_describe(struct output_ctx *octx, const char *name,
+			      const struct symbol_table *tbl,
+			      const struct datatype *type)
+{
+	char *path = NULL;
+	FILE *f;
+
+	if (!tbl || !tbl->symbols[0].identifier)
+		return;
+
+	f = open_iproute2_db(name, &path);
+	if (f)
+		fclose(f);
+	if (!path && asprintf(&path, "%s%s",
+			      name[0] == '/' ? "" : "unknown location of ",
+			      name) < 0)
+		return;
+
+	nft_print(octx, "\npre-defined symbolic constants from %s ", path);
+	if (tbl->base == BASE_DECIMAL)
+		nft_print(octx, "(in decimal):\n");
+	else
+		nft_print(octx, "(in hexadecimal):\n");
+	symbol_table_print(tbl, type, type->byteorder, octx);
+	free(path);
+}
+
 void mark_table_init(struct nft_ctx *ctx)
 {
 	ctx->output.tbl.mark = rt_symbol_table_init("rt_marks");
@@ -968,10 +995,17 @@ static struct error_record *mark_type_parse(struct parse_ctx *ctx,
 	return symbolic_constant_parse(ctx, sym, ctx->tbl->mark, res);
 }
 
+static void mark_type_describe(struct output_ctx *octx)
+{
+	rt_symbol_table_describe(octx, "rt_marks",
+				 octx->tbl.mark, &mark_type);
+}
+
 const struct datatype mark_type = {
 	.type		= TYPE_MARK,
 	.name		= "mark",
 	.desc		= "packet mark",
+	.describe	= mark_type_describe,
 	.size		= 4 * BITS_PER_BYTE,
 	.byteorder	= BYTEORDER_HOST_ENDIAN,
 	.basetype	= &integer_type,
diff --git a/src/meta.c b/src/meta.c
index 6f76f0033a630..eca8dac72098a 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -346,10 +346,17 @@ static struct error_record *devgroup_type_parse(struct parse_ctx *ctx,
 	return symbolic_constant_parse(ctx, sym, ctx->tbl->devgroup, res);
 }
 
+static void devgroup_type_describe(struct output_ctx *octx)
+{
+	rt_symbol_table_describe(octx, "group",
+				 octx->tbl.devgroup, &devgroup_type);
+}
+
 const struct datatype devgroup_type = {
 	.type		= TYPE_DEVGROUP,
 	.name		= "devgroup",
 	.desc		= "devgroup name",
+	.describe	= devgroup_type_describe,
 	.byteorder	= BYTEORDER_HOST_ENDIAN,
 	.size		= 4 * BITS_PER_BYTE,
 	.basetype	= &integer_type,
diff --git a/src/rt.c b/src/rt.c
index 3ee710ddc05b5..d8f3352f4b4a7 100644
--- a/src/rt.c
+++ b/src/rt.c
@@ -45,10 +45,17 @@ static struct error_record *realm_type_parse(struct parse_ctx *ctx,
 	return symbolic_constant_parse(ctx, sym, ctx->tbl->realm, res);
 }
 
+static void realm_type_describe(struct output_ctx *octx)
+{
+	rt_symbol_table_describe(octx, "rt_realms",
+				 octx->tbl.realm, &realm_type);
+}
+
 const struct datatype realm_type = {
 	.type		= TYPE_REALM,
 	.name		= "realm",
 	.desc		= "routing realm",
+	.describe	= realm_type_describe,
 	.byteorder	= BYTEORDER_HOST_ENDIAN,
 	.size		= 4 * BITS_PER_BYTE,
 	.basetype	= &integer_type,
-- 
2.43.0

