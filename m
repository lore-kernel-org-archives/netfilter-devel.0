From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 10/24] doc: use .IP list for TCPMSS
Date: Wed, 25 May 2011 01:08:11 +0200
Message-ID: <1306278506-11463-11-git-send-email-jengelh@medozas.de>
References: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40952 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933580Ab1EXXIj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 19:08:39 -0400
In-Reply-To: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_TCPMSS.man |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/extensions/libxt_TCPMSS.man b/extensions/libxt_TCPMSS.man
index ac8fb4e..8da8e76 100644
--- a/extensions/libxt_TCPMSS.man
+++ b/extensions/libxt_TCPMSS.man
@@ -11,19 +11,13 @@ packets.  The symptoms of this
 problem are that everything works fine from your Linux
 firewall/router, but machines behind it can never exchange large
 packets:
-.PD 0
-.RS 0.1i
-.TP 0.3i
-1)
+.IP 1. 4
 Web browsers connect, then hang with no data received.
-.TP
-2)
+.IP 2. 4
 Small mail works fine, but large emails hang.
-.TP
-3)
+.IP 3. 4
 ssh works fine, but scp hangs after initial handshaking.
-.RE
-.PD
+.PP
 Workaround: activate this option and add a rule to your firewall
 configuration like:
 .IP
-- 
1.7.3.4

