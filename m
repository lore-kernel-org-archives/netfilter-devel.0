From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [iptables-nftables PATCH v2] src: display rule by number
Date: Fri, 12 Jul 2013 13:27:33 +0200
Message-ID: <20130712112649.7295.62611.stgit@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:43766 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932746Ab3GLL1s (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Jul 2013 07:27:48 -0400
Received: by mail-wi0-f170.google.com with SMTP id ey16so580927wid.5
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Jul 2013 04:27:47 -0700 (PDT)
Received: from [127.0.0.1] ([46.182.89.220])
        by mx.google.com with ESMTPSA id s19sm2747592wik.11.2013.07.12.04.27.45
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Fri, 12 Jul 2013 04:27:46 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes the display of rule by number.

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft.c               |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 98d602c..7ff9c70 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2450,19 +2450,19 @@ __nft_rule_list(struct nft_handle *h, struct nft_chain *c, const char *table,
 		    strcmp(chain, rule_chain) != 0)
 			goto next;
 
-		if (rulenum > 0) {
+		if (rulenum > 0 && rule_ctr != rulenum) {
 			/* List by rule number case */
-			if (rule_ctr != rulenum) {
-				rule_ctr++;
-				goto next;
-			}
-		} else {
-			struct iptables_command_state cs = {};
-			/* Show all rules case */
-			nft_rule_to_iptables_command_state(r, &cs);
-
-			cb(&cs, r, rule_ctr, format);
+			goto next;
 		}
+		
+		struct iptables_command_state cs = {};
+		/* Show all rules case */
+		nft_rule_to_iptables_command_state(r, &cs);
+
+		cb(&cs, r, rule_ctr, format);
+		if (rulenum > 0 && rule_ctr == rulenum)
+			break; 
+
 next:
 		r = nft_rule_list_iter_next(iter);
 	}

