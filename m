From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 1/2 libnftnl] utils: Fix out of bound access in nftnl_family2str
Date: Mon, 15 Aug 2016 12:51:02 +0200
Message-ID: <20160815105103.22319-1-carlosfg@riseup.net>
References: <20160815103256.GB5883@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:49608 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbcHOKv1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Aug 2016 06:51:27 -0400
In-Reply-To: <20160815103256.GB5883@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Checks array limits before access it and adds a missed translation.

Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
---
 src/utils.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/utils.c b/src/utils.c
index e2715a2..7264d1f 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -23,6 +23,7 @@
 #include <linux/netfilter/nf_tables.h>
 
 static const char *const nftnl_family_str[NFPROTO_NUMPROTO] = {
+	[NFPROTO_UNSPEC]	= "unknown",
 	[NFPROTO_INET]		= "inet",
 	[NFPROTO_IPV4]		= "ip",
 	[NFPROTO_ARP]		= "arp",
@@ -33,7 +34,7 @@ static const char *const nftnl_family_str[NFPROTO_NUMPROTO] = {
 
 const char *nftnl_family2str(uint32_t family)
 {
-	if (nftnl_family_str[family] == NULL)
+	if (family >= NFPROTO_NUMPROTO || !nftnl_family_str[family])
 		return "unknown";
 
 	return nftnl_family_str[family];
-- 
2.8.3

