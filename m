From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH iptables] extensions: libip6t_SNAT/DNAT: add square bracket in xlat output when port is specified
Date: Fri,  2 Sep 2016 20:47:05 +0800
Message-ID: <1472820425-7535-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:54839 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752353AbcIBMrn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Sep 2016 08:47:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

It is better to add square brackets to ip6 address in nft translation
output when the port is specified. This is keep consistent with the
nft syntax.

Before this patch:
  # ip6tables-translate -t nat -A OUTPUT -p tcp -j DNAT --to-destination \
  [123::4]:1
  nft add rule ip6 nat OUTPUT meta l4proto tcp counter dnat to 123::4 :1
  # ip6tables-translate -t nat -A POSTROUTING -p tcp -j SNAT --to-source \
  [123::4-123::8]:1
  nft add rule ip6 nat POSTROUTING meta l4proto tcp counter snat to 123::4-123::8 :1

Apply this patch:
  # ip6tables-translate -t nat -A OUTPUT -p tcp -j DNAT --to-destination \
  [123::4]:1
  nft add rule ip6 nat OUTPUT meta l4proto tcp counter dnat to [123::4]:1
  # ip6tables-translate -t nat -A POSTROUTING -p tcp -j SNAT --to-source \
  [123::4-123::8]:1
  nft add rule ip6 nat POSTROUTING meta l4proto tcp counter snat to [123::4]-[123::8]:1

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 extensions/libip6t_DNAT.c | 21 ++++++++++++++-------
 extensions/libip6t_SNAT.c | 21 ++++++++++++++-------
 2 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/extensions/libip6t_DNAT.c b/extensions/libip6t_DNAT.c
index 97a8b1c..08d920d 100644
--- a/extensions/libip6t_DNAT.c
+++ b/extensions/libip6t_DNAT.c
@@ -234,17 +234,24 @@ static void DNAT_save(const void *ip, const struct xt_entry_target *target)
 static void print_range_xlate(const struct nf_nat_range *range,
 			      struct xt_xlate *xl)
 {
+	bool proto_specified = range->flags & NF_NAT_RANGE_PROTO_SPECIFIED;
+
 	if (range->flags & NF_NAT_RANGE_MAP_IPS) {
-		xt_xlate_add(xl, "%s",
-			   xtables_ip6addr_to_numeric(&range->min_addr.in6));
+		xt_xlate_add(xl, "%s%s%s",
+			     proto_specified ? "[" : "",
+			     xtables_ip6addr_to_numeric(&range->min_addr.in6),
+			     proto_specified ? "]" : "");
 
 		if (memcmp(&range->min_addr, &range->max_addr,
-			   sizeof(range->min_addr)))
-			xt_xlate_add(xl, "-%s",
-			     xtables_ip6addr_to_numeric(&range->max_addr.in6));
+			   sizeof(range->min_addr))) {
+			xt_xlate_add(xl, "-%s%s%s",
+				     proto_specified ? "[" : "",
+				     xtables_ip6addr_to_numeric(&range->max_addr.in6),
+				     proto_specified ? "]" : "");
+		}
 	}
-	if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
-		xt_xlate_add(xl, " :%hu", ntohs(range->min_proto.tcp.port));
+	if (proto_specified) {
+		xt_xlate_add(xl, ":%hu", ntohs(range->min_proto.tcp.port));
 
 		if (range->max_proto.tcp.port != range->min_proto.tcp.port)
 			xt_xlate_add(xl, "-%hu",
diff --git a/extensions/libip6t_SNAT.c b/extensions/libip6t_SNAT.c
index c3d8190..671ac61 100644
--- a/extensions/libip6t_SNAT.c
+++ b/extensions/libip6t_SNAT.c
@@ -244,17 +244,24 @@ static void SNAT_save(const void *ip, const struct xt_entry_target *target)
 static void print_range_xlate(const struct nf_nat_range *range,
 			      struct xt_xlate *xl)
 {
+	bool proto_specified = range->flags & NF_NAT_RANGE_PROTO_SPECIFIED;
+
 	if (range->flags & NF_NAT_RANGE_MAP_IPS) {
-		xt_xlate_add(xl, "%s",
-			   xtables_ip6addr_to_numeric(&range->min_addr.in6));
+		xt_xlate_add(xl, "%s%s%s",
+			     proto_specified ? "[" : "",
+			     xtables_ip6addr_to_numeric(&range->min_addr.in6),
+			     proto_specified ? "]" : "");
 
 		if (memcmp(&range->min_addr, &range->max_addr,
-			   sizeof(range->min_addr)))
-			xt_xlate_add(xl, "-%s",
-			     xtables_ip6addr_to_numeric(&range->max_addr.in6));
+			   sizeof(range->min_addr))) {
+			xt_xlate_add(xl, "-%s%s%s",
+				     proto_specified ? "[" : "",
+				     xtables_ip6addr_to_numeric(&range->max_addr.in6),
+				     proto_specified ? "]" : "");
+		}
 	}
-	if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
-		xt_xlate_add(xl, " :%hu", ntohs(range->min_proto.tcp.port));
+	if (proto_specified) {
+		xt_xlate_add(xl, ":%hu", ntohs(range->min_proto.tcp.port));
 
 		if (range->max_proto.tcp.port != range->min_proto.tcp.port)
 			xt_xlate_add(xl, "-%hu",
-- 
2.5.5


