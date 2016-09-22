From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH] libnftnl: remove libmxml support
Date: Thu, 22 Sep 2016 16:58:13 +0200
Message-ID: <147455629375.27979.9866845521114348969.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:55063 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1757521AbcIVO6U (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Sep 2016 10:58:20 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 0732951F300
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 14:58:16 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7AbkJcjXqnJ9 for <netfilter-devel@vger.kernel.org>;
        Thu, 22 Sep 2016 16:58:03 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 8095F51F301
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 16:58:01 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch removes the libmxml integration in libnftnl, since we have
JSON in place and there is no need to support two at the same time.

The JSON support is much better, for example libjansson has a better
parsing error reporting.

Moreover, libmxml 2.10 breaks the integration with libnftnl somehow,
as reported in Debian bug #83870 [0].

Also, the XML support inside libnftnl has never been in good shape, with
several tiny inconsitencies.

[0] https://bugs.debian.org/838370

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 configure.ac                           |   10 -
 examples/nft-chain-get.c               |    7 -
 examples/nft-chain-parse-add.c         |    9 -
 examples/nft-events.c                  |    6 -
 examples/nft-rule-get.c                |    8 -
 examples/nft-rule-parse-add.c          |    9 -
 examples/nft-ruleset-get.c             |    8 -
 examples/nft-ruleset-parse-file.c      |    5 -
 examples/nft-set-elem-get.c            |    4 -
 examples/nft-set-get.c                 |    4 -
 examples/nft-set-parse-add.c           |    9 -
 examples/nft-table-get.c               |    8 -
 examples/nft-table-parse-add.c         |    9 -
 include/Makefile.am                    |    1 
 include/expr_ops.h                     |    2 
 include/internal.h                     |    1 
 include/xml.h                          |   58 --------
 src/Makefile.am                        |    3 
 src/buffer.c                           |   26 +---
 src/chain.c                            |  107 ---------------
 src/expr/bitwise.c                     |   42 ------
 src/expr/byteorder.c                   |   43 ------
 src/expr/cmp.c                         |   36 -----
 src/expr/counter.c                     |   23 ---
 src/expr/ct.c                          |   48 -------
 src/expr/data_reg.c                    |  156 ----------------------
 src/expr/dup.c                         |   21 ---
 src/expr/dynset.c                      |   38 -----
 src/expr/exthdr.c                      |   40 ------
 src/expr/fwd.c                         |   18 --
 src/expr/hash.c                        |   44 ------
 src/expr/immediate.c                   |   39 -----
 src/expr/limit.c                       |   33 -----
 src/expr/log.c                         |   45 ------
 src/expr/lookup.c                      |   34 -----
 src/expr/masq.c                        |   27 ----
 src/expr/match.c                       |   21 ---
 src/expr/meta.c                        |   33 -----
 src/expr/nat.c                         |   55 --------
 src/expr/numgen.c                      |   30 ----
 src/expr/payload.c                     |   40 ------
 src/expr/queue.c                       |   30 ----
 src/expr/quota.c                       |   22 ---
 src/expr/redir.c                       |   27 ----
 src/expr/reject.c                      |   24 ---
 src/expr/target.c                      |   22 ---
 src/mxml.c                             |  232 --------------------------------
 src/rule.c                             |  162 ----------------------
 src/ruleset.c                          |  162 +---------------------
 src/set.c                              |  194 +--------------------------
 src/set_elem.c                         |  118 +---------------
 src/table.c                            |   53 -------
 tests/Makefile.am                      |    5 -
 tests/nft-parsing-test.c               |   62 ---------
 tests/test-script.sh                   |    1 
 tests/xmlfiles/01-table.xml            |    1 
 tests/xmlfiles/02-table.xml            |    1 
 tests/xmlfiles/10-chain.xml            |    1 
 tests/xmlfiles/11-chain.xml            |    1 
 tests/xmlfiles/12-chain.xml            |    1 
 tests/xmlfiles/20-rule-bitwise.xml     |    1 
 tests/xmlfiles/21-rule-byteorder.xml   |    1 
 tests/xmlfiles/22-rule-cmp.xml         |    1 
 tests/xmlfiles/23-rule-counter.xml     |    1 
 tests/xmlfiles/24-rule-ct.xml          |    1 
 tests/xmlfiles/25-rule-exthdr.xml      |    1 
 tests/xmlfiles/26-rule-immediate.xml   |    1 
 tests/xmlfiles/27-rule-limit.xml       |    1 
 tests/xmlfiles/28-rule-log.xml         |    1 
 tests/xmlfiles/29-rule-lookup.xml      |    1 
 tests/xmlfiles/30-rule-match.xml       |    1 
 tests/xmlfiles/31-rule-meta.xml        |    1 
 tests/xmlfiles/32-rule-nat6.xml        |    1 
 tests/xmlfiles/33-rule-nat4.xml        |    1 
 tests/xmlfiles/34-rule-payload.xml     |    1 
 tests/xmlfiles/35-rule-target.xml      |    1 
 tests/xmlfiles/36-rule-real.xml        |    1 
 tests/xmlfiles/37-rule-real.xml        |    1 
 tests/xmlfiles/38-rule-real.xml        |    1 
 tests/xmlfiles/39-rule-real.xml        |    1 
 tests/xmlfiles/40-rule-real.xml        |    1 
 tests/xmlfiles/41-rule-real.xml        |    1 
 tests/xmlfiles/42-rule-real.xml        |    1 
 tests/xmlfiles/43-rule-real.xml        |    1 
 tests/xmlfiles/44-rule-real.xml        |    1 
 tests/xmlfiles/45-rule-real.xml        |    1 
 tests/xmlfiles/46-rule-real.xml        |    1 
 tests/xmlfiles/47-rule-real.xml        |    1 
 tests/xmlfiles/48-rule-real.xml        |    1 
 tests/xmlfiles/49-rule-real.xml        |    1 
 tests/xmlfiles/50-rule-real.xml        |    1 
 tests/xmlfiles/51-rule-real.xml        |    1 
 tests/xmlfiles/52-rule-real.xml        |    1 
 tests/xmlfiles/53-rule-real.xml        |    1 
 tests/xmlfiles/54-rule-real.xml        |    1 
 tests/xmlfiles/55-rule-real.xml        |    1 
 tests/xmlfiles/56-rule-real.xml        |    1 
 tests/xmlfiles/57-rule-real.xml        |    1 
 tests/xmlfiles/58-rule-real.xml        |    1 
 tests/xmlfiles/59-rule-real.xml        |    1 
 tests/xmlfiles/60-rule-real.xml        |    1 
 tests/xmlfiles/61-rule-real.xml        |    1 
 tests/xmlfiles/62-rule-real.xml        |    1 
 tests/xmlfiles/63-rule-real.xml        |    1 
 tests/xmlfiles/64-rule-real.xml        |    1 
 tests/xmlfiles/65-rule-real.xml        |    1 
 tests/xmlfiles/66-rule-real.xml        |    1 
 tests/xmlfiles/67-rule-real.xml        |    1 
 tests/xmlfiles/68-rule-real.xml        |    1 
 tests/xmlfiles/69-rule-real.xml        |    1 
 tests/xmlfiles/70-rule-real.xml        |    1 
 tests/xmlfiles/71-rule-real.xml        |    1 
 tests/xmlfiles/72-rule-real.xml        |    1 
 tests/xmlfiles/73-set.xml              |    1 
 tests/xmlfiles/74-set.xml              |    1 
 tests/xmlfiles/75-ruleset.xml          |    1 
 tests/xmlfiles/76-rule-meta_target.xml |    1 
 tests/xmlfiles/77-rule-queue.xml       |    1 
 tests/xmlfiles/78-rule-queue.xml       |    2 
 tests/xmlfiles/79-rule-masq.xml        |    1 
 tests/xmlfiles/80-rule-redir.xml       |    1 
 tests/xmlfiles/81-rule-real.xml        |    1 
 122 files changed, 59 insertions(+), 2283 deletions(-)
 delete mode 100644 include/xml.h
 delete mode 100644 src/mxml.c
 delete mode 100644 tests/xmlfiles/01-table.xml
 delete mode 100644 tests/xmlfiles/02-table.xml
 delete mode 100644 tests/xmlfiles/10-chain.xml
 delete mode 100644 tests/xmlfiles/11-chain.xml
 delete mode 100644 tests/xmlfiles/12-chain.xml
 delete mode 100644 tests/xmlfiles/20-rule-bitwise.xml
 delete mode 100644 tests/xmlfiles/21-rule-byteorder.xml
 delete mode 100644 tests/xmlfiles/22-rule-cmp.xml
 delete mode 100644 tests/xmlfiles/23-rule-counter.xml
 delete mode 100644 tests/xmlfiles/24-rule-ct.xml
 delete mode 100644 tests/xmlfiles/25-rule-exthdr.xml
 delete mode 100644 tests/xmlfiles/26-rule-immediate.xml
 delete mode 100644 tests/xmlfiles/27-rule-limit.xml
 delete mode 100644 tests/xmlfiles/28-rule-log.xml
 delete mode 100644 tests/xmlfiles/29-rule-lookup.xml
 delete mode 100644 tests/xmlfiles/30-rule-match.xml
 delete mode 100644 tests/xmlfiles/31-rule-meta.xml
 delete mode 100644 tests/xmlfiles/32-rule-nat6.xml
 delete mode 100644 tests/xmlfiles/33-rule-nat4.xml
 delete mode 100644 tests/xmlfiles/34-rule-payload.xml
 delete mode 100644 tests/xmlfiles/35-rule-target.xml
 delete mode 100644 tests/xmlfiles/36-rule-real.xml
 delete mode 100644 tests/xmlfiles/37-rule-real.xml
 delete mode 100644 tests/xmlfiles/38-rule-real.xml
 delete mode 100644 tests/xmlfiles/39-rule-real.xml
 delete mode 100644 tests/xmlfiles/40-rule-real.xml
 delete mode 100644 tests/xmlfiles/41-rule-real.xml
 delete mode 100644 tests/xmlfiles/42-rule-real.xml
 delete mode 100644 tests/xmlfiles/43-rule-real.xml
 delete mode 100644 tests/xmlfiles/44-rule-real.xml
 delete mode 100644 tests/xmlfiles/45-rule-real.xml
 delete mode 100644 tests/xmlfiles/46-rule-real.xml
 delete mode 100644 tests/xmlfiles/47-rule-real.xml
 delete mode 100644 tests/xmlfiles/48-rule-real.xml
 delete mode 100644 tests/xmlfiles/49-rule-real.xml
 delete mode 100644 tests/xmlfiles/50-rule-real.xml
 delete mode 100644 tests/xmlfiles/51-rule-real.xml
 delete mode 100644 tests/xmlfiles/52-rule-real.xml
 delete mode 100644 tests/xmlfiles/53-rule-real.xml
 delete mode 100644 tests/xmlfiles/54-rule-real.xml
 delete mode 100644 tests/xmlfiles/55-rule-real.xml
 delete mode 100644 tests/xmlfiles/56-rule-real.xml
 delete mode 100644 tests/xmlfiles/57-rule-real.xml
 delete mode 100644 tests/xmlfiles/58-rule-real.xml
 delete mode 100644 tests/xmlfiles/59-rule-real.xml
 delete mode 100644 tests/xmlfiles/60-rule-real.xml
 delete mode 100644 tests/xmlfiles/61-rule-real.xml
 delete mode 100644 tests/xmlfiles/62-rule-real.xml
 delete mode 100644 tests/xmlfiles/63-rule-real.xml
 delete mode 100644 tests/xmlfiles/64-rule-real.xml
 delete mode 100644 tests/xmlfiles/65-rule-real.xml
 delete mode 100644 tests/xmlfiles/66-rule-real.xml
 delete mode 100644 tests/xmlfiles/67-rule-real.xml
 delete mode 100644 tests/xmlfiles/68-rule-real.xml
 delete mode 100644 tests/xmlfiles/69-rule-real.xml
 delete mode 100644 tests/xmlfiles/70-rule-real.xml
 delete mode 100644 tests/xmlfiles/71-rule-real.xml
 delete mode 100644 tests/xmlfiles/72-rule-real.xml
 delete mode 100644 tests/xmlfiles/73-set.xml
 delete mode 100644 tests/xmlfiles/74-set.xml
 delete mode 100644 tests/xmlfiles/75-ruleset.xml
 delete mode 100644 tests/xmlfiles/76-rule-meta_target.xml
 delete mode 100644 tests/xmlfiles/77-rule-queue.xml
 delete mode 100644 tests/xmlfiles/78-rule-queue.xml
 delete mode 100644 tests/xmlfiles/79-rule-masq.xml
 delete mode 100644 tests/xmlfiles/80-rule-redir.xml
 delete mode 100644 tests/xmlfiles/81-rule-real.xml

diff --git a/configure.ac b/configure.ac
index b78091e..813523d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -15,15 +15,9 @@ m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
 
 dnl Dependencies
 PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.0])
-AC_ARG_WITH([xml-parsing],
-	AS_HELP_STRING([--with-xml-parsing], [XML parsing support]))
 AC_ARG_WITH([json-parsing],
 	AS_HELP_STRING([--with-json-parsing], [JSON parsing support]))
 
