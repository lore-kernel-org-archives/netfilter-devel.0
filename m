From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH v2] libxt_TOS: add tests for translation infrastructure
Date: Tue, 17 Oct 2017 17:59:37 +0530
Message-ID: <20171017122937.20617-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:46108 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754079AbdJQMbz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2017 08:31:55 -0400
Received: by mail-pg0-f66.google.com with SMTP id k7so1307906pga.3
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 05:31:55 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch checks that the iptables TOS to nftables translation works fine.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
Changes in v2:
 -Change subject and log message

 extensions/libxt_TOS.txlate | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 extensions/libxt_TOS.txlate

diff --git a/extensions/libxt_TOS.txlate b/extensions/libxt_TOS.txlate
new file mode 100644
index 00000000..6d55eb24
--- /dev/null
+++ b/extensions/libxt_TOS.txlate
@@ -0,0 +1,25 @@
+ip6tables-translate -A INPUT -j TOS --set-tos 0x1f
+nft add rule ip6 filter INPUT counter ip6 dscp set 0x07
+
+ip6tables-translate -A INPUT -j TOS --set-tos 0xff
+nft add rule ip6 filter INPUT counter ip6 dscp set 0x3f
+
+ip6tables-translate -A INPUT -j TOS --set-tos Minimize-Delay
+nft add rule ip6 filter INPUT counter ip6 dscp set 0x04
+
+ip6tables-translate -A INPUT -j TOS --set-tos Minimize-Cost
+nft add rule ip6 filter INPUT counter ip6 dscp set 0x00
+
+ip6tables-translate -A INPUT -j TOS --set-tos Normal-Service
+nft add rule ip6 filter INPUT counter ip6 dscp set 0x00
+
+ip6tables-translate -A INPUT -j TOS --and-tos 0x12
+nft add rule ip6 filter INPUT counter ip6 dscp set 0x00
+
+ip6tables-translate -A INPUT -j TOS --or-tos 0x12
+nft add rule ip6 filter INPUT counter ip6 dscp set 0x04
+
+ip6tables-translate -A INPUT -j TOS --xor-tos 0x12
+nft add rule ip6 filter INPUT counter ip6 dscp set 0x04
+
+
-- 
2.11.0

