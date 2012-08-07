From: Michal Kubecek <mkubecek@suse.cz>
Subject: [iptables PATCH] libip6t_frag: match any frag id by default
Date: Tue, 7 Aug 2012 15:10:05 +0200
Message-ID: <20120807133739.AB7F8C6417@unicorn.suse.cz>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56597 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479Ab2HGNhl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Aug 2012 09:37:41 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id DA67CA3E85
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Aug 2012 15:37:39 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If no --fragid option is given, frag extension matches only
fragments with zero Identification field. This is unexpected and
it breaks ip6tables-save/ip6tables-restore functionality. Match
any frag id instead.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 extensions/libip6t_frag.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index d8bcaee..9bd802b 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -41,6 +41,13 @@ static const struct xt_option_entry frag_opts[] = {
 };
 #undef s
 
+static void frag_init(struct xt_entry_match *m)
+{
+	struct ip6t_frag *fraginfo = (struct ip6t_frag *)m->data;
+
+	fraginfo->ids[1] = 0xFFFFFFFF;
+}
+
 static void frag_parse(struct xt_option_call *cb)
 {
 	struct ip6t_frag *fraginfo = cb->data;
@@ -173,6 +180,7 @@ static struct xtables_match frag_mt6_reg = {
 	.size          = XT_ALIGN(sizeof(struct ip6t_frag)),
 	.userspacesize = XT_ALIGN(sizeof(struct ip6t_frag)),
 	.help          = frag_help,
+	.init          = frag_init,
 	.print         = frag_print,
 	.save          = frag_save,
 	.x6_parse      = frag_parse,
-- 
1.7.10.4

