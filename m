From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 08/24] Update the libxt_owner manpage with the UID/GID-range feature
Date: Sun,  6 Apr 2008 17:27:05 +0200
Message-ID: <4f0ee433c8bf1c8d0b74802f316f874977948e58.1207495183.git.jengelh@computergmbh.de>
References: <1207495642-21055-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56475 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbYDFP1Y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Apr 2008 11:27:24 -0400
In-Reply-To: <1207495642-21055-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <bd573e5e48763aa655cdb6e3f70a6f647c3868c7.1207495183.git.jengelh@computergmbh.de>
References: <bd573e5e48763aa655cdb6e3f70a6f647c3868c7.1207495183.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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
-- 
1.5.5.rc3

