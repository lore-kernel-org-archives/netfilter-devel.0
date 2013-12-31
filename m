From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 2/2] src: new error reporting approach for
 XML/JSON parsers
Date: Tue, 31 Dec 2013 12:27:54 +0100
Message-ID: <20131231112754.11095.95241.stgit@Ph0enix>
References: <20131231112747.11095.53072.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:57072 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab3LaL2n (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Dec 2013 06:28:43 -0500
Received: by mail-we0-f175.google.com with SMTP id t60so10831690wes.20
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Dec 2013 03:28:41 -0800 (PST)
Received: from [127.0.1.1] (85.136.70.56.dyn.user.ono.com. [85.136.70.56])
        by mx.google.com with ESMTPSA id z2sm71951048wiy.11.2013.12.31.03.28.39
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Dec 2013 03:28:40 -0800 (PST)
In-Reply-To: <20131231112747.11095.53072.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

I have added a new structure for reporting some errors that
we can't consider with errno.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 examples/nft-chain-json-add.c |   11 +++++
 examples/nft-chain-xml-add.c  |   11 +++++
 examples/nft-rule-json-add.c  |   11 +++++
 examples/nft-rule-xml-add.c   |   11 +++++
 examples/nft-set-json-add.c   |   12 +++++
 examples/nft-table-json-add.c |   11 +++++
 examples/nft-table-xml-add.c  |   12 +++++
 include/libnftables/chain.h   |    3 +
 include/libnftables/common.h  |   11 +++++
 include/libnftables/rule.h    |    3 +
 include/libnftables/ruleset.h |    3 +
 include/libnftables/set.h     |    6 ++-
 include/libnftables/table.h   |    3 +
 src/Makefile.am               |    1=20
 src/chain.c                   |   75 ++++++++++++++++++++-------------=
-
 src/common.c                  |   33 +++++++++++++++
 src/expr/bitwise.c            |   26 ++++++------
 src/expr/byteorder.c          |   27 +++++++-----
 src/expr/cmp.c                |   20 +++++----
 src/expr/counter.c            |   16 +++++--
 src/expr/ct.c                 |   19 +++++----
 src/expr/data_reg.c           |   54 ++++++++++++++-----------
 src/expr/data_reg.h           |    6 ++-
 src/expr/exthdr.c             |   23 ++++++----
 src/expr/immediate.c          |   14 ++++--
 src/expr/limit.c              |   17 +++++---
 src/expr/log.c                |   27 ++++++++----
 src/expr/lookup.c             |   18 +++++---
 src/expr/match.c              |   10 +++--
 src/expr/meta.c               |   14 ++++--
 src/expr/nat.c                |   30 +++++++-------
 src/expr/payload.c            |   24 ++++++-----
 src/expr/reject.c             |   16 +++++--
 src/expr/target.c             |   10 +++--
 src/expr_ops.h                |    6 ++-
 src/internal.h                |   90 +++++++++++++++++++++++++++++----=
--------
 src/jansson.c                 |   83 ++++++++++++++++++++++++++-------=
-----
 src/libnftables.map           |    5 ++
 src/mxml.c                    |   81 +++++++++++++++++++++++++++------=
----
 src/rule.c                    |   69 ++++++++++++++++++-------------
 src/ruleset.c                 |   72 +++++++++++++++++++--------------
 src/set.c                     |   70 ++++++++++++++++++--------------
 src/set_elem.c                |   21 +++++-----
 src/table.c                   |   44 ++++++++++++--------
 tests/nft-parsing-test.c      |   37 ++++++++++-------
 45 files changed, 759 insertions(+), 407 deletions(-)

diff --git a/examples/nft-chain-json-add.c b/examples/nft-chain-json-ad=
d.c
index 50cb29f..384729c 100644
--- a/examples/nft-chain-json-add.c
+++ b/examples/nft-chain-json-add.c
@@ -39,6 +39,7 @@ int main(int argc, char *argv[])
 	uint16_t family;
 	char json[4096];
 	char reprint[4096];
+	struct nft_parse_err *err;
=20
 	if (argc < 2) {
 		printf("Usage: %s <json-file>\n", argv[0]);
@@ -63,10 +64,17 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
=20
+	err =3D nft_err_alloc();
+	if(err =3D=3D NULL) {
+		perror("error");
+		exit(EXIT_FAILURE);
+	}
+
 	close(fd);
=20
-	if (nft_chain_parse(c, NFT_PARSE_JSON, json) < 0) {
+	if (nft_chain_parse(c, NFT_PARSE_JSON, json, err) < 0) {
 		printf("E: Unable to parse JSON file: %s\n", strerror(errno));
+		nft_err_print(err);
 		exit(EXIT_FAILURE);
 	}
=20
@@ -82,6 +90,7 @@ int main(int argc, char *argv[])
 	nft_chain_nlmsg_build_payload(nlh, c);
=20
 	nft_chain_free(c);
+	nft_err_free(err);
=20
 	nl =3D mnl_socket_open(NETLINK_NETFILTER);
 	if (nl =3D=3D NULL) {
diff --git a/examples/nft-chain-xml-add.c b/examples/nft-chain-xml-add.=
c
index 03a2950..e3dd652 100644
--- a/examples/nft-chain-xml-add.c
+++ b/examples/nft-chain-xml-add.c
@@ -37,6 +37,7 @@ int main(int argc, char *argv[])
 	uint16_t family;
 	char xml[4096];
 	char reprint[4096];
+	struct nft_parse_err *err;
=20
 	if (argc < 2) {
 		printf("Usage: %s <xml-file>\n", argv[0]);
@@ -49,6 +50,12 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
=20
+	err =3D nft_err_alloc();
+	if(err =3D=3D NULL) {
+		perror("error");
+		exit(EXIT_FAILURE);
+	}
+
         fd =3D open(argv[1], O_RDONLY);
         if (fd < 0) {
                 perror("open");
@@ -63,8 +70,9 @@ int main(int argc, char *argv[])
=20
 	close(fd);
=20
-	if (nft_chain_parse(c, NFT_PARSE_XML, xml) < 0) {
+	if (nft_chain_parse(c, NFT_PARSE_XML, xml, err) < 0) {
 		printf("E: Unable to parse XML file: %s\n", strerror(errno));
+		nft_err_print(err);
 		exit(EXIT_FAILURE);
 	}
=20
@@ -80,6 +88,7 @@ int main(int argc, char *argv[])
 	nft_chain_nlmsg_build_payload(nlh, c);
=20
 	nft_chain_free(c);
+	nft_err_free(err);
=20
 	nl =3D mnl_socket_open(NETLINK_NETFILTER);
 	if (nl =3D=3D NULL) {
diff --git a/examples/nft-rule-json-add.c b/examples/nft-rule-json-add.=
c
index 8659081..129338a 100644
--- a/examples/nft-rule-json-add.c
+++ b/examples/nft-rule-json-add.c
@@ -38,6 +38,7 @@ int main(int argc, char *argv[])
 	uint8_t family;
 	char json[4096];
 	char reprint[4096];
+	struct nft_parse_err *err;
=20
 	if (argc < 2) {
 		printf("Usage: %s <json-file>\n", argv[0]);
@@ -63,8 +64,15 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
=20
-	if (nft_rule_parse(r, NFT_PARSE_JSON, json) < 0) {
+	err =3D nft_err_alloc();
+	if(err =3D=3D NULL) {
+		perror("error");
+		exit(EXIT_FAILURE);
+	}
+
+	if (nft_rule_parse(r, NFT_PARSE_JSON, json, err) < 0) {
 		printf("E: Unable to parse JSON file: %s\n", strerror(errno));
+		nft_err_print(err);
 		exit(EXIT_FAILURE);
 	}
=20
@@ -80,6 +88,7 @@ int main(int argc, char *argv[])
 				       seq);
 	nft_rule_nlmsg_build_payload(nlh, r);
 	nft_rule_free(r);
+	nft_err_free(err);
=20
 	nl =3D mnl_socket_open(NETLINK_NETFILTER);
 	if (nl =3D=3D NULL) {
diff --git a/examples/nft-rule-xml-add.c b/examples/nft-rule-xml-add.c
index ce33fe7..6ac54ae 100644
--- a/examples/nft-rule-xml-add.c
+++ b/examples/nft-rule-xml-add.c
@@ -38,6 +38,7 @@ int main(int argc, char *argv[])
 	uint8_t family;
 	char xml[4096];
 	char reprint[4096];
+	struct nft_parse_err *err;
=20
 	if (argc < 2) {
 		printf("Usage: %s <xml-file>\n", argv[0]);
@@ -63,8 +64,15 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
=20
-	if (nft_rule_parse(r, NFT_PARSE_XML, xml) < 0) {
+	err =3D nft_err_alloc();
+	if(err =3D=3D NULL) {
+		perror("error");
+		exit(EXIT_FAILURE);
+	}
+
+	if (nft_rule_parse(r, NFT_PARSE_XML, xml, err) < 0) {
 		printf("E: Unable to parse XML file: %s\n", strerror(errno));
+		nft_err_print(err);
 		exit(EXIT_FAILURE);
 	}
=20
@@ -80,6 +88,7 @@ int main(int argc, char *argv[])
 				       seq);
 	nft_rule_nlmsg_build_payload(nlh, r);
 	nft_rule_free(r);
+	nft_err_free(err);
=20
 	nl =3D mnl_socket_open(NETLINK_NETFILTER);
 	if (nl =3D=3D NULL) {
diff --git a/examples/nft-set-json-add.c b/examples/nft-set-json-add.c
index 9a4aa48..28d6bec 100644
--- a/examples/nft-set-json-add.c
+++ b/examples/nft-set-json-add.c
@@ -38,6 +38,7 @@ int main(int argc, char *argv[])
 	uint16_t family;
 	char json[4096];
 	char reprint[4096];
+	struct nft_parse_err *err;
=20
 	if (argc < 2) {
 		printf("Usage: %s <json-file>\n", argv[0]);
@@ -62,10 +63,18 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
=20
+	err =3D nft_err_alloc();
+	if(err =3D=3D NULL) {
+		perror("error");
+		exit(EXIT_FAILURE);
+	}
+
+
 	close(fd);
=20
-	if (nft_set_parse(s, NFT_PARSE_JSON, json) < 0) {
+	if (nft_set_parse(s, NFT_PARSE_JSON, json, err) < 0) {
 		printf("E: Unable to parse JSON file: %s\n", strerror(errno));
+		nft_err_print(err);
 		exit(EXIT_FAILURE);
 	}
=20
@@ -80,6 +89,7 @@ int main(int argc, char *argv[])
 					NLM_F_CREATE|NLM_F_ACK, seq);
 	nft_set_nlmsg_build_payload(nlh, s);
 	nft_set_free(s);
+	nft_err_free(err);
=20
 	nl =3D mnl_socket_open(NETLINK_NETFILTER);
 	if (nl =3D=3D NULL) {
diff --git a/examples/nft-table-json-add.c b/examples/nft-table-json-ad=
d.c
index 6b16c7f..270e9df 100644
--- a/examples/nft-table-json-add.c
+++ b/examples/nft-table-json-add.c
@@ -39,6 +39,7 @@ int main(int argc, char *argv[])
 	uint16_t family;
 	char json[4096];
 	char reprint[4096];
+	struct nft_parse_err *err;
=20
 	if (argc < 2) {
 		printf("Usage: %s <json-file>\n", argv[0]);
@@ -64,8 +65,15 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
=20
-	if (nft_table_parse(t, NFT_PARSE_JSON, json) < 0) {
+	err =3D nft_err_alloc();
+	if(err =3D=3D NULL) {
+		perror("error");
+		exit(EXIT_FAILURE);
+	}
+
+	if (nft_table_parse(t, NFT_PARSE_JSON, json, err) < 0) {
 		printf("E: Unable to parse JSON file: %s\n", strerror(errno));
+		nft_err_print(err);
 		exit(EXIT_FAILURE);
 	}
=20
@@ -80,6 +88,7 @@ int main(int argc, char *argv[])
 					NLM_F_CREATE|NLM_F_ACK, seq);
 	nft_table_nlmsg_build_payload(nlh, t);
 	nft_table_free(t);
+	nft_err_free(err);
=20
 	nl =3D mnl_socket_open(NETLINK_NETFILTER);
 	if (nl =3D=3D NULL) {
diff --git a/examples/nft-table-xml-add.c b/examples/nft-table-xml-add.=
c
index 6a9163b..d876907 100644
--- a/examples/nft-table-xml-add.c
+++ b/examples/nft-table-xml-add.c
@@ -23,6 +23,7 @@
=20
 #include <libmnl/libmnl.h>
 #include <libnftables/table.h>
+#include <libnftables/common.h>
=20
 int main(int argc, char *argv[])
 {
@@ -35,6 +36,7 @@ int main(int argc, char *argv[])
 	uint16_t family;
 	char xml[4096];
 	char reprint[4096];
+	struct nft_parse_err *err;
=20
 	if (argc < 2) {
 		printf("Usage: %s <xml-file>\n", argv[0]);
@@ -60,8 +62,15 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
=20
-	if (nft_table_parse(t, NFT_PARSE_XML, xml) < 0) {
+	err =3D nft_err_alloc();
+	if(err =3D=3D NULL) {
+		perror("error");
+		exit(EXIT_FAILURE);
+	}
+
+	if (nft_table_parse(t, NFT_PARSE_XML, xml, err) < 0) {
 		printf("E: Unable to parse XML file: %s\n", strerror(errno));
+		nft_err_print(err);
 		exit(EXIT_FAILURE);
 	}
=20
@@ -76,6 +85,7 @@ int main(int argc, char *argv[])
 					NLM_F_CREATE|NLM_F_ACK, seq);
 	nft_table_nlmsg_build_payload(nlh, t);
 	nft_table_free(t);
+	nft_err_free(err);
=20
 	nl =3D mnl_socket_open(NETLINK_NETFILTER);
 	if (nl =3D=3D NULL) {
diff --git a/include/libnftables/chain.h b/include/libnftables/chain.h
index 8b4eab9..57ff4e6 100644
--- a/include/libnftables/chain.h
+++ b/include/libnftables/chain.h
@@ -51,7 +51,8 @@ struct nlmsghdr;
=20
 void nft_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct =
nft_chain *t);
=20
-int nft_chain_parse(struct nft_chain *c, enum nft_parse_type type, con=
st char *data);
+int nft_chain_parse(struct nft_chain *c, enum nft_parse_type type,
+  		    const char *data, struct nft_parse_err *err);
 int nft_chain_snprintf(char *buf, size_t size, struct nft_chain *t, ui=
nt32_t type, uint32_t flags);
 int nft_chain_fprintf(FILE *fp, struct nft_chain *c, uint32_t type, ui=
nt32_t flags);
=20
diff --git a/include/libnftables/common.h b/include/libnftables/common.=
h
index 9cd92b2..b88c899 100644
--- a/include/libnftables/common.h
+++ b/include/libnftables/common.h
@@ -1,6 +1,12 @@
 #ifndef _LIBNFTABLES_COMMON_H_
 #define _LIBNFTABLES_COMMON_H_
=20
+enum {
+	NFT_EBADINPUT	=3D 0,
+	NFT_EMISSINGNODE,
+	NFT_EBADTYPE,
+};
+
 enum nft_output_type {
 	NFT_OUTPUT_DEFAULT	=3D 0,
 	NFT_OUTPUT_XML,
@@ -14,7 +20,12 @@ enum nft_parse_type {
 	NFT_PARSE_MAX,
 };
=20
+struct nft_parse_err;
+
 struct nlmsghdr *nft_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t=
 family,
 				     uint16_t type, uint32_t seq);
=20
+struct nft_parse_err *nft_err_alloc(void);
+void nft_err_free(struct nft_parse_err *);
+void nft_err_print(struct nft_parse_err *);
 #endif
diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
index 86dbc17..1510203 100644
--- a/include/libnftables/rule.h
+++ b/include/libnftables/rule.h
@@ -47,7 +47,8 @@ struct nlmsghdr;
=20
 void nft_rule_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_rul=
e *t);
=20
-int nft_rule_parse(struct nft_rule *r, enum nft_parse_type type, const=
 char *data);
+int nft_rule_parse(struct nft_rule *r, enum nft_parse_type type,
+		   const char *data, struct nft_parse_err *err);
 int nft_rule_snprintf(char *buf, size_t size, struct nft_rule *t, uint=
32_t type, uint32_t flags);
 int nft_rule_fprintf(FILE *fp, struct nft_rule *r, uint32_t type, uint=
32_t flags);
=20
diff --git a/include/libnftables/ruleset.h b/include/libnftables/rulese=
t.h
index 1ec3059..b523346 100644
--- a/include/libnftables/ruleset.h
+++ b/include/libnftables/ruleset.h
@@ -30,7 +30,8 @@ void nft_ruleset_attr_unset(struct nft_ruleset *r, ui=
nt16_t attr);
 void nft_ruleset_attr_set(struct nft_ruleset *r, uint16_t attr, void *=
data);
 const void *nft_ruleset_attr_get(const struct nft_ruleset *r, uint16_t=
 attr);
=20
-int nft_ruleset_parse(struct nft_ruleset *rs, enum nft_parse_type type=
, const char *data);
+int nft_ruleset_parse(struct nft_ruleset *rs, enum nft_parse_type type=
,
+		      const char *data, struct nft_parse_err *err);
 int nft_ruleset_snprintf(char *buf, size_t size, const struct nft_rule=
set *rs, uint32_t type, uint32_t flags);
 int nft_ruleset_fprintf(FILE *fp, const struct nft_ruleset *rs, uint32=
_t type, uint32_t flags);
=20
diff --git a/include/libnftables/set.h b/include/libnftables/set.h
index 13ac857..9711729 100644
--- a/include/libnftables/set.h
+++ b/include/libnftables/set.h
@@ -60,7 +60,8 @@ struct nft_set *nft_set_list_iter_cur(struct nft_set_=
list_iter *iter);
 struct nft_set *nft_set_list_iter_next(struct nft_set_list_iter *iter)=
;
 void nft_set_list_iter_destroy(struct nft_set_list_iter *iter);
=20
-int nft_set_parse(struct nft_set *s, enum nft_parse_type type, const c=
har *data);
+int nft_set_parse(struct nft_set *s, enum nft_parse_type type,
+		  const char *data, struct nft_parse_err *err);
=20
 /*
  * Set elements
@@ -98,7 +99,8 @@ void nft_set_elem_nlmsg_build_payload(struct nlmsghdr=
 *nlh, struct nft_set_elem
=20
 int nft_set_elem_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_se=
t_elem *s);
=20
-int nft_set_elem_parse(struct nft_set_elem *e, enum nft_parse_type typ=
e, const char *data);
+int nft_set_elem_parse(struct nft_set_elem *e, enum nft_parse_type typ=
e,
+		       const char *data, struct nft_parse_err *err);
 int nft_set_elem_snprintf(char *buf, size_t size, struct nft_set_elem =
*s, uint32_t type, uint32_t flags);
 int nft_set_elem_fprintf(FILE *fp, struct nft_set_elem *se, uint32_t t=
ype, uint32_t flags);
=20
diff --git a/include/libnftables/table.h b/include/libnftables/table.h
index be60da9..80f2349 100644
--- a/include/libnftables/table.h
+++ b/include/libnftables/table.h
@@ -39,7 +39,8 @@ struct nlmsghdr;
=20
 void nft_table_nlmsg_build_payload(struct nlmsghdr *nlh, const struct =
nft_table *t);
=20
-int nft_table_parse(struct nft_table *t, enum nft_parse_type type, con=
st char *data);
+int nft_table_parse(struct nft_table *t, enum nft_parse_type type,
+		    const char *data, struct nft_parse_err *err);
 int nft_table_snprintf(char *buf, size_t size, struct nft_table *t, ui=
nt32_t type, uint32_t flags);
 int nft_table_fprintf(FILE *fp, struct nft_table *t, uint32_t type, ui=
nt32_t flags);
=20
diff --git a/src/Makefile.am b/src/Makefile.am
index 83ab658..fc13e46 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -4,6 +4,7 @@ lib_LTLIBRARIES =3D libnftables.la
 libnftables_la_LIBADD =3D ${LIBMNL_LIBS} ${LIBXML_LIBS} ${LIBJSON_LIBS=
}
 libnftables_la_LDFLAGS =3D -Wl,--version-script=3D$(srcdir)/libnftable=
s.map \
 			 -version-info $(LIBVERSION)
+
 libnftables_la_SOURCES =3D utils.c		\
 			 common.c		\
 			 table.c		\
diff --git a/src/chain.c b/src/chain.c
index a0004b5..a4ddb06 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -498,7 +498,8 @@ static inline int nft_str2hooknum(int family, const=
 char *hook)
 }
=20
 #ifdef JSON_PARSING
-int nft_jansson_parse_chain(struct nft_chain *c, json_t *tree)
+int nft_jansson_parse_chain(struct nft_chain *c, json_t *tree,
+			    struct nft_parse_err *err)
 {
 	json_t *root;
 	uint64_t uval64;
@@ -506,37 +507,40 @@ int nft_jansson_parse_chain(struct nft_chain *c, =
json_t *tree)
 	int32_t val32;
 	const char *valstr;
=20
-	root =3D nft_jansson_get_node(tree, "chain");
+	root =3D nft_jansson_get_node(tree, "chain", err);
 	if (root =3D=3D NULL)
 		return -1;
=20
-	valstr =3D nft_jansson_parse_str(root, "name");
+	valstr =3D nft_jansson_parse_str(root, "name", err);
 	if (valstr =3D=3D NULL)
 		goto err;
=20
 	nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_NAME, valstr);
=20
-	if (nft_jansson_parse_val(root, "handle", NFT_TYPE_U64, &uval64) < 0)
+	if (nft_jansson_parse_val(root, "handle", NFT_TYPE_U64, &uval64,
+				  err) < 0)
 		goto err;
=20
 	nft_chain_attr_set_u64(c,NFT_CHAIN_ATTR_HANDLE, uval64);
=20
-	if (nft_jansson_parse_val(root, "bytes", NFT_TYPE_U64, &uval64) < 0)
+	if (nft_jansson_parse_val(root, "bytes", NFT_TYPE_U64, &uval64,
+				  err) < 0)
 		goto err;
=20
 	nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_BYTES, uval64);
=20
-	if (nft_jansson_parse_val(root, "packets", NFT_TYPE_U64, &uval64) < 0=
)
+	if (nft_jansson_parse_val(root, "packets", NFT_TYPE_U64, &uval64,
+				  err) < 0)
 		goto err;
=20
 	nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_PACKETS, uval64);
=20
-	if (nft_jansson_parse_family(root, &val32) !=3D 0)
+	if (nft_jansson_parse_family(root, &val32, err) !=3D 0)
 		goto err;
=20
 	nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_FAMILY, val32);
=20
-	valstr =3D nft_jansson_parse_str(root, "table");
+	valstr =3D nft_jansson_parse_str(root, "table", err);
=20
 	if (valstr =3D=3D NULL)
 		goto err;
@@ -544,7 +548,7 @@ int nft_jansson_parse_chain(struct nft_chain *c, js=
on_t *tree)
 	nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_TABLE, valstr);
=20
 	if (nft_jansson_node_exist(root, "hooknum")) {
-		valstr =3D nft_jansson_parse_str(root, "type");
+		valstr =3D nft_jansson_parse_str(root, "type", err);
=20
 		if (valstr =3D=3D NULL)
 			goto err;
@@ -552,12 +556,12 @@ int nft_jansson_parse_chain(struct nft_chain *c, =
json_t *tree)
 		nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_TYPE, valstr);
=20
 		if (nft_jansson_parse_val(root, "prio", NFT_TYPE_S32,
-					  &val32) < 0)
+					  &val32, err) < 0)
 			goto err;
=20
 		nft_chain_attr_set_s32(c, NFT_CHAIN_ATTR_PRIO, val32);
=20
-		valstr =3D nft_jansson_parse_str(root, "hooknum");
+		valstr =3D nft_jansson_parse_str(root, "hooknum", err);
 		if (valstr =3D=3D NULL)
 			goto err;
=20
@@ -567,7 +571,7 @@ int nft_jansson_parse_chain(struct nft_chain *c, js=
on_t *tree)
=20
 		nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_HOOKNUM, val32);
=20
-		valstr =3D nft_jansson_parse_str(root, "policy");
+		valstr =3D nft_jansson_parse_str(root, "policy", err);
 		if (valstr =3D=3D NULL)
 			goto err;
=20
@@ -587,17 +591,18 @@ err:
 }
 #endif
=20
-static int nft_chain_json_parse(struct nft_chain *c, const char *json)
+static int nft_chain_json_parse(struct nft_chain *c, const char *json,
+				struct nft_parse_err *err)
 {
 #ifdef JSON_PARSING
 	json_t *tree;
 	json_error_t error;
=20
-	tree =3D nft_jansson_create_root(json, &error);
+	tree =3D nft_jansson_create_root(json, &error, err);
 	if (tree =3D=3D NULL)
 		return -1;
=20
-	return nft_jansson_parse_chain(c, tree);
+	return nft_jansson_parse_chain(c, tree, err);
 #else
 	errno =3D EOPNOTSUPP;
 	return -1;
@@ -605,13 +610,14 @@ static int nft_chain_json_parse(struct nft_chain =
*c, const char *json)
 }
=20
 #ifdef XML_PARSING
-int nft_mxml_chain_parse(mxml_node_t *tree, struct nft_chain *c)
+int nft_mxml_chain_parse(mxml_node_t *tree, struct nft_chain *c,
+			 struct nft_parse_err *err)
 {
 	const char *table, *name, *hooknum_str, *policy_str, *type;
 	int family, hooknum, policy;
=20
 	name =3D nft_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST,
-				  NFT_XML_MAND);
+				  NFT_XML_MAND, err);
 	if (name =3D=3D NULL)
 		return -1;
=20
@@ -619,25 +625,25 @@ int nft_mxml_chain_parse(mxml_node_t *tree, struc=
t nft_chain *c)
 	c->flags |=3D (1 << NFT_CHAIN_ATTR_NAME);
=20
 	if (nft_mxml_num_parse(tree, "handle", MXML_DESCEND_FIRST, BASE_DEC,
-			       &c->handle, NFT_TYPE_U64, NFT_XML_MAND) !=3D 0)
+			       &c->handle, NFT_TYPE_U64, NFT_XML_MAND, err) !=3D 0)
 		return -1;
=20
 	c->flags |=3D (1 << NFT_CHAIN_ATTR_HANDLE);
=20
 	if (nft_mxml_num_parse(tree, "bytes", MXML_DESCEND_FIRST, BASE_DEC,
-			       &c->bytes, NFT_TYPE_U64, NFT_XML_MAND) !=3D 0)
+			       &c->bytes, NFT_TYPE_U64, NFT_XML_MAND, err) !=3D 0)
 		return -1;
=20
 	c->flags |=3D (1 << NFT_CHAIN_ATTR_BYTES);
=20
 	if (nft_mxml_num_parse(tree, "packets", MXML_DESCEND_FIRST, BASE_DEC,
-			       &c->packets, NFT_TYPE_U64, NFT_XML_MAND) !=3D 0)
+			       &c->packets, NFT_TYPE_U64, NFT_XML_MAND, err) !=3D 0)
 		return -1;
=20
 	c->flags |=3D (1 << NFT_CHAIN_ATTR_PACKETS);
=20
 	table =3D nft_mxml_str_parse(tree, "table", MXML_DESCEND_FIRST,
-				   NFT_XML_MAND);
+				   NFT_XML_MAND, err);
 	if (table =3D=3D NULL)
 		return -1;
=20
@@ -648,7 +654,7 @@ int nft_mxml_chain_parse(mxml_node_t *tree, struct =
nft_chain *c)
 	c->flags |=3D (1 << NFT_CHAIN_ATTR_TABLE);
=20
 	family =3D nft_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST,
-				       NFT_XML_MAND);
+				       NFT_XML_MAND, err);
 	if (family < 0)
 		return -1;
=20
@@ -656,7 +662,7 @@ int nft_mxml_chain_parse(mxml_node_t *tree, struct =
nft_chain *c)
 	c->flags |=3D (1 << NFT_CHAIN_ATTR_FAMILY);
=20
 	hooknum_str =3D nft_mxml_str_parse(tree, "hooknum", MXML_DESCEND_FIRS=
T,
-					 NFT_XML_OPT);
+					 NFT_XML_OPT, err);
 	if (hooknum_str !=3D NULL) {
 		hooknum =3D nft_str2hooknum(c->family, hooknum_str);
 		if (hooknum < 0)
@@ -666,7 +672,7 @@ int nft_mxml_chain_parse(mxml_node_t *tree, struct =
nft_chain *c)
 		c->flags |=3D (1 << NFT_CHAIN_ATTR_HOOKNUM);
=20
 		type =3D nft_mxml_str_parse(tree, "type", MXML_DESCEND_FIRST,
-					  NFT_XML_MAND);
+					  NFT_XML_MAND, err);
 		if (type =3D=3D NULL)
 			return -1;
=20
@@ -679,14 +685,14 @@ int nft_mxml_chain_parse(mxml_node_t *tree, struc=
t nft_chain *c)
=20
 		if (nft_mxml_num_parse(tree, "prio", MXML_DESCEND, BASE_DEC,
 				       &c->prio, NFT_TYPE_S32,
-				       NFT_XML_MAND) !=3D 0)
+				       NFT_XML_MAND, err) !=3D 0)
 			return -1;
=20
 		c->flags |=3D (1 << NFT_CHAIN_ATTR_PRIO);
=20
 		policy_str =3D nft_mxml_str_parse(tree, "policy",
 						MXML_DESCEND_FIRST,
-						NFT_XML_MAND);
+						NFT_XML_MAND, err);
 		if (policy_str =3D=3D NULL)
 			return -1;
=20
@@ -702,15 +708,16 @@ int nft_mxml_chain_parse(mxml_node_t *tree, struc=
t nft_chain *c)
 }
 #endif
=20
-static int nft_chain_xml_parse(struct nft_chain *c, const char *xml)
+static int nft_chain_xml_parse(struct nft_chain *c, const char *xml,
+			       struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
 	int ret;
-	mxml_node_t *tree =3D nft_mxml_build_tree(xml, "chain");
+	mxml_node_t *tree =3D nft_mxml_build_tree(xml, "chain", err);
 	if (tree =3D=3D NULL)
 		return -1;
=20
-	ret =3D nft_mxml_chain_parse(tree, c);
+	ret =3D nft_mxml_chain_parse(tree, c, err);
 	mxmlDelete(tree);
 	return ret;
 #else
@@ -720,16 +727,17 @@ static int nft_chain_xml_parse(struct nft_chain *=
c, const char *xml)
 }
=20
 int nft_chain_parse(struct nft_chain *c, enum nft_parse_type type,
-		    const char *data)
+		    const char *data, struct nft_parse_err *err)
 {
 	int ret;
+	struct nft_parse_err perr;
=20
 	switch (type) {
 	case NFT_PARSE_XML:
-		ret =3D nft_chain_xml_parse(c, data);
+		ret =3D nft_chain_xml_parse(c, data, &perr);
 		break;
 	case NFT_PARSE_JSON:
-		ret =3D nft_chain_json_parse(c, data);
+		ret =3D nft_chain_json_parse(c, data, &perr);
 		break;
 	default:
 		ret =3D -1;
@@ -737,6 +745,9 @@ int nft_chain_parse(struct nft_chain *c, enum nft_p=
arse_type type,
 		break;
 	}
=20
+	if (err !=3D NULL)
+		*err =3D perr;
+
 	return ret;
 }
 EXPORT_SYMBOL(nft_chain_parse);
diff --git a/src/common.c b/src/common.c
index f03e730..701c41c 100644
--- a/src/common.c
+++ b/src/common.c
@@ -14,6 +14,7 @@
 #include <libnftables/common.h>
=20
 #include "internal.h"
+#include<stdlib.h>
=20
 struct nlmsghdr *nft_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t=
 family,
 				     uint16_t type, uint32_t seq)
@@ -33,4 +34,36 @@ struct nlmsghdr *nft_nlmsg_build_hdr(char *buf, uint=
16_t cmd, uint16_t family,
=20
 	return nlh;
 }
+
 EXPORT_SYMBOL(nft_nlmsg_build_hdr);
+
+struct nft_parse_err *nft_err_alloc(void)
+{
+	return calloc(1, sizeof(struct nft_parse_err));
+}
+EXPORT_SYMBOL(nft_err_alloc);
+
+void nft_err_free(struct nft_parse_err *err)
+{
+	xfree(err);
+}
+EXPORT_SYMBOL(nft_err_free);
+
+void nft_err_print(struct nft_parse_err *err)
+{
+	switch(err->error) {
+	case NFT_EBADINPUT:
+		printf("Error: Invalid input format in line %d column %d \n",
+		       err->line, err->column);
+		break;
+	case NFT_EMISSINGNODE:
+		printf("Error: Node \"%s\" not found \n", err->node_name);
+		break;
+	case NFT_EBADTYPE:
+		printf("Error: Invalid type in node \"%s\" \n", err->node_name);
+		break;
+	default:
+		printf("Error: Undefined error \n");
+	}
+}
+EXPORT_SYMBOL(nft_err_print);
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index bcec516..3c4f644 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -181,35 +181,36 @@ nft_rule_expr_bitwise_parse(struct nft_rule_expr =
*e, struct nlattr *attr)
 }
=20
 static int
-nft_rule_expr_bitwise_json_parse(struct nft_rule_expr *e, json_t *root=
)
+nft_rule_expr_bitwise_json_parse(struct nft_rule_expr *e, json_t *root=
,
+				 struct nft_parse_err *err)
 {
 #ifdef JSON_PARSING
 	struct nft_expr_bitwise *bitwise =3D nft_expr_data(e);
 	uint32_t reg, len;
=20
-	if (nft_jansson_parse_reg(root, "sreg", NFT_TYPE_U32, &reg) < 0)
+	if (nft_jansson_parse_reg(root, "sreg", NFT_TYPE_U32, &reg, err) < 0)
 		return -1;
=20
 	nft_rule_expr_set_u32(e, NFT_EXPR_BITWISE_SREG, reg);
=20
-	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &reg) < 0)
+	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &reg, err) < 0)
 		return -1;
=20
 	nft_rule_expr_set_u32(e, NFT_EXPR_BITWISE_DREG, reg);
=20
-	if (nft_jansson_parse_val(root, "len", NFT_TYPE_U32, &len) < 0)
+	if (nft_jansson_parse_val(root, "len", NFT_TYPE_U32, &len, err) < 0)
 		return -1;
=20
 	nft_rule_expr_set_u32(e, NFT_EXPR_BITWISE_LEN, len);
=20
 	if (nft_jansson_data_reg_parse(root, "mask",
-				       &bitwise->mask) !=3D DATA_VALUE)
+				       &bitwise->mask, err) !=3D DATA_VALUE)
 		return -1;
=20
 	e->flags |=3D (1 << NFT_EXPR_BITWISE_MASK);
=20
 	if (nft_jansson_data_reg_parse(root, "xor",
-				       &bitwise->xor) !=3D DATA_VALUE)
+				       &bitwise->xor, err) !=3D DATA_VALUE)
 		return -1;
=20
 	e->flags |=3D (1 << NFT_EXPR_BITWISE_XOR);
@@ -225,20 +226,21 @@ nft_rule_expr_bitwise_json_parse(struct nft_rule_=
expr *e, json_t *root)
 }
=20
 static int
-nft_rule_expr_bitwise_xml_parse(struct nft_rule_expr *e, mxml_node_t *=
tree)
+nft_rule_expr_bitwise_xml_parse(struct nft_rule_expr *e, mxml_node_t *=
tree,
+				struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
 	struct nft_expr_bitwise *bitwise =3D nft_expr_data(e);
 	int32_t reg;
=20
-	reg =3D nft_mxml_reg_parse(tree, "sreg", MXML_DESCEND_FIRST);
+	reg =3D nft_mxml_reg_parse(tree, "sreg", MXML_DESCEND_FIRST, err);
 	if (reg < 0)
 		return -1;
=20
 	bitwise->sreg =3D reg;
 	e->flags |=3D (1 << NFT_EXPR_BITWISE_SREG);
=20
-	reg =3D nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND);
+	reg =3D nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND, err);
 	if (reg < 0)
 		return -1;
=20
@@ -247,19 +249,19 @@ nft_rule_expr_bitwise_xml_parse(struct nft_rule_e=
xpr *e, mxml_node_t *tree)
=20
 	if (nft_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST,
 			       BASE_DEC, &bitwise->len, NFT_TYPE_U8,
-			       NFT_XML_MAND) !=3D 0)
+			       NFT_XML_MAND, err) !=3D 0)
 		return -1;
=20
 	e->flags |=3D (1 << NFT_EXPR_BITWISE_LEN);
=20
 	if (nft_mxml_data_reg_parse(tree, "mask", &bitwise->mask,
-				    NFT_XML_MAND) !=3D DATA_VALUE)
+				    NFT_XML_MAND, err) !=3D DATA_VALUE)
 		return -1;
=20
 	e->flags |=3D (1 << NFT_EXPR_BITWISE_MASK);
=20
 	if (nft_mxml_data_reg_parse(tree, "xor", &bitwise->xor,
-				    NFT_XML_MAND) !=3D DATA_VALUE)
+				    NFT_XML_MAND, err) !=3D DATA_VALUE)
 		return -1;
=20
 	e->flags |=3D (1 << NFT_EXPR_BITWISE_XOR);
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index 7224c82..d6beba3 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -194,24 +194,25 @@ static inline int nft_str2ntoh(const char *op)
 }
=20
 static int
-nft_rule_expr_byteorder_json_parse(struct nft_rule_expr *e, json_t *ro=
ot)
+nft_rule_expr_byteorder_json_parse(struct nft_rule_expr *e, json_t *ro=
ot,
+				   struct nft_parse_err *err)
 {
 #ifdef JSON_PARSING
 	const char *op;
 	uint32_t uval32;
 	int ntoh;
=20
-	if (nft_jansson_parse_reg(root, "sreg", NFT_TYPE_U32, &uval32) < 0)
+	if (nft_jansson_parse_reg(root, "sreg", NFT_TYPE_U32, &uval32, err) <=
 0)
 		return -1;
=20
 	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_SREG, uval32);
=20
-	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &uval32) < 0)
+	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &uval32, err) <=
 0)
 		return -1;
=20
 	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_DREG, uval32);
=20
-	op =3D nft_jansson_parse_str(root, "op");
+	op =3D nft_jansson_parse_str(root, "op", err);
 	if (op =3D=3D NULL)
 		return -1;
=20
@@ -221,12 +222,12 @@ nft_rule_expr_byteorder_json_parse(struct nft_rul=
e_expr *e, json_t *root)
=20
 	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_OP, ntoh);
=20
-	if (nft_jansson_parse_val(root, "len", NFT_TYPE_U32, &uval32) < 0)
+	if (nft_jansson_parse_val(root, "len", NFT_TYPE_U32, &uval32, err) < =
0)
 		return -1;
=20
 	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_LEN, uval32);
=20
-	if (nft_jansson_parse_val(root, "size", NFT_TYPE_U32, &uval32) < 0)
+	if (nft_jansson_parse_val(root, "size", NFT_TYPE_U32, &uval32, err) <=
 0)
 		return -1;
=20
 	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_SIZE, uval32);
@@ -239,28 +240,30 @@ nft_rule_expr_byteorder_json_parse(struct nft_rul=
e_expr *e, json_t *root)
 }
=20
 static int
-nft_rule_expr_byteorder_xml_parse(struct nft_rule_expr *e, mxml_node_t=
 *tree)
+nft_rule_expr_byteorder_xml_parse(struct nft_rule_expr *e, mxml_node_t=
 *tree,
+				  struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
 	struct nft_expr_byteorder *byteorder =3D nft_expr_data(e);
 	const char *op;
 	int32_t reg, ntoh;
=20
-	reg =3D nft_mxml_reg_parse(tree, "sreg", MXML_DESCEND_FIRST);
+	reg =3D nft_mxml_reg_parse(tree, "sreg", MXML_DESCEND_FIRST, err);
 	if (reg < 0)
 		return -1;
=20
 	byteorder->sreg =3D reg;
 	e->flags |=3D (1 << NFT_EXPR_BYTEORDER_SREG);
=20
-	reg =3D nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND);
+	reg =3D nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND, err);
 	if (reg < 0)
 		return -1;
=20
 	byteorder->dreg =3D reg;
 	e->flags |=3D (1 << NFT_EXPR_BYTEORDER_DREG);
=20
-	op =3D nft_mxml_str_parse(tree, "op", MXML_DESCEND_FIRST, NFT_XML_MAN=
D);
+	op =3D nft_mxml_str_parse(tree, "op", MXML_DESCEND_FIRST, NFT_XML_MAN=
D,
+				err);
 	if (op =3D=3D NULL)
 		return -1;
=20
@@ -273,14 +276,14 @@ nft_rule_expr_byteorder_xml_parse(struct nft_rule=
_expr *e, mxml_node_t *tree)
=20
 	if (nft_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST, BASE_DEC,
 			       &byteorder->len, NFT_TYPE_U8,
-			       NFT_XML_MAND) !=3D 0)
+			       NFT_XML_MAND, err) !=3D 0)
 		return -1;
=20
 	e->flags |=3D (1 << NFT_EXPR_BYTEORDER_LEN);
=20
 	if (nft_mxml_num_parse(tree, "size", MXML_DESCEND_FIRST, BASE_DEC,
 			       &byteorder->size, NFT_TYPE_U8,
-			       NFT_XML_MAND) !=3D 0)
+			       NFT_XML_MAND, err) !=3D 0)
 		return -1;
=20
 	e->flags |=3D (1 << NFT_EXPR_BYTEORDER_SIZE);
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 246f22f..ca1503c 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -174,7 +174,8 @@ static inline int nft_str2cmp(const char *op)
 	}
 }
=20
-static int nft_rule_expr_cmp_json_parse(struct nft_rule_expr *e, json_=
t *root)
+static int nft_rule_expr_cmp_json_parse(struct nft_rule_expr *e, json_=
t *root,
+					struct nft_parse_err *err)
 {
 #ifdef JSON_PARSING
 	struct nft_expr_cmp *cmp =3D nft_expr_data(e);
@@ -182,12 +183,12 @@ static int nft_rule_expr_cmp_json_parse(struct nf=
t_rule_expr *e, json_t *root)
 	uint32_t uval32;
 	int base;
=20
-	if (nft_jansson_parse_val(root, "sreg", NFT_TYPE_U32, &uval32) < 0)
+	if (nft_jansson_parse_val(root, "sreg", NFT_TYPE_U32, &uval32, err) <=
 0)
 		return -1;
=20
 	nft_rule_expr_set_u32(e, NFT_EXPR_CMP_SREG, uval32);
=20
-	op =3D nft_jansson_parse_str(root, "op");
+	op =3D nft_jansson_parse_str(root, "op", err);
 	if (op =3D=3D NULL)
 		return -1;
=20
@@ -198,7 +199,7 @@ static int nft_rule_expr_cmp_json_parse(struct nft_=
rule_expr *e, json_t *root)
 	nft_rule_expr_set_u32(e, NFT_EXPR_CMP_OP, base);
=20
 	if (nft_jansson_data_reg_parse(root, "cmpdata",
-				       &cmp->data) !=3D DATA_VALUE)
+				       &cmp->data, err) !=3D DATA_VALUE)
 		return -1;
=20
 	e->flags |=3D (1 << NFT_EXPR_CMP_DATA);
@@ -210,21 +211,23 @@ static int nft_rule_expr_cmp_json_parse(struct nf=
t_rule_expr *e, json_t *root)
 #endif
 }
=20
-static int nft_rule_expr_cmp_xml_parse(struct nft_rule_expr *e, mxml_n=
ode_t *tree)
+static int nft_rule_expr_cmp_xml_parse(struct nft_rule_expr *e, mxml_n=
ode_t *tree,
+				       struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
 	struct nft_expr_cmp *cmp =3D nft_expr_data(e);
 	const char *op;
 	int32_t reg, op_value;
=20
-	reg =3D nft_mxml_reg_parse(tree, "sreg", MXML_DESCEND_FIRST);
+	reg =3D nft_mxml_reg_parse(tree, "sreg", MXML_DESCEND_FIRST, err);
 	if (reg < 0)
 		return -1;
=20
 	cmp->sreg =3D reg;
 	e->flags |=3D (1 << NFT_EXPR_CMP_SREG);
=20
-	op =3D nft_mxml_str_parse(tree, "op", MXML_DESCEND_FIRST, NFT_XML_MAN=
D);
+	op =3D nft_mxml_str_parse(tree, "op", MXML_DESCEND_FIRST, NFT_XML_MAN=
D,
+				err);
 	if (op =3D=3D NULL)
 		return -1;
=20
@@ -236,7 +239,8 @@ static int nft_rule_expr_cmp_xml_parse(struct nft_r=
ule_expr *e, mxml_node_t *tre
 	e->flags |=3D (1 << NFT_EXPR_CMP_OP);
=20
 	if (nft_mxml_data_reg_parse(tree, "cmpdata",
-				    &cmp->data, NFT_XML_MAND) !=3D DATA_VALUE)
+				    &cmp->data, NFT_XML_MAND,
+				    err) !=3D DATA_VALUE)
 		return -1;
=20
 	e->flags |=3D (1 << NFT_EXPR_CMP_DATA);
diff --git a/src/expr/counter.c b/src/expr/counter.c
index 4919a69..11afb83 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -119,17 +119,18 @@ nft_rule_expr_counter_parse(struct nft_rule_expr =
*e, struct nlattr *attr)
 }
=20
 static int
-nft_rule_expr_counter_json_parse(struct nft_rule_expr *e, json_t *root=
)
+nft_rule_expr_counter_json_parse(struct nft_rule_expr *e, json_t *root=
,
+				 struct nft_parse_err *err)
 {
 #ifdef JSON_PARSING
 	uint64_t uval64;
=20
-	if (nft_jansson_parse_val(root, "pkts", NFT_TYPE_U64, &uval64) < 0)
+	if (nft_jansson_parse_val(root, "pkts", NFT_TYPE_U64, &uval64, err) <=
 0)
 		return -1;
=20
 	nft_rule_expr_set_u64(e, NFT_EXPR_CTR_PACKETS, uval64);
=20
-	if (nft_jansson_parse_val(root, "bytes", NFT_TYPE_U64, &uval64) < 0)
+	if (nft_jansson_parse_val(root, "bytes", NFT_TYPE_U64, &uval64, err) =
< 0)
 		return -1;
=20
 	nft_rule_expr_set_u64(e, NFT_EXPR_CTR_BYTES, uval64);
@@ -142,19 +143,22 @@ nft_rule_expr_counter_json_parse(struct nft_rule_=
expr *e, json_t *root)
 }
=20
 static int
-nft_rule_expr_counter_xml_parse(struct nft_rule_expr *e, mxml_node_t *=
tree)
+nft_rule_expr_counter_xml_parse(struct nft_rule_expr *e, mxml_node_t *=
tree,
+				struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
 	struct nft_expr_counter *ctr =3D nft_expr_data(e);
=20
 	if (nft_mxml_num_parse(tree, "pkts", MXML_DESCEND_FIRST, BASE_DEC,
-			       &ctr->pkts, NFT_TYPE_U64, NFT_XML_MAND) !=3D 0)
+			       &ctr->pkts, NFT_TYPE_U64, NFT_XML_MAND,
+			       err) !=3D 0)
 		return -1;
=20
 	e->flags |=3D (1 << NFT_EXPR_CTR_PACKETS);
=20
 	if (nft_mxml_num_parse(tree, "bytes", MXML_DESCEND_FIRST, BASE_DEC,
-			       &ctr->bytes, NFT_TYPE_U64, NFT_XML_MAND) !=3D 0)
+			       &ctr->bytes, NFT_TYPE_U64, NFT_XML_MAND,
+			       err) !=3D 0)
 		return -1;
=20
 	e->flags |=3D (1 << NFT_EXPR_CTR_BYTES);
diff --git a/src/expr/ct.c b/src/expr/ct.c
index 46e3cef..59d05a5 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -178,7 +178,8 @@ static inline int str2ctkey(const char *ctkey)
 	return -1;
 }
=20
-static int nft_rule_expr_ct_json_parse(struct nft_rule_expr *e, json_t=
 *root)
+static int nft_rule_expr_ct_json_parse(struct nft_rule_expr *e, json_t=
 *root,
+				       struct nft_parse_err *err)
 {
 #ifdef JSON_PARSING
 	const char *key_str;
@@ -186,13 +187,13 @@ static int nft_rule_expr_ct_json_parse(struct nft=
_rule_expr *e, json_t *root)
 	uint8_t dir;
 	int key;
=20
-	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &reg) < 0)
+	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &reg, err) < 0)
 		return -1;
=20
 	nft_rule_expr_set_u32(e, NFT_EXPR_CT_DREG, reg);
=20
 	if (nft_jansson_node_exist(root, "key")) {
-		key_str =3D nft_jansson_parse_str(root, "key");
+		key_str =3D nft_jansson_parse_str(root, "key", err);
 		if (key_str =3D=3D NULL)
 			return -1;
=20
@@ -205,7 +206,8 @@ static int nft_rule_expr_ct_json_parse(struct nft_r=
ule_expr *e, json_t *root)
 	}
=20
 	if (nft_jansson_node_exist(root, "dir")) {
-		if (nft_jansson_parse_val(root, "dir", NFT_TYPE_U8, &dir) < 0)
+		if (nft_jansson_parse_val(root, "dir", NFT_TYPE_U8, &dir,
+					  err) < 0)
 			return -1;
=20
 		if (dir !=3D IP_CT_DIR_ORIGINAL && dir !=3D IP_CT_DIR_REPLY)
@@ -225,7 +227,8 @@ err:
 }
=20
=20
-static int nft_rule_expr_ct_xml_parse(struct nft_rule_expr *e, mxml_no=
de_t *tree)
+static int nft_rule_expr_ct_xml_parse(struct nft_rule_expr *e, mxml_no=
de_t *tree,
+				      struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
 	struct nft_expr_ct *ct =3D nft_expr_data(e);
@@ -234,7 +237,7 @@ static int nft_rule_expr_ct_xml_parse(struct nft_ru=
le_expr *e, mxml_node_t *tree
 	int key;
 	uint8_t dir;
=20
-	reg =3D nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND_FIRST);
+	reg =3D nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND_FIRST, err);
 	if (reg < 0)
 		return -1;
=20
@@ -242,7 +245,7 @@ static int nft_rule_expr_ct_xml_parse(struct nft_ru=
le_expr *e, mxml_node_t *tree
 	e->flags |=3D (1 << NFT_EXPR_CT_DREG);
=20
 	key_str =3D nft_mxml_str_parse(tree, "key", MXML_DESCEND_FIRST,
-				     NFT_XML_MAND);
+				     NFT_XML_MAND, err);
 	if (key_str =3D=3D NULL)
 		return -1;
=20
@@ -254,7 +257,7 @@ static int nft_rule_expr_ct_xml_parse(struct nft_ru=
le_expr *e, mxml_node_t *tree
 	e->flags |=3D (1 << NFT_EXPR_CT_KEY);
=20
 	if (nft_mxml_num_parse(tree, "dir", MXML_DESCEND_FIRST, BASE_DEC,
-			       &dir, NFT_TYPE_U8, NFT_XML_MAND) !=3D 0)
+			       &dir, NFT_TYPE_U8, NFT_XML_MAND, err) !=3D 0)
 		return -1;
=20
 	if (dir !=3D IP_CT_DIR_ORIGINAL && dir !=3D IP_CT_DIR_REPLY)
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 76231af..462d464 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -27,12 +27,13 @@
 #include "internal.h"
=20
 #ifdef JSON_PARSING
-static int nft_data_reg_verdict_json_parse(union nft_data_reg *reg, js=
on_t *data)
+static int nft_data_reg_verdict_json_parse(union nft_data_reg *reg, js=
on_t *data,
+					   struct nft_parse_err *err)
 {
 	int verdict;
 	const char *verdict_str;
=20
-	verdict_str =3D nft_jansson_parse_str(data, "verdict");
+	verdict_str =3D nft_jansson_parse_str(data, "verdict", err);
 	if (verdict_str =3D=3D NULL)
 		return -1;
=20
@@ -45,9 +46,10 @@ static int nft_data_reg_verdict_json_parse(union nft=
_data_reg *reg, json_t *data
 	return 0;
 }
=20
-static int nft_data_reg_chain_json_parse(union nft_data_reg *reg, json=
_t *data)
+static int nft_data_reg_chain_json_parse(union nft_data_reg *reg, json=
_t *data,
+					 struct nft_parse_err *err)
 {
-	reg->chain =3D strdup(nft_jansson_parse_str(data, "chain"));
+	reg->chain =3D strdup(nft_jansson_parse_str(data, "chain", err));
 	if (reg->chain =3D=3D NULL) {
 		return -1;
 	}
@@ -55,19 +57,20 @@ static int nft_data_reg_chain_json_parse(union nft_=
data_reg *reg, json_t *data)
 	return 0;
 }
=20
-static int nft_data_reg_value_json_parse(union nft_data_reg *reg, json=
_t *data)
+static int nft_data_reg_value_json_parse(union nft_data_reg *reg, json=
_t *data,
+					 struct nft_parse_err *err)
 {
 	int i;
 	char node_name[6];
=20
-	if (nft_jansson_parse_val(data, "len", NFT_TYPE_U8, &reg->len) < 0)
+	if (nft_jansson_parse_val(data, "len", NFT_TYPE_U8, &reg->len, err) <=
 0)
 			return -1;
=20
 	for (i =3D 0; i < div_round_up(reg->len, sizeof(uint32_t)); i++) {
 		sprintf(node_name, "data%d", i);
=20
 		if (nft_jansson_str2num(data, node_name, BASE_HEX,
-				        &reg->val[i], NFT_TYPE_U32) !=3D 0)
+				        &reg->val[i], NFT_TYPE_U32, err) !=3D 0)
 			return -1;
 	}
=20
@@ -75,23 +78,24 @@ static int nft_data_reg_value_json_parse(union nft_=
data_reg *reg, json_t *data)
 }
 #endif
=20
-int nft_data_reg_json_parse(union nft_data_reg *reg, json_t *data)
+int nft_data_reg_json_parse(union nft_data_reg *reg, json_t *data,
+			    struct nft_parse_err *err)
 {
 #ifdef JSON_PARSING
=20
 	const char *type;
=20
-	type =3D nft_jansson_parse_str(data, "type");
+	type =3D nft_jansson_parse_str(data, "type", err);
 	if (type =3D=3D NULL)
 		return -1;
=20
 	/* Select what type of parsing is needed */
 	if (strcmp(type, "value") =3D=3D 0) {
-		return nft_data_reg_value_json_parse(reg, data);
+		return nft_data_reg_value_json_parse(reg, data, err);
 	} else if (strcmp(type, "verdict") =3D=3D 0) {
-		return nft_data_reg_verdict_json_parse(reg, data);
+		return nft_data_reg_verdict_json_parse(reg, data, err);
 	} else if (strcmp(type, "chain") =3D=3D 0) {
-		return nft_data_reg_chain_json_parse(reg, data);
+		return nft_data_reg_chain_json_parse(reg, data, err);
 	}
=20
 	return 0;
@@ -103,13 +107,14 @@ int nft_data_reg_json_parse(union nft_data_reg *r=
eg, json_t *data)
=20
 #ifdef XML_PARSING
 static int nft_data_reg_verdict_xml_parse(union nft_data_reg *reg,
-					  mxml_node_t *tree)
+					  mxml_node_t *tree,
+					  struct nft_parse_err *err)
 {
 	int verdict;
 	const char *verdict_str;
=20
 	verdict_str =3D nft_mxml_str_parse(tree, "verdict", MXML_DESCEND_FIRS=
T,
-					 NFT_XML_MAND);
+					 NFT_XML_MAND, err);
 	if (verdict_str =3D=3D NULL)
 		return DATA_NONE;
=20
@@ -123,12 +128,13 @@ static int nft_data_reg_verdict_xml_parse(union n=
ft_data_reg *reg,
 }
=20
 static int nft_data_reg_chain_xml_parse(union nft_data_reg *reg,
-					mxml_node_t *tree)
+					mxml_node_t *tree,
+					struct nft_parse_err *err)
 {
 	const char *chain;
=20
 	chain =3D nft_mxml_str_parse(tree, "chain", MXML_DESCEND_FIRST,
-				   NFT_XML_MAND);
+				   NFT_XML_MAND, err);
 	if (chain =3D=3D NULL)
 		return DATA_NONE;
=20
@@ -140,7 +146,8 @@ static int nft_data_reg_chain_xml_parse(union nft_d=
ata_reg *reg,
 }
=20
 static int nft_data_reg_value_xml_parse(union nft_data_reg *reg,
-					mxml_node_t *tree)
+					mxml_node_t *tree,
+					struct nft_parse_err *err)
 {
 	int i;
 	char node_name[6];
@@ -156,7 +163,7 @@ static int nft_data_reg_value_xml_parse(union nft_d=
ata_reg *reg,
 	*/
=20
 	if (nft_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST, BASE_DEC,
-			       &reg->len, NFT_TYPE_U8, NFT_XML_MAND) !=3D 0)
+			       &reg->len, NFT_TYPE_U8, NFT_XML_MAND, err) !=3D 0)
 		return DATA_NONE;
=20
 	/* Get and set <dataN> */
@@ -165,7 +172,7 @@ static int nft_data_reg_value_xml_parse(union nft_d=
ata_reg *reg,
=20
 		if (nft_mxml_num_parse(tree, node_name, MXML_DESCEND_FIRST,
 				       BASE_HEX, &reg->val[i], NFT_TYPE_U32,
-				       NFT_XML_MAND) !=3D 0)
+				       NFT_XML_MAND, err) !=3D 0)
 			return DATA_NONE;
 	}
=20
@@ -173,7 +180,8 @@ static int nft_data_reg_value_xml_parse(union nft_d=
ata_reg *reg,
 }
 #endif
=20
-int nft_data_reg_xml_parse(union nft_data_reg *reg, mxml_node_t *tree)
+int nft_data_reg_xml_parse(union nft_data_reg *reg, mxml_node_t *tree,
+			   struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
 	const char *type;
@@ -194,11 +202,11 @@ int nft_data_reg_xml_parse(union nft_data_reg *re=
g, mxml_node_t *tree)
 	}
=20
 	if (strcmp(type, "value") =3D=3D 0)
-		return nft_data_reg_value_xml_parse(reg, node);
+		return nft_data_reg_value_xml_parse(reg, node, err);
 	else if (strcmp(type, "verdict") =3D=3D 0)
-		return nft_data_reg_verdict_xml_parse(reg, node);
+		return nft_data_reg_verdict_xml_parse(reg, node, err);
 	else if (strcmp(type, "chain") =3D=3D 0)
-		return nft_data_reg_chain_xml_parse(reg, node);
+		return nft_data_reg_chain_xml_parse(reg, node, err);
=20
 	return DATA_NONE;
 #else
diff --git a/src/expr/data_reg.h b/src/expr/data_reg.h
index 8a6a235..5258051 100644
--- a/src/expr/data_reg.h
+++ b/src/expr/data_reg.h
@@ -29,8 +29,10 @@ union nft_data_reg {
=20
 int nft_data_reg_snprintf(char *buf, size_t size, union nft_data_reg *=
reg,
                         uint32_t output_format, uint32_t flags, int re=
g_type);
-int nft_data_reg_xml_parse(union nft_data_reg *reg, mxml_node_t *tree)=
;
+int nft_data_reg_xml_parse(union nft_data_reg *reg, mxml_node_t *tree,
+			   struct nft_parse_err *err);
 int nft_parse_data(union nft_data_reg *data, struct nlattr *attr, int =
*type);
-int nft_data_reg_json_parse(union nft_data_reg *reg, json_t *data);
+int nft_data_reg_json_parse(union nft_data_reg *reg, json_t *data,
+			    struct nft_parse_err *err);
=20
 #endif
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index 6841ac1..813830b 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -193,19 +193,20 @@ static inline int str2exthdr_type(const char *str=
)
 }
=20
 static int
-nft_rule_expr_exthdr_json_parse(struct nft_rule_expr *e, json_t *root)
+nft_rule_expr_exthdr_json_parse(struct nft_rule_expr *e, json_t *root,
+				struct nft_parse_err *err)
 {
 #ifdef JSON_PARSING
 	const char *exthdr_type;
 	uint32_t uval32;
 	int type;
=20
-	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &uval32) < 0)
+	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &uval32, err) <=
 0)
 		return -1;
=20
 	nft_rule_expr_set_u32(e, NFT_EXPR_EXTHDR_DREG, uval32);
=20
-	exthdr_type =3D nft_jansson_parse_str(root, "exthdr_type");
+	exthdr_type =3D nft_jansson_parse_str(root, "exthdr_type", err);
 	if (exthdr_type =3D=3D NULL)
 		return -1;
=20
@@ -215,12 +216,12 @@ nft_rule_expr_exthdr_json_parse(struct nft_rule_e=
xpr *e, json_t *root)
=20
 	nft_rule_expr_set_u32(e, NFT_EXPR_EXTHDR_TYPE, type);
=20
-	if (nft_jansson_parse_val(root, "offset", NFT_TYPE_U32, &uval32) < 0)
+	if (nft_jansson_parse_val(root, "offset", NFT_TYPE_U32, &uval32, err)=
 < 0)
 		return -1;
=20
 	nft_rule_expr_set_u32(e, NFT_EXPR_EXTHDR_OFFSET, uval32);
=20
-	if (nft_jansson_parse_val(root, "len", NFT_TYPE_U32, &uval32) < 0)
+	if (nft_jansson_parse_val(root, "len", NFT_TYPE_U32, &uval32, err) < =
0)
 		return -1;
=20
 	 nft_rule_expr_set_u32(e, NFT_EXPR_EXTHDR_LEN, uval32);
@@ -233,7 +234,8 @@ nft_rule_expr_exthdr_json_parse(struct nft_rule_exp=
r *e, json_t *root)
 }
=20
 static int
-nft_rule_expr_exthdr_xml_parse(struct nft_rule_expr *e, mxml_node_t *t=
ree)
+nft_rule_expr_exthdr_xml_parse(struct nft_rule_expr *e, mxml_node_t *t=
ree,
+			       struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
 	struct nft_expr_exthdr *exthdr =3D nft_expr_data(e);
@@ -241,7 +243,7 @@ nft_rule_expr_exthdr_xml_parse(struct nft_rule_expr=
 *e, mxml_node_t *tree)
 	int32_t reg;
 	int type;
=20
-	reg =3D nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND_FIRST);
+	reg =3D nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND_FIRST, err);
 	if (reg < 0)
 		return -1;
=20
@@ -249,7 +251,7 @@ nft_rule_expr_exthdr_xml_parse(struct nft_rule_expr=
 *e, mxml_node_t *tree)
 	e->flags |=3D (1 << NFT_EXPR_EXTHDR_DREG);
=20
 	exthdr_type =3D nft_mxml_str_parse(tree, "exthdr_type",
-					 MXML_DESCEND_FIRST, NFT_XML_MAND);
+					 MXML_DESCEND_FIRST, NFT_XML_MAND, err);
 	if (exthdr_type =3D=3D NULL)
 		return -1;
=20
@@ -263,14 +265,15 @@ nft_rule_expr_exthdr_xml_parse(struct nft_rule_ex=
pr *e, mxml_node_t *tree)
 	/* Get and set <offset> */
 	if (nft_mxml_num_parse(tree, "offset", MXML_DESCEND_FIRST, BASE_DEC,
 			       &exthdr->offset, NFT_TYPE_U32,
-			       NFT_XML_MAND) !=3D 0)
+			       NFT_XML_MAND, err) !=3D 0)
 		return -1;
=20
 	e->flags |=3D (1 << NFT_EXPR_EXTHDR_OFFSET);
=20
 	/* Get and set <len> */
 	if (nft_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST, BASE_DEC,
-			       &exthdr->len, NFT_TYPE_U32, NFT_XML_MAND) !=3D 0)
+			       &exthdr->len, NFT_TYPE_U32, NFT_XML_MAND,
+			       err) !=3D 0)
 		return -1;
