From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH iptables 1/3] extensions: libipt_DNAT/SNAT: fix "OOM" when do translation to nft
Date: Sun, 28 Aug 2016 16:50:46 +0800
Message-ID: <1472374248-21912-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:39136 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751075AbcH1Ivb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 Aug 2016 04:51:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

When I want to translate SNAT target to nft rule, an error message
was printed out:
  # iptables-translate -A POSTROUTING -j SNAT --to-source 1.1.1.1
  iptables-translate v1.6.0: OOM

Because ipt_natinfo{} started with a xt_entry_target{}, so when we
get the ipt_natinfo pointer, we should use the target itself,
not its data pointer. Yes, it is a little tricky and it's different
with other targets.

Fixes: 7a0992da44cf ("src: introduce struct xt_xlate_{mt,tg}_params")
Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 extensions/libipt_DNAT.c | 2 +-
 extensions/libipt_SNAT.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index c463f07..7890719 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -265,7 +265,7 @@ static void print_range_xlate(const struct nf_nat_ipv4_range *r,
 static int DNAT_xlate(struct xt_xlate *xl,
 		      const struct xt_xlate_tg_params *params)
 {
-	const struct ipt_natinfo *info = (const void *)params->target->data;
+	const struct ipt_natinfo *info = (const void *)params->target;
 	unsigned int i = 0;
 	bool sep_need = false;
 	const char *sep = " ";
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 71717fd..5c699d3 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -276,7 +276,7 @@ static void print_range_xlate(const struct nf_nat_ipv4_range *r,
 static int SNAT_xlate(struct xt_xlate *xl,
 		      const struct xt_xlate_tg_params *params)
 {
-	const struct ipt_natinfo *info = (const void *)params->target->data;
+	const struct ipt_natinfo *info = (const void *)params->target;
 	unsigned int i = 0;
 	bool sep_need = false;
 	const char *sep = " ";
-- 
2.5.5


