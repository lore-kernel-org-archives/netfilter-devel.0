From: Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH -iptables] cgroup, man: improve man-page bits
Date: Fri, 27 Mar 2015 19:38:36 +0100
Message-ID: <0e6bc44eee1b69940683cadcead21fe545066b89.1427481150.git.daniel@iogearbox.net>
Cc: netfilter-devel@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:40808 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbbC0Sij (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Mar 2015 14:38:39 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Document limitations when in use with INPUT until we found a
better solution. Also fix up indent in the example section.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 extensions/libxt_cgroup.man | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/extensions/libxt_cgroup.man b/extensions/libxt_cgroup.man
index 456a031..d0eb09b 100644
--- a/extensions/libxt_cgroup.man
+++ b/extensions/libxt_cgroup.man
@@ -2,13 +2,21 @@
 [\fB!\fP] \fB\-\-cgroup\fP \fIfwid\fP
 Match corresponding cgroup for this packet.
 
-Can be used to assign particular firewall policies for aggregated
-task/jobs on the system. This allows for more fine-grained firewall
-policies that only match for a subset of the system's processes.
-fwid is the maker set through the net_cls cgroup's id.
+Can be used in the OUTPUT chain to assign particular firewall
+policies for aggregated task/jobs on the system. This allows
+for more fine-grained firewall policies that only match for a
+subset of the system's processes. fwid is the maker set through
+the net_cls cgroup's id.
+
+\fBIMPORTANT\fP: when being used in the INPUT chain, the cgroup
+matcher is currently only of limited functionality, meaning it
+will only match on packets that are processed for local sockets
+through early socket demuxing. Therefore, general usage on the
+INPUT chain is disadviced unless the implications are well
+understood.
 .PP
 Example:
-.PP
+.IP
 iptables \-A OUTPUT \-p tcp \-\-sport 80 \-m cgroup ! \-\-cgroup 1
 \-j DROP
 .PP
-- 
1.9.3

