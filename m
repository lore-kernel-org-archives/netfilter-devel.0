From: Saikiran Madugula <hummerbliss@gmail.com>
Subject: [PATCH] iptables: Add autoreconf step in INSTALL document.
Date: Thu, 23 Jul 2009 14:26:31 +0100
Message-ID: <4A686507.7010403@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Saikiran Madugula <hummerbliss@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:49132 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbZGWN0d (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jul 2009 09:26:33 -0400
Received: by ewy26 with SMTP id 26so971307ewy.37
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jul 2009 06:26:32 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add autoreconf step in INSTALL document to clarify that one has
to do autoreconf before they can do any ./configure.

Signed-off-by: Saikiran Madugula <hummerbliss@gmail.com>
---
 INSTALL |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/INSTALL b/INSTALL
index 4a44989..a1da8ba 100644
--- a/INSTALL
+++ b/INSTALL
@@ -3,6 +3,7 @@ Installation instructions for iptables
 
 iptables uses the well-known configure(autotools) infrastructure.
 
+	$ autoreconf -vfi
 	$ ./configure
 	$ make
 	# make install
-- 
1.5.6.3
