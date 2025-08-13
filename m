Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2643B303C83
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 17:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755104922; cv=none; b=TkTqHHUG5/zK5r7aDs+IXQ3087DqnO5/Eg6dPj75K2Bjs37/LOxbJ0HFC/Rz5kiMnsd1+yUYhx02bUhnFGI9Q/4usbeQnNGI+bifzNRm0D1zwuLYg7Scl1IbUQ+edOWPi9yGQi+OZQbkkL/tSoyDkyM+madElbjn65NLDijuiZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755104922; c=relaxed/simple;
	bh=/ih/tPGQXEl0Ex+sBXveLkj6DhacF4MEASe9poO3ZcE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t/IAcRMhdSn2tJtBqzC/46n8gRas8ek/H+uZb1R003ofPj6rc3IW7E/D/6c7+n8cmhqTxOt7ZIjdxa9NtuwrDm47rio1upS6wlHWf+NnFSxcOpqHtF/Lp7/SrajR3AL3iO10g6WQ2wimk0k8Dos9q3LmZdGdxMDxKJH93h7Y45Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=h51DrDpu; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="h51DrDpu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=74pm2wOcRQYzrReoFhGhyVRUxyBsgV9iu4Xa7FUfkyY=; b=h51DrDpuP72MBgEKaYvzEmYpBP
	VAIH19MOwM7IADs7dqmD55nn56xFbXSgk0/+Watj3A+Yv0J37xL3Mchy5qYQecNp05HhqRQMdujAv
	cQ2kiCPiGhat/VBrqWVoIDnEaibVKMHeB1O+WwYIqgUX8wl8JG8dAjbbsOkXCwWYs26QLVmKkuVD6
	47Rbt8jWjDTmfBXztCGAg9jrfLSodsdrYetYPxB/pKt7kZ7sX+EzEpK4f6M31Ls3/l7W4j5pIMwRH
	RTToLetOCaRPG8NK5ot6uLZbHtD/c/L6sfvex5Xlv7hGDNjQJQPJKNFHfLuTzzPHg6NdFhOMWdxj/
	Zhw3RMoA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1umExq-000000003q4-3mgZ;
	Wed, 13 Aug 2025 19:08:38 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Dan Winship <danwinship@redhat.com>
Subject: [nft PATCH] table: Embed creating nft version into userdata
Date: Wed, 13 Aug 2025 19:07:19 +0200
Message-ID: <20250813170833.28585-1-phil@nwl.cc>
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
Changes since v1:
- Keep version and build timestamp separate in nftversion.h (separate
  variables) and netlink (separate attributes)
- Drop NFTNL_UDATA_TABLE_NFTVER define, rely upon updated libnftnl
  headers instead (we need a correct value in NFTNL_UDATA_TABLE_MAX as
  well, so no point in introducing hacks)
- Perform attribute existence checks in version_cmp() itself, kernel
  data may contain one or the other or both or none at all
- Minor warning adjustment as requested

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
 configure.ac   | 24 ++++++++++++++++++++++++
 include/rule.h |  1 +
 src/mnl.c      | 21 +++++++++++++++------
 src/netlink.c  | 33 +++++++++++++++++++++++++++++++++
 src/rule.c     |  4 ++++
 7 files changed, 81 insertions(+), 6 deletions(-)

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
index 550913ef04964..55fecbc56660a 100644
--- a/configure.ac
+++ b/configure.ac
@@ -114,6 +114,30 @@ AC_CHECK_DECLS([getprotobyname_r, getprotobynumber_r, getservbyport_r], [], [],
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
+	echo "	${STABLE_RELEASE}"
+	echo "};"
+	echo "static char nftbuildstamp[[]] = {"
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
index 43229f2498e55..ec4d73d12460a 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -10,6 +10,7 @@
 
 #include <nft.h>
 #include <iface.h>
+#include <nftversion.h>
 
 #include <libmnl/libmnl.h>
 #include <libnftnl/common.h>
@@ -1074,24 +1075,32 @@ int mnl_nft_table_add(struct netlink_ctx *ctx, struct cmd *cmd,
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
+			     sizeof(nftversion), nftversion) ||
+	    !nftnl_udata_put(udbuf, NFTNL_UDATA_TABLE_NFTBLD,
+	                     sizeof(nftbuildstamp), nftbuildstamp))
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
index 94cbcbfc6c094..b5da33e5a1e53 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -10,6 +10,7 @@
  */
 
 #include <nft.h>
+#include <nftversion.h>
 
 #include <errno.h>
 #include <libmnl/libmnl.h>
@@ -799,6 +800,14 @@ static int table_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 			if (value[len - 1] != '\0')
 				return -1;
 			break;
+		case NFTNL_UDATA_TABLE_NFTVER:
+			if (len != sizeof(nftversion))
+				return -1;
+			break;
+		case NFTNL_UDATA_TABLE_NFTBLD:
+			if (len != sizeof(nftbuildstamp))
+				return -1;
+			break;
 		default:
 			return 0;
 	}
@@ -806,6 +815,29 @@ static int table_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 	return 0;
 }
 
+static int version_cmp(const struct nftnl_udata **ud)
+{
+	const char *udbuf;
+	size_t i;
+
+	/* netlink attribute lengths checked by table_parse_udata_cb() */
+	if (ud[NFTNL_UDATA_TABLE_NFTVER]) {
+		udbuf = nftnl_udata_get(ud[NFTNL_UDATA_TABLE_NFTVER]);
+		for (i = 0; i < sizeof(nftversion); i++) {
+			if (nftversion[i] != udbuf[i])
+				return nftversion[i] - udbuf[i];
+		}
+	}
+	if (ud[NFTNL_UDATA_TABLE_NFTBLD]) {
+		udbuf = nftnl_udata_get(ud[NFTNL_UDATA_TABLE_NFTBLD]);
+		for (i = 0; i < sizeof(nftbuildstamp); i++) {
+			if (nftbuildstamp[i] != udbuf[i])
+				return nftbuildstamp[i] - udbuf[i];
+		}
+	}
+	return 0;
+}
+
 struct table *netlink_delinearize_table(struct netlink_ctx *ctx,
 					const struct nftnl_table *nlt)
 {
@@ -830,6 +862,7 @@ struct table *netlink_delinearize_table(struct netlink_ctx *ctx,
 		}
 		if (ud[NFTNL_UDATA_TABLE_COMMENT])
 			table->comment = xstrdup(nftnl_udata_get(ud[NFTNL_UDATA_TABLE_COMMENT]));
+		table->is_from_future = version_cmp(ud) < 0;
 	}
 
 	return table;
diff --git a/src/rule.c b/src/rule.c
index 0ad948ea87f2f..398e5bdd4c64e 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1298,6 +1298,10 @@ static void table_print(const struct table *table, struct output_ctx *octx)
 		fprintf(octx->error_fp,
 			"# Warning: table %s %s is managed by iptables-nft, do not touch!\n",
 			family, table->handle.table.name);
+	if (table->is_from_future)
+		fprintf(octx->error_fp,
+			"# Warning: table %s %s was created by a newer version of nftables? Content may be incomplete!\n",
+			family, table->handle.table.name);
 
 	nft_print(octx, "table %s %s {", family, table->handle.table.name);
 	if (nft_output_handle(octx) || table->flags & TABLE_F_OWNER)
-- 
2.49.0

