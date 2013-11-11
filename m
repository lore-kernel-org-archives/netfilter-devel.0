From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 2/2] json: Refactor of exporting and parsing
 support flags
Date: Mon, 11 Nov 2013 21:09:35 +0100
Message-ID: <20131111200935.19419.8227.stgit@Ph0enix>
References: <20131111200921.19419.32343.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:45693 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab3KKUKE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:10:04 -0500
Received: by mail-wi0-f173.google.com with SMTP id ey11so2716883wid.0
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Nov 2013 12:10:02 -0800 (PST)
Received: from [127.0.1.1] ([89.234.147.219])
        by mx.google.com with ESMTPSA id ft19sm37412528wic.5.2013.11.11.12.09.51
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Nov 2013 12:10:00 -0800 (PST)
In-Reply-To: <20131111200921.19419.32343.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Remove the different flag definition for using the snprinf
and parsing support and create a new flags for joining in
general flags.

Now for printing or parsing tables or chains, we needed to use:
	NFT_TABLE_O_JSON
	NFT_TABLE_O_XML
	NFT_CHAIN_O_JSON
	NFT_CHAIN_O_XML
	NFT_CHAIN_PARSE_JSON
	NFT_TABLE_PARSE_JSON
	NFT_CHAIN_PARSE_XML
        NFT_TABLE_PARSE_XML

Now for exporting and parsing rules and chains, we only use:
	NFT_FORMAT_JSON
	NFT_FORMAT_XML
	NFT_PARSE_FORMAT_JSON
	NFT_PARSE_FORMAT_XML

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 examples/nft-chain-get.c      |    6 +++---
 examples/nft-chain-json-add.c |    4 ++--
 examples/nft-chain-xml-add.c  |    4 ++--
 examples/nft-events.c         |    6 +++---
 examples/nft-rule-get.c       |    6 +++---
 examples/nft-rule-json-add.c  |    4 ++--
 examples/nft-rule-xml-add.c   |    4 ++--
 examples/nft-set-elem-get.c   |    6 +++---
 examples/nft-set-get.c        |    6 +++---
 examples/nft-set-json-add.c   |    4 ++--
 examples/nft-table-get.c      |    6 +++---
 examples/nft-table-json-add.c |    4 ++--
 examples/nft-table-xml-add.c  |    4 ++--
 include/libnftables/chain.h   |   17 +++--------------
 include/libnftables/common.h  |   16 ++++++++++++++++
 include/libnftables/rule.h    |   17 +++--------------
 include/libnftables/ruleset.h |   17 +++--------------
 include/libnftables/set.h     |   19 ++++---------------
 include/libnftables/table.h   |   17 +++--------------
 src/chain.c                   |   12 ++++++------
 src/expr/bitwise.c            |   18 +++++++++---------
 src/expr/byteorder.c          |    6 +++---
 src/expr/cmp.c                |   12 ++++++------
 src/expr/counter.c            |    6 +++---
 src/expr/ct.c                 |    6 +++---
 src/expr/data_reg.c           |   18 +++++++++---------
 src/expr/exthdr.c             |    6 +++---
 src/expr/immediate.c          |   24 ++++++++++++------------
 src/expr/limit.c              |    6 +++---
 src/expr/log.c                |    6 +++---
 src/expr/lookup.c             |    6 +++---
 src/expr/match.c              |    6 +++---
 src/expr/meta.c               |    6 +++---
 src/expr/nat.c                |    6 +++---
 src/expr/payload.c            |    6 +++---
 src/expr/reject.c             |    6 +++---
 src/expr/target.c             |    6 +++---
 src/rule.c                    |   12 ++++++------
 src/ruleset.c                 |   24 ++++++++++++------------
 src/set.c                     |   14 +++++++-------
 src/set_elem.c                |   18 +++++++++---------
 src/table.c                   |   12 ++++++------
 tests/nft-parsing-test.c      |   40 ++++++++++++++++++++-------------=
-------
 43 files changed, 205 insertions(+), 244 deletions(-)
 create mode 100644 include/libnftables/common.h

diff --git a/examples/nft-chain-get.c b/examples/nft-chain-get.c
index e466e8b..56b903a 100644
--- a/examples/nft-chain-get.c
+++ b/examples/nft-chain-get.c
@@ -51,7 +51,7 @@ int main(int argc, char *argv[])
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
-	uint32_t portid, seq, type =3D NFT_CHAIN_O_DEFAULT;
+	uint32_t portid, seq, type =3D NFT_FORMAT_DEFAULT;
 	struct nft_chain *t =3D NULL;
 	int ret, family;
=20
@@ -96,9 +96,9 @@ int main(int argc, char *argv[])
 	}
=20
 	if (strcmp(argv[argc-1], "xml") =3D=3D 0){
-		type =3D NFT_CHAIN_O_XML;
+		type =3D NFT_FORMAT_XML;
 	}else if (strcmp(argv[argc-1], "json") =3D=3D 0){
-		type =3D NFT_CHAIN_O_JSON;
+		type =3D NFT_FORMAT_JSON;
 	}
=20
 	nl =3D mnl_socket_open(NETLINK_NETFILTER);
diff --git a/examples/nft-chain-json-add.c b/examples/nft-chain-json-ad=
d.c
index 42e2d82..4b39327 100644
--- a/examples/nft-chain-json-add.c
+++ b/examples/nft-chain-json-add.c
@@ -65,12 +65,12 @@ int main(int argc, char *argv[])
=20
 	close(fd);
=20
-	if (nft_chain_parse(c, NFT_CHAIN_PARSE_JSON, json) < 0) {
+	if (nft_chain_parse(c, NFT_PARSE_FORMAT_JSON, json) < 0) {
 		printf("E: Unable to parse JSON file: %s\n", strerror(errno));
 		exit(EXIT_FAILURE);
 	}
=20
-	nft_chain_snprintf(reprint, sizeof(reprint), c, NFT_CHAIN_O_JSON, 0);
+	nft_chain_snprintf(reprint, sizeof(reprint), c, NFT_FORMAT_JSON, 0);
 	printf("Parsed:\n%s\n", reprint);
=20
 	nft_chain_attr_unset(c, NFT_CHAIN_ATTR_HANDLE);
diff --git a/examples/nft-chain-xml-add.c b/examples/nft-chain-xml-add.=
c
index 2e2fe11..42529a1 100644
--- a/examples/nft-chain-xml-add.c
+++ b/examples/nft-chain-xml-add.c
@@ -63,12 +63,12 @@ int main(int argc, char *argv[])
=20
 	close(fd);
=20
-	if (nft_chain_parse(c, NFT_CHAIN_PARSE_XML, xml) < 0) {
+	if (nft_chain_parse(c, NFT_PARSE_FORMAT_XML, xml) < 0) {
 		printf("E: Unable to parse XML file: %s\n", strerror(errno));
 		exit(EXIT_FAILURE);
 	}
=20
-	nft_chain_snprintf(reprint, sizeof(reprint), c, NFT_CHAIN_O_XML, 0);
+	nft_chain_snprintf(reprint, sizeof(reprint), c, NFT_FORMAT_XML, 0);
 	printf("Parsed:\n%s\n", reprint);
=20
 	nft_chain_attr_unset(c, NFT_CHAIN_ATTR_HANDLE);
diff --git a/examples/nft-events.c b/examples/nft-events.c
index 5550c70..8ba98a2 100644
--- a/examples/nft-events.c
+++ b/examples/nft-events.c
@@ -38,7 +38,7 @@ static int table_cb(const struct nlmsghdr *nlh, int t=
ype)
 		goto err_free;
 	}
=20
-	nft_table_snprintf(buf, sizeof(buf), t, NFT_TABLE_O_DEFAULT, 0);
+	nft_table_snprintf(buf, sizeof(buf), t, NFT_FORMAT_DEFAULT, 0);
 	printf("[%s]\t%s\n", type =3D=3D NFT_MSG_NEWTABLE ? "NEW" : "DEL", bu=
f);
=20
 err_free:
@@ -63,7 +63,7 @@ static int rule_cb(const struct nlmsghdr *nlh, int ty=
pe)
 		goto err_free;
 	}
=20
-	nft_rule_snprintf(buf, sizeof(buf), t, NFT_RULE_O_DEFAULT, 0);
+	nft_rule_snprintf(buf, sizeof(buf), t, NFT_FORMAT_DEFAULT, 0);
 	printf("[%s]\t%s\n", type =3D=3D NFT_MSG_NEWRULE ? "NEW" : "DEL", buf=
);
=20
 err_free:
@@ -88,7 +88,7 @@ static int chain_cb(const struct nlmsghdr *nlh, int t=
ype)
 		goto err_free;
 	}
=20
-	nft_chain_snprintf(buf, sizeof(buf), t, NFT_CHAIN_O_DEFAULT, 0);
+	nft_chain_snprintf(buf, sizeof(buf), t, NFT_FORMAT_DEFAULT, 0);
 	printf("[%s]\t%s\n", type =3D=3D NFT_MSG_NEWCHAIN ? "NEW" : "DEL", bu=
f);
=20
 err_free:
