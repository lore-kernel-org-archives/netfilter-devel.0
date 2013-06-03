From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 2/5] rule: fix snprintf return value
Date: Mon, 03 Jun 2013 22:44:52 +0200
Message-ID: <20130603204452.27713.79515.stgit@nfdev.cica.es>
References: <20130603204451.27713.51887.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42343 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757604Ab3FCUoz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Jun 2013 16:44:55 -0400
In-Reply-To: <20130603204451.27713.51887.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This cause some chained snprintf to fail.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/rule.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index f0208d9..a91d21d 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -676,7 +676,7 @@ static int nft_rule_snprintf_xml(char *buf, size_t size, struct nft_rule *r,
 	ret = snprintf(buf+offset, len, "</rule>");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	return ret;
+	return offset;
 }
 
 static int nft_rule_snprintf_default(char *buf, size_t size, struct nft_rule *r, 
@@ -699,7 +699,7 @@ static int nft_rule_snprintf_default(char *buf, size_t size, struct nft_rule *r,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
-	return ret;
+	return offset;
 }
 
 int nft_rule_snprintf(char *buf, size_t size, struct nft_rule *r,

