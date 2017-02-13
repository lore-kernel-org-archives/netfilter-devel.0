From: Kaarle Ritvanen <kaarle.ritvanen@datakunkku.fi>
Subject: [PATCH ulogd2 1/2] ulogd.conf: harmonize log file options with module default values
Date: Mon, 13 Feb 2017 11:47:28 +0200
Message-ID: <20170213094729.23478-1-kaarle.ritvanen@datakunkku.fi>
Cc: Kaarle Ritvanen <kaarle.ritvanen@datakunkku.fi>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from welho-filter2.welho.com ([83.102.41.24]:36298 "EHLO
        welho-filter2.welho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751007AbdBMJsA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Feb 2017 04:48:00 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Kaarle Ritvanen <kaarle.ritvanen@datakunkku.fi>
---
 ulogd.conf.in | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/ulogd.conf.in b/ulogd.conf.in
index 2fcf39a..6e7bdf4 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -183,15 +183,15 @@ nlgroup=1
 socket_path="/tmp/nuauth_ulogd2.sock"
 
 [emu1]
-file="/var/log/ulogd_syslogemu.log"
+file="/var/log/ulogd.syslogemu"
 sync=1
 
 [op1]
-file="/var/log/ulogd_oprint.log"
+file="/var/log/ulogd.pktlog"
 sync=1
 
 [gp1]
-file="/var/log/ulogd_gprint.log"
+file="/var/log/ulogd.gprint"
 sync=1
 timestamp=1
 
@@ -311,7 +311,7 @@ facility=LOG_LOCAL2
 
 [nacct1]
 sync = 1
-#file = /var/log/ulogd_nacct.log
+#file = /var/log/nacctdata.log
 
 [mark1]
 mark = 1
-- 
2.9.3

