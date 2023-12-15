Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B715747F5E
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Dec 2023 21:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Oj+veNnf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ukXTSbu4MJ7kGBkFgmcaR0d+z83qsvh+qcgvdmZyGpY=; b=Oj+veNnfYU4lUElc3iTWaYz0xf
	jK/u65NkYyLhhMFFgUJ4b4E4JrWNaDG+/GFlmK3+hBXIPfngHkNLhLTB+7dQzZoV8pmpOOn2/N5qJ
	UixnTuTNbZK9CnIMlXgSLIXXjwJewmF5KOHB7nMt5SuliUrjVLkkeuXgDbWjbv2LGL1sC78txwTA9
	IaOQWsBnztaXNi4GfeQBEN0avJ02QdijBIP+IbgcP4ybxPpiB7s67ZCTD89y+KNyIMAfEn2HPVakb
	rKPi0U1TfcOdy5dVm41Ym2CMB5vQ3a4fvgcLAUtDGb9KebfW1+ndwOjKuQK/QN4lG4jP2A3Mr+4rg
	RPgc6qRA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rEFar-0001HT-7j; Fri, 15 Dec 2023 22:19:37 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] datatype: rt_symbol_table_init() to search for iproute2 configs
Date: Fri, 15 Dec 2023 22:19:33 +0100
Message-ID: <20231215211933.7371-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is an ongoing effort among various distributions to tidy up in
/etc. The idea is to reduce contents to just what the admin manually
inserted to customize the system, anything else shall move out to /usr
(or so). The various files in /etc/iproute2 fall in that category as
they are seldomly modified.

The crux is though that iproute2 project seems not quite sure yet where
the files should go. While v6.6.0 installs them into /usr/lib/iproute2,
current mast^Wmain branch uses /usr/share/iproute2. Assume this is going
to stay as /(usr/)lib does not seem right for such files.

Note that rt_symbol_table_init() is not just used for
iproute2-maintained configs but also for connlabel.conf - so retain the
old behaviour when passed an absolute path.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/datatype.c | 38 ++++++++++++++++++++++++++++++++++----
 src/meta.c     |  2 +-
 src/rt.c       |  2 +-
 3 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index 86d55a5242694..9ca0516700f81 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -855,19 +855,47 @@ const struct datatype inet_service_type = {
 
 #define RT_SYM_TAB_INITIAL_SIZE		16
 
+static FILE *open_iproute2_db(const char *filename, char **path)
+{
+	FILE *ret;
+
+	if (filename[0] == '/')
+		return fopen(filename, "r");
+
+	if (asprintf(path, "/etc/iproute2/%s", filename) == -1)
+		goto fail;
+
+	ret = fopen(*path, "r");
+	if (ret)
+		return ret;
+
+	free(*path);
+	if (asprintf(path, "/usr/share/iproute2/%s", filename) == -1)
+		goto fail;
+
+	ret = fopen(*path, "r");
+	if (ret)
+		return ret;
+
+	free(*path);
+fail:
+	*path = NULL;
+	return NULL;
+}
+
 struct symbol_table *rt_symbol_table_init(const char *filename)
 {
+	char buf[512], namebuf[512], *p, *path = NULL;
 	struct symbolic_constant s;
 	struct symbol_table *tbl;
 	unsigned int size, nelems, val;
-	char buf[512], namebuf[512], *p;
 	FILE *f;
 
 	size = RT_SYM_TAB_INITIAL_SIZE;
 	tbl = xmalloc(sizeof(*tbl) + size * sizeof(s));
 	nelems = 0;
 
-	f = fopen(filename, "r");
+	f = open_iproute2_db(filename, &path);
 	if (f == NULL)
 		goto out;
 
@@ -882,7 +910,7 @@ struct symbol_table *rt_symbol_table_init(const char *filename)
 		    sscanf(p, "%u %511s\n", &val, namebuf) != 2 &&
 		    sscanf(p, "%u %511s #", &val, namebuf) != 2) {
 			fprintf(stderr, "iproute database '%s' corrupted\n",
-				filename);
+				path ?: filename);
 			break;
 		}
 
@@ -899,6 +927,8 @@ struct symbol_table *rt_symbol_table_init(const char *filename)
 
 	fclose(f);
 out:
+	if (path)
+		free(path);
 	tbl->symbols[nelems] = SYMBOL_LIST_END;
 	return tbl;
 }
@@ -914,7 +944,7 @@ void rt_symbol_table_free(const struct symbol_table *tbl)
 
 void mark_table_init(struct nft_ctx *ctx)
 {
-	ctx->output.tbl.mark = rt_symbol_table_init("/etc/iproute2/rt_marks");
+	ctx->output.tbl.mark = rt_symbol_table_init("rt_marks");
 }
 
 void mark_table_exit(struct nft_ctx *ctx)
diff --git a/src/meta.c b/src/meta.c
index 8d0b7aae96292..6f76f0033a630 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -325,7 +325,7 @@ const struct datatype pkttype_type = {
 
 void devgroup_table_init(struct nft_ctx *ctx)
 {
-	ctx->output.tbl.devgroup = rt_symbol_table_init("/etc/iproute2/group");
+	ctx->output.tbl.devgroup = rt_symbol_table_init("group");
 }
 
 void devgroup_table_exit(struct nft_ctx *ctx)
diff --git a/src/rt.c b/src/rt.c
index f5c80559ffeef..3ee710ddc05b5 100644
--- a/src/rt.c
+++ b/src/rt.c
@@ -25,7 +25,7 @@
 
 void realm_table_rt_init(struct nft_ctx *ctx)
 {
-	ctx->output.tbl.realm = rt_symbol_table_init("/etc/iproute2/rt_realms");
+	ctx->output.tbl.realm = rt_symbol_table_init("rt_realms");
 }
 
 void realm_table_rt_exit(struct nft_ctx *ctx)
-- 
2.43.0

