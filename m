From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/4] manpage: fix lintian warnings
Date: Thu, 20 Aug 2009 17:09:37 +0200
Message-ID: <1250780978-14013-4-git-send-email-jengelh@medozas.de>
References: <1250780978-14013-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40287 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbZHTPJp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2009 11:09:45 -0400
In-Reply-To: <1250780978-14013-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Laurence J. Lane <ljlane@debian.org>

Description: extraneous slash caused this lintian warning:
  W: iptables: manpage-has-errors-from-man usr/share/man/man8/iptables.8.gz
     220: cannot use newline as a starting delimiter
  W: iptables: manpage-has-errors-from-man usr/share/man/man8/ip6tables.8.gz
     1823: warning: `precedence'' not defined

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_TOS.man |    2 +-
 iptables.8.in            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_TOS.man b/extensions/libxt_TOS.man
index a42a73d..d5cbfcb 100644
--- a/extensions/libxt_TOS.man
+++ b/extensions/libxt_TOS.man
@@ -1,5 +1,5 @@
 This module sets the Type of Service field in the IPv4 header (including the
-'precedence' bits) or the Priority field in the IPv6 header. Note that TOS
+"precedence" bits) or the Priority field in the IPv6 header. Note that TOS
 shares the same bits as DSCP and ECN. The TOS target is only valid in the
 \fBmangle\fR table.
 .TP
diff --git a/iptables.8.in b/iptables.8.in
index 14fc23a..cb6e6b0 100644
--- a/iptables.8.in
+++ b/iptables.8.in
@@ -217,7 +217,7 @@ targets.
 Rename the user specified chain to the user supplied name.  This is
 cosmetic, and has no effect on the structure of the table.
 .TP
-\fB\-\h\fP
+\fB\-h\fP
 Help.
 Give a (currently very brief) description of the command syntax.
 .SS PARAMETERS
-- 
1.6.4

