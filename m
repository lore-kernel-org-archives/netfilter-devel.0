From: Andreas Schwab <schwab@linux-m68k.org>
Subject: [PATCH] libxt_tcp: print space before, not after "flags:"
Date: Mon, 20 Aug 2012 18:52:36 +0200
Message-ID: <m2k3wt4iaz.fsf@igel.home>
Mime-Version: 1.0
Content-Type: text/plain
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:44062 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514Ab2HTQwj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:52:39 -0400
Received: from frontend1.mail.m-online.net (unknown [192.168.8.180])
	by mail-out.m-online.net (Postfix) with ESMTP id 3X11KK4Zztz4KK6L
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Aug 2012 18:52:37 +0200 (CEST)
Received: from igel.home (ppp-88-217-97-100.dynamic.mnet-online.de [88.217.97.100])
	by mail.mnet-online.de (Postfix) with ESMTPA id 3X11KK2w3gzbbfJ
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Aug 2012 18:52:37 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
---
 extensions/libxt_tcp.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index e849fa2..bbdec45 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -278,11 +278,10 @@ static void
 print_flags(uint8_t mask, uint8_t cmp, int invert, int numeric)
 {
 	if (mask || invert) {
-		printf("flags:%s", invert ? "!" : "");
+		printf(" flags:%s", invert ? "!" : "");
 		if (numeric)
-			printf(" 0x%02X/0x%02X", mask, cmp);
+			printf("0x%02X/0x%02X", mask, cmp);
 		else {
-			printf(" ");
 			print_tcpf(mask);
 			printf("/");
 			print_tcpf(cmp);
-- 
1.7.12


-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
