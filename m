From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH 1/2] conntrackd: man: remove bogus characters
Date: Thu,  7 Apr 2016 10:21:43 +0200
Message-ID: <1460017304-21888-2-git-send-email-mart.frauenlob@chello.at>
References: <1460017304-21888-1-git-send-email-mart.frauenlob@chello.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-dmta-at01-2.mx.upcmail.net ([62.179.121.146]:46434 "EHLO
	vie01a-dmta-at01-2.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755544AbcDGIWH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 04:22:07 -0400
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-at01.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1ao5CW-0000v8-Ea
	for netfilter-devel@vger.kernel.org; Thu, 07 Apr 2016 10:22:04 +0200
In-Reply-To: <1460017304-21888-1-git-send-email-mart.frauenlob@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Mart Frauenlob <mart.frauenlob@chello.at>
---
 conntrackd.8 |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/conntrackd.8 b/conntrackd.8
index 1ac96a2..3bb4335 100644
--- a/conntrackd.8
+++ b/conntrackd.8
@@ -24,17 +24,17 @@ Run conntrackd in daemon mode.
 .B conntrackd 
 can be used in client mode to request several information and operations to a running daemon
 .TP
-.BI "-i "[ct|expect]"
+.BI "-i " "[ct|expect]"
 Dump the internal cache, i.e. show local states
 .TP
-.BI "-e "[ct|expect]"
+.BI "-e " "[ct|expect]"
 Dump the external cache, i.e. show foreign states
 .TP
 .BI "-x "
 Display output in XML format. This option is only valid in combination
 with "\-i" and "\-e" parameters.
 .TP
-.BI "-f " "[|internal|external]"
+.BI "-f " "[internal|external]"
 Flush the internal and/or external cache
 .TP
 .BI "-F [ct|expect]"
@@ -54,7 +54,7 @@ Request resync with other node (only FT-FW and NOTRACK modes).
 .BI "-k "
 Kill the daemon
 .TP
-.BI "-s " "[|network|cache|runtime|link|rsqueue|process|queue|ct|expect]"
+.BI "-s " "[network|cache|runtime|link|rsqueue|process|queue|ct|expect]"
 Dump statistics. If no parameter is passed, it displays the general statistics.
 If "network" is passed as parameter it displays the networking statistics.
 If "cache" is passed as parameter, it shows the extended cache statistics.
-- 
1.7.2.5

