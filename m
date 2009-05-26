From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/5] addrtype: fix one manpage type
Date: Tue, 26 May 2009 13:26:26 +0200
Message-ID: <1243337187-18216-5-git-send-email-jengelh@medozas.de>
References: <1243337187-18216-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34630 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbZEZL03 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 May 2009 07:26:29 -0400
In-Reply-To: <1243337187-18216-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

References: http://bugs.debian.org/528457
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_addrtype.man |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/libipt_addrtype.man b/extensions/libipt_addrtype.man
index 731f9b1..16fd9df 100644
--- a/extensions/libipt_addrtype.man
+++ b/extensions/libipt_addrtype.man
@@ -58,7 +58,7 @@ chains. It cannot be specified with the
 option.
 .TP
 \fB\-\-limit\-iface\-out\fP
-The address type checiking can be limited to the interface the packet is going
+The address type checking can be limited to the interface the packet is going
 out. This option is only valid in the
 .BR POSTROUTING ,
 .B OUTPUT
-- 
1.6.3.1

