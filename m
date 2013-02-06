From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 1/4] build: bump SONAME for libxtables
Date: Wed,  6 Feb 2013 01:47:02 +0100
Message-ID: <1360111625-1759-2-git-send-email-jengelh@inai.de>
References: <1360111625-1759-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:58917 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950Ab3BFArJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Feb 2013 19:47:09 -0500
In-Reply-To: <1360111625-1759-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Commit v1.4.17-16-gefcdba4 updated structs in xtables.h, so age must
become 0 and vcurrent be increased. The latter has already happened in
v1.4.17-6-gd1e7922.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 configure.ac |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index ffd088c..27e0b10 100644
--- a/configure.ac
+++ b/configure.ac
@@ -3,7 +3,7 @@ AC_INIT([iptables], [1.4.17])
 
 # See libtool.info "Libtool's versioning system"
 libxtables_vcurrent=10
-libxtables_vage=1
+libxtables_vage=0
 
 AC_CONFIG_AUX_DIR([build-aux])
 AC_CONFIG_HEADERS([config.h])
-- 
1.7.10.4

