From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/3] doc: explain experienced --hitcount limit
Date: Tue, 24 Nov 2009 16:07:33 +0100
Message-ID: <1259075255-25781-3-git-send-email-jengelh@medozas.de>
References: <1259075255-25781-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36326 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933216AbZKXPHd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:07:33 -0500
In-Reply-To: <1259075255-25781-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_recent.man |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_recent.man b/extensions/libxt_recent.man
index 9d5a64e..aa138df 100644
--- a/extensions/libxt_recent.man
+++ b/extensions/libxt_recent.man
@@ -44,7 +44,9 @@ This option must be used in conjunction with one of \fB\-\-rcheck\fP or
 address is in the list and packets had been received greater than or equal to
 the given value. This option may be used along with \fB\-\-seconds\fP to create
 an even narrower match requiring a certain number of hits within a specific
-time frame.
+time frame. The maximum value for the hitcount parameter is given by the
+"ip_pkt_list_tot" parameter of the xt_recent kernel module. Exceeding this
+value on the command line will cause the rule to be rejected.
 .TP
 \fB\-\-rttl\fP
 This option may only be used in conjunction with one of \fB\-\-rcheck\fP or
-- 
1.6.5.2

