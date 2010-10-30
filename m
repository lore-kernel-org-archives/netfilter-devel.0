From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 07/10] build: set Libs.private for pkgconfig file
Date: Sun, 31 Oct 2010 00:11:12 +0200
Message-ID: <1288476676-32749-8-git-send-email-jengelh@medozas.de>
References: <1288476676-32749-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49979 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab0J3WL0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:11:26 -0400
In-Reply-To: <1288476676-32749-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Similar to the commit in iptables, add Libs.private to tell about
dependencies for static linking.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 libnetfilter_queue.pc.in |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/libnetfilter_queue.pc.in b/libnetfilter_queue.pc.in
index 962c686..9c6c2c4 100644
--- a/libnetfilter_queue.pc.in
+++ b/libnetfilter_queue.pc.in
@@ -12,4 +12,5 @@ Version: @VERSION@
 Requires: libnfnetlink
 Conflicts:
 Libs: -L${libdir} -lnetfilter_queue
+Libs.private: @LIBNFNETLINK_LIBS@
 Cflags: -I${includedir}
-- 
1.7.1

