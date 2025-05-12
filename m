Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2B226AFB
	for <netfilter-devel@vger.kernel.org>; Tue, 13 May 2025 07:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747122114; cv=none; b=NsB41fUwGxB87/Dnpo8u73vOU4pockX6Hek8GrqZzqxZtqkfXnY37+vHDIm8NUvVOybS4GUFXiwL7RYdURlBozdCX2YvB6QEvTzoDsNSYg4h8zHgbLiomYzZNMGXJchDTE/Z2qrwlGtrq3JsUlG9svboXuscJHGN2K6/WSFwlwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747122114; c=relaxed/simple;
	bh=r50UNiOEJKnQWLi20xXahfSoCy7e6teXlwPaDBArhE8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jM6Mfae6HFOGoOg5/QRDZhEAZiFpQWJqntqvpmUNVHk4Xg3HtTSXqSWDuOaeuSHi5OGGXcoPf/XnGM5d4V5IopyGhpVwWhvt8Te98WT1o38odA/xMF63LvVHoxDDAKdpjkUanIgvYpa5erxxcHLPcS8lB74yxNl5aYQvRwJ5+aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=mO6QJO7d; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="mO6QJO7d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zAvzqlLb7lzBordY6Dup0jGeb86bK7rHcK0ClPhz8DQ=; b=mO6QJO7d+chWJWoWQCSNzXHyrK
	RWwVnSX5dwI3ivtesBJRbIK+FkRlJ4nRKjUHZ3fTqoR1JGHwEoRY4QXOKZjq7xMRvyZWRi827XL7M
	fEYJJEGS+fB8KlysmfpBwCaye6Zb/eJu2REnh3Wxm2TKP8Y5FLVq0KY2I8V0TuJlnlNorZG5+plJ8
	gp2RA92yhNjA5m41Gk3NoEntDEnpQSdK5KERjZfmSzq6S1VgT93MmEtzW9vx2gygwTnS6GL31/Rcl
	yEssxI/KvzplKuO9hLWhVB0ppdGJaAxAAmG+jCDCPQ2egT4LiHvafxL6RapXdjHpVdqdm56gahym7
	Cb/HHPSw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uEkGq-000000006J9-44Da;
	Tue, 13 May 2025 09:41:49 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Dan Winship <danwinship@redhat.com>
Subject: [nft RFC] table: Embed creating nft version into userdata
Date: Mon, 12 May 2025 23:03:21 +0200
Message-ID: <20250512210321.29032-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Upon listing a table which was created by a newer version of nftables,
warn about the potentially incomplete content.

Suggested-by: Florian Westphal <fw@strlen.de>
Cc: Dan Winship <danwinship@redhat.com>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/nft.h  |  2 ++
 include/rule.h |  1 +
 src/mnl.c      | 18 ++++++++++++------
 src/netlink.c  | 25 ++++++++++++++++++++++++-
 src/rule.c     |  4 ++++
 5 files changed, 43 insertions(+), 7 deletions(-)

diff --git a/include/nft.h b/include/nft.h
index a2d62dbf4808a..b406a68ffeb18 100644
--- a/include/nft.h
+++ b/include/nft.h
@@ -15,4 +15,6 @@
  * something we frequently need to do and it's intentional. */
 #define free_const(ptr) free((void *)(ptr))
 
+#define NFTNL_UDATA_TABLE_NFTVER 1
+
 #endif /* NFTABLES_NFT_H */
diff --git a/include/rule.h b/include/rule.h
index 85a0d9c0b524b..c4fecb2a8faeb 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -170,6 +170,7 @@ struct table {
 	uint32_t		owner;
 	const char		*comment;
 	bool			has_xt_stmts;
+	bool			is_from_future;
 };
 
 extern struct table *table_alloc(void);
