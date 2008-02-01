From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [06/10] [IPTABLES]: Update libxt_owner manpage (so far)
Date: Fri, 1 Feb 2008 01:29:14 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802010128590.4864@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801312315120.4864@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38772 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238AbYBAA3P (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jan 2008 19:29:15 -0500
In-Reply-To: <Pine.LNX.4.64.0801312315120.4864@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Update the libxt_owner manpage with the UID/GID-range feature

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/libxt_owner.man |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

Index: iptables/extensions/libxt_owner.man
===================================================================
--- iptables.orig/extensions/libxt_owner.man
+++ iptables/extensions/libxt_owner.man
@@ -3,14 +3,17 @@ for locally generated packets. This matc
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
