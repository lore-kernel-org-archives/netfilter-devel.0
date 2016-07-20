From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] ct: use nftables sysconf location for connlabel configuration
Date: Wed, 20 Jul 2016 12:17:05 +0200
Message-ID: <1469009825-1188-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55289 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753282AbcGTKQr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jul 2016 06:16:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Instead of using /etc/xtables use the nftables syconfdir.
Also update error message to tell which label failed translation
and which config file was used for this:

nft add filter input ct label foo
<cmdline>:1:27-29: Error: /etc/nftables/connlabel.conf: could not parse conntrack label "foo"

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/Makefile.am | 2 ++
 src/ct.c        | 7 +++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 8c59449..ff1dd6e 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -27,6 +27,8 @@ parser_bison.o scanner.o: AM_CFLAGS += -Wno-missing-prototypes -Wno-missing-decl
 
 BUILT_SOURCES = parser_bison.h
 
+ct.o: AM_CFLAGS += -DCONNLABEL_PATH="\"${sysconfdir}/\""
+
 nft_SOURCES =	main.c				\
 		rule.c				\
 		statement.c			\
diff --git a/src/ct.c b/src/ct.c
index b971ba1..e974307 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -29,6 +29,8 @@
 #include <utils.h>
 #include <statement.h>
 
+#define CONNLABEL_CONF	CONNLABEL_PATH "connlabel.conf"
+
 static const struct symbol_table ct_state_tbl = {
 	.symbols	= {
 		SYMBOL("invalid",	NF_CT_STATE_INVALID_BIT),
@@ -128,7 +130,8 @@ static struct error_record *ct_label_type_parse(const struct expr *sym,
 
 	dtype = sym->dtype;
 	if (s->identifier == NULL)
-		return error(&sym->location, "Could not parse %s", dtype->desc);
+		return error(&sym->location, "%s: could not parse %s \"%s\"", CONNLABEL_CONF,
+			     dtype->desc, sym->identifier);
 
 	if (s->value >= CT_LABEL_BIT_SIZE)
 		return error(&sym->location, "%s: out of range (%u max)",
@@ -158,7 +161,7 @@ static const struct datatype ct_label_type = {
 
 static void __init ct_label_table_init(void)
 {
-	ct_label_tbl = rt_symbol_table_init("/etc/xtables/connlabel.conf");
+	ct_label_tbl = rt_symbol_table_init(CONNLABEL_CONF);
 }
 
 #ifndef NF_CT_HELPER_NAME_LEN
-- 
2.7.3

