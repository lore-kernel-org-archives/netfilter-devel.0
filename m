From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/9] build: bump libxtables ABI version
Date: Sun,  1 May 2011 13:50:21 +0200
Message-ID: <1304250630-6150-2-git-send-email-jengelh@medozas.de>
References: <1304250630-6150-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49995 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab1EALuf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 May 2011 07:50:35 -0400
In-Reply-To: <1304250630-6150-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adding the x6_* members to struct xtables_{match,target} caused a
change requiring a bump.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/configure.ac b/configure.ac
index eb447e0..38b7b79 100644
--- a/configure.ac
+++ b/configure.ac
@@ -2,7 +2,7 @@
 AC_INIT([iptables], [1.4.10])
 
 # See libtool.info "Libtool's versioning system"
-libxtables_vcurrent=5
+libxtables_vcurrent=6
 libxtables_vage=0
 
 AC_CONFIG_HEADERS([config.h])
-- 
1.7.1

