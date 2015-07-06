From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] MAINTAINER: add bridge netfilter
Date: Mon,  6 Jul 2015 20:55:35 +0200
Message-ID: <1436208935-27098-1-git-send-email-pablo@netfilter.org>
Cc: julien.grall@citrix.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44854 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754652AbbGFSuE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jul 2015 14:50:04 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

So scripts/get_maintainer.pl shows the Netfilter mailing lists.

Reported-by: Julien Grall <julien.grall@citrix.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 246d9d8..8d0f459 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6845,6 +6845,7 @@ F:	include/uapi/linux/netfilter/
 F:	net/*/netfilter.c
 F:	net/*/netfilter/
 F:	net/netfilter/
+F:	net/bridge/br_netfilter*.c
 
 NETLABEL
 M:	Paul Moore <paul@paul-moore.com>
-- 
1.7.10.4

