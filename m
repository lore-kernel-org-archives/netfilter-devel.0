From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft] statement: Avoid rounding bytes in get_rate()
Date: Sun, 12 Feb 2017 10:45:34 -0200
Message-ID: <20170212124534.GA2981@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:34563 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751153AbdBLMp7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Feb 2017 07:45:59 -0500
Received: by mail-qk0-f194.google.com with SMTP id e1so10889752qkh.1
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Feb 2017 04:45:58 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

get_rate() is used to print quotas and limits and currently rounds the
number of bytes:

$ nft add quota filter https-quota 4000 kbytes
$ nft list ruleset
table ip filter {
	quota https-quota {
		3 mbytes
	}
}

This may be a problem when loading your configuration after saving it
with 'list ruleset'. With this patch the values are represented in a
greater unit only when there is no rest in the conversion:

$ nft add quota filter https-quota2 2048 kbytes
$ nft list ruleset
table ip filter {
	quota https-quota {
		4000 kbytes
	}

	quota https-quota2 {
		2 mbytes
	}
}

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 src/statement.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/src/statement.c b/src/statement.c
index 3beb86a..7ffd25f 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -300,20 +300,15 @@ static const char *data_unit[] = {
 
 const char *get_rate(uint64_t byte_rate, uint64_t *rate)
 {
-	uint64_t res, prev, rest;
 	int i;
 
-	res = prev = byte_rate;
-	for (i = 0;; i++) {
-		rest = res % 1024;
-		res /= 1024;
-		if (res <= 1 && rest != 0)
+	for (i = 0; data_unit[i + 1] != NULL; i++) {
+		if (byte_rate % 1024)
 			break;
-		if (data_unit[i + 1] == NULL)
-			break;
-		prev = res;
+		byte_rate /= 1024;
 	}
-	*rate = prev;
+
+	*rate = byte_rate;
 	return data_unit[i];
 }
 
-- 
2.7.4

