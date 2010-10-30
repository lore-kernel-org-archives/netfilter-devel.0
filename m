From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/7] build: set Libs.private for pkgconfig file
Date: Sun, 31 Oct 2010 00:08:15 +0200
Message-ID: <1288476502-18721-2-git-send-email-jengelh@medozas.de>
References: <1288476502-18721-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46342 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857Ab0J3WJD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:09:03 -0400
In-Reply-To: <1288476502-18721-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Similar to the commit in iptables, add Libs.private to tell about
dependencies for static linking.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 libnetfilter_conntrack.pc.in |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/libnetfilter_conntrack.pc.in b/libnetfilter_conntrack.pc.in
index e706c0a..857f993 100644
--- a/libnetfilter_conntrack.pc.in
+++ b/libnetfilter_conntrack.pc.in
@@ -12,4 +12,5 @@ Version: @VERSION@
 Requires: libnfnetlink
 Conflicts:
 Libs: -L${libdir} -lnetfilter_conntrack
+Libs.private: @LIBNFNETLINK_LIBS@
 Cflags: -I${includedir}
-- 
1.7.1

