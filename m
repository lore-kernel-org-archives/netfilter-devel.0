Return-Path: <SRS0=UO6N=UP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75F0AC31E49
	for <netfilter-devel@archiver.kernel.org>; Sun, 16 Jun 2019 09:29:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 584C7216C8
	for <netfilter-devel@archiver.kernel.org>; Sun, 16 Jun 2019 09:29:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbfFPJ3w (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 16 Jun 2019 05:29:52 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:39676 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725766AbfFPJ3w (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 16 Jun 2019 05:29:52 -0400
X-Greylist: delayed 1421 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Jun 2019 05:29:51 EDT
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hcR73-0000JW-L1; Sun, 16 Jun 2019 11:06:09 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] datatype: fix print of raw numerical symbol values
Date:   Sun, 16 Jun 2019 10:55:49 +0200
Message-Id: <20190616085549.1087-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The two rules:
arp operation 1-2 accept
arp operation 256-512 accept

are both shown as 256-512:

        chain in_public {
                arp operation 256-512 accept
                arp operation 256-512 accept
                meta mark "1"
                tcp flags 2,4
        }

This is because range expression enforces numeric output,
yet nft_print doesn't respect byte order.

Behave as if we had no symbol in the first place and call
the base type print function instead.

This means we now respect format specifier as well:
	chain in_public {
                arp operation 1-2 accept
                arp operation 256-512 accept
                meta mark "0x00000001"
                tcp flags 0x2,0x4
	}

Without fix, added test case will fail:
'add rule arp test-arp input arp operation 1-2': 'arp operation 1-2' mismatches 'arp operation 256-512'

Signed-off-by: Florian Westphal <fw@strlen.de>
---
  Note there is a discrepancy between output when we have a symbol and
  when we do not.

  Example, add rule:
  meta mark "foo"

  (with '1 "foo"' in rt_marks), nft will print quotes when symbol
  printing is inhibited via -n, but elides them in case the symbol
  is not available.

 src/datatype.c                    | 2 +-
 tests/py/arp/arp.t                | 1 +
 tests/py/arp/arp.t.payload        | 6 ++++++
 tests/py/arp/arp.t.payload.netdev | 8 ++++++++
 4 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/src/datatype.c b/src/datatype.c
index 8ae3aa1c3f90..d193ccc0a659 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -198,7 +198,7 @@ void symbolic_constant_print(const struct symbol_table *tbl,
 		nft_print(octx, "\"");
 
 	if (nft_output_numeric_symbol(octx))
-		nft_print(octx, "%" PRIu64 "", val);
+		expr_basetype(expr)->print(expr, octx);
 	else
 		nft_print(octx, "%s", s->identifier);
 
diff --git a/tests/py/arp/arp.t b/tests/py/arp/arp.t
index 86bab5232eaf..2540c0a77419 100644
--- a/tests/py/arp/arp.t
+++ b/tests/py/arp/arp.t
@@ -38,6 +38,7 @@ arp plen != {33-55};ok
 
 arp operation {nak, inreply, inrequest, rreply, rrequest, reply, request};ok
 arp operation != {nak, inreply, inrequest, rreply, rrequest, reply, request};ok
+arp operation 1-2;ok
 arp operation request;ok
 arp operation reply;ok
 arp operation rrequest;ok
diff --git a/tests/py/arp/arp.t.payload b/tests/py/arp/arp.t.payload
index d36bef183396..52c993294810 100644
--- a/tests/py/arp/arp.t.payload
+++ b/tests/py/arp/arp.t.payload
@@ -188,6 +188,12 @@ arp test-arp input
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
+# arp operation 1-2
+arp test-arp input
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ cmp gte reg 1 0x00000100 ]
+  [ cmp lte reg 1 0x00000200 ]
+
 # arp operation request
 arp test-arp input
   [ payload load 2b @ network header + 6 => reg 1 ]
diff --git a/tests/py/arp/arp.t.payload.netdev b/tests/py/arp/arp.t.payload.netdev
index 0146cf500ee2..667691fff2f6 100644
--- a/tests/py/arp/arp.t.payload.netdev
+++ b/tests/py/arp/arp.t.payload.netdev
@@ -246,6 +246,14 @@ netdev test-netdev ingress
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
+# arp operation 1-2
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ cmp gte reg 1 0x00000100 ]
+  [ cmp lte reg 1 0x00000200 ]
+
 # arp operation request
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-- 
2.21.0

