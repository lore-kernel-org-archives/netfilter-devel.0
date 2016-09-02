From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH libnftnl] trace: use get_u32 to parse NFPROTO and POLICY attribute
Date: Fri,  2 Sep 2016 20:51:26 +0800
Message-ID: <1472820686-8157-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:39480 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752633AbcIBMv6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Sep 2016 08:51:58 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

NFTA_TRACE_NFPROTO and NFTA_TRACE_POLICY attribute is 32-bit
value, so we should use mnl_attr_get_u32 and htonl here.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 src/trace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/trace.c b/src/trace.c
index 2b3388d..bd05d3c 100644
--- a/src/trace.c
+++ b/src/trace.c
@@ -408,12 +408,12 @@ int nftnl_trace_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_trace *t)
 		t->flags |= (1 << NFTNL_TRACE_TRANSPORT_HEADER);
 
 	if (tb[NFTA_TRACE_NFPROTO]) {
-		t->nfproto = ntohs(mnl_attr_get_u16(tb[NFTA_TRACE_NFPROTO]));
+		t->nfproto = ntohl(mnl_attr_get_u32(tb[NFTA_TRACE_NFPROTO]));
 		t->flags |= (1 << NFTNL_TRACE_NFPROTO);
 	}
 
 	if (tb[NFTA_TRACE_POLICY]) {
-		t->policy = ntohs(mnl_attr_get_u16(tb[NFTA_TRACE_POLICY]));
+		t->policy = ntohl(mnl_attr_get_u32(tb[NFTA_TRACE_POLICY]));
 		t->flags |= (1 << NFTNL_TRACE_POLICY);
 	}
 
-- 
2.5.5


