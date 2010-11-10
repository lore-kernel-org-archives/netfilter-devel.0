From: Jan Engelhardt <jengelh@medozas.de>
Subject: [patch] netfilter: nfnetlink: guard against undefined entries
Date: Wed, 10 Nov 2010 02:50:00 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011100249390.23289@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:39290 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab0KJBuC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Nov 2010 20:50:02 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

parent a391d495f6082f6348b9074214e81c7e2dc1151c (v2.6.37-rc1-184-ga391d49)
commit 6e97eb121bc8e39c651645c3d937f468d2b3e7fe
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sat Nov 6 21:19:16 2010 +0100

netfilter: nfnetlink: guard against undefined entries

Check for empty entries in struct nfnl_callback[] to avoid potential
NULL deference. (Because I have run into one during development.)

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/nfnetlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index b4a4532..7012882 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -152,7 +152,7 @@ replay:
 	}
 
 	nc = nfnetlink_find_client(type, ss);
-	if (!nc)
+	if (nc == NULL || nc->call == NULL)
 		return -EINVAL;
 
 	{
-- 
# Created with git-export-patch
