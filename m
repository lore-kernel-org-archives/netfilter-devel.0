From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 09/24] Update the libxt_owner manpage with the UID/GID-range
 feature
Date: Tue, 4 Mar 2008 16:57:30 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041657190.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53762 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbYCDP5b (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 10:57:31 -0500
In-Reply-To: <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit eac317510606d3673fd2e65c3917f72e9010ca33
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Mon Feb 11 00:57:18 2008 +0100

    Update the libxt_owner manpage with the UID/GID-range feature
---
 extensions/libxt_owner.man |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/extensions/libxt_owner.man b/extensions/libxt_owner.man
index add2369..344ce2e 100644
--- a/extensions/libxt_owner.man
+++ b/extensions/libxt_owner.man
@@ -3,14 +3,17 @@ for locally generated packets. This match is only valid in the OUTPUT and
 POSTROUTING chains. Forwarded packets do not have any socket associated with
 them. Packets from kernel threads do have a socket, but usually no owner.
 .TP
-\fB--uid-owner\fR \fIuserid\fR
+\fB--uid-owner\fR \fIusername\fR
+.TP
+\fB--uid-owner\fR \fIuserid\fR[\fB-\fR\fIuserid\fR]
 Matches if the packet socket's file structure (if it has one) is owned by the
-given user ID. A user name may be specified in place of \fIuserid\fR, in which
-case iptables will try to look it up.
+given user. You may also specify a numerical UID, or an UID range.
+.TP
+\fB--gid-owner\fR \fIgroupname\fR
 .TP
-\fB--gid-owner\fR \fIgroupid\fR
-Matches if the packet socket's file structure is owned by the given group ID.
-A group name may be specified in place of \fIgroupid\fR.
+\fB--gid-owner\fR \fIgroupid\fR[\fB-\fR\fIgroupid\fR]
+Matches if the packet socket's file structure is owned by the given group.
+You may also specify a numerical GID, or a GID range.
 .TP
 \fB--socket-exists\fR
 Matches if the packet is associated with a socket.
