From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/8] netfilter: ip_tables: fix compilation when debug is enabled
Date: Tue, 11 May 2010 18:47:24 +0200
Message-ID: <1273596452-27011-2-git-send-email-jengelh@medozas.de>
References: <1273596452-27011-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37422 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755Ab0EKQr6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 May 2010 12:47:58 -0400
In-Reply-To: <1273596452-27011-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/ip_tables.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 3e6af10..f92818f 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -591,7 +591,7 @@ check_entry(const struct ipt_entry *e, const char *name)
 	const struct ipt_entry_target *t;
 
 	if (!ip_checkentry(&e->ip)) {
-		duprintf("ip check failed %p %s.\n", e, name);
+		duprintf("ip check failed %p %s.\n", e, par->match->name);
 		return -EINVAL;
 	}
 
@@ -618,7 +618,7 @@ check_match(struct ipt_entry_match *m, struct xt_mtchk_param *par)
 	ret = xt_check_match(par, m->u.match_size - sizeof(*m),
 	      ip->proto, ip->invflags & IPT_INV_PROTO);
 	if (ret < 0) {
-		duprintf("check failed for `%s'.\n", par.match->name);
+		duprintf("check failed for `%s'.\n", par->match->name);
 		return ret;
 	}
 	return 0;
-- 
1.7.0.5

