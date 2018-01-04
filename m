From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables] extensions: hashlimit: always print timeout on translations
Date: Thu,  4 Jan 2018 10:55:47 +0100
Message-ID: <20180104095547.5284-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51474 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751829AbeADJz4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Jan 2018 04:55:56 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AA44DB6C88
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Jan 2018 10:55:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 99E3134D8
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Jan 2018 10:55:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 59BAB53CDC
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Jan 2018 10:55:51 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 28E8D41FEA09
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Jan 2018 10:55:51 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Meters need an explicit timeout that we cannot skip, otherwise entries
remain in the set forever.

This fixes the following translation:

$ iptables-translate -A INPUT -m tcp -p tcp --dport 80 -m hashlimit
--hashlimit-above 200kb/s --hashlimit-burst 1mb --hashlimit-mode
srcip,dstport --hashlimit-name http2 --hashlimit-htable-expire 1000 -j
DROP

that was skipping the timeout option:

nft add rule ip filter INPUT tcp dport 80 flow table http2 { tcp dport .
ip saddr limit rate over 200 kbytes/second burst 1 mbytes}
counter drop

Reported-by: Duncan Roe <duncan_roe@optusnet.com.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 extensions/libxt_hashlimit.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index 3fa5719127db..f85f2d3a179a 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -1341,8 +1341,7 @@ static int hashlimit_mt_xlate(struct xt_xlate *xl, const char *name,
 	xt_xlate_add(xl, "flow table %s {", name);
 	ret = hashlimit_mode_xlate(xl, cfg->mode, family,
 				   cfg->srcmask, cfg->dstmask);
-	if (cfg->expire != 1000)
-		xt_xlate_add(xl, " timeout %us", cfg->expire / 1000);
+	xt_xlate_add(xl, " timeout %us", cfg->expire / 1000);
 	xt_xlate_add(xl, " limit rate");
 
 	if (cfg->mode & XT_HASHLIMIT_INVERT)
-- 
2.11.0

