From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH] buffer: fix a bug in nft_buf_close passing the tag to close the xml elements.
Date: Mon,  9 Feb 2015 21:09:52 +0100
Message-ID: <1423512596-29777-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:62641 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbbBIUJj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2015 15:09:39 -0500
Received: by mail-wg0-f48.google.com with SMTP id x12so29058733wgg.7
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Feb 2015 12:09:38 -0800 (PST)
Received: from localhost.localdomain (129.166.216.87.static.jazztel.es. [87.216.166.129])
        by mx.google.com with ESMTPSA id ub1sm17729984wjc.43.2015.02.09.12.09.37
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Feb 2015 12:09:37 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/buffer.c b/src/buffer.c
index d64f944..4cedb9e 100644
--- a/src/buffer.c
+++ b/src/buffer.c
@@ -75,7 +75,7 @@ int nft_buf_close(struct nft_buf *b, int type, const char *tag)
 {
 	switch (type) {
 	case NFT_OUTPUT_XML:
-		return nft_buf_put(b, "</%s>");
+		return nft_buf_put(b, "</%s>", tag);
 	case NFT_OUTPUT_JSON:
 		/* Remove trailing comma in json */
 		if (b->size > 0 && b->buf[b->size - 1] == ',') {
-- 
1.7.10.4

