From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/6] libxt_tcp: always print the mask parts
Date: Sat, 20 Aug 2011 21:24:50 +0200
Message-ID: <1313868294-21471-4-git-send-email-jengelh@medozas.de>
References: <1313868294-21471-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40060 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016Ab1HTTZB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Aug 2011 15:25:01 -0400
In-Reply-To: <1313868294-21471-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

0xFF is unlikely to happen (given that ALL translates to 0x3F at
most), but assuming that through magic, 0xFF was put into memory,
iptables -S/iptables-save would ignore printing it, practically
outputting just one argument to --tcp-flags which currently wants two.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_tcp.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index 3940d91..e849fa2 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -357,9 +357,7 @@ static void tcp_save(const void *ip, const struct xt_entry_match *match)
 		if (tcpinfo->invflags & XT_TCP_INV_FLAGS)
 			printf(" !");
 		printf(" --tcp-flags ");
-		if (tcpinfo->flg_mask != 0xFF) {
-			print_tcpf(tcpinfo->flg_mask);
-		}
+		print_tcpf(tcpinfo->flg_mask);
 		printf(" ");
 		print_tcpf(tcpinfo->flg_cmp);
 	}
-- 
1.7.3.4

