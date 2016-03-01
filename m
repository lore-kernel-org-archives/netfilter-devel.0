From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libipt_MASQUERADE: Add translation to nft
Date: Tue, 1 Mar 2016 23:54:44 +0530
Message-ID: <20160301182444.GA12026@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35641 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbcCASYv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 13:24:51 -0500
Received: by mail-pa0-f49.google.com with SMTP id bj10so47541244pad.2
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Mar 2016 10:24:51 -0800 (PST)
Received: from gmail.com ([223.183.15.73])
        by smtp.gmail.com with ESMTPSA id ud10sm47245054pab.27.2016.03.01.10.24.48
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 01 Mar 2016 10:24:50 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for target MASQUERADE to nftables.
Full translation of this target awaits the support for --to-ports option.

Examples:

$ sudo iptables-translate -t nat -A POSTROUTING -o eth0 -j MASQUERADE
nft add rule ip nat POSTROUTING oifname eth0 counter masquerade

$ sudo iptables-translate -t nat -A POSTROUTING -j MASQUERADE --random
nft add rule ip nat POSTROUTING counter masquerade random

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libipt_MASQUERADE.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUERADE.c
index ea07445..1dc8853 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -134,6 +134,22 @@ MASQUERADE_save(const void *ip, const struct xt_entry_target *target)
 		printf(" --random");
 }
 
+static int
+MASQUERADE_xlate(const struct xt_entry_target *target,
+		 struct xt_xlate *xl, int numeric)
+{
+	const struct nf_nat_ipv4_multi_range_compat *mr =
+					(const void *)target->data;
+	const struct nf_nat_ipv4_range *r = &mr->range[0];
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
@@ -146,6 +162,7 @@ static struct xtables_target masquerade_tg_reg = {
 	.print		= MASQUERADE_print,
 	.save		= MASQUERADE_save,
 	.x6_options	= MASQUERADE_opts,
+	.xlate		= MASQUERADE_xlate,
 };
 
 void _init(void)
-- 
1.9.1

