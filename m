From: Guruswamy Basavaiah <guru2018@gmail.com>
Subject: [PATCH] iptables-translate: Initializing comment member in xt_xlate
 structure
Date: Tue, 29 Mar 2016 00:34:36 +0530
Message-ID: <20160328190436.GA19755@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:33623 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbcC1TEm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Mar 2016 15:04:42 -0400
Received: by mail-pa0-f65.google.com with SMTP id q6so16600231pav.0
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Mar 2016 12:04:41 -0700 (PDT)
Received: from localhost.localdomain ([1.23.10.201])
        by smtp.gmail.com with ESMTPSA id e87sm37454741pfb.76.2016.03.28.12.04.39
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Mon, 28 Mar 2016 12:04:40 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Initializing comment member in xt_xlate structure. 

Because of not initializing, when translating iptables command with multiple
ip addresses, In the translated commands --comment field is getting added.

Before fix:
inbhdhcp21574:basavaia$>sudo ./iptables-translate -A INPUT --source "40.0.0.1, 30.0.0.1" --dest "20.0.0.1, 60.0.0.1" -j ACCEPT
nft add rule ip filter INPUT ip saddr 40.0.0.1 ip daddr 20.0.0.1 counter accept
add rule ip filter INPUT ip saddr 40.0.0.1 ip daddr 60.0.0.1 counter comment \" \" accept
add rule ip filter INPUT ip saddr 30.0.0.1 ip daddr 20.0.0.1 counter comment \" \" accept
add rule ip filter INPUT ip saddr 30.0.0.1 ip daddr 60.0.0.1 counter comment \" \" accept

After fix:
inbhdhcp21574:basavaia$>sudo ./iptables-translate -A INPUT --source "40.0.0.1, 30.0.0.1" --dest "20.0.0.1, 60.0.0.1" -j ACCEPT
nft add rule ip filter INPUT ip saddr 40.0.0.1 ip daddr 20.0.0.1 counter accept
add rule ip filter INPUT ip saddr 40.0.0.1 ip daddr 60.0.0.1 counter accept
add rule ip filter INPUT ip saddr 30.0.0.1 ip daddr 20.0.0.1 counter accept
add rule ip filter INPUT ip saddr 30.0.0.1 ip daddr 60.0.0.1 counter accept

Signed-off-by: Guruswamy Basavaiah <guru2018@gmail.com>
---
 libxtables/xtables.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index fe24caa..cdb56c0 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -2014,6 +2014,7 @@ struct xt_xlate *xt_xlate_alloc(int size)
 	xl->buf.size = size;
 	xl->buf.rem = size;
 	xl->buf.off = 0;
+	bzero(xl->comment, NFT_USERDATA_MAXLEN);
 
 	return xl;
 }
-- 
2.5.0

