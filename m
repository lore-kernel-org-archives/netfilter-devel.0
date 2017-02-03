From: Kaarle Ritvanen <kaarle.ritvanen@datakunkku.fi>
Subject: [PATCH ulogd2] adjust ulogd.logrotate to match ulogd.conf
Date: Fri,  3 Feb 2017 13:24:27 +0200
Message-ID: <20170203112427.22678-1-kaarle.ritvanen@datakunkku.fi>
Cc: Kaarle Ritvanen <kaarle.ritvanen@datakunkku.fi>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from welho-filter2.welho.com ([83.102.41.24]:57258 "EHLO
        welho-filter2.welho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752296AbdBCLbt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Feb 2017 06:31:49 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Kaarle Ritvanen <kaarle.ritvanen@datakunkku.fi>
---
 ulogd.logrotate | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ulogd.logrotate b/ulogd.logrotate
index b3fb6d1..a865353 100644
--- a/ulogd.logrotate
+++ b/ulogd.logrotate
@@ -1,4 +1,4 @@
-/var/log/ulogd.log /var/log/ulogd.syslogemu /var/log/ulogd.pktlog /var/log/ulogd.pcap {
+/var/log/ulogd*.log {
     missingok
     sharedscripts
     postrotate
-- 
2.9.3

