From: Patrick McHardy <kaber@trash.net>
Subject: [LIBNL 05/09]: nfnetlink_log: only set hwproto if not zero
Date: Fri, 18 Jan 2008 17:55:54 +0100 (MET)
Message-ID: <20080118165521.13385.17641.sendpatchset@localhost.localdomain>
References: <20080118165514.13385.44695.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	philipc@snapgear.com
To: tgraf@suug.ch
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42974 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762331AbYARQzz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:55:55 -0500
In-Reply-To: <20080118165514.13385.44695.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 26b35449524246778d4a14c3805430797c29c039
Author: Patrick McHardy <kaber@trash.net>
Date:   Fri Jan 18 17:44:52 2008 +0100

    [LIBNL]: nfnetlink_log: only set hwproto if not zero
    
    The hwproto doesn't have its own attribute and is also present when
    not set. Don't set the attribute if its value is zero.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/lib/netfilter/log.c b/lib/netfilter/log.c
index a6bf3d5..a900927 100644
--- a/lib/netfilter/log.c
+++ b/lib/netfilter/log.c
@@ -86,7 +86,8 @@ struct nfnl_log *nfnlmsg_log_parse(struct nlmsghdr *nlh)
 	if (attr) {
 		struct nfulnl_msg_packet_hdr *hdr = nla_data(attr);
 
-		nfnl_log_set_hwproto(log, hdr->hw_protocol);
+		if (hdr->hw_protocol)
+			nfnl_log_set_hwproto(log, hdr->hw_protocol);
 		nfnl_log_set_hook(log, hdr->hook);
 	}
 
