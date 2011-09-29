From: JP Abgrall <jpa@google.com>
Subject: [PATCH] netfilter: ipv6: let ipv6_find_hdr() fail when offset can't be found
Date: Thu, 29 Sep 2011 16:52:08 -0700
Message-ID: <1317340328-22751-1-git-send-email-jpa@google.com>
Cc: JP Abgrall <jpa@google.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:46599 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab1I2Xw0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Sep 2011 19:52:26 -0400
Received: from wpaz13.hot.corp.google.com (wpaz13.hot.corp.google.com [172.24.198.77])
	by smtp-out.google.com with ESMTP id p8TNqOPf016093
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Sep 2011 16:52:24 -0700
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There are some cases where the caller wants the last target and only
the offset. But it turns out that there are cases with fragments where
the final nexthdr is something like IPPROTO_UDP.
This would lead the caller to believe the offset was valid.
Before the "fragoff" days, any fragment would cause a negative return value.
So return -ENOENT when fragoff is 0 and the offset can't be set.

Change-Id: Ib474e8a4267dd2b300feca325811330329684a88
Signed-off-by: JP Abgrall <jpa@google.com>
---
:100644 100644 94874b0... eda6703... M	net/ipv6/netfilter/ip6_tables.c
 net/ipv6/netfilter/ip6_tables.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 94874b0..eda6703 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -2300,7 +2300,7 @@ static void __exit ip6_tables_fini(void)
  * Note that non-1st fragment is special case that "the protocol number
  * of last header" is "next header" field in Fragment header. In this case,
  * *offset is meaningless and fragment offset is stored in *fragoff if fragoff
- * isn't NULL.
+ * isn't NULL. And if fragoff is NULL, function returns -1.
  *
  */
 int ipv6_find_hdr(const struct sk_buff *skb, unsigned int *offset,
@@ -2344,6 +2344,8 @@ int ipv6_find_hdr(const struct sk_buff *skb, unsigned int *offset,
 				     hp->nexthdr == NEXTHDR_NONE)) {
 					if (fragoff)
 						*fragoff = _frag_off;
+					else
+						return -ENOENT;
 					return hp->nexthdr;
 				}
 				return -ENOENT;
-- 
1.7.3.1

