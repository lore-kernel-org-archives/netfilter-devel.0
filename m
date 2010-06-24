From: Tim Gardner <tim.gardner@canonical.com>
Subject: [PATCH 2/3] netfilter: xt_connbytes: Force CT accounting to be enabled
Date: Thu, 24 Jun 2010 09:27:36 -0600
Message-ID: <1277393257-15281-3-git-send-email-tim.gardner@canonical.com>
References: <1277393257-15281-1-git-send-email-tim.gardner@canonical.com>
Cc: netfilter-devel@vger.kernel.org,
	Tim Gardner <tim.gardner@canonical.com>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:2882 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755472Ab0FXP2M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jun 2010 11:28:12 -0400
In-Reply-To: <1277393257-15281-1-git-send-email-tim.gardner@canonical.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Check at rule install time that CT accounting is enabled. Force it
to be enabled if not while also emitting a warning since this is not
the default state.

This is in preparation for deprecating CONFIG_NF_CT_ACCT.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 net/netfilter/xt_connbytes.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index 7351783..b0cda8c 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -112,6 +112,16 @@ static int connbytes_mt_check(const struct xt_mtchk_param *par)
 	if (ret < 0)
 		pr_info("cannot load conntrack support for proto=%u\n",
 			par->family);
+
+	/*
+	 * This filter cannot function correctly unless connection tracking
+	 * accounting is enabled, so complain in the hope that someone notices.
+	 */
+	if (nf_ct_acct_enabled(par) == false) {
+		pr_warning("Forcing CT accounting to be enabled\n");
+		nf_ct_set_acct(par, true);
+	}
+
 	return ret;
 }
 
-- 
1.7.0.4

