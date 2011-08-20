From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/6] libxt_u32: fix missing allowance for inversion
Date: Sat, 20 Aug 2011 21:24:48 +0200
Message-ID: <1313868294-21471-2-git-send-email-jengelh@medozas.de>
References: <1313868294-21471-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40056 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754844Ab1HTTY7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Aug 2011 15:24:59 -0400
In-Reply-To: <1313868294-21471-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_u32.c   |    2 +-
 tests/options-most.rules |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_u32.c b/extensions/libxt_u32.c
index 774d5ea..6d024fb 100644
--- a/extensions/libxt_u32.c
+++ b/extensions/libxt_u32.c
@@ -24,7 +24,7 @@ enum {
 
 static const struct xt_option_entry u32_opts[] = {
 	{.name = "u32", .id = O_U32, .type = XTTYPE_STRING,
-	 .flags = XTOPT_MAND},
+	 .flags = XTOPT_MAND | XTOPT_INVERT},
 	XTOPT_TABLEEND,
 };
 
diff --git a/tests/options-most.rules b/tests/options-most.rules
index 7298a1f..c2e30f2 100644
--- a/tests/options-most.rules
+++ b/tests/options-most.rules
@@ -40,7 +40,7 @@
 -A INPUT -p tcp -m tcp ! --tcp-flags FIN,SYN,RST,ACK SYN
 -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN
 -A INPUT -p tcp -m tos --tos 0xff/0x01
--A INPUT -p tcp -m u32 --u32 "0x0=0x0" -m u32 --u32 "0x0=0x0"
+-A INPUT -p tcp -m u32 ! --u32 "0x0=0x0" -m u32 ! --u32 "0x0=0x0"
 -A INPUT -p tcp -m hbh -m hbh -m hl --hl-eq 1 -m ipv6header --header hop-by-hop --soft
 -A INPUT -m ipv6header --header hop-by-hop --soft -m rt --rt-type 2 --rt-segsleft 2 --rt-len 5 -m rt --rt-type 0 --rt-segsleft 2 --rt-len 5 --rt-0-res --rt-0-addrs ::1 --rt-0-not-strict -m rt --rt-type 0 --rt-segsleft 2 --rt-len 5 --rt-0-res --rt-0-addrs ::1,::2 --rt-0-not-strict
 -A INPUT -p tcp -m cpu --cpu 1 -m tcp --sport 1:2 --dport 1:2 --tcp-option 1 --tcp-flags FIN,SYN,RST,ACK SYN -m cpu --cpu 1
-- 
1.7.3.4

