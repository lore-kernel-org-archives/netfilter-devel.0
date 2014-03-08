From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH v2 2/3] example/nft-rule-insert: fixed and merged
 this example with nft-rule-add
Date: Sat, 08 Mar 2014 16:22:33 +0100
Message-ID: <20140308152202.18827.40529.stgit@Ph0enix>
References: <20140308152106.18827.23707.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:36991 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaCHPWr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Mar 2014 10:22:47 -0500
Received: by mail-bk0-f48.google.com with SMTP id mx12so1056424bkb.35
        for <netfilter-devel@vger.kernel.org>; Sat, 08 Mar 2014 07:22:46 -0800 (PST)
Received: from [127.0.1.1] ([2001:bf0:c001:30:3d1f:93c2:7e21:8d5c])
        by mx.google.com with ESMTPSA id pt2sm5899432bkb.8.2014.03.08.07.22.45
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Mar 2014 07:22:45 -0800 (PST)
In-Reply-To: <20140308152106.18827.23707.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Merged the example for inserting rules and fixed for using
the correct header.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
v2: Fixed some style error, removed useless code lines and used the cor=
rect function=20
for setting an attribute.

 examples/Makefile.am       |    1=20
 examples/nft-rule-add.c    |   15 +++
 examples/nft-rule-insert.c |  204 ------------------------------------=
--------
 3 files changed, 12 insertions(+), 208 deletions(-)
 delete mode 100644 examples/nft-rule-insert.c

diff --git a/examples/Makefile.am b/examples/Makefile.am
index b433b2d..54b1dfb 100644
--- a/examples/Makefile.am
+++ b/examples/Makefile.am
@@ -12,7 +12,6 @@ check_PROGRAMS =3D nft-table-add		\
 		 nft-chain-del		\
 		 nft-chain-get		\
 		 nft-rule-add		\
-		 nft-rule-insert	\
 		 nft-rule-xml-add	\
 		 nft-rule-json-add	\
 		 nft-rule-del		\
diff --git a/examples/nft-rule-add.c b/examples/nft-rule-add.c
index 21b3bf8..6961d0d 100644
--- a/examples/nft-rule-add.c
+++ b/examples/nft-rule-add.c
@@ -80,11 +80,12 @@ static void add_counter(struct nft_rule *r)
 }