diff --git a/examples/nft-rule-get.c b/examples/nft-rule-get.c
index cd0f8dc..23448f1 100644
--- a/examples/nft-rule-get.c
+++ b/examples/nft-rule-get.c
@@ -51,7 +51,7 @@ int main(int argc, char *argv[])
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
-	uint32_t portid, seq, type =3D NFT_RULE_O_DEFAULT;
+	uint32_t portid, seq, type =3D NFT_FORMAT_DEFAULT;
 	struct nft_rule *t =3D NULL;
 	int ret, family;
=20
@@ -78,9 +78,9 @@ int main(int argc, char *argv[])
=20
 	if (argc =3D=3D 3) {
 		if (strcmp(argv[2], "xml") =3D=3D 0)
-			type =3D NFT_RULE_O_XML;
+			type =3D NFT_FORMAT_XML;
 		else if (strcmp(argv[2], "json") =3D=3D 0)
-			type =3D NFT_RULE_O_JSON;
+			type =3D NFT_FORMAT_JSON;
 	}
=20
 	/* XXX requires table, chain and handle attributes for selective get =
*/
diff --git a/examples/nft-rule-json-add.c b/examples/nft-rule-json-add.=
c
index 83dec3e..2aa236b 100644
--- a/examples/nft-rule-json-add.c
+++ b/examples/nft-rule-json-add.c
@@ -63,12 +63,12 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
=20
-	if (nft_rule_parse(r, NFT_RULE_PARSE_JSON, json) < 0) {
+	if (nft_rule_parse(r, NFT_PARSE_FORMAT_JSON, json) < 0) {
 		printf("E: Unable to parse JSON file: %s\n", strerror(errno));
 		exit(EXIT_FAILURE);
 	}
=20
-	nft_rule_snprintf(reprint, sizeof(reprint), r, NFT_RULE_O_JSON, 0);
+	nft_rule_snprintf(reprint, sizeof(reprint), r, NFT_FORMAT_JSON, 0);
 	printf("Parsed:\n%s\n", reprint);
=20
 	nft_rule_attr_unset(r, NFT_RULE_ATTR_HANDLE);
diff --git a/examples/nft-rule-xml-add.c b/examples/nft-rule-xml-add.c
index 4de7a69..bfca7e1 100644
--- a/examples/nft-rule-xml-add.c
+++ b/examples/nft-rule-xml-add.c
@@ -63,12 +63,12 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
=20
-	if (nft_rule_parse(r, NFT_RULE_PARSE_XML, xml) < 0) {
+	if (nft_rule_parse(r, NFT_PARSE_FORMAT_XML, xml) < 0) {
 		printf("E: Unable to parse XML file: %s\n", strerror(errno));
 		exit(EXIT_FAILURE);
 	}
=20
-	nft_rule_snprintf(reprint, sizeof(reprint), r, NFT_RULE_O_XML, 0);
+	nft_rule_snprintf(reprint, sizeof(reprint), r, NFT_FORMAT_XML, 0);
 	printf("Parsed:\n%s\n", reprint);
=20
 	nft_rule_attr_unset(r, NFT_RULE_ATTR_HANDLE);
diff --git a/examples/nft-set-elem-get.c b/examples/nft-set-elem-get.c
index aeba400..c5ae6d3 100644
--- a/examples/nft-set-elem-get.c
+++ b/examples/nft-set-elem-get.c
@@ -52,7 +52,7 @@ int main(int argc, char *argv[])
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 	uint32_t portid, seq, family;
-	uint32_t type =3D NFT_SET_O_DEFAULT;
+	uint32_t type =3D NFT_FORMAT_DEFAULT;
 	struct nft_set *t =3D NULL;
 	int ret;
=20
@@ -81,9 +81,9 @@ int main(int argc, char *argv[])
 	}
=20
 	if (argc =3D=3D 5 && strcmp(argv[4], "json") =3D=3D 0 )
-		type =3D NFT_SET_O_JSON;
+		type =3D NFT_FORMAT_JSON;
 	else if (argc =3D=3D 5 && strcmp(argv[4], "xml") =3D=3D 0)
-		type =3D NFT_SET_O_XML;
+		type =3D NFT_FORMAT_XML;
=20
 	nlh =3D nft_set_nlmsg_build_hdr(buf, NFT_MSG_GETSETELEM, family,
 					NLM_F_DUMP|NLM_F_ACK, seq);
diff --git a/examples/nft-set-get.c b/examples/nft-set-get.c
index 4bc585c..6567ef6 100644
--- a/examples/nft-set-get.c
+++ b/examples/nft-set-get.c
@@ -52,7 +52,7 @@ int main(int argc, char *argv[])
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 	uint32_t portid, seq, family;
-	uint32_t type =3D NFT_SET_O_DEFAULT;
+	uint32_t type =3D NFT_FORMAT_DEFAULT;
 	struct nft_set *t =3D NULL;
 	int ret;
=20
@@ -80,9 +80,9 @@ int main(int argc, char *argv[])
 	}
=20
 	if (argc =3D=3D 3 && strcmp(argv[2], "json") =3D=3D 0)
-		type =3D NFT_SET_O_JSON;
+		type =3D NFT_FORMAT_JSON;
 	else if (argc =3D=3D 3 && strcmp(argv[2], "xml") =3D=3D 0)
-		type =3D NFT_SET_O_XML;
+		type =3D NFT_FORMAT_XML;
=20
 	nlh =3D nft_set_nlmsg_build_hdr(buf, NFT_MSG_GETSET, family,
 					NLM_F_DUMP|NLM_F_ACK, seq);
diff --git a/examples/nft-set-json-add.c b/examples/nft-set-json-add.c
index 33c3acd..191ce91 100644
--- a/examples/nft-set-json-add.c
+++ b/examples/nft-set-json-add.c
@@ -64,12 +64,12 @@ int main(int argc, char *argv[])
=20
 	close(fd);
