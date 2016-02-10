From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH ulogd 6/7] ulogd: update calling stop callback condition
Date: Wed, 10 Feb 2016 11:04:14 +0900
Message-ID: <20160210020414.GG17470@gmail.com>
References: <20160206104249.GA19349@gmail.com>
 <a53f427c-6b04-4d3b-898e-ba63fc949f5a@email.android.com>
 <20160210015358.GA17470@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:36255 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129AbcBJCET (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Feb 2016 21:04:19 -0500
Received: by mail-pa0-f66.google.com with SMTP id sv5so242185pab.3
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Feb 2016 18:04:18 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20160210015358.GA17470@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

TIMECONV filter in previous patch has private data but does not
have stop callback, then segfault occured.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 src/ulogd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/ulogd.c b/src/ulogd.c
index 5b9a586..7e1a42f 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -1288,13 +1288,13 @@ static void stop_pluginstances()
 
 	llist_for_each_entry(stack, &ulogd_pi_stacks, stack_list) {
 		llist_for_each_entry_safe(pi, npi, &stack->list, list) {
-			if ((pi->plugin->priv_size > 0 || *pi->plugin->stop) &&
-			    pluginstance_stop(pi)) {
+			if (*pi->plugin->stop && pluginstance_stop(pi)) {
 				ulogd_log(ULOGD_DEBUG, "calling stop for %s\n",
 					  pi->plugin->name);
 				(*pi->plugin->stop)(pi);
-				pi->private[0] = 0;
 			}
+			if (pi->plugin->priv_size > 0)
+				pi->private[0] = 0;
 			free(pi);
 		}
 	}
-- 
2.1.4