=20
 	e->flags |=3D (1 << NFT_EXPR_EXTHDR_LEN);
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index a96d3de..3ae4082 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -178,20 +178,21 @@ nft_rule_expr_immediate_parse(struct nft_rule_exp=
r *e, struct nlattr *attr)
 }
=20
 static int
-nft_rule_expr_immediate_json_parse(struct nft_rule_expr *e, json_t *ro=
ot)
+nft_rule_expr_immediate_json_parse(struct nft_rule_expr *e, json_t *ro=
ot,
+				   struct nft_parse_err *err)
 {
 #ifdef JSON_PARSING
 	struct nft_expr_immediate *imm =3D nft_expr_data(e);
 	int datareg_type;
 	uint32_t reg;
=20
-	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &reg) < 0)
+	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &reg, err) < 0)
 		return -1;
=20
 	nft_rule_expr_set_u32(e, NFT_EXPR_IMM_DREG, reg);
=20
 	datareg_type =3D nft_jansson_data_reg_parse(root, "immediatedata",
-						  &imm->data);
+						  &imm->data, err);
 	if (datareg_type < 0)
 		return -1;
=20
@@ -217,14 +218,15 @@ nft_rule_expr_immediate_json_parse(struct nft_rul=
e_expr *e, json_t *root)
 }
