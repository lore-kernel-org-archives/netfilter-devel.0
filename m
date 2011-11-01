From: pablo@netfilter.org
Subject: [PATCH 13/14] MAINTAINERS: update netfilter maintainers
Date: Tue,  1 Nov 2011 10:11:35 +0100
Message-ID: <1320138696-28048-14-git-send-email-pablo@netfilter.org>
References: <1320138696-28048-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37269 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab1KAJMM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Nov 2011 05:12:12 -0400
In-Reply-To: <1320138696-28048-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Marc Boucher, James Morris and Rusty Russell were crucial in the
early netfilter days. We thank them all!

However, they are not actively maintaining netfilter anymore.

This patch adds myself as netfilter maintainer.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 MAINTAINERS |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4befa12..8edf72b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4452,11 +4452,9 @@ F:	Documentation/networking/vxge.txt
 F:	drivers/net/ethernet/neterion/
 
 NETFILTER/IPTABLES/IPCHAINS
-P:	Rusty Russell
-P:	Marc Boucher
-P:	James Morris
 P:	Harald Welte
 P:	Jozsef Kadlecsik
+M:	Pablo Neira Ayuso <pablo@netfilter.org>
 M:	Patrick McHardy <kaber@trash.net>
 L:	netfilter-devel@vger.kernel.org
 L:	netfilter@vger.kernel.org
-- 
1.7.2.5

