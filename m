From: Piyush Pangtey <gokuvsvegita@gmail.com>
Subject: [PATCH] nft: Remove memory-leak
Date: Mon, 14 Mar 2016 14:11:53 +0530
Message-ID: <20160314084153.GA4064@fate>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:36364 "EHLO
	mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425AbcCNIlm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Mar 2016 04:41:42 -0400
Received: by mail-pf0-f173.google.com with SMTP id u190so102122805pfb.3
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Mar 2016 01:41:41 -0700 (PDT)
Received: from fate ([14.139.254.36])
        by smtp.gmail.com with ESMTPSA id s14sm30238100pfa.3.2016.03.14.01.41.39
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Mon, 14 Mar 2016 01:41:40 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Added matching xfree calls in chain_free(), for the chain members 'type' and
'dev'.

Signed-off-by: Piyush Pangtey <gokuvsvegita@gmail.com>
---
 src/rule.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/rule.c b/src/rule.c
index 0b78549..85987b9 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -510,6 +510,9 @@ void chain_free(struct chain *chain)
 		rule_free(rule);
 	handle_free(&chain->handle);
 	scope_release(&chain->scope);
+	xfree(chain->type);
+	if (chain->dev != NULL)
+		xfree(chain->dev);
 	xfree(chain);
 }
 
-- 
1.9.1


-- 

With regards,
Piyush Pangtey <gokuvsvegita@gmail.com>
