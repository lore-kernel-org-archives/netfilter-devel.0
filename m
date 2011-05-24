From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 06/24] libxt_rateest: streamline case display of units
Date: Wed, 25 May 2011 01:08:07 +0200
Message-ID: <1306278506-11463-7-git-send-email-jengelh@medozas.de>
References: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40936 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933573Ab1EXXIf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 19:08:35 -0400
In-Reply-To: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_rateest.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/libxt_rateest.c b/extensions/libxt_rateest.c
index e70edc6..509b3e3 100644
--- a/extensions/libxt_rateest.c
+++ b/extensions/libxt_rateest.c
@@ -65,11 +65,11 @@ static const struct rate_suffix {
 	{ "bit",	1. },
 	{ "Kibit",	1024. },
 	{ "kbit",	1000. },
-	{ "mibit",	1024.*1024. },
+	{ "Mibit",	1024.*1024. },
 	{ "mbit",	1000000. },
-	{ "gibit",	1024.*1024.*1024. },
+	{ "Gibit",	1024.*1024.*1024. },
 	{ "gbit",	1000000000. },
-	{ "tibit",	1024.*1024.*1024.*1024. },
+	{ "Tibit",	1024.*1024.*1024.*1024. },
 	{ "tbit",	1000000000000. },
 	{ "Bps",	8. },
 	{ "KiBps",	8.*1024. },
-- 
1.7.3.4

