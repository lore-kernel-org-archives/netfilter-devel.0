From: Jan Engelhardt <jengelh@medozas.de>
Subject: build: add m4 directory
Date: Sat, 21 Feb 2009 20:05:35 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902212005220.31533@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42276 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbZBUTFi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Feb 2009 14:05:38 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


parent 9bf002ff7935e7dff625683787fc3a06ac2ef2cb (conntrack-tools-0.9.11-1-g9bf002f)
commit be1ed556e5045846430cdfecfead1543faed5272
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sat Feb 21 20:04:33 2009 +0100

build: add m4 directory

Since 4dd73e4e34b57685d8a85e041f6a0b4a65200e30, the "m4" directory
is missing because git stores no empty directories. Add the
appropriate .gitignore file and the problem resolves itself.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 m4/.gitignore |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)
 create mode 100644 m4/.gitignore

diff --git a/m4/.gitignore b/m4/.gitignore
new file mode 100644
index 0000000..64d9bbc
--- /dev/null
+++ b/m4/.gitignore
@@ -0,0 +1,2 @@
+/libtool.m4
+/lt*.m4
-- 
# Created with git-export-patch

