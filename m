From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/3] libxt_CT: add a manpage
Date: Tue, 16 Mar 2010 20:02:18 +0100
Message-ID: <1268766140-28435-3-git-send-email-jengelh@medozas.de>
References: <1268766140-28435-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:33739 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933651Ab0CPTCY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Mar 2010 15:02:24 -0400
In-Reply-To: <1268766140-28435-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_CT.c   |    2 +-
 extensions/libxt_CT.man |   25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 1 deletions(-)
 create mode 100644 extensions/libxt_CT.man

diff --git a/extensions/libxt_CT.c b/extensions/libxt_CT.c
index 79fa8d0..0b40fc6 100644
--- a/extensions/libxt_CT.c
+++ b/extensions/libxt_CT.c
@@ -13,7 +13,7 @@ static void ct_help(void)
 "CT target options:\n"
 " --notrack			Don't track connection\n"
 " --helper name			Use conntrack helper 'name' for connection\n"
-" --ctevents event[,event...]	Generate specified conntrack vents for connection\n"
+" --ctevents event[,event...]	Generate specified conntrack events for connection\n"
 " --expevents event[,event...]	Generate specified expectation events for connection\n"
 " --zone ID			Assign/Lookup connection in zone ID\n"
 	);
diff --git a/extensions/libxt_CT.man b/extensions/libxt_CT.man
new file mode 100644
index 0000000..ff258b7
--- /dev/null
+++ b/extensions/libxt_CT.man
@@ -0,0 +1,25 @@
+The CT target allows to set parameters for a packet or its associated
+connection. The target attaches a "template" connection tracking entry to
+the packet, which is then used by the conntrack core when initializing
+a new ct entry. This target is thus only valid in the "raw" table.
+.TP
+\fB\-\-notrack\fP
+Disables connection tracking for this packet.
+.TP
+\fB\-\-helper\fP \fIname\fP
+Use the helper identified by \fIname\fP for the connection. This is more
+flexible than loading the conntrack helper modules with preset ports.
+.TP
+\fB\-\-ctevents\fP \fIevent\fP[\fB,\fP...]
+Only generate the specified conntrack events for this connection. Possible
+event types are: \fBnew\fP, \fBrelated\fP, \fBdestroy\fP, \fBreply\fP,
+\fBassured\fP, \fBprotoinfo\fP, \fBhelper\fP, \fBmark\fP (this refers to
+the ctmark, not nfmark), \fBnatseqinfo\fP, \fBsecmark\fP (ctsecmark).
+.TP
+\fB\-\-expevents\fP \fIevent\fP[\fB,\fP...]
+Only generate the specified expectation events for this connection.
+Possible event types are: \fBnew\fP.
+.TP
+\fB\-\-zone\fP \fIid\fP
+Assign this packet to zone \fIid\fP and only have lookups done in that zone.
+By default, packets have zone 0.
-- 
1.7.0.2

