From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [ebtables-compat PATCH 1/2] libxtables: search first for
 AF-specific extension
Date: Thu, 29 Jan 2015 17:44:33 +0100
Message-ID: <20150129164433.21224.14657.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42698 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754248AbbA2Qoo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Jan 2015 11:44:44 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There are some extension which may name-clash, for example:
 * libxt_mark.so
 * liebt_mark.so

Let's search first for AF-specific extension and then for the generic libxt_**.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 libxtables/xtables.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 6985a27..16e4d96 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -549,7 +549,7 @@ void xtables_parse_interface(const char *arg, char *vianame,
 static void *load_extension(const char *search_path, const char *af_prefix,
     const char *name, bool is_target)
 {
-	const char *all_prefixes[] = {"libxt_", af_prefix, NULL};
+	const char *all_prefixes[] = {af_prefix, "libxt_", NULL};
 	const char **prefix;
 	const char *dir = search_path, *next;
 	void *ptr = NULL;

