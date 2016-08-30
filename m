From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [conntrack-tools PATCH 3/4] conntrackd.8: add reference to systemd
Date: Tue, 30 Aug 2016 14:20:45 +0200
Message-ID: <147255964566.17411.5301986542060967309.stgit@nfdev2.cica.es>
References: <147255963490.17411.649527820452381341.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:37041 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1758219AbcH3MUq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2016 08:20:46 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 0CCAD51F160
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 12:20:39 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id fO3GMkQD88OK for <netfilter-devel@vger.kernel.org>;
        Tue, 30 Aug 2016 14:20:34 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 1D32C51F146
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 14:20:34 +0200 (CEST)
In-Reply-To: <147255963490.17411.649527820452381341.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add reference to systemd integration in the manpage.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 conntrackd.8 |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/conntrackd.8 b/conntrackd.8
index bd195ec..6ccf261 100644
--- a/conntrackd.8
+++ b/conntrackd.8
@@ -145,6 +145,13 @@ event filtering. Otherwise, all the event filtering is done in userspace with
 the corresponding extra overhead. If you are not using the Filter clause in
 the configuration file, ignore this notice.
 
+.SH SYSTEMD INTEGRATION
+Starting with the 1.4.4 release, \fBconntrackd\fP includes integration with
+\fBsystemd(1)\fP to use an unit file of \fIType=notify\fP and watchdog support.
+
+The daemon should be configured at build time to include such support
+and \fBconntrackd.conf(5)\fP should contain \fBSystemd on\fP.
+
 .SH INCOMPATIBILITIES
 During the 0.9.9 development, some important changes in the replication message
 format were introduced. Therefore, \fBconntrackd\fP >= 0.9.9 will not work

