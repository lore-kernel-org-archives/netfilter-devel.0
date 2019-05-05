Return-Path: <SRS0=aMTL=TF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60CC6C004C9
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 May 2019 21:01:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36E46205F4
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 May 2019 21:01:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbfEEVBk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 May 2019 17:01:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:45420 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727295AbfEEVBk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 May 2019 17:01:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8741DAE72;
        Sun,  5 May 2019 21:01:38 +0000 (UTC)
From:   Petr Vorel <pvorel@suse.cz>
To:     netfilter-devel@vger.kernel.org
Cc:     Petr Vorel <pvorel@suse.cz>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jan Engelhardt <jengelh@medozas.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH libmnl 1/1] examples: Add rtnl-addr-add.c
Date:   Sun,  5 May 2019 23:01:30 +0200
Message-Id: <20190505210130.31682-1-pvorel@suse.cz>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Petr Vorel <pvorel@suse.cz>
---
Hi,

a patch to save searching for people using libmnl for manipulating IP
addresses.

Kind regards,
Petr
---
 examples/rtnl/.gitignore      |   1 +
 examples/rtnl/Makefile.am     |   6 +-
 examples/rtnl/rtnl-addr-add.c | 119 ++++++++++++++++++++++++++++++++++
 3 files changed, 125 insertions(+), 1 deletion(-)
 create mode 100644 examples/rtnl/rtnl-addr-add.c

diff --git a/examples/rtnl/.gitignore b/examples/rtnl/.gitignore
index b03a27d..24ac633 100644
--- a/examples/rtnl/.gitignore
+++ b/examples/rtnl/.gitignore
@@ -1,3 +1,4 @@
+/rtnl-addr-add
 /rtnl-link-dump
 /rtnl-link-dump2
 /rtnl-link-dump3
diff --git a/examples/rtnl/Makefile.am b/examples/rtnl/Makefile.am
index 174a4fb..dd8a77d 100644
--- a/examples/rtnl/Makefile.am
+++ b/examples/rtnl/Makefile.am
@@ -1,6 +1,7 @@
 include $(top_srcdir)/Make_global.am
 
-check_PROGRAMS = rtnl-addr-dump \
+check_PROGRAMS = rtnl-addr-add \
+		 rtnl-addr-dump \
 		 rtnl-link-dump rtnl-link-dump2 rtnl-link-dump3 \
 		 rtnl-link-event \
 		 rtnl-link-set \
@@ -9,6 +10,9 @@ check_PROGRAMS = rtnl-addr-dump \
 		 rtnl-route-event \
 		 rtnl-neigh-dump
 
+rtnl_addr_add_SOURCES = rtnl-addr-add.c
+rtnl_addr_add_LDADD = ../../src/libmnl.la
+
 rtnl_addr_dump_SOURCES = rtnl-addr-dump.c
 rtnl_addr_dump_LDADD = ../../src/libmnl.la
 
diff --git a/examples/rtnl/rtnl-addr-add.c b/examples/rtnl/rtnl-addr-add.c
new file mode 100644
index 0000000..f0c2fda
--- /dev/null
+++ b/examples/rtnl/rtnl-addr-add.c
@@ -0,0 +1,119 @@
+/* This example is placed in the public domain. */
+#include <netinet/in.h>
+#include <arpa/inet.h>
+#include <time.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <strings.h>
+#include <net/if.h>
+
+#include <libmnl/libmnl.h>
+#include <linux/if_link.h>
+#include <linux/rtnetlink.h>
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	struct ifaddrmsg *ifm;
+	uint32_t seq, portid;
+	union {
+		in_addr_t ip;
+		struct in6_addr ip6;
+	} addr;
+	int ret, family = AF_INET;
+
+	uint32_t prefix;
+	int iface;
+
+
+	if (argc <= 3) {
+		printf("Usage: %s iface destination cidr\n", argv[0]);
+		printf("Example: %s eth0 10.0.1.12 32\n", argv[0]);
+		printf("	 %s eth0 ffff::10.0.1.12 128\n", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	iface = if_nametoindex(argv[1]);
+	if (iface == 0) {
+		perror("if_nametoindex");
+		exit(EXIT_FAILURE);
+	}
+
+	if (!inet_pton(AF_INET, argv[2], &addr)) {
+		if (!inet_pton(AF_INET6, argv[2], &addr)) {
+			perror("inet_pton");
+			exit(EXIT_FAILURE);
+		}
+		family = AF_INET6;
+	}
+
+	if (sscanf(argv[3], "%u", &prefix) == 0) {
+		perror("sscanf");
+		exit(EXIT_FAILURE);
+	}
+
+	nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type	= RTM_NEWADDR;
+
+	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_CREATE | NLM_F_REPLACE | NLM_F_ACK;
+	nlh->nlmsg_seq = seq = time(NULL);
+
+	ifm = mnl_nlmsg_put_extra_header(nlh, sizeof(struct ifaddrmsg));
+
+	ifm->ifa_family = family;
+	ifm->ifa_prefixlen = prefix;
+	ifm->ifa_flags = IFA_F_PERMANENT;
+
+	ifm->ifa_scope = RT_SCOPE_UNIVERSE;
+	ifm->ifa_index = iface;
+
+	/*
+	 * The exact meaning of IFA_LOCAL and IFA_ADDRESS depend
+	 * on the address family being used and the device type.
+	 * For broadcast devices (like the interfaces we use),
+	 * for IPv4 we specify both and they are used interchangeably.
+	 * For IPv6, only IFA_ADDRESS needs to be set.
+	 */
+	if (family == AF_INET) {
+		mnl_attr_put_u32(nlh, IFA_LOCAL, addr.ip);
+		mnl_attr_put_u32(nlh, IFA_ADDRESS, addr.ip);
+	}
+	else
+		mnl_attr_put(nlh, IFA_ADDRESS, sizeof(struct in6_addr), &addr);
+
+	nl = mnl_socket_open(NETLINK_ROUTE);
+	if (nl == NULL) {
+		perror("mnl_socket_open");
+		exit(EXIT_FAILURE);
+	}
+
+	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
+		perror("mnl_socket_bind");
+		exit(EXIT_FAILURE);
+	}
+	portid = mnl_socket_get_portid(nl);
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		perror("mnl_socket_sendto");
+		exit(EXIT_FAILURE);
+	}
+
+	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	if (ret < 0) {
+		perror("mnl_socket_recvfrom");
+		exit(EXIT_FAILURE);
+	}
+
+	ret = mnl_cb_run(buf, ret, seq, portid, NULL, NULL);
+	if (ret < 0) {
+		perror("mnl_cb_run");
+		exit(EXIT_FAILURE);
+	}
+
+	mnl_socket_close(nl);
+
+	return 0;
+}
-- 
2.21.0

