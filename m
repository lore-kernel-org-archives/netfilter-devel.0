From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 1/4] netfilter: xt_recent: remove ip_list_hash_size parameter
Date: Wed, 11 Jul 2012 01:52:27 +0200
Message-ID: <1341964350-13809-2-git-send-email-jengelh@inai.de>
References: <1341964350-13809-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:54419 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755569Ab2GJXwh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:52:37 -0400
In-Reply-To: <1341964350-13809-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This module parameter has no effect, since the user-specified value is
overriden by the init function anyway.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 net/netfilter/xt_recent.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index c426497..b980b3f 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -50,7 +50,6 @@ static unsigned int ip_list_uid = 0;
 static unsigned int ip_list_gid = 0;
 module_param(ip_list_tot, uint, 0400);
 module_param(ip_pkt_list_tot, uint, 0400);
-module_param(ip_list_hash_size, uint, 0400);
 module_param(ip_list_perms, uint, 0400);
 module_param(ip_list_uid, uint, S_IRUGO | S_IWUSR);
 module_param(ip_list_gid, uint, S_IRUGO | S_IWUSR);
-- 
1.7.7

