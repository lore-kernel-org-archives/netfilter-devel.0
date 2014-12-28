From: Steven Barth <cyrus@openwrt.org>
Subject: [PATCH 2/5] datatype: use mpz_set_str instead of gmp_sscanf
Date: Sun, 28 Dec 2014 18:17:42 +0100
Message-ID: <1419787065-26146-3-git-send-email-cyrus@openwrt.org>
References: <1419787065-26146-1-git-send-email-cyrus@openwrt.org>
Cc: Steven Barth <cyrus@openwrt.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.core-networks.de ([82.96.72.7]:36393 "EHLO
	mail.core-networks.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaL1RqJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Dec 2014 12:46:09 -0500
In-Reply-To: <1419787065-26146-1-git-send-email-cyrus@openwrt.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This simplifies the integer parsing logic and restricts it to
functions being part of the mini-gmp subset.

Signed-off-by: Steven Barth <cyrus@openwrt.org>
---
 src/datatype.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index 2a9fcdb..76f2af1 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -276,11 +276,9 @@ static struct error_record *integer_type_parse(const struct expr *sym,
 					       struct expr **res)
 {
 	mpz_t v;
-	int len;
 
 	mpz_init(v);
-	if (gmp_sscanf(sym->identifier, "%Zu%n", v, &len) != 1 ||
-	    (int)strlen(sym->identifier) != len) {
+	if (mpz_set_str(v, sym->identifier, 0)) {
 		mpz_clear(v);
 		return error(&sym->location, "Could not parse %s",
 			     sym->dtype->desc);
-- 
2.1.4

