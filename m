From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 05/17] doc: mention iptables-apply in the SEE ALSO sections
Date: Sun, 30 Sep 2012 12:22:08 +0200
Message-ID: <1349000540-17508-6-git-send-email-jengelh@inai.de>
References: <1349000540-17508-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:38813 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843Ab2I3KW1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2012 06:22:27 -0400
In-Reply-To: <1349000540-17508-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

References: http://bugs.debian.org/660748
Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 iptables/ip6tables.8.in   |    1 +
 iptables/iptables-apply.8 |    2 +-
 iptables/iptables.8.in    |    1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/iptables/ip6tables.8.in b/iptables/ip6tables.8.in
index edd092d..078bcac 100644
--- a/iptables/ip6tables.8.in
+++ b/iptables/ip6tables.8.in
@@ -390,6 +390,7 @@ There are several other changes in ip6tables.
 \fBip6tables\-save\fP(8),
 \fBip6tables\-restore\fP(8),
 \fBiptables\fP(8),
+\fBiptables\-apply\fP(8),
 \fBiptables\-extensions\fP(8),
 \fBiptables\-save\fP(8),
 \fBiptables\-restore\fP(8),
diff --git a/iptables/iptables-apply.8 b/iptables/iptables-apply.8
index 8208fd0..66eaf57 100644
--- a/iptables/iptables-apply.8
+++ b/iptables/iptables-apply.8
@@ -18,7 +18,7 @@ connection, the user will not be able to answer affirmatively. In this
 case, the script rolls back to the previous ruleset after the timeout
 expired. The timeout can be set with \fB\-t\fP.
 .PP
-When called as ip6tables\-apply, the script will use
+When called as \fBip6tables\-apply\fP, the script will use
 ip6tables\-save/\-restore instead.
 .SH OPTIONS
 .TP
diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
index 48eb2fa..d6b409d 100644
--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -393,6 +393,7 @@ seen previously.  So the following options are handled differently:
 .fi
 There are several other changes in iptables.
 .SH SEE ALSO
+\fBiptables\-apply\fP(8),
 \fBiptables\-save\fP(8),
 \fBiptables\-restore\fP(8),
 \fBiptables\-extensions\fP(8),
-- 
1.7.10.4

