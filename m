From: Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH V4 1/2] netfilter: xt_AUDIT: use consistent ipv4 network offset
Date: Wed, 22 Mar 2017 03:05:36 -0400
Message-ID: <d2ef98ddd4884276879107d4cd4521330e709578.1490165887.git.rgb@redhat.com>
Cc: Richard Guy Briggs <rgb@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Thomas Woerner <twoerner@redhat.com>,
        Thomas Graf <tgraf@infradead.org>,
        Eric Paris <eparis@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>
To: Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, linux-audit@redhat.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35446 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933816AbdCVHGS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Mar 2017 03:06:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Even though the skb->data pointer has been moved from the link layer
header to the network layer header, use the same method to calculate the
offset in ipv4 and ipv6 routines.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 net/netfilter/xt_AUDIT.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
index 4973cbd..cdb7cee 100644
--- a/net/netfilter/xt_AUDIT.c
+++ b/net/netfilter/xt_AUDIT.c
@@ -76,7 +76,7 @@ static void audit_ip4(struct audit_buffer *ab, struct sk_buff *skb)
 	struct iphdr _iph;
 	const struct iphdr *ih;
 
-	ih = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
+	ih = skb_header_pointer(skb, skb_network_offset(skb), sizeof(_iph), &_iph);
 	if (!ih) {
 		audit_log_format(ab, " truncated=1");
 		return;
-- 
1.7.1

