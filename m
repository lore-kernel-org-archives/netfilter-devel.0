From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/4] doc: fix an unbalanced tag
Date: Wed, 11 Nov 2009 13:54:18 +0100
Message-ID: <1257944062-6988-2-git-send-email-jengelh@medozas.de>
References: <1257944062-6988-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43724 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755263AbZKKMyU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Nov 2009 07:54:20 -0500
In-Reply-To: <1257944062-6988-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ipset.8 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/ipset.8 b/ipset.8
index 55e5d9b..c07fc81 100644
--- a/ipset.8
+++ b/ipset.8
@@ -103,7 +103,7 @@ Add an IP entry to a set.
 .BI "-D, --del " "\fIsetname\fP \fIIP\fP"
 Delete an IP entry from a set. 
 .TP
-.BI "-T, --test " "\fIsetname\fP \fIIP
+.BI "-T, --test " "\fIsetname\fP \fIIP\fP
 Test wether an IP entry is in a set or not. Exit status number is zero
 if the tested IP is in the set and nonzero if it is missing from 
 the set.
-- 
1.6.5.2

