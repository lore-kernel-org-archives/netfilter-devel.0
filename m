From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] scanner: IPv4-Mapped IPv6 addresses support
Date: Mon,  9 Oct 2017 13:48:12 +0200
Message-ID: <1507549692-9878-2-git-send-email-pablo@netfilter.org>
References: <1507549692-9878-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49398 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751257AbdJILsa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Oct 2017 07:48:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2180080FF8
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Oct 2017 13:48:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 11EF3DA80B
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Oct 2017 13:48:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 14510DA86B
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Oct 2017 13:48:27 +0200 (CEST)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DA5404025FBA
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Oct 2017 13:48:26 +0200 (CEST)
In-Reply-To: <1507549692-9878-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The scanner rejects IPv4-Mapped IPv6 addresses, eg.

 # cat test
 #!/usr/sbin/nft -f
 flush ruleset
 table inet global {
    set blackhole_ipv6 {
        type ipv6_addr
        flags interval
        elements = { ::ffff:0.0.0.0/96 }
    }
 }

 # nft -f test
 test:8:30-38: Error: syntax error, unexpected string, expecting comma or '}'
        elements = { ::ffff:0.0.0.0/96 }
                            ^^^^^^^^^^

According to RFC4291, Sect. 2.5.5.2. IPv4-Mapped IPv6 Address:

   |                80 bits               | 16 |      32 bits        |
   +--------------------------------------+--------------------------+
   |0000..............................0000|FFFF|    IPv4 address     |
   +--------------------------------------+----+---------------------+

Update scanner bits to parse this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/scanner.l | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/scanner.l b/src/scanner.l
index 186fb47eb763..594073660c6b 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -160,7 +160,8 @@ v63		({v630}|{v631}|{v632}|{v633})
 v620		((:)((:{hex4}){2}))
 v621		((({hex4}:){1})((:{hex4}){1}))
 v622		((({hex4}:){2})(:))
-v62		({v620}|{v621}|{v622})
+v62_rfc4291	((:)(:[fF]{4})(:{ip4addr}))
+v62		({v620}|{v621}|{v622}|{v62_rfc4291})
 v610		((:)(:{hex4}{1}))
 v611		((({hex4}:){1})(:))
 v61		({v610}|{v611})
-- 
2.1.4

