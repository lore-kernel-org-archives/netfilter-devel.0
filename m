From: Ansis Atteka <aatteka@nicira.com>
Subject: [PATCH] tests: conntrackd: fix compile errors and warnings
Date: Thu, 23 Aug 2012 18:27:22 -0700
Message-ID: <1345771642-4121-1-git-send-email-aatteka@nicira.com>
Cc: Ansis Atteka <aatteka@nicira.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:46118 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932083Ab2HXB2h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Aug 2012 21:28:37 -0400
Received: by pbbro2 with SMTP id ro2so3477752pbb.26
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Aug 2012 18:28:19 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes few compile warnings and errors.

Signed-off-by: Ansis Atteka <aatteka@nicira.com>
---
 tests/conntrackd/cthelper/expect.c |    3 ++-
 tests/conntrackd/cthelper/main.c   |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tests/conntrackd/cthelper/expect.c b/tests/conntrackd/cthelper/expect.c
index c667293..d1d1d28 100644
--- a/tests/conntrackd/cthelper/expect.c
+++ b/tests/conntrackd/cthelper/expect.c
@@ -25,7 +25,8 @@ cthelper_expect_init(struct nf_expect *exp, struct nf_conntrack *master,
 		  uint32_t class,
 		  union nfct_attr_grp_addr *saddr,
 		  union nfct_attr_grp_addr *daddr,
-		  uint8_t l4proto, uint16_t *sport, uint16_t *dport)
+		  uint8_t l4proto, uint16_t *sport, uint16_t *dport,
+		  uint32_t flags)
 {
 	struct nf_conntrack *expected, *mask;
 
diff --git a/tests/conntrackd/cthelper/main.c b/tests/conntrackd/cthelper/main.c
index f229c5d..7021f00 100755
--- a/tests/conntrackd/cthelper/main.c
+++ b/tests/conntrackd/cthelper/main.c
@@ -119,10 +119,10 @@ cthelper_process_packet(const uint8_t *pkt, uint32_t pktlen,
 		ct->myct->ct = tmp;
 
 		if (pktb_mangled(pktb)) {
-			int i;
+			uint32_t i;
 			uint8_t *data = pktb_network_header(pktb);
 
-			printf("\e[1;31mmangled content: ", pktb_len(pktb));
+			printf("\e[1;31mmangled content: ");
 
 			for (i=0; i < pktb_len(pktb); i++)
 				printf("%c", data[i]);
-- 
1.7.9.5

