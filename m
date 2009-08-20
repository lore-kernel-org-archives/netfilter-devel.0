From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/4] ipt_set: fix a typo in the manpage
Date: Thu, 20 Aug 2009 17:09:36 +0200
Message-ID: <1250780978-14013-3-git-send-email-jengelh@medozas.de>
References: <1250780978-14013-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40284 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731AbZHTPJo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2009 11:09:44 -0400
In-Reply-To: <1250780978-14013-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Trent W. Buck <trentbuck@gmail.com>

References: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=539101
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_set.man |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/libipt_set.man b/extensions/libipt_set.man
index 6df6b29..455706c 100644
--- a/extensions/libipt_set.man
+++ b/extensions/libipt_set.man
@@ -1,4 +1,4 @@
-This modules macthes IP sets which can be defined by ipset(8).
+This modules matches IP sets which can be defined by ipset(8).
 .TP
 [\fB!\fP] \fB\-\-match\-set\fP \fIsetname\fP \fIflag\fP[\fB,\fP\fIflag\fP]...
 where flags are the comma separated list of
-- 
1.6.4

