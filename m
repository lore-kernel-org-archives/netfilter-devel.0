From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 5/5] examples: get XML ruleset
Date: Mon, 03 Jun 2013 22:44:56 +0200
Message-ID: <20130603204456.27713.86423.stgit@nfdev.cica.es>
References: <20130603204451.27713.51887.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42361 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758113Ab3FCUpG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Jun 2013 16:45:06 -0400
In-Reply-To: <20130603204451.27713.51887.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This example code prints out the current ruleset in XML format.
In a near future, when sets are XML-handled this example will be updated.

Take this as a proposal. There are many ways to print out the ruleset in XML.
 * Nesting or not rules in each chain.
 * Nesting or not each chain in his corresponding table.
 * Using other naming scheme for top level elements, like '<nftables>' and/or '<ruleset>'.

Also note that ATM there is no implementation to parse the whole ruleset but objects (table/chain/rule).

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/Makefile.am           |    4 +
 examples/nft-ruleset-xml-get.c |  265 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 269 insertions(+)
 create mode 100644 examples/nft-ruleset-xml-get.c

diff --git a/examples/Makefile.am b/examples/Makefile.am
index dcf798a..49488b8 100644
--- a/examples/Makefile.am
+++ b/examples/Makefile.am
@@ -13,6 +13,7 @@ check_PROGRAMS = nft-table-add		\
 		 nft-rule-xml-add	\
 		 nft-rule-del		\
 		 nft-rule-get		\
+		 nft-ruleset-xml-get	\
 		 nft-events		\
 		 nft-set-add		\
 		 nft-set-get		\
@@ -61,6 +62,9 @@ nft_rule_del_LDADD = ../src/libnftables.la ${LIBMNL_LIBS} ${LIBXML_LIBS}
 nft_rule_get_SOURCES = nft-rule-get.c
 nft_rule_get_LDADD = ../src/libnftables.la ${LIBMNL_LIBS} ${LIBXML_LIBS}
 
+nft_ruleset_xml_get_SOURCES = nft-ruleset-xml-get.c
+nft_ruleset_xml_get_LDADD = ../src/libnftables.la ${LIBMNL_LIBS} ${LIBXML_LIBS}
+
 nft_events_SOURCES = nft-events.c
 nft_events_LDADD = ../src/libnftables.la ${LIBMNL_LIBS} ${LIBXML_LIBS}
 
