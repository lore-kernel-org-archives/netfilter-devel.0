From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH 4/5] conntrack: man: add options --src and --dst.
Date: Thu,  7 Apr 2016 20:31:41 +0200
Message-ID: <1460053902-2200-5-git-send-email-mart.frauenlob@chello.at>
References: <1460053902-2200-1-git-send-email-mart.frauenlob@chello.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-dmta-at03-3.mx.upcmail.net ([62.179.121.153]:47156 "EHLO
	vie01a-dmta-at03-3.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757095AbcDGScW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 14:32:22 -0400
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-at03.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1aoEj6-0005DT-6v
	for netfilter-devel@vger.kernel.org; Thu, 07 Apr 2016 20:32:20 +0200
In-Reply-To: <1460053902-2200-1-git-send-email-mart.frauenlob@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Mart Frauenlob <mart.frauenlob@chello.at>
---
 conntrack.8 |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/conntrack.8 b/conntrack.8
index 184e51c..e54951a 100644
--- a/conntrack.8
+++ b/conntrack.8
@@ -115,11 +115,11 @@ however, this results in more memory consumption.
 This option can only be used in conjunction with "\-E, \-\-event".
 .SS FILTER PARAMETERS
 .TP
-.BI "-s, --orig-src " IP_ADDRESS
+.BI "-s, --src, --orig-src " IP_ADDRESS
 Match only entries whose source address in the original direction equals the one specified as argument.
 Implies "--mask-src" when CIDR notation is used.
 .TP
-.BI "-d, --orig-dst " IP_ADDRESS
+.BI "-d, --dst, --orig-dst " IP_ADDRESS
 Match only entries whose destination address in the original direction equals the one specified as argument.
 Implies "--mask-dst" when CIDR notation is used.
 .TP
-- 
1.7.2.5

