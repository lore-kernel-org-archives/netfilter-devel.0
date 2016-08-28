From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH iptables 2/3] extensions: libip[6]t_SNAT/DNAT: use the new nft syntax when do xlate
Date: Sun, 28 Aug 2016 16:50:47 +0800
Message-ID: <1472374248-21912-2-git-send-email-zlpnobody@163.com>
References: <1472374248-21912-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:39335 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751075AbcH1Ivf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 Aug 2016 04:51:35 -0400
In-Reply-To: <1472374248-21912-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

After commit "src: add 'to' for snat and dnat" in nftables tree,
we should recommend the end user to use the new syntax.

Before this patch:
  # iptables-translate -t nat -A POSTROUTING -j SNAT --to-source 1.1.1.1
  nft add rule ip nat POSTROUTING counter snat 1.1.1.1
  # ip6tables-translate -t nat -A PREROUTING -j DNAT --to-destination
  2001::1
  nft add rule ip6 nat PREROUTING counter dnat 2001::1

Apply this patch:
  # iptables-translate -t nat -A POSTROUTING -j SNAT --to-source 1.1.1.1
  nft add rule ip nat POSTROUTING counter snat to 1.1.1.1
  # ip6tables-translate -t nat -A PREROUTING -j DNAT --to-destination
  2001::1
  nft add rule ip6 nat PREROUTING counter dnat to 2001::1

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 extensions/libip6t_DNAT.c | 2 +-
 extensions/libip6t_SNAT.c | 2 +-
 extensions/libipt_DNAT.c  | 2 +-
 extensions/libipt_SNAT.c  | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/extensions/libip6t_DNAT.c b/extensions/libip6t_DNAT.c
index 3925c3b..97a8b1c 100644
--- a/extensions/libip6t_DNAT.c
+++ b/extensions/libip6t_DNAT.c
@@ -259,7 +259,7 @@ static int DNAT_xlate(struct xt_xlate *xl,
 	bool sep_need = false;
 	const char *sep = " ";
 
-	xt_xlate_add(xl, "dnat ");
+	xt_xlate_add(xl, "dnat to ");
 	print_range_xlate(range, xl);
 	if (range->flags & NF_NAT_RANGE_PROTO_RANDOM) {
 		xt_xlate_add(xl, " random");
diff --git a/extensions/libip6t_SNAT.c b/extensions/libip6t_SNAT.c
index 4d742ea..c3d8190 100644
--- a/extensions/libip6t_SNAT.c
+++ b/extensions/libip6t_SNAT.c
@@ -269,7 +269,7 @@ static int SNAT_xlate(struct xt_xlate *xl,
 	bool sep_need = false;
 	const char *sep = " ";
 
-	xt_xlate_add(xl, "snat ");
+	xt_xlate_add(xl, "snat to ");
 	print_range_xlate(range, xl);
 	if (range->flags & NF_NAT_RANGE_PROTO_RANDOM) {
 		xt_xlate_add(xl, " random");
diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index 7890719..a14d16f 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -271,7 +271,7 @@ static int DNAT_xlate(struct xt_xlate *xl,
 	const char *sep = " ";
 
 	for (i = 0; i < info->mr.rangesize; i++) {
-		xt_xlate_add(xl, "dnat ");
+		xt_xlate_add(xl, "dnat to ");
 		print_range_xlate(&info->mr.range[i], xl);
 		if (info->mr.range[i].flags & NF_NAT_RANGE_PROTO_RANDOM) {
 			xt_xlate_add(xl, " random");
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 5c699d3..e92d811 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -282,7 +282,7 @@ static int SNAT_xlate(struct xt_xlate *xl,
 	const char *sep = " ";
 
 	for (i = 0; i < info->mr.rangesize; i++) {
-		xt_xlate_add(xl, "snat ");
+		xt_xlate_add(xl, "snat to ");
 		print_range_xlate(&info->mr.range[i], xl);
 		if (info->mr.range[i].flags & NF_NAT_RANGE_PROTO_RANDOM) {
 			xt_xlate_add(xl, " random");
-- 
2.5.5


