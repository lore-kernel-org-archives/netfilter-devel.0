From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH] include: add missing unistd.h
Date: Mon, 20 Dec 2010 01:44:43 +0100
Message-ID: <1292805884-27782-2-git-send-email-jengelh@medozas.de>
References: <1292805884-27782-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59276 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab0LTAor (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 Dec 2010 19:44:47 -0500
In-Reply-To: <1292805884-27782-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When a project uses MNL_SOCKET_BUFFER_SIZE without having included
unistd.h, it gets:

mystuff.c:36:2: warning: implicit declaration of function "getpagesize"

It is libmnl's job to include this, since mystuff.c did not use
getpagesize anywhere.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/libmnl/libmnl.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
index 78fd0c4..3e69629 100644
--- a/include/libmnl/libmnl.h
+++ b/include/libmnl/libmnl.h
@@ -9,6 +9,7 @@
 #	include <stdio.h>
 #	include <stdint.h>
 #endif
+#include <unistd.h>
 #include <sys/socket.h> /* for sa_family_t */
 #include <linux/netlink.h>
 
-- 
1.7.1

