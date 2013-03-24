From: pablo@netfilter.org
Subject: [PATCH 1/2] libxt_osf: fix missing --ttl and --log in save output
Date: Sun, 24 Mar 2013 11:09:19 +0100
Message-ID: <1364119760-5069-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35600 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab3CXKJ3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Mar 2013 06:09:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

closes http://bugzilla.netfilter.org/show_bug.cgi?id=805

Reported-by: Bourne Without <blackhole@airposte.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 extensions/libxt_osf.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/extensions/libxt_osf.c b/extensions/libxt_osf.c
index 88274a0..4e2139a 100644
--- a/extensions/libxt_osf.c
+++ b/extensions/libxt_osf.c
@@ -93,6 +93,10 @@ static void osf_save(const void *ip, const struct xt_entry_match *match)
 	const struct xt_osf_info *info = (const struct xt_osf_info*) match->data;
 
 	printf(" --genre %s%s", (info->flags & XT_OSF_INVERT) ? "! ": "", info->genre);
+	if (info->flags & XT_OSF_TTL)
+		printf(" --ttl %u", info->ttl);
+	if (info->flags & XT_OSF_LOG)
+		printf(" --log %u", info->loglevel);
 }
 
 static struct xtables_match osf_match = {
-- 
1.7.10.4

