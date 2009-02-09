From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 05/05: xt_sctp: sctp chunk mapping doesn't work
Date: Mon,  9 Feb 2009 17:39:33 +0100 (MET)
Message-ID: <20090209163932.13918.43869.sendpatchset@x2.localnet>
References: <20090209163926.13918.96177.sendpatchset@x2.localnet>
Cc: netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59012 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbZBIQje (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 11:39:34 -0500
In-Reply-To: <20090209163926.13918.96177.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 3c0994f8a7864e1d1de3cefbcf715bfde5b2a41a
Author: Qu Haoran <haoran.qu@6wind.com>
Date:   Mon Feb 9 15:35:43 2009 +0100

    netfilter: xt_sctp: sctp chunk mapping doesn't work
    
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