diff --git a/examples/nft-ruleset-xml-get.c b/examples/nft-ruleset-xml-get.c
new file mode 100644
index 0000000..b93e55d
--- /dev/null
+++ b/examples/nft-ruleset-xml-get.c
@@ -0,0 +1,265 @@
+/*
+ * (C) 2013 Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#define SNPRINTF_BUFFER_SIZE(ret, size, len, offset)	\
+	size += ret;					\
+	if (ret > len)					\
+		ret = len;				\
+	offset += ret;					\
+	len -= ret;
+
+#include <stdlib.h>
+#include <time.h>
+#include <string.h>
+#include <netinet/in.h>
+
+#include <linux/netfilter/nf_tables.h>
+
+#include <libmnl/libmnl.h>
+#include <libnftables/table.h>
+#include <libnftables/chain.h>
+#include <libnftables/rule.h>
+#include <libnftables/set.h>
+
+struct printdata {
+	char *buf;
+	int ret;
+	long int size;
+	int len;
+	int offset;
+} ;
+
+static int table_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nft_table *t;
+	struct printdata *p = (struct printdata *)data;
+
+	t = nft_table_alloc();
+	if (t == NULL) {
+		perror("OOM");
+		goto err;
+	}
+
+	if (nft_table_nlmsg_parse(nlh, t) < 0) {
+		perror("nft_table_nlmsg_parse");
+		goto err_free;
+	}
+
+	p->ret = nft_table_snprintf(p->buf+p->offset, p->size, t, NFT_TABLE_O_XML, 0);
+	SNPRINTF_BUFFER_SIZE(p->ret, p->size, p->len, p->offset);
+
+err_free:
+	nft_table_free(t);
+err:
+	return MNL_CB_OK;
+}
+
+static int chain_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nft_chain *c;
+	struct printdata *p = (struct printdata *)data;
+
+	c = nft_chain_alloc();
+	if (c == NULL) {
+		perror("OOM");
+		goto err;
+	}
+
+	if (nft_chain_nlmsg_parse(nlh, c) < 0) {
+		perror("nft_chain_nlmsg_parse");
+		goto err_free;
+	}
+
+	p->ret = nft_chain_snprintf(p->buf+p->offset, p->size, c, NFT_CHAIN_O_XML, 0);
+	SNPRINTF_BUFFER_SIZE(p->ret, p->size, p->len, p->offset);
+
+err_free:
+	nft_chain_free(c);
+err:
+	return MNL_CB_OK;
+}
+
+static int rule_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nft_rule *r;
+	struct printdata *p = (struct printdata *)data;
+
+	r = nft_rule_alloc();
+	if (r == NULL) {
+		perror("OOM");
+		goto err;
+	}
+
+	if (nft_rule_nlmsg_parse(nlh, r) < 0) {
+		perror("nft_rule_nlmsg_parse");
+		goto err_free;
+	}
+
+	p->ret = nft_rule_snprintf(p->buf+p->offset, p->size, r, NFT_RULE_O_XML, 0);
+	SNPRINTF_BUFFER_SIZE(p->ret, p->size, p->len, p->offset);
+
+err_free:
+	nft_rule_free(r);
+err:
+	return MNL_CB_OK;
+}
+
+static void get_table(struct mnl_socket *nl, uint16_t family, struct printdata *p)
+{
+	int ret;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	int seq = time(NULL);
+	struct nlmsghdr *nlh;
+	uint32_t portid = mnl_socket_get_portid(nl);
+
+	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, family,
+					NLM_F_DUMP, seq);
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		perror("mnl_socket_send");
+		exit(EXIT_FAILURE);
+	}
+
+	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	while (ret > 0) {
+		ret = mnl_cb_run(buf, ret, seq, portid, table_cb, p);
+		if (ret <= 0)
+			break;
+		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	}
+	if (ret == -1) {
+		perror("error");
+		exit(EXIT_FAILURE);
+	}
+}
+
+static void get_chain(struct mnl_socket *nl, uint16_t family, struct printdata *p)
+{
+	int ret;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	int seq = time(NULL);
+	struct nlmsghdr *nlh;
+	uint32_t portid = mnl_socket_get_portid(nl);
+
+	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, family,
+					NLM_F_DUMP, seq);
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		perror("mnl_socket_send");
+		exit(EXIT_FAILURE);
+	}
+
+	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	while (ret > 0) {
+		ret = mnl_cb_run(buf, ret, seq, portid, chain_cb, p);
+		if (ret <= 0)
+			break;
+		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	}
+	if (ret == -1) {
+		perror("error");
+		exit(EXIT_FAILURE);
+	}
+}
+
+static void get_rule(struct mnl_socket *nl, uint16_t family, struct printdata *p)
+{
+	int ret;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	int seq = time(NULL);
+	struct nlmsghdr *nlh;
+	uint32_t portid = mnl_socket_get_portid(nl);
+
+	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, family,
+					NLM_F_DUMP, seq);
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		perror("mnl_socket_send");
+		exit(EXIT_FAILURE);
+	}
+
+	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	while (ret > 0) {
+		ret = mnl_cb_run(buf, ret, seq, portid, rule_cb, p);
+		if (ret <= 0)
+			break;
+		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	}
+	if (ret == -1) {
+		perror("error");
+		exit(EXIT_FAILURE);
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	char printbuf[1000000];
+	struct printdata p;
+	p.buf = printbuf;
+	p.size = sizeof(printbuf);
+	p.len = p.size;
+	p.offset = 0;
+
+	nl = mnl_socket_open(NETLINK_NETFILTER);
+	if (nl == NULL) {
+		perror("mnl_socket_open");
+		exit(EXIT_FAILURE);
+	}
+
+	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
+		perror("mnl_socket_bind");
+		exit(EXIT_FAILURE);
+	}
+
+	p.ret = snprintf(p.buf, p.size, "<nftables>");
+	SNPRINTF_BUFFER_SIZE(p.ret, p.size, p.len, p.offset);
+
+	p.ret = snprintf(p.buf+p.offset, p.size, "<ruleset family=\"AF_BRIDGE\">");
+	SNPRINTF_BUFFER_SIZE(p.ret, p.size, p.len, p.offset);
+
+	/*Get Bridge ruleset*/
+	get_table(nl, AF_BRIDGE, &p);
+	get_chain(nl, AF_BRIDGE, &p);
+	get_rule(nl, AF_BRIDGE, &p);
+
+	p.ret = snprintf(p.buf+p.offset, p.size, "</ruleset>");
+	SNPRINTF_BUFFER_SIZE(p.ret, p.size, p.len, p.offset);
+
+	p.ret = snprintf(p.buf+p.offset, p.size, "<ruleset family=\"AF_INET\">");
+	SNPRINTF_BUFFER_SIZE(p.ret, p.size, p.len, p.offset);
+
+	/*Get IPv4 ruleset*/
+	get_table(nl, AF_INET, &p);
+	get_chain(nl, AF_INET, &p);
+	get_rule(nl, AF_INET, &p);
+
+	p.ret = snprintf(p.buf+p.offset, p.size, "</ruleset>");
+	SNPRINTF_BUFFER_SIZE(p.ret, p.size, p.len, p.offset);
+
+	p.ret = snprintf(p.buf+p.offset, p.size, "<ruleset family=\"AF_INET6\">");
+	SNPRINTF_BUFFER_SIZE(p.ret, p.size, p.len, p.offset);
+
+	/*Get IPv6 ruleset*/
+	get_table(nl, AF_INET6, &p);
+	get_chain(nl, AF_INET6, &p);
+	get_rule(nl, AF_INET6, &p);
+
+	p.ret = snprintf(p.buf+p.offset, p.size, "</ruleset>");
+	SNPRINTF_BUFFER_SIZE(p.ret, p.size, p.len, p.offset);
+
+	p.ret = snprintf(p.buf+p.offset, p.size, "</nftables>");
+	SNPRINTF_BUFFER_SIZE(p.ret, p.size, p.len, p.offset);
+
+	printf("%s\n", printbuf);
+
+	mnl_socket_close(nl);
+	return EXIT_SUCCESS;
+}

