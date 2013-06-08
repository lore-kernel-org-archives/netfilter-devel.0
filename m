From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [PATCH] fix leak of iter in nft_rule_list
Date: Sat, 08 Jun 2013 15:40:04 +0200
Message-ID: <20130608134004.4582.54427.stgit@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:46054 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3FHNkT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Jun 2013 09:40:19 -0400
Received: by mail-wi0-f182.google.com with SMTP id cb5so1922640wib.15
        for <netfilter-devel@vger.kernel.org>; Sat, 08 Jun 2013 06:40:17 -0700 (PDT)
Received: from [127.0.0.1] ([46.182.90.145])
        by mx.google.com with ESMTPSA id r9sm2367553wik.1.2013.06.08.06.40.15
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Sat, 08 Jun 2013 06:40:17 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Leak of iter in nft_rule_list function fixed.

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 5a0b814..7223c79 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2520,6 +2520,7 @@ next:
 		c = nft_chain_list_iter_next(iter);
 	}
 
+	nft_chain_list_iter_destroy(iter);
 	nft_chain_list_free(list);
 
 	return 1;

