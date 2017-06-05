From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH iptables 2/3] libip6t_icmp6: xlate: remove leftover space
Date: Tue,  6 Jun 2017 00:08:27 +0200
Message-ID: <20170605220828.4738-2-pablombg@gmail.com>
References: <20170605220828.4738-1-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33394 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751180AbdFEWKg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jun 2017 18:10:36 -0400
Received: by mail-wr0-f193.google.com with SMTP id v104so8702613wrb.0
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Jun 2017 15:10:31 -0700 (PDT)
In-Reply-To: <20170605220828.4738-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This change should have been included in commit f035be35c749
("xtables-translate: fix multiple spaces issue"), but was forgotten.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 extensions/libip6t_icmp6.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index b49a241d..37c2bcb8 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -282,8 +282,6 @@ static int icmp6_xlate(struct xt_xlate *xl,
 	if (!type_xlate_print(xl, info->type, info->code[0], info->code[1]))
 		return 0;
 
-	xt_xlate_add(xl, " ");
-
 	return 1;
 }
 
-- 
2.11.0

