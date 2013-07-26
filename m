From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [iptables-nftables PATCH 5/5] nft: fix family operation lookup
Date: Fri, 26 Jul 2013 13:05:19 +0200
Message-ID: <1374836719-27596-5-git-send-email-giuseppelng@gmail.com>
References: <1374836719-27596-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:62361 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758409Ab3GZLGG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jul 2013 07:06:06 -0400
Received: by mail-we0-f174.google.com with SMTP id q54so1697816wes.5
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Jul 2013 04:06:05 -0700 (PDT)
In-Reply-To: <1374836719-27596-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This fixes the family operations lookup: handle's family is the one to use at this point

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/xtables.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/iptables/xtables.c b/iptables/xtables.c
index 59f38a9..eb614c6 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -1110,7 +1110,7 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 	if (h->family == AF_UNSPEC)
 		h->family = args.family;
 
-	h->ops = nft_family_ops_lookup(args.family);
+	h->ops = nft_family_ops_lookup(h->family);
 	if (h->ops == NULL)
 		xtables_error(PARAMETER_PROBLEM, "Unknown family");
 
-- 
1.7.8.6

