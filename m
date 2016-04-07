From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH 2/5] conntrack: man: add --protonum option.
Date: Thu,  7 Apr 2016 20:31:39 +0200
Message-ID: <1460053902-2200-3-git-send-email-mart.frauenlob@chello.at>
References: <1460053902-2200-1-git-send-email-mart.frauenlob@chello.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-dmta-at01-2.mx.upcmail.net ([62.179.121.146]:48323 "EHLO
	vie01a-dmta-at01-2.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757231AbcDGScX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 14:32:23 -0400
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-at01.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1aoEj6-0006GL-1z
	for netfilter-devel@vger.kernel.org; Thu, 07 Apr 2016 20:32:20 +0200
In-Reply-To: <1460053902-2200-1-git-send-email-mart.frauenlob@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Mart Frauenlob <mart.frauenlob@chello.at>
---
 conntrack.8 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/conntrack.8 b/conntrack.8
index f2c1ca5..184e51c 100644
--- a/conntrack.8
+++ b/conntrack.8
@@ -129,7 +129,7 @@ Match only entries whose source address in the reply direction equals the one sp
 .BI "-q, --reply-dst " IP_ADDRESS
 Match only entries whose destination address in the reply direction equals the one specified as argument.
 .TP
-.BI "-p, --proto " "PROTO "
+.BI "-p, --proto, --protonum " "PROTO"
 Specify layer four (TCP, UDP, ...) protocol.
 .TP
 .BI "-f, --family " "PROTO"
-- 
1.7.2.5

