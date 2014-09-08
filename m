From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: [PATCH 5/5] ipset: data callback does not need to be part of cb_ctl[]
Date: Mon, 08 Sep 2014 16:30:53 +0200
Message-ID: <20140908143053.16930.68662.stgit@jonathan.eitzenberger.org>
References: <20140908142604.16930.94892.stgit@jonathan.eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:57287 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaIHOb5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Sep 2014 10:31:57 -0400
In-Reply-To: <20140908142604.16930.94892.stgit@jonathan.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Because the data callback is passed explicitely to mnl_cb_run2()
there is no need to add it to cb_ctl[].  For nlmsg_types
>= NLMSG_MIN_TYPE the data callback is used explicitely.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>
---
 lib/session.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/session.c b/lib/session.c
index 8d79a96..807f0d3 100644
--- a/lib/session.c
+++ b/lib/session.c
@@ -1868,7 +1868,6 @@ static mnl_cb_t cb_ctl[] = {
 	[NLMSG_ERROR] = callback_error,
 	[NLMSG_DONE]  = callback_done,
 	[NLMSG_OVERRUN] = callback_noop,
-	[NLMSG_MIN_TYPE] = callback_data,
 };
 
 static inline struct ipset_handle *

