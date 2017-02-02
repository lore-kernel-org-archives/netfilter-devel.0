From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft v2 1/2] main: Validate the number of numeric options
Date: Thu, 2 Feb 2017 10:25:53 -0200
Message-ID: <20170202122553.GA17853@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:36101 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751350AbdBBM0A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Feb 2017 07:26:00 -0500
Received: by mail-qt0-f193.google.com with SMTP id h53so3553589qth.3
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Feb 2017 04:26:00 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The number of numeric options influences the behavior and the user
should be warned if a invalid number is used.

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---

 v2: Was split from a bigger patch. Now an error is triggered when a
 invalid number of numeric options is used, instead of allowing it and
 using the closer valid number.

 src/main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/main.c b/src/main.c
index 6ba752b..48a813d 100644
--- a/src/main.c
+++ b/src/main.c
@@ -288,7 +288,12 @@ int main(int argc, char * const *argv)
 			include_paths[num_include_paths++] = optarg;
 			break;
 		case OPT_NUMERIC:
-			numeric_output++;
+			if (++numeric_output > NUMERIC_ALL) {
+				fprintf(stderr, "Too many numeric options "
+						"used, max. %u\n",
+					NUMERIC_ALL);
+				exit(NFT_EXIT_FAILURE);
+			}
 			break;
 		case OPT_STATELESS:
 			stateless_output++;
-- 
2.7.4

