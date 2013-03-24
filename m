From: pablo@netfilter.org
Subject: [PATCH 2/2] libxt_osf: fix bad location for location in --genre
Date: Sun, 24 Mar 2013 11:09:20 +0100
Message-ID: <1364119760-5069-2-git-send-email-pablo@netfilter.org>
References: <1364119760-5069-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35605 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295Ab3CXKJd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Mar 2013 06:09:33 -0400
In-Reply-To: <1364119760-5069-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

closes http://bugzilla.netfilter.org/show_bug.cgi?id=805

Reported-by: Bourne Without <blackhole@airposte.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 extensions/libxt_osf.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/extensions/libxt_osf.c b/extensions/libxt_osf.c
index 4e2139a..52dba47 100644
--- a/extensions/libxt_osf.c
+++ b/extensions/libxt_osf.c
@@ -92,7 +92,10 @@ static void osf_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_osf_info *info = (const struct xt_osf_info*) match->data;
 
-	printf(" --genre %s%s", (info->flags & XT_OSF_INVERT) ? "! ": "", info->genre);
+	if (info->flags & XT_OSF_INVERT)
+		printf(" !");
+
+	printf(" --genre %s", info->genre);
 	if (info->flags & XT_OSF_TTL)
 		printf(" --ttl %u", info->ttl);
 	if (info->flags & XT_OSF_LOG)
-- 
1.7.10.4

