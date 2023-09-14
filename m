Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A15EDE9A6
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Sep 2023 11:17:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236954AbjINLRb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Sep 2023 07:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236893AbjINLR3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Sep 2023 07:17:29 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B091FD5
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Sep 2023 04:17:23 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qgkLa-00033e-H4; Thu, 14 Sep 2023 13:17:22 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel@vger.kernel.org
Cc:     Romain Bellan <romain.bellan@wifirst.fr>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 libnetfilter_conntrack 2/2] utils: add NFCT_FILTER_DUMP_TUPLE example
Date:   Thu, 14 Sep 2023 13:16:53 +0200
Message-ID: <20230914111703.1145582-2-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230914111703.1145582-1-fw@strlen.de>
References: <20230914111703.1145582-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Romain Bellan <romain.bellan@wifirst.fr>

Simple example to see conntrack kernel side filtering configuration.
Callback is reading the kernel result, and user is notified when kernel
does not support filtering (so filtering must be done in userspace)

Signed-off-by: Romain Bellan <romain.bellan@wifirst.fr>
Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 utils/.gitignore                    |  1 +
 utils/Makefile.am                   |  4 ++
 utils/conntrack_dump_filter_tuple.c | 70 +++++++++++++++++++++++++++++
 3 files changed, 75 insertions(+)
 create mode 100644 utils/conntrack_dump_filter_tuple.c

diff --git a/utils/.gitignore b/utils/.gitignore
index 63dfcb2d3d30..0de05c02f4b6 100644
--- a/utils/.gitignore
+++ b/utils/.gitignore
@@ -3,6 +3,7 @@
 /conntrack_delete
 /conntrack_dump
 /conntrack_dump_filter
+/conntrack_dump_filter_tuple
 /conntrack_events
 /conntrack_filter
 /conntrack_flush
diff --git a/utils/Makefile.am b/utils/Makefile.am
index 69bafe68b002..438ca74c829d 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -9,6 +9,7 @@ check_PROGRAMS = expect_dump expect_create expect_get expect_delete \
 	       conntrack_master conntrack_filter \
 	       conntrack_grp_create \
 	       conntrack_dump_filter \
+	       conntrack_dump_filter_tuple \
 	       ctexp_events
 
 conntrack_grp_create_SOURCES = conntrack_grp_create.c
@@ -35,6 +36,9 @@ conntrack_dump_LDADD = ../src/libnetfilter_conntrack.la
 conntrack_dump_filter_SOURCES = conntrack_dump_filter.c
 conntrack_dump_filter_LDADD = ../src/libnetfilter_conntrack.la
 
+conntrack_dump_filter_tuple_SOURCES = conntrack_dump_filter_tuple.c
+conntrack_dump_filter_tuple_LDADD = ../src/libnetfilter_conntrack.la
+
 conntrack_flush_SOURCES = conntrack_flush.c
 conntrack_flush_LDADD = ../src/libnetfilter_conntrack.la
 
diff --git a/utils/conntrack_dump_filter_tuple.c b/utils/conntrack_dump_filter_tuple.c
new file mode 100644
index 000000000000..44633daa900c
--- /dev/null
+++ b/utils/conntrack_dump_filter_tuple.c
@@ -0,0 +1,70 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <arpa/inet.h>
+
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+
+static int cb(const struct nlmsghdr *nlh,
+	      enum nf_conntrack_msg_type type,
+	      struct nf_conntrack *ct,
+	      void *data)
+{
+	char buf[1024];
+
+	if (!(nlh->nlmsg_flags & NLM_F_DUMP_FILTERED))
+	  {
+	    fprintf(stderr, "No filtering in kernel, do filtering in userspace\n");
+	    return NFCT_CB_FAILURE;
+	  }
+
+	nfct_snprintf(buf, sizeof(buf), ct, NFCT_T_UNKNOWN, NFCT_O_DEFAULT, NFCT_OF_SHOW_LAYER3 | NFCT_OF_TIMESTAMP);
+	printf("%s\n", buf);
+
+	return NFCT_CB_CONTINUE;
+}
+
+int main(void)
+{
+	int ret;
+	struct nfct_handle *h;
+
+	h = nfct_open(CONNTRACK, 0);
+	if (!h) {
+		perror("nfct_open");
+		return -1;
+	}
+	struct nfct_filter_dump *filter_dump = nfct_filter_dump_create();
+	if (filter_dump == NULL) {
+		perror("nfct_filter_dump_alloc");
+		return -1;
+	}
+
+	struct nf_conntrack	*ct;
+	ct = nfct_new();
+	if (!ct) {
+		perror("nfct_new");
+		return 0;
+	}
+
+	nfct_set_attr_u8(ct, ATTR_ORIG_L3PROTO, AF_INET);
+	nfct_set_attr_u8(ct, ATTR_L4PROTO, IPPROTO_ICMP);
+	nfct_set_attr_u32(ct, ATTR_ORIG_IPV4_DST, inet_addr("203.0.113.55"));
+	nfct_filter_dump_set_attr(filter_dump, NFCT_FILTER_DUMP_TUPLE, ct);
+
+	nfct_callback_register2(h, NFCT_T_ALL, cb, NULL);
+	ret = nfct_query(h, NFCT_Q_DUMP_FILTER, filter_dump);
+
+	nfct_filter_dump_destroy(filter_dump);
+
+	printf("TEST: get conntrack ");
+	if (ret == -1)
+		printf("(%d)(%s)\n", ret, strerror(errno));
+	else
+		printf("(OK)\n");
+
+	nfct_close(h);
+
+	ret == -1 ? exit(EXIT_FAILURE) : exit(EXIT_SUCCESS);
+}
-- 
2.41.0

