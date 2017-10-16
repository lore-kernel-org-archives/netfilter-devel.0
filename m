From: Aastha Gupta <aastha.gupta4104@gmail.com>
Subject: [PATCH] iptables: add test file for TCPMSS extension
Date: Tue, 17 Oct 2017 02:32:09 +0530
Message-ID: <1508187729-3926-1-git-send-email-aastha.gupta4104@gmail.com>
Cc: Aastha Gupta <aastha.gupta4104@gmail.com>
To: outreachy-kernel@googlegroups.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:52498 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757531AbdJPVCP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Oct 2017 17:02:15 -0400
Received: by mail-pg0-f68.google.com with SMTP id a192so6365902pge.9
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Oct 2017 14:02:15 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds test file for the recently added TCPMSS extension.

Signed-off-by: Aastha Gupta <aastha.gupta4104@gmail.com>
---
 extensions/libxt_TCPMSS.txlate | 5 +++++
 1 file changed, 5 insertions(+)
 create mode 100644 extensions/libxt_TCPMSS.txlate

diff --git a/extensions/libxt_TCPMSS.txlate b/extensions/libxt_TCPMSS.txlate
new file mode 100644
index 0000000..6a64d2c
--- /dev/null
+++ b/extensions/libxt_TCPMSS.txlate
@@ -0,0 +1,5 @@
+iptables-translate -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
+nft add rule ip filter FORWARD tcp flags & (syn|rst) == syn counter tcp option maxseg size set rt mtu
+
+iptables-translate -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 90
+nft add rule ip filter FORWARD tcp flags & (syn|rst) == syn counter tcp option maxseg size set 90
-- 
2.7.4

