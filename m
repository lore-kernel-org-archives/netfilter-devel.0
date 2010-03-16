From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/3] libxt_comment: avoid use of IPv4-specific examples
Date: Tue, 16 Mar 2010 20:02:17 +0100
Message-ID: <1268766140-28435-2-git-send-email-jengelh@medozas.de>
References: <1268766140-28435-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:33735 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966551Ab0CPTCX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Mar 2010 15:02:23 -0400
In-Reply-To: <1268766140-28435-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since libxt_comment.man is included in both iptables.8 and
ip6tables.8, we should probably try to create examples that do not
rely on either address family.

References: http://bugs.debian.org/572628
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_comment.man |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_comment.man b/extensions/libxt_comment.man
index 94f871e..faaee2a 100644
--- a/extensions/libxt_comment.man
+++ b/extensions/libxt_comment.man
@@ -3,4 +3,4 @@ Allows you to add comments (up to 256 characters) to any rule.
 \fB\-\-comment\fP \fIcomment\fP
 .TP
 Example:
-iptables \-A INPUT \-s 192.168.0.0/16 \-m comment \-\-comment "A privatized IP block"
+iptables \-A INPUT \-i eth1 \-m comment \-\-comment "my local LAN"
-- 
1.7.0.2