=20
 static int
-nft_rule_expr_immediate_xml_parse(struct nft_rule_expr *e, mxml_node_t=
 *tree)
+nft_rule_expr_immediate_xml_parse(struct nft_rule_expr *e, mxml_node_t=
 *tree,
+				  struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
 	struct nft_expr_immediate *imm =3D nft_expr_data(e);
 	int datareg_type;
 	int32_t reg;
=20
-	reg =3D nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND_FIRST);
+	reg =3D nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND_FIRST, err);
 	if (reg < 0)
 		return -1;
=20
@@ -232,7 +234,7 @@ nft_rule_expr_immediate_xml_parse(struct nft_rule_e=
xpr *e, mxml_node_t *tree)
 	e->flags |=3D (1 << NFT_EXPR_IMM_DREG);
=20
 	datareg_type =3D nft_mxml_data_reg_parse(tree, "immediatedata",
-					       &imm->data, NFT_XML_MAND);
+					       &imm->data, NFT_XML_MAND, err);
 	switch (datareg_type) {
 	case DATA_VALUE:
 		e->flags |=3D (1 << NFT_EXPR_IMM_DATA);
diff --git a/src/expr/limit.c b/src/expr/limit.c
index 4854a77..e6b0492 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -118,17 +118,18 @@ nft_rule_expr_limit_parse(struct nft_rule_expr *e=
, struct nlattr *attr)
 	return 0;
 }
