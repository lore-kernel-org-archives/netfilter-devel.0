From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH v2] extensions: libip6t_MASQUERADE: Add translation to nft
Date: Wed, 2 Mar 2016 15:54:01 +0530
Message-ID: <20160302102401.GA9921@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:33704 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbcCBKYJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 05:24:09 -0500
Received: by mail-pa0-f65.google.com with SMTP id y7so12018715paa.0
        for <netfilter-devel@vger.kernel.org>; Wed, 02 Mar 2016 02:24:09 -0800 (PST)
Received: from gmail.com ([223.176.178.213])
        by smtp.gmail.com with ESMTPSA id kw10sm51963550pab.0.2016.03.02.02.24.06
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 02 Mar 2016 02:24:07 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for masquerade to nftables.

Examples:

$ sudo ip6tables-translate -t nat -A POSTROUTING -j MASQUERADE
nft add rule ip6 nat POSTROUTING counter masquerade

$ sudo ip6tables-translate -t nat -A POSTROUTING -p tcp -j MASQUERADE --to-ports 10
nft add rule ip6 nat POSTROUTING ip6 nexthdr tcp counter masquerade to :10

$ sudo ip6tables-translate -t nat -A POSTROUTING -p tcp -j MASQUERADE --to-ports 10-20 --random
nft add rule ip6 nat POSTROUTING ip6 nexthdr tcp counter masquerade to :10-20 random

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
Changes in v2:
	Add code for masquerading port range selection

 extensions/libip6t_MASQUERADE.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/extensions/libip6t_MASQUERADE.c b/extensions/libip6t_MASQUERADE.c
index eb9213e..5a309ac 100644
--- a/extensions/libip6t_MASQUERADE.c
+++ b/extensions/libip6t_MASQUERADE.c
@@ -131,6 +131,27 @@ MASQUERADE_save(const void *ip, const struct xt_entry_target *target)
 		printf(" --random");
 }
 
+static int
+MASQUERADE_xlate(const struct xt_entry_target *target,
+		 struct xt_xlate *xl, int numeric)
+{
+	const struct nf_nat_range *r = (const void *)target->data;
+
+	xt_xlate_add(xl, "masquerade");
+
+	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
+		xt_xlate_add(xl, " to :%hu", ntohs(r->min_proto.tcp.port));
+		if (r->max_proto.tcp.port != r->min_proto.tcp.port)
+			xt_xlate_add(xl, "-%hu", ntohs(r->max_proto.tcp.port));
+	}
+
+	xt_xlate_add(xl, " ");
+	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM)
+		xt_xlate_add(xl, "random ");
+
+	return 1;
+}
+
 static struct xtables_target masquerade_tg_reg = {
 	.name		= "MASQUERADE",
 	.version	= XTABLES_VERSION,
@@ -142,6 +163,7 @@ static struct xtables_target masquerade_tg_reg = {
 	.print		= MASQUERADE_print,
 	.save		= MASQUERADE_save,
 	.x6_options	= MASQUERADE_opts,
+	.xlate		= MASQUERADE_xlate,
 };
 
 void _init(void)
-- 
1.9.1

