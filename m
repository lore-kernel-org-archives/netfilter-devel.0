From: Thomas Graf <tgraf@infradead.org>
Subject: [PATCH] iptables: add manual page section for AUDIT target
Date: Tue, 15 Mar 2011 20:26:20 -0400
Message-ID: <20110316002620.GA26145@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35280 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab1CPA0Z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Mar 2011 20:26:25 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Thomas Graf <tgraf@redhat.com>

diff --git a/extensions/libxt_AUDIT.man b/extensions/libxt_AUDIT.man
new file mode 100644
index 0000000..cd79696
--- /dev/null
+++ b/extensions/libxt_AUDIT.man
@@ -0,0 +1,14 @@
+This target allows to create audit records for packets hitting the target.
+It can be used to record accepted, dropped, and rejected packets. See
+auditd(8) for additional details.
+.TP
+\fB\-\-type\fP {\fBaccept\fP|\fBdrop\fP|\fBreject\fP}
+Set type of audit record.
+.PP
+Example:
+.IP
+iptables \-N AUDIT_DROP
+.IP
+iptables \-A AUDIT_DROP \-j AUDIT \-\-type drop
+.IP
+iptables \-A AUDIT_DROP \-j DROP
