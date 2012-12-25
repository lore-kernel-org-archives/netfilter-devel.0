From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 11/13] doc: mention -m in the manpage
Date: Wed, 26 Dec 2012 00:11:27 +0100
Message-ID: <1356477089-13241-12-git-send-email-jengelh@inai.de>
References: <1356477089-13241-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:38911 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab2LYXLe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Dec 2012 18:11:34 -0500
In-Reply-To: <1356477089-13241-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 iptables/ip6tables.8.in |    7 +++++++
 iptables/iptables.8.in  |    7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/iptables/ip6tables.8.in b/iptables/ip6tables.8.in
index fd0e61b..dfeebe6 100644
--- a/iptables/ip6tables.8.in
+++ b/iptables/ip6tables.8.in
@@ -281,6 +281,13 @@ See the description of the \fB\-s\fP
 (source) flag for a detailed description of the syntax.  The flag
 \fB\-\-dst\fP is an alias for this option.
 .TP
+\fB\-m\fP, \fB\-\-match\fP \fImatch\fP
+Specifies a match to use, that is, an extension module that tests for a
+specific property. The set of matches make up the condition under which a
+target is invoked. Matches are evaluated first to last as specified on the
+command line and work in short-circuit fashion, i.e. if one extension yields
+false, evaluation will stop.
+.TP
 \fB\-j\fP, \fB\-\-jump\fP \fItarget\fP
 This specifies the target of the rule; i.e., what to do if the packet
 matches it.  The target can be a user-defined chain (other than the
diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
index 748d00f..9276cf9 100644
--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -277,6 +277,13 @@ See the description of the \fB\-s\fP
 (source) flag for a detailed description of the syntax.  The flag
 \fB\-\-dst\fP is an alias for this option.
 .TP
+\fB\-m\fP, \fB\-\-match\fP \fImatch\fP
+Specifies a match to use, that is, an extension module that tests for a
+specific property. The set of matches make up the condition under which a
+target is invoked. Matches are evaluated first to last as specified on the
+command line and work in short-circuit fashion, i.e. if one extension yields
+false, evaluation will stop.
+.TP
 \fB\-j\fP, \fB\-\-jump\fP \fItarget\fP
 This specifies the target of the rule; i.e., what to do if the packet
 matches it.  The target can be a user-defined chain (other than the
-- 
1.7.10.4

