Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4412110
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Aug 2025 12:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754657195; cv=none; b=IT9SHsXFfFWVcZlNbK0pEPS2Wfql2hT0dO/Sw1Z6lasMj+XZMwwBispn7IFGb2iD6Ips3SddJJtquJ4oRSOw8M9iy6KLXWPZ4sTS2pnOpz3eBt+uUsAZGnStLQ8Yd0+7T5aLmNw/T8Qbn7iDnLuRY2DPY7xgp++MmXYbxGVxo4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754657195; c=relaxed/simple;
	bh=ePDBQO50Jv84dJaWAln7XsAmhXIjpXtWhfZFtnRq1TA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XCmK9yaSx1vn6XHwgsh2iPZQIlXxcy4aFxb98jJ3BRfZ5+VsNK+aduUQVKZjP+hKyd1xOyMuYJunOldpLwT6rw8ehiCdUc8SONINzXS/VaqlqcyoBDYZGUdvcf99B1l5WnhKC7jEI0a2kUeZ+HvTTqmmUgmSB3+UthHjQ+kiHAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=fO8m2RKN; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="fO8m2RKN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=azYu3c79Yg57SFN6Mb9YxGiJSH3dcZc2DGgY2m1UbrU=; b=fO8m2RKNoSOLDyvbEjmh0vL6Np
	RVoL1qHrEdYMnjAfN5st95qMEN1KxJBTgvHgSzKC9f4m+LUPB6aM30nhD1p4FN4pgRi4iAit9W8/V
	8lEc426hASN29qmrP0ajiWegDns571XQED3VhM0DJyuv9vARtoCfToAnHhIPwoMde1ZXW0oa1qTj2
	No1Dliuo1W0pXIzS2fY32UNm0Vmbn9d5Uj431bpkG6f3rQP1iRwSpuuJNryXlqllaB8XPLs+LKpSN
	qpja4nb9JddJ9vuPD9z/5zg0mbn3unBncpz4q9j5vjdqx5RQeFyxk8erXoLPVeWnjedRuwkBXPJVg
	9veMneag==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ukMUP-000000001tU-3m0i;
	Fri, 08 Aug 2025 14:46:29 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Dan Winship <danwinship@redhat.com>
Subject: [nft PATCH] table: Embed creating nft version into userdata
Date: Fri,  8 Aug 2025 14:46:18 +0200
Message-ID: <20250808124624.30768-1-phil@nwl.cc>
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
Changes since RFC:
- Change NFTNL_UDATA_TABLE_NFTVER content from string (PACKAGE_VERSION)
  to 12Byte binary data consisting of:
  - the version 3-tuple
  - a stable release number specified at configure-time
  - the build time in seconds since epoch (a 64bit value - could scrap
    some bytes, but maybe worth leaving some space)
---
 .gitignore     |  1 +
 Makefile.am    |  3 +++
 configure.ac   | 22 ++++++++++++++++++++++
 include/nft.h  |  2 ++
 include/rule.h |  1 +
 src/mnl.c      | 19 +++++++++++++------
 src/netlink.c  | 23 ++++++++++++++++++++++-
 src/rule.c     |  4 ++++
 8 files changed, 68 insertions(+), 7 deletions(-)

diff --git a/.gitignore b/.gitignore
index a62e31f31c6b5..1e3bc5146b2f1 100644
--- a/.gitignore
+++ b/.gitignore
@@ -14,6 +14,7 @@ autom4te.cache
 build-aux/
 libnftables.pc
 libtool
+nftversion.h
 
 # cscope files
 /cscope.*
diff --git a/Makefile.am b/Makefile.am
index b5580b5451fca..ca6af2e393bed 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -33,6 +33,7 @@ sbin_PROGRAMS =
 check_PROGRAMS =
 dist_man_MANS =
 CLEANFILES =
+DISTCLEANFILES =
 
 ###############################################################################
 
@@ -106,6 +107,8 @@ noinst_HEADERS = \
 	\
 	$(NULL)
 
+DISTCLEANFILES += nftversion.h
+
 ###############################################################################
 
 AM_CPPFLAGS = \
