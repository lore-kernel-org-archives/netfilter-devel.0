From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: [conntrack-tools PATCH v2] conntrackd.conf.5: fix sentence about
 systemd
Date: Wed, 24 Jan 2018 20:04:28 -0800
Message-ID: <151685306829.3981.8178550952886609608.stgit@endurance>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:44252 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933234AbeAYEEc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Jan 2018 23:04:32 -0500
Received: by mail-io0-f195.google.com with SMTP id z6so7179031iob.11
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jan 2018 20:04:32 -0800 (PST)
Received: from endurance ([50.233.106.125])
        by smtp.gmail.com with ESMTPSA id z3sm185960itf.0.2018.01.24.20.04.29
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 24 Jan 2018 20:04:30 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Typos, duplicated systemd word in the sentence and 'obviously'.

Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 conntrackd.conf.5 |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/conntrackd.conf.5 b/conntrackd.conf.5
index 2ce6aa3..7c5c29f 100644
--- a/conntrackd.conf.5
+++ b/conntrackd.conf.5
@@ -22,7 +22,7 @@
 .\" <http://www.gnu.org/licenses/>.
 .\" %%%LICENSE_END
 .\"
-.TH CONNTRACKD.CONF 5 "June 09, 2017"
+.TH CONNTRACKD.CONF 5 "January 24, 2018"
 
 .SH NAME
 conntrackd.conf \- configuration file for conntrackd daemon
@@ -470,7 +470,7 @@ Enable \fBsystemd(1)\fP runtime support if \fBconntrackd(8)\fP is compiled
 with the proper configuration. Then you can use a service unit of
 \fIType=notify\fP.
 
-Obviusly, this requires the init systemd of your system to be \fBsystemd(1)\fP.
+Obviously, this requires the init of your system to be \fBsystemd(1)\fP.
 
 Note: \fBsystemd(1)\fP watchdog is supported as well.
 

