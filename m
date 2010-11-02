From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ipset-5: 1/9] Kernel compile-time files are added to .gitignore
Date: Tue,  2 Nov 2010 15:35:26 +0100
Message-ID: <1288708534-14510-2-git-send-email-kadlec@blackhole.kfki.hu>
References: <1288708534-14510-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.7.0.4"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:46739 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981Ab0KBOfg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Nov 2010 10:35:36 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 1591118815E
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Nov 2010 15:35:35 +0100 (CET)
Received: from smtp1.kfki.hu ([127.0.0.1])
	by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rzwHOiskCjU0 for <netfilter-devel@vger.kernel.org>;
	Tue,  2 Nov 2010 15:35:35 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp1.kfki.hu (Postfix) with ESMTP id F39E4188157
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Nov 2010 15:35:34 +0100 (CET)
In-Reply-To: <1288708534-14510-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------1.7.0.4
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 .gitignore |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)


--------------1.7.0.4
Content-Type: text/x-patch; name="0001-Kernel-compile-time-files-are-added-to-.gitignore.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="0001-Kernel-compile-time-files-are-added-to-.gitignore.patch"

diff --git a/.gitignore b/.gitignore
index 9f6660e..6992cc9 100644
--- a/.gitignore
+++ b/.gitignore
@@ -7,6 +7,15 @@
 Makefile
 Makefile.in
 
+*.o.cmd
+*.ko
+*.ko.cmd
+*.mod.c
+*.mod.o.cmd
+.tmp_versions
+Module.symvers
+modules.order
+
 /aclocal.m4
 /autom4te.cache
 /compile

--------------1.7.0.4--


