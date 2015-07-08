From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/7] MAINTAINER: add bridge netfilter
Date: Wed,  8 Jul 2015 11:48:19 +0200
Message-ID: <1436348900-13130-7-git-send-email-pablo@netfilter.org>
References: <1436348900-13130-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51707 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934694AbbGHJnQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jul 2015 05:43:16 -0400
In-Reply-To: <1436348900-13130-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

So scripts/get_maintainer.pl shows the Netfilter mailing lists.

Reported-by: Julien Grall <julien.grall@citrix.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 993d4cf..8183b465 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6996,6 +6996,7 @@ F:	include/uapi/linux/netfilter/
 F:	net/*/netfilter.c
 F:	net/*/netfilter/
 F:	net/netfilter/
+F:	net/bridge/br_netfilter*.c
 
 NETLABEL
 M:	Paul Moore <paul@paul-moore.com>
-- 
1.7.10.4

