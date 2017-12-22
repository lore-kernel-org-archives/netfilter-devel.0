From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH nft] src: do not print limit keyword inside object definition
Date: Fri, 22 Dec 2017 18:26:10 +0100
Message-ID: <20171222172610.5165-1-pablombg@gmail.com>
Cc: pablo@netfilter.org, "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:41720 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756091AbdLVR0q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Dec 2017 12:26:46 -0500
Received: by mail-wm0-f66.google.com with SMTP id g75so23226568wme.0
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Dec 2017 09:26:46 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

table ip limits {
    limit foo {
        limit rate 5/second
        ^^^^^
    }
}

This behaviour is inconsistent and breaks the restoration of saved
rule-sets with "nft -f".

Fixes: c0697eabe832 ("src: add stateful object support for limit")
Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 src/rule.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index cbc40e2..bb9add0 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1316,7 +1316,7 @@ static void obj_print_data(const struct obj *obj,
 			  opts->nl, opts->tab, opts->tab);
 		switch (obj->limit.type) {
 		case NFT_LIMIT_PKTS:
-			nft_print(octx, "limit rate %s%" PRIu64 "/%s",
+			nft_print(octx, "rate %s%" PRIu64 "/%s",
 				  inv ? "over " : "", obj->limit.rate,
 				  get_unit(obj->limit.unit));
 			if (obj->limit.burst > 0)
@@ -1326,7 +1326,7 @@ static void obj_print_data(const struct obj *obj,
 		case NFT_LIMIT_PKT_BYTES:
 			data_unit = get_rate(obj->limit.rate, &rate);
 
-			nft_print(octx, "limit rate %s%" PRIu64 " %s/%s",
+			nft_print(octx, "rate %s%" PRIu64 " %s/%s",
 				  inv ? "over " : "", rate, data_unit,
 				  get_unit(obj->limit.unit));
 			if (obj->limit.burst > 0) {
-- 
2.15.1

