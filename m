From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libxt_connmark: Fix order of mask and mark
Date: Wed, 1 Jun 2016 23:38:27 +0530
Message-ID: <20160601180827.GA5279@shivani>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35794 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbcFASJL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Jun 2016 14:09:11 -0400
Received: by mail-pf0-f193.google.com with SMTP id f144so4809708pfa.2
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Jun 2016 11:09:11 -0700 (PDT)
Received: from shivani ([116.202.32.105])
        by smtp.gmail.com with ESMTPSA id x71sm24189625pfj.43.2016.06.01.11.09.08
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 01 Jun 2016 11:09:10 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The order of mask and mark in the output is wrong. This has been pointed
out: http://git.netfilter.org/iptables/commit/?id=8548dd253833027c68ac6400c3118ef788fabe5d
by Liping Zhang <liping.zhang@spreadtrum.com>.
This patch fixes the same issue with connmark.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libxt_connmark.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_connmark.c b/extensions/libxt_connmark.c
index fbfeb74..958a50c 100644
--- a/extensions/libxt_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -127,8 +127,8 @@ static void print_mark_xlate(unsigned int mark, unsigned int mask,
 			     struct xt_xlate *xl, uint32_t op)
 {
 	if (mask != 0xffffffffU)
-		xt_xlate_add(xl, " and 0x%x %s 0x%x ", mark,
-			   op == XT_OP_EQ ? "==" : "!=", mask);
+		xt_xlate_add(xl, " and 0x%x %s 0x%x ", mask,
+			   op == XT_OP_EQ ? "==" : "!=", mark);
 	else
 		xt_xlate_add(xl, " %s0x%x ",
 			   op == XT_OP_EQ ? "" : "!= ", mark);
-- 
1.9.1

