From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/2] build: use only AC_CANONICAL_HOST
Date: Fri, 31 Dec 2010 00:44:20 +0100
Message-ID: <1293752662-13961-2-git-send-email-jengelh@medozas.de>
References: <1293752662-13961-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43863 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab0L3XoY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:44:24 -0500
In-Reply-To: <1293752662-13961-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Calculating AC_CANONICAL_TARGET is superfluous, because ipset is not a
code generator.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index 7b6d276..c5bcdce 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,12 +1,12 @@
 dnl Boilerplate
 AC_INIT([ipset], [5.2], [kadlec@blackhole.kfki.hu])
-AC_CANONICAL_TARGET
+AC_CANONICAL_HOST
 AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_HEADER([config.h])
 AM_INIT_AUTOMAKE([-Wall -Werror foreign subdir-objects])
 
 dnl Shortcut: Linux supported alone
-case $target in
+case "$host" in
 *-*-linux*) ;;
 *) AC_MSG_ERROR([Linux systems supported exclusively!]);;
 esac
-- 
1.7.1

