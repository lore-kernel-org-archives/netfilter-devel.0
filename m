From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/3] libxt_connlimit: reword help text to say prefix length
Date: Wed, 19 Jan 2011 18:32:26 +0100
Message-ID: <1295458349-14106-2-git-send-email-jengelh@medozas.de>
References: <1295458349-14106-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org, jan.rovner@diadema.cz
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40837 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab1ASRcd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Jan 2011 12:32:33 -0500
In-Reply-To: <1295458349-14106-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_connlimit.c   |    2 +-
 extensions/libxt_connlimit.man |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_connlimit.c b/extensions/libxt_connlimit.c
index 85c0ca8..693adbf 100644
--- a/extensions/libxt_connlimit.c
+++ b/extensions/libxt_connlimit.c
@@ -15,7 +15,7 @@ static void connlimit_help(void)
 "connlimit match options:\n"
 "[!] --connlimit-above n        match if the number of existing "
 "                               connections is (not) above n\n"
-"    --connlimit-mask n         group hosts using mask\n");
+"    --connlimit-mask n         group hosts using prefix length (default: max len)\n");
 }
 
 static const struct option connlimit_opts[] = {
diff --git a/extensions/libxt_connlimit.man b/extensions/libxt_connlimit.man
index c0246fd..f8f9c7b 100644
--- a/extensions/libxt_connlimit.man
+++ b/extensions/libxt_connlimit.man
@@ -6,7 +6,8 @@ Match if the number of existing connections is (not) above \fIn\fP.
 .TP
 \fB\-\-connlimit\-mask\fP \fIprefix_length\fP
 Group hosts using the prefix length. For IPv4, this must be a number between
-(including) 0 and 32. For IPv6, between 0 and 128.
+(including) 0 and 32. For IPv6, between 0 and 128. If not specified, the
+maximum prefix length for the applicable protocol is used.
 .P
 Examples:
 .TP
-- 
1.7.1

