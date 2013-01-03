From: Ulrich Weber <ulrich.weber@sophos.com>
Subject: [PATCH] iptables: set IPv6 DNAT --to-destination
Date: Thu, 3 Jan 2013 11:41:38 +0100
Message-ID: <20130103104125.GA11070@uweber-WS>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx2.sophos.com ([145.253.124.138]:59437 "EHLO mx2.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039Ab3ACKlp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jan 2013 05:41:45 -0500
Received: from mx2.sophos.com (localhost.localdomain [127.0.0.1])
	by localhost (Postfix) with SMTP id 5395060002
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Jan 2013 10:41:44 +0000 (GMT)
Received: from de-wie-exch3b.green.sophos (de-wie-exch3b.green.sophos [10.60.70.62])
	by mx2.sophos.com (Postfix) with ESMTPS id 2ACAA60001
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Jan 2013 10:41:44 +0000 (GMT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

as in IPv4 and fixes DNAT_save

Signed-off-by: Ulrich Weber <ulrich.weber@sophos.com>
---
 extensions/libip6t_DNAT.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/extensions/libip6t_DNAT.c b/extensions/libip6t_DNAT.c
index 1bba37e..eaa6bf1 100644
--- a/extensions/libip6t_DNAT.c
+++ b/extensions/libip6t_DNAT.c
@@ -29,13 +29,13 @@ static void DNAT_help(void)
 {
 	printf(
 "DNAT target options:\n"
-" --to-dest [<ipaddr>[-<ipaddr>]][:port[-port]]\n"
-"				Address to map source to.\n"
+" --to-destination [<ipaddr>[-<ipaddr>]][:port[-port]]\n"
+"				Address to map destination to.\n"
 "[--random] [--persistent]\n");
 }
 
 static const struct xt_option_entry DNAT_opts[] = {
-	{.name = "to-dest", .id = O_TO_DEST, .type = XTTYPE_STRING,
+	{.name = "to-destination", .id = O_TO_DEST, .type = XTTYPE_STRING,
 	 .flags = XTOPT_MAND | XTOPT_MULTI},
 	{.name = "random", .id = O_RANDOM, .type = XTTYPE_NONE},
 	{.name = "persistent", .id = O_PERSISTENT, .type = XTTYPE_NONE},
@@ -167,7 +167,7 @@ static void DNAT_parse(struct xt_option_call *cb)
 				get_kernel_version();
 			if (kernel_version > LINUX_VERSION(2, 6, 10))
 				xtables_error(PARAMETER_PROBLEM,
-					   "DNAT: Multiple --to-source not supported");
+					   "DNAT: Multiple --to-destination not supported");
 		}
 		parse_to(cb->arg, portok, range);
 		break;
@@ -223,7 +223,7 @@ static void DNAT_save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct nf_nat_range *range = (const void *)target->data;
 
-	printf(" --to-source ");
+	printf(" --to-destination ");
 	print_range(range);
 	if (range->flags & NF_NAT_RANGE_PROTO_RANDOM)
 		printf(" --random");
-- 
1.8.0.2