=20
-	if (nft_set_parse(s, NFT_SET_PARSE_JSON, json) < 0) {
+	if (nft_set_parse(s, NFT_PARSE_FORMAT_JSON, json) < 0) {
 		printf("E: Unable to parse JSON file: %s\n", strerror(errno));
 		exit(EXIT_FAILURE);
 	}
=20
-	nft_set_snprintf(reprint, sizeof(reprint), s, NFT_SET_O_JSON, 0);
+	nft_set_snprintf(reprint, sizeof(reprint), s, NFT_FORMAT_JSON, 0);
 	printf("Parsed:\n%s\n", reprint);
=20
 	family =3D nft_set_attr_get_u32(s, NFT_SET_ATTR_FAMILY);
diff --git a/examples/nft-table-get.c b/examples/nft-table-get.c
index f57423b..78c19f3 100644
--- a/examples/nft-table-get.c
+++ b/examples/nft-table-get.c
@@ -54,7 +54,7 @@ int main(int argc, char *argv[])
 	uint32_t portid, seq, family;
 	struct nft_table *t =3D NULL;
 	int ret;
-	uint32_t type =3D NFT_TABLE_O_DEFAULT;
+	uint32_t type =3D NFT_FORMAT_DEFAULT;
=20
 	if (argc < 2 || argc > 4) {
 		fprintf(stderr, "%s <family> [<table>] [<default|xml|json>]\n",
@@ -78,11 +78,11 @@ int main(int argc, char *argv[])
 	}
=20
 	if (strcmp(argv[argc-1], "xml") =3D=3D 0) {
-		type =3D NFT_TABLE_O_XML;
+		type =3D NFT_FORMAT_XML;
 		argv[argc-1] =3D NULL;
 		argc--;
 	}else if (strcmp(argv[argc-1], "json") =3D=3D 0) {
-		type =3D NFT_TABLE_O_JSON;
+		type =3D NFT_FORMAT_JSON;
 		argv[argc-1] =3D NULL;
 		argc--;
 	} else if (strcmp(argv[argc - 1], "default") =3D=3D 0) {
diff --git a/examples/nft-table-json-add.c b/examples/nft-table-json-ad=
d.c
index 5526c91..18f94c1 100644
--- a/examples/nft-table-json-add.c
+++ b/examples/nft-table-json-add.c
@@ -64,12 +64,12 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
=20
-	if (nft_table_parse(t, NFT_TABLE_PARSE_JSON, json) < 0) {
+	if (nft_table_parse(t, NFT_PARSE_FORMAT_JSON, json) < 0) {
 		printf("E: Unable to parse JSON file: %s\n", strerror(errno));
 		exit(EXIT_FAILURE);
 	}
=20
-	nft_table_snprintf(reprint, sizeof(reprint), t, NFT_TABLE_O_JSON, 0);
+	nft_table_snprintf(reprint, sizeof(reprint), t, NFT_FORMAT_JSON, 0);
 	printf("Parsed:\n%s\n", reprint);
=20
 	family =3D nft_table_attr_get_u32(t, NFT_TABLE_ATTR_FAMILY);
diff --git a/examples/nft-table-xml-add.c b/examples/nft-table-xml-add.=
c
index 6de0855..d231a9d 100644
--- a/examples/nft-table-xml-add.c
+++ b/examples/nft-table-xml-add.c
@@ -60,12 +60,12 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
=20
-	if (nft_table_parse(t, NFT_TABLE_PARSE_XML, xml) < 0) {
+	if (nft_table_parse(t, NFT_PARSE_FORMAT_XML, xml) < 0) {
 		printf("E: Unable to parse XML file: %s\n", strerror(errno));
 		exit(EXIT_FAILURE);
 	}
=20
-	nft_table_snprintf(reprint, sizeof(reprint), t, NFT_TABLE_O_XML, 0);
+	nft_table_snprintf(reprint, sizeof(reprint), t, NFT_FORMAT_XML, 0);
 	printf("Parsed:\n%s\n", reprint);
=20
 	family =3D nft_table_attr_get_u32(t, NFT_TABLE_ATTR_FAMILY);
diff --git a/include/libnftables/chain.h b/include/libnftables/chain.h
index 5de7318..d959f7d 100644
--- a/include/libnftables/chain.h
+++ b/include/libnftables/chain.h
@@ -6,6 +6,8 @@
 #include <stdbool.h>
 #include <sys/types.h>
=20
+#include <libnftables/common.h>
+
 #ifdef __cplusplus
 extern "C" {
 #endif
@@ -47,20 +49,7 @@ struct nlmsghdr;
=20
 void nft_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct =
nft_chain *t);
=20
-enum {
-	NFT_CHAIN_O_DEFAULT	=3D 0,
-	NFT_CHAIN_O_XML,
-	NFT_CHAIN_O_JSON,
-};
-
-enum nft_chain_parse_type {
-	NFT_CHAIN_PARSE_NONE	=3D 0,
-	NFT_CHAIN_PARSE_XML,
-	NFT_CHAIN_PARSE_JSON,
-	NFT_CHAIN_PARSE_MAX
-};
-
-int nft_chain_parse(struct nft_chain *c, enum nft_chain_parse_type typ=
e, const char *data);
+int nft_chain_parse(struct nft_chain *c, enum nft_parse_format_type ty=
pe, const char *data);
 int nft_chain_snprintf(char *buf, size_t size, struct nft_chain *t, ui=
nt32_t type, uint32_t flags);
 int nft_chain_fprintf(FILE *fp, struct nft_chain *c, uint32_t type, ui=
nt32_t flags);
=20
diff --git a/include/libnftables/common.h b/include/libnftables/common.=
h
new file mode 100644
index 0000000..5055834
--- /dev/null
+++ b/include/libnftables/common.h
@@ -0,0 +1,16 @@
+#ifndef _COMMON_H_
+#define _COMMON_H_
+
+enum {
+	NFT_FORMAT_DEFAULT	=3D 0,
+	NFT_FORMAT_XML,
+	NFT_FORMAT_JSON,
+};
+
+enum nft_parse_format_type {
+	NFT_PARSE_FORMAT_NONE	=3D 0,
+	NFT_PARSE_FORMAT_XML,
+	NFT_PARSE_FORMAT_JSON,
+	NFT_PARSE_FORMAT_MAX,
+};
+#endif
diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
index b61afb0..c67b114 100644
--- a/include/libnftables/rule.h
+++ b/include/libnftables/rule.h
@@ -6,6 +6,8 @@
 #include <stdbool.h>
 #include <sys/types.h>
=20
+#include <libnftables/common.h>
+
 #ifdef __cplusplus
 extern "C" {
 #endif
@@ -45,20 +47,7 @@ struct nlmsghdr;
=20
 void nft_rule_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_rul=
e *t);
=20
-enum {
-	NFT_RULE_O_DEFAULT	=3D 0,
-	NFT_RULE_O_XML,
-	NFT_RULE_O_JSON,
-};
-
-enum nft_rule_parse_type {
-	NFT_RULE_PARSE_NONE	=3D 0,
-	NFT_RULE_PARSE_XML,
-	NFT_RULE_PARSE_JSON,
-	NFT_RULE_PARSE_MAX,
-};
-
-int nft_rule_parse(struct nft_rule *r, enum nft_rule_parse_type type, =
const char *data);
+int nft_rule_parse(struct nft_rule *r, enum nft_parse_format_type type=
, const char *data);
 int nft_rule_snprintf(char *buf, size_t size, struct nft_rule *t, uint=
32_t type, uint32_t flags);
 int nft_rule_fprintf(FILE *fp, struct nft_rule *r, uint32_t type, uint=
32_t flags);
=20
diff --git a/include/libnftables/ruleset.h b/include/libnftables/rulese=
t.h
index 3b20bfa..2f44c5b 100644
--- a/include/libnftables/ruleset.h
+++ b/include/libnftables/ruleset.h
@@ -7,6 +7,8 @@
 #include <stdint.h>
 #include <sys/types.h>
=20
+#include <libnftables/common.h>
+
 #ifdef __cplusplus
 extern "C" {
 #endif
@@ -28,20 +30,7 @@ void nft_ruleset_attr_unset(struct nft_ruleset *r, u=
int16_t attr);
 void nft_ruleset_attr_set(struct nft_ruleset *r, uint16_t attr, void *=
data);
 const void *nft_ruleset_attr_get(const struct nft_ruleset *r, uint16_t=
 attr);
=20
-enum {
-	NFT_RULESET_O_DEFAULT	=3D 0,
-	NFT_RULESET_O_XML,
-	NFT_RULESET_O_JSON,
-};
-
-enum nft_ruleset_parse_type {
-	NFT_RULESET_PARSE_NONE	=3D 0,
-	NFT_RULESET_PARSE_XML,
-	NFT_RULESET_PARSE_JSON,
-	NFT_RULESET_PARSE_MAX,
-};
-
-int nft_ruleset_parse(struct nft_ruleset *rs, enum nft_ruleset_parse_t=
ype type, const char *data);
+int nft_ruleset_parse(struct nft_ruleset *rs, enum nft_parse_format_ty=
pe type, const char *data);
 int nft_ruleset_snprintf(char *buf, size_t size, const struct nft_rule=
set *rs, uint32_t type, uint32_t flags);
 int nft_ruleset_fprintf(FILE *fp, const struct nft_ruleset *rs, uint32=
_t type, uint32_t flags);
=20
diff --git a/include/libnftables/set.h b/include/libnftables/set.h
index cf63b9b..24bbb0d 100644
--- a/include/libnftables/set.h
+++ b/include/libnftables/set.h
@@ -6,6 +6,8 @@
 #include <stdbool.h>
 #include <sys/types.h>
=20
+#include <libnftables/common.h>
+
 enum {
 	NFT_SET_ATTR_TABLE,
 	NFT_SET_ATTR_NAME,
@@ -58,14 +60,7 @@ struct nft_set *nft_set_list_iter_cur(struct nft_set=
_list_iter *iter);
 struct nft_set *nft_set_list_iter_next(struct nft_set_list_iter *iter)=
;
 void nft_set_list_iter_destroy(struct nft_set_list_iter *iter);
=20
-enum nft_set_parse_type {
-	NFT_SET_PARSE_NONE	=3D 0,
-	NFT_SET_PARSE_XML,
-	NFT_SET_PARSE_JSON,
-	NFT_SET_PARSE_MAX,
-};
-
-int nft_set_parse(struct nft_set *s, enum nft_set_parse_type type, con=
st char *data);
+int nft_set_parse(struct nft_set *s, enum nft_parse_format_type type, =
const char *data);
=20
 /*
  * Set elements
@@ -79,12 +74,6 @@ enum {
 	NFT_SET_ELEM_ATTR_DATA,
 };
=20
-enum {
-	NFT_SET_O_DEFAULT	=3D 0,
-	NFT_SET_O_XML,
-	NFT_SET_O_JSON,
-};
-
 struct nft_set_elem;
=20
 struct nft_set_elem *nft_set_elem_alloc(void);
@@ -109,7 +98,7 @@ void nft_set_elem_nlmsg_build_payload(struct nlmsghd=
r *nlh, struct nft_set_elem
=20
 int nft_set_elem_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_se=
t_elem *s);
=20
-int nft_set_elem_parse(struct nft_set_elem *e, enum nft_set_parse_type=
 type, const char *data);
+int nft_set_elem_parse(struct nft_set_elem *e, enum nft_parse_format_t=
ype type, const char *data);
 int nft_set_elem_snprintf(char *buf, size_t size, struct nft_set_elem =
*s, uint32_t type, uint32_t flags);
 int nft_set_elem_fprintf(FILE *fp, struct nft_set_elem *se, uint32_t t=
ype, uint32_t flags);
=20
diff --git a/include/libnftables/table.h b/include/libnftables/table.h
index e3b4888..7a07726 100644
--- a/include/libnftables/table.h
+++ b/include/libnftables/table.h
@@ -6,6 +6,8 @@
 #include <stdbool.h>
 #include <sys/types.h>
=20
+#include <libnftables/common.h>
+
 #ifdef __cplusplus
 extern "C" {
 #endif
@@ -35,20 +37,7 @@ struct nlmsghdr;
=20
 void nft_table_nlmsg_build_payload(struct nlmsghdr *nlh, const struct =
nft_table *t);
=20
-enum {
-	NFT_TABLE_O_DEFAULT	=3D 0,
-	NFT_TABLE_O_XML,
-	NFT_TABLE_O_JSON,
-};
-
-enum nft_table_parse_type {
-	NFT_TABLE_PARSE_NONE	=3D 0,
-	NFT_TABLE_PARSE_XML,
-	NFT_TABLE_PARSE_JSON,
-	NFT_TABLE_PARSE_MAX,
-};
-
-int nft_table_parse(struct nft_table *t, enum nft_table_parse_type typ=
e, const char *data);
+int nft_table_parse(struct nft_table *t, enum nft_parse_format_type ty=
pe, const char *data);
 int nft_table_snprintf(char *buf, size_t size, struct nft_table *t, ui=
nt32_t type, uint32_t flags);
 int nft_table_fprintf(FILE *fp, struct nft_table *t, uint32_t type, ui=
nt32_t flags);
=20
diff --git a/src/chain.c b/src/chain.c
index cdb398f..057373a 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -727,16 +727,16 @@ static int nft_chain_xml_parse(struct nft_chain *=
c, const char *xml)
 #endif
 }
=20
-int nft_chain_parse(struct nft_chain *c, enum nft_chain_parse_type typ=
e,
+int nft_chain_parse(struct nft_chain *c, enum nft_parse_format_type ty=
pe,
 		    const char *data)
 {
 	int ret;
=20
 	switch (type) {
-	case NFT_CHAIN_PARSE_XML:
+	case NFT_PARSE_FORMAT_XML:
 		ret =3D nft_chain_xml_parse(c, data);
 		break;
-	case NFT_CHAIN_PARSE_JSON:
+	case NFT_PARSE_FORMAT_JSON:
 		ret =3D nft_chain_json_parse(c, data);
 		break;
 	default:
@@ -838,11 +838,11 @@ int nft_chain_snprintf(char *buf, size_t size, st=
ruct nft_chain *c,
 		       uint32_t type, uint32_t flags)
 {
 	switch(type) {
-	case NFT_CHAIN_O_DEFAULT:
+	case NFT_FORMAT_DEFAULT:
 		return nft_chain_snprintf_default(buf, size, c);
-	case NFT_CHAIN_O_XML:
+	case NFT_FORMAT_XML:
 		return nft_chain_snprintf_xml(buf, size, c);
-	case NFT_CHAIN_O_JSON:
+	case NFT_FORMAT_JSON:
 		return nft_chain_snprintf_json(buf, size, c);
 	default:
 		break;
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 0be1593..08de7a8 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -293,14 +293,14 @@ nft_rule_expr_bitwise_snprintf_json(char *buf, si=
ze_t size,
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	ret =3D nft_data_reg_snprintf(buf+offset, len, &bitwise->mask,
-				    NFT_RULE_O_JSON, 0, DATA_VALUE);
+				    NFT_FORMAT_JSON, 0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	ret =3D snprintf(buf+offset, len, "},\"xor\":{");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	ret =3D nft_data_reg_snprintf(buf+offset, len, &bitwise->xor,
-				    NFT_RULE_O_JSON, 0, DATA_VALUE);
+				    NFT_FORMAT_JSON, 0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	ret =3D snprintf(buf+offset, len, "}");
@@ -325,14 +325,14 @@ nft_rule_expr_bitwise_snprintf_xml(char *buf, siz=
e_t size,
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	ret =3D nft_data_reg_snprintf(buf+offset, len, &bitwise->mask,
-				    NFT_RULE_O_XML, 0, DATA_VALUE);
+				    NFT_FORMAT_XML, 0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	ret =3D snprintf(buf+offset, len, "</mask><xor>");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	ret =3D nft_data_reg_snprintf(buf+offset, len, &bitwise->xor,
-				    NFT_RULE_O_XML, 0, DATA_VALUE);
+				    NFT_FORMAT_XML, 0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	ret =3D snprintf(buf+offset, len, "</xor>");
@@ -352,14 +352,14 @@ nft_rule_expr_bitwise_snprintf_default(char *buf,=
 size_t size,
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	ret =3D nft_data_reg_snprintf(buf+offset, len, &bitwise->mask,
-				    NFT_RULE_O_DEFAULT, 0, DATA_VALUE);
+				    NFT_FORMAT_DEFAULT, 0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	ret =3D snprintf(buf+offset, len, ") ^ ");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	ret =3D nft_data_reg_snprintf(buf+offset, len, &bitwise->xor,
-				    NFT_RULE_O_DEFAULT, 0, DATA_VALUE);
+				    NFT_FORMAT_DEFAULT, 0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	return offset;
@@ -372,12 +372,12 @@ nft_rule_expr_bitwise_snprintf(char *buf, size_t =
size, uint32_t type,
 	struct nft_expr_bitwise *bitwise =3D nft_expr_data(e);
=20
 	switch(type) {
-	case NFT_RULE_O_DEFAULT:
+	case NFT_FORMAT_DEFAULT:
 		return nft_rule_expr_bitwise_snprintf_default(buf, size,
 							      bitwise);
-	case NFT_RULE_O_XML:
+	case NFT_FORMAT_XML:
 		return nft_rule_expr_bitwise_snprintf_xml(buf, size, bitwise);
-	case NFT_RULE_O_JSON:
+	case NFT_FORMAT_JSON:
 		return nft_rule_expr_bitwise_snprintf_json(buf, size, bitwise);
 	default:
 		break;
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index 7012452..95d941d 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -351,13 +351,13 @@ nft_rule_expr_byteorder_snprintf(char *buf, size_=
t size, uint32_t type,
 	struct nft_expr_byteorder *byteorder =3D nft_expr_data(e);
=20
 	switch(type) {
-	case NFT_RULE_O_DEFAULT:
+	case NFT_FORMAT_DEFAULT:
 		return nft_rule_expr_byteorder_snprintf_default(buf, size,
 								byteorder);
-	case NFT_RULE_O_XML:
+	case NFT_FORMAT_XML:
 		return nft_rule_expr_byteorder_snprintf_xml(buf, size,
 							    byteorder);
-	case NFT_RULE_O_JSON:
+	case NFT_FORMAT_JSON:
 		return nft_rule_expr_byteorder_snprintf_json(buf, size,
 							    byteorder);
 	default:
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 7de7226..bc29181 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -258,7 +258,7 @@ nft_rule_expr_cmp_snprintf_json(char *buf, size_t s=
ize, struct nft_expr_cmp *cmp
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	ret =3D nft_data_reg_snprintf(buf+offset, len, &cmp->data,
-				    NFT_RULE_O_JSON, 0, DATA_VALUE);
+				    NFT_FORMAT_JSON, 0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	ret =3D snprintf(buf+offset, len, "}");
@@ -277,7 +277,7 @@ nft_rule_expr_cmp_snprintf_xml(char *buf, size_t si=
ze, struct nft_expr_cmp *cmp)
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	ret =3D nft_data_reg_snprintf(buf+offset, len, &cmp->data,
-				    NFT_RULE_O_XML, 0, DATA_VALUE);
+				    NFT_FORMAT_XML, 0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	ret =3D snprintf(buf+offset, len, "</cmpdata>");
@@ -297,7 +297,7 @@ nft_rule_expr_cmp_snprintf_default(char *buf, size_=
t size,
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	ret =3D nft_data_reg_snprintf(buf+offset, len, &cmp->data,
-				    NFT_RULE_O_DEFAULT, 0, DATA_VALUE);
+				    NFT_FORMAT_DEFAULT, 0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	return offset;
@@ -310,11 +310,11 @@ nft_rule_expr_cmp_snprintf(char *buf, size_t size=
, uint32_t type,
 	struct nft_expr_cmp *cmp =3D nft_expr_data(e);
=20
 	switch(type) {
-	case NFT_RULE_O_DEFAULT:
+	case NFT_FORMAT_DEFAULT:
 		return nft_rule_expr_cmp_snprintf_default(buf, size, cmp);
-	case NFT_RULE_O_XML:
+	case NFT_FORMAT_XML:
 		return nft_rule_expr_cmp_snprintf_xml(buf, size, cmp);
-	case NFT_RULE_O_JSON:
+	case NFT_FORMAT_JSON:
 		return nft_rule_expr_cmp_snprintf_json(buf, size, cmp);
 	default:
 		break;
diff --git a/src/expr/counter.c b/src/expr/counter.c
index 561f26c..b227aa0 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -173,13 +173,13 @@ nft_rule_expr_counter_snprintf(char *buf, size_t =
len, uint32_t type,
 	struct nft_expr_counter *ctr =3D nft_expr_data(e);
=20
 	switch(type) {
-	case NFT_RULE_O_DEFAULT:
+	case NFT_FORMAT_DEFAULT:
 		return snprintf(buf, len, "pkts %"PRIu64" bytes %"PRIu64" ",
 				ctr->pkts, ctr->bytes);
-	case NFT_RULE_O_XML:
+	case NFT_FORMAT_XML:
 		return snprintf(buf, len, "<pkts>%"PRIu64"</pkts><bytes>%"PRIu64"</b=
ytes>",
 				ctr->pkts, ctr->bytes);
-	case NFT_RULE_O_JSON:
+	case NFT_FORMAT_JSON:
 		return snprintf(buf, len, "\"pkts\":%"PRIu64",\"bytes\":%"PRIu64"",
 				ctr->pkts, ctr->bytes);
 	default:
diff --git a/src/expr/ct.c b/src/expr/ct.c
index e84d996..0fe8368 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -304,15 +304,15 @@ nft_rule_expr_ct_snprintf(char *buf, size_t len, =
uint32_t type,
 	struct nft_expr_ct *ct =3D nft_expr_data(e);
=20
 	switch(type) {
-	case NFT_RULE_O_DEFAULT:
+	case NFT_FORMAT_DEFAULT:
 		return snprintf(buf, len, "load %s =3D> reg %u dir %u ",
 				ctkey2str(ct->key), ct->dreg, ct->dir);
-	case NFT_RULE_O_XML:
+	case NFT_FORMAT_XML:
 		return snprintf(buf, len, "<dreg>%u</dreg>"
 					  "<key>%s</key>"
 					  "<dir>%u</dir>",
 				ct->dreg, ctkey2str(ct->key), ct->dir);
-	case NFT_RULE_O_JSON:
+	case NFT_FORMAT_JSON:
 		return nft_expr_ct_snprintf_json(buf, len, e);
 	default:
 		break;
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 193f3ab..51d6daf 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -300,13 +300,13 @@ int nft_data_reg_snprintf(char *buf, size_t size,=
 union nft_data_reg *reg,
 	switch(reg_type) {
 	case DATA_VALUE:
 		switch(output_format) {
-		case NFT_RULE_O_DEFAULT:
+		case NFT_FORMAT_DEFAULT:
 			return nft_data_reg_value_snprintf_default(buf, size,
 								   reg, flags);
-		case NFT_RULE_O_XML:
+		case NFT_FORMAT_XML:
 			return nft_data_reg_value_snprintf_xml(buf, size,
 							       reg, flags);
-		case NFT_RULE_O_JSON:
+		case NFT_FORMAT_JSON:
 			return nft_data_reg_value_snprintf_json(buf, size,
 							       reg, flags);
 		default:
@@ -314,15 +314,15 @@ int nft_data_reg_snprintf(char *buf, size_t size,=
 union nft_data_reg *reg,
 		}
 	case DATA_VERDICT:
 		switch(output_format) {
-		case NFT_RULE_O_DEFAULT:
+		case NFT_FORMAT_DEFAULT:
 			return snprintf(buf, size, "%d ", reg->verdict);
-		case NFT_RULE_O_XML:
+		case NFT_FORMAT_XML:
 			return snprintf(buf, size,
 					"<data_reg type=3D\"verdict\">"
 						"<verdict>%s</verdict>"
 					"</data_reg>",
 					nft_verdict2str(reg->verdict));
-		case NFT_RULE_O_JSON:
+		case NFT_FORMAT_JSON:
 			return snprintf(buf, size,
 					"\"data_reg\":{"
 					"\"type\":\"verdict\","
@@ -333,14 +333,14 @@ int nft_data_reg_snprintf(char *buf, size_t size,=
 union nft_data_reg *reg,
 		}
 	case DATA_CHAIN:
 		switch(output_format) {
-		case NFT_RULE_O_DEFAULT:
+		case NFT_FORMAT_DEFAULT:
 			return snprintf(buf, size, "%s ", reg->chain);
-		case NFT_RULE_O_XML:
+		case NFT_FORMAT_XML:
 			return snprintf(buf, size,
 					"<data_reg type=3D\"chain\">"
 						"<chain>%s</chain>"
 					"</data_reg>", reg->chain);
-		case NFT_RULE_O_JSON:
+		case NFT_FORMAT_JSON:
 			return snprintf(buf, size,
 					"\"data_reg\":{\"type\":\"chain\","
 					"\"chain\":\"%s\""
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index 32791d0..c297ea5 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -289,11 +289,11 @@ nft_rule_expr_exthdr_snprintf(char *buf, size_t l=
en, uint32_t type,
 	struct nft_expr_exthdr *exthdr =3D nft_expr_data(e);
=20
 	switch(type) {
-	case NFT_RULE_O_DEFAULT:
+	case NFT_FORMAT_DEFAULT:
 		return snprintf(buf, len, "load %ub @ %u + %u =3D> reg %u ",
 				exthdr->len, exthdr->type,
 				exthdr->offset, exthdr->dreg);
-	case NFT_RULE_O_XML:
+	case NFT_FORMAT_XML:
 		return snprintf(buf, len, "<dreg>%u</dreg>"
 					  "<exthdr_type>%s</exthdr_type>"
 					  "<offset>%u</offset>"
@@ -301,7 +301,7 @@ nft_rule_expr_exthdr_snprintf(char *buf, size_t len=
, uint32_t type,
 					exthdr->dreg,
 					exthdr_type2str(exthdr->type),
 					exthdr->offset, exthdr->len);
-	case NFT_RULE_O_JSON:
+	case NFT_FORMAT_JSON:
 		return snprintf(buf, len, "\"dreg\":%u,"
 					  "\"exthdr_type\":\"%s\",\"offset\":%u,"
 					  "\"len\":%u",
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index cb3b209..3b963da 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -268,17 +268,17 @@ nft_rule_expr_immediate_snprintf_json(char *buf, =
size_t len,
=20
 	if (e->flags & (1 << NFT_EXPR_IMM_DATA)) {
 		ret =3D nft_data_reg_snprintf(buf+offset, len, &imm->data,
-					    NFT_RULE_O_JSON, flags, DATA_VALUE);
+					    NFT_FORMAT_JSON, flags, DATA_VALUE);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	} else if (e->flags & (1 << NFT_EXPR_IMM_VERDICT)) {
 		ret =3D nft_data_reg_snprintf(buf+offset, len, &imm->data,
-					  NFT_RULE_O_JSON, flags, DATA_VERDICT);
+					  NFT_FORMAT_JSON, flags, DATA_VERDICT);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	} else if (e->flags & (1 << NFT_EXPR_IMM_CHAIN)) {
 		ret =3D nft_data_reg_snprintf(buf+offset, len, &imm->data,
-					    NFT_RULE_O_JSON, flags, DATA_CHAIN);
+					    NFT_FORMAT_JSON, flags, DATA_CHAIN);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
=20
@@ -302,17 +302,17 @@ nft_rule_expr_immediate_snprintf_xml(char *buf, s=
ize_t len,
=20
 	if (e->flags & (1 << NFT_EXPR_IMM_DATA)) {
 		ret =3D nft_data_reg_snprintf(buf+offset, len, &imm->data,
-					    NFT_RULE_O_XML, flags, DATA_VALUE);
+					    NFT_FORMAT_XML, flags, DATA_VALUE);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	} else if (e->flags & (1 << NFT_EXPR_IMM_VERDICT)) {
 		ret =3D nft_data_reg_snprintf(buf+offset, len, &imm->data,
-					  NFT_RULE_O_XML, flags, DATA_VERDICT);
+					  NFT_FORMAT_XML, flags, DATA_VERDICT);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	} else if (e->flags & (1 << NFT_EXPR_IMM_CHAIN)) {
 		ret =3D nft_data_reg_snprintf(buf+offset, len, &imm->data,
-					    NFT_RULE_O_XML, flags, DATA_CHAIN);
+					    NFT_FORMAT_XML, flags, DATA_CHAIN);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
=20
@@ -334,17 +334,17 @@ nft_rule_expr_immediate_snprintf_default(char *bu=
f, size_t len,
=20
 	if (e->flags & (1 << NFT_EXPR_IMM_DATA)) {
 		ret =3D nft_data_reg_snprintf(buf+offset, len, &imm->data,
-					NFT_RULE_O_DEFAULT, flags, DATA_VALUE);
+					NFT_FORMAT_DEFAULT, flags, DATA_VALUE);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	} else if (e->flags & (1 << NFT_EXPR_IMM_VERDICT)) {
 		ret =3D nft_data_reg_snprintf(buf+offset, len, &imm->data,
-				NFT_RULE_O_DEFAULT, flags, DATA_VERDICT);
+				NFT_FORMAT_DEFAULT, flags, DATA_VERDICT);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	} else if (e->flags & (1 << NFT_EXPR_IMM_CHAIN)) {
 		ret =3D nft_data_reg_snprintf(buf+offset, len, &imm->data,
-					NFT_RULE_O_DEFAULT, flags, DATA_CHAIN);
+					NFT_FORMAT_DEFAULT, flags, DATA_CHAIN);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
=20
@@ -356,11 +356,11 @@ nft_rule_expr_immediate_snprintf(char *buf, size_=
t len, uint32_t type,
 				 uint32_t flags, struct nft_rule_expr *e)
 {
 	switch(type) {
-	case NFT_RULE_O_DEFAULT:
+	case NFT_FORMAT_DEFAULT:
 		return nft_rule_expr_immediate_snprintf_default(buf, len, e, flags);
-	case NFT_RULE_O_XML:
+	case NFT_FORMAT_XML:
 		return nft_rule_expr_immediate_snprintf_xml(buf, len, e, flags);
-	case NFT_RULE_O_JSON:
+	case NFT_FORMAT_JSON:
 		return nft_rule_expr_immediate_snprintf_json(buf, len, e, flags);
 	default:
 		break;
diff --git a/src/expr/limit.c b/src/expr/limit.c
index 4fcf798..cb2ade5 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -183,14 +183,14 @@ nft_rule_expr_limit_snprintf(char *buf, size_t le=
n, uint32_t type,
 	struct nft_expr_limit *limit =3D nft_expr_data(e);
=20
 	switch(type) {
-	case NFT_RULE_O_DEFAULT:
+	case NFT_FORMAT_DEFAULT:
 		return snprintf(buf, len, "rate %"PRIu64"/%s ",
 				limit->rate, get_unit(limit->unit));
-	case NFT_RULE_O_XML:
+	case NFT_FORMAT_XML:
 		return snprintf(buf, len, "<rate>%"PRIu64"</rate>"
 					  "<unit>%"PRIu64"</unit>",
 				limit->rate, limit->unit);
-	case NFT_RULE_O_JSON:
+	case NFT_FORMAT_JSON:
 		return snprintf(buf, len, "\"rate\":%"PRIu64","
 					  "\"unit\":%"PRIu64"",
 				limit->rate, limit->unit);
diff --git a/src/expr/log.c b/src/expr/log.c
index 7722d62..62ee0a2 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -243,19 +243,19 @@ nft_rule_expr_log_snprintf(char *buf, size_t len,=
 uint32_t type,
 	struct nft_expr_log *log =3D nft_expr_data(e);
=20
 	switch(type) {
-	case NFT_RULE_O_DEFAULT:
+	case NFT_FORMAT_DEFAULT:
 		return snprintf(buf, len, "prefix '%s' group %u "
 					  "snaplen %u qthreshold %u ",
 				log->prefix, log->group,
 				log->snaplen, log->qthreshold);
-	case NFT_RULE_O_XML:
+	case NFT_FORMAT_XML:
 		return snprintf(buf, len, "<prefix>%s</prefix>"
 					  "<group>%u</group>"
 					  "<snaplen>%u</snaplen>"
 					  "<qthreshold>%u</qthreshold>",
 				log->prefix, log->group,
 				log->snaplen, log->qthreshold);
-	case NFT_RULE_O_JSON:
+	case NFT_FORMAT_JSON:
 		return snprintf(buf, len, "\"prefix\":\"%s\","
 					  "\"group\":%u,"
 					  "\"snaplen\":%u,"
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index e37e295..789c61d 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -257,11 +257,11 @@ nft_rule_expr_lookup_snprintf(char *buf, size_t s=
ize, uint32_t type,
 	struct nft_expr_lookup *lookup =3D nft_expr_data(e);
=20
 	switch(type) {
-	case NFT_RULE_O_DEFAULT:
+	case NFT_FORMAT_DEFAULT:
 		return nft_rule_expr_lookup_snprintf_default(buf, size, lookup);
-	case NFT_RULE_O_XML:
+	case NFT_FORMAT_XML:
 		return nft_rule_expr_lookup_snprintf_xml(buf, size, lookup);
-	case NFT_RULE_O_JSON:
+	case NFT_FORMAT_JSON:
 		return nft_rule_expr_lookup_snprintf_json(buf, size, lookup);
 	default:
 		break;
diff --git a/src/expr/match.c b/src/expr/match.c
index c03ab12..6b2fb74 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -245,12 +245,12 @@ nft_rule_expr_match_snprintf(char *buf, size_t le=
n, uint32_t type,
 	struct nft_expr_match *match =3D nft_expr_data(e);
=20
 	switch(type) {
-	case NFT_RULE_O_DEFAULT:
+	case NFT_FORMAT_DEFAULT:
 		return snprintf(buf, len, "name %s rev %u ",
 				match->name, match->rev);
-	case NFT_RULE_O_XML:
+	case NFT_FORMAT_XML:
 		return nft_rule_expr_match_snprintf_xml(buf, len, match);
-	case NFT_RULE_O_JSON:
+	case NFT_FORMAT_JSON:
 		return nft_rule_expr_match_snprintf_json(buf, len, match);
 	default:
 		break;
diff --git a/src/expr/meta.c b/src/expr/meta.c
index beeb8ca..535642d 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -231,14 +231,14 @@ nft_rule_expr_meta_snprintf(char *buf, size_t len=
, uint32_t type,
 	struct nft_expr_meta *meta =3D nft_expr_data(e);
=20
 	switch(type) {
-	case NFT_RULE_O_DEFAULT:
+	case NFT_FORMAT_DEFAULT:
 		return snprintf(buf, len, "load %s =3D> reg %u ",
 				meta_key2str(meta->key), meta->dreg);
-	case NFT_RULE_O_XML:
+	case NFT_FORMAT_XML:
 		return snprintf(buf, len, "<dreg>%u</dreg>"
 					  "<key>%s</key>",
 				meta->dreg, meta_key2str(meta->key));
-	case NFT_RULE_O_JSON:
+	case NFT_FORMAT_JSON:
 		return snprintf(buf, len, "\"dreg\":%u,"
 					  "\"key\":\"%s\"",
 				meta->dreg, meta_key2str(meta->key));
diff --git a/src/expr/nat.c b/src/expr/nat.c
index 7150eec..e8f6351 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -438,11 +438,11 @@ nft_rule_expr_nat_snprintf(char *buf, size_t size=
, uint32_t type,
 			   uint32_t flags, struct nft_rule_expr *e)
 {
 	switch (type) {
-	case NFT_RULE_O_DEFAULT:
+	case NFT_FORMAT_DEFAULT:
 		return nft_rule_expr_nat_snprintf_default(buf, size, e);
-	case NFT_RULE_O_XML:
+	case NFT_FORMAT_XML:
 		return nft_rule_expr_nat_snprintf_xml(buf, size, e);
-	case NFT_RULE_O_JSON:
+	case NFT_FORMAT_JSON:
 		return nft_rule_expr_nat_snprintf_json(buf, size, e);
 	default:
 		break;
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 390b8ef..12c8781 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -302,14 +302,14 @@ nft_rule_expr_payload_snprintf(char *buf, size_t =
len, uint32_t type,
 	struct nft_expr_payload *payload =3D nft_expr_data(e);
=20
 	switch(type) {
-	case NFT_RULE_O_DEFAULT:
+	case NFT_FORMAT_DEFAULT:
 		return snprintf(buf, len, "load %ub @ %s header + %u =3D> reg %u ",
 				payload->len, base2str(payload->base),
 				payload->offset, payload->dreg);
-	case NFT_RULE_O_XML:
+	case NFT_FORMAT_XML:
 		return nft_rule_expr_payload_snprintf_xml(buf, len, flags,
 							  payload);
-	case NFT_RULE_O_JSON:
+	case NFT_FORMAT_JSON:
 		return nft_rule_expr_payload_snprintf_json(buf, len, flags,
 							  payload);
 	default:
diff --git a/src/expr/reject.c b/src/expr/reject.c
index ca008ef..26b0734 100644
--- a/src/expr/reject.c
+++ b/src/expr/reject.c
@@ -177,14 +177,14 @@ nft_rule_expr_reject_snprintf(char *buf, size_t l=
en, uint32_t type,
 	struct nft_expr_reject *reject =3D nft_expr_data(e);
=20
 	switch(type) {
-	case NFT_RULE_O_DEFAULT:
+	case NFT_FORMAT_DEFAULT:
 		return snprintf(buf, len, "type %u code %u  ",
 				reject->type, reject->icmp_code);
-	case NFT_RULE_O_XML:
+	case NFT_FORMAT_XML:
 		return snprintf(buf, len, "<type>%u</type>"
 					  "<code>%u</code>",
 				reject->type, reject->icmp_code);
-	case NFT_RULE_O_JSON:
+	case NFT_FORMAT_JSON:
 		return snprintf(buf, len, "\"type\":%u,"
 					  "\"code\":%u,",
 				reject->type, reject->icmp_code);
diff --git a/src/expr/target.c b/src/expr/target.c
index 43fb666..40274a7 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -247,12 +247,12 @@ nft_rule_expr_target_snprintf(char *buf, size_t l=
en, uint32_t type,
 	struct nft_expr_target *target =3D nft_expr_data(e);
=20
 	switch(type) {
-	case NFT_RULE_O_DEFAULT:
+	case NFT_FORMAT_DEFAULT:
 		return snprintf(buf, len, "name %s rev %u ",
 				target->name, target->rev);
-	case NFT_RULE_O_XML:
+	case NFT_FORMAT_XML:
 		return nft_rule_exp_target_snprintf_xml(buf, len, target);
-	case NFT_RULE_O_JSON:
+	case NFT_FORMAT_JSON:
 		return nft_rule_exp_target_snprintf_json(buf, len, target);
 	default:
 		break;
diff --git a/src/rule.c b/src/rule.c
index 3b45dc7..68e0b2f 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -658,16 +658,16 @@ static int nft_rule_xml_parse(struct nft_rule *r,=
 const char *xml)
 #endif
 }
=20
-int nft_rule_parse(struct nft_rule *r, enum nft_rule_parse_type type,
+int nft_rule_parse(struct nft_rule *r, enum nft_parse_format_type type=
,
 		   const char *data)
 {
 	int ret;
=20
 	switch (type) {
-	case NFT_RULE_PARSE_XML:
+	case NFT_PARSE_FORMAT_XML:
 		ret =3D nft_rule_xml_parse(r, data);
 		break;
-	case NFT_RULE_PARSE_JSON:
+	case NFT_PARSE_FORMAT_JSON:
 		ret =3D nft_rule_json_parse(r, data);
 		break;
 	default:
@@ -806,11 +806,11 @@ int nft_rule_snprintf(char *buf, size_t size, str=
uct nft_rule *r,
 		       uint32_t type, uint32_t flags)
 {
 	switch(type) {
-	case NFT_RULE_O_DEFAULT:
+	case NFT_FORMAT_DEFAULT:
 		return nft_rule_snprintf_default(buf, size, r, type, flags);
-	case NFT_RULE_O_XML:
+	case NFT_FORMAT_XML:
 		return nft_rule_snprintf_xml(buf, size, r, type, flags);
-	case NFT_RULE_O_JSON:
+	case NFT_FORMAT_JSON:
 		return nft_rule_snprintf_json(buf, size, r, type, flags);
 	default:
 		break;
diff --git a/src/ruleset.c b/src/ruleset.c
index ee2c60a..838123a 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -557,16 +557,16 @@ err:
 #endif
 }
=20
-int nft_ruleset_parse(struct nft_ruleset *r, enum nft_ruleset_parse_ty=
pe type,
+int nft_ruleset_parse(struct nft_ruleset *r, enum nft_parse_format_typ=
e type,
 		      const char *data)
 {
 	int ret;
=20
 	switch (type) {
-	case NFT_RULESET_PARSE_XML:
+	case NFT_PARSE_FORMAT_XML:
 		ret =3D nft_ruleset_xml_parse(r, data);
 		break;
-	case NFT_RULESET_PARSE_JSON:
+	case NFT_PARSE_FORMAT_JSON:
 		ret =3D nft_ruleset_json_parse(r, data);
 		break;
 	default:
@@ -582,9 +582,9 @@ EXPORT_SYMBOL(nft_ruleset_parse);
 static const char *nft_ruleset_o_opentag(uint32_t type)
 {
 	switch (type) {
-	case NFT_RULESET_O_XML:
+	case NFT_FORMAT_XML:
 		return "<nftables>";
-	case NFT_RULESET_O_JSON:
+	case NFT_FORMAT_JSON:
 		return "{\"nftables\":[";
 	default:
 		return "";
@@ -597,9 +597,9 @@ static const char *nft_ruleset_o_separator(void *ob=
j, uint32_t type)
 		return "";
=20
 	switch (type) {
-	case NFT_RULESET_O_JSON:
+	case NFT_FORMAT_JSON:
 		return ",";
-	case NFT_RULESET_O_DEFAULT:
+	case NFT_FORMAT_DEFAULT:
 		return "\n";
 	default:
 		return "";
@@ -609,9 +609,9 @@ static const char *nft_ruleset_o_separator(void *ob=
j, uint32_t type)
 static const char *nft_ruleset_o_closetag(uint32_t type)
 {
 	switch (type) {
-	case NFT_RULESET_O_XML:
+	case NFT_FORMAT_XML:
 		return "</nftables>";
-	case NFT_RULESET_O_JSON:
+	case NFT_FORMAT_JSON:
 		return "]}";
 	default:
 		return "";
@@ -803,9 +803,9 @@ int nft_ruleset_snprintf(char *buf, size_t size, co=
nst struct nft_ruleset *r,
 			 uint32_t type, uint32_t flags)
 {
 	switch (type) {
-	case NFT_RULESET_O_DEFAULT:
-	case NFT_RULESET_O_XML:
-	case NFT_RULESET_O_JSON:
+	case NFT_FORMAT_DEFAULT:
+	case NFT_FORMAT_XML:
+	case NFT_FORMAT_JSON:
 		return nft_ruleset_do_snprintf(buf, size, r, type, flags);
 	default:
 		errno =3D EOPNOTSUPP;
diff --git a/src/set.c b/src/set.c
index 9620006..8e1a332 100644
--- a/src/set.c
+++ b/src/set.c
@@ -515,16 +515,16 @@ static int nft_set_xml_parse(struct nft_set *s, c=
onst char *xml)
 #endif
 }
=20
-int nft_set_parse(struct nft_set *s, enum nft_set_parse_type type,
+int nft_set_parse(struct nft_set *s, enum nft_parse_format_type type,
 		  const char *data)
 {
 	int ret;
=20
 	switch (type) {
-	case NFT_SET_PARSE_XML:
+	case NFT_PARSE_FORMAT_XML:
 		ret =3D nft_set_xml_parse(s, data);
 		break;
-	case NFT_SET_PARSE_JSON:
+	case NFT_PARSE_FORMAT_JSON:
 		ret =3D nft_set_json_parse(s, data);
 		break;
 	default:
@@ -640,7 +640,7 @@ static int nft_set_snprintf_xml(char *buf, size_t s=
ize, struct nft_set *s,
 	if (!list_empty(&s->element_list)) {
 		list_for_each_entry(elem, &s->element_list, head) {
 			ret =3D nft_set_elem_snprintf(buf+offset, len, elem,
-						    NFT_SET_O_XML, flags);
+						    NFT_FORMAT_XML, flags);
 			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 		}
 	}
@@ -655,11 +655,11 @@ int nft_set_snprintf(char *buf, size_t size, stru=
ct nft_set *s,
 		     uint32_t type, uint32_t flags)
 {
 	switch(type) {
-	case NFT_SET_O_DEFAULT:
+	case NFT_FORMAT_DEFAULT:
 		return nft_set_snprintf_default(buf, size, s, type, flags);
-	case NFT_SET_O_XML:
+	case NFT_FORMAT_XML:
 		return nft_set_snprintf_xml(buf, size, s, flags);
-	case NFT_SET_O_JSON:
+	case NFT_FORMAT_JSON:
 		return nft_set_snprintf_json(buf, size, s, type, flags);
 	default:
 		break;
diff --git a/src/set_elem.c b/src/set_elem.c
index 516905d..3d09bb7 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -434,11 +434,11 @@ static int nft_set_elem_xml_parse(struct nft_set_=
elem *e, const char *xml)
 }
=20
 int nft_set_elem_parse(struct nft_set_elem *e,
-		       enum nft_set_parse_type type, const char *data) {
+		       enum nft_parse_format_type type, const char *data) {
 	int ret;
=20
 	switch (type) {
-	case NFT_SET_PARSE_XML:
+	case NFT_PARSE_FORMAT_XML:
 		ret =3D nft_set_elem_xml_parse(e, data);
 		break;
 	default:
@@ -463,7 +463,7 @@ static int nft_set_elem_snprintf_json(char *buf, si=
ze_t size,
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	ret =3D nft_data_reg_snprintf(buf+offset, len, &e->key,
-				    NFT_RULE_O_JSON, flags, DATA_VALUE);
+				    NFT_FORMAT_JSON, flags, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	ret =3D snprintf(buf+offset, len, "}");
@@ -481,7 +481,7 @@ static int nft_set_elem_snprintf_json(char *buf, si=
ze_t size,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 		ret =3D nft_data_reg_snprintf(buf+offset, len, &e->data,
-				    NFT_RULE_O_JSON, flags, type);
+				    NFT_FORMAT_JSON, flags, type);
 			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 		ret =3D snprintf(buf+offset, len, "}");
@@ -529,7 +529,7 @@ static int nft_set_elem_snprintf_xml(char *buf, siz=
e_t size,
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	ret =3D nft_data_reg_snprintf(buf+offset, len, &e->key,
-				    NFT_RULE_O_XML, flags, DATA_VALUE);
+				    NFT_FORMAT_XML, flags, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	ret =3D snprintf(buf+offset, len, "</key>");
@@ -547,7 +547,7 @@ static int nft_set_elem_snprintf_xml(char *buf, siz=
e_t size,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 		ret =3D nft_data_reg_snprintf(buf+offset, len, &e->data,
-					    NFT_RULE_O_XML, flags, type);
+					    NFT_FORMAT_XML, flags, type);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 		ret =3D snprintf(buf+offset, len, "</data>");
@@ -564,11 +564,11 @@ int nft_set_elem_snprintf(char *buf, size_t size,=
 struct nft_set_elem *e,
 			   uint32_t type, uint32_t flags)
 {
 	switch(type) {
-	case NFT_SET_O_DEFAULT:
+	case NFT_FORMAT_DEFAULT:
 		return nft_set_elem_snprintf_default(buf, size, e);
-	case NFT_SET_O_XML:
+	case NFT_FORMAT_XML:
 		return nft_set_elem_snprintf_xml(buf, size, e, flags);
-	case NFT_SET_O_JSON:
+	case NFT_FORMAT_JSON:
 		return nft_set_elem_snprintf_json(buf, size, e, flags);
 	default:
 		break;
diff --git a/src/table.c b/src/table.c
index d1acc7c..ec188ed 100644
--- a/src/table.c
+++ b/src/table.c
@@ -324,16 +324,16 @@ static int nft_table_json_parse(struct nft_table =
*t, const char *json)
 #endif
 }
=20
-int nft_table_parse(struct nft_table *t, enum nft_table_parse_type typ=
e,
+int nft_table_parse(struct nft_table *t, enum nft_parse_format_type ty=
pe,
 		    const char *data)
 {
 	int ret;
=20
 	switch (type) {
-	case NFT_TABLE_PARSE_XML:
+	case NFT_PARSE_FORMAT_XML:
 		ret =3D nft_table_xml_parse(t, data);
 		break;
-	case NFT_TABLE_PARSE_JSON:
+	case NFT_PARSE_FORMAT_JSON:
 		ret =3D nft_table_json_parse(t, data);
 		break;
 	default:
@@ -375,11 +375,11 @@ int nft_table_snprintf(char *buf, size_t size, st=
ruct nft_table *t,
 		       uint32_t type, uint32_t flags)
 {
 	switch(type) {
-	case NFT_TABLE_O_DEFAULT:
+	case NFT_FORMAT_DEFAULT:
 		return nft_table_snprintf_default(buf, size, t);
-	case NFT_TABLE_O_XML:
+	case NFT_FORMAT_XML:
 		return nft_table_snprintf_xml(buf, size, t);
-	case NFT_TABLE_O_JSON:
+	case NFT_FORMAT_JSON:
 		return nft_table_snprintf_json(buf, size, t);
 	default:
 		break;
diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index 9fa69ae..0a15dd6 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -112,36 +112,36 @@ static int compare_test(uint32_t type, void *inpu=
t, const char *filename)
=20
 	switch (type) {
 	case TEST_XML_TABLE:
-		nft_table_snprintf(out, sizeof(out), t, NFT_TABLE_O_XML, 0);
+		nft_table_snprintf(out, sizeof(out), t, NFT_FORMAT_XML, 0);
 		break;
 	case TEST_JSON_TABLE:
-		nft_table_snprintf(out, sizeof(out), t, NFT_TABLE_O_JSON, 0);
+		nft_table_snprintf(out, sizeof(out), t, NFT_FORMAT_JSON, 0);
 		break;
 	case TEST_XML_CHAIN:
-		nft_chain_snprintf(out, sizeof(out), c, NFT_CHAIN_O_XML, 0);
+		nft_chain_snprintf(out, sizeof(out), c, NFT_FORMAT_XML, 0);
 		break;
 	case TEST_JSON_CHAIN:
-		nft_chain_snprintf(out, sizeof(out), c, NFT_CHAIN_O_JSON, 0);
+		nft_chain_snprintf(out, sizeof(out), c, NFT_FORMAT_JSON, 0);
 		break;
 	case TEST_XML_RULE:
-		nft_rule_snprintf(out, sizeof(out), r, NFT_RULE_O_XML, 0);
+		nft_rule_snprintf(out, sizeof(out), r, NFT_FORMAT_XML, 0);
 		break;
 	case TEST_JSON_RULE:
-		nft_rule_snprintf(out, sizeof(out), r, NFT_RULE_O_JSON, 0);
+		nft_rule_snprintf(out, sizeof(out), r, NFT_FORMAT_JSON, 0);
 		break;
 	case TEST_XML_SET:
-		nft_set_snprintf(out, sizeof(out), s, NFT_SET_O_XML, 0);
+		nft_set_snprintf(out, sizeof(out), s, NFT_FORMAT_XML, 0);
 		break;
 	case TEST_JSON_SET:
-		nft_set_snprintf(out, sizeof(out), s, NFT_SET_O_JSON, 0);
+		nft_set_snprintf(out, sizeof(out), s, NFT_FORMAT_JSON, 0);
 		break;
 	case TEST_XML_RULESET:
 		nft_ruleset_snprintf(out, sizeof(out), rs,
-				     NFT_RULESET_O_XML, 0);
+				     NFT_FORMAT_XML, 0);
 		break;
 	case TEST_JSON_RULESET:
 		nft_ruleset_snprintf(out, sizeof(out), rs,
-				     NFT_RULESET_O_JSON, 0);
+				     NFT_FORMAT_JSON, 0);
 		break;
 	default:
 		errno =3D EINVAL;
@@ -191,7 +191,7 @@ static int test_json(const char *filename)
 	if (json_object_get(root, "table") !=3D NULL) {
 		t =3D nft_table_alloc();
 		if (t !=3D NULL) {
-			if (nft_table_parse(t, NFT_TABLE_PARSE_JSON, json) =3D=3D 0)
+			if (nft_table_parse(t, NFT_PARSE_FORMAT_JSON, json) =3D=3D 0)
 				ret =3D compare_test(TEST_JSON_TABLE, t, filename);
 			else
 				goto failparsing;
@@ -201,7 +201,7 @@ static int test_json(const char *filename)
 	} else if (json_object_get(root, "chain") !=3D NULL) {
 		c =3D nft_chain_alloc();
 		if (c !=3D NULL) {
-			if (nft_chain_parse(c, NFT_CHAIN_PARSE_JSON, json) =3D=3D 0)
+			if (nft_chain_parse(c, NFT_PARSE_FORMAT_JSON, json) =3D=3D 0)
 				ret =3D compare_test(TEST_JSON_CHAIN, c, filename);
 			else
 				goto failparsing;
@@ -211,7 +211,7 @@ static int test_json(const char *filename)
 	} else if (json_object_get(root, "rule") !=3D NULL) {
 		r =3D nft_rule_alloc();
 		if (r !=3D NULL) {
-			if (nft_rule_parse(r, NFT_RULE_PARSE_JSON, json) =3D=3D 0)
+			if (nft_rule_parse(r, NFT_PARSE_FORMAT_JSON, json) =3D=3D 0)
 				ret =3D compare_test(TEST_JSON_RULE, r, filename);
 			else
 				goto failparsing;
@@ -221,7 +221,7 @@ static int test_json(const char *filename)
 	} else if (json_object_get(root, "set") !=3D NULL) {
 		s =3D nft_set_alloc();
 		if (s !=3D NULL) {
-			if (nft_set_parse(s, NFT_SET_PARSE_JSON, json) =3D=3D 0)
+			if (nft_set_parse(s, NFT_PARSE_FORMAT_JSON, json) =3D=3D 0)
 				ret =3D compare_test(TEST_JSON_SET, s, filename);
 			else
 				goto failparsing;
@@ -231,7 +231,7 @@ static int test_json(const char *filename)
 	} else if (json_object_get(root, "nftables") !=3D NULL) {
 		rs =3D nft_ruleset_alloc();
 		if (rs !=3D NULL) {
-			if (nft_ruleset_parse(rs, NFT_RULESET_PARSE_JSON, json) =3D=3D 0)
+			if (nft_ruleset_parse(rs, NFT_PARSE_FORMAT_JSON, json) =3D=3D 0)
 				ret =3D compare_test(TEST_JSON_RULESET, rs, filename);
 			else
 				goto failparsing;
@@ -290,7 +290,7 @@ static int test_xml(const char *filename)
 	if (strcmp(tree->value.opaque, "table") =3D=3D 0) {
 		t =3D nft_table_alloc();
 		if (t !=3D NULL) {
-			if (nft_table_parse(t, NFT_TABLE_PARSE_XML, xml) =3D=3D 0)
+			if (nft_table_parse(t, NFT_PARSE_FORMAT_XML, xml) =3D=3D 0)
 				ret =3D compare_test(TEST_XML_TABLE, t, filename);
 			else
 				goto failparsing;
@@ -300,7 +300,7 @@ static int test_xml(const char *filename)
 	} else if (strcmp(tree->value.opaque, "chain") =3D=3D 0) {
 		c =3D nft_chain_alloc();
 		if (c !=3D NULL) {
-			if (nft_chain_parse(c, NFT_CHAIN_PARSE_XML, xml) =3D=3D 0)
+			if (nft_chain_parse(c, NFT_PARSE_FORMAT_XML, xml) =3D=3D 0)
 				ret =3D compare_test(TEST_XML_CHAIN, c, filename);
 			else
 				goto failparsing;
@@ -310,7 +310,7 @@ static int test_xml(const char *filename)
 	} else if (strcmp(tree->value.opaque, "rule") =3D=3D 0) {
 		r =3D nft_rule_alloc();
 		if (r !=3D NULL) {
-			if (nft_rule_parse(r, NFT_RULE_PARSE_XML, xml) =3D=3D 0)
+			if (nft_rule_parse(r, NFT_PARSE_FORMAT_XML, xml) =3D=3D 0)
 				ret =3D compare_test(TEST_XML_RULE, r, filename);
 			else
 				goto failparsing;
@@ -320,7 +320,7 @@ static int test_xml(const char *filename)
 	} else if (strcmp(tree->value.opaque, "set") =3D=3D 0) {
 		s =3D nft_set_alloc();
 		if (s !=3D NULL) {
-			if (nft_set_parse(s, NFT_SET_PARSE_XML, xml) =3D=3D 0)
+			if (nft_set_parse(s, NFT_PARSE_FORMAT_XML, xml) =3D=3D 0)
 				ret =3D compare_test(TEST_XML_SET, s, filename);
 			else
 				goto failparsing;
@@ -330,7 +330,7 @@ static int test_xml(const char *filename)
 	} else if (strcmp(tree->value.opaque, "nftables") =3D=3D 0) {
 		rs =3D nft_ruleset_alloc();
 		if (rs !=3D NULL) {
-			if (nft_ruleset_parse(rs, NFT_RULESET_PARSE_XML,
+			if (nft_ruleset_parse(rs, NFT_PARSE_FORMAT_XML,
 					      xml) =3D=3D 0)
 				ret =3D compare_test(TEST_XML_RULESET, rs,
 						   filename);

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
