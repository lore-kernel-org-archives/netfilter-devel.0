From: Kaarle Ritvanen <kaarle.ritvanen@datakunkku.fi>
Subject: [PATCH 2/2] rotate all default output files
Date: Fri, 10 Mar 2017 22:04:26 +0200
Message-ID: <20170310200426.15543-2-kaarle.ritvanen@datakunkku.fi>
References: <20170310200426.15543-1-kaarle.ritvanen@datakunkku.fi>
Cc: Kaarle Ritvanen <kaarle.ritvanen@datakunkku.fi>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from welho-filter1.welho.com ([83.102.41.23]:48591 "EHLO
        welho-filter1.welho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755349AbdCJUEk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Mar 2017 15:04:40 -0500
In-Reply-To: <20170310200426.15543-1-kaarle.ritvanen@datakunkku.fi>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 ulogd.logrotate | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ulogd.logrotate b/ulogd.logrotate
index b3fb6d1..8470811 100644
--- a/ulogd.logrotate
+++ b/ulogd.logrotate
@@ -1,4 +1,4 @@
-/var/log/ulogd.log /var/log/ulogd.syslogemu /var/log/ulogd.pktlog /var/log/ulogd.pcap {
+/var/log/ulogd* {
     missingok
     sharedscripts
     postrotate
-- 
2.9.3