diff --git a/src/mnl.c b/src/mnl.c
index ee51933798580..174e97ccb74f6 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1069,24 +1069,30 @@ int mnl_nft_table_add(struct netlink_ctx *ctx, struct cmd *cmd,
 	if (nlt == NULL)
 		memory_allocation_error();
 
+	udbuf = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
+	if (!udbuf)
+		memory_allocation_error();
+
 	nftnl_table_set_u32(nlt, NFTNL_TABLE_FAMILY, cmd->handle.family);
 	if (cmd->table) {
 		nftnl_table_set_u32(nlt, NFTNL_TABLE_FLAGS, cmd->table->flags);
 
 		if (cmd->table->comment) {
-			udbuf = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
-			if (!udbuf)
-				memory_allocation_error();
 			if (!nftnl_udata_put_strz(udbuf, NFTNL_UDATA_TABLE_COMMENT, cmd->table->comment))
 				memory_allocation_error();
-			nftnl_table_set_data(nlt, NFTNL_TABLE_USERDATA, nftnl_udata_buf_data(udbuf),
-					     nftnl_udata_buf_len(udbuf));
-			nftnl_udata_buf_free(udbuf);
 		}
 	} else {
 		nftnl_table_set_u32(nlt, NFTNL_TABLE_FLAGS, 0);
 	}
 
+	if (!nftnl_udata_put_strz(udbuf, NFTNL_UDATA_TABLE_NFTVER,
+				  PACKAGE_VERSION))
+		memory_allocation_error();
+	nftnl_table_set_data(nlt, NFTNL_TABLE_USERDATA,
+			     nftnl_udata_buf_data(udbuf),
+			     nftnl_udata_buf_len(udbuf));
+	nftnl_udata_buf_free(udbuf);
+
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
 				    NFT_MSG_NEWTABLE,
 				    cmd->handle.family,
diff --git a/src/netlink.c b/src/netlink.c
index 86ca32144f029..88d4cf73352f6 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -751,6 +751,7 @@ static int table_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 
 	switch (type) {
 		case NFTNL_UDATA_TABLE_COMMENT:
+		case NFTNL_UDATA_TABLE_NFTVER:
 			if (value[len - 1] != '\0')
 				return -1;
 			break;
@@ -761,10 +762,28 @@ static int table_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 	return 0;
 }
 
+static int version_cmp(const char *ver_a, const char *ver_b)
+{
+	int ax, ay, az, bx, by, bz;
+
+	if (sscanf(ver_a, "%d.%d.%d", &ax, &ay, &az) != 3 ||
+	    sscanf(ver_b, "%d.%d.%d", &bx, &by, &bz) != 3)
+		return 0;
+
+	if (ax != bx)
+		return ax - bx;
+	if (ay != by)
+		return ay - by;
+	if (az != bz)
+		return az - bz;
+
+	return strcmp(ver_a, ver_b);
+}
+
 struct table *netlink_delinearize_table(struct netlink_ctx *ctx,
 					const struct nftnl_table *nlt)
 {
-	const struct nftnl_udata *ud[NFTNL_UDATA_TABLE_MAX + 1] = {};
+	const struct nftnl_udata *ud[NFTNL_UDATA_TABLE_MAX + 2] = {}, *udtmp;
 	struct table *table;
 	const char *udata;
 	uint32_t ulen;
@@ -785,6 +804,10 @@ struct table *netlink_delinearize_table(struct netlink_ctx *ctx,
 		}
 		if (ud[NFTNL_UDATA_TABLE_COMMENT])
 			table->comment = xstrdup(nftnl_udata_get(ud[NFTNL_UDATA_TABLE_COMMENT]));
+		udtmp = ud[NFTNL_UDATA_TABLE_NFTVER];
+		if (udtmp && version_cmp(PACKAGE_VERSION,
+					 nftnl_udata_get(udtmp)) < 0)
+			table->is_from_future = true;
 	}
 
 	return table;
diff --git a/src/rule.c b/src/rule.c
index 80315837baf06..9b9a7e1e080ab 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1285,6 +1285,10 @@ static void table_print(const struct table *table, struct output_ctx *octx)
 		fprintf(octx->error_fp,
 			"# Warning: table %s %s is managed by iptables-nft, do not touch!\n",
 			family, table->handle.table.name);
+	if (table->is_from_future)
+		fprintf(octx->error_fp,
+			"# Warning: table %s %s was created by a newer version of nftables, content may be incomplete!\n",
+			family, table->handle.table.name);
 
 	nft_print(octx, "table %s %s {", family, table->handle.table.name);
 	if (nft_output_handle(octx) || table->flags & TABLE_F_OWNER)
-- 
2.49.0

