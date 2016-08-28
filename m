From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH iptables 3/3] extensions: libip[6]t_REDIRECT: use new nft syntax when do xlate
Date: Sun, 28 Aug 2016 16:50:48 +0800
Message-ID: <1472374248-21912-3-git-send-email-zlpnobody@163.com>
References: <1472374248-21912-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:39417 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751075AbcH1Ivg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 Aug 2016 04:51:36 -0400
In-Reply-To: <1472374248-21912-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

After commit "parser_bison: redirect to :port for consistency with
nat/masq statement" in nftables tree, we should recommend the end
user to use the new syntax.

Before this patch:
  # iptables-translate -t nat -A PREROUTING -p tcp -j REDIRECT --to-ports 1
  nft add rule ip nat PREROUTING ip protocol tcp counter redirect to 1

Apply this patch:
  # iptables-translate -t nat -A PREROUTING -p tcp -j REDIRECT --to-ports 1
  nft add rule ip nat PREROUTING ip protocol tcp counter redirect to :1

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 extensions/libip6t_REDIRECT.c | 2 +-
 extensions/libipt_REDIRECT.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libip6t_REDIRECT.c b/extensions/libip6t_REDIRECT.c
index 32f85b9..8e04d2c 100644
--- a/extensions/libip6t_REDIRECT.c
+++ b/extensions/libip6t_REDIRECT.c
@@ -138,7 +138,7 @@ static int REDIRECT_xlate(struct xt_xlate *xl,
 	const struct nf_nat_range *range = (const void *)params->target->data;
 
 	if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
-		xt_xlate_add(xl, "redirect to %hu",
+		xt_xlate_add(xl, "redirect to :%hu",
 			   ntohs(range->min_proto.tcp.port));
 		if (range->max_proto.tcp.port != range->min_proto.tcp.port)
 			xt_xlate_add(xl, "-%hu ",
diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index 31ca88c..7850306 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -143,7 +143,7 @@ static int REDIRECT_xlate(struct xt_xlate *xl,
 	const struct nf_nat_ipv4_range *r = &mr->range[0];
 
 	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
-		xt_xlate_add(xl, "redirect to %hu", ntohs(r->min.tcp.port));
+		xt_xlate_add(xl, "redirect to :%hu", ntohs(r->min.tcp.port));
 		if (r->max.tcp.port != r->min.tcp.port)
 			xt_xlate_add(xl, "-%hu ", ntohs(r->max.tcp.port));
 		if (mr->range[0].flags & NF_NAT_RANGE_PROTO_RANDOM)
-- 
2.5.5


