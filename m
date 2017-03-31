From: Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH 1/4] iptables: iptables: Add blank line after declaration
Date: Fri, 31 Mar 2017 21:43:48 +0530
Message-ID: <20170331161351.26141-2-arushisinghal19971997@gmail.com>
References: <20170331161351.26141-1-arushisinghal19971997@gmail.com>
Cc: Arushi Singhal <arushisinghal19971997@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33519 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933126AbdCaQOI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Mar 2017 12:14:08 -0400
Received: by mail-pg0-f67.google.com with SMTP id 79so18432087pgf.0
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Mar 2017 09:14:07 -0700 (PDT)
In-Reply-To: <20170331161351.26141-1-arushisinghal19971997@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add blank line after the declaration of variable to follow kernel coding
style.

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
 iptables/getethertype.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/iptables/getethertype.c b/iptables/getethertype.c
index 027ef4a..bf3e408 100644
--- a/iptables/getethertype.c
+++ b/iptables/getethertype.c
@@ -75,6 +75,7 @@ struct ethertypeent *getethertypeent(void)
 {
 	char *e;
 	char *endptr;
+
 	register char *cp, **q;
 
 	if (etherf == NULL
-- 
2.11.0

