From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH] libnetfilter_acct: use PRIu64 and remove unnecessary cast
Date: Tue, 05 Mar 2013 18:40:39 +0000
Message-ID: <51363C27.3020305@googlemail.com>
References: <20130305135943.GA4369@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:55837 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757786Ab3CESku (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Mar 2013 13:40:50 -0500
Received: by mail-we0-f179.google.com with SMTP id p43so6850012wea.10
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Mar 2013 10:40:49 -0800 (PST)
In-Reply-To: <20130305135943.GA4369@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch corrects all nfacct_snprintf_* functions to use PRIu64,
given that we are using uint64_t type variables and also removes
the unnecessary casts.

Signed-off-by: Mr Dash Four <mr.dash.four@googlemail.com>
---
  src/libnetfilter_acct.c |   11 ++++-------
  1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/src/libnetfilter_acct.c b/src/libnetfilter_acct.c
index 0abaeac..ba89e2d 100644
--- a/src/libnetfilter_acct.c
+++ b/src/libnetfilter_acct.c
@@ -13,6 +13,7 @@
  #include <endian.h>
  #include <stdlib.h>
  #include <string.h>
+#include <inttypes.h>

  #include <libmnl/libmnl.h>
  #include <linux/netfilter/nfnetlink.h>
@@ -235,10 +236,8 @@ nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,

  	if (flags & NFACCT_SNPRINTF_F_FULL) {
  		ret = snprintf(buf, rem,
-			"{ pkts = %.20llu, bytes = %.20llu } = %s;",
-			(unsigned long long)
+			"{ pkts = %.20"PRIu64", bytes = %.20"PRIu64" } = %s;",
  			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS),
-			(unsigned long long)
  			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES),
  			nfacct_attr_get_str(nfacct, NFACCT_ATTR_NAME));
  	} else {
@@ -296,12 +295,10 @@ nfacct_snprintf_xml(char *buf, size_t rem, struct nfacct *nfacct,

  	ret = snprintf(buf, rem,
  			"<obj><name>%s</name>"
-			"<pkts>%.20llu</pkts>"
-			"<bytes>%.20llu</bytes>",
+			"<pkts>%.20"PRIu64"</pkts>"
+			"<bytes>%.20"PRIu64"</bytes>",
  			nfacct_attr_get_str(nfacct, NFACCT_ATTR_NAME),
-			(unsigned long long)
  			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES),
-			(unsigned long long)
  			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS));
  	BUFFER_SIZE(ret, size, rem, offset);



