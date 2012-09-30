From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 16/17] doc: name the supported log levels for ipt_LOG
Date: Sun, 30 Sep 2012 12:22:19 +0200
Message-ID: <1349000540-17508-17-git-send-email-jengelh@inai.de>
References: <1349000540-17508-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:38823 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab2I3KW3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2012 06:22:29 -0400
In-Reply-To: <1349000540-17508-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Leonardo Ferreira da Silva Boiko lets it be known that syslogd.conf may
not exist on certain systems. Referencing that manpage is not a good
idea in any case, I believe, since the strings that are accepted are
defined by iptables and not a syslog implementation.

References: http://bugs.debian.org/567564
Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/libip6t_LOG.man |    5 ++++-
 extensions/libipt_LOG.man  |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/extensions/libip6t_LOG.man b/extensions/libip6t_LOG.man
index b7803fe..0a48640 100644
--- a/extensions/libip6t_LOG.man
+++ b/extensions/libip6t_LOG.man
@@ -11,7 +11,10 @@ separate rules with the same matching criteria, first using target LOG
 then DROP (or REJECT).
 .TP
 \fB\-\-log\-level\fP \fIlevel\fP
-Level of logging (numeric or see \fIsyslog.conf\fP(5)).
+Level of logging, which can be (system-specific) numeric or a mnemonic.
+Possible values are (in decreasing order of priority): \fBemerg\fP,
+\fBalert\fP, \fBcrit\fP, \fBerror\fP, \fBwarning\fP, \fBnotice\fP, \fBinfo\fP
+or \fBdebug\fP.
 .TP
 \fB\-\-log\-prefix\fP \fIprefix\fP
 Prefix log messages with the specified prefix; up to 29 letters long,
diff --git a/extensions/libipt_LOG.man b/extensions/libipt_LOG.man
index 47c35e0..f2574f8 100644
--- a/extensions/libipt_LOG.man
+++ b/extensions/libipt_LOG.man
@@ -11,7 +11,10 @@ separate rules with the same matching criteria, first using target LOG
 then DROP (or REJECT).
 .TP
 \fB\-\-log\-level\fP \fIlevel\fP
-Level of logging (numeric or see \fIsyslog.conf\fP(5)).
+Level of logging, which can be (system-specific) numeric or a mnemonic.
+Possible values are (in decreasing order of priority): \fBemerg\fP,
+\fBalert\fP, \fBcrit\fP, \fBerror\fP, \fBwarning\fP, \fBnotice\fP, \fBinfo\fP
+or \fBdebug\fP.
 .TP
 \fB\-\-log\-prefix\fP \fIprefix\fP
 Prefix log messages with the specified prefix; up to 29 letters long,
-- 
1.7.10.4

