From: Sergey Popovich <popovich_sergei@mail.ru>
Subject: [PATCH 1/2] libipset: print third element in debugging
Date: Mon,  5 May 2014 11:07:05 +0300
Message-ID: <594c392cc60dc713fc6ea8d29ccf30913e8a9629.1399275196.git.popovich_sergei@mail.ru>
References: <cover.1399275196.git.popovich_sergei@mail.ru>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fallback3.mail.ru ([94.100.176.58]:53880 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341AbaEEIJA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 May 2014 04:09:00 -0400
Received: from smtp4.mail.ru (smtp4.mail.ru [94.100.176.44])
	by fallback3.mail.ru (mPOP.Fallback_MX) with ESMTP id 9ED0E11499C04
	for <netfilter-devel@vger.kernel.org>; Mon,  5 May 2014 12:07:32 +0400 (MSK)
Received: from [195.234.68.4] (port=40497 helo=tuxracer.skif.com.ua)
	by smtp4.mail.ru with esmtpa (envelope-from <popovich_sergei@mail.ru>)
	id 1WhDvd-0003Yx-9a
	for netfilter-devel@vger.kernel.org; Mon, 05 May 2014 12:07:13 +0400
In-Reply-To: <cover.1399275196.git.popovich_sergei@mail.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We have that done for first and second elements when
parsing element string, do this for third element for
convenience.

Signed-off-by: Sergey Popovich <popovich_sergei@mail.ru>
---
 lib/parse.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/parse.c b/lib/parse.c
index 4db872e..405d6a2 100644
--- a/lib/parse.c
+++ b/lib/parse.c
@@ -1976,8 +1976,10 @@ ipset_parse_elem(struct ipset_session *session,
 		D("parse elem part two: %s", a);
 		parse_elem(session, type, IPSET_DIM_TWO, a);
 	}
-	if (type->dimension > IPSET_DIM_TWO && b != NULL)
+	if (type->dimension > IPSET_DIM_TWO && b != NULL) {
+		D("parse elem part three: %s", b);
 		parse_elem(session, type, IPSET_DIM_THREE, b);
+	}
 
 	goto out;
 
-- 
1.7.10.4

