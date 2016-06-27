From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH libnftnl] set: Fix nftnl_set_set_str
Date: Mon, 27 Jun 2016 18:24:25 +0200
Message-ID: <20160627162425.4376-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:35713 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbcF0QYp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Jun 2016 12:24:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We need the string length

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 src/set.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/set.c b/src/set.c
index 879100c..edbcbe5 100644
--- a/src/set.c
+++ b/src/set.c
@@ -203,7 +203,7 @@ EXPORT_SYMBOL_ALIAS(nftnl_set_set_u64, nft_set_attr=
_set_u64);
=20
 int nftnl_set_set_str(struct nftnl_set *s, uint16_t attr, const char *=
str)
 {
-	return nftnl_set_set(s, attr, str);
+	return nftnl_set_set_data(s, attr, str, strlen(str));
 }
 EXPORT_SYMBOL_ALIAS(nftnl_set_set_str, nft_set_attr_set_str);
=20
--=20
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
