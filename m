From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: [conntrack-tools PATCH] conntrackd: remove warning for -S
Date: Wed, 09 Aug 2017 14:19:32 +0200
Message-ID: <150228117223.32474.3290205091216581281.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:45440 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751443AbdHIMTl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Aug 2017 08:19:41 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 534CF51F448
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Aug 2017 12:19:39 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EKQwpaFsGN1P for <netfilter-devel@vger.kernel.org>;
        Wed,  9 Aug 2017 14:19:34 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id E94A351F427
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Aug 2017 14:19:33 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove the warning message for the -S option which has been deprecated for
years now.

Users calling conntrackd with this switch activated will now get an error.

Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 src/main.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/src/main.c b/src/main.c
index 3b19160..7062e12 100644
--- a/src/main.c
+++ b/src/main.c
@@ -281,9 +281,6 @@ int main(int argc, char *argv[])
 				action = STATS;
 			}
 			break;
-		case 'S':
-			dlog(LOG_WARNING,"-S option is obsolete. Ignoring.");
-			break;
 		case 'n':
 			set_operation_mode(&type, REQUEST, argv);
 			action = REQUEST_DUMP;

