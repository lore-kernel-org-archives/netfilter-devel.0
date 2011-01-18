From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/5] netfilter: xtables: add missing header files to export list
Date: Tue, 18 Jan 2011 16:16:59 +0100
Message-ID: <1295363820-14881-6-git-send-email-jengelh@medozas.de>
References: <1295363820-14881-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40499 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526Ab1ARPRL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jan 2011 10:17:11 -0500
In-Reply-To: <1295363820-14881-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/Kbuild |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index 9f11fbc..fc4e0aa 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -56,6 +56,8 @@ header-y += xt_rateest.h
 header-y += xt_realm.h
 header-y += xt_recent.h
 header-y += xt_sctp.h
+header-y += xt_secmark.h
+header-y += xt_socket.h
 header-y += xt_state.h
 header-y += xt_statistic.h
 header-y += xt_string.h
-- 
1.7.1

