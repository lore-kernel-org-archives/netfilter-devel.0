From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libip6t_MASQUERADE: Add translation to nft
Date: Wed, 2 Mar 2016 00:05:47 +0530
Message-ID: <20160301183547.GA12993@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34764 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbcCASfy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 13:35:54 -0500
Received: by mail-pa0-f47.google.com with SMTP id fy10so116460485pac.1
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Mar 2016 10:35:54 -0800 (PST)
Received: from gmail.com ([223.183.15.73])
        by smtp.gmail.com with ESMTPSA id x13sm47177953pfa.72.2016.03.01.10.35.51
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 01 Mar 2016 10:35:52 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for target masquerade to nftables.
Full translation of this target awaits the support for --to-ports
option.

Examples:

$ sudo ip6tables-translate -t nat -A POSTROUTING -o eth0 -j MASQUERADE
nft add rule ip6 nat POSTROUTING oifname eth0 counter masquerade

$ sudo ip6tables-translate -t nat -A POSTROUTING -j MASQUERADE --random
nft add rule ip6 nat POSTROUTING counter masquerade random

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libip6t_MASQUERADE.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/extensions/libip6t_MASQUERADE.c b/extensions/libip6t_MASQUERADE.c
index eb9213e..325cdcd 100644
--- a/extensions/libip6t_MASQUERADE.c
+++ b/extensions/libip6t_MASQUERADE.c
@@ -131,6 +131,20 @@ MASQUERADE_save(const void *ip, const struct xt_entry_target *target)
 		printf(" --random");
 }
 
+static int
+MASQUERADE_xlate(const struct xt_entry_target *target,
+		 struct xt_xlate *xl, int numeric)
+{
+	const struct nf_nat_range *r = (const void *)target->data;
+
+	xt_xlate_add(xl, "masquerade ");
+
+	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM)
+		xt_xlate_add(xl, "random ");
+
+	return 1;
+}
+
 static struct xtables_target masquerade_tg_reg = {
 	.name		= "MASQUERADE",
 	.version	= XTABLES_VERSION,
@@ -142,6 +156,7 @@ static struct xtables_target masquerade_tg_reg = {
 	.print		= MASQUERADE_print,
 	.save		= MASQUERADE_save,
 	.x6_options	= MASQUERADE_opts,
+	.xlate		= MASQUERADE_xlate,
 };
 
 void _init(void)
-- 
1.9.1

