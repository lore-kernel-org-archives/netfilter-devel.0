From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/4] doc: fix undesired newline in ip6tables-restore(8)
Date: Sun, 11 Sep 2011 12:38:44 +0200
Message-ID: <1315737527-19595-3-git-send-email-jengelh@medozas.de>
References: <1315737527-19595-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:56941 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249Ab1IKKiy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Sep 2011 06:38:54 -0400
In-Reply-To: <1315737527-19595-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 iptables/ip6tables-restore.8 |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/iptables/ip6tables-restore.8 b/iptables/ip6tables-restore.8
index 0264807..aa09768 100644
--- a/iptables/ip6tables-restore.8
+++ b/iptables/ip6tables-restore.8
@@ -32,7 +32,6 @@ I/O redirection provided by your shell to read from a file
 restore the values of all packet and byte counters
 .TP
 \fB\-n\fR, \fB\-\-noflush\fR 
-.TP
 don't flush the previous contents of the table. If not specified, 
 .B ip6tables-restore
 flushes (deletes) all previous contents of the respective IPv6 Table.
-- 
1.7.3.4