=20
-static int nft_rule_expr_limit_json_parse(struct nft_rule_expr *e, jso=
n_t *root)
+static int nft_rule_expr_limit_json_parse(struct nft_rule_expr *e, jso=
n_t *root,
+					  struct nft_parse_err *err)
 {
 #ifdef JSON_PARSING
 	uint64_t uval64;
=20
-	if (nft_jansson_parse_val(root, "rate", NFT_TYPE_U64, &uval64) < 0)
+	if (nft_jansson_parse_val(root, "rate", NFT_TYPE_U64, &uval64, err) <=
 0)
 		return -1;
=20
 	nft_rule_expr_set_u64(e, NFT_EXPR_LIMIT_RATE, uval64);
=20
-	if (nft_jansson_parse_val(root, "unit", NFT_TYPE_U64, &uval64) < 0)
+	if (nft_jansson_parse_val(root, "unit", NFT_TYPE_U64, &uval64, err) <=
 0)
 		return -1;
=20
 	nft_rule_expr_set_u64(e, NFT_EXPR_LIMIT_UNIT, uval64);
@@ -140,19 +141,23 @@ static int nft_rule_expr_limit_json_parse(struct =
nft_rule_expr *e, json_t *root)
 #endif
 }
=20
-static int nft_rule_expr_limit_xml_parse(struct nft_rule_expr *e, mxml=
_node_t *tree)
+static int nft_rule_expr_limit_xml_parse(struct nft_rule_expr *e,
+					 mxml_node_t *tree,
+					 struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
 	struct nft_expr_limit *limit =3D nft_expr_data(e);
=20
 	if (nft_mxml_num_parse(tree, "rate", MXML_DESCEND_FIRST, BASE_DEC,
-			       &limit->rate, NFT_TYPE_U64, NFT_XML_MAND) !=3D 0)
+			       &limit->rate, NFT_TYPE_U64, NFT_XML_MAND,
+			       err) !=3D 0)
 		return -1;
=20
 	e->flags |=3D (1 << NFT_EXPR_LIMIT_RATE);
=20
 	if (nft_mxml_num_parse(tree, "unit", MXML_DESCEND_FIRST, BASE_DEC,
-			       &limit->unit, NFT_TYPE_U64, NFT_XML_MAND) !=3D 0)
+			       &limit->unit, NFT_TYPE_U64, NFT_XML_MAND,
+			       err) !=3D 0)
 		return -1;
=20
 	e->flags |=3D (1 << NFT_EXPR_LIMIT_UNIT);
diff --git a/src/expr/log.c b/src/expr/log.c
index 76657a9..c62a8b4 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -160,31 +160,34 @@ nft_rule_expr_log_parse(struct nft_rule_expr *e, =
struct nlattr *attr)
 	return 0;
 }
=20
-static int nft_rule_expr_log_json_parse(struct nft_rule_expr *e, json_=
t *root)
+static int nft_rule_expr_log_json_parse(struct nft_rule_expr *e, json_=
t *root,
+					struct nft_parse_err *err)
 {
 #ifdef JSON_PARSING
 	const char *prefix;
 	uint32_t snaplen;
 	uint16_t uval16;
=20
-	prefix =3D nft_jansson_parse_str(root, "prefix");
+	prefix =3D nft_jansson_parse_str(root, "prefix", err);
 	if (prefix =3D=3D NULL)
 		return -1;
=20
 	nft_rule_expr_set_str(e, NFT_EXPR_LOG_PREFIX, prefix);
=20
-	if (nft_jansson_parse_val(root, "group", NFT_TYPE_U16, &uval16) < 0)
+	if (nft_jansson_parse_val(root, "group", NFT_TYPE_U16, &uval16,
+				  err) < 0)
 		return -1;
=20
 	nft_rule_expr_set_u16(e, NFT_EXPR_LOG_GROUP, uval16);
=20
-	if (nft_jansson_parse_val(root, "snaplen", NFT_TYPE_U32, &snaplen) < =
0)
+	if (nft_jansson_parse_val(root, "snaplen", NFT_TYPE_U32, &snaplen,
+				  err) < 0)
 		return -1;
=20
 	nft_rule_expr_set_u32(e, NFT_EXPR_LOG_SNAPLEN, snaplen);
=20
 	if (nft_jansson_parse_val(root, "qthreshold", NFT_TYPE_U16,
-				  &uval16) < 0)
+				  &uval16, err) < 0)
 		return -1;
=20
 	nft_rule_expr_set_u16(e, NFT_EXPR_LOG_QTHRESHOLD, uval16);
@@ -196,14 +199,16 @@ static int nft_rule_expr_log_json_parse(struct nf=
t_rule_expr *e, json_t *root)
 #endif
 }
=20
-static int nft_rule_expr_log_xml_parse(struct nft_rule_expr *e, mxml_n=
ode_t *tree)
+static int nft_rule_expr_log_xml_parse(struct nft_rule_expr *e,
+				       mxml_node_t *tree,
+				       struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
 	struct nft_expr_log *log =3D nft_expr_data(e);
 	const char *prefix;
=20
 	prefix =3D nft_mxml_str_parse(tree, "prefix", MXML_DESCEND_FIRST,
-				    NFT_XML_MAND);
+				    NFT_XML_MAND, err);
 	if (prefix =3D=3D NULL)
 		return -1;
=20
@@ -211,20 +216,22 @@ static int nft_rule_expr_log_xml_parse(struct nft=
_rule_expr *e, mxml_node_t *tre
 	e->flags |=3D (1 << NFT_EXPR_LOG_PREFIX);
=20
 	if (nft_mxml_num_parse(tree, "group", MXML_DESCEND_FIRST, BASE_DEC,
-			       &log->group, NFT_TYPE_U16, NFT_XML_MAND) !=3D 0)
+			       &log->group, NFT_TYPE_U16, NFT_XML_MAND,
+			       err) !=3D 0)
 		return -1;
=20
 	e->flags |=3D (1 << NFT_EXPR_LOG_GROUP);
=20
 	if (nft_mxml_num_parse(tree, "snaplen", MXML_DESCEND_FIRST, BASE_DEC,
-			       &log->snaplen, NFT_TYPE_U32, NFT_XML_MAND) !=3D 0)
+			       &log->snaplen, NFT_TYPE_U32, NFT_XML_MAND,
+			       err) !=3D 0)
 		return -1;
=20
 	e->flags |=3D (1 << NFT_EXPR_LOG_SNAPLEN);
=20
 	if (nft_mxml_num_parse(tree, "qthreshold", MXML_DESCEND_FIRST,
 			       BASE_DEC, &log->qthreshold,
-			       NFT_TYPE_U16, NFT_XML_MAND) !=3D 0)
+			       NFT_TYPE_U16, NFT_XML_MAND, err) !=3D 0)
 		return -1;
=20
 	e->flags |=3D (1 << NFT_EXPR_LOG_QTHRESHOLD);
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 4e91cfb..b0aadf2 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -143,24 +143,25 @@ nft_rule_expr_lookup_parse(struct nft_rule_expr *=
e, struct nlattr *attr)
 }
=20
 static int
-nft_rule_expr_lookup_json_parse(struct nft_rule_expr *e, json_t *root)
+nft_rule_expr_lookup_json_parse(struct nft_rule_expr *e, json_t *root,
+				struct nft_parse_err *err)
 {
 #ifdef JSON_PARSING
 	const char *set_name;
 	int32_t reg;
=20
-	set_name =3D nft_jansson_parse_str(root, "set");
+	set_name =3D nft_jansson_parse_str(root, "set", err);
 	if (set_name =3D=3D NULL)
 		return -1;
=20
 	nft_rule_expr_set_str(e, NFT_EXPR_LOOKUP_SET, set_name);
=20
-	if (nft_jansson_parse_reg(root, "sreg", NFT_TYPE_U32, &reg) < 0)
+	if (nft_jansson_parse_reg(root, "sreg", NFT_TYPE_U32, &reg, err) < 0)
 		return -1;
=20
 	nft_rule_expr_set_u32(e, NFT_EXPR_LOOKUP_SREG, reg);
=20
-	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &reg) < 0)
+	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &reg, err) < 0)
 		return -1;
=20
 	nft_rule_expr_set_u32(e, NFT_EXPR_LOOKUP_DREG, reg);
@@ -173,7 +174,8 @@ nft_rule_expr_lookup_json_parse(struct nft_rule_exp=
r *e, json_t *root)
 }
=20
 static int
-nft_rule_expr_lookup_xml_parse(struct nft_rule_expr *e, mxml_node_t *t=
ree)
+nft_rule_expr_lookup_xml_parse(struct nft_rule_expr *e, mxml_node_t *t=
ree,
+			       struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
 	struct nft_expr_lookup *lookup =3D nft_expr_data(e);
@@ -181,7 +183,7 @@ nft_rule_expr_lookup_xml_parse(struct nft_rule_expr=
 *e, mxml_node_t *tree)
 	int32_t reg;
=20
 	set_name =3D nft_mxml_str_parse(tree, "set", MXML_DESCEND_FIRST,
-				      NFT_XML_MAND);
+				      NFT_XML_MAND, err);
 	if (set_name =3D=3D NULL)
 		return -1;
=20
@@ -189,14 +191,14 @@ nft_rule_expr_lookup_xml_parse(struct nft_rule_ex=
pr *e, mxml_node_t *tree)
 	lookup->set_name[IFNAMSIZ-1] =3D '\0';
 	e->flags |=3D (1 << NFT_EXPR_LOOKUP_SET);
=20
-	reg =3D nft_mxml_reg_parse(tree, "sreg", MXML_DESCEND);
+	reg =3D nft_mxml_reg_parse(tree, "sreg", MXML_DESCEND, err);
 	if (reg < 0)
 		return -1;
=20
 	lookup->sreg =3D reg;
 	e->flags |=3D (1 << NFT_EXPR_LOOKUP_SREG);
=20
-	reg =3D nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND);
+	reg =3D nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND, err);
 	if (reg < 0)
 		return -1;
=20
diff --git a/src/expr/match.c b/src/expr/match.c
index c7863b8..5487050 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -170,12 +170,13 @@ static int nft_rule_expr_match_parse(struct nft_r=
ule_expr *e, struct nlattr *att
 	return 0;
 }
=20
-static int nft_rule_expr_match_json_parse(struct nft_rule_expr *e, jso=
n_t *root)
+static int nft_rule_expr_match_json_parse(struct nft_rule_expr *e, jso=
n_t *root,
+					  struct nft_parse_err *err)
 {
 #ifdef JSON_PARSING
 	const char *name;
=20
-	name =3D nft_jansson_parse_str(root, "name");
+	name =3D nft_jansson_parse_str(root, "name", err);
 	if (name =3D=3D NULL)
 		return -1;
=20
@@ -189,14 +190,15 @@ static int nft_rule_expr_match_json_parse(struct =
nft_rule_expr *e, json_t *root)
 }
=20
=20
-static int nft_rule_expr_match_xml_parse(struct nft_rule_expr *e, mxml=
_node_t *tree)
+static int nft_rule_expr_match_xml_parse(struct nft_rule_expr *e, mxml=
_node_t *tree,
+					 struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
 	struct nft_expr_match *mt =3D nft_expr_data(e);
 	const char *name;
=20
 	name =3D nft_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST,
-				  NFT_XML_MAND);
+				  NFT_XML_MAND, err);
 	if (name =3D=3D NULL)
 		return -1;
=20
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 88d2908..3c5fd77 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -160,19 +160,20 @@ static inline int str2meta_key(const char *str)
 	return -1;
 }
=20
-static int nft_rule_expr_meta_json_parse(struct nft_rule_expr *e, json=
_t *root)
+static int nft_rule_expr_meta_json_parse(struct nft_rule_expr *e, json=
_t *root,
+					 struct nft_parse_err *err)
 {
 #ifdef JSON_PARSING
 	const char *key_str;
 	uint32_t reg;
 	int key;
=20
-	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &reg) < 0)
+	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &reg, err) < 0)
                 return -1;
=20
 	nft_rule_expr_set_u32(e, NFT_EXPR_META_DREG, reg);
=20
-	key_str =3D nft_jansson_parse_str(root, "key");
+	key_str =3D nft_jansson_parse_str(root, "key", err);
 	if (key_str =3D=3D NULL)
 		return -1;
=20
@@ -190,7 +191,8 @@ static int nft_rule_expr_meta_json_parse(struct nft=
_rule_expr *e, json_t *root)
 }
=20
=20
-static int nft_rule_expr_meta_xml_parse(struct nft_rule_expr *e, mxml_=
node_t *tree)
+static int nft_rule_expr_meta_xml_parse(struct nft_rule_expr *e, mxml_=
node_t *tree,
+					struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
 	struct nft_expr_meta *meta =3D nft_expr_data(e);
@@ -198,7 +200,7 @@ static int nft_rule_expr_meta_xml_parse(struct nft_=
rule_expr *e, mxml_node_t *tr
 	int32_t reg;
 	int key;
=20
-	reg =3D nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND_FIRST);
+	reg =3D nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND_FIRST, err);
 	if (reg < 0)
                 return -1;
=20
@@ -206,7 +208,7 @@ static int nft_rule_expr_meta_xml_parse(struct nft_=
rule_expr *e, mxml_node_t *tr
 	e->flags |=3D (1 << NFT_EXPR_META_DREG);
=20
 	key_str =3D nft_mxml_str_parse(tree, "key", MXML_DESCEND_FIRST,
-				     NFT_XML_MAND);
+				     NFT_XML_MAND, err);
 	if (key_str =3D=3D NULL)
 		return -1;
=20
diff --git a/src/expr/nat.c b/src/expr/nat.c
index 30b02ec..34a977a 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -196,14 +196,15 @@ static inline int nft_str2nat(const char *nat)
 	}
 }
=20
-static int nft_rule_expr_nat_json_parse(struct nft_rule_expr *e, json_=
t *root)
+static int nft_rule_expr_nat_json_parse(struct nft_rule_expr *e, json_=
t *root,
+					struct nft_parse_err *err)
 {
 #ifdef JSON_PARSING
 	const char *nat_type, *family_str;
 	uint32_t reg;
 	int val32;
=20
-	nat_type =3D nft_jansson_parse_str(root, "nat_type");
+	nat_type =3D nft_jansson_parse_str(root, "nat_type", err);
 	if (nat_type =3D=3D NULL)
 		return -1;
=20
@@ -213,7 +214,7 @@ static int nft_rule_expr_nat_json_parse(struct nft_=
rule_expr *e, json_t *root)
=20
 	nft_rule_expr_set_u32(e, NFT_EXPR_NAT_TYPE, val32);
=20
-	family_str =3D nft_jansson_parse_str(root, "family");
+	family_str =3D nft_jansson_parse_str(root, "family", err);
 	if (family_str =3D=3D NULL)
 		return -1;
=20
@@ -224,25 +225,25 @@ static int nft_rule_expr_nat_json_parse(struct nf=
t_rule_expr *e, json_t *root)
 	nft_rule_expr_set_u32(e, NFT_EXPR_NAT_FAMILY, val32);
=20
 	if (nft_jansson_parse_reg(root, "sreg_addr_min", NFT_TYPE_U32,
-				  &reg) < 0)
+				  &reg, err) < 0)
 		return -1;
=20
 	nft_rule_expr_set_u32(e, NFT_EXPR_NAT_REG_ADDR_MIN, reg);
=20
 	if (nft_jansson_parse_reg(root, "sreg_addr_max", NFT_TYPE_U32,
-				  &reg) < 0)
+				  &reg, err) < 0)
 		return -1;
=20
 	nft_rule_expr_set_u32(e, NFT_EXPR_NAT_REG_ADDR_MAX, reg);
=20
 	if (nft_jansson_parse_reg(root, "sreg_proto_min", NFT_TYPE_U32,
-				  &reg) < 0)
+				  &reg, err) < 0)
 		return -1;
=20
 	nft_rule_expr_set_u32(e, NFT_EXPR_NAT_REG_PROTO_MIN, reg);
=20
 	if (nft_jansson_parse_reg(root, "sreg_proto_max", NFT_TYPE_U32,
-				  &reg) < 0)
+				  &reg, err) < 0)
 		return -1;
=20
 	nft_rule_expr_set_u32(e, NFT_EXPR_NAT_REG_PROTO_MAX, reg);
@@ -254,7 +255,8 @@ static int nft_rule_expr_nat_json_parse(struct nft_=
rule_expr *e, json_t *root)
 #endif
 }
