From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/5] doc: libxt_MARK: no longer restricted to mangle table
Date: Tue,  6 Apr 2010 12:52:39 +0200
Message-ID: <1270551164-2945-2-git-send-email-jengelh@medozas.de>
References: <1270551164-2945-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36847 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240Ab0DFKwu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Apr 2010 06:52:50 -0400
In-Reply-To: <1270551164-2945-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

MARK used to be limited to the mangle table, but there was no real
restriction.

References: http://marc.info/?l=netfilter-devel&m=126806510332668&w=2
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_MARK.man |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/extensions/libxt_MARK.man b/extensions/libxt_MARK.man
index 98be812..aaeceb4 100644
--- a/extensions/libxt_MARK.man
+++ b/extensions/libxt_MARK.man
@@ -1,7 +1,8 @@
 This target is used to set the Netfilter mark value associated with the packet.
-The target can only be used in the \fBmangle\fR table. It can, for example, be
-used in conjunction with routing based on fwmark (needs iproute2). The mark
-field is 32 bits wide.
+It can, for example, be used in conjunction with routing based on fwmark (needs
+iproute2). If you plan on doing so, note that the mark needs to be set in the
+PREROUTING chain of the mangle table to affect routing.
+The mark field is 32 bits wide.
 .TP
 \fB\-\-set\-xmark\fP \fIvalue\fP[\fB/\fP\fImask\fP]
 Zeroes out the bits given by \fImask\fR and XORs \fIvalue\fR into the packet
-- 
1.7.0.2

