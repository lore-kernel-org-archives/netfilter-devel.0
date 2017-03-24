From: Laura Garcia Liebana <laura.garcia@zevenet.com>
Subject: [PATCH nft] src: hash: fix seed attribute not listed
Date: Fri, 24 Mar 2017 20:53:12 +0100
Message-ID: <20170324195312.wv5gdyrpxld5mwbn@nevthink>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:33175 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752556AbdCXTxS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Mar 2017 15:53:18 -0400
Received: by mail-wr0-f174.google.com with SMTP id y90so201369wrb.0
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 12:53:17 -0700 (PDT)
Received: from nevthink ([91.126.74.89])
        by smtp.gmail.com with ESMTPSA id n80sm1357699wrb.24.2017.03.24.12.53.15
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 Mar 2017 12:53:15 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The tests warned about a problem with the seed listing.

/tests/py# ./nft-test.py ip/hash.t
ip/hash.t: WARNING: line: 4: 'src/nft add rule --debug=netlink \
 ip test-ip4 pre ct mark set jhash ip saddr . ip daddr mod 2 \
 seed 0xdeadbeef': 'ct mark set jhash ip saddr . ip daddr mod 2 \
 seed 0xdeadbeef' mismatches 'ct mark set jhash ip saddr . ip \
 daddr mod 2'
ip/hash.t: WARNING: line: 6: 'src/nft add rule --debug=netlink \
 ip test-ip4 pre ct mark set jhash ip saddr . ip daddr mod 2 seed \
 0xdeadbeef offset 100': 'ct mark set jhash ip saddr . ip daddr \
 mod 2 seed 0xdeadbeef offset 100' mismatches 'ct mark set jhash \
 ip saddr . ip daddr mod 2 offset 100'
ip/hash.t: 6 unit tests, 0 error, 2 warning

The expression type is now treated as an unsigned int in the
hash_expr_print() function.

Fixes 3a86406 ("src: hash: support of symmetric hash")

Signed-off-by: Laura Garcia Liebana <laura.garcia@zevenet.com>
---
 src/hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/hash.c b/src/hash.c
index a7a9612..bec1684 100644
--- a/src/hash.c
+++ b/src/hash.c
@@ -28,7 +28,7 @@ static void hash_expr_print(const struct expr *expr)
 	}
 
 	printf(" mod %u", expr->hash.mod);
-	if (expr->hash.type & NFT_HASH_JENKINS && expr->hash.seed)
+	if ((expr->hash.type == NFT_HASH_JENKINS) && expr->hash.seed)
 		printf(" seed 0x%x", expr->hash.seed);
 	if (expr->hash.offset)
 		printf(" offset %u", expr->hash.offset);
-- 
2.11.0

