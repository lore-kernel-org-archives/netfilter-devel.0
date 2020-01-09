Return-Path: <SRS0=zMD2=26=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B10C33CA2
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Jan 2020 17:21:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2852E2067D
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Jan 2020 17:21:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387794AbgAIRVZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Jan 2020 12:21:25 -0500
Received: from correo.us.es ([193.147.175.20]:58602 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729640AbgAIRVY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Jan 2020 12:21:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CB6DEE8D68
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2020 18:21:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BC526DA712
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2020 18:21:21 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B1DB9DA709; Thu,  9 Jan 2020 18:21:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 876F8DA718
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2020 18:21:19 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 09 Jan 2020 18:21:19 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 722E942EE38E
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2020 18:21:19 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/3] libnftables: add nft_ctx_set_netns()
Date:   Thu,  9 Jan 2020 18:21:13 +0100
Message-Id: <20200109172115.229723-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200109172115.229723-1-pablo@netfilter.org>
References: <20200109172115.229723-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This new function allows you to specify the net namespace for the
nftables command invocations.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/namespace.h            |  21 ++++++++
 include/nftables/libnftables.h |   3 ++
 src/Makefile.am                |   1 +
 src/libnftables.c              |  20 ++++++++
 src/libnftables.map            |   4 ++
 src/namespace.c                | 107 +++++++++++++++++++++++++++++++++++++++++
 6 files changed, 156 insertions(+)
 create mode 100644 include/namespace.h
 create mode 100644 src/namespace.c

diff --git a/include/namespace.h b/include/namespace.h
new file mode 100644
index 000000000000..0aa7524c1525
--- /dev/null
+++ b/include/namespace.h
@@ -0,0 +1,21 @@
+#ifndef __NAMESPACE_H__
+#define __NAMESPACE_H__
+
+#include <sched.h>
+#include <sys/mount.h>
+#include <unistd.h>
+#include <sys/syscall.h>
+#include <errno.h>
+
+/* Use the same default path as iproute2. */
+#ifndef NETNS_RUN_DIR
+#define NETNS_RUN_DIR "/var/run/netns"
+#endif
+
+#ifndef NETNS_ETC_DIR
+#define NETNS_ETC_DIR "/etc/netns"
+#endif
+
+int netns_switch(const char *netns);
+
+#endif /* __NAMESPACE_H__ */
diff --git a/include/nftables/libnftables.h b/include/nftables/libnftables.h
index 765b20dd71ee..887628959ac6 100644
--- a/include/nftables/libnftables.h
+++ b/include/nftables/libnftables.h
@@ -34,10 +34,13 @@ enum nft_debug_level {
  * Possible flags to pass to nft_ctx_new()
  */
 #define NFT_CTX_DEFAULT		0
+#define NFT_CTX_NETNS		1
 
 struct nft_ctx *nft_ctx_new(uint32_t flags);
 void nft_ctx_free(struct nft_ctx *ctx);
 
+int nft_ctx_set_netns(struct nft_ctx *ctx, const char *netns);
+
 bool nft_ctx_get_dry_run(struct nft_ctx *ctx);
 void nft_ctx_set_dry_run(struct nft_ctx *ctx, bool dry);
 
diff --git a/src/Makefile.am b/src/Makefile.am
index 740c21f2cac8..ecd9bb2f1447 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -46,6 +46,7 @@ libnftables_la_SOURCES =			\
 		numgen.c			\
 		ct.c				\
 		xfrm.c				\
+		namespace.c			\
 		netlink.c			\
 		netlink_linearize.c		\
 		netlink_delinearize.c		\
diff --git a/src/libnftables.c b/src/libnftables.c
index cd2fcf2fd522..cd1763657cec 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -12,6 +12,7 @@
 #include <parser.h>
 #include <utils.h>
 #include <iface.h>
+#include <namespace.h>
 
 #include <errno.h>
 #include <stdlib.h>
@@ -166,6 +167,25 @@ struct nft_ctx *nft_ctx_new(uint32_t flags)
 	return ctx;
 }
 
+EXPORT_SYMBOL(nft_ctx_set_netns);
+int nft_ctx_set_netns(struct nft_ctx *ctx, const char *netns)
+{
+	int err;
+
+	if (ctx->flags != NFT_CTX_NETNS) {
+		errno = EOPNOTSUPP;
+		return -1;
+	}
+
+	err = netns_switch(netns);
+	if (err < 0)
+		return err;
+
+	nft_ctx_netlink_init(ctx);
+
+	return 0;
+}
+
 static ssize_t cookie_write(void *cptr, const char *buf, size_t buflen)
 {
 	struct cookie *cookie = cptr;
diff --git a/src/libnftables.map b/src/libnftables.map
index 955af3803ee0..bb8bc5de9e59 100644
--- a/src/libnftables.map
+++ b/src/libnftables.map
@@ -23,3 +23,7 @@ global:
 
 local: *;
 };
