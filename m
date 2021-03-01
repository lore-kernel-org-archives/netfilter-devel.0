Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93D68C433DB
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Mar 2021 15:27:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A72864DF5
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Mar 2021 15:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237144AbhCAP1G (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Mar 2021 10:27:06 -0500
Received: from correo.us.es ([193.147.175.20]:34592 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237088AbhCAP1E (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Mar 2021 10:27:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 18962DA7E9
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Mar 2021 16:26:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 03454DA722
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Mar 2021 16:26:21 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EC773DA73F; Mon,  1 Mar 2021 16:26:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4966BDA722
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Mar 2021 16:26:18 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 01 Mar 2021 16:26:18 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 2F0FD42DC6E2
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Mar 2021 16:26:18 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] table: support for the table owner flag
Date:   Mon,  1 Mar 2021 16:26:15 +0100
Message-Id: <20210301152615.22454-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add new flag to allow userspace process to own tables: Tables that have
an owner can only be updated/destroyed by the owner. The table is
destroyed either if the owner process calls nft_ctx_free() or owner
process is terminated (implicit table release).

The ruleset listing includes the program name that owns the table:

 nft> list ruleset
 table ip x { # progname nft
        flags owner

        chain y {
                type filter hook input priority filter; policy accept;
                counter packets 1 bytes 309
        }
 }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/owner.h    |   6 ++
 include/rule.h     |   4 +-
 src/Makefile.am    |   1 +
 src/netlink.c      |   1 +
 src/owner.c        | 173 +++++++++++++++++++++++++++++++++++++++++++++
 src/parser_bison.y |   5 +-
 src/rule.c         |   9 ++-
 7 files changed, 196 insertions(+), 3 deletions(-)
 create mode 100644 include/owner.h
 create mode 100644 src/owner.c

diff --git a/include/owner.h b/include/owner.h
new file mode 100644
index 000000000000..85d821cc1ad9
--- /dev/null
+++ b/include/owner.h
@@ -0,0 +1,6 @@
+#ifndef _NFT_OWNER_H_
+#define _NFT_OWNER_H_
+
+char *get_progname(uint32_t portid);
+
+#endif
diff --git a/include/rule.h b/include/rule.h
index 87b6828edca4..523435f6f5d5 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -131,8 +131,9 @@ struct symbol *symbol_get(const struct scope *scope, const char *identifier);
 
 enum table_flags {
 	TABLE_F_DORMANT		= (1 << 0),
+	TABLE_F_OWNER		= (1 << 1),
 };
-#define TABLE_FLAGS_MAX 1
+#define TABLE_FLAGS_MAX		2
 
 const char *table_flag_name(uint32_t flag);
 
@@ -162,6 +163,7 @@ struct table {
 	struct list_head	chain_bindings;
 	enum table_flags 	flags;
 	unsigned int		refcnt;
+	uint32_t		owner;
 	const char		*comment;
 };
 
diff --git a/src/Makefile.am b/src/Makefile.am
index 3041a933bc06..2f6d434b3ad2 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -61,6 +61,7 @@ libnftables_la_SOURCES =			\
 		netlink_delinearize.c		\
 		misspell.c			\
 		monitor.c			\
+		owner.c				\
 		segtree.c			\
 		rbtree.c			\
 		gmputil.c			\
diff --git a/src/netlink.c b/src/netlink.c
index c3887d5b6662..8c86789b8369 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -614,6 +614,7 @@ struct table *netlink_delinearize_table(struct netlink_ctx *ctx,
 	table->handle.table.name = xstrdup(nftnl_table_get_str(nlt, NFTNL_TABLE_NAME));
 	table->flags	     = nftnl_table_get_u32(nlt, NFTNL_TABLE_FLAGS);
 	table->handle.handle.id = nftnl_table_get_u64(nlt, NFTNL_TABLE_HANDLE);
+	table->owner	     = nftnl_table_get_u32(nlt, NFTNL_TABLE_OWNER);
 
 	if (nftnl_table_is_set(nlt, NFTNL_TABLE_USERDATA)) {
 		udata = nftnl_table_get_data(nlt, NFTNL_TABLE_USERDATA, &ulen);
diff --git a/src/owner.c b/src/owner.c
new file mode 100644
index 000000000000..2d98a2e98028
--- /dev/null
+++ b/src/owner.c
@@ -0,0 +1,173 @@
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <sys/time.h>
+#include <time.h>
+#include <inttypes.h>
+#include <dirent.h>
+
+#include <netlink.h>
+#include <owner.h>
+
+static char *pid2name(pid_t pid)
+{
+	char procname[256], *prog;
+	FILE *fp;
+	int ret;
+
+	ret = snprintf(procname, sizeof(procname), "/proc/%lu/stat", (unsigned long)pid);
+	if (ret < 0 || ret > (int)sizeof(procname))
+		return NULL;
+
+	fp = fopen(procname, "r");
+	if (!fp)
+		return NULL;
+
+	ret = fscanf(fp, "%*u (%m[^)]", &prog);
+
+	fclose(fp);
+
+	if (ret == 1)
+		return prog;
+
+	return NULL;
+}
+
+static char *portid2name(pid_t pid, uint32_t portid, unsigned long inode)
+{
+	const struct dirent *ent;
+	char procname[256];
+	DIR *dir;
+	int ret;
+
+	ret = snprintf(procname, sizeof(procname), "/proc/%lu/fd/", (unsigned long)pid);
+	if (ret < 0 || ret >= (int)sizeof(procname))
+		return NULL;
+
+	dir = opendir(procname);
+	if (!dir)
+		return NULL;
+
+	for (;;) {
+		unsigned long ino;
+		char tmp[128];
+		ssize_t rl;
+
+		ent = readdir(dir);
+		if (!ent)
+			break;
+
+		if (ent->d_type != DT_LNK)
+			continue;
+
+		ret = snprintf(procname, sizeof(procname), "/proc/%d/fd/%s",
+			       pid, ent->d_name);
+		if (ret < 0 || ret >= (int)sizeof(procname))
+			continue;
+
+		rl = readlink(procname, tmp, sizeof(tmp));
+		if (rl <= 0 || rl > (ssize_t)sizeof(tmp))
+			continue;
+
+		tmp[rl] = 0;
+
+		ret = sscanf(tmp, "socket:[%lu]", &ino);
+		if (ret == 1 && ino == inode) {
+			closedir(dir);
+			return pid2name(pid);
+		}
+	}
+
+	closedir(dir);
+	return NULL;
+}
+
+static char *name_by_portid(uint32_t portid, unsigned long inode)
+{
+	const struct dirent *ent;
+	char *prog;
+	DIR *dir;
+
+	/* Many netlink users use their process ID to allocate the first port id. */
+	prog = portid2name(portid, portid, inode);
+	if (prog)
+		return prog;
+
+	/* no luck, search harder. */
+	dir = opendir("/proc");
+	if (!dir)
+		return NULL;
+
+	for (;;) {
+		unsigned long pid;
+		char *end;
+
+		ent = readdir(dir);
+		if (!ent)
+			break;
+
+		if (ent->d_type != DT_DIR)
+			continue;
+
+		pid = strtoul(ent->d_name, &end, 10);
+		if (pid <= 1 || *end)
+			continue;
+
+		if (pid == portid) /* already tried */
+			continue;
+
+		prog = portid2name(pid, portid, inode);
+		if (prog)
+			break;
+	}
+
+	closedir(dir);
+	return prog;
+}
+
+char *get_progname(uint32_t portid)
+{
+	FILE *fp = fopen("/proc/net/netlink", "r");
+	uint32_t portid_check;
+	unsigned long inode;
+	int ret, prot;
+
+	if (!fp)
+		return NULL;
+
+	for (;;) {
+		char line[256];
+
+		if (!fgets(line, sizeof(line), fp))
+			break;
+
+		ret = sscanf(line, "%*x %d %u %*x %*d %*d %*x %*d %*u %lu\n",
+			     &prot, &portid_check, &inode);
+
+		if (ret == EOF)
+			break;
+
+		if (ret == 3 && portid_check == portid && prot == NETLINK_NETFILTER) {
+			static uint32_t last_portid;
+			static uint32_t last_inode;
+			static char *last_program;
+			char *prog;
+
+			fclose(fp);
+
+			if (last_portid == portid && last_inode == inode)
+				return last_program;
+
+			prog = name_by_portid(portid, inode);
+
+			free(last_program);
+			last_program = prog;
+			last_portid = portid;
+			last_inode = inode;
+			return prog;
+		}
+	}
+
+	fclose(fp);
+	return NULL;
+}
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 11e899ff2f20..304ab76372f3 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1553,7 +1553,10 @@ table_block_alloc	:	/* empty */
 table_options		:	FLAGS		STRING
 			{
 				if (strcmp($2, "dormant") == 0) {
-					$<table>0->flags = TABLE_F_DORMANT;
+					$<table>0->flags |= TABLE_F_DORMANT;
+					xfree($2);
+				} else if (strcmp($2, "owner") == 0) {
+					$<table>0->flags |= TABLE_F_OWNER;
 					xfree($2);
 				} else {
 					erec_queue(error(&@2, "unknown table option %s", $2),
diff --git a/src/rule.c b/src/rule.c
index d22ab5009790..acb10f65a517 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -25,6 +25,7 @@
 #include <misspell.h>
 #include <json.h>
 #include <cache.h>
+#include <owner.h>
 
 #include <libnftnl/common.h>
 #include <libnftnl/ruleset.h>
@@ -1407,6 +1408,7 @@ struct table *table_lookup_fuzzy(const struct handle *h,
 
 static const char *table_flags_name[TABLE_FLAGS_MAX] = {
 	"dormant",
+	"owner",
 };
 
 const char *table_flag_name(uint32_t flag)
@@ -1451,8 +1453,13 @@ static void table_print(const struct table *table, struct output_ctx *octx)
 	const char *family = family2str(table->handle.family);
 
 	nft_print(octx, "table %s %s {", family, table->handle.table.name);
+	if (nft_output_handle(octx) || table->flags & TABLE_F_OWNER)
+		nft_print(octx, " #");
 	if (nft_output_handle(octx))
-		nft_print(octx, " # handle %" PRIu64, table->handle.handle.id);
+		nft_print(octx, " handle %" PRIu64, table->handle.handle.id);
+	if (table->flags & TABLE_F_OWNER)
+		nft_print(octx, " progname %s", get_progname(table->owner));
+
 	nft_print(octx, "\n");
 	table_print_flags(table, &delim, octx);
 
-- 
2.20.1

