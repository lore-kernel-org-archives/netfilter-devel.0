From: Neutron Soutmun <neo.neutron@gmail.com>
Subject: [PATCH] ipset: Fix hyphen used as minus sign in manpage
Date: Sun, 12 May 2013 16:30:57 +0700
Message-ID: <20130512093057.GB9286@nitrogen.neutroncom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, neo.neutron@gmail.com
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:45932 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab3ELJbE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 May 2013 05:31:04 -0400
Received: by mail-pa0-f48.google.com with SMTP id kp6so3882666pab.7
        for <netfilter-devel@vger.kernel.org>; Sun, 12 May 2013 02:31:03 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Neutron Soutmun <neo.neutron@gmail.com>
---
 src/ipset.8 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/ipset.8 b/src/ipset.8
index 6e627a2..7bb55e1 100644
--- a/src/ipset.8
+++ b/src/ipset.8
@@ -278,7 +278,7 @@ ipset create test hash:ip timeout 300
 .IP
 ipset add test 192.168.0.1 timeout 60
 .IP
-ipset -exist add test 192.168.0.1 timeout 600
+ipset \-exist add test 192.168.0.1 timeout 600
 .PP 
 .SS nomatch
 The \fBhash\fR set types which can store \fBnet\fR type of data (i.e. hash:*net*)
-- 
1.7.10.4

