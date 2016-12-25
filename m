From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH iptables] extensions: libxt_connbytes: Add translation to nft
Date: Sun, 25 Dec 2016 20:27:51 +0800
Message-ID: <1482668871-1946-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:47116 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752704AbcLYM2Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Dec 2016 07:28:24 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

For example:
  # iptables-translate -A OUTPUT -m connbytes --connbytes 200 \
  --connbytes-dir original --connbytes-mode packets
  nft add rule ip filter OUTPUT ct original packets ge 200 counter

  # iptables-translate -A OUTPUT -m connbytes ! --connbytes 200 \
  --connbytes-dir reply --connbytes-mode packets
  nft add rule ip filter OUTPUT ct reply packets lt 200 counter

  # iptables-translate -A OUTPUT -m connbytes --connbytes 200:600 \
  --connbytes-dir both --connbytes-mode bytes
  nft add rule ip filter OUTPUT ct bytes 200-600 counter

  # iptables-translate -A OUTPUT -m connbytes ! --connbytes 200:600 \
  --connbytes-dir both --connbytes-mode bytes
  nft add rule ip filter OUTPUT ct bytes != 200-600 counter

  # iptables-translate -A OUTPUT -m connbytes --connbytes 200:200 \
  --connbytes-dir both --connbytes-mode avgpkt
  nft add rule ip filter OUTPUT ct avgpkt 200 counter

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 extensions/libxt_connbytes.c | 56 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/extensions/libxt_connbytes.c b/extensions/libxt_connbytes.c
index ed2ad25..b57f0fc 100644
--- a/extensions/libxt_connbytes.c
+++ b/extensions/libxt_connbytes.c
@@ -156,6 +156,61 @@ static void connbytes_save(const void *ip, const struct xt_entry_match *match)
 	print_direction(sinfo);
 }
 
+
+static int connbytes_xlate(struct xt_xlate *xl,
+			   const struct xt_xlate_mt_params *params)
+{
+	const struct xt_connbytes_info *info = (void *)params->match->data;
+	unsigned long long from, to;
+	bool invert = false;
+
+	xt_xlate_add(xl, "ct ");
+
+	switch (info->direction) {
+	case XT_CONNBYTES_DIR_ORIGINAL:
+		xt_xlate_add(xl, "original ");
+		break;
+	case XT_CONNBYTES_DIR_REPLY:
+		xt_xlate_add(xl, "reply ");
+		break;
+	case XT_CONNBYTES_DIR_BOTH:
+		break;
+	default:
+		return 0;
+	}
+
+	switch (info->what) {
+	case XT_CONNBYTES_PKTS:
+		xt_xlate_add(xl, "packets ");
+		break;
+	case XT_CONNBYTES_BYTES:
+		xt_xlate_add(xl, "bytes ");
+		break;
+	case XT_CONNBYTES_AVGPKT:
+		xt_xlate_add(xl, "avgpkt ");
+		break;
+	default:
+		return 0;
+	}
+
+	if (info->count.from > info->count.to) {
+		invert = true;
+		from = info->count.to;
+		to = info->count.from;
+	} else {
+		to = info->count.to;
+		from = info->count.from;
+	}
+
+	if (from == to)
+		xt_xlate_add(xl, "%llu", from);
+	else if (to == UINT64_MAX)
+		xt_xlate_add(xl, "%s %llu", invert ? "lt" : "ge", from);
+	else
+		xt_xlate_add(xl, "%s%llu-%llu", invert ? "!= " : "", from, to);
+	return 1;
+}
+
 static struct xtables_match connbytes_match = {
 	.family		= NFPROTO_UNSPEC,
 	.name 		= "connbytes",
@@ -167,6 +222,7 @@ static struct xtables_match connbytes_match = {
 	.save 		= connbytes_save,
 	.x6_parse	= connbytes_parse,
 	.x6_options	= connbytes_opts,
+	.xlate		= connbytes_xlate,
 };
 
 void _init(void)
-- 
2.5.5