=20
-static int nft_rule_expr_nat_xml_parse(struct nft_rule_expr *e, mxml_n=
ode_t *tree)
+static int nft_rule_expr_nat_xml_parse(struct nft_rule_expr *e, mxml_n=
ode_t *tree,
+				       struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
 	struct nft_expr_nat *nat =3D nft_expr_data(e);
@@ -263,7 +265,7 @@ static int nft_rule_expr_nat_xml_parse(struct nft_r=
ule_expr *e, mxml_node_t *tre
 	int family, nat_type_value;
=20
 	nat_type =3D nft_mxml_str_parse(tree, "type", MXML_DESCEND_FIRST,
-				      NFT_XML_MAND);
+				      NFT_XML_MAND, err);
 	if (nat_type =3D=3D NULL)
 		return -1;
=20
@@ -275,7 +277,7 @@ static int nft_rule_expr_nat_xml_parse(struct nft_r=
ule_expr *e, mxml_node_t *tre
 	e->flags |=3D (1 << NFT_EXPR_NAT_TYPE);
=20
 	family =3D nft_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST,
-				       NFT_XML_MAND);
+				       NFT_XML_MAND, err);
 	if (family < 0) {
 		mxmlDelete(tree);
 		return -1;
@@ -284,28 +286,28 @@ static int nft_rule_expr_nat_xml_parse(struct nft=
_rule_expr *e, mxml_node_t *tre
 	nat->family =3D family;
 	e->flags |=3D (1 << NFT_EXPR_NAT_FAMILY);
=20
-	reg =3D nft_mxml_reg_parse(tree, "sreg_addr_min", MXML_DESCEND);
+	reg =3D nft_mxml_reg_parse(tree, "sreg_addr_min", MXML_DESCEND, err);
 	if (reg < 0)
 		return -1;
=20
 	nat->sreg_addr_min =3D reg;
 	e->flags |=3D (1 << NFT_EXPR_NAT_REG_ADDR_MIN);
=20
-	reg =3D nft_mxml_reg_parse(tree, "sreg_addr_max", MXML_DESCEND);
+	reg =3D nft_mxml_reg_parse(tree, "sreg_addr_max", MXML_DESCEND, err);
 	if (reg < 0)
 		return -1;
=20
 	nat->sreg_addr_max =3D reg;
 	e->flags |=3D (1 << NFT_EXPR_NAT_REG_ADDR_MAX);
=20
-	reg =3D nft_mxml_reg_parse(tree, "sreg_proto_min", MXML_DESCEND);
+	reg =3D nft_mxml_reg_parse(tree, "sreg_proto_min", MXML_DESCEND, err)=
;
 	if (reg < 0)
 		return -1;
=20
 	nat->sreg_proto_min =3D reg;
 	e->flags |=3D (1 << NFT_EXPR_NAT_REG_PROTO_MIN);
=20
-	reg =3D nft_mxml_reg_parse(tree, "sreg_proto_max", MXML_DESCEND);
+	reg =3D nft_mxml_reg_parse(tree, "sreg_proto_max", MXML_DESCEND, err)=
;
 	if (reg < 0)
 		return -1;
=20
diff --git a/src/expr/payload.c b/src/expr/payload.c
index fc32ff2..911bb01 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -194,19 +194,20 @@ static inline int nft_str2base(const char *base)
 }
=20
 static int
-nft_rule_expr_payload_json_parse(struct nft_rule_expr *e, json_t *root=
)
+nft_rule_expr_payload_json_parse(struct nft_rule_expr *e, json_t *root=
,
+				 struct nft_parse_err *err)
 {
 #ifdef JSON_PARSING
 	const char *base_str;
 	uint32_t reg, uval32;
 	int base;
=20
-	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &reg) < 0)
+	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &reg, err) < 0)
 		return -1;
=20
 	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_DREG, reg);
=20
-	base_str =3D nft_jansson_parse_str(root, "base");
+	base_str =3D nft_jansson_parse_str(root, "base", err);
 	if (base_str =3D=3D NULL)
 		return -1;
=20
@@ -216,12 +217,13 @@ nft_rule_expr_payload_json_parse(struct nft_rule_=
expr *e, json_t *root)
=20
 	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_BASE, base);
=20
-	if (nft_jansson_parse_val(root, "offset", NFT_TYPE_U32, &uval32) < 0)
+	if (nft_jansson_parse_val(root, "offset", NFT_TYPE_U32, &uval32,
+				  err) < 0)
 		return -1;
=20
 	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_OFFSET, uval32);
=20
-	if (nft_jansson_parse_val(root, "len", NFT_TYPE_U32, &uval32) < 0)
+	if (nft_jansson_parse_val(root, "len", NFT_TYPE_U32, &uval32, err) < =
0)
 		return -1;
=20
 	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_LEN, uval32);
@@ -234,14 +236,15 @@ nft_rule_expr_payload_json_parse(struct nft_rule_=
expr *e, json_t *root)
 }
=20
 static int
-nft_rule_expr_payload_xml_parse(struct nft_rule_expr *e, mxml_node_t *=
tree)
+nft_rule_expr_payload_xml_parse(struct nft_rule_expr *e, mxml_node_t *=
tree,
+				struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
 	struct nft_expr_payload *payload =3D nft_expr_data(e);
 	const char *base_str;
 	int32_t reg, base;
=20
-	reg =3D nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND_FIRST);
+	reg =3D nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND_FIRST, err);
 	if (reg < 0)
 		return -1;
=20
@@ -249,7 +252,7 @@ nft_rule_expr_payload_xml_parse(struct nft_rule_exp=
r *e, mxml_node_t *tree)
 	e->flags |=3D (1 << NFT_EXPR_PAYLOAD_DREG);
=20
 	base_str =3D nft_mxml_str_parse(tree, "base", MXML_DESCEND_FIRST,
-				      NFT_XML_MAND);
+				      NFT_XML_MAND, err);
 	if (base_str =3D=3D NULL)
 		return -1;
=20
@@ -262,13 +265,14 @@ nft_rule_expr_payload_xml_parse(struct nft_rule_e=
xpr *e, mxml_node_t *tree)
=20
 	if (nft_mxml_num_parse(tree, "offset", MXML_DESCEND_FIRST, BASE_DEC,
 			       &payload->offset, NFT_TYPE_U8,
-			       NFT_XML_MAND) !=3D 0)
+			       NFT_XML_MAND, err) !=3D 0)
 		return -1;
=20
 	e->flags |=3D (1 << NFT_EXPR_PAYLOAD_OFFSET);
=20
 	if (nft_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST, BASE_DEC,
-			       &payload->len, NFT_TYPE_U8, NFT_XML_MAND) !=3D 0)
+			       &payload->len, NFT_TYPE_U8,
+			       NFT_XML_MAND, err) !=3D 0)
 		return -1;
=20
 	e->flags |=3D (1 << NFT_EXPR_PAYLOAD_LEN);
diff --git a/src/expr/reject.c b/src/expr/reject.c
index 848f004..c06b070 100644
--- a/src/expr/reject.c
+++ b/src/expr/reject.c
@@ -122,18 +122,19 @@ nft_rule_expr_reject_parse(struct nft_rule_expr *=
e, struct nlattr *attr)
 }
=20
 static int
-nft_rule_expr_reject_json_parse(struct nft_rule_expr *e, json_t *root)
+nft_rule_expr_reject_json_parse(struct nft_rule_expr *e, json_t *root,
+				struct nft_parse_err *err)
 {
 #ifdef JSON_PARSING
 	uint32_t type;
 	uint16_t code;
=20
-	if (nft_jansson_parse_val(root, "type", NFT_TYPE_U32, &type) < 0)
+	if (nft_jansson_parse_val(root, "type", NFT_TYPE_U32, &type, err) < 0=
)
 		return -1;
=20
 	nft_rule_expr_set_u32(e, NFT_EXPR_REJECT_TYPE, type);
=20
-	if (nft_jansson_parse_val(root, "code", NFT_TYPE_U8, &code) < 0)
+	if (nft_jansson_parse_val(root, "code", NFT_TYPE_U8, &code, err) < 0)
 		return -1;
=20
 	nft_rule_expr_set_u8(e, NFT_EXPR_REJECT_CODE, code);
@@ -146,19 +147,22 @@ nft_rule_expr_reject_json_parse(struct nft_rule_e=
xpr *e, json_t *root)
 }
=20
 static int
-nft_rule_expr_reject_xml_parse(struct nft_rule_expr *e, mxml_node_t *t=
ree)
+nft_rule_expr_reject_xml_parse(struct nft_rule_expr *e, mxml_node_t *t=
ree,
+			       struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
 	struct nft_expr_reject *reject =3D nft_expr_data(e);
=20
 	if (nft_mxml_num_parse(tree, "type", MXML_DESCEND_FIRST, BASE_DEC,
-			       &reject->type, NFT_TYPE_U32, NFT_XML_MAND) !=3D 0)
+			       &reject->type, NFT_TYPE_U32, NFT_XML_MAND,
+			       err) !=3D 0)
 		return -1;
=20
 	e->flags |=3D (1 << NFT_EXPR_REJECT_TYPE);
=20
 	if (nft_mxml_num_parse(tree, "code", MXML_DESCEND_FIRST, BASE_DEC,
-			       &reject->icmp_code, NFT_TYPE_U8, NFT_XML_MAND) !=3D 0)
+			       &reject->icmp_code, NFT_TYPE_U8, NFT_XML_MAND,
+			       err) !=3D 0)
 		return -1;
=20
 	e->flags |=3D (1 << NFT_EXPR_REJECT_CODE);
diff --git a/src/expr/target.c b/src/expr/target.c
index 23dff3a..071fb07 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -171,12 +171,13 @@ static int nft_rule_expr_target_parse(struct nft_=
rule_expr *e, struct nlattr *at
 }
=20
 static int
-nft_rule_expr_target_json_parse(struct nft_rule_expr *e, json_t *root)
+nft_rule_expr_target_json_parse(struct nft_rule_expr *e, json_t *root,
+				struct nft_parse_err *err)
 {
 #ifdef JSON_PARSING
 	const char *name;
=20
-	name =3D nft_jansson_parse_str(root, "name");
+	name =3D nft_jansson_parse_str(root, "name", err);
 	if (name =3D=3D NULL)
 		return -1;
=20
@@ -190,14 +191,15 @@ nft_rule_expr_target_json_parse(struct nft_rule_e=
xpr *e, json_t *root)
 }
=20
 static int
-nft_rule_expr_target_xml_parse(struct nft_rule_expr *e, mxml_node_t *t=
ree)
+nft_rule_expr_target_xml_parse(struct nft_rule_expr *e, mxml_node_t *t=
ree,
+			       struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
 	struct nft_expr_target *tg =3D nft_expr_data(e);
 	const char *name;
=20
 	name =3D nft_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST,
-				  NFT_XML_MAND);
+				  NFT_XML_MAND, err);
 	if (name =3D=3D NULL)
 		return -1;
=20
diff --git a/src/expr_ops.h b/src/expr_ops.h
index 26e0b82..b06f575 100644
--- a/src/expr_ops.h
+++ b/src/expr_ops.h
@@ -29,8 +29,10 @@ struct expr_ops {
 	int 	(*parse)(struct nft_rule_expr *e, struct nlattr *attr);
 	void	(*build)(struct nlmsghdr *nlh, struct nft_rule_expr *e);
 	int	(*snprintf)(char *buf, size_t len, uint32_t type, uint32_t flags,=
 struct nft_rule_expr *e);
-	int	(*xml_parse)(struct nft_rule_expr *e, mxml_node_t *tree);
-	int	(*json_parse)(struct nft_rule_expr *e, json_t *data);
+	int	(*xml_parse)(struct nft_rule_expr *e, mxml_node_t *tree,
+			     struct nft_parse_err *err);
+	int	(*json_parse)(struct nft_rule_expr *e, json_t *data,
+			      struct nft_parse_err *err);
 };
=20
 void nft_expr_ops_register(struct expr_ops *ops);
diff --git a/src/internal.h b/src/internal.h
index f975ad1..9ef505f 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -13,6 +13,7 @@
=20
 #include <stdint.h>
 #include <stdbool.h>
+#include <libnftables/common.h>
=20
 #define BASE_DEC 10
 #define BASE_HEX 16
@@ -30,59 +31,94 @@ enum nft_type {
 	NFT_TYPE_S64,
 };
=20
+struct nft_parse_err {
+	int line;
+	int column;
+	int error;
+	const char *node_name;
+};
+
 #ifdef XML_PARSING
 #include <mxml.h>
 #define NFT_XML_MAND 0
 #define NFT_XML_OPT (1 << 0)
-mxml_node_t *nft_mxml_build_tree(const char *xml, const char *treename=
);
-struct nft_rule_expr *nft_mxml_expr_parse(mxml_node_t *node);
-int nft_mxml_reg_parse(mxml_node_t *tree, const char *reg_name, uint32=
_t flags);
+mxml_node_t *nft_mxml_build_tree(const char *xml, const char *treename=
,
+				 struct nft_parse_err *err);
+struct nft_rule_expr *nft_mxml_expr_parse(mxml_node_t *node,
+					  struct nft_parse_err *err);
+int nft_mxml_reg_parse(mxml_node_t *tree, const char *reg_name, uint32=
_t flags,
+		       struct nft_parse_err *err);
 union nft_data_reg;
-int nft_mxml_data_reg_parse(mxml_node_t *tree, const char *node_name, =
union nft_data_reg *data_reg, uint16_t flags);
-int nft_mxml_num_parse(mxml_node_t *tree, const char *node_name, uint3=
2_t mxml_flags, int base, void *number, enum nft_type type, uint16_t fl=
ags);
-const char *nft_mxml_str_parse(mxml_node_t *tree, const char *node_nam=
e, uint32_t mxml_flags, uint16_t flags);
-int nft_mxml_family_parse(mxml_node_t *tree, const char *node_name, ui=
nt32_t mxml_flags, uint16_t flags);
+int nft_mxml_data_reg_parse(mxml_node_t *tree, const char *node_name,
+			    union nft_data_reg *data_reg, uint16_t flags,
+			    struct nft_parse_err *err);
+int nft_mxml_num_parse(mxml_node_t *tree, const char *node_name,
+		       uint32_t mxml_flags, int base, void *number,
+		       enum nft_type type, uint16_t flags,
+		       struct nft_parse_err *err);
+const char *nft_mxml_str_parse(mxml_node_t *tree, const char *node_nam=
e,
+			       uint32_t mxml_flags, uint16_t flags,
+			       struct nft_parse_err *err);
+int nft_mxml_family_parse(mxml_node_t *tree, const char *node_name,
+			  uint32_t mxml_flags, uint16_t flags,
+			  struct nft_parse_err *err);
=20
 struct nft_set_elem;
-int nft_mxml_set_elem_parse(mxml_node_t *node, struct nft_set_elem *e)=
;
+int nft_mxml_set_elem_parse(mxml_node_t *node, struct nft_set_elem *e,
+			    struct nft_parse_err *err);
 struct nft_table;
-int nft_mxml_table_parse(mxml_node_t *tree, struct nft_table *t);
+int nft_mxml_table_parse(mxml_node_t *tree, struct nft_table *t,
+			 struct nft_parse_err *err);
 struct nft_chain;
-int nft_mxml_chain_parse(mxml_node_t *tree, struct nft_chain *c);
+int nft_mxml_chain_parse(mxml_node_t *tree, struct nft_chain *c,
+			 struct nft_parse_err *err);
 struct nft_rule;
-int nft_mxml_rule_parse(mxml_node_t *tree, struct nft_rule *r);
+int nft_mxml_rule_parse(mxml_node_t *tree, struct nft_rule *r,
+			struct nft_parse_err *err);
 struct nft_set;
-int nft_mxml_set_parse(mxml_node_t *tree, struct nft_set *s);
+int nft_mxml_set_parse(mxml_node_t *tree, struct nft_set *s,
+		       struct nft_parse_err *err);
 #endif
=20
 #ifdef JSON_PARSING
 #include <jansson.h>
+
 int nft_jansson_parse_val(json_t *root, const char *node_name, int typ=
e,
-			  void *out);
-const char *nft_jansson_parse_str(json_t *root, const char *node_name)=
;
+			  void *out, struct nft_parse_err *err);
+const char *nft_jansson_parse_str(json_t *root, const char *node_name,
+				  struct nft_parse_err *err);
 bool nft_jansson_node_exist(json_t *root, const char *node_name);
-json_t *nft_jansson_create_root(const char *json, json_error_t *err);
-json_t *nft_jansson_get_node(json_t *root, const char *node_name);
+json_t *nft_jansson_create_root(const char *json, json_error_t *error,
+				struct nft_parse_err *err);
+json_t *nft_jansson_get_node(json_t *root, const char *node_name,
+			     struct nft_parse_err *err);
 void nft_jansson_free_root(json_t *root);
-int nft_jansson_parse_family(json_t *root, void *out);
-int nft_jansson_str2num(json_t *root, const char *node_name, int base,
-			void *out, enum nft_type type);
+int nft_jansson_parse_family(json_t *root, void *out, struct nft_parse=
_err *err);
+int nft_jansson_str2num(json_t *root, const char *node_name, int base,=
 void *out,
+			enum nft_type type, struct nft_parse_err *err);
 int nft_jansson_parse_reg(json_t *root, const char *node_name, int typ=
e,
-			  void *out);
-struct nft_rule_expr *nft_jansson_expr_parse(json_t *root);
+			  void *out, struct nft_parse_err *err);
+struct nft_rule_expr *nft_jansson_expr_parse(json_t *root,
+					     struct nft_parse_err *err);
 union nft_data_reg;
 int nft_jansson_data_reg_parse(json_t *root, const char *node_name,
-			       union nft_data_reg *data_reg);
+			       union nft_data_reg *data_reg,
+			       struct nft_parse_err *err);
 struct nft_set_elem;
-int nft_set_elem_json_parse(struct nft_set_elem *e, json_t *root);
+int nft_set_elem_json_parse(struct nft_set_elem *e, json_t *root,
+			    struct nft_parse_err *err);
 struct nft_table;
-int nft_jansson_parse_table(struct nft_table *t, json_t *tree);
+int nft_jansson_parse_table(struct nft_table *t, json_t *tree,
+			    struct nft_parse_err *err);
 struct nft_chain;
-int nft_jansson_parse_chain(struct nft_chain *c, json_t *tree);
+int nft_jansson_parse_chain(struct nft_chain *c, json_t *tree,
+			    struct nft_parse_err *err);
 struct nft_rule;
-int nft_jansson_parse_rule(struct nft_rule *r, json_t *tree);
+int nft_jansson_parse_rule(struct nft_rule *r, json_t *tree,
+			   struct nft_parse_err *err);
 struct nft_set;
-int nft_jansson_parse_set(struct nft_set *s, json_t *tree);
+int nft_jansson_parse_set(struct nft_set *s, json_t *tree,
+			  struct nft_parse_err *err);
 #endif
=20
 const char *nft_family2str(uint32_t family);
diff --git a/src/jansson.c b/src/jansson.c
index 539f9ab..eff0802 100644
--- a/src/jansson.c
+++ b/src/jansson.c
@@ -24,17 +24,21 @@
 #ifdef JSON_PARSING
=20
 static int nft_jansson_load_int_node(json_t *root, const char *node_na=
me,
-				      json_int_t *val)
+				      json_int_t *val, struct nft_parse_err *err)
 {
 	json_t *node;
=20
 	node =3D json_object_get(root, node_name);
 	if (node =3D=3D NULL) {
+		err->error =3D NFT_EMISSINGNODE;
+		err->node_name =3D node_name;
 		errno =3D EINVAL;
 		return -1;
 	}
=20
 	if (!json_is_integer(node)) {
+		err->error =3D NFT_EBADTYPE;
+		err->node_name =3D node_name;
 		errno =3D ERANGE;
 		return -1;
 	}
@@ -43,27 +47,35 @@ static int nft_jansson_load_int_node(json_t *root, =
const char *node_name,
 	return 0;
 }
=20
-const char *nft_jansson_parse_str(json_t *root, const char *node_name)
+const char *nft_jansson_parse_str(json_t *root, const char *node_name,
+				  struct nft_parse_err *err)
 {
 	json_t *node;
 	const char *val;
=20
 	node =3D json_object_get(root, node_name);
 	if (node =3D=3D NULL) {
+		err->error =3D NFT_EMISSINGNODE;
+		err->node_name =3D node_name;
 		errno =3D EINVAL;
 		return NULL;
 	}
+
 	val =3D json_string_value(node);
+	if (val =3D=3D NULL) {
+		err->error =3D NFT_EBADTYPE;
+		err->node_name =3D node_name;
+	}
=20
 	return val;
 }
=20
 int nft_jansson_parse_val(json_t *root, const char *node_name, int typ=
e,
-			  void *out)
+			  void *out, struct nft_parse_err *err)
 {
 	json_int_t val;
=20
-	if (nft_jansson_load_int_node(root, node_name, &val) =3D=3D -1)
+	if (nft_jansson_load_int_node(root, node_name, &val, err) =3D=3D -1)
 		return -1;
=20
 	if (nft_get_value(type, &val, out) =3D=3D -1)
@@ -77,12 +89,17 @@ bool nft_jansson_node_exist(json_t *root, const cha=
r *node_name)
 	return json_object_get(root, node_name) !=3D NULL;
 }
