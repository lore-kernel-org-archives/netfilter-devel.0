From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 02/02: xt_sctp: sctp chunk mapping doesn't work
Date: Thu, 12 Feb 2009 08:07:38 +0100 (MET)
Message-ID: <20090212070735.4876.81436.sendpatchset@x2.localnet>
References: <20090212070732.4876.43180.sendpatchset@x2.localnet>
Cc: netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41877 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbZBLHHk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 02:07:40 -0500
In-Reply-To: <20090212070732.4876.43180.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit f3568e644ddf628aab11ce2fc8341e4b12654e0f
Author: Qu Haoran <haoran.qu@6wind.com>
Date:   Thu Feb 12 08:03:46 2009 +0100

    netfilter: xt_sctp: sctp chunk mapping doesn't work
    
    Upstream commit: d4e2675a
    
    When user tries to map all chunks given in argument, kernel
    works on a copy of the chunkmap, but at the end it doesn't
    check the copy, but the orginal one.
    
    Signed-off-by: Qu Haoran <haoran.qu@6wind.com>
    Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index e223cb4..a189ada 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -105,7 +105,7 @@ match_packet(const struct sk_buff *skb,
 
 	switch (chunk_match_type) {
 	case SCTP_CHUNK_MATCH_ALL:
-		return SCTP_CHUNKMAP_IS_CLEAR(info->chunkmap);
+		return SCTP_CHUNKMAP_IS_CLEAR(chunkmapcopy);
 	case SCTP_CHUNK_MATCH_ANY:
 		return false;
 	case SCTP_CHUNK_MATCH_ONLY:
