From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 04/12] payload: disable payload merge if offsets are not on byte boundary
Date: Sun, 16 Aug 2015 21:05:47 +0200
Message-ID: <1439751955-31190-5-git-send-email-fw@strlen.de>
References: <1439751955-31190-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34745 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751047AbbHPTGJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Aug 2015 15:06:09 -0400
In-Reply-To: <1439751955-31190-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

... because it doesn't work, we attempt to merge it into wrong
place, we would have to merge the second value at a specific location.

F.e. vlan hdr 4094 gives us

0xfe0f

Merging in the CFI should yield 0xfe1f, but the constant merging
doesn't know how to achive that; at the moment 'vlan id 4094'
and 'vlan id 4094 vlan cfi 1' give same result -- 0xfe0f.

For now just turn off the optimization step unless everything is
byte divisible (the common case).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/payload.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/payload.c b/src/payload.c
index bd574ee..372dcec 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -357,6 +357,10 @@ raw:
  */
 bool payload_is_adjacent(const struct expr *e1, const struct expr *e2)
 {
+	if (e1->payload.offset % BITS_PER_BYTE || e1->len % BITS_PER_BYTE ||
+	    e2->payload.offset % BITS_PER_BYTE || e2->len % BITS_PER_BYTE)
+		return false;
+
 	if (e1->payload.base		 == e2->payload.base &&
 	    e1->payload.offset + e1->len == e2->payload.offset)
 		return true;
-- 
2.0.5