=20
-json_t *nft_jansson_create_root(const char *json, json_error_t *err)
+json_t *nft_jansson_create_root(const char *json, json_error_t *error,
+				struct nft_parse_err *err)
 {
 	json_t *root;
=20
-	root =3D json_loadb(json, strlen(json), 0, err);
+	root =3D json_loadb(json, strlen(json), 0, error);
 	if (root =3D=3D NULL) {
+		err->error =3D NFT_EBADINPUT;
+		err->line =3D error->line;
+		err->column =3D error->column;
+		err->node_name =3D error->source;
 		errno =3D EINVAL;
 		return NULL;
 	}
@@ -90,12 +107,15 @@ json_t *nft_jansson_create_root(const char *json, =
json_error_t *err)
 	return root;
 }
=20
-json_t *nft_jansson_get_node(json_t *root, const char *node_name)
+json_t *nft_jansson_get_node(json_t *root, const char *node_name,
+			     struct nft_parse_err *err)
 {
 	json_t *node;
=20
 	node =3D json_object_get(root, node_name);
 	if (node =3D=3D NULL) {
+		err->error =3D NFT_EMISSINGNODE;
+		err->node_name =3D node_name;
 		errno =3D EINVAL;
 		return NULL;
 	}
@@ -108,17 +128,18 @@ void nft_jansson_free_root(json_t *root)
 	json_decref(root);
 }
=20
-int nft_jansson_parse_family(json_t *root, void *out)
+int nft_jansson_parse_family(json_t *root, void *out, struct nft_parse=
_err *err)
 {
 	const char *str;
 	int family;
=20
-	str =3D nft_jansson_parse_str(root, "family");
+	str =3D nft_jansson_parse_str(root, "family", err);
 	if (str =3D=3D NULL)
 		return -1;
=20
 	family =3D nft_str2family(str);
 	if (family < 0) {
+		err->node_name =3D "family";
 		errno =3D EINVAL;
 		return -1;
 	}
@@ -128,9 +149,9 @@ int nft_jansson_parse_family(json_t *root, void *ou=
t)
 }
=20
 int nft_jansson_parse_reg(json_t *root, const char *node_name, int typ=
e,
-			  void *out)
+			  void *out, struct nft_parse_err *err)
 {
-	if (nft_jansson_parse_val(root, node_name, type, out) < 0)
+	if (nft_jansson_parse_val(root, node_name, type, out, err) < 0)
 		return -1;
=20
 	if (*((uint32_t *)out) > NFT_REG_MAX){
@@ -142,38 +163,42 @@ int nft_jansson_parse_reg(json_t *root, const cha=
r *node_name, int type,
 }
=20
 int nft_jansson_str2num(json_t *root, const char *node_name, int base,
-			void *out, enum nft_type type)
+			void *out, enum nft_type type, struct nft_parse_err *err)
 {
 	const char *str;
=20
-	str =3D nft_jansson_parse_str(root, node_name);
+	str =3D nft_jansson_parse_str(root, node_name, err);
 	if (str =3D=3D NULL)
 		return -1;
=20
 	return nft_strtoi(str, base, out, type);
 }
=20
-struct nft_rule_expr *nft_jansson_expr_parse(json_t *root)
+struct nft_rule_expr *nft_jansson_expr_parse(json_t *root,
+					     struct nft_parse_err *err)
 {
 	struct nft_rule_expr *e;
 	const char *type;
 	int ret;
=20
-	type =3D nft_jansson_parse_str(root, "type");
+	type =3D nft_jansson_parse_str(root, "type", err);
 	if (type =3D=3D NULL)
 		return NULL;
=20
 	e =3D nft_rule_expr_alloc(type);
-	if (e =3D=3D NULL)
-		return NULL;;
+	if (e =3D=3D NULL) {
+		err->node_name =3D "type";
+		return NULL;
+	}
=20
-	ret =3D e->ops->json_parse(e, root);
+	ret =3D e->ops->json_parse(e, root, err);
=20
 	return ret < 0 ? NULL : e;
 }
=20
 int nft_jansson_data_reg_parse(json_t *root, const char *node_name,
-			       union nft_data_reg *data_reg)
+			       union nft_data_reg *data_reg,
+			       struct nft_parse_err *err)
 {
 	json_t *data;
 	const char *type;
@@ -181,24 +206,27 @@ int nft_jansson_data_reg_parse(json_t *root, cons=
t char *node_name,
=20
 	data =3D json_object_get(root, node_name);
 	if (data =3D=3D NULL) {
+		err->error =3D NFT_EMISSINGNODE;
+		err->node_name =3D node_name;
 		errno =3D EINVAL;
 		return -1;
 	}
=20
 	data =3D json_object_get(data, "data_reg");
 	if (data =3D=3D NULL) {
+		err->error =3D NFT_EMISSINGNODE;
+		err->node_name =3D "data_reg";
 		errno =3D EINVAL;
 		return -1;
 	}
=20
-	ret =3D nft_data_reg_json_parse(data_reg, data);
-
+	ret =3D nft_data_reg_json_parse(data_reg, data, err);
 	if (ret < 0) {
 		errno =3D EINVAL;
 		return -1;
 	}
=20
-	type =3D nft_jansson_parse_str(data, "type");
+	type =3D nft_jansson_parse_str(data, "type", err);
 	if (type =3D=3D NULL)
 		return -1;
=20
@@ -209,29 +237,32 @@ int nft_jansson_data_reg_parse(json_t *root, cons=
t char *node_name,
 	else if (strcmp(type, "chain") =3D=3D 0)
 		return DATA_CHAIN;
 	else {
+		err->error =3D NFT_EBADTYPE;
+		err->node_name =3D "type";
 		errno =3D EINVAL;
 		return -1;
 	}
 }
=20
-int nft_set_elem_json_parse(struct nft_set_elem *e, json_t *root)
+int nft_set_elem_json_parse(struct nft_set_elem *e, json_t *root,
+			    struct nft_parse_err *err)
 {
 	uint32_t uval32;
 	int set_elem_data;
=20
-	if (nft_jansson_parse_val(root, "flags", NFT_TYPE_U32, &uval32) < 0)
+	if (nft_jansson_parse_val(root, "flags", NFT_TYPE_U32, &uval32, err) =
< 0)
 		return -1;
=20
 	nft_set_elem_attr_set_u32(e, NFT_SET_ELEM_ATTR_FLAGS, uval32);
=20
-	if (nft_jansson_data_reg_parse(root, "key", &e->key) !=3D DATA_VALUE)
+	if (nft_jansson_data_reg_parse(root, "key", &e->key, err) !=3D DATA_V=
ALUE)
 		return -1;
=20
 	e->flags |=3D (1 << NFT_SET_ELEM_ATTR_KEY);
=20
 	if (nft_jansson_node_exist(root, "data")) {
 		set_elem_data =3D nft_jansson_data_reg_parse(root, "data",
-							   &e->data);
+							   &e->data, err);
 		switch (set_elem_data) {
 		case DATA_VALUE:
 			e->flags |=3D (1 << NFT_SET_ELEM_ATTR_DATA);
diff --git a/src/libnftables.map b/src/libnftables.map
index 7dc9aee..fd01b4d 100644
--- a/src/libnftables.map
+++ b/src/libnftables.map
@@ -1,5 +1,10 @@
 LIBNFTABLES_1.0 {
 global:
+
+  nft_err_alloc;
+  nft_err_free;
+  nft_err_print;
+
   nft_table_alloc;
   nft_table_free;
   nft_table_attr_is_set;
diff --git a/src/mxml.c b/src/mxml.c
index 82156b7..94ad68f 100644
--- a/src/mxml.c
+++ b/src/mxml.c
@@ -22,13 +22,16 @@
 #include <libnftables/set.h>
=20
 #ifdef XML_PARSING
-mxml_node_t *nft_mxml_build_tree(const char *xml, const char *treename=
)
+mxml_node_t *nft_mxml_build_tree(const char *xml, const char *treename=
,
+				 struct nft_parse_err *err)
 {
 	mxml_node_t *tree;
=20
 	tree =3D mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
-	if (tree =3D=3D NULL)
+	if (tree =3D=3D NULL) {
+		err->error =3D NFT_EBADINPUT;
 		goto err;
+	}
=20
 	if (strcmp(tree->value.opaque, treename) =3D=3D 0)
 		return tree;
@@ -39,7 +42,8 @@ err:
 	return NULL;
 }
=20
-struct nft_rule_expr *nft_mxml_expr_parse(mxml_node_t *node)
+struct nft_rule_expr *nft_mxml_expr_parse(mxml_node_t *node,
+					  struct nft_parse_err *err)
 {
 	mxml_node_t *tree;
 	struct nft_rule_expr *e;
@@ -48,8 +52,11 @@ struct nft_rule_expr *nft_mxml_expr_parse(mxml_node_=
t *node)
 	int ret;
=20
 	expr_name =3D mxmlElementGetAttr(node, "type");
-	if (expr_name =3D=3D NULL)
+	if (expr_name =3D=3D NULL) {
+		err->node_name =3D "type";
+		err->error =3D NFT_EMISSINGNODE;
 		goto err;
+	}
=20
 	e =3D nft_rule_expr_alloc(expr_name);
 	if (e =3D=3D NULL)
@@ -65,7 +72,7 @@ struct nft_rule_expr *nft_mxml_expr_parse(mxml_node_t=
 *node)
 	if (tree =3D=3D NULL)
 		goto err_expr;
=20
-	ret =3D e->ops->xml_parse(e, tree);
+	ret =3D e->ops->xml_parse(e, tree, err);
 	mxmlDelete(tree);
=20
 	return ret < 0 ? NULL : e;
@@ -77,20 +84,24 @@ err:
 	return NULL;
 }
=20
-int nft_mxml_reg_parse(mxml_node_t *tree, const char *reg_name, uint32=
_t flags)
+int nft_mxml_reg_parse(mxml_node_t *tree, const char *reg_name, uint32=
_t flags,
+		       struct nft_parse_err *err)
 {
 	mxml_node_t *node;
 	uint64_t val;
=20
 	node =3D mxmlFindElement(tree, tree, reg_name, NULL, NULL, flags);
 	if (node =3D=3D NULL) {
+		err->error =3D NFT_EMISSINGNODE;
 		errno =3D EINVAL;
 		goto err;
 	}
=20
 	if (nft_strtoi(node->child->value.opaque, BASE_DEC, &val,
-		       NFT_TYPE_U64) !=3D 0)
+		       NFT_TYPE_U64) !=3D 0) {
+		err->error =3D NFT_EBADTYPE;
 		goto err;
+	}
=20
 	if (val > NFT_REG_MAX) {
 		errno =3D ERANGE;
@@ -98,73 +109,101 @@ int nft_mxml_reg_parse(mxml_node_t *tree, const c=
har *reg_name, uint32_t flags)
 	}
 	return val;
 err:
+	err->node_name =3D reg_name;
 	return -1;
 }
=20
 int nft_mxml_data_reg_parse(mxml_node_t *tree, const char *node_name,
-			    union nft_data_reg *data_reg, uint16_t flags)
+			    union nft_data_reg *data_reg, uint16_t flags,
+			    struct nft_parse_err *err)
 {
 	mxml_node_t *node;
=20
 	node =3D mxmlFindElement(tree, tree, node_name, NULL, NULL,
 			       MXML_DESCEND_FIRST);
 	if (node =3D=3D NULL || node->child =3D=3D NULL) {
-		if (!(flags & NFT_XML_OPT))
+		if (!(flags & NFT_XML_OPT)) {
+			err->error =3D NFT_EMISSINGNODE;
+			err->node_name =3D node_name;
 			errno =3D EINVAL;
+		}
=20
 		return DATA_NONE;
 	}
=20
-	return nft_data_reg_xml_parse(data_reg, node);
+	return nft_data_reg_xml_parse(data_reg, node, err);
 }
=20
 int
 nft_mxml_num_parse(mxml_node_t *tree, const char *node_name,
 		   uint32_t mxml_flags, int base, void *number,
-		   enum nft_type type, uint16_t flags)
+		   enum nft_type type, uint16_t flags,
+		   struct nft_parse_err *err)
 {
 	mxml_node_t *node =3D NULL;
+	int ret;
=20
 	node =3D mxmlFindElement(tree, tree, node_name, NULL, NULL, mxml_flag=
s);
 	if (node =3D=3D NULL || node->child =3D=3D NULL) {
-		if (!(flags & NFT_XML_OPT))
+		if (!(flags & NFT_XML_OPT)) {
 			errno =3D EINVAL;
-
+			err->node_name =3D node_name;
+			err->error =3D NFT_EMISSINGNODE;
+		}
 		return -1;
 	}
-	return nft_strtoi(node->child->value.opaque, base, number, type);
+
+	ret =3D nft_strtoi(node->child->value.opaque, base, number, type);
+
+	if (ret !=3D 0) {
+		err->error =3D NFT_EBADTYPE;
+		err->node_name =3D node_name;
+	}
+	return ret;
 }
=20
 const char *nft_mxml_str_parse(mxml_node_t *tree, const char *node_nam=
e,
-			       uint32_t mxml_flags, uint16_t flags)
+			       uint32_t mxml_flags, uint16_t flags,
+			       struct nft_parse_err *err)
 {
 	mxml_node_t *node;
+	const char *ret;
=20
 	node =3D mxmlFindElement(tree, tree, node_name, NULL, NULL, mxml_flag=
s);
 	if (node =3D=3D NULL || node->child =3D=3D NULL) {
-		if (!(flags & NFT_XML_OPT))
+		if (!(flags & NFT_XML_OPT)) {
 			errno =3D EINVAL;
-
+			err->node_name =3D node_name;
+			err->error =3D NFT_EMISSINGNODE;
+		}
 		return NULL;
 	}
=20
-	return node->child->value.opaque;
+	ret =3D node->child->value.opaque;
+	if (ret =3D=3D NULL) {
+		err->node_name =3D node_name;
+		err->error =3D NFT_EBADTYPE;
+	}
+	return ret;
 }
=20
 int nft_mxml_family_parse(mxml_node_t *tree, const char *node_name,
-			  uint32_t mxml_flags, uint16_t flags)
+			  uint32_t mxml_flags, uint16_t flags,
+			  struct nft_parse_err *err)
 {
 	const char *family_str;
 	int family;
=20
 	family_str =3D nft_mxml_str_parse(tree, node_name, mxml_flags,
-					flags);
+					flags, err);
 	if (family_str =3D=3D NULL)
 		return -1;
=20
 	family =3D nft_str2family(family_str);
-	if (family < 0)
+	if (family < 0) {
+		err->node_name =3D node_name;
 		errno =3D EAFNOSUPPORT;
+	}
=20
 	return family;
 }
diff --git a/src/rule.c b/src/rule.c
index 280350a..4800a76 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -442,7 +442,8 @@ int nft_rule_nlmsg_parse(const struct nlmsghdr *nlh=
, struct nft_rule *r)
 EXPORT_SYMBOL(nft_rule_nlmsg_parse);
=20
 #ifdef JSON_PARSING
-int nft_jansson_parse_rule(struct nft_rule *r, json_t *tree)
+int nft_jansson_parse_rule(struct nft_rule *r, json_t *tree,
+			   struct nft_parse_err *err)
 {
 	json_t *root, *array;
 	struct nft_rule_expr *e;
@@ -451,28 +452,29 @@ int nft_jansson_parse_rule(struct nft_rule *r, js=
on_t *tree)
 	uint32_t uval32;
 	int i, family;
=20
-	root =3D nft_jansson_get_node(tree, "rule");
+	root =3D nft_jansson_get_node(tree, "rule", err);
 	if (root =3D=3D NULL)
 		return -1;
=20
-	if (nft_jansson_parse_family(root, &family) !=3D 0)
+	if (nft_jansson_parse_family(root, &family, err) !=3D 0)
 		goto err;
=20
 	nft_rule_attr_set_u32(r, NFT_RULE_ATTR_FAMILY, family);
=20
-	str =3D nft_jansson_parse_str(root, "table");
+	str =3D nft_jansson_parse_str(root, "table", err);
 	if (str =3D=3D NULL)
 		goto err;
=20
 	nft_rule_attr_set_str(r, NFT_RULE_ATTR_TABLE, str);
=20
-	str =3D nft_jansson_parse_str(root, "chain");
+	str =3D nft_jansson_parse_str(root, "chain", err);
 	if (str =3D=3D NULL)
 		goto err;
=20
 	nft_rule_attr_set_str(r, NFT_RULE_ATTR_CHAIN, str);
=20
-	if (nft_jansson_parse_val(root, "handle", NFT_TYPE_U64, &uval64) < 0)
+	if (nft_jansson_parse_val(root, "handle", NFT_TYPE_U64, &uval64,
+				  err) < 0)
 		goto err;
=20
 	nft_rule_attr_set_u64(r, NFT_RULE_ATTR_HANDLE, uval64);
@@ -480,13 +482,13 @@ int nft_jansson_parse_rule(struct nft_rule *r, js=
on_t *tree)
 	if (nft_jansson_node_exist(root, "compat_proto") ||
 	    nft_jansson_node_exist(root, "compat_flags")) {
 		if (nft_jansson_parse_val(root, "compat_proto", NFT_TYPE_U32,
-					  &uval32) < 0)
+					  &uval32, err) < 0)
 			goto err;
=20
 		nft_rule_attr_set_u32(r, NFT_RULE_ATTR_COMPAT_PROTO, uval32);
=20
 		if (nft_jansson_parse_val(root, "compat_flags", NFT_TYPE_U32,
-					  &uval32) < 0)
+					  &uval32, err) < 0)
 			goto err;
=20
 		nft_rule_attr_set_u32(r, NFT_RULE_ATTR_COMPAT_FLAGS, uval32);
@@ -494,19 +496,22 @@ int nft_jansson_parse_rule(struct nft_rule *r, js=
on_t *tree)
=20
 	if (nft_jansson_node_exist(root, "position")) {
 		if (nft_jansson_parse_val(root, "position", NFT_TYPE_U64,
-					  &uval64) < 0)
+					  &uval64, err) < 0)
 			goto err;
=20
 		nft_rule_attr_set_u64(r, NFT_RULE_ATTR_POSITION, uval64);
 	}
=20
 	array =3D json_object_get(root, "expr");
-	if (array =3D=3D NULL)
+	if (array =3D=3D NULL) {
+		err->error =3D NFT_EMISSINGNODE;
+		err->node_name =3D "expr";
 		goto err;
+	}
=20
 	for (i =3D 0; i < json_array_size(array); ++i) {
=20
-		e =3D nft_jansson_expr_parse(json_array_get(array, i));
+		e =3D nft_jansson_expr_parse(json_array_get(array, i), err);
 		if (e =3D=3D NULL)
 			goto err;
=20
@@ -521,17 +526,18 @@ err:
 }
 #endif
=20
-static int nft_rule_json_parse(struct nft_rule *r, const char *json)
+static int nft_rule_json_parse(struct nft_rule *r, const char *json,
+			       struct nft_parse_err *err)
 {
 #ifdef JSON_PARSING
 	json_t *tree;
 	json_error_t error;
=20
-	tree =3D nft_jansson_create_root(json, &error);
+	tree =3D nft_jansson_create_root(json, &error, err);
 	if (tree =3D=3D NULL)
 		return -1;
=20
-	return nft_jansson_parse_rule(r, tree);
+	return nft_jansson_parse_rule(r, tree, err);
 #else
 	errno =3D EOPNOTSUPP;
 	return -1;
@@ -539,7 +545,8 @@ static int nft_rule_json_parse(struct nft_rule *r, =
const char *json)
 }
=20
 #ifdef XML_PARSING
-int nft_mxml_rule_parse(mxml_node_t *tree, struct nft_rule *r)
+int nft_mxml_rule_parse(mxml_node_t *tree, struct nft_rule *r,
+			struct nft_parse_err *err)
 {
 	mxml_node_t *node;
 	struct nft_rule_expr *e;
@@ -547,7 +554,7 @@ int nft_mxml_rule_parse(mxml_node_t *tree, struct n=
ft_rule *r)
 	int family;
=20
 	family =3D nft_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST,
-				       NFT_XML_MAND);
+				       NFT_XML_MAND, err);
 	if (family < 0)
 		return -1;
=20
@@ -555,7 +562,7 @@ int nft_mxml_rule_parse(mxml_node_t *tree, struct n=
ft_rule *r)
 	r->flags |=3D (1 << NFT_RULE_ATTR_FAMILY);
=20
 	table =3D nft_mxml_str_parse(tree, "table", MXML_DESCEND_FIRST,
-				   NFT_XML_MAND);
+				   NFT_XML_MAND, err);
 	if (table =3D=3D NULL)
 		return -1;
=20
@@ -566,7 +573,7 @@ int nft_mxml_rule_parse(mxml_node_t *tree, struct n=
ft_rule *r)
 	r->flags |=3D (1 << NFT_RULE_ATTR_TABLE);
=20
 	chain =3D nft_mxml_str_parse(tree, "chain", MXML_DESCEND_FIRST,
-				   NFT_XML_MAND);
+				   NFT_XML_MAND, err);
 	if (chain =3D=3D NULL)
 		return -1;
