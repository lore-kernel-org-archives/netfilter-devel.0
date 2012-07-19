From: Eric Leblond <eric@regit.org>
Subject: [PATCH] Fix crash when the same NFCT is used by two stacks.
Date: Thu, 19 Jul 2012 08:56:04 +0200
Message-ID: <1342680964-1250-2-git-send-email-eric@regit.org>
References: <CAAJpzgYGxVgazp74qck_Diacp7SJCjMOZFhw7cX0_k6B-4Qw9Q@mail.gmail.com>
 <1342680964-1250-1-git-send-email-eric@regit.org>
Cc: Gomathivinayagam Muthuvinayagam <sankarmail@gmail.com>,
	Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:39812 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab2GSG5D (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jul 2012 02:57:03 -0400
In-Reply-To: <1342680964-1250-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The polling timer initialisation code was put in the configurator
code. It was then created for all instances. But only first one has
a valid NFCT handle. This was resulting in a crash.
This patch moves the timer initialisation in the constructor which
is called only once on the main NFCT instance.

Signed-off-by: Eric Leblond <eric@regit.org>
Reported-by: Gomathivinayagam Muthuvinayagam <sankarmail@gmail.com>
---
 input/flow/ulogd_inpflow_NFCT.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index b45a435..dcba58f 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -982,11 +982,6 @@ static int configure_nfct(struct ulogd_pluginstance *upi,
 	if (ret < 0)
 		return ret;
 
-	ulogd_init_timer(&cpi->timer, upi, polling_timer_cb);
-	if (pollint_ce(upi->config_kset).u.value != 0)
-		ulogd_add_timer(&cpi->timer,
-				pollint_ce(upi->config_kset).u.value);
-
 	return 0;
 }
 
@@ -1152,6 +1147,11 @@ static int constructor_nfct_polling(struct ulogd_pluginstance *upi)
 	if (cpi->ct == NULL)
 		goto err_ct_cache;
 
+	ulogd_init_timer(&cpi->timer, upi, polling_timer_cb);
+	if (pollint_ce(upi->config_kset).u.value != 0)
+		ulogd_add_timer(&cpi->timer,
+				pollint_ce(upi->config_kset).u.value);
+
 	ulogd_log(ULOGD_NOTICE, "NFCT working in polling mode\n");
 	return 0;
 
-- 
1.7.10.4

