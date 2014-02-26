From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [RFC PATCH v2 3/6] rule: generalize chain_print()
Date: Wed, 26 Feb 2014 17:10:00 +0100
Message-ID: <20140226161000.18974.9778.stgit@nfdev.cica.es>
References: <20140226160918.18974.64532.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:60328 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751679AbaBZQKC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:10:02 -0500
In-Reply-To: <20140226160918.18974.64532.stgit@nfdev.cica.es>
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
index b263593..9791cea 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -126,6 +126,7 @@ extern struct chain *chain_lookup(const struct table *table,
 				  const struct handle *h);
 
 extern const char *family2str(unsigned int family);
+extern void chain_print_plain(const struct chain *chain);
 
 /**
  * struct rule - nftables rule
diff --git a/src/rule.c b/src/rule.c
index c774664..d8a065a 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -397,6 +397,20 @@ static void chain_print(const struct chain *chain)
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

