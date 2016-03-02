From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH v2] extensions: libipt_MASQUERADE: Add translation to nft
Date: Wed, 2 Mar 2016 15:27:49 +0530
Message-ID: <20160302095749.GA6686@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:33875 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbcCBJ54 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 04:57:56 -0500
Received: by mail-pa0-f65.google.com with SMTP id hj7so647095pac.1
        for <netfilter-devel@vger.kernel.org>; Wed, 02 Mar 2016 01:57:56 -0800 (PST)
Received: from gmail.com ([223.176.178.213])
        by smtp.gmail.com with ESMTPSA id h2sm18180253pfd.91.2016.03.02.01.57.53
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 02 Mar 2016 01:57:54 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for masquerade to nftables.

Examples:

$ sudo iptables-translate -t nat -A POSTROUTING -j MASQUERADE
nft add rule ip nat POSTROUTING counter masquerade

$ sudo iptables-translate -t nat -A POSTROUTING -p tcp -j MASQUERADE --to-ports 10
nft add rule ip nat POSTROUTING ip protocol tcp counter masquerade to :10

$ sudo iptables-translate -t nat -A POSTROUTING -p tcp -j MASQUERADE --to-ports 10-20 --random
nft add rule ip nat POSTROUTING ip protocol tcp counter masquerade to :10-20 random

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
Changes in v2:
	Add code for masquerade port range selection

 extensions/libipt_MASQUERADE.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUERADE.c
index ea07445..d1393c1 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -134,6 +134,29 @@ MASQUERADE_save(const void *ip, const struct xt_entry_target *target)
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
+	xt_xlate_add(xl, "masquerade");
+
+	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
+		xt_xlate_add(xl, " to :%hu", ntohs(r->min.tcp.port));
+		if (r->max.tcp.port != r->min.tcp.port)
+			xt_xlate_add(xl, "-%hu", ntohs(r->max.tcp.port));
+        }
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
@@ -146,6 +169,7 @@ static struct xtables_target masquerade_tg_reg = {
 	.print		= MASQUERADE_print,
 	.save		= MASQUERADE_save,
 	.x6_options	= MASQUERADE_opts,
+	.xlate		= MASQUERADE_xlate,
 };
 
 void _init(void)
-- 
1.9.1

