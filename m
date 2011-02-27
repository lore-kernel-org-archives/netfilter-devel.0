From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 6/9] libxtables: avoid confusing use of ai_protocol=IPPROTO_IPV6
Date: Sun, 27 Feb 2011 02:31:16 +0100
Message-ID: <1298770280-7652-7-git-send-email-jengelh@medozas.de>
References: <1298770280-7652-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52523 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229Ab1B0Bbd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Feb 2011 20:31:33 -0500
In-Reply-To: <1298770280-7652-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Wes Campaigne <westacular@gmail.com>

[Split hunk from Wes's submission. Added commit message. -j.eng]

ai_protocol normally specifies the L4 protocol one wants to
specifically inquire about when a service (2nd parameter to
getaddrinfo) is specified. Such a service lookup would potentially
yield nothing, because there just is not any "mytunnel 2222/ipv6" in
/etc/services, since IPPROTO_IPV6 itself is not a protocol with a
concept of (port-based) services to begin with.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 xtables.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/xtables.c b/xtables.c
index f66fb27..83c5b41 100644
--- a/xtables.c
+++ b/xtables.c
@@ -1424,8 +1424,6 @@ host_to_ip6addr(const char *name, unsigned int *naddr)
 	hints.ai_flags    = AI_CANONNAME;
 	hints.ai_family   = AF_INET6;
 	hints.ai_socktype = SOCK_RAW;
-	hints.ai_protocol = IPPROTO_IPV6;
-	hints.ai_next     = NULL;
 
 	*naddr = 0;
 	if ((err = getaddrinfo(name, NULL, &hints, &res)) != 0) {
-- 
1.7.1

