From: fgao@ikuai8.com
Subject: [PATCH nf-next] netfilter: ftp: Remove the useless dlen==0 condition check in find_pattern
Date: Thu,  1 Sep 2016 10:14:17 +0800
Message-ID: <1472696057-15819-1-git-send-email-fgao@ikuai8.com>
Cc: gfree.wind@gmail.com, Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from SMTPBG351.QQ.COM ([183.57.50.165]:48998 "EHLO smtpbg351.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753708AbcIACPO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Aug 2016 22:15:14 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

The caller function "help" has already make sure the datalen could not be zero
before invoke find_pattern as a parameter by the following codes

	if (dataoff >= skb->len) {
		pr_debug("ftp: dataoff(%u) >= skblen(%u)\n", dataoff,
			 skb->len);
		return NF_ACCEPT;
	}
	datalen = skb->len - dataoff;

And the latter codes "ends_in_nl = (fb_ptr[datalen - 1] == '\n');" use datalen
directly without checking if it is zero.

So it is unneccessary to check it in find_pattern too.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/netfilter/nf_conntrack_ftp.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index b6934b5..77f05ac 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -301,8 +301,6 @@ static int find_pattern(const char *data, size_t dlen,
 	size_t i = plen;
 
 	pr_debug("find_pattern `%s': dlen = %Zu\n", pattern, dlen);
-	if (dlen == 0)
-		return 0;
 
 	if (dlen <= plen) {
 		/* Short packet: try for partial? */
@@ -312,16 +310,6 @@ static int find_pattern(const char *data, size_t dlen,
 	}
 
 	if (strncasecmp(data, pattern, plen) != 0) {
-#if 0
-		size_t i;
-
-		pr_debug("ftp: string mismatch\n");
-		for (i = 0; i < plen; i++) {
-			pr_debug("ftp:char %u `%c'(%u) vs `%c'(%u)\n",
-				 i, data[i], data[i],
-				 pattern[i], pattern[i]);
-		}
-#endif
 		return 0;
 	}
 
-- 
1.9.1


