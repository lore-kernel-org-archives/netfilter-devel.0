From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH 1/4] nfct: add missing commands to usage output.
Date: Fri,  8 Apr 2016 08:18:41 +0200
Message-ID: <1460096324-17426-2-git-send-email-mart.frauenlob@chello.at>
References: <1460096324-17426-1-git-send-email-mart.frauenlob@chello.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-dmta-at02-1.mx.upcmail.net ([62.179.121.148]:15714 "EHLO
	vie01a-dmta-at02-1.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751981AbcDHGS4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Apr 2016 02:18:56 -0400
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-pe01.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1aoPkr-0003h9-Uz
	for netfilter-devel@vger.kernel.org; Fri, 08 Apr 2016 08:18:53 +0200
In-Reply-To: <1460096324-17426-1-git-send-email-mart.frauenlob@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Mart Frauenlob <mart.frauenlob@chello.at>
---
 src/nfct.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/src/nfct.c b/src/nfct.c
index 3331e5b..27841be 100644
--- a/src/nfct.c
+++ b/src/nfct.c
@@ -204,6 +204,9 @@ static const char help_msg[] =
 	"  add object-name\tAdd new accounting object to table\n"
 	"  delete object-name\tDelete existing accounting object\n"
 	"  get object-name\tGet existing accounting object\n"
+	"  disable\t\tDisable queueing packets to userspace for helper inspection\n"
+	"  default-set\t\tSet default timeouts\n"
+	"  default-get\t\tGet default timeouts\n"
 	"  flush\t\t\tFlush accounting object table\n";
 
 static int nfct_cmd_help(int argc, char *argv[])
-- 
1.7.2.5

