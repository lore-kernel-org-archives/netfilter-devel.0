From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 3/8] rule: generalize chain_print()
Date: Mon, 14 Apr 2014 12:17:19 +0200
Message-ID: <20140414101719.5018.52430.stgit@nfdev.cica.es>
References: <20140414101634.5018.86819.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42761 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753360AbaDNKRW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:17:22 -0400
In-Reply-To: <20140414101634.5018.86819.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Lest generalize the chain_print() function, so we can print a plain chain
as the user typed in the basic CLI.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/rule.h |    1 +
 src/rule.c     |   14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/rule.h b/include/rule.h
index 072cff8..6c373e6 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -128,6 +128,7 @@ extern struct chain *chain_lookup(const struct table *table,
 				  const struct handle *h);
 
 extern const char *family2str(unsigned int family);
+extern void chain_print_plain(const struct chain *chain);
 
 /**
  * struct rule - nftables rule
diff --git a/src/rule.c b/src/rule.c
index accff0f..858149e 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -401,6 +401,20 @@ static void chain_print(const struct chain *chain)
 	printf("\t}\n");
 }
 
+void chain_print_plain(const struct chain *chain)
+{
+	printf("chain %s %s %s", family2str(chain->handle.family),
+	       chain->handle.table, chain->handle.chain);
+
+	if (chain->flags & CHAIN_F_BASECHAIN) {
+		printf(" { type %s hook %s priority %u; }", chain->type,
+		       hooknum2str(chain->handle.family, chain->hooknum),
+		       chain->priority);
+	}
+
+	printf("\n");
+}
+
 struct table *table_alloc(void)
 {
 	struct table *table;

