From: Eric Leblond <eric@regit.org>
Subject: [libnetfilter_acct PATCH] Fix packets and bytes inversion.
Date: Wed, 26 Dec 2012 23:30:52 +0100
Message-ID: <1356561052-32655-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:41601 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab2LZWbk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Dec 2012 17:31:40 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pkts and bytes are inversed in some part of the code. This patch
fixes most of the occurence of this problem.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/libnetfilter_acct.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/src/libnetfilter_acct.c b/src/libnetfilter_acct.c
index 6a3a839..0abaeac 100644
--- a/src/libnetfilter_acct.c
+++ b/src/libnetfilter_acct.c
@@ -106,11 +106,11 @@ nfacct_attr_set(struct nfacct *nfacct, enum nfacct_attr_type type,
 		nfacct->bitset |= (1 << NFACCT_ATTR_NAME);
 		break;
 	case NFACCT_ATTR_PKTS:
-		nfacct->bytes = *((uint64_t *) data);
+		nfacct->pkts = *((uint64_t *) data);
 		nfacct->bitset |= (1 << NFACCT_ATTR_PKTS);
 		break;
 	case NFACCT_ATTR_BYTES:
-		nfacct->pkts = *((uint64_t *) data);
+		nfacct->bytes = *((uint64_t *) data);
 		nfacct->bitset |= (1 << NFACCT_ATTR_BYTES);
 		break;
 	}
@@ -237,9 +237,9 @@ nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 		ret = snprintf(buf, rem,
 			"{ pkts = %.20llu, bytes = %.20llu } = %s;",
 			(unsigned long long)
-			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES),
-			(unsigned long long)
 			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS),
+			(unsigned long long)
+			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES),
 			nfacct_attr_get_str(nfacct, NFACCT_ATTR_NAME));
 	} else {
 		ret = snprintf(buf, rem, "%s\n",
@@ -426,7 +426,7 @@ void nfacct_nlmsg_build_payload(struct nlmsghdr *nlh, struct nfacct *nfacct)
 		mnl_attr_put_u64(nlh, NFACCT_PKTS, htobe64(nfacct->pkts));
 
 	if (nfacct->bitset & (1 << NFACCT_ATTR_BYTES))
-		mnl_attr_put_u64(nlh, NFACCT_PKTS, htobe64(nfacct->bytes));
+		mnl_attr_put_u64(nlh, NFACCT_BYTES, htobe64(nfacct->bytes));
 }
 EXPORT_SYMBOL(nfacct_nlmsg_build_payload);
 
-- 
1.7.10.4

