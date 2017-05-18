From: Alin Nastac <alin.nastac@gmail.com>
Subject: [PATCH v2] extensions: libxt_hashlimit: fix 64-bit printf formats
Date: Thu, 18 May 2017 16:16:25 +0200
Message-ID: <1495116985-27115-1-git-send-email-alin.nastac@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:34765 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755790AbdEROQd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 May 2017 10:16:33 -0400
Received: by mail-it0-f67.google.com with SMTP id d68so4775361ita.1
        for <netfilter-devel@vger.kernel.org>; Thu, 18 May 2017 07:16:33 -0700 (PDT)
Received: from cplx1037.edegem.eu.thmulti.com ([2001:4158:f012:a50:2a10:7bff:fec5:6f08])
        by smtp.gmail.com with ESMTPSA id h142sm8718257ith.31.2017.05.18.07.16.31
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 18 May 2017 07:16:32 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Furthermore, this extension use a mix of PRIu64 and %llu formats for
uint64_t values. IMO it should use only one, for the sake of consistency.

Signed-off-by: Alin Nastac <alin.nastac@gmail.com>
---
 extensions/libxt_hashlimit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index 9e63e1e..970bad9 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -942,7 +942,7 @@ static void print_packets_rate_xlate(struct xt_xlate *xl, uint64_t avg,
 		    _rates[i].mult / avg < _rates[i].mult % avg)
 			break;
 
-	xt_xlate_add(xl, " %llu/%s burst %lu packets",
+	xt_xlate_add(xl, " %"PRIu64"/%s burst %"PRIu64" packets",
 		     _rates[i-1].mult / avg, _rates[i-1].name, burst);
 }
 
-- 
2.7.4

