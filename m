From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/4] doc: the -m option cannot be inverted
Date: Tue,  5 Jul 2011 15:14:40 +0200
Message-ID: <1309871682-27307-4-git-send-email-jengelh@medozas.de>
References: <1309871682-27307-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:42323 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932350Ab1GENOw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jul 2011 09:14:52 -0400
In-Reply-To: <1309871682-27307-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 iptables/ip6tables.8.in |    3 ---
 iptables/iptables.8.in  |    3 ---
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/iptables/ip6tables.8.in b/iptables/ip6tables.8.in
index 0f7e3cc..748cebb 100644
--- a/iptables/ip6tables.8.in
+++ b/iptables/ip6tables.8.in
@@ -366,9 +366,6 @@ module.  You can specify multiple extended match modules in one line,
 and you can use the \fB\-h\fP or \fB\-\-help\fP
 options after the module has been specified to receive help specific
 to that module.
-.PP
-The following are included in the base package, and most of these can
-be preceded by a "\fB!\fP" to invert the sense of the match.
 .\" @MATCH@
 .SH TARGET EXTENSIONS
 ip6tables can use extended target modules: the following are included
diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
index 3b717a1..24618b7 100644
--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -365,9 +365,6 @@ module.  You can specify multiple extended match modules in one line,
 and you can use the \fB\-h\fP or \fB\-\-help\fP
 options after the module has been specified to receive help specific
 to that module.
-.PP
-The following are included in the base package, and most of these can
-be preceded by a "\fB!\fP" to invert the sense of the match.
 .\" @MATCH@
 .SH TARGET EXTENSIONS
 iptables can use extended target modules: the following are included
-- 
1.7.3.4

