From: Ana Rey <anarey@gmail.com>
Subject: [PATCH] src: proto: fixed a rreply symbol
Date: Mon, 17 Feb 2014 11:41:23 +0100
Message-ID: <1392633683-5485-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:52039 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbaBQKll (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 05:41:41 -0500
Received: by mail-ea0-f178.google.com with SMTP id a15so7026157eae.23
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Feb 2014 02:41:40 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There is a bug with rreply symbol. The rreply and reply symbol were the same.

There is a reproduction of this bug here:
$ sudo nft add rule arp art-t filter arp operation reply
$ sudo nft list table arp art-t
table arp art-t {
        chain filter {
                 type filter hook input priority 0;
                 arp operation 512
        }
}

$ sudo nft add rule arp art-t filter arp operation rreply
$ sudo nft list table arp art-t
table arp art-t {
        chain filter {
                 type filter hook input priority 0;
                 arp operation 512  <=====
                 arp operation 512  <=====
        }
}

 src/proto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/proto.c b/src/proto.c
index cc073af..3e62f92 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -661,7 +661,7 @@ static const struct symbol_table arpop_tbl = {
 		SYMBOL("request",	ARPOP_REQUEST),
 		SYMBOL("reply",		ARPOP_REPLY),
 		SYMBOL("rrequest",	ARPOP_RREQUEST),
-		SYMBOL("rreply",	ARPOP_REPLY),
+		SYMBOL("rreply",	ARPOP_RREPLY),
 		SYMBOL("inrequest",	ARPOP_InREQUEST),
 		SYMBOL("inreply",	ARPOP_InREPLY),
 		SYMBOL("nak",		ARPOP_NAK),
-- 
1.8.5.3

