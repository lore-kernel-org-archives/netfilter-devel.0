From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables] extensions: hashlimit: fix incorrect burst in translations
Date: Wed,  3 Jan 2018 15:41:08 +0100
Message-ID: <20180103144109.8280-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60634 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751596AbeACOlQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 09:41:16 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E512B2492B
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jan 2018 15:41:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C8F8AFC5E8
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jan 2018 15:41:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A1DB1FC5F8
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jan 2018 15:41:12 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6AC9541EB0E1
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jan 2018 15:41:12 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

iptables-translate -A INPUT -m tcp -p tcp --dport 80 -m hashlimit --hashlimit-above 200kb/s --hashlimit-burst 1mb --hashlimit-mode srcip,dstport --hashlimit-name http2 --hashlimit-htable-expire 3000 -j DROP

shows:

nft add rule ip filter INPUT tcp dport 80 flow table http2 { tcp dport . ip saddr timeout 3s limit rate over 200 kbytes/second burst 1 mbytes burst 6 packets} counter drop

which prints burst twice, this is not correct.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 extensions/libxt_hashlimit.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index 472d8e7f6cc2..3fa5719127db 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -1350,10 +1350,12 @@ static int hashlimit_mt_xlate(struct xt_xlate *xl, const char *name,
 
 	if (cfg->mode & XT_HASHLIMIT_BYTES)
 		print_bytes_rate_xlate(xl, cfg);
-	else
+	else {
 		print_packets_rate_xlate(xl, cfg->avg, revision);
-	if (cfg->burst != 5)
-		xt_xlate_add(xl, " burst %lu packets", cfg->burst);
+		if (cfg->burst != XT_HASHLIMIT_BURST)
+			xt_xlate_add(xl, " burst %lu packets", cfg->burst);
+
+	}
 	xt_xlate_add(xl, "}");
 
 	return ret;
-- 
2.11.0

