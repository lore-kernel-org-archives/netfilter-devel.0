From: Phil Sutter <phil@nwl.cc>
Subject: [libnftnl PATCH 3/7] expr/ct: prevent array index overrun in ctkey2str()
Date: Fri, 12 Aug 2016 01:33:35 +0200
Message-ID: <1470958419-32602-4-git-send-email-phil@nwl.cc>
References: <1470958419-32602-1-git-send-email-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:59782 "EHLO mail.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbcHKXea (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Aug 2016 19:34:30 -0400
In-Reply-To: <1470958419-32602-1-git-send-email-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The array has NFT_CT_MAX fields, so indices must be less than that
number.

Fixes: 977b7a1dbe1bd ("ct: xml: use key names instead of numbers")
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/expr/ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/expr/ct.c b/src/expr/ct.c
index 7d96df4e1d5b0..1a53b49fde0ad 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -173,7 +173,7 @@ static const char *ctkey2str_array[NFT_CT_MAX] = {
 
 static const char *ctkey2str(uint32_t ctkey)
 {
-	if (ctkey > NFT_CT_MAX)
+	if (ctkey >= NFT_CT_MAX)
 		return "unknown";
 
 	return ctkey2str_array[ctkey];
-- 
2.8.2