diff --git a/configure.ac b/configure.ac
index 550913ef04964..2c68c2b8e0560 100644
--- a/configure.ac
+++ b/configure.ac
@@ -114,6 +114,28 @@ AC_CHECK_DECLS([getprotobyname_r, getprotobynumber_r, getservbyport_r], [], [],
 #include <netdb.h>
 ]])
 
+AC_ARG_WITH([stable-release], [AS_HELP_STRING([--with-stable-release],
+            [Stable release number])],
+            [], [with_stable_release=0])
+AC_CONFIG_COMMANDS([stable_release],
+                   [STABLE_RELEASE=$stable_release],
+                   [stable_release=$with_stable_release])
+AC_CONFIG_COMMANDS([nftversion.h], [
+(
+	echo "static char nftversion[[]] = {"
+	echo "	${VERSION}," | tr '.' ','
+	echo "	${STABLE_RELEASE},"
+	for ((i = 56; i >= 0; i-= 8)); do
+		echo "	((uint64_t)MAKE_STAMP >> $i) & 0xff,"
+	done
+	echo "};"
+) >nftversion.h
+])
+# Current date should be fetched exactly once per build,
+# so have 'make' call date and pass the value to every 'gcc' call
+AC_SUBST([MAKE_STAMP], ["\$(shell date +%s)"])
+CFLAGS="${CFLAGS} -DMAKE_STAMP=\${MAKE_STAMP}"
+
 AC_CONFIG_FILES([					\
 		Makefile				\
 		libnftables.pc				\
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
index 470ae10754ba5..319f9c39f1107 100644
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
index 43229f2498e55..67ec60a6fee00 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -10,6 +10,7 @@
 
 #include <nft.h>
 #include <iface.h>
+#include <nftversion.h>
 
 #include <libmnl/libmnl.h>
 #include <libnftnl/common.h>
@@ -1074,24 +1075,30 @@ int mnl_nft_table_add(struct netlink_ctx *ctx, struct cmd *cmd,
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
 
+	if (!nftnl_udata_put(udbuf, NFTNL_UDATA_TABLE_NFTVER,
+			     sizeof(nftversion), nftversion))
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
index 94cbcbfc6c094..97a49c08b1e82 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -10,6 +10,7 @@
  */
 
 #include <nft.h>
+#include <nftversion.h>
 
 #include <errno.h>
 #include <libmnl/libmnl.h>
@@ -799,6 +800,10 @@ static int table_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 			if (value[len - 1] != '\0')
 				return -1;
 			break;
+		case NFTNL_UDATA_TABLE_NFTVER:
+			if (len != sizeof(nftversion))
+				return -1;
+			break;
 		default:
 			return 0;
 	}
@@ -806,10 +811,23 @@ static int table_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 	return 0;
 }
 
+static int version_cmp(const struct nftnl_udata *ud)
+{
+	const char *udbuf = nftnl_udata_get(ud);
+	size_t i;
+
+	/* udbuf length checked by table_parse_udata_cb() */
+	for (i = 0; i < sizeof(nftversion); i++) {
+		if (nftversion[i] != udbuf[i])
+			return nftversion[i] - udbuf[i];
+	}
+	return 0;
+}
+
 struct table *netlink_delinearize_table(struct netlink_ctx *ctx,
 					const struct nftnl_table *nlt)
 {
-	const struct nftnl_udata *ud[NFTNL_UDATA_TABLE_MAX + 1] = {};
+	const struct nftnl_udata *ud[NFTNL_UDATA_TABLE_MAX + 2] = {};
 	struct table *table;
 	const char *udata;
 	uint32_t ulen;
@@ -830,6 +848,9 @@ struct table *netlink_delinearize_table(struct netlink_ctx *ctx,
 		}
 		if (ud[NFTNL_UDATA_TABLE_COMMENT])
 			table->comment = xstrdup(nftnl_udata_get(ud[NFTNL_UDATA_TABLE_COMMENT]));
+		if (ud[NFTNL_UDATA_TABLE_NFTVER] &&
+		    version_cmp(ud[NFTNL_UDATA_TABLE_NFTVER]) < 0)
+			table->is_from_future = true;
 	}
 
 	return table;
diff --git a/src/rule.c b/src/rule.c
index 0ad948ea87f2f..fd69c622cfe75 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1298,6 +1298,10 @@ static void table_print(const struct table *table, struct output_ctx *octx)
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

