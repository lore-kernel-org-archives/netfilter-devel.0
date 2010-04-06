From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/5] doc: remove claim that TCPMSS is limited to mangle
Date: Tue,  6 Apr 2010 12:52:40 +0200
Message-ID: <1270551164-2945-3-git-send-email-jengelh@medozas.de>
References: <1270551164-2945-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36847 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240Ab0DFKwv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Apr 2010 06:52:51 -0400
In-Reply-To: <1270551164-2945-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There was no real restriction, and in fact, the kernel module never
had such a limitation in the last years.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_TCPMSS.man |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_TCPMSS.man b/extensions/libxt_TCPMSS.man
index b5cb455..ac8fb4e 100644
--- a/extensions/libxt_TCPMSS.man
+++ b/extensions/libxt_TCPMSS.man
@@ -4,10 +4,7 @@ outgoing interface's MTU minus 40 for IPv4 or 60 for IPv6, respectively).
 Of course, it can only be used
 in conjunction with
 \fB\-p tcp\fP.
-It is only valid in the
-.BR mangle
-table.
-.br
+.PP
 This target is used to overcome criminally braindead ISPs or servers
 which block "ICMP Fragmentation Needed" or "ICMPv6 Packet Too Big"
 packets.  The symptoms of this
-- 
1.7.0.2

