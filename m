From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH libnfntl v2] set: Fix nftnl_set_set_str
Date: Fri,  1 Jul 2016 18:07:15 +0200
Message-ID: <1467389235-26632-1-git-send-email-carlosfg@riseup.net>
References: <20160701142247.GA8806@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:53387 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151AbcGAQH4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Jul 2016 12:07:56 -0400
In-Reply-To: <20160701142247.GA8806@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We need the string length

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 src/set.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/set.c b/src/set.c
index 47e0c45..8a025ab 100644
--- a/src/set.c
+++ b/src/set.c
@@ -190,7 +190,7 @@ EXPORT_SYMBOL_ALIAS(nftnl_set_set_u64, nft_set_attr=
_set_u64);
=20
 int nftnl_set_set_str(struct nftnl_set *s, uint16_t attr, const char *=
str)
 {
-	return nftnl_set_set(s, attr, str);
+	return nftnl_set_set_data(s, attr, str, strlen(str) + 1);
 }
 EXPORT_SYMBOL_ALIAS(nftnl_set_set_str, nft_set_attr_set_str);
=20
--=20
2.5.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
