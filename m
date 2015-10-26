From: Ian Morris <ipm@chirality.org.uk>
Subject: [PATCH nf-next 3/4] netfilter-bridge: brace placement
Date: Mon, 26 Oct 2015 09:10:42 +0000
Message-ID: <1445850643-9186-4-git-send-email-ipm@chirality.org.uk>
References: <1445850643-9186-1-git-send-email-ipm@chirality.org.uk>
Cc: Ian Morris <ipm@chirality.org.uk>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from inet-gw.chirality.org.uk ([88.97.209.22]:56043 "EHLO
	cedar.ipmorris.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753246AbbJZJKs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Oct 2015 05:10:48 -0400
In-Reply-To: <1445850643-9186-1-git-send-email-ipm@chirality.org.uk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Change brace placement to eliminate checkpatch error.

No changes detected by objdiff.

Signed-off-by: Ian Morris <ipm@chirality.org.uk>
---
 net/bridge/netfilter/ebt_log.c  | 6 ++----
 net/bridge/netfilter/ebtables.c | 3 +--
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index f22284d..152300d 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -36,14 +36,12 @@ static int ebt_log_tg_check(const struct xt_tgchk_param *par)
 	return 0;
 }
 
-struct tcpudphdr
-{
+struct tcpudphdr {
 	__be16 src;
 	__be16 dst;
 };
 
-struct arppayload
-{
+struct arppayload {
 	unsigned char mac_src[ETH_ALEN];
 	unsigned char ip_src[4];
 	unsigned char mac_dst[ETH_ALEN];
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 62090e2..b13ea69 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -551,8 +551,7 @@ ebt_check_entry_size_and_hooks(const struct ebt_entry *e,
 	return 0;
 }
 
-struct ebt_cl_stack
-{
+struct ebt_cl_stack {
 	struct ebt_chainstack cs;
 	int from;
 	unsigned int hookmask;
-- 
1.9.1

