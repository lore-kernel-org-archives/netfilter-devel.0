From: lantw44@gmail.com
Subject: [PATCH 1/3] extra: use inet_ntop instead of inet_ntoa
Date: Fri, 20 Jun 2014 18:26:59 +0800
Message-ID: <1403260021-8732-1-git-send-email-lantw44@gmail.com>
Cc: Ting-Wei Lan <lantw44@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:64915 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965068AbaFTK1M (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jun 2014 06:27:12 -0400
Received: by mail-pd0-f178.google.com with SMTP id r10so2839223pdi.37
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Jun 2014 03:27:11 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Ting-Wei Lan <lantw44@gmail.com>

The result of inet_ntoa() will be overwritten by the next call to
inet_ntoa(), so using it twice in the same snprintf() call causes
wrong result.
---
 src/extra/ipv4.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/src/extra/ipv4.c b/src/extra/ipv4.c
index 0fe716b..a93d113 100644
--- a/src/extra/ipv4.c
+++ b/src/extra/ipv4.c
@@ -134,9 +134,13 @@ int nfq_ip_snprintf(char *buf, size_t size, const struct iphdr *iph)
 	struct in_addr src = { iph->saddr };
 	struct in_addr dst = { iph->daddr };
 
+	char src_str[INET_ADDRSTRLEN];
+	char dst_str[INET_ADDRSTRLEN];
+
 	ret = snprintf(buf, size, "SRC=%s DST=%s LEN=%u TOS=0x%X "
 				  "PREC=0x%X TTL=%u ID=%u PROTO=%u ",
-			inet_ntoa(src), inet_ntoa(dst),
+			inet_ntop(AF_INET, &src, src_str, INET_ADDRSTRLEN),
+			inet_ntop(AF_INET, &dst, dst_str, INET_ADDRSTRLEN),
 			ntohs(iph->tot_len), IPTOS_TOS(iph->tos),
 			IPTOS_PREC(iph->tos), iph->ttl, ntohs(iph->id),
 			iph->protocol);
-- 
1.9.3