=20
@@ -577,19 +584,19 @@ int nft_mxml_rule_parse(mxml_node_t *tree, struct=
 nft_rule *r)
 	r->flags |=3D (1 << NFT_RULE_ATTR_CHAIN);
=20
 	if (nft_mxml_num_parse(tree, "handle", MXML_DESCEND_FIRST, BASE_DEC,
-			       &r->handle, NFT_TYPE_U64, NFT_XML_MAND) !=3D 0)
+			       &r->handle, NFT_TYPE_U64, NFT_XML_MAND, err) !=3D 0)
 		return -1;
=20
 	r->flags |=3D (1 << NFT_RULE_ATTR_HANDLE);
=20
 	if (nft_mxml_num_parse(tree, "compat_proto", MXML_DESCEND_FIRST,
 			       BASE_DEC, &r->compat.proto, NFT_TYPE_U32,
-			       NFT_XML_OPT) >=3D 0)
+			       NFT_XML_OPT, err) >=3D 0)
 		r->flags |=3D (1 << NFT_RULE_ATTR_COMPAT_PROTO);
=20
 	if (nft_mxml_num_parse(tree, "compat_flags", MXML_DESCEND_FIRST,
 			       BASE_DEC, &r->compat.flags, NFT_TYPE_U32,
-			       NFT_XML_OPT) >=3D 0)
+			       NFT_XML_OPT, err) >=3D 0)
 		r->flags |=3D (1 << NFT_RULE_ATTR_COMPAT_FLAGS);
=20
 	if (nft_rule_attr_is_set(r, NFT_RULE_ATTR_COMPAT_PROTO) !=3D
@@ -600,7 +607,7 @@ int nft_mxml_rule_parse(mxml_node_t *tree, struct n=
ft_rule *r)
=20
 	if (nft_mxml_num_parse(tree, "position", MXML_DESCEND_FIRST,
 			       BASE_DEC, &r->position, NFT_TYPE_U64,
-			       NFT_XML_OPT) >=3D 0)
+			       NFT_XML_OPT, err) >=3D 0)
 		r->flags |=3D (1 << NFT_RULE_ATTR_POSITION);
=20
 	/* Iterating over <expr> */
@@ -609,7 +616,7 @@ int nft_mxml_rule_parse(mxml_node_t *tree, struct n=
ft_rule *r)
 		node !=3D NULL;
 		node =3D mxmlFindElement(node, tree, "expr", "type",
 				       NULL, MXML_DESCEND)) {
-		e =3D nft_mxml_expr_parse(node);
+		e =3D nft_mxml_expr_parse(node, err);
 		if (e =3D=3D NULL)
 			return -1;
=20
@@ -620,15 +627,16 @@ int nft_mxml_rule_parse(mxml_node_t *tree, struct=
 nft_rule *r)
 }
 #endif
=20
-static int nft_rule_xml_parse(struct nft_rule *r, const char *xml)
+static int nft_rule_xml_parse(struct nft_rule *r, const char *xml,
+			      struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
 	int ret;
-	mxml_node_t *tree =3D nft_mxml_build_tree(xml, "rule");
+	mxml_node_t *tree =3D nft_mxml_build_tree(xml, "rule", err);
 	if (tree =3D=3D NULL)
 		return -1;
=20
-	ret =3D nft_mxml_rule_parse(tree, r);
+	ret =3D nft_mxml_rule_parse(tree, r, err);
 	mxmlDelete(tree);
 	return ret;
 #else
@@ -638,22 +646,25 @@ static int nft_rule_xml_parse(struct nft_rule *r,=
 const char *xml)
 }
=20
 int nft_rule_parse(struct nft_rule *r, enum nft_parse_type type,
-		   const char *data)
+		   const char *data, struct nft_parse_err *err)
 {
 	int ret;
+	struct nft_parse_err perr;
=20
 	switch (type) {
 	case NFT_PARSE_XML:
-		ret =3D nft_rule_xml_parse(r, data);
+		ret =3D nft_rule_xml_parse(r, data, &perr);
 		break;
 	case NFT_PARSE_JSON:
-		ret =3D nft_rule_json_parse(r, data);
+		ret =3D nft_rule_json_parse(r, data, &perr);
 		break;
 	default:
 		ret =3D -1;
 		errno =3D EOPNOTSUPP;
 		break;
 	}
+	if (err !=3D NULL)
+		*err =3D perr;
=20
 	return ret;
 }
diff --git a/src/ruleset.c b/src/ruleset.c
index f591382..a12efa9 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -132,7 +132,8 @@ const void *nft_ruleset_attr_get(const struct nft_r=
uleset *r, uint16_t attr)
 EXPORT_SYMBOL(nft_ruleset_attr_get);
=20
 #ifdef JSON_PARSING
-static int nft_ruleset_json_parse_tables(struct nft_ruleset *rs, json_=
t *array)
+static int nft_ruleset_json_parse_tables(struct nft_ruleset *rs, json_=
t *array,
+					 struct nft_parse_err *err)
 {
 	int i, len;
 	json_t *node;
@@ -161,7 +162,7 @@ static int nft_ruleset_json_parse_tables(struct nft=
_ruleset *rs, json_t *array)
 			goto err;
 		}
=20
-		if (nft_jansson_parse_table(o, node) < 0) {
+		if (nft_jansson_parse_table(o, node, err) < 0) {
 			nft_table_free(o);
 			goto err;
 		}
@@ -180,7 +181,8 @@ err:
 	return -1;
 }
=20
-static int nft_ruleset_json_parse_chains(struct nft_ruleset *rs, json_=
t *array)
+static int nft_ruleset_json_parse_chains(struct nft_ruleset *rs, json_=
t *array,
+					 struct nft_parse_err *err)
 {
 	int i, len;
 	json_t *node;
@@ -209,7 +211,7 @@ static int nft_ruleset_json_parse_chains(struct nft=
_ruleset *rs, json_t *array)
 			goto err;
 		}
=20
-		if (nft_jansson_parse_chain(o, node) < 0) {
+		if (nft_jansson_parse_chain(o, node, err) < 0) {
 			nft_chain_free(o);
 			goto err;
 		}
@@ -228,7 +230,8 @@ err:
 	return -1;
 }
=20
-static int nft_ruleset_json_parse_sets(struct nft_ruleset *rs, json_t =
*array)
+static int nft_ruleset_json_parse_sets(struct nft_ruleset *rs, json_t =
*array,
+				       struct nft_parse_err *err)
 {
 	int i, len;
 	json_t *node;
@@ -257,7 +260,7 @@ static int nft_ruleset_json_parse_sets(struct nft_r=
uleset *rs, json_t *array)
 			goto err;
 		}
=20
-		if (nft_jansson_parse_set(s, node) < 0) {
+		if (nft_jansson_parse_set(s, node, err) < 0) {
 			nft_set_free(s);
 			goto err;
 		}
@@ -276,7 +279,8 @@ err:
 	return -1;
 }
=20
-static int nft_ruleset_json_parse_rules(struct nft_ruleset *rs, json_t=
 *array)
+static int nft_ruleset_json_parse_rules(struct nft_ruleset *rs, json_t=
 *array,
+					struct nft_parse_err *err)
 {
 	int i, len;
 	json_t *node;
@@ -305,7 +309,7 @@ static int nft_ruleset_json_parse_rules(struct nft_=
ruleset *rs, json_t *array)
 			goto err;
 		}
=20
-		if (nft_jansson_parse_rule(o, node) < 0) {
+		if (nft_jansson_parse_rule(o, node, err) < 0) {
 			nft_rule_free(o);
 			goto err;
 		}
@@ -326,13 +330,14 @@ err:
=20
 #endif
=20
-static int nft_ruleset_json_parse(struct nft_ruleset *rs, const char *=
json)
+static int nft_ruleset_json_parse(struct nft_ruleset *rs, const char *=
json,
+				  struct nft_parse_err *err)
 {
 #ifdef JSON_PARSING
 	json_t *root, *array;
 	json_error_t error;
=20
-	root =3D nft_jansson_create_root(json, &error);
+	root =3D nft_jansson_create_root(json, &error, err);
 	if (root =3D=3D NULL)
 		return -1;
=20
@@ -342,16 +347,16 @@ static int nft_ruleset_json_parse(struct nft_rule=
set *rs, const char *json)
 		goto err;
 	}
=20
-	if (nft_ruleset_json_parse_tables(rs, array) !=3D 0)
+	if (nft_ruleset_json_parse_tables(rs, array, err) !=3D 0)
 		goto err;
=20
-	if (nft_ruleset_json_parse_chains(rs, array) !=3D 0)
+	if (nft_ruleset_json_parse_chains(rs, array, err) !=3D 0)
 		goto err;
=20
-	if (nft_ruleset_json_parse_sets(rs, array) !=3D 0)
+	if (nft_ruleset_json_parse_sets(rs, array, err) !=3D 0)
 		goto err;
=20
-	if (nft_ruleset_json_parse_rules(rs, array) !=3D 0)
+	if (nft_ruleset_json_parse_rules(rs, array, err) !=3D 0)
 		goto err;
=20
 	nft_jansson_free_root(root);
@@ -367,7 +372,8 @@ err:
=20
 #ifdef XML_PARSING
 static int
-nft_ruleset_xml_parse_tables(struct nft_ruleset *rs, mxml_node_t *tree=
)
+nft_ruleset_xml_parse_tables(struct nft_ruleset *rs, mxml_node_t *tree=
,
+			     struct nft_parse_err *err)
 {
 	mxml_node_t *node;
 	struct nft_table *t;
@@ -386,7 +392,7 @@ nft_ruleset_xml_parse_tables(struct nft_ruleset *rs=
, mxml_node_t *tree)
 		if (t =3D=3D NULL)
 			goto err_free;
=20
-		if (nft_mxml_table_parse(node, t) !=3D 0) {
+		if (nft_mxml_table_parse(node, t, err) !=3D 0) {
 			nft_table_free(t);
 			goto err_free;
 		}
@@ -407,7 +413,8 @@ err_free:
 }
=20
 static int
-nft_ruleset_xml_parse_chains(struct nft_ruleset *rs, mxml_node_t *tree=
)
+nft_ruleset_xml_parse_chains(struct nft_ruleset *rs, mxml_node_t *tree=
,
+			     struct nft_parse_err *err)
 {
 	mxml_node_t *node;
 	struct nft_chain *c;
@@ -426,7 +433,7 @@ nft_ruleset_xml_parse_chains(struct nft_ruleset *rs=
, mxml_node_t *tree)
 		if (c =3D=3D NULL)
 			goto err_free;
=20
-		if (nft_mxml_chain_parse(node, c) !=3D 0) {
+		if (nft_mxml_chain_parse(node, c, err) !=3D 0) {
 			nft_chain_free(c);
 			goto err_free;
 		}
@@ -447,7 +454,8 @@ err_free:
 }
=20
 static int
-nft_ruleset_xml_parse_sets(struct nft_ruleset *rs, mxml_node_t *tree)
+nft_ruleset_xml_parse_sets(struct nft_ruleset *rs, mxml_node_t *tree,
+			   struct nft_parse_err *err)
 {
 	mxml_node_t *node;
 	struct nft_set *s;
@@ -466,7 +474,7 @@ nft_ruleset_xml_parse_sets(struct nft_ruleset *rs, =
mxml_node_t *tree)
 		if (s =3D=3D NULL)
 			goto err_free;
=20
-		if (nft_mxml_set_parse(node, s) !=3D 0) {
+		if (nft_mxml_set_parse(node, s, err) !=3D 0) {
 			nft_set_free(s);
 			goto err_free;
 		}
@@ -486,7 +494,8 @@ err_free:
 }
=20
 static int
-nft_ruleset_xml_parse_rules(struct nft_ruleset *rs, mxml_node_t *tree)
+nft_ruleset_xml_parse_rules(struct nft_ruleset *rs, mxml_node_t *tree,
+			    struct nft_parse_err *err)
 {
 	mxml_node_t *node;
 	struct nft_rule *r;
@@ -505,7 +514,7 @@ nft_ruleset_xml_parse_rules(struct nft_ruleset *rs,=
 mxml_node_t *tree)
 		if (r =3D=3D NULL)
 			goto err_free;
=20
-		if (nft_mxml_rule_parse(node, r) !=3D 0) {
+		if (nft_mxml_rule_parse(node, r, err) !=3D 0) {
 			nft_rule_free(r);
 			goto err_free;
 		}
@@ -525,25 +534,26 @@ err_free:
 }
 #endif
=20
-static int nft_ruleset_xml_parse(struct nft_ruleset *rs, const char *x=
ml)
+static int nft_ruleset_xml_parse(struct nft_ruleset *rs, const char *x=
ml,
+				 struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
 	mxml_node_t *tree;
=20
-	tree =3D nft_mxml_build_tree(xml, "nftables");
+	tree =3D nft_mxml_build_tree(xml, "nftables", err);
 	if (tree =3D=3D NULL)
 		return -1;
=20
-	if (nft_ruleset_xml_parse_tables(rs, tree) !=3D 0)
+	if (nft_ruleset_xml_parse_tables(rs, tree, err) !=3D 0)
 		goto err;
=20
-	if (nft_ruleset_xml_parse_chains(rs, tree) !=3D 0)
+	if (nft_ruleset_xml_parse_chains(rs, tree, err) !=3D 0)
 		goto err;
=20
-	if (nft_ruleset_xml_parse_sets(rs, tree) !=3D 0)
+	if (nft_ruleset_xml_parse_sets(rs, tree, err) !=3D 0)
 		goto err;
=20
-	if (nft_ruleset_xml_parse_rules(rs, tree) !=3D 0)
+	if (nft_ruleset_xml_parse_rules(rs, tree, err) !=3D 0)
 		goto err;
=20
 	mxmlDelete(tree);
@@ -558,16 +568,16 @@ err:
 }
=20
 int nft_ruleset_parse(struct nft_ruleset *r, enum nft_parse_type type,
-		      const char *data)
+		      const char *data, struct nft_parse_err *err)
 {
 	int ret;
=20
 	switch (type) {
 	case NFT_PARSE_XML:
-		ret =3D nft_ruleset_xml_parse(r, data);
+		ret =3D nft_ruleset_xml_parse(r, data, err);
 		break;
 	case NFT_PARSE_JSON:
-		ret =3D nft_ruleset_json_parse(r, data);
+		ret =3D nft_ruleset_json_parse(r, data, err);
 		break;
 	default:
 		ret =3D -1;
diff --git a/src/set.c b/src/set.c
index c5204cc..32c7fff 100644
--- a/src/set.c
+++ b/src/set.c
@@ -283,7 +283,8 @@ int nft_set_nlmsg_parse(const struct nlmsghdr *nlh,=
 struct nft_set *s)
 EXPORT_SYMBOL(nft_set_nlmsg_parse);
=20
 #ifdef JSON_PARSING
-int nft_jansson_parse_set(struct nft_set *s, json_t *tree)
+int nft_jansson_parse_set(struct nft_set *s, json_t *tree,
+			  struct nft_parse_err *err)
 {
 	json_t *root, *array, *json_elem;
 	uint32_t uval32;
@@ -291,45 +292,47 @@ int nft_jansson_parse_set(struct nft_set *s, json=
_t *tree)
 	const char *valstr;
 	struct nft_set_elem *elem;
=20
-	root =3D nft_jansson_get_node(tree, "set");
+	root =3D nft_jansson_get_node(tree, "set", err);
 	if (root =3D=3D NULL)
 		return -1;
=20
-	valstr =3D nft_jansson_parse_str(root, "name");
+	valstr =3D nft_jansson_parse_str(root, "name", err);
 	if (valstr =3D=3D NULL)
 		return -1;
=20
 	nft_set_attr_set_str(s, NFT_SET_ATTR_NAME, valstr);
=20
-	valstr =3D nft_jansson_parse_str(root, "table");
+	valstr =3D nft_jansson_parse_str(root, "table", err);
 	if (valstr =3D=3D NULL)
 		return -1;
=20
 	nft_set_attr_set_str(s, NFT_SET_ATTR_TABLE, valstr);
=20
-	if (nft_jansson_parse_val(root, "flags", NFT_TYPE_U32, &uval32) < 0)
+	if (nft_jansson_parse_val(root, "flags", NFT_TYPE_U32, &uval32, err) =
< 0)
 		return -1;
=20
 	nft_set_attr_set_u32(s, NFT_SET_ATTR_FLAGS, uval32);
=20
-	if (nft_jansson_parse_family(root, &family) < 0)
+	if (nft_jansson_parse_family(root, &family, err) < 0)
 		return -1;
=20
 	nft_set_attr_set_u32(s, NFT_SET_ATTR_FAMILY, family);
=20
-	if (nft_jansson_parse_val(root, "key_type", NFT_TYPE_U32, &uval32) < =
0)
+	if (nft_jansson_parse_val(root, "key_type", NFT_TYPE_U32, &uval32,
+				  err) < 0)
 		return -1;
=20
 	nft_set_attr_set_u32(s, NFT_SET_ATTR_KEY_TYPE, uval32);
=20
-	if (nft_jansson_parse_val(root, "key_len", NFT_TYPE_U32, &uval32) < 0=
)
+	if (nft_jansson_parse_val(root, "key_len", NFT_TYPE_U32, &uval32,
+				  err) < 0)
 		return -1;
=20
 	nft_set_attr_set_u32(s, NFT_SET_ATTR_KEY_LEN, uval32);
=20
 	if (nft_jansson_node_exist(root, "data_type")) {
 		if (nft_jansson_parse_val(root, "data_type", NFT_TYPE_U32,
-					  &uval32) < 0)
+					  &uval32, err) < 0)
 			goto err;
=20
 		nft_set_attr_set_u32(s, NFT_SET_ATTR_DATA_TYPE, uval32);
@@ -337,7 +340,7 @@ int nft_jansson_parse_set(struct nft_set *s, json_t=
 *tree)
=20
 	if (nft_jansson_node_exist(root, "data_len")) {
 		if (nft_jansson_parse_val(root, "data_len", NFT_TYPE_U32,
-					  &uval32) < 0)
+					  &uval32, err) < 0)
 			goto err;
=20
 		nft_set_attr_set_u32(s, NFT_SET_ATTR_DATA_LEN, uval32);
@@ -354,7 +357,7 @@ int nft_jansson_parse_set(struct nft_set *s, json_t=
 *tree)
 			if (json_elem =3D=3D NULL)
 				goto err;
=20
-			if (nft_set_elem_json_parse(elem, json_elem) < 0)
+			if (nft_set_elem_json_parse(elem, json_elem, err) < 0)
 				goto err;
=20
 			list_add_tail(&elem->head, &s->element_list);
@@ -371,17 +374,18 @@ err:
 }
 #endif
=20
-static int nft_set_json_parse(struct nft_set *s, const char *json)
+static int nft_set_json_parse(struct nft_set *s, const char *json,
+			      struct nft_parse_err *err)
 {
 #ifdef JSON_PARSING
 	json_t *tree;
 	json_error_t error;
=20
-	tree =3D nft_jansson_create_root(json, &error);
+	tree =3D nft_jansson_create_root(json, &error, err);
 	if (tree =3D=3D NULL)
 		return -1;
=20
-	return nft_jansson_parse_set(s, tree);
+	return nft_jansson_parse_set(s, tree, err);
 #else
 	errno =3D EOPNOTSUPP;
 	return -1;
@@ -389,7 +393,8 @@ static int nft_set_json_parse(struct nft_set *s, co=
nst char *json)
 }
=20
 #ifdef XML_PARSING
-int nft_mxml_set_parse(mxml_node_t *tree, struct nft_set *s)
+int nft_mxml_set_parse(mxml_node_t *tree, struct nft_set *s,
+		       struct nft_parse_err *err)
 {
 	mxml_node_t *node =3D NULL;
 	struct nft_set_elem *elem;
@@ -397,7 +402,7 @@ int nft_mxml_set_parse(mxml_node_t *tree, struct nf=
t_set *s)
 	int family;
=20
 	name =3D nft_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST,
-				  NFT_XML_MAND);
+				  NFT_XML_MAND, err);
 	if (name =3D=3D NULL)
 		return -1;
=20
@@ -408,7 +413,7 @@ int nft_mxml_set_parse(mxml_node_t *tree, struct nf=
t_set *s)
 	s->flags |=3D (1 << NFT_SET_ATTR_NAME);
=20
 	table =3D nft_mxml_str_parse(tree, "table", MXML_DESCEND_FIRST,
-				   NFT_XML_MAND);
+				   NFT_XML_MAND, err);
 	if (table =3D=3D NULL)
 		return -1;
=20
@@ -419,7 +424,7 @@ int nft_mxml_set_parse(mxml_node_t *tree, struct nf=
t_set *s)
 	s->flags |=3D (1 << NFT_SET_ATTR_TABLE);
=20
 	family =3D nft_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST,
-				       NFT_XML_MAND);
+				       NFT_XML_MAND, err);
 	if (family < 0)
 		return -1;
