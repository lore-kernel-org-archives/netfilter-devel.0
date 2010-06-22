From: Tim Gardner <tim.gardner@canonical.com>
Subject: Re: [PATCH 2/3] netfilter: xt_connbytes: Force CT tracking to be
 enabled
Date: Tue, 22 Jun 2010 11:02:42 -0600
Message-ID: <4C20ECB2.6010506@canonical.com>
References: <1277225075-30428-1-git-send-email-tim.gardner@canonical.com> <1277225075-30428-3-git-send-email-tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010606040708040207060408"
Cc: netfilter-devel@vger.kernel.org, ole@ans.pl
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:2971 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab0FVRCu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jun 2010 13:02:50 -0400
In-Reply-To: <1277225075-30428-3-git-send-email-tim.gardner@canonical.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010606040708040207060408
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Bah! This should be 'CT accounting', not 'CT tracking'. The commit in 
the git repo is correct, I'd just forgotten to regen the patches that I 
emailed.

rtg

-- 
Tim Gardner tim.gardner@canonical.com

--------------010606040708040207060408
Content-Type: text/x-patch;
 name="0002-netfilter-xt_connbytes-Force-CT-accounting-to-be-ena.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-netfilter-xt_connbytes-Force-CT-accounting-to-be-ena.pa";
 filename*1="tch"

>From 5836a019e4d267d78ba2b33db2d77cd03cd83fb2 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Tue, 22 Jun 2010 09:27:30 -0600
Subject: [PATCH 2/3] netfilter: xt_connbytes: Force CT accounting to be enabled

Check at runtime that CT accounting is enabled, and force it
to be enabled if not.

This is in preparation for deprecating CONFIG_NF_CT_ACCT.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 net/netfilter/xt_connbytes.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index 7351783..d703355 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -21,7 +21,7 @@ static bool
 connbytes_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_connbytes_info *sinfo = par->matchinfo;
-	const struct nf_conn *ct;
+	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	u_int64_t what = 0;	/* initialize to make gcc happy */
 	u_int64_t bytes = 0;
@@ -32,6 +32,17 @@ connbytes_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	if (!ct)
 		return false;
 
+	/*
+	 * This filter cannot function correctly unless connection tracking
+	 * accounting is enabled, so complain about it until someone notices.
+	 * It _should_ only print one warning message.
+	 */
+	if (unlikely(nf_ct_acct_enabled(ct) == false)) {
+		if (net_ratelimit())
+			pr_warning("ipt_connbytes: Force enabling CT accounting\n");
+		nf_ct_set_acct(ct, true);
+	}
+
 	counters = nf_conn_acct_find(ct);
 	if (!counters)
 		return false;
-- 
1.7.0.4


--------------010606040708040207060408--
