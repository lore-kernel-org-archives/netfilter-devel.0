Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDBB2C2BBCA
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Dec 2020 18:50:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE10522B3B
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Dec 2020 18:50:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731718AbgLOSum (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Dec 2020 13:50:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731704AbgLOSud (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Dec 2020 13:50:33 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B35CC0617A6
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Dec 2020 10:49:53 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kpFOQ-00066Q-To; Tue, 15 Dec 2020 19:49:50 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH conntrack-tools] conntrack: pretty-print the portid
Date:   Tue, 15 Dec 2020 19:49:43 +0100
Message-Id: <20201215184943.23359-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

DESTROY events already include the portid.  Add some /proc glue
to lookup the portid.

Problem is that there is no direct mapping to a name.
Lookup steps are:
1. Obtain the portid inode from /proc/net/netlink.
   If we can't even find that, no luck.
   If the reported id matches the cached inode of the found
   portid, use the cached result.

2. assume portid == pid and search
   /proc/portid/fd/ for a socket with matching inode.
   If we can't find that, repeat this for every pid.

As this is quite some work, cache the last result so 'conntrack -F'
will only cause this lookup to run once.

The lookup also won't work in case the deleting/flushing program
has already exited, thus a negative result will be cached too.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/conntrack.c | 179 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 172 insertions(+), 7 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index d05a5991dae2..cc58d3f3df7f 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -55,6 +55,7 @@
 #include <sys/time.h>
 #include <time.h>
 #include <inttypes.h>
+#include <dirent.h>
 #ifdef HAVE_ARPA_INET_H
 #include <arpa/inet.h>
 #endif
@@ -1671,6 +1672,169 @@ exp_event_sighandler(int s)
 	exit(0);
 }
 
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
+static char *get_progname(uint32_t portid)
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
+
 static int event_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nfgenmsg *nfh = mnl_nlmsg_get_payload(nlh);
@@ -1679,7 +1843,6 @@ static int event_cb(const struct nlmsghdr *nlh, void *data)
 	enum nf_conntrack_msg_type type;
 	unsigned int op_flags = 0;
 	struct nf_conntrack *ct;
-	bool userspace = false;
 	char buf[1024];
 
 	switch(nlh->nlmsg_type & 0xff) {
@@ -1740,14 +1903,16 @@ static int event_cb(const struct nlmsghdr *nlh, void *data)
 
 	nfct_snprintf_labels(buf, sizeof(buf), ct, type, op_type, op_flags, labelmap);
 done:
-	if (output_mask & _O_US) {
-		if (nlh->nlmsg_pid)
-			userspace = true;
+	if ((output_mask & _O_US) && nlh->nlmsg_pid) {
+		char *prog = get_progname(nlh->nlmsg_pid);
+
+		if (prog)
+			printf("%s [USERSPACE] portid=%u progname=%s\n", buf, nlh->nlmsg_pid, prog);
 		else
-			userspace = false;
+			printf("%s [USERSPACE] portid=%u\n", buf, nlh->nlmsg_pid);
+	} else {
+		puts(buf);
 	}
-
-	printf("%s%s\n", buf, userspace ? " [USERSPACE]" : "");
 	fflush(stdout);
 
 	counter++;
-- 
2.26.2