=20
@@ -428,31 +433,31 @@ int nft_mxml_set_parse(mxml_node_t *tree, struct =
nft_set *s)
 	s->flags |=3D (1 << NFT_SET_ATTR_FAMILY);
=20
 	if (nft_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST, BASE_DEC,
-			       &s->set_flags, NFT_TYPE_U32, NFT_XML_MAND) !=3D 0)
+			       &s->set_flags, NFT_TYPE_U32, NFT_XML_MAND, err) !=3D 0)
 		return -1;
=20
 	s->flags |=3D (1 << NFT_SET_ATTR_FLAGS);
=20
 	if (nft_mxml_num_parse(tree, "key_type", MXML_DESCEND_FIRST, BASE_DEC=
,
-			       &s->key_type, NFT_TYPE_U32, NFT_XML_MAND) !=3D 0)
+			       &s->key_type, NFT_TYPE_U32, NFT_XML_MAND, err) !=3D 0)
 		return -1;
=20
 	s->flags |=3D (1 << NFT_SET_ATTR_KEY_TYPE);
=20
 	if (nft_mxml_num_parse(tree, "key_len", MXML_DESCEND_FIRST, BASE_DEC,
-			       &s->key_len, NFT_TYPE_U32, NFT_XML_MAND) !=3D 0)
+			       &s->key_len, NFT_TYPE_U32, NFT_XML_MAND, err) !=3D 0)
 		return -1;
=20
 	s->flags |=3D (1 << NFT_SET_ATTR_KEY_LEN);
=20
 	if (nft_mxml_num_parse(tree, "data_type", MXML_DESCEND_FIRST, BASE_DE=
C,
-			       &s->data_type, NFT_TYPE_U32, NFT_XML_MAND) !=3D 0)
+			       &s->data_type, NFT_TYPE_U32, NFT_XML_MAND, err) !=3D 0)
 		return -1;
=20
 	s->flags |=3D (1 << NFT_SET_ATTR_DATA_TYPE);
=20
 	if (nft_mxml_num_parse(tree, "data_len", MXML_DESCEND_FIRST, BASE_DEC=
,
-			       &s->data_len, NFT_TYPE_U32, NFT_XML_MAND) !=3D 0)
+			       &s->data_len, NFT_TYPE_U32, NFT_XML_MAND, err) !=3D 0)
 		return -1;
=20
 	s->flags |=3D (1 << NFT_SET_ATTR_DATA_LEN);
@@ -467,7 +472,7 @@ int nft_mxml_set_parse(mxml_node_t *tree, struct nf=
t_set *s)
 		if (elem =3D=3D NULL)
 			return -1;
=20
-		if (nft_mxml_set_elem_parse(node, elem) < 0)
+		if (nft_mxml_set_elem_parse(node, elem, err) < 0)
 			return -1;
=20
 		list_add_tail(&elem->head, &s->element_list);
@@ -477,15 +482,16 @@ int nft_mxml_set_parse(mxml_node_t *tree, struct =
nft_set *s)
 }
 #endif
=20
-static int nft_set_xml_parse(struct nft_set *s, const char *xml)
+static int nft_set_xml_parse(struct nft_set *s, const char *xml,
+			     struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
 	int ret;
-	mxml_node_t *tree =3D nft_mxml_build_tree(xml, "set");
+	mxml_node_t *tree =3D nft_mxml_build_tree(xml, "set", err);
 	if (tree =3D=3D NULL)
 		return -1;
=20
-	ret =3D nft_mxml_set_parse(tree, s);
+	ret =3D nft_mxml_set_parse(tree, s, err);
 	mxmlDelete(tree);
 	return ret;
 #else
@@ -495,16 +501,17 @@ static int nft_set_xml_parse(struct nft_set *s, c=
onst char *xml)
 }
=20
 int nft_set_parse(struct nft_set *s, enum nft_parse_type type,
-		  const char *data)
+		  const char *data, struct nft_parse_err *err)
 {
 	int ret;
+	struct nft_parse_err perr;
=20
 	switch (type) {
 	case NFT_PARSE_XML:
-		ret =3D nft_set_xml_parse(s, data);
+		ret =3D nft_set_xml_parse(s, data, &perr);
 		break;
 	case NFT_PARSE_JSON:
-		ret =3D nft_set_json_parse(s, data);
+		ret =3D nft_set_json_parse(s, data, &perr);
 		break;
 	default:
 		ret =3D -1;
@@ -512,6 +519,9 @@ int nft_set_parse(struct nft_set *s, enum nft_parse=
_type type,
 		break;
 	}
=20
+	if (err !=3D NULL)
+		*err =3D perr;
+
 	return ret;
 }
 EXPORT_SYMBOL(nft_set_parse);
diff --git a/src/set_elem.c b/src/set_elem.c
index fce9c1d..7365aff 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -357,26 +357,27 @@ int nft_set_elems_nlmsg_parse(const struct nlmsgh=
dr *nlh, struct nft_set *s)
 EXPORT_SYMBOL(nft_set_elems_nlmsg_parse);
=20
 #ifdef XML_PARSING
-int nft_mxml_set_elem_parse(mxml_node_t *tree, struct nft_set_elem *e)
+int nft_mxml_set_elem_parse(mxml_node_t *tree, struct nft_set_elem *e,
+			    struct nft_parse_err *err)
 {
 	int set_elem_data;
=20
 	if (nft_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST,
 			       BASE_DEC, &e->set_elem_flags,
-			       NFT_TYPE_U32, NFT_XML_MAND) !=3D 0)
+			       NFT_TYPE_U32, NFT_XML_MAND, err) !=3D 0)
 		return -1;
=20
 	e->flags |=3D (1 << NFT_SET_ELEM_ATTR_FLAGS);
=20
 	if (nft_mxml_data_reg_parse(tree, "key", &e->key,
-				    NFT_XML_MAND) !=3D DATA_VALUE)
+				    NFT_XML_MAND, err) !=3D DATA_VALUE)
 		return -1;
=20
 	e->flags |=3D (1 << NFT_SET_ELEM_ATTR_KEY);
=20
 	/* <set_elem_data> is not mandatory */
 	set_elem_data =3D nft_mxml_data_reg_parse(tree, "data",
-						&e->data, NFT_XML_OPT);
+						&e->data, NFT_XML_OPT, err);
 	switch (set_elem_data) {
 	case DATA_VALUE:
 		e->flags |=3D (1 << NFT_SET_ELEM_ATTR_DATA);
@@ -393,17 +394,18 @@ int nft_mxml_set_elem_parse(mxml_node_t *tree, st=
ruct nft_set_elem *e)
 }
 #endif
=20
-static int nft_set_elem_xml_parse(struct nft_set_elem *e, const char *=
xml)
+static int nft_set_elem_xml_parse(struct nft_set_elem *e, const char *=
xml,
+				  struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
 	mxml_node_t *tree;
 	int ret;
=20
-	tree =3D nft_mxml_build_tree(xml, "set_elem");
+	tree =3D nft_mxml_build_tree(xml, "set_elem", err);
 	if (tree =3D=3D NULL)
 		return -1;
=20
-	ret =3D nft_mxml_set_elem_parse(tree, e);
+	ret =3D nft_mxml_set_elem_parse(tree, e, err);
 	mxmlDelete(tree);
 	return ret;
 #else
@@ -413,12 +415,13 @@ static int nft_set_elem_xml_parse(struct nft_set_=
elem *e, const char *xml)
 }
=20
 int nft_set_elem_parse(struct nft_set_elem *e,
-		       enum nft_parse_type type, const char *data) {
+		       enum nft_parse_type type, const char *data,
+		       struct nft_parse_err *err) {
 	int ret;
=20
 	switch (type) {
 	case NFT_PARSE_XML:
-		ret =3D nft_set_elem_xml_parse(e, data);
+		ret =3D nft_set_elem_xml_parse(e, data, err);
 		break;
 	default:
 		errno =3D EOPNOTSUPP;
diff --git a/src/table.c b/src/table.c
index 9e20768..9b5f5c9 100644
--- a/src/table.c
+++ b/src/table.c
@@ -211,13 +211,14 @@ int nft_table_nlmsg_parse(const struct nlmsghdr *=
nlh, struct nft_table *t)
 EXPORT_SYMBOL(nft_table_nlmsg_parse);
=20
 #ifdef XML_PARSING
-int nft_mxml_table_parse(mxml_node_t *tree, struct nft_table *t)
+int nft_mxml_table_parse(mxml_node_t *tree, struct nft_table *t,
+			 struct nft_parse_err *err)
 {
 	const char *name;
 	int family;
=20
 	name =3D nft_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST,
-				  NFT_XML_MAND);
+				  NFT_XML_MAND, err);
 	if (name =3D=3D NULL)
 		return -1;
=20
@@ -228,7 +229,7 @@ int nft_mxml_table_parse(mxml_node_t *tree, struct =
nft_table *t)
 	t->flags |=3D (1 << NFT_TABLE_ATTR_NAME);
=20
 	family =3D nft_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST,
-				       NFT_XML_MAND);
+				       NFT_XML_MAND, err);
 	if (family < 0)
 		return -1;
=20
@@ -237,7 +238,7 @@ int nft_mxml_table_parse(mxml_node_t *tree, struct =
nft_table *t)
=20
 	if (nft_mxml_num_parse(tree, "flags", MXML_DESCEND, BASE_DEC,
 			       &t->table_flags, NFT_TYPE_U32,
-			       NFT_XML_MAND) !=3D 0)
+			       NFT_XML_MAND, err) !=3D 0)
 		return -1;
=20
 	t->flags |=3D (1 << NFT_TABLE_ATTR_FLAGS);
@@ -246,15 +247,16 @@ int nft_mxml_table_parse(mxml_node_t *tree, struc=
t nft_table *t)
 }
 #endif
=20
-static int nft_table_xml_parse(struct nft_table *t, const char *xml)
+static int nft_table_xml_parse(struct nft_table *t, const char *xml,
+			       struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
 	int ret;
-	mxml_node_t *tree =3D nft_mxml_build_tree(xml, "table");
+	mxml_node_t *tree =3D nft_mxml_build_tree(xml, "table", err);
 	if (tree =3D=3D NULL)
 		return -1;
=20
-	ret =3D nft_mxml_table_parse(tree, t);
+	ret =3D nft_mxml_table_parse(tree, t, err);
 	mxmlDelete(tree);
 	return ret;
 #else
@@ -264,29 +266,30 @@ static int nft_table_xml_parse(struct nft_table *=
t, const char *xml)
 }
=20
 #ifdef JSON_PARSING
-int nft_jansson_parse_table(struct nft_table *t, json_t *tree)
+int nft_jansson_parse_table(struct nft_table *t, json_t *tree,
+			    struct nft_parse_err *err)
 {
 	json_t *root;
 	uint32_t flags;
 	const char *str;
 	int family;
=20
-	root =3D nft_jansson_get_node(tree, "table");
+	root =3D nft_jansson_get_node(tree, "table", err);
 	if (root =3D=3D NULL)
 		return -1;
=20
-	str =3D nft_jansson_parse_str(root, "name");
+	str =3D nft_jansson_parse_str(root, "name", err);
 	if (str =3D=3D NULL)
 		goto err;
=20
 	nft_table_attr_set_str(t, NFT_TABLE_ATTR_NAME, str);
=20
-	if (nft_jansson_parse_family(root, &family) !=3D 0)
+	if (nft_jansson_parse_family(root, &family, err) !=3D 0)
 		goto err;
=20
 	nft_table_attr_set_u32(t, NFT_TABLE_ATTR_FAMILY, family);
=20
-	if (nft_jansson_parse_val(root, "flags", NFT_TYPE_U32, &flags) < 0)
+	if (nft_jansson_parse_val(root, "flags", NFT_TYPE_U32, &flags, err) <=
 0)
 		goto err;
=20
 	nft_table_attr_set_u32(t, NFT_TABLE_ATTR_FLAGS, flags);
@@ -299,17 +302,18 @@ err:
 }
 #endif
=20
-static int nft_table_json_parse(struct nft_table *t, const char *json)
+static int nft_table_json_parse(struct nft_table *t, const char *json,
+				struct nft_parse_err *err)
 {
 #ifdef JSON_PARSING
 	json_t *tree;
 	json_error_t error;
=20
-	tree =3D nft_jansson_create_root(json, &error);
+	tree =3D nft_jansson_create_root(json, &error, err);
 	if (tree =3D=3D NULL)
 		return -1;
=20
-	return nft_jansson_parse_table(t, tree);
+	return nft_jansson_parse_table(t, tree, err);
 #else
 	errno =3D EOPNOTSUPP;
 	return -1;
@@ -317,16 +321,17 @@ static int nft_table_json_parse(struct nft_table =
*t, const char *json)
 }
=20
 int nft_table_parse(struct nft_table *t, enum nft_parse_type type,
-		    const char *data)
+		    const char *data, struct nft_parse_err *err)
 {
 	int ret;
+	struct nft_parse_err perr;
=20
 	switch (type) {
 	case NFT_PARSE_XML:
-		ret =3D nft_table_xml_parse(t, data);
+		ret =3D nft_table_xml_parse(t, data, &perr);
 		break;
 	case NFT_PARSE_JSON:
-		ret =3D nft_table_json_parse(t, data);
+		ret =3D nft_table_json_parse(t, data, &perr);
 		break;
 	default:
 		ret =3D -1;
@@ -334,6 +339,9 @@ int nft_table_parse(struct nft_table *t, enum nft_p=
arse_type type,
 		break;
 	}
=20
+	if (err !=3D NULL)
+		*err =3D perr;
+
 	return ret;
 }
 EXPORT_SYMBOL(nft_table_parse);
diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index 6a5ab4d..e72818c 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -167,7 +167,7 @@ static int compare_test(uint32_t type, void *input,=
 const char *filename)
 }
 #endif
=20
-static int test_json(const char *filename)
+static int test_json(const char *filename, struct nft_parse_err *err)
 {
 #ifdef JSON_PARSING
 	int ret =3D -1;
@@ -191,7 +191,7 @@ static int test_json(const char *filename)
 	if (json_object_get(root, "table") !=3D NULL) {
 		t =3D nft_table_alloc();
 		if (t !=3D NULL) {
-			if (nft_table_parse(t, NFT_PARSE_JSON, json) =3D=3D 0)
+			if (nft_table_parse(t, NFT_PARSE_JSON, json, err) =3D=3D 0)
 				ret =3D compare_test(TEST_JSON_TABLE, t, filename);
 			else
 				goto failparsing;
@@ -201,7 +201,7 @@ static int test_json(const char *filename)
 	} else if (json_object_get(root, "chain") !=3D NULL) {
 		c =3D nft_chain_alloc();
 		if (c !=3D NULL) {
-			if (nft_chain_parse(c, NFT_PARSE_JSON, json) =3D=3D 0)
+			if (nft_chain_parse(c, NFT_PARSE_JSON, json, err) =3D=3D 0)
 				ret =3D compare_test(TEST_JSON_CHAIN, c, filename);
 			else
 				goto failparsing;
@@ -211,7 +211,7 @@ static int test_json(const char *filename)
 	} else if (json_object_get(root, "rule") !=3D NULL) {
 		r =3D nft_rule_alloc();
 		if (r !=3D NULL) {
-			if (nft_rule_parse(r, NFT_PARSE_JSON, json) =3D=3D 0)
+			if (nft_rule_parse(r, NFT_PARSE_JSON, json, err) =3D=3D 0)
 				ret =3D compare_test(TEST_JSON_RULE, r, filename);
 			else
 				goto failparsing;
@@ -221,7 +221,7 @@ static int test_json(const char *filename)
 	} else if (json_object_get(root, "set") !=3D NULL) {
 		s =3D nft_set_alloc();
 		if (s !=3D NULL) {
-			if (nft_set_parse(s, NFT_PARSE_JSON, json) =3D=3D 0)
+			if (nft_set_parse(s, NFT_PARSE_JSON, json, err) =3D=3D 0)
 				ret =3D compare_test(TEST_JSON_SET, s, filename);
 			else
 				goto failparsing;
@@ -231,7 +231,7 @@ static int test_json(const char *filename)
 	} else if (json_object_get(root, "nftables") !=3D NULL) {
 		rs =3D nft_ruleset_alloc();
 		if (rs !=3D NULL) {
-			if (nft_ruleset_parse(rs, NFT_PARSE_JSON, json) =3D=3D 0)
+			if (nft_ruleset_parse(rs, NFT_PARSE_JSON, json, err) =3D=3D 0)
 				ret =3D compare_test(TEST_JSON_RULESET, rs, filename);
 			else
 				goto failparsing;
@@ -256,7 +256,7 @@ failparsing:
 #endif
 }
=20
-static int test_xml(const char *filename)
+static int test_xml(const char *filename, struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
 	int ret =3D -1;
@@ -290,7 +290,7 @@ static int test_xml(const char *filename)
 	if (strcmp(tree->value.opaque, "table") =3D=3D 0) {
 		t =3D nft_table_alloc();
 		if (t !=3D NULL) {
-			if (nft_table_parse(t, NFT_PARSE_XML, xml) =3D=3D 0)
+			if (nft_table_parse(t, NFT_PARSE_XML, xml, err) =3D=3D 0)
 				ret =3D compare_test(TEST_XML_TABLE, t, filename);
 			else
 				goto failparsing;
@@ -300,7 +300,7 @@ static int test_xml(const char *filename)
 	} else if (strcmp(tree->value.opaque, "chain") =3D=3D 0) {
 		c =3D nft_chain_alloc();
 		if (c !=3D NULL) {
-			if (nft_chain_parse(c, NFT_PARSE_XML, xml) =3D=3D 0)
+			if (nft_chain_parse(c, NFT_PARSE_XML, xml, err) =3D=3D 0)
 				ret =3D compare_test(TEST_XML_CHAIN, c, filename);
 			else
 				goto failparsing;
@@ -310,7 +310,7 @@ static int test_xml(const char *filename)
 	} else if (strcmp(tree->value.opaque, "rule") =3D=3D 0) {
 		r =3D nft_rule_alloc();
 		if (r !=3D NULL) {
-			if (nft_rule_parse(r, NFT_PARSE_XML, xml) =3D=3D 0)
+			if (nft_rule_parse(r, NFT_PARSE_XML, xml, err) =3D=3D 0)
 				ret =3D compare_test(TEST_XML_RULE, r, filename);
 			else
 				goto failparsing;
@@ -320,7 +320,7 @@ static int test_xml(const char *filename)
 	} else if (strcmp(tree->value.opaque, "set") =3D=3D 0) {
 		s =3D nft_set_alloc();
 		if (s !=3D NULL) {
-			if (nft_set_parse(s, NFT_PARSE_XML, xml) =3D=3D 0)
+			if (nft_set_parse(s, NFT_PARSE_XML, xml, err) =3D=3D 0)
 				ret =3D compare_test(TEST_XML_SET, s, filename);
 			else
 				goto failparsing;
@@ -331,7 +331,7 @@ static int test_xml(const char *filename)
 		rs =3D nft_ruleset_alloc();
 		if (rs !=3D NULL) {
 			if (nft_ruleset_parse(rs, NFT_PARSE_XML,
-					      xml) =3D=3D 0)
+					      xml, err) =3D=3D 0)
 				ret =3D compare_test(TEST_XML_RULESET, rs,
 						   filename);
 			else
@@ -361,6 +361,7 @@ int main(int argc, char *argv[])
 	struct dirent *dent;
 	char path[PATH_MAX];
 	int ret =3D 0, exit_code =3D 0;
+	struct nft_parse_err *err;
=20
 	if (argc !=3D 2) {
 		fprintf(stderr, "Usage: %s <directory>\n", argv[0]);
@@ -373,6 +374,12 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
=20
+	err =3D nft_err_alloc();
+	if (err =3D=3D NULL) {
+		perror("error");
+		exit(EXIT_FAILURE);
+	}
+
 	while ((dent =3D readdir(d)) !=3D NULL) {
 		int len =3D strlen(dent->d_name);
=20
@@ -383,14 +390,14 @@ int main(int argc, char *argv[])
 		snprintf(path, sizeof(path), "%s/%s", argv[1], dent->d_name);
=20
 		if (strcmp(&dent->d_name[len-4], ".xml") =3D=3D 0) {
-			if ((ret =3D test_xml(path)) =3D=3D 0) {
+			if ((ret =3D test_xml(path, err)) =3D=3D 0) {
 				printf("parsing and validating %s: ", path);
 				printf("\033[32mOK\e[0m\n");
 			}
 			exit_code +=3D ret;
 		}
 		if (strcmp(&dent->d_name[len-5], ".json") =3D=3D 0) {
-			if ((ret =3D test_json(path)) =3D=3D 0) {
+			if ((ret =3D test_json(path, err)) =3D=3D 0) {
 				printf("parsing and validating %s: ", path);
 				printf("\033[32mOK\e[0m\n");
 			}
@@ -398,7 +405,9 @@ int main(int argc, char *argv[])
 		}
 	}
=20
+	nft_err_print(err);
 	closedir(d);
+	nft_err_free(err);
=20
 	if (exit_code !=3D 0)
 		exit(EXIT_FAILURE);

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
