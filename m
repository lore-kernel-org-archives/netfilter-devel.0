From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Subject: [PATCH v2] netfilter: don't output error message redundantly
Date: Fri, 25 Jul 2014 09:06:27 +0800
Message-ID: <53D1AD93.7010005@cn.fujitsu.com>
References: <53CF53DD.6020308@cn.fujitsu.com> <20140724114946.GA21812@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30448 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750828AbaGYBKX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jul 2014 21:10:23 -0400
In-Reply-To: <20140724114946.GA21812@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The function led_trigger_register() will only return -EEXIST when
error arises.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---

v2: use pr_err rather than pr_warning

 net/netfilter/xt_LED.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/xt_LED.c b/net/netfilter/xt_LED.c
index 993de2b..f14bcf2 100644
--- a/net/netfilter/xt_LED.c
+++ b/net/netfilter/xt_LED.c
@@ -133,9 +133,7 @@ static int led_tg_check(const struct xt_tgchk_param *par)
 
 	err = led_trigger_register(&ledinternal->netfilter_led_trigger);
 	if (err) {
-		pr_warning("led_trigger_register() failed\n");
-		if (err == -EEXIST)
-			pr_warning("Trigger name is already in use.\n");
+		pr_err("Trigger name is already in use.\n");
 		goto exit_alloc;
 	}
 
-- 
1.8.3.1
