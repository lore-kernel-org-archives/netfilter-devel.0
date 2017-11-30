From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH iptables] extensions: libxt_tcpmss: Add test case for invalid ranges.
Date: Thu, 30 Nov 2017 19:18:06 +0530
Message-ID: <20171130134806.21737-2-rvarsha016@gmail.com>
References: <20171130134806.21737-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pl0-f49.google.com ([209.85.160.49]:44729 "EHLO
        mail-pl0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750964AbdK3Nsn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Nov 2017 08:48:43 -0500
Received: by mail-pl0-f49.google.com with SMTP id x22so4254957pln.11
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Nov 2017 05:48:43 -0800 (PST)
In-Reply-To: <20171130134806.21737-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds test case for invalid MSS range.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 extensions/libxt_tcpmss.t | 1 +
 1 file changed, 1 insertion(+)

diff --git a/extensions/libxt_tcpmss.t b/extensions/libxt_tcpmss.t
index 3181e49d..2b415957 100644
--- a/extensions/libxt_tcpmss.t
+++ b/extensions/libxt_tcpmss.t
@@ -3,3 +3,4 @@
 -p tcp -m tcpmss --mss 42;=;OK
 -p tcp -m tcpmss --mss 42:12345;=;OK
 -p tcp -m tcpmss --mss 42:65536;;FAIL
+-p tcp -m tcpmss --mss 65535:1000;;FAIL
-- 
2.14.3