-AS_IF([test "x$with_xml_parsing" = "xyes"],
-	[PKG_CHECK_MODULES([LIBXML], [mxml >= 2.6])],
-	[with_xml_parsing="no"]
-)
 AS_IF([test "x$with_json_parsing" = "xyes"],
 	[PKG_CHECK_MODULES([LIBJSON], [jansson >= 2.3])],
 	[with_json_parsing="no"]
@@ -40,9 +34,6 @@ case "$host" in
 esac
 
 regular_CPPFLAGS="-D_FILE_OFFSET_BITS=64 -D_REENTRANT"
-AS_IF([test "x$with_xml_parsing" = "xyes"], [
-	regular_CPPFLAGS="$regular_CPPFLAGS -DXML_PARSING"
-])
 
 AS_IF([test "x$with_json_parsing" = "xyes"], [
 	regular_CPPFLAGS="$regular_CPPFLAGS -DJSON_PARSING"
@@ -57,5 +48,4 @@ AC_OUTPUT
 
 echo "
 libnftnl configuration:
-  XML support:				${with_xml_parsing}
   JSON support:				${with_json_parsing}"
diff --git a/examples/nft-chain-get.c b/examples/nft-chain-get.c
index f5d4593..6fda2d8 100644
--- a/examples/nft-chain-get.c
+++ b/examples/nft-chain-get.c
@@ -58,7 +58,7 @@ int main(int argc, char *argv[])
 	seq = time(NULL);
 
 	if (argc < 2 || argc > 5) {
-		fprintf(stderr, "Usage: %s <family> [<table> <chain>] [xml]\n",
+		fprintf(stderr, "Usage: %s <family> [<table> <chain>] [json]\n",
 			argv[0]);
 		exit(EXIT_FAILURE);
 	}
@@ -95,11 +95,8 @@ int main(int argc, char *argv[])
 						NLM_F_DUMP, seq);
 	}
 
-	if (strcmp(argv[argc-1], "xml") == 0){
-		type = NFTNL_OUTPUT_XML;
-	}else if (strcmp(argv[argc-1], "json") == 0){
+	if (strcmp(argv[argc-1], "json") == 0)
 		type = NFTNL_OUTPUT_JSON;
-	}
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
diff --git a/examples/nft-chain-parse-add.c b/examples/nft-chain-parse-add.c
index cf43cc2..dd27343 100644
--- a/examples/nft-chain-parse-add.c
+++ b/examples/nft-chain-parse-add.c
@@ -81,18 +81,15 @@ int main(int argc, char *argv[])
 	struct mnl_nlmsg_batch *batch;
 
 	if (argc < 3) {
-		printf("Usage: %s {xml|json} <file>\n", argv[0]);
+		printf("Usage: %s {json} <file>\n", argv[0]);
 		exit(EXIT_FAILURE);
 	}
 
-	if (strcmp(argv[1], "xml") == 0) {
-		format = NFTNL_PARSE_XML;
-		outformat = NFTNL_OUTPUT_XML;
-	} else if (strcmp(argv[1], "json") == 0) {
+	if (strcmp(argv[1], "json") == 0) {
 		format = NFTNL_PARSE_JSON;
 		outformat = NFTNL_OUTPUT_JSON;
 	} else {
-		printf("Unknown format: xml, json\n");
+		printf("Unknown format: only json is supported\n");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/nft-events.c b/examples/nft-events.c
index 885af45..bd8c752 100644
--- a/examples/nft-events.c
+++ b/examples/nft-events.c
@@ -236,9 +236,7 @@ int main(int argc, char *argv[])
 		type = NFTNL_OUTPUT_DEFAULT;
 		break;
 	case 2:
-		if (strcmp(argv[1], "xml") == 0) {
-			type = NFTNL_OUTPUT_XML;
-		} else if (strcmp(argv[1], "json") == 0) {
+		if (strcmp(argv[1], "json") == 0) {
 			type = NFTNL_OUTPUT_JSON;
 		} else if (strcmp(argv[1], "default") == 0) {
 			type = NFTNL_OUTPUT_DEFAULT;
@@ -248,7 +246,7 @@ int main(int argc, char *argv[])
 		}
 		break;
 	default:
-		fprintf(stderr, "%s [<default|xml|json>]\n", argv[0]);
+		fprintf(stderr, "%s [<default|json>]\n", argv[0]);
 		return EXIT_FAILURE;
 	}
 
diff --git a/examples/nft-rule-get.c b/examples/nft-rule-get.c
index 6a15d56..aa49612 100644
--- a/examples/nft-rule-get.c
+++ b/examples/nft-rule-get.c
@@ -82,7 +82,7 @@ int main(int argc, char *argv[])
 	int ret, family;
 
 	if (argc < 2 || argc > 5) {
-		fprintf(stderr, "Usage: %s <family> [<table> <chain>] [xml|json]\n",
+		fprintf(stderr, "Usage: %s <family> [<table> <chain>] [json]\n",
 			argv[0]);
 		exit(EXIT_FAILURE);
 	}
@@ -102,11 +102,9 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	/* [xml|json] specified */
+	/* json specified */
 	if (argc == 3 || argc == 5) {
-		if (strcmp(argv[argc - 1], "xml") == 0)
-			type = NFTNL_OUTPUT_XML;
-		else if (strcmp(argv[argc - 1], "json") == 0)
+		if (strcmp(argv[argc - 1], "json") == 0)
 			type = NFTNL_OUTPUT_JSON;
 	}
 
diff --git a/examples/nft-rule-parse-add.c b/examples/nft-rule-parse-add.c
index 3707de3..90f1da7 100644
--- a/examples/nft-rule-parse-add.c
+++ b/examples/nft-rule-parse-add.c
@@ -84,18 +84,15 @@ int main(int argc, char *argv[])
 	uint16_t family, format, outformat;
 
 	if (argc < 3) {
-		printf("Usage: %s {xml|json} <file>\n", argv[0]);
+		printf("Usage: %s {json} <file>\n", argv[0]);
 		exit(EXIT_FAILURE);
 	}
 
-	if (strcmp(argv[1], "xml") == 0) {
-		format = NFTNL_PARSE_XML;
-		outformat = NFTNL_OUTPUT_XML;
-	} else if (strcmp(argv[1], "json") == 0) {
+	if (strcmp(argv[1], "json") == 0) {
 		format = NFTNL_PARSE_JSON;
 		outformat = NFTNL_OUTPUT_JSON;
 	} else {
-		printf("Unknown format: xml, json\n");
+		printf("Unknown format: json\n");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/nft-ruleset-get.c b/examples/nft-ruleset-get.c
index 2c9d775..9e997c2 100644
--- a/examples/nft-ruleset-get.c
+++ b/examples/nft-ruleset-get.c
@@ -344,18 +344,16 @@ int main(int argc, char *argv[])
 	int ret;
 
 	if (argc > 2) {
-		fprintf(stderr, "%s {xml|json}\n",
+		fprintf(stderr, "%s {json}\n",
 			argv[0]);
 		exit(EXIT_FAILURE);
 	}
 
 	if (argc == 2) {
-		if (strcmp(argv[1], "xml") == 0)
-			type = NFTNL_OUTPUT_XML;
-		else if (strcmp(argv[1], "json") == 0)
+		if (strcmp(argv[1], "json") == 0)
 			type = NFTNL_OUTPUT_JSON;
 		else {
-			fprintf(stderr, "Unknown type: {xml|json}\n");
+			fprintf(stderr, "Unknown type: only json is supported\n");
 			exit(EXIT_FAILURE);
 		}
 	}
diff --git a/examples/nft-ruleset-parse-file.c b/examples/nft-ruleset-parse-file.c
index 84dc304..505c43c 100644
--- a/examples/nft-ruleset-parse-file.c
+++ b/examples/nft-ruleset-parse-file.c
@@ -422,11 +422,8 @@ int main(int argc, char *argv[])
 	if (len >= 5 && strcmp(&filename[len - 5], ".json") == 0)
 		ret = nftnl_ruleset_parse_file_cb(NFTNL_PARSE_JSON, fp, err, NULL,
 						&ruleset_elems_cb);
-	else if (len >= 4 && strcmp(&filename[len - 4], ".xml") == 0)
-		ret = nftnl_ruleset_parse_file_cb(NFTNL_PARSE_XML, fp, err, NULL,
-						&ruleset_elems_cb);
 	else {
-		printf("the filename %s must to end in .xml or .json\n",
+		printf("the filename %s does not have a trailing .json\n",
 			filename);
 		exit(EXIT_FAILURE);
 	}
diff --git a/examples/nft-set-elem-get.c b/examples/nft-set-elem-get.c
index 9c637ee..9a3ccd7 100644
--- a/examples/nft-set-elem-get.c
+++ b/examples/nft-set-elem-get.c
@@ -57,7 +57,7 @@ int main(int argc, char *argv[])
 	int ret;
 
 	if (argc < 4 || argc > 5) {
-		fprintf(stderr, "%s <family> <table> <set> [<json|xml>]\n",
+		fprintf(stderr, "%s <family> <table> <set> [<json>]\n",
 			argv[0]);
 		return EXIT_FAILURE;
 	}
@@ -82,8 +82,6 @@ int main(int argc, char *argv[])
 
 	if (argc == 5 && strcmp(argv[4], "json") == 0 )
 		type = NFTNL_OUTPUT_JSON;
-	else if (argc == 5 && strcmp(argv[4], "xml") == 0)
-		type = NFTNL_OUTPUT_XML;
 
 	nlh = nftnl_set_nlmsg_build_hdr(buf, NFT_MSG_GETSETELEM, family,
 					NLM_F_DUMP|NLM_F_ACK, seq);
diff --git a/examples/nft-set-get.c b/examples/nft-set-get.c
index 245ac5f..c4ad8ee 100644
--- a/examples/nft-set-get.c
+++ b/examples/nft-set-get.c
@@ -57,7 +57,7 @@ int main(int argc, char *argv[])
 	int ret;
 
 	if (argc < 2 || argc > 3) {
-		fprintf(stderr, "%s <family> [<json|xml>]\n", argv[0]);
+		fprintf(stderr, "%s <family> [<json>]\n", argv[0]);
 		return EXIT_FAILURE;
 	}
 	t = nftnl_set_alloc();
@@ -83,8 +83,6 @@ int main(int argc, char *argv[])
 
 	if (argc == 3 && strcmp(argv[2], "json") == 0)
 		type = NFTNL_OUTPUT_JSON;
-	else if (argc == 3 && strcmp(argv[2], "xml") == 0)
-		type = NFTNL_OUTPUT_XML;
 
 	nlh = nftnl_set_nlmsg_build_hdr(buf, NFT_MSG_GETSET, family,
 					NLM_F_DUMP|NLM_F_ACK, seq);
diff --git a/examples/nft-set-parse-add.c b/examples/nft-set-parse-add.c
index 3648730..550e8f4 100644
--- a/examples/nft-set-parse-add.c
+++ b/examples/nft-set-parse-add.c
@@ -85,18 +85,15 @@ int main(int argc, char *argv[])
 	struct mnl_nlmsg_batch *batch;
 
 	if (argc < 2) {
-		printf("Usage: %s {xml|json} <file>\n", argv[0]);
+		printf("Usage: %s {json} <file>\n", argv[0]);
 		exit(EXIT_FAILURE);
 	}
 
-	if (strcmp(argv[1], "xml") == 0) {
-		format = NFTNL_PARSE_XML;
-		outformat = NFTNL_OUTPUT_XML;
-	} else if (strcmp(argv[1], "json") == 0) {
+	if (strcmp(argv[1], "json") == 0) {
 		format = NFTNL_PARSE_JSON;
 		outformat = NFTNL_OUTPUT_JSON;
 	} else {
-		printf("Unknown format: xml, json\n");
+		printf("Unknown format: only json is supported\n");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/nft-table-get.c b/examples/nft-table-get.c
index d648a11..193db77 100644
--- a/examples/nft-table-get.c
+++ b/examples/nft-table-get.c
@@ -57,7 +57,7 @@ int main(int argc, char *argv[])
 	uint32_t type = NFTNL_OUTPUT_DEFAULT;
 
 	if (argc < 2 || argc > 4) {
-		fprintf(stderr, "%s <family> [<table>] [<default|xml|json>]\n",
+		fprintf(stderr, "%s <family> [<table>] [<default|json>]\n",
 			argv[0]);
 		return EXIT_FAILURE;
 	}
@@ -77,11 +77,7 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	if (strcmp(argv[argc-1], "xml") == 0) {
-		type = NFTNL_OUTPUT_XML;
-		argv[argc-1] = NULL;
-		argc--;
-	}else if (strcmp(argv[argc-1], "json") == 0) {
+	if (strcmp(argv[argc-1], "json") == 0) {
 		type = NFTNL_OUTPUT_JSON;
 		argv[argc-1] = NULL;
 		argc--;
diff --git a/examples/nft-table-parse-add.c b/examples/nft-table-parse-add.c
index 31d31cc..28cb276 100644
--- a/examples/nft-table-parse-add.c
+++ b/examples/nft-table-parse-add.c
@@ -80,18 +80,15 @@ int main(int argc, char *argv[])
 	struct mnl_nlmsg_batch *batch;
 
 	if (argc < 3) {
-		printf("Usage: %s {xml|json} <file>\n", argv[0]);
+		printf("Usage: %s {json} <file>\n", argv[0]);
 		exit(EXIT_FAILURE);
 	}
 
-	if (strcmp(argv[1], "xml") == 0) {
-		format = NFTNL_PARSE_XML;
-		outformat = NFTNL_OUTPUT_XML;
-	} else if (strcmp(argv[1], "json") == 0) {
+	if (strcmp(argv[1], "json") == 0) {
 		format = NFTNL_PARSE_JSON;
 		outformat = NFTNL_OUTPUT_JSON;
 	} else {
-		printf("Unknown format: xml, json\n");
+		printf("Unknown format: only json is supported\n");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/include/Makefile.am b/include/Makefile.am
index 9f55737..a049e2e 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -7,7 +7,6 @@ noinst_HEADERS = internal.h	\
 		 expr_ops.h	\
 		 linux_list.h	\
 		 set.h		\
-		 xml.h		\
 		 common.h	\
 		 expr.h		\
 		 json.h		\
diff --git a/include/expr_ops.h b/include/expr_ops.h
index a334732..e639390 100644
--- a/include/expr_ops.h
+++ b/include/expr_ops.h
@@ -19,8 +19,6 @@ struct expr_ops {
 	int 	(*parse)(struct nftnl_expr *e, struct nlattr *attr);
 	void	(*build)(struct nlmsghdr *nlh, const struct nftnl_expr *e);
 	int	(*snprintf)(char *buf, size_t len, uint32_t type, uint32_t flags, const struct nftnl_expr *e);
-	int	(*xml_parse)(struct nftnl_expr *e, mxml_node_t *tree,
-			     struct nftnl_parse_err *err);
 	int	(*json_parse)(struct nftnl_expr *e, json_t *data,
 			      struct nftnl_parse_err *err);
 };
diff --git a/include/internal.h b/include/internal.h
index c74e2bf..7e97c4a 100644
--- a/include/internal.h
+++ b/include/internal.h
@@ -6,7 +6,6 @@
 #include "linux_list.h"
 #include "utils.h"
 #include "common.h"
-#include "xml.h"
 #include "json.h"
 #include "linux_list.h"
 #include "set.h"
diff --git a/include/xml.h b/include/xml.h
deleted file mode 100644
index 7b33a83..0000000
--- a/include/xml.h
+++ /dev/null
@@ -1,58 +0,0 @@
-#ifndef LIBNFTNL_XML_INTERNAL_H
-#define LIBNFTNL_XML_INTERNAL_H
-
-#ifdef XML_PARSING
-#include <mxml.h>
-#include "common.h"
-
-#define NFTNL_XML_MAND 0
-#define NFTNL_XML_OPT (1 << 0)
-
-struct nftnl_table;
-struct nftnl_chain;
-struct nftnl_rule;
-struct nftnl_set;
-struct nftnl_set_elem;
-struct nftnl_set_list;
-union nftnl_data_reg;
-
-mxml_node_t *nftnl_mxml_build_tree(const void *data, const char *treename,
-				 struct nftnl_parse_err *err, enum nftnl_parse_input input);
-struct nftnl_expr *nftnl_mxml_expr_parse(mxml_node_t *node,
-					  struct nftnl_parse_err *err,
-					  struct nftnl_set_list *set_list);
-int nftnl_mxml_reg_parse(mxml_node_t *tree, const char *reg_name, uint32_t *reg,
-		       uint32_t mxmlflags, uint32_t flags,
-		       struct nftnl_parse_err *err);
-int nftnl_mxml_data_reg_parse(mxml_node_t *tree, const char *node_name,
-			    union nftnl_data_reg *data_reg, uint16_t flags,
-			    struct nftnl_parse_err *err);
-int nftnl_mxml_num_parse(mxml_node_t *tree, const char *node_name,
-		       uint32_t mxml_flags, int base, void *number,
-		       enum nftnl_type type, uint16_t flags,
-		       struct nftnl_parse_err *err);
-const char *nftnl_mxml_str_parse(mxml_node_t *tree, const char *node_name,
-			       uint32_t mxml_flags, uint16_t flags,
-			       struct nftnl_parse_err *err);
-int nftnl_mxml_family_parse(mxml_node_t *tree, const char *node_name,
-			  uint32_t mxml_flags, uint16_t flags,
-			  struct nftnl_parse_err *err);
-int nftnl_mxml_set_elem_parse(mxml_node_t *node, struct nftnl_set_elem *e,
-			    struct nftnl_parse_err *err);
-int nftnl_mxml_table_parse(mxml_node_t *tree, struct nftnl_table *t,
-			 struct nftnl_parse_err *err);
-int nftnl_mxml_chain_parse(mxml_node_t *tree, struct nftnl_chain *c,
-			 struct nftnl_parse_err *err);
-int nftnl_mxml_rule_parse(mxml_node_t *tree, struct nftnl_rule *r,
-			struct nftnl_parse_err *err,
-			struct nftnl_set_list *set_list);
-int nftnl_mxml_set_parse(mxml_node_t *tree, struct nftnl_set *s,
-		       struct nftnl_parse_err *err);
-
-int nftnl_data_reg_xml_parse(union nftnl_data_reg *reg, mxml_node_t *tree,
-			   struct nftnl_parse_err *err);
-#else
-#define mxml_node_t void
-#endif
-
-#endif /* LIBNFTNL_XML_INTERNAL_H */
diff --git a/src/Makefile.am b/src/Makefile.am
index 4a91cdb..4ab8fca 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -1,7 +1,7 @@
 include $(top_srcdir)/Make_global.am
 lib_LTLIBRARIES = libnftnl.la
 
-libnftnl_la_LIBADD = ${LIBMNL_LIBS} ${LIBXML_LIBS} ${LIBJSON_LIBS}
+libnftnl_la_LIBADD = ${LIBMNL_LIBS} ${LIBJSON_LIBS}
 libnftnl_la_LDFLAGS = -Wl,--version-script=$(srcdir)/libnftnl.map	\
 		      -version-info $(LIBVERSION)
 
@@ -17,7 +17,6 @@ libnftnl_la_SOURCES = utils.c		\
 		      set.c		\
 		      set_elem.c	\
 		      ruleset.c		\
-		      mxml.c		\
 		      jansson.c		\
 		      udata.c		\
 		      expr.c		\
diff --git a/src/buffer.c b/src/buffer.c
index 57d3c0c..d97d517 100644
--- a/src/buffer.c
+++ b/src/buffer.c
@@ -62,10 +62,9 @@ static int nftnl_buf_put(struct nftnl_buf *b, const char *fmt, ...)
 int nftnl_buf_open(struct nftnl_buf *b, int type, const char *tag)
 {
 	switch (type) {
-	case NFTNL_OUTPUT_XML:
-		return nftnl_buf_put(b, "<%s>", tag);
 	case NFTNL_OUTPUT_JSON:
 		return nftnl_buf_put(b, "{\"%s\":{", tag);
+	case NFTNL_OUTPUT_XML:
 	default:
 		return 0;
 	}
@@ -74,8 +73,6 @@ int nftnl_buf_open(struct nftnl_buf *b, int type, const char *tag)
 int nftnl_buf_close(struct nftnl_buf *b, int type, const char *tag)
 {
 	switch (type) {
-	case NFTNL_OUTPUT_XML:
-		return nftnl_buf_put(b, "</%s>", tag);
 	case NFTNL_OUTPUT_JSON:
 		/* Remove trailing comma in json */
 		if (b->size > 0 && b->buf[b->size - 1] == ',') {
@@ -85,6 +82,7 @@ int nftnl_buf_close(struct nftnl_buf *b, int type, const char *tag)
 		}
 
 		return nftnl_buf_put(b, "}}");
+	case NFTNL_OUTPUT_XML:
 	default:
 		return 0;
 	}
@@ -96,7 +94,6 @@ int nftnl_buf_open_array(struct nftnl_buf *b, int type, const char *tag)
 	case NFTNL_OUTPUT_JSON:
 		return nftnl_buf_put(b, "{\"%s\":[", tag);
 	case NFTNL_OUTPUT_XML:
-		return nftnl_buf_put(b, "<%s>", tag);
 	default:
 		return 0;
 	}
@@ -108,7 +105,6 @@ int nftnl_buf_close_array(struct nftnl_buf *b, int type, const char *tag)
 	case NFTNL_OUTPUT_JSON:
 		return nftnl_buf_put(b, "]}");
 	case NFTNL_OUTPUT_XML:
-		return nftnl_buf_put(b, "</%s>", tag);
 	default:
 		return 0;
 	}
@@ -117,10 +113,9 @@ int nftnl_buf_close_array(struct nftnl_buf *b, int type, const char *tag)
 int nftnl_buf_u32(struct nftnl_buf *b, int type, uint32_t value, const char *tag)
 {
 	switch (type) {
-	case NFTNL_OUTPUT_XML:
-		return nftnl_buf_put(b, "<%s>%u</%s>", tag, value, tag);
 	case NFTNL_OUTPUT_JSON:
 		return nftnl_buf_put(b, "\"%s\":%u,", tag, value);
+	case NFTNL_OUTPUT_XML:
 	default:
 		return 0;
 	}
@@ -129,10 +124,9 @@ int nftnl_buf_u32(struct nftnl_buf *b, int type, uint32_t value, const char *tag
 int nftnl_buf_s32(struct nftnl_buf *b, int type, uint32_t value, const char *tag)
 {
 	switch (type) {
-	case NFTNL_OUTPUT_XML:
-		return nftnl_buf_put(b, "<%s>%d</%s>", tag, value, tag);
 	case NFTNL_OUTPUT_JSON:
 		return nftnl_buf_put(b, "\"%s\":%d,", tag, value);
+	case NFTNL_OUTPUT_XML:
 	default:
 		return 0;
 	}
@@ -141,10 +135,9 @@ int nftnl_buf_s32(struct nftnl_buf *b, int type, uint32_t value, const char *tag
 int nftnl_buf_u64(struct nftnl_buf *b, int type, uint64_t value, const char *tag)
 {
 	switch (type) {
-	case NFTNL_OUTPUT_XML:
-		return nftnl_buf_put(b, "<%s>%"PRIu64"</%s>", tag, value, tag);
 	case NFTNL_OUTPUT_JSON:
 		return nftnl_buf_put(b, "\"%s\":%"PRIu64",", tag, value);
+	case NFTNL_OUTPUT_XML:
 	default:
 		return 0;
 	}
@@ -153,10 +146,9 @@ int nftnl_buf_u64(struct nftnl_buf *b, int type, uint64_t value, const char *tag
 int nftnl_buf_str(struct nftnl_buf *b, int type, const char *str, const char *tag)
 {
 	switch (type) {
-	case NFTNL_OUTPUT_XML:
-		return nftnl_buf_put(b, "<%s>%s</%s>", tag, str, tag);
 	case NFTNL_OUTPUT_JSON:
 		return nftnl_buf_put(b, "\"%s\":\"%s\",", tag, str);
+	case NFTNL_OUTPUT_XML:
 	default:
 		return 0;
 	}
@@ -169,11 +161,7 @@ int nftnl_buf_reg(struct nftnl_buf *b, int type, union nftnl_data_reg *reg,
 
 	switch (type) {
 	case NFTNL_OUTPUT_XML:
-		ret = nftnl_buf_put(b, "<%s>", tag);
-		ret = nftnl_data_reg_snprintf(b->buf + b->off, b->len, reg,
-                                    NFTNL_OUTPUT_XML, 0, reg_type);
-		nftnl_buf_update(b, ret);
-		return nftnl_buf_put(b, "</%s>", tag);
+		return 0;
 	case NFTNL_OUTPUT_JSON:
 		nftnl_buf_put(b, "\"%s\":{", tag);
 		ret = nftnl_data_reg_snprintf(b->buf + b->off, b->len, reg,
diff --git a/src/chain.c b/src/chain.c
index dfe0cf2..49cd094 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -708,109 +708,6 @@ static int nftnl_chain_json_parse(struct nftnl_chain *c, const void *json,
 #endif
 }
 
-#ifdef XML_PARSING
-int nftnl_mxml_chain_parse(mxml_node_t *tree, struct nftnl_chain *c,
-			 struct nftnl_parse_err *err)
-{
-	const char *table, *name, *hooknum_str, *policy_str, *type, *dev;
-	int family, hooknum, policy;
-	uint64_t handle, bytes, packets, prio, use;
-
-	name = nftnl_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST,
-				  NFTNL_XML_MAND, err);
-	if (name != NULL)
-		nftnl_chain_set_str(c, NFTNL_CHAIN_NAME, name);
-
-	if (nftnl_mxml_num_parse(tree, "handle", MXML_DESCEND_FIRST, BASE_DEC,
-			       &handle, NFTNL_TYPE_U64, NFTNL_XML_MAND, err) == 0)
-		nftnl_chain_set_u64(c, NFTNL_CHAIN_HANDLE, handle);
-
-	if (nftnl_mxml_num_parse(tree, "bytes", MXML_DESCEND_FIRST, BASE_DEC,
-			       &bytes, NFTNL_TYPE_U64, NFTNL_XML_MAND, err) == 0)
-		nftnl_chain_set_u64(c, NFTNL_CHAIN_BYTES, bytes);
-
-
-	if (nftnl_mxml_num_parse(tree, "packets", MXML_DESCEND_FIRST, BASE_DEC,
-			       &packets, NFTNL_TYPE_U64, NFTNL_XML_MAND, err) == 0)
-		nftnl_chain_set_u64(c, NFTNL_CHAIN_PACKETS, packets);
-
-	table = nftnl_mxml_str_parse(tree, "table", MXML_DESCEND_FIRST,
-				   NFTNL_XML_MAND, err);
-
-	if (table != NULL)
-		nftnl_chain_set_str(c, NFTNL_CHAIN_TABLE, table);
-
-	if (nftnl_mxml_num_parse(tree, "use", MXML_DESCEND_FIRST, BASE_DEC,
-			       &use, NFTNL_TYPE_U64, NFTNL_XML_MAND, err) == 0)
-		nftnl_chain_set_u64(c, NFTNL_CHAIN_PACKETS, use);
-
-	family = nftnl_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST,
-				       NFTNL_XML_MAND, err);
-	if (family >= 0)
-		nftnl_chain_set_u32(c, NFTNL_CHAIN_FAMILY, family);
-
-	hooknum_str = nftnl_mxml_str_parse(tree, "hooknum", MXML_DESCEND_FIRST,
-					 NFTNL_XML_OPT, err);
-	if (hooknum_str != NULL) {
-		hooknum = nftnl_str2hooknum(c->family, hooknum_str);
-		if (hooknum < 0)
-			return -1;
-		nftnl_chain_set_u32(c, NFTNL_CHAIN_HOOKNUM, hooknum);
-
-		type = nftnl_mxml_str_parse(tree, "type", MXML_DESCEND_FIRST,
-					  NFTNL_XML_MAND, err);
-
-		if (type != NULL)
-			nftnl_chain_set_str(c, NFTNL_CHAIN_TYPE, type);
-
-		if (nftnl_mxml_num_parse(tree, "prio", MXML_DESCEND, BASE_DEC,
-				       &prio, NFTNL_TYPE_S32, NFTNL_XML_MAND,
-				       err) == 0)
-			nftnl_chain_set_s32(c, NFTNL_CHAIN_PRIO, prio);
-
-		policy_str = nftnl_mxml_str_parse(tree, "policy",
-						MXML_DESCEND_FIRST,
-						NFTNL_XML_MAND, err);
-		if (policy_str != NULL) {
-			if (nftnl_str2verdict(policy_str, &policy) != 0) {
-				errno = EINVAL;
-				err->node_name = "policy";
-				err->error = NFTNL_PARSE_EBADTYPE;
-				return -1;
-			}
-			nftnl_chain_set_u32(c, NFTNL_CHAIN_POLICY,
-					       policy);
-		}
-
-		dev = nftnl_mxml_str_parse(tree, "device", MXML_DESCEND_FIRST,
-					   NFTNL_XML_MAND, err);
-		if (dev != NULL)
-			nftnl_chain_set_str(c, NFTNL_CHAIN_DEV, dev);
-	}
-
-	return 0;
-}
-#endif
-
-static int nftnl_chain_xml_parse(struct nftnl_chain *c, const void *xml,
-			       struct nftnl_parse_err *err,
-			       enum nftnl_parse_input input)
-{
-#ifdef XML_PARSING
-	int ret;
-	mxml_node_t *tree = nftnl_mxml_build_tree(xml, "chain", err, input);
-	if (tree == NULL)
-		return -1;
-
-	ret = nftnl_mxml_chain_parse(tree, c, err);
-	mxmlDelete(tree);
-	return ret;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
-
 static int nftnl_chain_do_parse(struct nftnl_chain *c, enum nftnl_parse_type type,
 			      const void *data, struct nftnl_parse_err *err,
 			      enum nftnl_parse_input input)
@@ -819,12 +716,10 @@ static int nftnl_chain_do_parse(struct nftnl_chain *c, enum nftnl_parse_type typ
 	struct nftnl_parse_err perr = {};
 
 	switch (type) {
-	case NFTNL_PARSE_XML:
-		ret = nftnl_chain_xml_parse(c, data, &perr, input);
-		break;
 	case NFTNL_PARSE_JSON:
 		ret = nftnl_chain_json_parse(c, data, &perr, input);
 		break;
+	case NFTNL_PARSE_XML:
 	default:
 		ret = -1;
 		errno = EOPNOTSUPP;
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 9cc9347..0febc9d 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -209,47 +209,6 @@ nftnl_expr_bitwise_json_parse(struct nftnl_expr *e, json_t *root,
 #endif
 }
 
-static int
-nftnl_expr_bitwise_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
-				struct nftnl_parse_err *err)
-{
-#ifdef XML_PARSING
-	struct nftnl_expr_bitwise *bitwise = nftnl_expr_data(e);
-	uint32_t sreg, dreg, len;
-
-	if (nftnl_mxml_reg_parse(tree, "sreg", &sreg, MXML_DESCEND_FIRST,
-			       NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_BITWISE_SREG, sreg);
-
-	if (nftnl_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND_FIRST,
-			       NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_BITWISE_DREG, dreg);
-
-	if (nftnl_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST, BASE_DEC,
-			       &len, NFTNL_TYPE_U32, NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_BITWISE_LEN, len);
-
-	if (nftnl_mxml_data_reg_parse(tree, "mask", &bitwise->mask, NFTNL_XML_MAND,
-				    err) == DATA_VALUE)
-		e->flags |= (1 << NFTNL_EXPR_BITWISE_MASK);
-
-	if (nftnl_mxml_data_reg_parse(tree, "xor", &bitwise->xor, NFTNL_XML_MAND,
-				    err) == DATA_VALUE)
-		e->flags |= (1 << NFTNL_EXPR_BITWISE_XOR);
-
-	/* Additional validation: mask and xor must use the same number of
-	 * data registers.
-	 */
-	if (bitwise->mask.len != bitwise->xor.len)
-		return -1;
-
-	return 0;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
-
 static int nftnl_expr_bitwise_export(char *buf, size_t size,
 				     const struct nftnl_expr *e, int type)
 {
@@ -341,6 +300,5 @@ struct expr_ops expr_ops_bitwise = {
 	.parse		= nftnl_expr_bitwise_parse,
 	.build		= nftnl_expr_bitwise_build,
 	.snprintf	= nftnl_expr_bitwise_snprintf,
-	.xml_parse	= nftnl_expr_bitwise_xml_parse,
 	.json_parse	= nftnl_expr_bitwise_json_parse,
 };
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index a7914ef..5f8e585 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -234,48 +234,6 @@ nftnl_expr_byteorder_json_parse(struct nftnl_expr *e, json_t *root,
 #endif
 }
 
-static int
-nftnl_expr_byteorder_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
-				  struct nftnl_parse_err *err)
-{
-#ifdef XML_PARSING
-	const char *op;
-	int32_t ntoh;
-	uint32_t sreg, dreg, len, size;
-
-	if (nftnl_mxml_reg_parse(tree, "sreg", &sreg, MXML_DESCEND_FIRST,
-			       NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_BYTEORDER_SREG, sreg);
-
-	if (nftnl_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND, NFTNL_XML_MAND,
-			       err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_BYTEORDER_DREG, dreg);
-
-	op = nftnl_mxml_str_parse(tree, "op", MXML_DESCEND_FIRST, NFTNL_XML_MAND,
-				err);
-	if (op != NULL) {
-		ntoh = nftnl_str2ntoh(op);
-		if (ntoh < 0)
-			return -1;
-
-		nftnl_expr_set_u32(e, NFTNL_EXPR_BYTEORDER_OP, ntoh);
-	}
-
-	if (nftnl_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST, BASE_DEC,
-			       &len, NFTNL_TYPE_U32, NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_BYTEORDER_LEN, len);
-
-	if (nftnl_mxml_num_parse(tree, "size", MXML_DESCEND_FIRST, BASE_DEC,
-			       &size, NFTNL_TYPE_U32, NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_BYTEORDER_SIZE, size);
-
-	return 0;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
-
 static int nftnl_expr_byteorder_export(char *buf, size_t size,
 				       const struct nftnl_expr *e, int type)
 {
@@ -357,6 +315,5 @@ struct expr_ops expr_ops_byteorder = {
 	.parse		= nftnl_expr_byteorder_parse,
 	.build		= nftnl_expr_byteorder_build,
 	.snprintf	= nftnl_expr_byteorder_snprintf,
-	.xml_parse	= nftnl_expr_byteorder_xml_parse,
 	.json_parse	= nftnl_expr_byteorder_json_parse,
 };
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index a46c15a..e7ed0db 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -209,41 +209,6 @@ static int nftnl_expr_cmp_json_parse(struct nftnl_expr *e, json_t *root,
 #endif
 }
 
-static int nftnl_expr_cmp_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
-				       struct nftnl_parse_err *err)
-{
-#ifdef XML_PARSING
-	struct nftnl_expr_cmp *cmp = nftnl_expr_data(e);
-	const char *op;
-	int32_t op_value;
-	uint32_t sreg;
-
-	if (nftnl_mxml_reg_parse(tree, "sreg", &sreg, MXML_DESCEND_FIRST,
-			       NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_CMP_SREG, sreg);
-
-	op = nftnl_mxml_str_parse(tree, "op", MXML_DESCEND_FIRST, NFTNL_XML_MAND,
-				err);
-	if (op != NULL) {
-		op_value = nftnl_str2cmp(op);
-		if (op_value < 0)
-			return -1;
-
-		nftnl_expr_set_u32(e, NFTNL_EXPR_CMP_OP, op_value);
-	}
-
-	if (nftnl_mxml_data_reg_parse(tree, "data",
-				    &cmp->data, NFTNL_XML_MAND,
-				    err) == DATA_VALUE)
-		e->flags |= (1 << NFTNL_EXPR_CMP_DATA);
-
-	return 0;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
-
 static int nftnl_expr_cmp_export(char *buf, size_t size,
 				 const struct nftnl_expr *e, int type)
 {
@@ -320,6 +285,5 @@ struct expr_ops expr_ops_cmp = {
 	.parse		= nftnl_expr_cmp_parse,
 	.build		= nftnl_expr_cmp_build,
 	.snprintf	= nftnl_expr_cmp_snprintf,
-	.xml_parse	= nftnl_expr_cmp_xml_parse,
 	.json_parse	= nftnl_expr_cmp_json_parse,
 };
diff --git a/src/expr/counter.c b/src/expr/counter.c
index 4488afc..21901e8 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -137,28 +137,6 @@ nftnl_expr_counter_json_parse(struct nftnl_expr *e, json_t *root,
 #endif
 }
 
-static int
-nftnl_expr_counter_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
-				struct nftnl_parse_err *err)
-{
-#ifdef XML_PARSING
-	uint64_t pkts, bytes;
-
-	if (nftnl_mxml_num_parse(tree, "pkts", MXML_DESCEND_FIRST, BASE_DEC,
-			       &pkts, NFTNL_TYPE_U64, NFTNL_XML_MAND,  err) == 0)
-		nftnl_expr_set_u64(e, NFTNL_EXPR_CTR_PACKETS, pkts);
-
-	if (nftnl_mxml_num_parse(tree, "bytes", MXML_DESCEND_FIRST, BASE_DEC,
-			       &bytes, NFTNL_TYPE_U64, NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u64(e, NFTNL_EXPR_CTR_BYTES, bytes);
-
-	return 0;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
-
 static int nftnl_expr_counter_export(char *buf, size_t size,
 				     const struct nftnl_expr *e, int type)
 {
@@ -223,6 +201,5 @@ struct expr_ops expr_ops_counter = {
 	.parse		= nftnl_expr_counter_parse,
 	.build		= nftnl_expr_counter_build,
 	.snprintf	= nftnl_expr_counter_snprintf,
-	.xml_parse	= nftnl_expr_counter_xml_parse,
 	.json_parse	= nftnl_expr_counter_json_parse,
 };
diff --git a/src/expr/ct.c b/src/expr/ct.c
index 0137891..e680738 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -263,53 +263,6 @@ err:
 }
 
 
-static int nftnl_expr_ct_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
-				      struct nftnl_parse_err *err)
-{
-#ifdef XML_PARSING
-	const char *key_str, *dir_str;
-	int key;
-	uint8_t dir;
-	uint32_t dreg, sreg;
-
-	if (nftnl_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND_FIRST,
-			       NFTNL_XML_OPT, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_CT_DREG, dreg);
-
-	if (nftnl_mxml_reg_parse(tree, "sreg", &sreg, MXML_DESCEND_FIRST,
-			       NFTNL_XML_OPT, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_CT_SREG, sreg);
-
-	key_str = nftnl_mxml_str_parse(tree, "key", MXML_DESCEND_FIRST,
-				     NFTNL_XML_MAND, err);
-	if (key_str != NULL) {
-		key = str2ctkey(key_str);
-		if (key < 0)
-			return -1;
-
-		nftnl_expr_set_u32(e, NFTNL_EXPR_CT_KEY, key);
-	}
-	dir_str = nftnl_mxml_str_parse(tree, "dir", MXML_DESCEND_FIRST,
-				     NFTNL_XML_OPT, err);
-	if (dir_str != NULL) {
-		if (str2ctdir(dir_str, &dir) != 0) {
-			err->node_name = "dir";
-			err->error = NFTNL_PARSE_EBADTYPE;
-			goto err;
-		}
-		nftnl_expr_set_u8(e, NFTNL_EXPR_CT_DIR, dir);
-	}
-
-	return 0;
-err:
-	errno = EINVAL;
-	return -1;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
-
 static int
 nftnl_expr_ct_export(char *buf, size_t size, const struct nftnl_expr *e,
 		     int type)
@@ -402,6 +355,5 @@ struct expr_ops expr_ops_ct = {
 	.parse		= nftnl_expr_ct_parse,
 	.build		= nftnl_expr_ct_build,
 	.snprintf	= nftnl_expr_ct_snprintf,
-	.xml_parse	= nftnl_expr_ct_xml_parse,
 	.json_parse	= nftnl_expr_ct_json_parse,
 };
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 395e9f6..0249258 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -96,94 +96,6 @@ int nftnl_data_reg_json_parse(union nftnl_data_reg *reg, json_t *data,
 }
 #endif
 
-#ifdef XML_PARSING
-static int nftnl_data_reg_verdict_xml_parse(union nftnl_data_reg *reg,
-					  mxml_node_t *tree,
-					  struct nftnl_parse_err *err)
-{
-	int verdict;
-	const char *verdict_str;
-	const char *chain;
-
-	verdict_str = nftnl_mxml_str_parse(tree, "verdict", MXML_DESCEND_FIRST,
-					 NFTNL_XML_MAND, err);
-	if (verdict_str == NULL)
-		return DATA_NONE;
-
-	if (nftnl_str2verdict(verdict_str, &verdict) != 0) {
-		err->node_name = "verdict";
-		err->error = NFTNL_PARSE_EBADTYPE;
-		errno = EINVAL;
-		return DATA_NONE;
-	}
-
-	reg->verdict = (uint32_t)verdict;
-
-	chain = nftnl_mxml_str_parse(tree, "chain", MXML_DESCEND_FIRST,
-				   NFTNL_XML_OPT, err);
-	if (chain != NULL) {
-		if (reg->chain)
-			xfree(reg->chain);
-
-		reg->chain = strdup(chain);
-	}
-
-	return DATA_VERDICT;
-}
-
-static int nftnl_data_reg_value_xml_parse(union nftnl_data_reg *reg,
-					mxml_node_t *tree,
-					struct nftnl_parse_err *err)
-{
-	int i;
-	char node_name[6];
-
-	if (nftnl_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST, BASE_DEC,
-			       &reg->len, NFTNL_TYPE_U8, NFTNL_XML_MAND, err) != 0)
-		return DATA_NONE;
-
-	for (i = 0; i < div_round_up(reg->len, sizeof(uint32_t)); i++) {
-		sprintf(node_name, "data%d", i);
-
-		if (nftnl_mxml_num_parse(tree, node_name, MXML_DESCEND_FIRST,
-				       BASE_HEX, &reg->val[i], NFTNL_TYPE_U32,
-				       NFTNL_XML_MAND, err) != 0)
-			return DATA_NONE;
-	}
-
-	return DATA_VALUE;
-}
-
-int nftnl_data_reg_xml_parse(union nftnl_data_reg *reg, mxml_node_t *tree,
-			   struct nftnl_parse_err *err)
-{
-	const char *type;
-	mxml_node_t *node;
-
-	node = mxmlFindElement(tree, tree, "reg", "type", NULL,
-			       MXML_DESCEND_FIRST);
-	if (node == NULL)
-		goto err;
-
-	type = mxmlElementGetAttr(node, "type");
-
-	if (type == NULL)
-		goto err;
-
-	if (strcmp(type, "value") == 0)
-		return nftnl_data_reg_value_xml_parse(reg, node, err);
-	else if (strcmp(type, "verdict") == 0)
-		return nftnl_data_reg_verdict_xml_parse(reg, node, err);
-
-	return DATA_NONE;
-err:
-	errno = EINVAL;
-	err->node_name = "reg";
-	err->error = NFTNL_PARSE_EMISSINGNODE;
-	return DATA_NONE;
-}
-#endif
-
 static int
 nftnl_data_reg_value_snprintf_json(char *buf, size_t size,
 				   const union nftnl_data_reg *reg,
@@ -221,43 +133,6 @@ nftnl_data_reg_value_snprintf_json(char *buf, size_t size,
 	return offset;
 }
 
-static
-int nftnl_data_reg_value_snprintf_xml(char *buf, size_t size,
-				      const union nftnl_data_reg *reg,
-				      uint32_t flags)
-{
-	int len = size, offset = 0, ret, i, j;
-	uint32_t be;
-	uint8_t *tmp;
-
-	ret = snprintf(buf, len, "<reg type=\"value\">");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	ret = snprintf(buf+offset, len, "<len>%u</len>", reg->len);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	for (i = 0; i < div_round_up(reg->len, sizeof(uint32_t)); i++) {
-		ret = snprintf(buf+offset, len, "<data%d>0x", i);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-		be = htonl(reg->val[i]);
-		tmp = (uint8_t *)&be;
-
-		for (j = 0; j < sizeof(uint32_t); j++) {
-			ret = snprintf(buf+offset, len, "%.02x", tmp[j]);
-			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-		}
-
-		ret = snprintf(buf+offset, len, "</data%d>", i);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	ret = snprintf(buf+offset, len, "</reg>");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	return offset;
-}
-
 static int
 nftnl_data_reg_value_snprintf_default(char *buf, size_t size,
 				      const union nftnl_data_reg *reg,
@@ -292,29 +167,6 @@ nftnl_data_reg_verdict_snprintf_def(char *buf, size_t size,
 }
 
 static int
-nftnl_data_reg_verdict_snprintf_xml(char *buf, size_t size,
-				    const union nftnl_data_reg *reg,
-				    uint32_t flags)
-{
-	int len = size, offset = 0, ret = 0;
-
-	ret = snprintf(buf, size, "<reg type=\"verdict\">"
-		       "<verdict>%s</verdict>", nftnl_verdict2str(reg->verdict));
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	if (reg->chain != NULL) {
-		ret = snprintf(buf+offset, len, "<chain>%s</chain>",
-			       reg->chain);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	ret = snprintf(buf+offset, len, "</reg>");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	return offset;
-}
-
-static int
 nftnl_data_reg_verdict_snprintf_json(char *buf, size_t size,
 				     const union nftnl_data_reg *reg,
 				     uint32_t flags)
@@ -348,12 +200,10 @@ int nftnl_data_reg_snprintf(char *buf, size_t size,
 		case NFTNL_OUTPUT_DEFAULT:
 			return nftnl_data_reg_value_snprintf_default(buf, size,
 								   reg, flags);
-		case NFTNL_OUTPUT_XML:
-			return nftnl_data_reg_value_snprintf_xml(buf, size,
-							       reg, flags);
 		case NFTNL_OUTPUT_JSON:
 			return nftnl_data_reg_value_snprintf_json(buf, size,
 							       reg, flags);
+		case NFTNL_OUTPUT_XML:
 		default:
 			break;
 		}
@@ -363,12 +213,10 @@ int nftnl_data_reg_snprintf(char *buf, size_t size,
 		case NFTNL_OUTPUT_DEFAULT:
 			return nftnl_data_reg_verdict_snprintf_def(buf, size,
 								 reg, flags);
-		case NFTNL_OUTPUT_XML:
-			return nftnl_data_reg_verdict_snprintf_xml(buf, size,
-								 reg, flags);
 		case NFTNL_OUTPUT_JSON:
 			return nftnl_data_reg_verdict_snprintf_json(buf, size,
 								  reg, flags);
+		case NFTNL_OUTPUT_XML:
 		default:
 			break;
 		}
diff --git a/src/expr/dup.c b/src/expr/dup.c
index ac1923c..9aa332b 100644
--- a/src/expr/dup.c
+++ b/src/expr/dup.c
@@ -133,26 +133,6 @@ static int nftnl_expr_dup_json_parse(struct nftnl_expr *e, json_t *root,
 #endif
 }
 
-static int nftnl_expr_dup_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
-				    struct nftnl_parse_err *err)
-{
-#ifdef XML_PARSING
-	uint32_t sreg_addr, sreg_dev;
-
-	if (nftnl_mxml_reg_parse(tree, "sreg_addr", &sreg_addr, MXML_DESCEND_FIRST,
-			       NFTNL_XML_OPT, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_DUP_SREG_ADDR, sreg_addr);
-	if (nftnl_mxml_reg_parse(tree, "sreg_dev", &sreg_dev, MXML_DESCEND_FIRST,
-			       NFTNL_XML_OPT, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_DUP_SREG_DEV, sreg_dev);
-
-	return 0;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
-
 static int nftnl_expr_dup_export(char *buf, size_t size,
 				 const struct nftnl_expr *e, int type)
 {
@@ -227,6 +207,5 @@ struct expr_ops expr_ops_dup = {
 	.parse		= nftnl_expr_dup_parse,
 	.build		= nftnl_expr_dup_build,
 	.snprintf	= nftnl_expr_dup_snprintf,
-	.xml_parse	= nftnl_expr_dup_xml_parse,
 	.json_parse	= nftnl_expr_dup_json_parse,
 };
diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index ea59145..20a5004 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -242,43 +242,6 @@ nftnl_expr_dynset_json_parse(struct nftnl_expr *e, json_t *root,
 }
 
 static int
-nftnl_expr_dynset_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
-			       struct nftnl_parse_err *err)
-{
-#ifdef XML_PARSING
-	const char *set_name;
-	uint32_t uval32;
-	uint64_t uval64;
-
-	set_name = nftnl_mxml_str_parse(tree, "set", MXML_DESCEND_FIRST,
-				      NFTNL_XML_MAND, err);
-	if (set_name != NULL)
-		nftnl_expr_set_str(e, NFTNL_EXPR_DYNSET_SET_NAME, set_name);
-
-	if (nftnl_mxml_reg_parse(tree, "sreg_key", &uval32, MXML_DESCEND,
-			       NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_DYNSET_SREG_KEY, uval32);
-
-	if (nftnl_mxml_reg_parse(tree, "sreg_data", &uval32, MXML_DESCEND,
-			       NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_DYNSET_SREG_DATA, uval32);
-
-	if (nftnl_mxml_num_parse(tree, "op", MXML_DESCEND_FIRST, BASE_DEC,
-			       &uval32, NFTNL_TYPE_U32, NFTNL_XML_MAND,  err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_DYNSET_OP, uval32);
-
-	if (nftnl_mxml_num_parse(tree, "timeout", MXML_DESCEND_FIRST, BASE_DEC,
-			       &uval64, NFTNL_TYPE_U64, NFTNL_XML_MAND,  err) == 0)
-		nftnl_expr_set_u64(e, NFTNL_EXPR_DYNSET_TIMEOUT, uval64);
-
-	return 0;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
-
-static int
 nftnl_expr_dynset_export(char *buf, size_t size,
 			 const struct nftnl_expr *e, int type)
 {
@@ -406,6 +369,5 @@ struct expr_ops expr_ops_dynset = {
 	.parse		= nftnl_expr_dynset_parse,
 	.build		= nftnl_expr_dynset_build,
 	.snprintf	= nftnl_expr_dynset_snprintf,
-	.xml_parse	= nftnl_expr_dynset_xml_parse,
 	.json_parse	= nftnl_expr_dynset_json_parse,
 };
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index deb0d7c..b164e3f 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -221,45 +221,6 @@ nftnl_expr_exthdr_json_parse(struct nftnl_expr *e, json_t *root,
 #endif
 }
 
-static int
-nftnl_expr_exthdr_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
-			       struct nftnl_parse_err *err)
-{
-#ifdef XML_PARSING
-	const char *exthdr_type;
-	int type;
-	uint32_t dreg, len, offset;
-
-	if (nftnl_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND_FIRST,
-			       NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_EXTHDR_DREG, dreg);
-
-	exthdr_type = nftnl_mxml_str_parse(tree, "exthdr_type",
-					 MXML_DESCEND_FIRST, NFTNL_XML_MAND, err);
-	if (exthdr_type != NULL) {
-		type = str2exthdr_type(exthdr_type);
-		if (type < 0)
-			return -1;
-		nftnl_expr_set_u8(e, NFTNL_EXPR_EXTHDR_TYPE, type);
-	}
-
-	/* Get and set <offset> */
-	if (nftnl_mxml_num_parse(tree, "offset", MXML_DESCEND_FIRST, BASE_DEC,
-			       &offset, NFTNL_TYPE_U32, NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_EXTHDR_OFFSET, offset);
-
-	/* Get and set <len> */
-	if (nftnl_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST, BASE_DEC,
-			       &len, NFTNL_TYPE_U32, NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_EXTHDR_LEN, len);
-
-	return 0;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
-
 static int nftnl_expr_exthdr_export(char *buf, size_t len,
 				    const struct nftnl_expr *e, int type)
 {
@@ -333,6 +294,5 @@ struct expr_ops expr_ops_exthdr = {
 	.parse		= nftnl_expr_exthdr_parse,
 	.build		= nftnl_expr_exthdr_build,
 	.snprintf	= nftnl_expr_exthdr_snprintf,
-	.xml_parse	= nftnl_expr_exthdr_xml_parse,
 	.json_parse	= nftnl_expr_exthdr_json_parse,
 };
diff --git a/src/expr/fwd.c b/src/expr/fwd.c
index 9c5520c..c30d494 100644
--- a/src/expr/fwd.c
+++ b/src/expr/fwd.c
@@ -116,23 +116,6 @@ static int nftnl_expr_fwd_json_parse(struct nftnl_expr *e, json_t *root,
 #endif
 }
 
-static int nftnl_expr_fwd_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
-				    struct nftnl_parse_err *err)
-{
-#ifdef XML_PARSING
-	uint32_t sreg_dev;
-
-	if (nftnl_mxml_reg_parse(tree, "sreg_dev", &sreg_dev, MXML_DESCEND_FIRST,
-			       NFTNL_XML_OPT, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_FWD_SREG_DEV, sreg_dev);
-
-	return 0;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
-
 static int nftnl_expr_fwd_export(char *buf, size_t size,
 				 const struct nftnl_expr *e, int type)
 {
@@ -198,6 +181,5 @@ struct expr_ops expr_ops_fwd = {
 	.parse		= nftnl_expr_fwd_parse,
 	.build		= nftnl_expr_fwd_build,
 	.snprintf	= nftnl_expr_fwd_snprintf,
-	.xml_parse	= nftnl_expr_fwd_xml_parse,
 	.json_parse	= nftnl_expr_fwd_json_parse,
 };
diff --git a/src/expr/hash.c b/src/expr/hash.c
index 371e766..08f09f5 100644
--- a/src/expr/hash.c
+++ b/src/expr/hash.c
@@ -207,49 +207,6 @@ static int nftnl_expr_hash_json_parse(struct nftnl_expr *e, json_t *root,
 #endif
 }
 
-
-static int nftnl_expr_hash_xml_parse(struct nftnl_expr *e,
-				     mxml_node_t *tree,
-				     struct nftnl_parse_err *err)
-{
-#ifdef XML_PARSING
-	uint32_t sreg, dreg, len, modulus, seed, offset;
-
-	if (nftnl_mxml_reg_parse(tree, "sreg", &sreg, MXML_DESCEND_FIRST,
-				 NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_SREG, sreg);
-
-	if (nftnl_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND_FIRST,
-				 NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_DREG, dreg);
-
-	if (nftnl_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST, BASE_DEC,
-				 &len, NFTNL_TYPE_U32, NFTNL_XML_MAND,
-				 err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_LEN, len);
-
-	if (nftnl_mxml_num_parse(tree, "modulus", MXML_DESCEND_FIRST, BASE_DEC,
-				 &modulus, NFTNL_TYPE_U32, NFTNL_XML_MAND,
-				 err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_MODULUS, modulus);
-
-	if (nftnl_mxml_num_parse(tree, "seed", MXML_DESCEND_FIRST, BASE_DEC,
-				 &seed, NFTNL_TYPE_U32, NFTNL_XML_MAND,
-				 err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_SEED, seed);
-
-	if (nftnl_mxml_num_parse(tree, "offset", MXML_DESCEND_FIRST, BASE_DEC,
-				 &offset, NFTNL_TYPE_U32, NFTNL_XML_MAND,
-				 err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_OFFSET, offset);
-
-	return 0;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
-
 static int
 nftnl_expr_hash_snprintf_default(char *buf, size_t size,
 				 const struct nftnl_expr *e)
@@ -338,6 +295,5 @@ struct expr_ops expr_ops_hash = {
 	.parse		= nftnl_expr_hash_parse,
 	.build		= nftnl_expr_hash_build,
 	.snprintf	= nftnl_expr_hash_snprintf,
-	.xml_parse	= nftnl_expr_hash_xml_parse,
 	.json_parse	= nftnl_expr_hash_json_parse,
 };
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 2fdae9c..0b188cc 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -210,44 +210,6 @@ nftnl_expr_immediate_json_parse(struct nftnl_expr *e, json_t *root,
 }
 
 static int
-nftnl_expr_immediate_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
-				  struct nftnl_parse_err *err)
-{
-#ifdef XML_PARSING
-	struct nftnl_expr_immediate *imm = nftnl_expr_data(e);
-	int datareg_type;
-	uint32_t reg;
-
-	if (nftnl_mxml_reg_parse(tree, "dreg", &reg, MXML_DESCEND_FIRST,
-			       NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_IMM_DREG, reg);
-
-	datareg_type = nftnl_mxml_data_reg_parse(tree, "data",
-					       &imm->data, NFTNL_XML_MAND, err);
-	if (datareg_type >= 0) {
-		switch (datareg_type) {
-		case DATA_VALUE:
-			e->flags |= (1 << NFTNL_EXPR_IMM_DATA);
-			break;
-		case DATA_VERDICT:
-			e->flags |= (1 << NFTNL_EXPR_IMM_VERDICT);
-			break;
-		case DATA_CHAIN:
-			e->flags |= (1 << NFTNL_EXPR_IMM_CHAIN);
-			break;
-		default:
-			return -1;
-		}
-	}
-
-	return 0;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
-
-static int
 nftnl_expr_immediate_export(char *buf, size_t size, const struct nftnl_expr *e,
 			    int type)
 {
@@ -355,6 +317,5 @@ struct expr_ops expr_ops_immediate = {
 	.parse		= nftnl_expr_immediate_parse,
 	.build		= nftnl_expr_immediate_build,
 	.snprintf	= nftnl_expr_immediate_snprintf,
-	.xml_parse	= nftnl_expr_immediate_xml_parse,
 	.json_parse	= nftnl_expr_immediate_json_parse,
 };
diff --git a/src/expr/limit.c b/src/expr/limit.c
index 9f19d53..856ab18 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -186,38 +186,6 @@ static int nftnl_expr_limit_json_parse(struct nftnl_expr *e, json_t *root,
 #endif
 }
 
-static int nftnl_expr_limit_xml_parse(struct nftnl_expr *e,
-					 mxml_node_t *tree,
-					 struct nftnl_parse_err *err)
-{
-#ifdef XML_PARSING
-	uint64_t rate, unit;
-	uint32_t burst, type, flags;
-
-	if (nftnl_mxml_num_parse(tree, "rate", MXML_DESCEND_FIRST, BASE_DEC,
-			       &rate, NFTNL_TYPE_U64, NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u64(e, NFTNL_EXPR_LIMIT_RATE, rate);
-
-	if (nftnl_mxml_num_parse(tree, "unit", MXML_DESCEND_FIRST, BASE_DEC,
-			       &unit, NFTNL_TYPE_U64, NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u64(e, NFTNL_EXPR_LIMIT_UNIT, unit);
-	if (nftnl_mxml_num_parse(tree, "burst", MXML_DESCEND_FIRST, BASE_DEC,
-			       &burst, NFTNL_TYPE_U32, NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_LIMIT_BURST, burst);
-	if (nftnl_mxml_num_parse(tree, "type", MXML_DESCEND_FIRST, BASE_DEC,
-			       &type, NFTNL_TYPE_U32, NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_LIMIT_TYPE, type);
-	if (nftnl_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST, BASE_DEC,
-			       &flags, NFTNL_TYPE_U32, NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_LIMIT_FLAGS, flags);
-
-	return 0;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
-
 static const char *get_unit(uint64_t u)
 {
 	switch (u) {
@@ -318,6 +286,5 @@ struct expr_ops expr_ops_limit = {
 	.parse		= nftnl_expr_limit_parse,
 	.build		= nftnl_expr_limit_build,
 	.snprintf	= nftnl_expr_limit_snprintf,
-	.xml_parse	= nftnl_expr_limit_xml_parse,
 	.json_parse	= nftnl_expr_limit_json_parse,
 };
diff --git a/src/expr/log.c b/src/expr/log.c
index d1e7b8d..57490d9 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -224,50 +224,6 @@ static int nftnl_expr_log_json_parse(struct nftnl_expr *e, json_t *root,
 #endif
 }
 
-static int nftnl_expr_log_xml_parse(struct nftnl_expr *e,
-				       mxml_node_t *tree,
-				       struct nftnl_parse_err *err)
-{
-#ifdef XML_PARSING
-	const char *prefix;
-	uint32_t snaplen, level, flags;
-	uint16_t group, qthreshold;
-
-	prefix = nftnl_mxml_str_parse(tree, "prefix", MXML_DESCEND_FIRST,
-				    NFTNL_XML_MAND, err);
-	if (prefix != NULL)
-		nftnl_expr_set_str(e, NFTNL_EXPR_LOG_PREFIX, prefix);
-
-	if (nftnl_mxml_num_parse(tree, "group", MXML_DESCEND_FIRST, BASE_DEC,
-			       &group, NFTNL_TYPE_U16, NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u16(e, NFTNL_EXPR_LOG_GROUP, group);
-
-	if (nftnl_mxml_num_parse(tree, "snaplen", MXML_DESCEND_FIRST, BASE_DEC,
-			       &snaplen, NFTNL_TYPE_U32, NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_LOG_SNAPLEN, snaplen);
-
-	if (nftnl_mxml_num_parse(tree, "qthreshold", MXML_DESCEND_FIRST, BASE_DEC,
-			       &qthreshold, NFTNL_TYPE_U16, NFTNL_XML_MAND,
-			       err) == 0)
-		nftnl_expr_set_u16(e, NFTNL_EXPR_LOG_QTHRESHOLD, qthreshold);
-
-	if (nftnl_mxml_num_parse(tree, "level", MXML_DESCEND_FIRST, BASE_DEC,
-			       &level, NFTNL_TYPE_U16, NFTNL_XML_MAND,
-			       err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_LOG_LEVEL, level);
-
-	if (nftnl_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST, BASE_DEC,
-			       &flags, NFTNL_TYPE_U16, NFTNL_XML_MAND,
-			       err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_LOG_FLAGS, flags);
-
-	return 0;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
-
 static int nftnl_expr_log_snprintf_default(char *buf, size_t size,
 					   const struct nftnl_expr *e)
 {
@@ -370,6 +326,5 @@ struct expr_ops expr_ops_log = {
 	.parse		= nftnl_expr_log_parse,
 	.build		= nftnl_expr_log_build,
 	.snprintf	= nftnl_expr_log_snprintf,
-	.xml_parse	= nftnl_expr_log_xml_parse,
 	.json_parse	= nftnl_expr_log_json_parse,
 };
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 1377c0c..861815f 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -197,39 +197,6 @@ nftnl_expr_lookup_json_parse(struct nftnl_expr *e, json_t *root,
 }
 
 static int
-nftnl_expr_lookup_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
-			       struct nftnl_parse_err *err)
-{
-#ifdef XML_PARSING
-	const char *set_name;
-	uint32_t sreg, dreg, flags;
-
-	set_name = nftnl_mxml_str_parse(tree, "set", MXML_DESCEND_FIRST,
-				      NFTNL_XML_MAND, err);
-	if (set_name != NULL)
-		nftnl_expr_set_str(e, NFTNL_EXPR_LOOKUP_SET, set_name);
-
-	if (nftnl_mxml_reg_parse(tree, "sreg", &sreg, MXML_DESCEND, NFTNL_XML_MAND,
-			       err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_LOOKUP_SREG, sreg);
-
-	if (nftnl_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND, NFTNL_XML_OPT,
-			       err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_LOOKUP_DREG, dreg);
-
-        if (nftnl_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST, BASE_DEC,
-				 &flags, NFTNL_TYPE_U32,
-				 NFTNL_XML_MAND, err) == 0)
-                nftnl_expr_set_u32(e, NFTNL_EXPR_LOOKUP_FLAGS, flags);
-
-	return 0;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
-
-static int
 nftnl_expr_lookup_export(char *buf, size_t size,
 			 const struct nftnl_expr *e, int type)
 {
@@ -327,6 +294,5 @@ struct expr_ops expr_ops_lookup = {
 	.parse		= nftnl_expr_lookup_parse,
 	.build		= nftnl_expr_lookup_build,
 	.snprintf	= nftnl_expr_lookup_snprintf,
-	.xml_parse	= nftnl_expr_lookup_xml_parse,
 	.json_parse	= nftnl_expr_lookup_json_parse,
 };
diff --git a/src/expr/masq.c b/src/expr/masq.c
index 77506fe..32b5ad9 100644
--- a/src/expr/masq.c
+++ b/src/expr/masq.c
@@ -155,32 +155,6 @@ nftnl_expr_masq_json_parse(struct nftnl_expr *e, json_t *root,
 #endif
 }
 
-static int
-nftnl_expr_masq_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
-			     struct nftnl_parse_err *err)
-{
-#ifdef XML_PARSING
-	uint32_t flags;
-	uint32_t reg_proto_min, reg_proto_max;
-
-	if (nftnl_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST, BASE_DEC,
-			       &flags, NFTNL_TYPE_U32, NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_MASQ_FLAGS, flags);
-	if (nftnl_mxml_reg_parse(tree, "sreg_proto_min", &reg_proto_min,
-				 MXML_DESCEND, NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_MASQ_REG_PROTO_MIN,
-				   reg_proto_min);
-	if (nftnl_mxml_reg_parse(tree, "sreg_proto_max", &reg_proto_max,
-				 MXML_DESCEND, NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_MASQ_REG_PROTO_MAX,
-				   reg_proto_max);
-
-	return 0;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
 static int nftnl_expr_masq_export(char *buf, size_t size,
 				  const struct nftnl_expr *e, int type)
 {
@@ -255,6 +229,5 @@ struct expr_ops expr_ops_masq = {
 	.parse		= nftnl_expr_masq_parse,
 	.build		= nftnl_expr_masq_build,
 	.snprintf	= nftnl_expr_masq_snprintf,
-	.xml_parse	= nftnl_expr_masq_xml_parse,
 	.json_parse	= nftnl_expr_masq_json_parse,
 };
diff --git a/src/expr/match.c b/src/expr/match.c
index c48518e..dd09e1e 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -182,26 +182,6 @@ static int nftnl_expr_match_json_parse(struct nftnl_expr *e, json_t *root,
 }
 
 
-static int nftnl_expr_match_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
-					 struct nftnl_parse_err *err)
-{
-#ifdef XML_PARSING
-	const char *name;
-
-	name = nftnl_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST,
-				  NFTNL_XML_MAND, err);
-	if (name != NULL)
-		nftnl_expr_set_str(e, NFTNL_EXPR_MT_NAME, name);
-
-	/* mt->info is ignored until other solution is reached */
-
-	return 0;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
-
 static int nftnl_expr_match_export(char *buf, size_t size,
 				   const struct nftnl_expr *e, int type)
 {
@@ -270,6 +250,5 @@ struct expr_ops expr_ops_match = {
 	.parse		= nftnl_expr_match_parse,
 	.build		= nftnl_expr_match_build,
 	.snprintf	= nftnl_expr_match_snprintf,
-	.xml_parse 	= nftnl_expr_match_xml_parse,
 	.json_parse 	= nftnl_expr_match_json_parse,
 };
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 6abf6c4..2c75841 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -215,38 +215,6 @@ static int nftnl_expr_meta_json_parse(struct nftnl_expr *e, json_t *root,
 #endif
 }
 
-
-static int nftnl_expr_meta_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
-					struct nftnl_parse_err *err)
-{
-#ifdef XML_PARSING
-	const char *key_str;
-	int key;
-	uint32_t dreg, sreg;
-
-	key_str = nftnl_mxml_str_parse(tree, "key", MXML_DESCEND_FIRST,
-				     NFTNL_XML_MAND, err);
-	if (key_str != NULL) {
-		key = str2meta_key(key_str);
-		if (key >= 0)
-			nftnl_expr_set_u32(e, NFTNL_EXPR_META_KEY, key);
-	}
-
-	if (nftnl_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND_FIRST,
-			       NFTNL_XML_OPT, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_META_DREG, dreg);
-
-	if (nftnl_mxml_reg_parse(tree, "sreg", &sreg, MXML_DESCEND_FIRST,
-			       NFTNL_XML_OPT, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_META_SREG, sreg);
-
-	return 0;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
-
 static int
 nftnl_expr_meta_snprintf_default(char *buf, size_t len,
 				 const struct nftnl_expr *e)
@@ -323,6 +291,5 @@ struct expr_ops expr_ops_meta = {
 	.parse		= nftnl_expr_meta_parse,
 	.build		= nftnl_expr_meta_build,
 	.snprintf	= nftnl_expr_meta_snprintf,
-	.xml_parse 	= nftnl_expr_meta_xml_parse,
 	.json_parse 	= nftnl_expr_meta_json_parse,
 };
diff --git a/src/expr/nat.c b/src/expr/nat.c
index 485a623..29bc3a2 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -275,60 +275,6 @@ static int nftnl_expr_nat_json_parse(struct nftnl_expr *e, json_t *root,
 #endif
 }
 
-static int nftnl_expr_nat_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
-				       struct nftnl_parse_err *err)
-{
-#ifdef XML_PARSING
-	const char *nat_type;
-	uint32_t family, nat_type_value, flags;
-	uint32_t reg_addr_min, reg_addr_max;
-	uint32_t reg_proto_min, reg_proto_max;
-
-	nat_type = nftnl_mxml_str_parse(tree, "nat_type", MXML_DESCEND_FIRST,
-				      NFTNL_XML_MAND, err);
-	if (nat_type == NULL)
-		return -1;
-
-	nat_type_value = nftnl_str2nat(nat_type);
-	if (nat_type_value < 0)
-		return -1;
-	nftnl_expr_set_u32(e, NFTNL_EXPR_NAT_TYPE, nat_type_value);
-
-	family = nftnl_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST,
-				       NFTNL_XML_MAND, err);
-	if (family < 0) {
-		mxmlDelete(tree);
-		return -1;
-	}
-	nftnl_expr_set_u32(e, NFTNL_EXPR_NAT_FAMILY, family);
-
-	if (nftnl_mxml_reg_parse(tree, "sreg_addr_min", &reg_addr_min,
-			       MXML_DESCEND, NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_NAT_REG_ADDR_MIN, reg_addr_min);
-
-	if (nftnl_mxml_reg_parse(tree, "sreg_addr_max", &reg_addr_max,
-			       MXML_DESCEND, NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_NAT_REG_ADDR_MAX, reg_addr_max);
-
-	if (nftnl_mxml_reg_parse(tree, "sreg_proto_min", &reg_proto_min,
-			       MXML_DESCEND, NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_NAT_REG_PROTO_MIN, reg_proto_min);
-
-	if (nftnl_mxml_reg_parse(tree, "sreg_proto_max", &reg_proto_max,
-			       MXML_DESCEND, NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_NAT_REG_PROTO_MAX, reg_proto_max);
-
-	if (nftnl_mxml_num_parse(tree, "flags", MXML_DESCEND, BASE_DEC, &flags,
-			       NFTNL_TYPE_U32, NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_NAT_FLAGS, flags);
-
-	return 0;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
-
 static int nftnl_expr_nat_export(char *buf, size_t size,
 				 const struct nftnl_expr *e, int type)
 {
@@ -438,6 +384,5 @@ struct expr_ops expr_ops_nat = {
 	.parse		= nftnl_expr_nat_parse,
 	.build		= nftnl_expr_nat_build,
 	.snprintf	= nftnl_expr_nat_snprintf,
-	.xml_parse	= nftnl_expr_nat_xml_parse,
 	.json_parse	= nftnl_expr_nat_json_parse,
 };
diff --git a/src/expr/numgen.c b/src/expr/numgen.c
index a23be53..cd7dd60 100644
--- a/src/expr/numgen.c
+++ b/src/expr/numgen.c
@@ -153,35 +153,6 @@ static int nftnl_expr_ng_json_parse(struct nftnl_expr *e, json_t *root,
 #endif
 }
 
-
-static int nftnl_expr_ng_xml_parse(struct nftnl_expr *e,
-				   mxml_node_t *tree,
-				   struct nftnl_parse_err *err)
-{
-#ifdef XML_PARSING
-	uint32_t dreg, modulus, type;
-
-	if (nftnl_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND_FIRST,
-				 NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_NG_DREG, dreg);
-
-	if (nftnl_mxml_num_parse(tree, "modulus", MXML_DESCEND_FIRST, BASE_DEC,
-				 &modulus, NFTNL_TYPE_U32, NFTNL_XML_MAND,
-				 err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_NG_MODULUS, modulus);
-
-	if (nftnl_mxml_num_parse(tree, "type", MXML_DESCEND_FIRST, BASE_DEC,
-				 &type, NFTNL_TYPE_U32, NFTNL_XML_MAND,
-				 err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_NG_TYPE, type);
-
-	return 0;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
-
 static int
 nftnl_expr_ng_snprintf_default(char *buf, size_t size,
 			       const struct nftnl_expr *e)
@@ -267,6 +238,5 @@ struct expr_ops expr_ops_ng = {
 	.parse		= nftnl_expr_ng_parse,
 	.build		= nftnl_expr_ng_build,
 	.snprintf	= nftnl_expr_ng_snprintf,
-	.xml_parse	= nftnl_expr_ng_xml_parse,
 	.json_parse	= nftnl_expr_ng_json_parse,
 };
diff --git a/src/expr/payload.c b/src/expr/payload.c
index c9ab5d4..17dd4cd 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -251,45 +251,6 @@ nftnl_expr_payload_json_parse(struct nftnl_expr *e, json_t *root,
 #endif
 }
 
-static int
-nftnl_expr_payload_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
-				struct nftnl_parse_err *err)
-{
-#ifdef XML_PARSING
-	const char *base_str;
-	int32_t base;
-	uint32_t dreg, offset, len;
-
-	if (nftnl_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND_FIRST,
-			       NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_PAYLOAD_DREG, dreg);
-
-	base_str = nftnl_mxml_str_parse(tree, "base", MXML_DESCEND_FIRST,
-				      NFTNL_XML_MAND, err);
-	if (base_str != NULL) {
-		base = nftnl_str2base(base_str);
-		if (base < 0)
-			return -1;
-
-		nftnl_expr_set_u32(e, NFTNL_EXPR_PAYLOAD_BASE, base);
-	}
-
-	if (nftnl_mxml_num_parse(tree, "offset", MXML_DESCEND_FIRST, BASE_DEC,
-			       &offset, NFTNL_TYPE_U32, NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_PAYLOAD_OFFSET, offset);
-
-
-	if (nftnl_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST, BASE_DEC,
-			       &len, NFTNL_TYPE_U32, NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_PAYLOAD_LEN, len);
-
-	return 0;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
-
 static int nftnl_expr_payload_export(char *buf, size_t size, uint32_t flags,
 				     const struct nftnl_expr *e, int type)
 {
@@ -370,6 +331,5 @@ struct expr_ops expr_ops_payload = {
 	.parse		= nftnl_expr_payload_parse,
 	.build		= nftnl_expr_payload_build,
 	.snprintf	= nftnl_expr_payload_snprintf,
-	.xml_parse	= nftnl_expr_payload_xml_parse,
 	.json_parse	= nftnl_expr_payload_json_parse,
 };
diff --git a/src/expr/queue.c b/src/expr/queue.c
index 033c542..281950f 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -150,35 +150,6 @@ nftnl_expr_queue_json_parse(struct nftnl_expr *e, json_t *root,
 #endif
 }
 
-static int
-nftnl_expr_queue_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
-			      struct nftnl_parse_err *err)
-{
-#ifdef XML_PARSING
-	uint16_t queue_num, queue_total, flags;
-
-	if (nftnl_mxml_num_parse(tree, "num", MXML_DESCEND_FIRST, BASE_DEC,
-			       &queue_num, NFTNL_TYPE_U16, NFTNL_XML_MAND,
-			       err) == 0)
-		nftnl_expr_set_u16(e, NFTNL_EXPR_QUEUE_NUM, queue_num);
-
-	if (nftnl_mxml_num_parse(tree, "total", MXML_DESCEND_FIRST, BASE_DEC,
-			       &queue_total, NFTNL_TYPE_U16,
-			       NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u16(e, NFTNL_EXPR_QUEUE_TOTAL, queue_total);
-
-	if (nftnl_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST, BASE_DEC,
-			       &flags, NFTNL_TYPE_U16,
-			       NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u16(e, NFTNL_EXPR_QUEUE_FLAGS, flags);
-
-	return 0;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
-
 static int nftnl_expr_queue_snprintf_default(char *buf, size_t len,
 					     const struct nftnl_expr *e)
 {
@@ -269,6 +240,5 @@ struct expr_ops expr_ops_queue = {
 	.parse		= nftnl_expr_queue_parse,
 	.build		= nftnl_expr_queue_build,
 	.snprintf	= nftnl_expr_queue_snprintf,
-	.xml_parse	= nftnl_expr_queue_xml_parse,
 	.json_parse	= nftnl_expr_queue_json_parse,
 };
diff --git a/src/expr/quota.c b/src/expr/quota.c
index 47db62f..7740b24 100644
--- a/src/expr/quota.c
+++ b/src/expr/quota.c
@@ -136,27 +136,6 @@ nftnl_expr_quota_json_parse(struct nftnl_expr *e, json_t *root,
 #endif
 }
 
-static int nftnl_expr_quota_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
-				      struct nftnl_parse_err *err)
-{
-#ifdef XML_PARSING
-	uint64_t bytes;
-	uint32_t flags;
-
-	if (nftnl_mxml_num_parse(tree, "bytes", MXML_DESCEND_FIRST, BASE_DEC,
-				 &bytes, NFTNL_TYPE_U64, NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u64(e, NFTNL_EXPR_QUOTA_BYTES, bytes);
-	if (nftnl_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST, BASE_DEC,
-				 &flags, NFTNL_TYPE_U32, NFTNL_XML_MAND,  err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_QUOTA_FLAGS, flags);
-
-	return 0;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
-
 static int nftnl_expr_quota_export(char *buf, size_t size,
 				   const struct nftnl_expr *e, int type)
 {
@@ -205,6 +184,5 @@ struct expr_ops expr_ops_quota = {
 	.parse		= nftnl_expr_quota_parse,
 	.build		= nftnl_expr_quota_build,
 	.snprintf	= nftnl_expr_quota_snprintf,
-	.xml_parse	= nftnl_expr_quota_xml_parse,
 	.json_parse	= nftnl_expr_quota_json_parse,
 };
diff --git a/src/expr/redir.c b/src/expr/redir.c
index d9dba00..d5bc179 100644
--- a/src/expr/redir.c
+++ b/src/expr/redir.c
@@ -157,32 +157,6 @@ nftnl_expr_redir_json_parse(struct nftnl_expr *e, json_t *root,
 #endif
 }
 
-static int
-nftnl_expr_redir_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
-			      struct nftnl_parse_err *err)
-{
-#ifdef XML_PARSING
-	uint32_t reg, flags;
-
-	if (nftnl_mxml_reg_parse(tree, "sreg_proto_min", &reg,
-			       MXML_DESCEND, NFTNL_XML_OPT, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_REDIR_REG_PROTO_MIN, reg);
-
-	if (nftnl_mxml_reg_parse(tree, "sreg_proto_max", &reg,
-			       MXML_DESCEND, NFTNL_XML_OPT, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_REDIR_REG_PROTO_MAX, reg);
-
-	if (nftnl_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST, BASE_DEC,
-			       &flags, NFTNL_TYPE_U32, NFTNL_XML_OPT, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_REDIR_FLAGS, flags);
-
-	return 0;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
-
 static int nftnl_expr_redir_export(char *buf, size_t size,
 				   const struct nftnl_expr *e, int type)
 {
@@ -269,6 +243,5 @@ struct expr_ops expr_ops_redir = {
 	.parse		= nftnl_expr_redir_parse,
 	.build		= nftnl_expr_redir_build,
 	.snprintf	= nftnl_expr_redir_snprintf,
-	.xml_parse	= nftnl_expr_redir_xml_parse,
 	.json_parse	= nftnl_expr_redir_json_parse,
 };
diff --git a/src/expr/reject.c b/src/expr/reject.c
index 2906082..11d8b20 100644
--- a/src/expr/reject.c
+++ b/src/expr/reject.c
@@ -137,29 +137,6 @@ nftnl_expr_reject_json_parse(struct nftnl_expr *e, json_t *root,
 #endif
 }
 
-static int
-nftnl_expr_reject_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
-			       struct nftnl_parse_err *err)
-{
-#ifdef XML_PARSING
-	uint32_t type;
-	uint8_t code;
-
-	if (nftnl_mxml_num_parse(tree, "type", MXML_DESCEND_FIRST, BASE_DEC,
-			       &type, NFTNL_TYPE_U32, NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_REJECT_TYPE, type);
-
-	if (nftnl_mxml_num_parse(tree, "code", MXML_DESCEND_FIRST, BASE_DEC,
-			       &code, NFTNL_TYPE_U8, NFTNL_XML_MAND, err) == 0)
-		nftnl_expr_set_u8(e, NFTNL_EXPR_REJECT_CODE, code);
-
-	return 0;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
-
 static int nftnl_expr_reject_snprintf_default(char *buf, size_t len,
 					      const struct nftnl_expr *e)
 {
@@ -224,6 +201,5 @@ struct expr_ops expr_ops_reject = {
 	.parse		= nftnl_expr_reject_parse,
 	.build		= nftnl_expr_reject_build,
 	.snprintf	= nftnl_expr_reject_snprintf,
-	.xml_parse	= nftnl_expr_reject_xml_parse,
 	.json_parse	= nftnl_expr_reject_json_parse,
 };
diff --git a/src/expr/target.c b/src/expr/target.c
index 5a3301c..ed4bf7d 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -182,27 +182,6 @@ nftnl_expr_target_json_parse(struct nftnl_expr *e, json_t *root,
 #endif
 }
 
-static int
-nftnl_expr_target_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
-			       struct nftnl_parse_err *err)
-{
-#ifdef XML_PARSING
-	const char *name;
-
-	name = nftnl_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST,
-				  NFTNL_XML_MAND, err);
-	if (name != NULL)
-		nftnl_expr_set_str(e, NFTNL_EXPR_TG_NAME, name);
-
-	/* tg->info is ignored until other solution is reached */
-
-	return 0;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
-
 static int nftnl_rule_exp_target_export(char *buf, size_t size,
 				        const struct nftnl_expr *e, int type)
 {
@@ -271,6 +250,5 @@ struct expr_ops expr_ops_target = {
 	.parse		= nftnl_expr_target_parse,
 	.build		= nftnl_expr_target_build,
 	.snprintf	= nftnl_expr_target_snprintf,
-	.xml_parse	= nftnl_expr_target_xml_parse,
 	.json_parse	= nftnl_expr_target_json_parse,
 };
diff --git a/src/mxml.c b/src/mxml.c
deleted file mode 100644
index 51dbf1b..0000000
--- a/src/mxml.c
+++ /dev/null
@@ -1,232 +0,0 @@
-/*
- * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
- * (C) 2013 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
- */
-#include "internal.h"
-
-#include <stdint.h>
-#include <limits.h>
-
-#include <linux/netfilter/nf_tables.h>
-#include <libnftnl/table.h>
-#include <libnftnl/chain.h>
-#include <libnftnl/rule.h>
-#include <libnftnl/expr.h>
-#include <libnftnl/set.h>
-
-#ifdef XML_PARSING
-mxml_node_t *nftnl_mxml_build_tree(const void *data, const char *treename,
-				 struct nftnl_parse_err *err, enum nftnl_parse_input input)
-{
-	mxml_node_t *tree;
-
-	switch (input) {
-	case NFTNL_PARSE_BUFFER:
-		tree = mxmlLoadString(NULL, data, MXML_OPAQUE_CALLBACK);
-		break;
-	case NFTNL_PARSE_FILE:
-		tree = mxmlLoadFile(NULL, (FILE *)data, MXML_OPAQUE_CALLBACK);
-		break;
-	default:
-		goto err;
-	}
-
-	if (tree == NULL) {
-		err->error = NFTNL_PARSE_EBADINPUT;
-		goto err;
-	}
-
-	if (tree->value.opaque != NULL &&
-	    strcmp(tree->value.opaque, treename) == 0)
-		return tree;
-
-	err->error = NFTNL_PARSE_EMISSINGNODE;
-	err->node_name = treename;
-
-	mxmlDelete(tree);
-err:
-	err->line = 0;
-	err->column = 0;
-	errno = EINVAL;
-	return NULL;
-}
-
-struct nftnl_expr *nftnl_mxml_expr_parse(mxml_node_t *node,
-					  struct nftnl_parse_err *err,
-					  struct nftnl_set_list *set_list)
-{
-	mxml_node_t *tree;
-	struct nftnl_expr *e;
-	const char *expr_name;
-	char *xml_text;
-	uint32_t set_id;
-	int ret;
-
-	expr_name = mxmlElementGetAttr(node, "type");
-	if (expr_name == NULL) {
-		err->node_name = "type";
-		err->error = NFTNL_PARSE_EMISSINGNODE;
-		goto err;
-	}
-
-	e = nftnl_expr_alloc(expr_name);
-	if (e == NULL)
-		goto err;
-
-	xml_text = mxmlSaveAllocString(node, MXML_NO_CALLBACK);
-	if (xml_text == NULL)
-		goto err_expr;
-
-	tree = mxmlLoadString(NULL, xml_text, MXML_OPAQUE_CALLBACK);
-	xfree(xml_text);
-
-	if (tree == NULL)
-		goto err_expr;
-
-	ret = e->ops->xml_parse(e, tree, err);
-	mxmlDelete(tree);
-
-	if (set_list != NULL &&
-	    strcmp(expr_name, "lookup") == 0 &&
-	    nftnl_set_lookup_id(e, set_list, &set_id))
-		nftnl_expr_set_u32(e, NFTNL_EXPR_LOOKUP_SET_ID, set_id);
-
-	return ret < 0 ? NULL : e;
-err_expr:
-	nftnl_expr_free(e);
-err:
-	mxmlDelete(tree);
-	errno = EINVAL;
-	return NULL;
-}
-
-int nftnl_mxml_reg_parse(mxml_node_t *tree, const char *reg_name, uint32_t *reg,
-		       uint32_t mxmlflags, uint32_t flags,
-		       struct nftnl_parse_err *err)
-{
-	mxml_node_t *node;
-
-	node = mxmlFindElement(tree, tree, reg_name, NULL, NULL, mxmlflags);
-	if (node == NULL) {
-		if (!(flags & NFTNL_XML_OPT)) {
-			err->error = NFTNL_PARSE_EMISSINGNODE;
-			errno = EINVAL;
-			goto err;
-		}
-		return -1;
-	}
-
-	if (nftnl_strtoi(node->child->value.opaque, BASE_DEC, reg,
-		       NFTNL_TYPE_U32) != 0) {
-		err->error = NFTNL_PARSE_EBADTYPE;
-		goto err;
-	}
-
-	if (*reg > NFT_REG_MAX) {
-		errno = ERANGE;
-		goto err;
-	}
-
-	return 0;
-err:
-	err->node_name = reg_name;
-	return -1;
-}
-
-int nftnl_mxml_data_reg_parse(mxml_node_t *tree, const char *node_name,
-			    union nftnl_data_reg *data_reg, uint16_t flags,
-			    struct nftnl_parse_err *err)
-{
-	mxml_node_t *node;
-
-	node = mxmlFindElement(tree, tree, node_name, NULL, NULL,
-			       MXML_DESCEND_FIRST);
-
-	/* It is necessary for the compatibility with cmpdata label. */
-	if (node == NULL || node->child == NULL)
-		node = tree;
-
-	return nftnl_data_reg_xml_parse(data_reg, node, err);
-}
-
-int
-nftnl_mxml_num_parse(mxml_node_t *tree, const char *node_name,
-		   uint32_t mxml_flags, int base, void *number,
-		   enum nftnl_type type, uint16_t flags,
-		   struct nftnl_parse_err *err)
-{
-	mxml_node_t *node = NULL;
-	int ret;
-
-	node = mxmlFindElement(tree, tree, node_name, NULL, NULL, mxml_flags);
-	if (node == NULL || node->child == NULL) {
-		if (!(flags & NFTNL_XML_OPT)) {
-			errno = EINVAL;
-			err->node_name = node_name;
-			err->error = NFTNL_PARSE_EMISSINGNODE;
-		}
-		return -1;
-	}
-
-	ret = nftnl_strtoi(node->child->value.opaque, base, number, type);
-
-	if (ret != 0) {
-		err->error = NFTNL_PARSE_EBADTYPE;
-		err->node_name = node_name;
-	}
-	return ret;
-}
-
-const char *nftnl_mxml_str_parse(mxml_node_t *tree, const char *node_name,
-			       uint32_t mxml_flags, uint16_t flags,
-			       struct nftnl_parse_err *err)
-{
-	mxml_node_t *node;
-	const char *ret;
-
-	node = mxmlFindElement(tree, tree, node_name, NULL, NULL, mxml_flags);
-	if (node == NULL || node->child == NULL) {
-		if (!(flags & NFTNL_XML_OPT)) {
-			errno = EINVAL;
-			err->node_name = node_name;
-			err->error = NFTNL_PARSE_EMISSINGNODE;
-		}
-		return NULL;
-	}
-
-	ret = node->child->value.opaque;
-	if (ret == NULL) {
-		err->node_name = node_name;
-		err->error = NFTNL_PARSE_EBADTYPE;
-	}
-	return ret;
-}
-
-int nftnl_mxml_family_parse(mxml_node_t *tree, const char *node_name,
-			  uint32_t mxml_flags, uint16_t flags,
-			  struct nftnl_parse_err *err)
-{
-	const char *family_str;
-	int family;
-
-	family_str = nftnl_mxml_str_parse(tree, node_name, mxml_flags,
-					flags, err);
-	if (family_str == NULL)
-		return -1;
-
-	family = nftnl_str2family(family_str);
-	if (family < 0) {
-		err->node_name = node_name;
-		errno = EAFNOSUPPORT;
-	}
-
-	return family;
-}
-#endif
diff --git a/src/rule.c b/src/rule.c
index 5d0097c..22026a4 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -609,92 +609,6 @@ static int nftnl_rule_json_parse(struct nftnl_rule *r, const void *json,
 #endif
 }
 
-#ifdef XML_PARSING
-int nftnl_mxml_rule_parse(mxml_node_t *tree, struct nftnl_rule *r,
-			struct nftnl_parse_err *err,
-			struct nftnl_set_list *set_list)
-{
-	mxml_node_t *node;
-	struct nftnl_expr *e;
-	const char *table, *chain;
-	int family;
-
-	family = nftnl_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST,
-				       NFTNL_XML_MAND, err);
-	if (family >= 0)
-		nftnl_rule_set_u32(r, NFTNL_RULE_FAMILY, family);
-
-	table = nftnl_mxml_str_parse(tree, "table", MXML_DESCEND_FIRST,
-				   NFTNL_XML_MAND, err);
-	if (table != NULL)
-		nftnl_rule_set_str(r, NFTNL_RULE_TABLE, table);
-
-	chain = nftnl_mxml_str_parse(tree, "chain", MXML_DESCEND_FIRST,
-				   NFTNL_XML_MAND, err);
-	if (chain != NULL)
-		nftnl_rule_set_str(r, NFTNL_RULE_CHAIN, chain);
-
-	if (nftnl_mxml_num_parse(tree, "handle", MXML_DESCEND_FIRST, BASE_DEC,
-			      &r->handle, NFTNL_TYPE_U64, NFTNL_XML_MAND, err) >= 0)
-		r->flags |= (1 << NFTNL_RULE_HANDLE);
-
-	if (nftnl_mxml_num_parse(tree, "compat_proto", MXML_DESCEND_FIRST,
-			       BASE_DEC, &r->compat.proto, NFTNL_TYPE_U32,
-			       NFTNL_XML_OPT, err) >= 0)
-		r->flags |= (1 << NFTNL_RULE_COMPAT_PROTO);
-
-	if (nftnl_mxml_num_parse(tree, "compat_flags", MXML_DESCEND_FIRST,
-			       BASE_DEC, &r->compat.flags, NFTNL_TYPE_U32,
-			       NFTNL_XML_OPT, err) >= 0)
-		r->flags |= (1 << NFTNL_RULE_COMPAT_FLAGS);
-
-	if (nftnl_rule_is_set(r, NFTNL_RULE_COMPAT_PROTO) !=
-			nftnl_rule_is_set(r, NFTNL_RULE_COMPAT_FLAGS)) {
-		errno = EINVAL;
-	}
-
-	if (nftnl_mxml_num_parse(tree, "position", MXML_DESCEND_FIRST,
-			       BASE_DEC, &r->position, NFTNL_TYPE_U64,
-			       NFTNL_XML_OPT, err) >= 0)
-		r->flags |= (1 << NFTNL_RULE_POSITION);
-
-	/* Iterating over <expr> */
-	for (node = mxmlFindElement(tree, tree, "expr", "type",
-				    NULL, MXML_DESCEND);
-		node != NULL;
-		node = mxmlFindElement(node, tree, "expr", "type",
-				       NULL, MXML_DESCEND)) {
-		e = nftnl_mxml_expr_parse(node, err, set_list);
-		if (e == NULL)
-			return -1;
-
-		nftnl_rule_add_expr(r, e);
-	}
-
-	return 0;
-}
-#endif
-
-static int nftnl_rule_xml_parse(struct nftnl_rule *r, const void *xml,
-			      struct nftnl_parse_err *err,
-			      enum nftnl_parse_input input,
-			      struct nftnl_set_list *set_list)
-{
-#ifdef XML_PARSING
-	int ret;
-	mxml_node_t *tree = nftnl_mxml_build_tree(xml, "rule", err, input);
-	if (tree == NULL)
-		return -1;
-
-	ret = nftnl_mxml_rule_parse(tree, r, err, set_list);
-	mxmlDelete(tree);
-	return ret;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
-
 static int nftnl_rule_do_parse(struct nftnl_rule *r, enum nftnl_parse_type type,
 			     const void *data, struct nftnl_parse_err *err,
 			     enum nftnl_parse_input input)
@@ -703,12 +617,10 @@ static int nftnl_rule_do_parse(struct nftnl_rule *r, enum nftnl_parse_type type,
 	struct nftnl_parse_err perr = {};
 
 	switch (type) {
-	case NFTNL_PARSE_XML:
-		ret = nftnl_rule_xml_parse(r, data, &perr, input, NULL);
-		break;
 	case NFTNL_PARSE_JSON:
 		ret = nftnl_rule_json_parse(r, data, &perr, input, NULL);
 		break;
+	case NFTNL_PARSE_XML:
 	default:
 		ret = -1;
 		errno = EOPNOTSUPP;
@@ -812,73 +724,6 @@ static int nftnl_rule_snprintf_json(char *buf, size_t size,
 	return offset;
 }
 
-static int nftnl_rule_snprintf_xml(char *buf, size_t size,
-				   const struct nftnl_rule *r,
-				   uint32_t type, uint32_t flags)
-{
-	int ret, len = size, offset = 0;
-	struct nftnl_expr *expr;
-
-	ret = snprintf(buf, len, "<rule>");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	if (r->flags & (1 << NFTNL_RULE_FAMILY)) {
-		ret = snprintf(buf+offset, len, "<family>%s</family>",
-			       nftnl_family2str(r->family));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (r->flags & (1 << NFTNL_RULE_TABLE)) {
-		ret = snprintf(buf+offset, len, "<table>%s</table>",
-			       r->table);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (r->flags & (1 << NFTNL_RULE_CHAIN)) {
-		ret = snprintf(buf+offset, len, "<chain>%s</chain>",
-			       r->chain);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (r->flags & (1 << NFTNL_RULE_HANDLE)) {
-		ret = snprintf(buf+offset, len, "<handle>%llu</handle>",
-			       (unsigned long long)r->handle);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (r->compat.flags != 0 || r->compat.proto != 0) {
-		ret = snprintf(buf+offset, len,
-			       "<compat_flags>%u</compat_flags>"
-			       "<compat_proto>%u</compat_proto>",
-			       r->compat.flags, r->compat.proto);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (r->flags & (1 << NFTNL_RULE_POSITION)) {
-		ret = snprintf(buf+offset, len,
-			       "<position>%"PRIu64"</position>",
-			       r->position);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	list_for_each_entry(expr, &r->expr_list, head) {
-		ret = snprintf(buf+offset, len,
-				"<expr type=\"%s\">", expr->ops->name);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-		ret = nftnl_expr_snprintf(buf+offset, len, expr,
-					     type, flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-		ret = snprintf(buf+offset, len, "</expr>");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	}
-	ret = snprintf(buf+offset, len, "</rule>");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	return offset;
-}
-
 static int nftnl_rule_snprintf_default(char *buf, size_t size,
 				       const struct nftnl_rule *r,
 				       uint32_t type, uint32_t flags)
@@ -967,14 +812,11 @@ static int nftnl_rule_cmd_snprintf(char *buf, size_t size,
 		ret = nftnl_rule_snprintf_default(buf+offset, len, r, type,
 						inner_flags);
 		break;
-	case NFTNL_OUTPUT_XML:
-		ret = nftnl_rule_snprintf_xml(buf+offset, len, r, type,
-					    inner_flags);
-		break;
 	case NFTNL_OUTPUT_JSON:
 		ret = nftnl_rule_snprintf_json(buf+offset, len, r, type,
 					     inner_flags);
 		break;
+	case NFTNL_OUTPUT_XML:
 	default:
 		return -1;
 	}
diff --git a/src/ruleset.c b/src/ruleset.c
index 2f3c110..8f3c9b2 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -47,7 +47,6 @@ struct nftnl_parse_ctx {
 	/* These fields below are not exposed to the user */
 	union {
 		json_t			*json;
-		mxml_node_t		*xml;
 	};
 
 	uint32_t format;
@@ -215,7 +214,7 @@ uint32_t nftnl_ruleset_ctx_get_u32(const struct nftnl_parse_ctx *ctx, uint16_t a
 }
 EXPORT_SYMBOL_ALIAS(nftnl_ruleset_ctx_get_u32, nft_ruleset_ctx_get_u32);
 
-#if defined(JSON_PARSING) || defined(XML_PARSING)
+#if defined(JSON_PARSING)
 static void nftnl_ruleset_ctx_set(struct nftnl_parse_ctx *ctx, uint16_t attr,
 				void *data)
 {
@@ -268,11 +267,6 @@ static int nftnl_ruleset_parse_tables(struct nftnl_parse_ctx *ctx,
 #endif
 		break;
 	case NFTNL_OUTPUT_XML:
-#ifdef XML_PARSING
-		if (nftnl_mxml_table_parse(ctx->xml, table, err) < 0)
-			goto err;
-#endif
-		break;
 	default:
 		errno = EOPNOTSUPP;
 		goto err;
@@ -306,11 +300,6 @@ static int nftnl_ruleset_parse_chains(struct nftnl_parse_ctx *ctx,
 #endif
 		break;
 	case NFTNL_OUTPUT_XML:
-#ifdef XML_PARSING
-		if (nftnl_mxml_chain_parse(ctx->xml, chain, err) < 0)
-			goto err;
-#endif
-		break;
 	default:
 		errno = EOPNOTSUPP;
 		goto err;
@@ -368,11 +357,6 @@ static int nftnl_ruleset_parse_set_elems(struct nftnl_parse_ctx *ctx,
 #endif
 		break;
 	case NFTNL_OUTPUT_XML:
-#ifdef XML_PARSING
-		if (nftnl_mxml_set_parse(ctx->xml, set, err) < 0)
-			goto err;
-#endif
-		break;
 	default:
 		errno = EOPNOTSUPP;
 		goto err;
@@ -404,11 +388,6 @@ static int nftnl_ruleset_parse_sets(struct nftnl_parse_ctx *ctx,
 #endif
 		break;
 	case NFTNL_OUTPUT_XML:
-#ifdef XML_PARSING
-		if (nftnl_mxml_set_parse(ctx->xml, set, err) < 0)
-			goto err;
-#endif
-		break;
 	default:
 		errno = EOPNOTSUPP;
 		goto err;
@@ -441,11 +420,6 @@ static int nftnl_ruleset_parse_rules(struct nftnl_parse_ctx *ctx,
 #endif
 		break;
 	case NFTNL_OUTPUT_XML:
-#ifdef XML_PARSING
-		if (nftnl_mxml_rule_parse(ctx->xml, rule, err, ctx->set_list) < 0)
-			goto err;
-#endif
-		break;
 	default:
 		errno = EOPNOTSUPP;
 		goto err;
@@ -600,126 +574,6 @@ err1:
 #endif
 }
 
-#ifdef XML_PARSING
-static int nftnl_ruleset_xml_parse_ruleset(struct nftnl_parse_ctx *ctx,
-					 struct nftnl_parse_err *err)
-{
-	const char *node_type;
-	mxml_node_t *node, *array = ctx->xml;
-	int len = 0, ret;
-
-	for (node = mxmlFindElement(array, array, NULL, NULL, NULL,
-				    MXML_DESCEND_FIRST);
-	     node != NULL;
-	     node = mxmlFindElement(node, array, NULL, NULL, NULL,
-				    MXML_NO_DESCEND)) {
-		len++;
-		node_type = node->value.opaque;
-		ctx->xml = node;
-		if (strcmp(node_type, "table") == 0)
-			ret = nftnl_ruleset_parse_tables(ctx, err);
-		else if (strcmp(node_type, "chain") == 0)
-			ret = nftnl_ruleset_parse_chains(ctx, err);
-		else if (strcmp(node_type, "set") == 0)
-			ret = nftnl_ruleset_parse_sets(ctx, err);
-		else if (strcmp(node_type, "rule") == 0)
-			ret = nftnl_ruleset_parse_rules(ctx, err);
-		else if (strcmp(node_type, "element") == 0)
-			ret = nftnl_ruleset_parse_set_elems(ctx, err);
-		else
-			return -1;
-
-		if (ret < 0)
-			return ret;
-	}
-
-	if (len == 0 && ctx->cmd == NFTNL_CMD_FLUSH) {
-		nftnl_ruleset_ctx_set_u32(ctx, NFTNL_RULESET_CTX_TYPE,
-					NFTNL_RULESET_RULESET);
-		if (ctx->cb(ctx) < 0)
-			return -1;
-	}
-
-	return 0;
-}
-
-static int nftnl_ruleset_xml_parse_cmd(const char *cmd, struct nftnl_parse_err *err,
-				     struct nftnl_parse_ctx *ctx)
-{
-	uint32_t cmdnum;
-	mxml_node_t *nodecmd;
-
-	cmdnum = nftnl_str2cmd(cmd);
-	if (cmdnum == NFTNL_CMD_UNSPEC) {
-		err->error = NFTNL_PARSE_EMISSINGNODE;
-		err->node_name = strdup(cmd);
-		return -1;
-	}
-
-	nodecmd = mxmlFindElement(ctx->xml, ctx->xml, cmd, NULL, NULL,
-				  MXML_DESCEND_FIRST);
-
-	ctx->xml = nodecmd;
-	nftnl_ruleset_ctx_set_u32(ctx, NFTNL_RULESET_CTX_CMD, cmdnum);
-
-	if (nftnl_ruleset_xml_parse_ruleset(ctx, err) != 0)
-		goto err;
-
-	return 0;
-err:
-	return -1;
-}
-#endif
-
-static int nftnl_ruleset_xml_parse(const void *xml, struct nftnl_parse_err *err,
-				 enum nftnl_parse_input input,
-				 enum nftnl_parse_type type, void *arg,
-				 int (*cb)(const struct nftnl_parse_ctx *ctx))
-{
-#ifdef XML_PARSING
-	mxml_node_t *tree, *nodecmd = NULL;
-	char *cmd;
-	struct nftnl_parse_ctx ctx;
-
-	ctx.cb = cb;
-	ctx.format = type;
-	ctx.flags = 0;
-
-	ctx.set_list = nftnl_set_list_alloc();
-	if (ctx.set_list == NULL)
-		return -1;
-
-	if (arg != NULL)
-		nftnl_ruleset_ctx_set(&ctx, NFTNL_RULESET_CTX_DATA, arg);
-
-	tree = nftnl_mxml_build_tree(xml, "nftables", err, input);
-	if (tree == NULL)
-		goto err1;
-
-	ctx.xml = tree;
-
-	nodecmd = mxmlWalkNext(tree, tree, MXML_DESCEND_FIRST);
-	while (nodecmd != NULL) {
-		cmd = nodecmd->value.opaque;
-		if (nftnl_ruleset_xml_parse_cmd(cmd, err, &ctx) < 0)
-			goto err2;
-		nodecmd = mxmlWalkNext(tree, tree, MXML_NO_DESCEND);
-	}
-
-	nftnl_set_list_free(ctx.set_list);
-	mxmlDelete(tree);
-	return 0;
-err2:
-	mxmlDelete(tree);
-err1:
-	nftnl_set_list_free(ctx.set_list);
-	return -1;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
-
 static int
 nftnl_ruleset_do_parse(enum nftnl_parse_type type, const void *data,
 		     struct nftnl_parse_err *err, enum nftnl_parse_input input,
@@ -728,12 +582,10 @@ nftnl_ruleset_do_parse(enum nftnl_parse_type type, const void *data,
 	int ret;
 
 	switch (type) {
-	case NFTNL_PARSE_XML:
-		ret = nftnl_ruleset_xml_parse(data, err, input, type, arg, cb);
-		break;
 	case NFTNL_PARSE_JSON:
 		ret = nftnl_ruleset_json_parse(data, err, input, type, arg, cb);
 		break;
+	case NFTNL_PARSE_XML:
 	default:
 		ret = -1;
 		errno = EOPNOTSUPP;
@@ -838,10 +690,9 @@ EXPORT_SYMBOL_ALIAS(nftnl_ruleset_parse_file, nft_ruleset_parse_file);
 static const char *nftnl_ruleset_o_opentag(uint32_t type)
 {
 	switch (type) {
-	case NFTNL_OUTPUT_XML:
-		return "<nftables>";
 	case NFTNL_OUTPUT_JSON:
 		return "{\"nftables\":[";
+	case NFTNL_OUTPUT_XML:
 	default:
 		return "";
 	}
@@ -865,10 +716,9 @@ static const char *nftnl_ruleset_o_separator(void *obj, uint32_t type)
 static const char *nftnl_ruleset_o_closetag(uint32_t type)
 {
 	switch (type) {
-	case NFTNL_OUTPUT_XML:
-		return "</nftables>";
 	case NFTNL_OUTPUT_JSON:
 		return "]}";
+	case NFTNL_OUTPUT_XML:
 	default:
 		return "";
 	}
@@ -1071,9 +921,9 @@ static int nftnl_ruleset_cmd_snprintf(char *buf, size_t size,
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
-	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
 		return nftnl_ruleset_do_snprintf(buf, size, r, cmd, type, flags);
+	case NFTNL_OUTPUT_XML:
 	default:
 		errno = EOPNOTSUPP;
 		return -1;
@@ -1085,11 +935,11 @@ int nftnl_ruleset_snprintf(char *buf, size_t size, const struct nftnl_ruleset *r
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
-	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
 		return nftnl_ruleset_cmd_snprintf(buf, size, r,
 						nftnl_flag2cmd(flags), type,
 						flags);
+	case NFTNL_OUTPUT_XML:
 	default:
 		errno = EOPNOTSUPP;
 		return -1;
diff --git a/src/set.c b/src/set.c
index 4581e3f..a42b713 100644
--- a/src/set.c
+++ b/src/set.c
@@ -673,109 +673,6 @@ static int nftnl_set_json_parse(struct nftnl_set *s, const void *json,
 #endif
 }
 
-#ifdef XML_PARSING
-int nftnl_mxml_set_parse(mxml_node_t *tree, struct nftnl_set *s,
-		       struct nftnl_parse_err *err)
-{
-	mxml_node_t *node = NULL;
-	struct nftnl_set_elem *elem;
-	const char *name, *table;
-	int family;
-	uint32_t set_flags, key_type, key_len;
-	uint32_t data_type, data_len, policy, size;
-
-	name = nftnl_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST,
-				  NFTNL_XML_MAND, err);
-	if (name == NULL)
-		return -1;
-	nftnl_set_set_str(s, NFTNL_SET_NAME, name);
-
-	table = nftnl_mxml_str_parse(tree, "table", MXML_DESCEND_FIRST,
-				   NFTNL_XML_MAND, err);
-	if (table == NULL)
-		return -1;
-	nftnl_set_set_str(s, NFTNL_SET_TABLE, table);
-
-	family = nftnl_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST,
-				       NFTNL_XML_MAND, err);
-	if (family >= 0)
-		nftnl_set_set_u32(s, NFTNL_SET_FAMILY, family);
-
-	if (nftnl_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST, BASE_DEC,
-			       &set_flags, NFTNL_TYPE_U32, NFTNL_XML_MAND,
-			       err) == 0)
-		nftnl_set_set_u32(s, NFTNL_SET_FLAGS, set_flags);
-
-	if (nftnl_mxml_num_parse(tree, "key_type", MXML_DESCEND_FIRST, BASE_DEC,
-			       &key_type, NFTNL_TYPE_U32, NFTNL_XML_MAND, err) == 0)
-		nftnl_set_set_u32(s, NFTNL_SET_KEY_TYPE, key_type);
-
-	if (nftnl_mxml_num_parse(tree, "key_len", MXML_DESCEND_FIRST, BASE_DEC,
-			       &key_len, NFTNL_TYPE_U32, NFTNL_XML_MAND, err) < 0)
-		return -1;
-	nftnl_set_set_u32(s, NFTNL_SET_KEY_LEN, key_len);
-
-	if (nftnl_mxml_num_parse(tree, "data_type", MXML_DESCEND_FIRST, BASE_DEC,
-			       &data_type, NFTNL_TYPE_U32,
-			       NFTNL_XML_OPT, err) == 0) {
-		nftnl_set_set_u32(s, NFTNL_SET_DATA_TYPE, data_type);
-
-		if (nftnl_mxml_num_parse(tree, "data_len", MXML_DESCEND_FIRST,
-				       BASE_DEC, &data_len, NFTNL_TYPE_U32,
-				       NFTNL_XML_MAND, err) == 0)
-			nftnl_set_set_u32(s, NFTNL_SET_DATA_LEN, data_len);
-
-	}
-
-	if (nftnl_mxml_num_parse(tree, "policy", MXML_DESCEND_FIRST,
-			       BASE_DEC, &policy, NFTNL_TYPE_U32,
-			       NFTNL_XML_OPT, err) == 0)
-		nftnl_set_set_u32(s, NFTNL_SET_POLICY, policy);
-
-	if (nftnl_mxml_num_parse(tree, "desc_size", MXML_DESCEND_FIRST,
-			       BASE_DEC, &size, NFTNL_TYPE_U32,
-			       NFTNL_XML_OPT, err) == 0)
-		nftnl_set_set_u32(s, NFTNL_SET_DESC_SIZE, policy);
-
-	for (node = mxmlFindElement(tree, tree, "set_elem", NULL,
-				    NULL, MXML_DESCEND);
-		node != NULL;
-		node = mxmlFindElement(node, tree, "set_elem", NULL,
-				       NULL, MXML_DESCEND)) {
-
-		elem = nftnl_set_elem_alloc();
-		if (elem == NULL)
-			return -1;
-
-		if (nftnl_mxml_set_elem_parse(node, elem, err) < 0)
-			return -1;
-
-		list_add_tail(&elem->head, &s->element_list);
-	}
-
-	return 0;
-}
-#endif
-
-static int nftnl_set_xml_parse(struct nftnl_set *s, const void *xml,
-			     struct nftnl_parse_err *err,
-			     enum nftnl_parse_input input)
-{
-#ifdef XML_PARSING
-	int ret;
-	mxml_node_t *tree = nftnl_mxml_build_tree(xml, "set", err, input);
-	if (tree == NULL)
-		return -1;
-
-	ret = nftnl_mxml_set_parse(tree, s, err);
-	mxmlDelete(tree);
-	return ret;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
-
 static int nftnl_set_do_parse(struct nftnl_set *s, enum nftnl_parse_type type,
 			    const void *data, struct nftnl_parse_err *err,
 			    enum nftnl_parse_input input)
@@ -784,12 +681,10 @@ static int nftnl_set_do_parse(struct nftnl_set *s, enum nftnl_parse_type type,
 	struct nftnl_parse_err perr = {};
 
 	switch (type) {
-	case NFTNL_PARSE_XML:
-		ret = nftnl_set_xml_parse(s, data, &perr, input);
-		break;
 	case NFTNL_PARSE_JSON:
 		ret = nftnl_set_json_parse(s, data, &perr, input);
 		break;
+	case NFTNL_PARSE_XML:
 	default:
 		ret = -1;
 		errno = EOPNOTSUPP;
@@ -959,87 +854,6 @@ static int nftnl_set_snprintf_default(char *buf, size_t size,
 	return offset;
 }
 
-static int nftnl_set_snprintf_xml(char *buf, size_t size,
-				  const struct nftnl_set *s, uint32_t flags)
-{
-	int ret;
-	int len = size, offset = 0;
-	struct nftnl_set_elem *elem;
-
-	ret = snprintf(buf, len, "<set>");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	if (s->flags & (1 << NFTNL_SET_FAMILY)) {
-		ret = snprintf(buf + offset, len, "<family>%s</family>",
-			       nftnl_family2str(s->family));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (s->flags & (1 << NFTNL_SET_TABLE)) {
-		ret = snprintf(buf + offset, len, "<table>%s</table>",
-			       s->table);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (s->flags & (1 << NFTNL_SET_NAME)) {
-		ret = snprintf(buf + offset, len, "<name>%s</name>",
-			       s->name);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (s->flags & (1 << NFTNL_SET_FLAGS)) {
-		ret = snprintf(buf + offset, len, "<flags>%u</flags>",
-			       s->set_flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (s->flags & (1 << NFTNL_SET_KEY_TYPE)) {
-		ret = snprintf(buf + offset, len, "<key_type>%u</key_type>",
-			       s->key_type);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (s->flags & (1 << NFTNL_SET_KEY_LEN)) {
-		ret = snprintf(buf + offset, len, "<key_len>%u</key_len>",
-			       s->key_len);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (s->flags & (1 << NFTNL_SET_DATA_TYPE)) {
-		ret = snprintf(buf + offset, len, "<data_type>%u</data_type>",
-			       s->data_type);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (s->flags & (1 << NFTNL_SET_DATA_LEN)) {
-		ret = snprintf(buf + offset, len, "<data_len>%u</data_len>",
-			       s->data_len);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (s->flags & (1 << NFTNL_SET_POLICY)) {
-		ret = snprintf(buf + offset, len, "<policy>%u</policy>",
-			       s->policy);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (s->flags & (1 << NFTNL_SET_DESC_SIZE)) {
-		ret = snprintf(buf + offset, len, "<desc_size>%u</desc_size>",
-			       s->desc.size);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (!list_empty(&s->element_list)) {
-		list_for_each_entry(elem, &s->element_list, head) {
-			ret = nftnl_set_elem_snprintf(buf + offset, len, elem,
-						    NFTNL_OUTPUT_XML, flags);
-			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-		}
-	}
-
-	ret = snprintf(buf + offset, len, "</set>");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	return offset;
-}
-
 static int nftnl_set_cmd_snprintf(char *buf, size_t size,
 				  const struct nftnl_set *s, uint32_t cmd,
 				  uint32_t type, uint32_t flags)
@@ -1047,6 +861,9 @@ static int nftnl_set_cmd_snprintf(char *buf, size_t size,
 	int ret, len = size, offset = 0;
 	uint32_t inner_flags = flags;
 
+	if (type == NFTNL_OUTPUT_XML)
+		return 0;
+
 	/* prevent set_elems to print as events */
 	inner_flags &= ~NFTNL_OF_EVENT_ANY;
 
@@ -1058,9 +875,6 @@ static int nftnl_set_cmd_snprintf(char *buf, size_t size,
 		ret = nftnl_set_snprintf_default(buf+offset, len, s, type,
 					       inner_flags);
 		break;
-	case NFTNL_OUTPUT_XML:
-		ret = nftnl_set_snprintf_xml(buf+offset, len, s, inner_flags);
-		break;
 	case NFTNL_OUTPUT_JSON:
 		ret = nftnl_set_snprintf_json(buf+offset, len, s, type,
 					    inner_flags);
diff --git a/src/set_elem.c b/src/set_elem.c
index db63a05..46fb7c6 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -518,62 +518,6 @@ int nftnl_set_elems_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_set *s)
 }
 EXPORT_SYMBOL_ALIAS(nftnl_set_elems_nlmsg_parse, nft_set_elems_nlmsg_parse);
 
-#ifdef XML_PARSING
-int nftnl_mxml_set_elem_parse(mxml_node_t *tree, struct nftnl_set_elem *e,
-			    struct nftnl_parse_err *err)
-{
-	int set_elem_data;
-	uint32_t set_elem_flags;
-
-	if (nftnl_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST, BASE_DEC,
-			       &set_elem_flags, NFTNL_TYPE_U32, NFTNL_XML_MAND,
-			       err) == 0)
-		nftnl_set_elem_set_u32(e, NFTNL_SET_ELEM_FLAGS, set_elem_flags);
-
-	if (nftnl_mxml_data_reg_parse(tree, "key", &e->key,
-				    NFTNL_XML_MAND, err) == DATA_VALUE)
-		e->flags |= (1 << NFTNL_SET_ELEM_KEY);
-
-	/* <set_elem_data> is not mandatory */
-	set_elem_data = nftnl_mxml_data_reg_parse(tree, "data",
-						&e->data, NFTNL_XML_OPT, err);
-	switch (set_elem_data) {
-	case DATA_VALUE:
-		e->flags |= (1 << NFTNL_SET_ELEM_DATA);
-		break;
-	case DATA_VERDICT:
-		e->flags |= (1 << NFTNL_SET_ELEM_VERDICT);
-		if (e->data.chain != NULL)
-			e->flags |= (1 << NFTNL_SET_ELEM_CHAIN);
-
-		break;
-	}
-
-	return 0;
-}
-#endif
-
-static int nftnl_set_elem_xml_parse(struct nftnl_set_elem *e, const void *xml,
-				  struct nftnl_parse_err *err,
-				  enum nftnl_parse_input input)
-{
-#ifdef XML_PARSING
-	mxml_node_t *tree;
-	int ret;
-
-	tree = nftnl_mxml_build_tree(xml, "set_elem", err, input);
-	if (tree == NULL)
-		return -1;
-
-	ret = nftnl_mxml_set_elem_parse(tree, e, err);
-	mxmlDelete(tree);
-	return ret;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
-
 static int nftnl_set_elem_json_parse(struct nftnl_set_elem *e, const void *json,
 				   struct nftnl_parse_err *err,
 				   enum nftnl_parse_input input)
@@ -601,12 +545,10 @@ nftnl_set_elem_do_parse(struct nftnl_set_elem *e, enum nftnl_parse_type type,
 	int ret;
 
 	switch (type) {
-	case NFTNL_PARSE_XML:
-		ret = nftnl_set_elem_xml_parse(e, data, err, input);
-		break;
 	case NFTNL_PARSE_JSON:
 		ret = nftnl_set_elem_json_parse(e, data, err, input);
 		break;
+	case NFTNL_PARSE_XML:
 	default:
 		errno = EOPNOTSUPP;
 		ret = -1;
@@ -715,58 +657,6 @@ static int nftnl_set_elem_snprintf_default(char *buf, size_t size,
 	return offset;
 }
 
-static int nftnl_set_elem_snprintf_xml(char *buf, size_t size,
-				       const struct nftnl_set_elem *e,
-				       uint32_t flags)
-{
-	int ret, len = size, offset = 0, type = DATA_NONE;
-
-	ret = snprintf(buf, size, "<set_elem>");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	if (e->flags & (1 << NFTNL_SET_ELEM_FLAGS)) {
-		ret = snprintf(buf + offset, size, "<flags>%u</flags>",
-			       e->set_elem_flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (e->flags & (1 << NFTNL_SET_ELEM_KEY)) {
-		ret = snprintf(buf + offset, len, "<key>");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-		ret = nftnl_data_reg_snprintf(buf + offset, len, &e->key,
-					    NFTNL_OUTPUT_XML, flags, DATA_VALUE);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-		ret = snprintf(buf + offset, len, "</key>");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (e->flags & (1 << NFTNL_SET_ELEM_DATA))
-		type = DATA_VALUE;
-	else if (e->flags & (1 << NFTNL_SET_ELEM_CHAIN))
-		type = DATA_CHAIN;
-	else if (e->flags & (1 << NFTNL_SET_ELEM_VERDICT))
-		type = DATA_VERDICT;
-
-	if (type != DATA_NONE) {
-		ret = snprintf(buf + offset, len, "<data>");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-		ret = nftnl_data_reg_snprintf(buf + offset, len, &e->data,
-					    NFTNL_OUTPUT_XML, flags, type);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-		ret = snprintf(buf + offset, len, "</data>");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	ret = snprintf(buf + offset, len, "</set_elem>");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	return offset;
-}
-
 static int nftnl_set_elem_cmd_snprintf(char *buf, size_t size,
 				       const struct nftnl_set_elem *e,
 				       uint32_t cmd, uint32_t type,
@@ -774,6 +664,9 @@ static int nftnl_set_elem_cmd_snprintf(char *buf, size_t size,
 {
 	int ret, len = size, offset = 0;
 
+	if (type == NFTNL_OUTPUT_XML)
+		return 0;
+
 	ret = nftnl_cmd_header_snprintf(buf + offset, len, cmd, type, flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
@@ -781,9 +674,6 @@ static int nftnl_set_elem_cmd_snprintf(char *buf, size_t size,
 	case NFTNL_OUTPUT_DEFAULT:
 		ret = nftnl_set_elem_snprintf_default(buf+offset, len, e);
 		break;
-	case NFTNL_OUTPUT_XML:
-		ret = nftnl_set_elem_snprintf_xml(buf+offset, len, e, flags);
-		break;
 	case NFTNL_OUTPUT_JSON:
 		ret = nftnl_set_elem_snprintf_json(buf+offset, len, e, flags);
 		break;
diff --git a/src/table.c b/src/table.c
index 845fd68..4286d51 100644
--- a/src/table.c
+++ b/src/table.c
@@ -251,55 +251,6 @@ int nftnl_table_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_table *t)
 }
 EXPORT_SYMBOL_ALIAS(nftnl_table_nlmsg_parse, nft_table_nlmsg_parse);
 
-#ifdef XML_PARSING
-int nftnl_mxml_table_parse(mxml_node_t *tree, struct nftnl_table *t,
-			 struct nftnl_parse_err *err)
-{
-	const char *name;
-	int family;
-	uint32_t flags, use;
-
-	name = nftnl_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST,
-				  NFTNL_XML_MAND, err);
-	if (name != NULL)
-		nftnl_table_set_str(t, NFTNL_TABLE_NAME, name);
-
-	family = nftnl_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST,
-				       NFTNL_XML_MAND, err);
-	if (family >= 0)
-		nftnl_table_set_u32(t, NFTNL_TABLE_FAMILY, family);
-
-	if (nftnl_mxml_num_parse(tree, "flags", MXML_DESCEND, BASE_DEC,
-			       &flags, NFTNL_TYPE_U32, NFTNL_XML_MAND, err) == 0)
-		nftnl_table_set_u32(t, NFTNL_TABLE_FLAGS, flags);
-
-	if (nftnl_mxml_num_parse(tree, "use", MXML_DESCEND, BASE_DEC,
-			       &use, NFTNL_TYPE_U32, NFTNL_XML_MAND, err) == 0)
-		nftnl_table_set_u32(t, NFTNL_TABLE_USE, use);
-
-	return 0;
-}
-#endif
-
-static int nftnl_table_xml_parse(struct nftnl_table *t, const void *data,
-			       struct nftnl_parse_err *err,
-			       enum nftnl_parse_input input)
-{
-#ifdef XML_PARSING
-	int ret;
-	mxml_node_t *tree = nftnl_mxml_build_tree(data, "table", err, input);
-	if (tree == NULL)
-		return -1;
-
-	ret = nftnl_mxml_table_parse(tree, t, err);
-	mxmlDelete(tree);
-	return ret;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
-}
-
 #ifdef JSON_PARSING
 int nftnl_jansson_parse_table(struct nftnl_table *t, json_t *tree,
 			    struct nftnl_parse_err *err)
@@ -363,12 +314,10 @@ static int nftnl_table_do_parse(struct nftnl_table *t, enum nftnl_parse_type typ
 	struct nftnl_parse_err perr = {};
 
 	switch (type) {
-	case NFTNL_PARSE_XML:
-		ret = nftnl_table_xml_parse(t, data, &perr, input);
-		break;
 	case NFTNL_PARSE_JSON:
 		ret = nftnl_table_json_parse(t, data, &perr, input);
 		break;
+	case NFTNL_PARSE_XML:
 	default:
 		ret = -1;
 		errno = EOPNOTSUPP;
diff --git a/tests/Makefile.am b/tests/Makefile.am
index e5588c9..99d2974 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -1,8 +1,7 @@
 include $(top_srcdir)/Make_global.am
 
 EXTRA_DIST =		test-script.sh			\
-			jsonfiles			\
-			xmlfiles
+			jsonfiles
 
 check_PROGRAMS = 	nft-parsing-test		\
 			nft-table-test			\
@@ -35,7 +34,7 @@ check_PROGRAMS = 	nft-parsing-test		\
 			nft-expr_hash-test
 
 nft_parsing_test_SOURCES = nft-parsing-test.c
-nft_parsing_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS} ${LIBXML_LIBS} ${LIBJSON_LIBS}
+nft_parsing_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS} ${LIBJSON_LIBS}
 
 nft_table_test_SOURCES = nft-table-test.c
 nft_table_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index ce3dc4d..d25a73e 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -144,43 +144,6 @@ failparsing:
 	return -1;
 }
 
-static int test_xml(const char *filename, struct nftnl_parse_err *err)
-{
-	int ret = -1;
-	struct nftnl_ruleset *rs;
-	FILE *fp;
-
-	fp = fopen(filename, "r");
-	if (fp == NULL) {
-		printf("unable to open file %s: %s\n", filename,
-		       strerror(errno));
-		return -1;
-	}
-
-	rs = nftnl_ruleset_alloc();
-	if (rs == NULL) {
-		perror("nftnl_ruleset_alloc");
-		return -1;
-	}
-
-	if (nftnl_ruleset_parse_file(rs, NFTNL_PARSE_XML, fp, err) == 0)
-		ret = compare_test(TEST_XML_RULESET, rs, filename, fp);
-	else
-		goto failparsing;
-
-	nftnl_ruleset_free(rs);
-	fclose(fp);
-
-	return ret;
-
-failparsing:
-	fclose(fp);
-	printf("parsing %s: ", filename);
-	printf("\033[31mFAILED\e[0m (%s)\n", strerror(errno));
-	nftnl_parse_perror("Reason", err);
-	return -1;
-}
-
 static int execute_test(const char *dir_name)
 {
 	DIR *d;
@@ -210,16 +173,6 @@ static int execute_test(const char *dir_name)
 
 		snprintf(path, sizeof(path), "%s/%s", dir_name, dent->d_name);
 
-		if (strcmp(&dent->d_name[len-4], ".xml") == 0) {
-			if ((ret = test_xml(path, err)) == 0) {
-				if (!update) {
-					printf("parsing and validating %s: ",
-					       path);
-					printf("\033[32mOK\e[0m\n");
-				}
-			}
-			exit_code += ret;
-		}
 		if (strcmp(&dent->d_name[len-5], ".json") == 0) {
 			if ((ret = test_json(path, err)) == 0) {
 				if (!update) {
@@ -244,8 +197,8 @@ static int execute_test(const char *dir_name)
 static int execute_test_file(const char *filename)
 {
 	char path[PATH_MAX];
-	int ret = 0;
 	struct nftnl_parse_err *err;
+	int ret = 0, len;
 
 	err = nftnl_parse_err_alloc();
 	if (err == NULL) {
@@ -255,18 +208,7 @@ static int execute_test_file(const char *filename)
 
 	snprintf(path, sizeof(path), "%s", filename);
 
-	int len = strlen(filename);
-	if (strcmp(&filename[len-4], ".xml") == 0) {
-		if ((ret = test_xml(path, err)) == 0) {
-			if (!update) {
-				printf("parsing and validating %s: ",
-				       path);
-				printf("\033[32mOK\e[0m\n");
-			}
-		}
-		nftnl_parse_err_free(err);
-		exit(EXIT_FAILURE);
-	}
+	len = strlen(filename);
 	if (strcmp(&filename[len-5], ".json") == 0) {
 		if ((ret = test_json(path, err)) == 0) {
 			if (!update) {
diff --git a/tests/test-script.sh b/tests/test-script.sh
index dcd9080..1c93e93 100755
--- a/tests/test-script.sh
+++ b/tests/test-script.sh
@@ -26,5 +26,4 @@
 ./nft-rule-test
 ./nft-set-test
 ./nft-table-test
-./nft-parsing-test -d xmlfiles
 ./nft-parsing-test -d jsonfiles
diff --git a/tests/xmlfiles/01-table.xml b/tests/xmlfiles/01-table.xml
deleted file mode 100644
index c83c4e2..0000000
--- a/tests/xmlfiles/01-table.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><table><name>filter</name><family>ip</family><flags>0</flags><use>0</use></table></add></nftables>
diff --git a/tests/xmlfiles/02-table.xml b/tests/xmlfiles/02-table.xml
deleted file mode 100644
index 99dc6df..0000000
--- a/tests/xmlfiles/02-table.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><table><name>nat</name><family>ip6</family><flags>0</flags><use>0</use></table></add></nftables>
diff --git a/tests/xmlfiles/10-chain.xml b/tests/xmlfiles/10-chain.xml
deleted file mode 100644
index 8ae807b..0000000
--- a/tests/xmlfiles/10-chain.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><chain><name>test</name><handle>0</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family><type>filter</type><hooknum>input</hooknum><prio>0</prio><policy>accept</policy></chain></add></nftables>
diff --git a/tests/xmlfiles/11-chain.xml b/tests/xmlfiles/11-chain.xml
deleted file mode 100644
index d48fa40..0000000
--- a/tests/xmlfiles/11-chain.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><chain><name>test</name><handle>0</handle><bytes>59</bytes><packets>1</packets><table>filter</table><family>ip6</family><type>filter</type><hooknum>forward</hooknum><prio>0</prio><policy>drop</policy></chain></add></nftables>
diff --git a/tests/xmlfiles/12-chain.xml b/tests/xmlfiles/12-chain.xml
deleted file mode 100644
index 448feb2..0000000
--- a/tests/xmlfiles/12-chain.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><chain><name>foo</name><handle>100</handle><bytes>59264154979</bytes><packets>2548796325</packets><table>nat</table><family>ip</family><type>nat</type><hooknum>postrouting</hooknum><prio>0</prio><policy>accept</policy></chain></add></nftables>
diff --git a/tests/xmlfiles/20-rule-bitwise.xml b/tests/xmlfiles/20-rule-bitwise.xml
deleted file mode 100644
index 69ff702..0000000
--- a/tests/xmlfiles/20-rule-bitwise.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><reg type="value"><len>4</len><data0>0x0000000a</data0></reg></mask><xor><reg type="value"><len>4</len><data0>0x00000000</data0></reg></xor></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/21-rule-byteorder.xml b/tests/xmlfiles/21-rule-byteorder.xml
deleted file mode 100644
index 2c30ad7..0000000
--- a/tests/xmlfiles/21-rule-byteorder.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>test</table><chain>test</chain><handle>1000</handle><expr type="byteorder"><sreg>3</sreg><dreg>4</dreg><op>hton</op><len>4</len><size>4</size></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/22-rule-cmp.xml b/tests/xmlfiles/22-rule-cmp.xml
deleted file mode 100644
index 103b7da..0000000
--- a/tests/xmlfiles/22-rule-cmp.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>36</handle><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x6e6f6200</data1><data2>0x2e303164</data2><data3>0x00393331</data3></reg></data></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/23-rule-counter.xml b/tests/xmlfiles/23-rule-counter.xml
deleted file mode 100644
index c6708c6..0000000
--- a/tests/xmlfiles/23-rule-counter.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>39</handle><expr type="counter"><pkts>3</pkts><bytes>177</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/24-rule-ct.xml b/tests/xmlfiles/24-rule-ct.xml
deleted file mode 100644
index 832ae2f..0000000
--- a/tests/xmlfiles/24-rule-ct.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="ct"><dreg>1</dreg><key>state</key><dir>original</dir></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/25-rule-exthdr.xml b/tests/xmlfiles/25-rule-exthdr.xml
deleted file mode 100644
index 483d269..0000000
--- a/tests/xmlfiles/25-rule-exthdr.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip6</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="exthdr"><dreg>1</dreg><exthdr_type>mh</exthdr_type><offset>2</offset><len>16</len></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/26-rule-immediate.xml b/tests/xmlfiles/26-rule-immediate.xml
deleted file mode 100644
index fa5b3e7..0000000
--- a/tests/xmlfiles/26-rule-immediate.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>input</chain><handle>32</handle><expr type="immediate"><dreg>0</dreg><data><reg type="verdict"><verdict>accept</verdict></reg></data></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/27-rule-limit.xml b/tests/xmlfiles/27-rule-limit.xml
deleted file mode 100644
index e186204..0000000
--- a/tests/xmlfiles/27-rule-limit.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="limit"><rate>123123</rate><unit>321321</unit></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/28-rule-log.xml b/tests/xmlfiles/28-rule-log.xml
deleted file mode 100644
index 9a11bbb..0000000
--- a/tests/xmlfiles/28-rule-log.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>96</handle><expr type="log"><prefix>test_chain</prefix><group>1</group></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/29-rule-lookup.xml b/tests/xmlfiles/29-rule-lookup.xml
deleted file mode 100644
index 2074908..0000000
--- a/tests/xmlfiles/29-rule-lookup.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>37</handle><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/30-rule-match.xml b/tests/xmlfiles/30-rule-match.xml
deleted file mode 100644
index 094f913..0000000
--- a/tests/xmlfiles/30-rule-match.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="match"><name>state</name></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/31-rule-meta.xml b/tests/xmlfiles/31-rule-meta.xml
deleted file mode 100644
index 1b9e1fa..0000000
--- a/tests/xmlfiles/31-rule-meta.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>36</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/32-rule-nat6.xml b/tests/xmlfiles/32-rule-nat6.xml
deleted file mode 100644
index 5a71148..0000000
--- a/tests/xmlfiles/32-rule-nat6.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip6</family><table>nat</table><chain>OUTPUT</chain><handle>100</handle><expr type="nat"><nat_type>snat</nat_type><family>ip6</family><sreg_addr_min>1</sreg_addr_min><sreg_addr_max>2</sreg_addr_max><sreg_proto_min>3</sreg_proto_min><sreg_proto_max>4</sreg_proto_max></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/33-rule-nat4.xml b/tests/xmlfiles/33-rule-nat4.xml
deleted file mode 100644
index c55618b..0000000
--- a/tests/xmlfiles/33-rule-nat4.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="nat"><nat_type>dnat</nat_type><family>ip</family><sreg_addr_min>1</sreg_addr_min><sreg_addr_max>2</sreg_addr_max><sreg_proto_min>3</sreg_proto_min><sreg_proto_max>4</sreg_proto_max><flags>12</flags></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/34-rule-payload.xml b/tests/xmlfiles/34-rule-payload.xml
deleted file mode 100644
index 34084d0..0000000
--- a/tests/xmlfiles/34-rule-payload.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>34</handle><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/35-rule-target.xml b/tests/xmlfiles/35-rule-target.xml
deleted file mode 100644
index 8bcfeb0..0000000
--- a/tests/xmlfiles/35-rule-target.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="target"><name>LOG</name></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/36-rule-real.xml b/tests/xmlfiles/36-rule-real.xml
deleted file mode 100644
index 54db02b..0000000
--- a/tests/xmlfiles/36-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>22</handle><expr type="payload"><dreg>1</dreg><offset>12</offset><len>8</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>8</len><data0>0x0100a8c0</data0><data1>0x6400a8c0</data1></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/37-rule-real.xml b/tests/xmlfiles/37-rule-real.xml
deleted file mode 100644
index 97882b9..0000000
--- a/tests/xmlfiles/37-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>25</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>2</len><data0>0x00001600</data0></reg></data></expr><expr type=
 "ct"><dreg>1</dreg><key>state</key><dir>original</dir></expr><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><reg type="value"><len>4</len><data0>0x0000000a</data0></reg><
 /mask><xor><reg type="value"><len>4</len><data0>0x00000000</data0></reg></xor></expr><expr type="cmp"><sreg>1</sreg><op>neq</op><data><reg type="value"><len>4</len><data0>0x00000000</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>testprefix</prefix><group>1</group></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/38-rule-real.xml b/tests/xmlfiles/38-rule-real.xml
deleted file mode 100644
index 49ab7b5..0000000
--- a/tests/xmlfiles/38-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>30</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="lookup"><set>set3</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>2</len><data0>0x0000bb01</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><data><re
 g type="verdict"><verdict>accept</verdict></reg></data></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/39-rule-real.xml b/tests/xmlfiles/39-rule-real.xml
deleted file mode 100644
index fa63b28..0000000
--- a/tests/xmlfiles/39-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>31</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x6f620000</data2><data3>0x0030646e</data3></reg></data></expr><expr type="meta"><dreg>1</dreg><key>oifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x62000000</data1><data2>0x31646e6f</data2><data3>0x0037322e</data3></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>8</offset><len>16</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>16</len><data0>0xc09a00
 2a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x50010000</data3></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>6</offset><len>1</len><base>network</base>
 </expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000011</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>2</len><data0>0x00003500</data0></reg></data></expr><expr type="ct"><dreg>1</dreg><key>status</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000001</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>dns_drop</prefix><group>2</group></expr><expr type="immediate"><dreg>0</dreg><data><reg type="verdict"><verdict>drop</verdict></reg></data></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/40-rule-real.xml b/tests/xmlfiles/40-rule-real.xml
deleted file mode 100644
index 55f195b..0000000
--- a/tests/xmlfiles/40-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>2</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x0100a8c0</data0></reg></data></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/41-rule-real.xml b/tests/xmlfiles/41-rule-real.xml
deleted file mode 100644
index 87dc713..0000000
--- a/tests/xmlfiles/41-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>3</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>gte</op><data><reg type="value"><len>4</len><data0>0x0100a8c0</data0></reg></data></expr><expr type="cmp"><sreg>1</sreg><op>lte</op><data><reg type="value"><len>4</len><data0>0xfa00a8c0</data0></reg></data></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/42-rule-real.xml b/tests/xmlfiles/42-rule-real.xml
deleted file mode 100644
index 7f66ab8..0000000
--- a/tests/xmlfiles/42-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>4</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x0100a8c0</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/43-rule-real.xml b/tests/xmlfiles/43-rule-real.xml
deleted file mode 100644
index fd9ac33..0000000
--- a/tests/xmlfiles/43-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>5</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x0100a8c0</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><data><reg type="verdict"><verdict>drop</verdict></reg></data></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/44-rule-real.xml b/tests/xmlfiles/44-rule-real.xml
deleted file mode 100644
index ce026d0..0000000
--- a/tests/xmlfiles/44-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>6</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x0100a8c0</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/45-rule-real.xml b/tests/xmlfiles/45-rule-real.xml
deleted file mode 100644
index 0448be6..0000000
--- a/tests/xmlfiles/45-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>7</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>2</len><data0>0x00001600</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/46-rule-real.xml b/tests/xmlfiles/46-rule-real.xml
deleted file mode 100644
index 973df55..0000000
--- a/tests/xmlfiles/46-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>8</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>4</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x16000004</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/47-rule-real.xml b/tests/xmlfiles/47-rule-real.xml
deleted file mode 100644
index 0d35fd9..0000000
--- a/tests/xmlfiles/47-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>9</handle><expr type="payload"><dreg>1</dreg><offset>12</offset><len>8</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>8</len><data0>0x0100a8c0</data0><data1>0x6400a8c0</data1></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/48-rule-real.xml b/tests/xmlfiles/48-rule-real.xml
deleted file mode 100644
index ebcd219..0000000
--- a/tests/xmlfiles/48-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>10</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>8</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>8</len><data0>0x16000004</data0><data1>0x00000000</data1></reg></data></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/49-rule-real.xml b/tests/xmlfiles/49-rule-real.xml
deleted file mode 100644
index 5fdf0d8..0000000
--- a/tests/xmlfiles/49-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>11</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>8</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>8</len><data0>0x16000004</data0><data1>0x00000000</data1></reg></data></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/50-rule-real.xml b/tests/xmlfiles/50-rule-real.xml
deleted file mode 100644
index 0ac1ac0..0000000
--- a/tests/xmlfiles/50-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>12</handle><expr type="ct"><dreg>1</dreg><key>state</key><dir>original</dir></expr><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><reg type="value"><len>4</len><data0>0x0000000a</data0></reg></mask><xor><reg type="value"><len>4</len><data0>0x00000000</data0></reg></xor></expr><expr type="cmp"><sreg>1</sreg><op>neq</op><data><reg type="value"><len>4</len><data0>0x00000000</data0></reg></data></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/51-rule-real.xml b/tests/xmlfiles/51-rule-real.xml
deleted file mode 100644
index 3976636..0000000
--- a/tests/xmlfiles/51-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>13</handle><expr type="ct"><dreg>1</dreg><key>direction</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000000</data0></reg></data></expr><expr type="counter"><pkts>5</pkts><bytes>160</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/52-rule-real.xml b/tests/xmlfiles/52-rule-real.xml
deleted file mode 100644
index 889415a..0000000
--- a/tests/xmlfiles/52-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>14</handle><expr type="ct"><dreg>1</dreg><key>direction</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000001</data0></reg></data></expr><expr type="counter"><pkts>50</pkts><bytes>11247</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/53-rule-real.xml b/tests/xmlfiles/53-rule-real.xml
deleted file mode 100644
index a484270..0000000
--- a/tests/xmlfiles/53-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>15</handle><expr type="ct"><dreg>1</dreg><key>status</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000001</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/54-rule-real.xml b/tests/xmlfiles/54-rule-real.xml
deleted file mode 100644
index 6859ac2..0000000
--- a/tests/xmlfiles/54-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>16</handle><expr type="ct"><dreg>1</dreg><key>mark</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000064</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/55-rule-real.xml b/tests/xmlfiles/55-rule-real.xml
deleted file mode 100644
index 8ee83e4..0000000
--- a/tests/xmlfiles/55-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>17</handle><expr type="ct"><dreg>1</dreg><key>secmark</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000000</data0></reg></data></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/56-rule-real.xml b/tests/xmlfiles/56-rule-real.xml
deleted file mode 100644
index be0b868..0000000
--- a/tests/xmlfiles/56-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>18</handle><expr type="ct"><dreg>1</dreg><key>expiration</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x0000001e</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/57-rule-real.xml b/tests/xmlfiles/57-rule-real.xml
deleted file mode 100644
index 7a1d68f..0000000
--- a/tests/xmlfiles/57-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>19</handle><expr type="ct"><dreg>1</dreg><key>helper</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00707466</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/58-rule-real.xml b/tests/xmlfiles/58-rule-real.xml
deleted file mode 100644
index d32ed8f..0000000
--- a/tests/xmlfiles/58-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>20</handle><expr type="meta"><dreg>1</dreg><key>len</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x000003e8</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/59-rule-real.xml b/tests/xmlfiles/59-rule-real.xml
deleted file mode 100644
index dc86dfb..0000000
--- a/tests/xmlfiles/59-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>21</handle><expr type="meta"><dreg>1</dreg><key>protocol</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>2</len><data0>0x00000008</data0></reg></data></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/60-rule-real.xml b/tests/xmlfiles/60-rule-real.xml
deleted file mode 100644
index e5938e3..0000000
--- a/tests/xmlfiles/60-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>22</handle><expr type="meta"><dreg>1</dreg><key>mark</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000000</data0></reg></data></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/61-rule-real.xml b/tests/xmlfiles/61-rule-real.xml
deleted file mode 100644
index 0c097b9..0000000
--- a/tests/xmlfiles/61-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>23</handle><expr type="meta"><dreg>1</dreg><key>iif</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000001</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/62-rule-real.xml b/tests/xmlfiles/62-rule-real.xml
deleted file mode 100644
index 387a4f1..0000000
--- a/tests/xmlfiles/62-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>24</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/63-rule-real.xml b/tests/xmlfiles/63-rule-real.xml
deleted file mode 100644
index 1f6aa92..0000000
--- a/tests/xmlfiles/63-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>25</handle><expr type="meta"><dreg>1</dreg><key>oif</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000001</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/64-rule-real.xml b/tests/xmlfiles/64-rule-real.xml
deleted file mode 100644
index 68f9d8a..0000000
--- a/tests/xmlfiles/64-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>26</handle><expr type="meta"><dreg>1</dreg><key>oifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/65-rule-real.xml b/tests/xmlfiles/65-rule-real.xml
deleted file mode 100644
index 6eeb3d0..0000000
--- a/tests/xmlfiles/65-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>27</handle><expr type="meta"><dreg>1</dreg><key>skuid</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x000003e8</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/66-rule-real.xml b/tests/xmlfiles/66-rule-real.xml
deleted file mode 100644
index 1294a85..0000000
--- a/tests/xmlfiles/66-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>28</handle><expr type="meta"><dreg>1</dreg><key>skgid</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x000003e8</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/67-rule-real.xml b/tests/xmlfiles/67-rule-real.xml
deleted file mode 100644
index 162d084..0000000
--- a/tests/xmlfiles/67-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>29</handle><expr type="meta"><dreg>1</dreg><key>secmark</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000000</data0></reg></data></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/68-rule-real.xml b/tests/xmlfiles/68-rule-real.xml
deleted file mode 100644
index 08371f9..0000000
--- a/tests/xmlfiles/68-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>32</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/69-rule-real.xml b/tests/xmlfiles/69-rule-real.xml
deleted file mode 100644
index 62119cd..0000000
--- a/tests/xmlfiles/69-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>33</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="lookup"><set>set1</set><sreg>1</sreg><dreg>0</dreg></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/70-rule-real.xml b/tests/xmlfiles/70-rule-real.xml
deleted file mode 100644
index 436c517..0000000
--- a/tests/xmlfiles/70-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>34</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map0</set><sreg>1</sreg><dreg>0</dreg></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/71-rule-real.xml b/tests/xmlfiles/71-rule-real.xml
deleted file mode 100644
index bb50afd..0000000
--- a/tests/xmlfiles/71-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>35</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map1</set><sreg>1</sreg><dreg>0</dreg></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/72-rule-real.xml b/tests/xmlfiles/72-rule-real.xml
deleted file mode 100644
index 85ce226..0000000
--- a/tests/xmlfiles/72-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>output</chain><handle>36</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="lookup"><set>map2</set><sreg>1</sreg><dreg>0</dreg></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/73-set.xml b/tests/xmlfiles/73-set.xml
deleted file mode 100644
index 17b5995..0000000
--- a/tests/xmlfiles/73-set.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><set><family>ip</family><table>filter</table><name>set0</name><key_type>0</key_type><key_len>0</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><key><reg type="value"><len>4</len><data0>0x0300a8c0</data0></reg></key></set_elem><set_elem><key><reg type="value"><len>4</len><data0>0x0200a8c0</data0></reg></key></set_elem><set_elem><key><reg type="value"><len>4</len><data0>0x0100a8c0</data0></reg></key></set_elem></set></add></nftables>
diff --git a/tests/xmlfiles/74-set.xml b/tests/xmlfiles/74-set.xml
deleted file mode 100644
index bf39c46..0000000
--- a/tests/xmlfiles/74-set.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><set><family>ip6</family><table>filter</table><name>set0</name><key_type>0</key_type><key_len>0</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><key><reg type="value"><len>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x70010000</data3></reg></key></set_elem><set_elem><key><reg type="value"><len>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x50010000</data3></reg></key></set_elem></set></add></nftables>
diff --git a/tests/xmlfiles/75-ruleset.xml b/tests/xmlfiles/75-ruleset.xml
deleted file mode 100644
index 9c63686..0000000
--- a/tests/xmlfiles/75-ruleset.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><table><name>filter</name><family>ip</family><flags>0</flags><use>0</use></table><table><name>filter</name><family>ip6</family><flags>0</flags><use>0</use></table><chain><name>input</name><handle>1</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family></chain><chain><name>output</name><handle>2</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family></chain><chain><name>forward</name><handle>1</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip6</family></chain><set><family>ip6</family><table>filter</table><name>set0</name><flags>3</flags><key_type>12</key_type><key_len>2</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><key><reg type="value"><len>2</len><data0>0x00004300</data
 0></reg></key></set_elem><set_elem><key><reg type="value"><len>2</len><data0>0x00003500</data0></reg></key></set_elem></set><set><family>ip</family><table>filter</table><name>map0</name><fla
 gs>11</flags><key_type>12</key_type><key_len>2</key_len><data_type>4294967040</data_type><data_len>16</data_len><set_elem><key><reg type="value"><len>2</len><data0>0x00005000</data0></reg></key><data><reg type="verdict"><verdict>drop</verdict></reg></data></set_elem><set_elem><key><reg type="value"><len>2</len><data0>0x00001600</data0></reg></key><data><reg type="verdict"><verdict>accept</verdict></reg></data></set_elem></set><rule><family>ip</family><table>filter</table><chain>input</chain><handle>8</handle><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><data><reg type="verdict"><verdict>accept</verdict></reg></data></expr></rule><rule><family>ip</family><table>filter</table><chain>output</chain><handle>9</handle><expr type="payload"><dreg>
 1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><e
 xpr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map0</set><sreg>1</sreg><dreg>0</dreg></expr></rule><rule><family>ip6</family><table>filter</table><chain>forward</chain><handle>2</handle><expr type="payload"><dreg>1</dreg><offset>6</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000011</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><data><reg type="verdict"><verdict>accept</verdict></reg></data></exp
 r></rule></add></nftables>
diff --git a/tests/xmlfiles/76-rule-meta_target.xml b/tests/xmlfiles/76-rule-meta_target.xml
deleted file mode 100644
index beac9f3..0000000
--- a/tests/xmlfiles/76-rule-meta_target.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>129</handle><expr type="meta"><key>mark</key><sreg>1</sreg></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/77-rule-queue.xml b/tests/xmlfiles/77-rule-queue.xml
deleted file mode 100644
index b9e9628..0000000
--- a/tests/xmlfiles/77-rule-queue.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>input</chain><handle>43</handle><expr type="queue"><num>4</num><total>2</total><flags>0</flags></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/78-rule-queue.xml b/tests/xmlfiles/78-rule-queue.xml
deleted file mode 100644
index d192d7d..0000000
--- a/tests/xmlfiles/78-rule-queue.xml
+++ /dev/null
@@ -1,2 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>input</chain><handle>44</handle><position>43</position><expr type="queue"><num>4</num><total>2</total><flags>3</flags></expr></rule></add></nftables>
-
diff --git a/tests/xmlfiles/79-rule-masq.xml b/tests/xmlfiles/79-rule-masq.xml
deleted file mode 100644
index 59f9c53..0000000
--- a/tests/xmlfiles/79-rule-masq.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip6</family><table>nat</table><chain>postrouting</chain><handle>4</handle><expr type="masq"><flags>12</flags></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/80-rule-redir.xml b/tests/xmlfiles/80-rule-redir.xml
deleted file mode 100644
index 00abc58..0000000
--- a/tests/xmlfiles/80-rule-redir.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip6</family><table>nat</table><chain>prerouting</chain><handle>4</handle><expr type="redir"></expr></rule></add></nftables>
diff --git a/tests/xmlfiles/81-rule-real.xml b/tests/xmlfiles/81-rule-real.xml
deleted file mode 100644
index 11a860e..0000000
--- a/tests/xmlfiles/81-rule-real.xml
+++ /dev/null
@@ -1 +0,0 @@
-<nftables><add><rule><family>ip</family><table>filter</table><chain>input</chain><handle>5</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>2</len><data0>0x00001700</data0></reg></data></expr></rule></add></nftables>

