From: Jan Engelhardt <jengelh@medozas.de>
Subject: pull: mark size documentation
Date: Mon, 5 Oct 2009 13:56:01 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0910051354550.17030@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:41427 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932530AbZJEL4j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Oct 2009 07:56:39 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 8eacb5929b5fd85cee6c602f52131e6bce341147:
  Jan Engelhardt (1):
        iprange: roll address parsing into a loop

are available in the git repository at:

  git://dev.medozas.de/iptables master

Jan Engelhardt (1):
      doc: mention maximum mark size in manpages

 extensions/libxt_CONNMARK.man |    3 ++-
 extensions/libxt_MARK.man     |    3 ++-
 extensions/libxt_SECMARK.man  |    2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)


parent 8eacb5929b5fd85cee6c602f52131e6bce341147 (v1.4.5-6-g8eacb59)
commit bdb7201ed5893a80f6a5ce24e4c043c12a6024a7
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Mon Oct 5 13:24:02 2009 +0200

doc: mention maximum mark size in manpages
---
 extensions/libxt_CONNMARK.man |    3 ++-
 extensions/libxt_MARK.man     |    3 ++-
 extensions/libxt_SECMARK.man  |    2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/extensions/libxt_CONNMARK.man b/extensions/libxt_CONNMARK.man
index 571ce37..13c6b4b 100644
--- a/extensions/libxt_CONNMARK.man
+++ b/extensions/libxt_CONNMARK.man
@@ -1,4 +1,5 @@
-This module sets the netfilter mark value associated with a connection.
+This module sets the netfilter mark value associated with a connection. The
+mark is 32 bits wide.
 .TP
 \fB\-\-set\-xmark\fP \fIvalue\fP[\fB/\fP\fImask\fP]
 Zero out the bits given by \fImask\fR and XOR \fIvalue\fR into the ctmark.
diff --git a/extensions/libxt_MARK.man b/extensions/libxt_MARK.man
index 7bb05be..98be812 100644
--- a/extensions/libxt_MARK.man
+++ b/extensions/libxt_MARK.man
@@ -1,6 +1,7 @@
 This target is used to set the Netfilter mark value associated with the packet.
 The target can only be used in the \fBmangle\fR table. It can, for example, be
-used in conjunction with routing based on fwmark (needs iproute2).
+used in conjunction with routing based on fwmark (needs iproute2). The mark
+field is 32 bits wide.
 .TP
 \fB\-\-set\-xmark\fP \fIvalue\fP[\fB/\fP\fImask\fP]
 Zeroes out the bits given by \fImask\fR and XORs \fIvalue\fR into the packet
diff --git a/extensions/libxt_SECMARK.man b/extensions/libxt_SECMARK.man
index f58bb43..e44efce 100644
--- a/extensions/libxt_SECMARK.man
+++ b/extensions/libxt_SECMARK.man
@@ -2,6 +2,6 @@ This is used to set the security mark value associated with the
 packet for use by security subsystems such as SELinux.  It is only
 valid in the
 .B mangle
-table.
+table. The mark is 32 bits wide.
 .TP
 \fB\-\-selctx\fP \fIsecurity_context\fP
-- 
# Created with git-export-patch
