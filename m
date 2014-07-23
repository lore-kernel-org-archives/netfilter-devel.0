From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Subject: [PATCH] netfilter: don't output error message redundantly
Date: Wed, 23 Jul 2014 14:19:09 +0800
Message-ID: <53CF53DD.6020308@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18742 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751922AbaGWGXD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2014 02:23:03 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The function led_trigger_register() will only return -EEXIST when
error arises.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 net/netfilter/xt_LED.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/xt_LED.c b/net/netfilter/xt_LED.c
index 993de2b..b47a58c 100644
--- a/net/netfilter/xt_LED.c
+++ b/net/netfilter/xt_LED.c
@@ -133,9 +133,7 @@ static int led_tg_check(const struct xt_tgchk_param *par)
 
 	err = led_trigger_register(&ledinternal->netfilter_led_trigger);
 	if (err) {
-		pr_warning("led_trigger_register() failed\n");
-		if (err == -EEXIST)
-			pr_warning("Trigger name is already in use.\n");
+		pr_warning("Trigger name is already in use.\n");
 		goto exit_alloc;
 	}
 
-- 
1.8.3.1
