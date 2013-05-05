From: Dmitry Popov <dp@highloadlab.com>
Subject: [PATCH] xtables-addons: xt_RAWNAT: skb writable part might not
 include whole l4 header (ipv4 case).
Date: Sun, 5 May 2013 22:05:04 +0400
Message-ID: <20130505220504.1a3f2380a1e798b37e628dd1@highloadlab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@gmx.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:33936 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab3EESF3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 May 2013 14:05:29 -0400
Received: by mail-lb0-f172.google.com with SMTP id y6so2829415lbh.31
        for <netfilter-devel@vger.kernel.org>; Sun, 05 May 2013 11:05:27 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Consider TCP/IPv4 packet with IP options:
sizeof(*iph) + sizeof(struct tcphdr) is not enough to include tcp checksum.
It may hurt if this packet is fragmented.

Therefore we should use iph->ihl * 4 instead of sizeof(*iph).

Signed-off-by: Dmitry Popov <dp@highloadlab.com>
---
 extensions/xt_RAWNAT.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/xt_RAWNAT.c b/extensions/xt_RAWNAT.c
index a52e614..858f911 100644
--- a/extensions/xt_RAWNAT.c
+++ b/extensions/xt_RAWNAT.c
@@ -109,7 +109,7 @@ static void rawnat4_update_l4(struct sk_buff *skb, __be32 oldip, __be32 newip)
 
 static unsigned int rawnat4_writable_part(const struct iphdr *iph)
 {
-	unsigned int wlen = sizeof(*iph);
+	unsigned int wlen = iph->ihl * 4;
 
 	switch (iph->protocol) {
 	case IPPROTO_TCP:
