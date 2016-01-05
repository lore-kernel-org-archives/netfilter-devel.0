From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH v2] src: datatype: Modify symbol table for icmpv6 packet types
Date: Tue, 5 Jan 2016 17:50:23 +0530
Message-ID: <20160105122023.GA2815@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34308 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbcAEMUa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jan 2016 07:20:30 -0500
Received: by mail-pa0-f41.google.com with SMTP id uo6so195255711pac.1
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Jan 2016 04:20:30 -0800 (PST)
Received: from gmail.com ([106.215.133.124])
        by smtp.gmail.com with ESMTPSA id m87sm97549874pfi.51.2016.01.05.04.20.28
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 05 Jan 2016 04:20:29 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add the missing symbols and correct the macros corresponding to the
existing symbols.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
Changes in v2:
	Remove unneeded symbol and corresponding macro

 src/datatype.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index f56763b..40e14c9 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -17,6 +17,7 @@
 #include <arpa/inet.h>
 #include <linux/types.h>
 #include <linux/netfilter.h>
+#include <linux/icmpv6.h>
 
 #include <nftables.h>
 #include <datatype.h>
@@ -26,7 +27,6 @@
 #include <netlink.h>
 
 #include <netinet/ip_icmp.h>
-#include <netinet/icmp6.h>
 
 static const struct datatype *datatypes[TYPE_MAX + 1] = {
 	[TYPE_INVALID]		= &invalid_type,
@@ -731,10 +731,12 @@ const struct datatype icmp_code_type = {
 
 static const struct symbol_table icmpv6_code_tbl = {
 	.symbols	= {
-		SYMBOL("no-route",		ICMP6_DST_UNREACH_NOROUTE),
-		SYMBOL("admin-prohibited",	ICMP6_DST_UNREACH_ADMIN),
-		SYMBOL("addr-unreachable",	ICMP6_DST_UNREACH_ADDR),
-		SYMBOL("port-unreachable",	ICMP6_DST_UNREACH_NOPORT),
+		SYMBOL("no-route",		ICMPV6_NOROUTE),
+		SYMBOL("admin-prohibited",	ICMPV6_ADM_PROHIBITED),
+		SYMBOL("addr-unreachable",	ICMPV6_ADDR_UNREACH),
+		SYMBOL("port-unreachable",	ICMPV6_PORT_UNREACH),
+		SYMBOL("policy-fail",		ICMPV6_POLICY_FAIL),
+		SYMBOL("reject-route",		ICMPV6_REJECT_ROUTE),
 		SYMBOL_LIST_END
 	},
 };
-- 
1.9.1

