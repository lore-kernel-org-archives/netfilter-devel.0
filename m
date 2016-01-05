From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] src: datatype: Modify symbol table for icmpv6 packet types
Date: Tue, 5 Jan 2016 12:08:36 +0530
Message-ID: <20160105063836.GA4295@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:33549 "EHLO
	mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbcAEGio (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jan 2016 01:38:44 -0500
Received: by mail-pf0-f172.google.com with SMTP id q63so179167705pfb.0
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Jan 2016 22:38:44 -0800 (PST)
Received: from gmail.com ([106.218.187.195])
        by smtp.gmail.com with ESMTPSA id v16sm125293431pfi.94.2016.01.04.22.38.41
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Mon, 04 Jan 2016 22:38:42 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add the missing symbols and correct the macros corresponding to the
existing symbols.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 src/datatype.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index f56763b..d8599e5 100644
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
@@ -731,10 +731,13 @@ const struct datatype icmp_code_type = {
 
 static const struct symbol_table icmpv6_code_tbl = {
 	.symbols	= {
-		SYMBOL("no-route",		ICMP6_DST_UNREACH_NOROUTE),
-		SYMBOL("admin-prohibited",	ICMP6_DST_UNREACH_ADMIN),
-		SYMBOL("addr-unreachable",	ICMP6_DST_UNREACH_ADDR),
-		SYMBOL("port-unreachable",	ICMP6_DST_UNREACH_NOPORT),
+		SYMBOL("no-route",		ICMPV6_NOROUTE),
+		SYMBOL("admin-prohibited",	ICMPV6_ADM_PROHIBITED),
+		SYMBOL("not-neighbour",		ICMPV6_NOT_NEIGHBOUR),
+		SYMBOL("addr-unreachable",	ICMPV6_ADDR_UNREACH),
+		SYMBOL("port-unreachable",	ICMPV6_PORT_UNREACH),
+		SYMBOL("policy-fail",		ICMPV6_POLICY_FAIL),
+		SYMBOL("reject-route",		ICMPV6_REJECT_ROUTE),
 		SYMBOL_LIST_END
 	},
 };
-- 
1.9.1

