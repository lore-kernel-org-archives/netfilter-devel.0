From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] extensions: add tests for ipcomp protocol
Date: Mon, 23 Oct 2017 09:53:16 +0530
Message-ID: <20171023042316.4278-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:45193 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750743AbdJWEXh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Oct 2017 00:23:37 -0400
Received: by mail-pf0-f194.google.com with SMTP id d28so16167848pfe.2
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Oct 2017 21:23:37 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds test for ipcomp protocol.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 extensions/libxt_ipcomp.t | 5 +++++
 1 file changed, 5 insertions(+)
 create mode 100644 extensions/libxt_ipcomp.t

diff --git a/extensions/libxt_ipcomp.t b/extensions/libxt_ipcomp.t
new file mode 100644
index 00000000..ce111142
--- /dev/null
+++ b/extensions/libxt_ipcomp.t
@@ -0,0 +1,5 @@
+:INPUT,FORWARD
+-m policy --dir in --pol ipsec --proto ipcomp;=;OK
+-m policy --dir in --pol none --proto ipcomp;;FAIL
+-m policy --dir in --pol ipsec --strict --reqid 1 --spi 0x1 --proto ipcomp;=;OK
+-m policy --dir in --pol ipsec --strict --reqid 1 --spi 0x1 --proto ipcomp --mode tunnel --tunnel-dst 10.0.0.0/8 --tunnel-src 10.0.0.0/8 --next --reqid 2;=;OK
-- 
2.11.0

