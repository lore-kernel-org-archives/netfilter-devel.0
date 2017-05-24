From: Alin Nastac <alin.nastac@gmail.com>
Subject: [PATCH v3] extensions: libxt_hashlimit: fix uint64_t printf formats
Date: Wed, 24 May 2017 09:13:58 +0200
Message-ID: <1495610038-29297-1-git-send-email-alin.nastac@technicolor.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:36326 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935569AbdEXHOJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 May 2017 03:14:09 -0400
Received: by mail-it0-f67.google.com with SMTP id i206so16940472ita.3
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 00:14:09 -0700 (PDT)
Received: from cplx1037.edegem.eu.thmulti.com ([2001:4158:f012:c10:2a10:7bff:fec5:6f08])
        by smtp.gmail.com with ESMTPSA id i74sm1352732itb.5.2017.05.24.00.14.07
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 24 May 2017 00:14:07 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Alin Nastac <alin.nastac@gmail.com>

The remaining %llu formats are used for unsigned long long values.

Signed-off-by: Alin Nastac <alin.nastac@gmail.com>
---
 extensions/libxt_hashlimit.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index 9e63e1e..d7de540 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -736,7 +736,7 @@ hashlimit_mt_print(const struct hashlimit_cfg2 *cfg, unsigned int dmask, int rev
 		quantum = print_bytes(cfg->avg, cfg->burst, "");
 	} else {
 		quantum = print_rate(cfg->avg, revision);
-		printf(" burst %llu", cfg->burst);
+		printf(" burst %"PRIu64, cfg->burst);
 	}
 	if (cfg->mode & (XT_HASHLIMIT_HASH_SIP | XT_HASHLIMIT_HASH_SPT |
 	    XT_HASHLIMIT_HASH_DIP | XT_HASHLIMIT_HASH_DPT)) {
@@ -846,7 +846,7 @@ hashlimit_mt_save(const struct hashlimit_cfg2 *cfg, const char* name, unsigned i
 		quantum = print_bytes(cfg->avg, cfg->burst, "--hashlimit-");
 	} else {
 		quantum = print_rate(cfg->avg, revision);
-		printf(" --hashlimit-burst %llu", cfg->burst);
+		printf(" --hashlimit-burst %"PRIu64, cfg->burst);
 	}
 
 	if (cfg->mode & (XT_HASHLIMIT_HASH_SIP | XT_HASHLIMIT_HASH_SPT |
@@ -942,7 +942,7 @@ static void print_packets_rate_xlate(struct xt_xlate *xl, uint64_t avg,
 		    _rates[i].mult / avg < _rates[i].mult % avg)
 			break;
 
-	xt_xlate_add(xl, " %llu/%s burst %lu packets",
+	xt_xlate_add(xl, " %"PRIu64"/%s burst %"PRIu64" packets",
 		     _rates[i-1].mult / avg, _rates[i-1].name, burst);
 }
 
-- 
2.7.4

