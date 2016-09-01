From: Kevin Cernekee <cernekee@chromium.org>
Subject: [PATCH 2/3] conntrackd: cthelper: ftp: Fix debug print
Date: Wed, 31 Aug 2016 21:27:54 -0700
Message-ID: <1472704075-38007-2-git-send-email-cernekee@chromium.org>
References: <1472704075-38007-1-git-send-email-cernekee@chromium.org>
Cc: ashley.hughes@blueyonder.co.uk, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34550 "EHLO
        mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750858AbcIAE3X (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Sep 2016 00:29:23 -0400
Received: by mail-pa0-f43.google.com with SMTP id fi15so25431540pac.1
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Aug 2016 21:29:22 -0700 (PDT)
In-Reply-To: <1472704075-38007-1-git-send-email-cernekee@chromium.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

matchoff is relative to dataoff, i.e. matchoff=0 (as utilized by
nfq_tcp_mangle_ipv4()) points to the first byte of the TCP payload.

Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
---
 src/helpers/ftp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/helpers/ftp.c b/src/helpers/ftp.c
index 3da6e56..27ab5eb 100644
--- a/src/helpers/ftp.c
+++ b/src/helpers/ftp.c
@@ -511,7 +511,7 @@ ftp_helper_cb(struct pkt_buff *pkt, uint32_t protoff,
 		goto out_update_nl;
 
 	pr_debug("conntrack_ftp: match `%.*s' (%u bytes at %u)\n",
-		 matchlen, pktb_network_header(pkt) + matchoff,
+		 matchlen, pktb_network_header(pkt) + dataoff + matchoff,
 		 matchlen, ntohl(th->seq) + matchoff);
 
 	/* We refer to the reverse direction ("!dir") tuples here,
-- 
1.9.1

