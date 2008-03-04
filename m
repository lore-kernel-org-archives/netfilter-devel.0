From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 13/19] [NETFILTER]: remove xt_counters* indirection macros
Date: Tue, 4 Mar 2008 17:36:00 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041734380.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47328 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765931AbYCDQgB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:36:01 -0500
In-Reply-To: <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Wrong commit message in commit... dang!

    [NETFILTER]: remove xt_counters* indirection macros

===
commit 6a54084aa882f20ca5588cf93854285ea5c3d0ca
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Sat Feb 9 00:45:44 2008 +0100

    [NETFILTER]: remove ARPT_{CONTINUE,RETURN} indirection macros
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 include/linux/netfilter_arp/arp_tables.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 2cdcc0c..f701e36 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -180,10 +180,6 @@ struct arpt_replace
 	struct arpt_entry entries[0];
 };
 
-/* The argument to ARPT_SO_ADD_COUNTERS. */
-#define arpt_counters_info xt_counters_info
-#define arpt_counters xt_counters
-
 /* The argument to ARPT_SO_GET_ENTRIES. */
 struct arpt_get_entries
 {
