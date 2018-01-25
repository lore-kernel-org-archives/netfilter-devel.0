From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: [conntrack-tools PATCH] conntrackd.conf.5: fix typo,
 duplicated systemd word in the sentence
Date: Wed, 24 Jan 2018 19:44:34 -0800
Message-ID: <151685187494.3215.10360323849964751390.stgit@endurance>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:44447 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933342AbeAYDoi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Jan 2018 22:44:38 -0500
Received: by mail-pf0-f196.google.com with SMTP id m26so4826225pfj.11
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jan 2018 19:44:38 -0800 (PST)
Received: from endurance ([50.233.106.125])
        by smtp.gmail.com with ESMTPSA id o186sm2157106pga.16.2018.01.24.19.44.35
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 24 Jan 2018 19:44:36 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Delete duplicated word.

Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 conntrackd.conf.5 |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/conntrackd.conf.5 b/conntrackd.conf.5
index 2ce6aa3..689e692 100644
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
+Obviusly, this requires the init of your system to be \fBsystemd(1)\fP.
 
 Note: \fBsystemd(1)\fP watchdog is supported as well.
 

