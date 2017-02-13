From: Kaarle Ritvanen <kaarle.ritvanen@datakunkku.fi>
Subject: [PATCH ulogd2 2/2] rotate all default output files
Date: Mon, 13 Feb 2017 11:47:29 +0200
Message-ID: <20170213094729.23478-2-kaarle.ritvanen@datakunkku.fi>
References: <20170213094729.23478-1-kaarle.ritvanen@datakunkku.fi>
Cc: Kaarle Ritvanen <kaarle.ritvanen@datakunkku.fi>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from welho-filter2.welho.com ([83.102.41.24]:36304 "EHLO
        welho-filter2.welho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751007AbdBMJsC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Feb 2017 04:48:02 -0500
In-Reply-To: <20170213094729.23478-1-kaarle.ritvanen@datakunkku.fi>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Kaarle Ritvanen <kaarle.ritvanen@datakunkku.fi>
---
 ulogd.logrotate | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ulogd.logrotate b/ulogd.logrotate
index b3fb6d1..3b4c487 100644
--- a/ulogd.logrotate
+++ b/ulogd.logrotate
@@ -1,4 +1,4 @@
-/var/log/ulogd.log /var/log/ulogd.syslogemu /var/log/ulogd.pktlog /var/log/ulogd.pcap {
+/var/log/ulogd.log /var/log/ulogd.syslogemu /var/log/ulogd.pktlog /var/log/ulogd.gprint /var/log/ulogd.json /var/log/ulogd.pcap /var/log/ulogd.sqlite3db /var/log/nacctdata.log {
     missingok
     sharedscripts
     postrotate
-- 
2.9.3