+
+LIBNFTABLES_2 {
+  nft_ctx_set_netns;
+} LIBNFTABLES_1;
diff --git a/src/namespace.c b/src/namespace.c
new file mode 100644
index 000000000000..3ca465d68808
--- /dev/null
+++ b/src/namespace.c
@@ -0,0 +1,107 @@
+/*
+ * namespace.c
+ *
+ *		This program is free software; you can redistribute it and/or
+ *		modify it under the terms of the GNU General Public License
+ *		as published by the Free Software Foundation; either version
+ *		2 of the License, or (at your option) any later version.
+ *
+ * This code has been extracted from iproute/lib/namespace.c
+ */
+
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/statvfs.h>
+#include <fcntl.h>
+#include <dirent.h>
+#include <limits.h>
+#include <sched.h>
+#include <namespace.h>
+
+static void bind_etc(const char *name)
+{
+	char etc_netns_path[sizeof(NETNS_ETC_DIR) + NAME_MAX];
+	char netns_name[PATH_MAX];
+	char etc_name[PATH_MAX];
+	struct dirent *entry;
+	DIR *dir;
+
+	if (strlen(name) >= NAME_MAX)
+		return;
+
+	snprintf(etc_netns_path, sizeof(etc_netns_path), "%s/%s", NETNS_ETC_DIR, name);
+	dir = opendir(etc_netns_path);
+	if (!dir)
+		return;
+
+	while ((entry = readdir(dir)) != NULL) {
+		if (strcmp(entry->d_name, ".") == 0)
+			continue;
+		if (strcmp(entry->d_name, "..") == 0)
+			continue;
+		snprintf(netns_name, sizeof(netns_name), "%s/%s", etc_netns_path, entry->d_name);
+		snprintf(etc_name, sizeof(etc_name), "/etc/%s", entry->d_name);
+		if (mount(netns_name, etc_name, "none", MS_BIND, NULL) < 0) {
+			fprintf(stderr, "Bind %s -> %s failed: %s\n",
+				netns_name, etc_name, strerror(errno));
+		}
+	}
+	closedir(dir);
+}
+
+int netns_switch(const char *name)
+{
+	char net_path[PATH_MAX];
+	int netns;
+	unsigned long mountflags = 0;
+	struct statvfs fsstat;
+
+	snprintf(net_path, sizeof(net_path), "%s/%s", NETNS_RUN_DIR, name);
+	netns = open(net_path, O_RDONLY | O_CLOEXEC);
+	if (netns < 0) {
+		fprintf(stderr, "Cannot open network namespace \"%s\": %s\n",
+			name, strerror(errno));
+		return -1;
+	}
+
+	if (setns(netns, CLONE_NEWNET) < 0) {
+		fprintf(stderr, "setting the network namespace \"%s\" failed: %s\n",
+			name, strerror(errno));
+		close(netns);
+		return -1;
+	}
+	close(netns);
+
+	if (unshare(CLONE_NEWNS) < 0) {
+		fprintf(stderr, "unshare failed: %s\n", strerror(errno));
+		return -1;
+	}
+	/* Don't let any mounts propagate back to the parent */
+	if (mount("", "/", "none", MS_SLAVE | MS_REC, NULL)) {
+		fprintf(stderr, "\"mount --make-rslave /\" failed: %s\n",
+			strerror(errno));
+		return -1;
+	}
+
+	/* Mount a version of /sys that describes the network namespace */
+
+	if (umount2("/sys", MNT_DETACH) < 0) {
+		/* If this fails, perhaps there wasn't a sysfs instance mounted. Good. */
+		if (statvfs("/sys", &fsstat) == 0) {
+			/* We couldn't umount the sysfs, we'll attempt to overlay it.
+			 * A read-only instance can't be shadowed with a read-write one. */
+			if (fsstat.f_flag & ST_RDONLY)
+				mountflags = MS_RDONLY;
+		}
+	}
+	if (mount(name, "/sys", "sysfs", mountflags, NULL) < 0) {
+		fprintf(stderr, "mount of /sys failed: %s\n",strerror(errno));
+		return -1;
+	}
+
+	/* Setup bind mounts for config files in /etc */
+	bind_etc(name);
+	return 0;
+}
-- 
2.11.0