=20
 static struct nft_rule *setup_rule(uint8_t family, const char *table,
-				   const char *chain)
+				   const char *chain, const char *handle)
 {
 	struct nft_rule *r =3D NULL;
 	uint8_t proto;
 	uint16_t dport;
+	uint64_t handle_num;
=20
 	r =3D nft_rule_alloc();
 	if (r =3D=3D NULL) {
@@ -96,6 +97,11 @@ static struct nft_rule *setup_rule(uint8_t family, c=
onst char *table,
 	nft_rule_attr_set(r, NFT_RULE_ATTR_CHAIN, chain);
 	nft_rule_attr_set_u32(r, NFT_RULE_ATTR_FAMILY, family);
=20
+	if (handle !=3D NULL) {
+		handle_num =3D atoll(handle);
+		nft_rule_attr_set_u64(r, NFT_RULE_ATTR_POSITION, handle_num);
+	}
+
 	proto =3D IPPROTO_TCP;
 	add_payload(r, NFT_PAYLOAD_NETWORK_HEADER, NFT_REG_1,
 		    offsetof(struct iphdr, protocol), sizeof(uint8_t));
@@ -138,7 +144,7 @@ int main(int argc, char *argv[])
 	uint32_t seq =3D time(NULL);
 	int ret;
=20
-	if (argc !=3D 4) {
+	if (argc < 4 || argc > 5) {
 		fprintf(stderr, "Usage: %s <family> <table> <chain>\n", argv[0]);
 		exit(EXIT_FAILURE);
 	}
@@ -152,7 +158,10 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
=20
-	r =3D setup_rule(family, argv[2], argv[3]);
+	if (argc !=3D 5)
+		r =3D setup_rule(family, argv[2], argv[3], NULL);
+	else
+		r =3D setup_rule(family, argv[2], argv[3], argv[4]);
=20
 	nl =3D mnl_socket_open(NETLINK_NETFILTER);
 	if (nl =3D=3D NULL) {
diff --git a/examples/nft-rule-insert.c b/examples/nft-rule-insert.c
deleted file mode 100644
index 1b377de..0000000
--- a/examples/nft-rule-insert.c
+++ /dev/null
@@ -1,204 +0,0 @@
-/*
- * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
- * (C) 2013 by Eric Leblond <eric@regit.org>
- *
- * This program is free software; you can redistribute it and/or modif=
y it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This software has been sponsored by Sophos Astaro <http://www.sopho=
s.com>
- */
-
-#include <stdlib.h>
-#include <time.h>
-#include <string.h>
-#include <stddef.h>	/* for offsetof */
-#include <netinet/in.h>
-#include <arpa/inet.h>
-
-#include <linux/netfilter/nf_tables.h>
-
-#include <libmnl/libmnl.h>
-#include <libnftnl/rule.h>
-#include <libnftnl/expr.h>
-
-#include <linux/netfilter_ipv4/ipt_LOG.h>
-#include <linux/netfilter/xt_iprange.h>
-
-#include <netinet/ip.h>
-
-static void add_target_log(struct nft_rule_expr *e)
-{
-	struct ipt_log_info *info;
-
-	nft_rule_expr_set(e, NFT_EXPR_TG_NAME, "LOG", strlen("LOG"));
-	nft_rule_expr_set_u32(e, NFT_EXPR_TG_REV, 0);
-
-	info =3D calloc(1, sizeof(struct ipt_log_info));
-	if (info =3D=3D NULL)
-		return;
-
-	sprintf(info->prefix, "test: ");
-	info->prefix[sizeof(info->prefix)-1] =3D '\0';
-	info->logflags =3D 0x0f;
-	info->level =3D 5;
-
-	nft_rule_expr_set(e, NFT_EXPR_TG_INFO, info, sizeof(*info));
-}
-
-static void add_expr_target(struct nft_rule *r)
-{
-	struct nft_rule_expr *expr;
-
-	expr =3D nft_rule_expr_alloc("target");
-	if (expr =3D=3D NULL)
-		return;
-
-	add_target_log(expr);
-
-	nft_rule_add_expr(r, expr);
-}
-
-static void add_match_iprange(struct nft_rule_expr *e)
-{
-	struct xt_iprange_mtinfo *info;
-
-	nft_rule_expr_set(e, NFT_EXPR_MT_NAME, "iprange", strlen("iprange"));
-	nft_rule_expr_set_u32(e, NFT_EXPR_MT_REV, 1);
-
-	info =3D calloc(1, sizeof(struct xt_iprange_mtinfo));
-	if (info =3D=3D NULL)
-		return;
-
-	info->src_min.ip =3D info->dst_min.ip =3D inet_addr("127.0.0.1");
-	info->src_max.ip =3D info->dst_max.ip =3D inet_addr("127.0.0.1");
-	info->flags =3D IPRANGE_SRC;
-
-	nft_rule_expr_set(e, NFT_EXPR_MT_INFO, info, sizeof(*info));
-}
-
-static void add_expr_match(struct nft_rule *r)
-{
-	struct nft_rule_expr *expr;
-
-	expr =3D nft_rule_expr_alloc("match");
-	if (expr =3D=3D NULL)
-		return;
-
-	add_match_iprange(expr);
-
-	nft_rule_add_expr(r, expr);
-}
-
-#define field_sizeof(t, f)	(sizeof(((t *)NULL)->f))
-
-static void add_payload2(struct nft_rule_expr *e)
-{
-	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_BASE,
-			      NFT_PAYLOAD_NETWORK_HEADER);
-	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_DREG, NFT_REG_1);
-	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_OFFSET,
-			      offsetof(struct iphdr, protocol));
-	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_LEN, 1);
-}
-
-static void add_payload(struct nft_rule *r)
-{
-	struct nft_rule_expr *expr;
-
-	expr =3D nft_rule_expr_alloc("payload");
-	if (expr =3D=3D NULL)
-		return;
-
-	add_payload2(expr);
-
-	nft_rule_add_expr(r, expr);
-}
-
-int main(int argc, char *argv[])
-{
-	struct mnl_socket *nl;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
-	uint32_t portid, seq;
-	struct nft_rule *r =3D NULL;
-	int ret, family;
-	uint64_t handle;
-
-	if (argc !=3D 5) {
-		fprintf(stderr, "Usage: %s <family> <table> <chain> <handle>\n",
-			argv[0]);
-		exit(EXIT_FAILURE);
-	}
-
-	r =3D nft_rule_alloc();
-	if (r =3D=3D NULL) {
-		perror("OOM");
-		exit(EXIT_FAILURE);
-	}
-
-	if (strcmp(argv[1], "ip") =3D=3D 0)
-		family =3D AF_INET;
-	else if (strcmp(argv[1], "ip6") =3D=3D 0)
-		family =3D AF_INET6;
-	else if (strcmp(argv[1], "bridge") =3D=3D 0)
-		family =3D AF_BRIDGE;
-	else {
-		fprintf(stderr, "Unknown family: ip, ip6, bridge\n");
-		exit(EXIT_FAILURE);
-	}
-
-	nft_rule_attr_set(r, NFT_RULE_ATTR_TABLE, argv[2]);
-	nft_rule_attr_set(r, NFT_RULE_ATTR_CHAIN, argv[3]);
-
-	handle =3D atoi(argv[4]);
-	nft_rule_attr_set(r, NFT_RULE_ATTR_POSITION, &handle);
-
-	add_expr_match(r);
-	add_payload(r);
-	add_expr_target(r);
-
-	char tmp[1024];
-	nft_rule_snprintf(tmp, sizeof(tmp), r, 0, 0);
-	printf("%s\n", tmp);
-
-	seq =3D time(NULL);
-	nlh =3D nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, family,
-					NLM_F_ACK|NLM_F_CREATE,
-					seq);
-	nft_rule_nlmsg_build_payload(nlh, r);
-	nft_rule_free(r);
-
-	nl =3D mnl_socket_open(NETLINK_NETFILTER);
-	if (nl =3D=3D NULL) {
-		perror("mnl_socket_open");
-		exit(EXIT_FAILURE);
-	}
-
-	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
-		perror("mnl_socket_bind");
-		exit(EXIT_FAILURE);
-	}
-	portid =3D mnl_socket_get_portid(nl);
-
-	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-		perror("mnl_socket_send");
-		exit(EXIT_FAILURE);
-	}
-
-	ret =3D mnl_socket_recvfrom(nl, buf, sizeof(buf));
-	while (ret > 0) {
-		ret =3D mnl_cb_run(buf, ret, seq, portid, NULL, NULL);
-		if (ret <=3D 0)
-			break;
-		ret =3D mnl_socket_recvfrom(nl, buf, sizeof(buf));
-	}
-	if (ret =3D=3D -1) {
-		perror("error");
-		exit(EXIT_FAILURE);
-	}
-	mnl_socket_close(nl);
-
-	return EXIT_SUCCESS;
-}

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
