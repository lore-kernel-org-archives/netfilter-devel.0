From: Joerg Marx <joerg.marx@secunet.com>
Subject: [PATCH] Fix a flaw in printing the MAC
Date: Thu, 17 Feb 2011 15:54:42 +0100
Message-ID: <4D5D36B2.2090608@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	"Schloegel, Robin" <robin.schloegel@secunet.com>
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:50639 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862Ab1BQPSR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:18:17 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The flaw was in skipping the second byte in MAC header due to increasing
the pointer AND indexed access starting at '1'.

Signed-off-by: Joerg Marx <joerg.marx@secunet.com>
---
 net/ipv6/netfilter/ip6t_LOG.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index 09c8889..de33803 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -410,7 +410,7 @@ fallback:
                if (p != NULL) {
                        sb_add(m, "%02x", *p++);
                        for (i = 1; i < len; i++)
-                               sb_add(m, ":%02x", p[i]);
+                               sb_add(m, ":%02x", *p++);
                }
                sb_add(m, " ");

-- 
1.7.1

