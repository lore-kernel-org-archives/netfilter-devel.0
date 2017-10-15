From: Aastha Gupta <aastha.gupta4104@gmail.com>
Subject: [PATCH v2] iptables: iptables-compat translation for TCPMSS
Date: Sun, 15 Oct 2017 17:32:19 +0530
Message-ID: <1508068939-17220-1-git-send-email-aastha.gupta4104@gmail.com>
Cc: Aastha Gupta <aastha.gupta4104@gmail.com>
To: outreachy-kernel@googlegroups.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:55255 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751792AbdJOMC1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Oct 2017 08:02:27 -0400
Received: by mail-pg0-f68.google.com with SMTP id l24so4603420pgu.11
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Oct 2017 05:02:27 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since path mtu support was added, we can now add
iptables-compat translation for TCPMSS extension.

Signed-off-by: Aastha Gupta <aastha.gupta4104@gmail.com>
---
changes in v2:
	- translate other options in TCPMSS target extension
	- fixed code styling issues

 extensions/libxt_TCPMSS.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/extensions/libxt_TCPMSS.c b/extensions/libxt_TCPMSS.c
index 4b71e44..0d9b200 100644
--- a/extensions/libxt_TCPMSS.c
+++ b/extensions/libxt_TCPMSS.c
@@ -91,6 +91,19 @@ static void TCPMSS_save(const void *ip, const struct xt_entry_target *target)
 		printf(" --set-mss %u", mssinfo->mss);
 }
 
+static int TCPMSS_xlate(struct xt_xlate *xl,
+			const struct xt_xlate_tg_params *params)
+{
+	const struct xt_tcpmss_info *mssinfo =
+		(const struct xt_tcpmss_info *)params->target->data;
+	if (mssinfo->mss == XT_TCPMSS_CLAMP_PMTU)
+		xt_xlate_add(xl, "tcp option maxseg size set rt mtu");
+	else
+		xt_xlate_add(xl, "tcp option maxseg size set %d", mssinfo->mss);
+
+	return 1;
+}
+
 static struct xtables_target tcpmss_tg_reg[] = {
 	{
 		.family        = NFPROTO_IPV4,
@@ -104,6 +117,7 @@ static struct xtables_target tcpmss_tg_reg[] = {
 		.x6_parse      = TCPMSS_parse,
 		.x6_fcheck     = TCPMSS_check,
 		.x6_options    = TCPMSS4_opts,
+		.xlate         = TCPMSS_xlate,
 	},
 	{
 		.family        = NFPROTO_IPV6,
-- 
2.7.4

