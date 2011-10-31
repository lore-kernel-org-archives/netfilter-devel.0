From: Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables] libxt_NFQUEUE: fix --queue-bypass ipt-save output
Date: Mon, 31 Oct 2011 16:10:57 +0100
Message-ID: <1320073857-15353-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46404 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932449Ab1JaPJU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Oct 2011 11:09:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

else, this will print "--queue-num 0--queue-bypass ".

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libxt_NFQUEUE.c |    2 +-
 tests/options-most.rules   |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index e47b586..8c2f699 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -152,7 +152,7 @@ static void NFQUEUE_save_v2(const void *ip, const struct xt_entry_target *target
 	NFQUEUE_save_v1(ip, target);
 
 	if (info->bypass)
-		printf("--queue-bypass ");
+		printf(" --queue-bypass");
 }
 
 static void NFQUEUE_init_v1(struct xt_entry_target *t)
diff --git a/tests/options-most.rules b/tests/options-most.rules
index ae28b82..7573361 100644
--- a/tests/options-most.rules
+++ b/tests/options-most.rules
@@ -178,6 +178,8 @@
 -A ntarg
 -A ntarg -j NFQUEUE --queue-balance 8:99
 -A ntarg
+-A ntarg -j NFQUEUE --queue-num 0 --queue-bypass
+-A ntarg
 -A ntarg -j RATEEST --rateest-name RE1 --rateest-interval 250.0ms --rateest-ewmalog 500.0ms
 -A ntarg
 -A ntarg -j RATEEST --rateest-name RE2 --rateest-interval 250.0ms --rateest-ewmalog 500.0ms
-- 
1.7.3.4

