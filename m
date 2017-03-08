From: Phil Sutter <phil@nwl.cc>
Subject: [iptables PATCH] extensions: libxt_addrtype: Add translation to nft
Date: Wed,  8 Mar 2017 02:06:14 +0100
Message-ID: <20170308010614.13881-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:38299 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933455AbdCHBRw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2017 20:17:52 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Translate addrtype match into fib expression:

$ iptables-translate -A INPUT -m addrtype --src-type LOCAL
nft add rule ip filter INPUT fib saddr type local counter

$ iptables-translate -A INPUT -m addrtype --dst-type LOCAL
nft add rule ip filter INPUT fib daddr type local counter

$ iptables-translate -A INPUT -m addrtype ! --dst-type ANYCAST,LOCAL
nft add rule ip filter INPUT fib daddr type != { local, anycast } counter

$ iptables-translate -A INPUT -m addrtype --limit-iface-in --dst-type ANYCAST,LOCAL
nft add rule ip filter INPUT fib daddr . iif type { local, anycast } counter

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_addrtype.c | 69 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/extensions/libxt_addrtype.c b/extensions/libxt_addrtype.c
index e5d3033ccc5ca..27485405b3595 100644
--- a/extensions/libxt_addrtype.c
+++ b/extensions/libxt_addrtype.c
@@ -245,6 +245,74 @@ static void addrtype_save_v1(const void *ip, const struct xt_entry_match *match)
 		printf(" --limit-iface-out");
 }
 
+static const char *const rtn_lnames[] = {
+	"unspec",
+	"unicast",
+	"local",
+	"broadcast",
+	"anycast",
+	"multicast",
+	"blackhole",
+	"unreachable",
+	"prohibit",
+	NULL,
+};
+
+static bool multiple_bits_set(uint16_t val)
+{
+	int first = ffs(val);
+
+	return first && (val >> first) > 0;
+}
+
+static int addrtype_xlate(struct xt_xlate *xl,
+			  const struct xt_xlate_mt_params *params)
+{
+	const struct xt_addrtype_info_v1 *info =
+		(const void *)params->match->data;
+	const char *sep = "";
+	bool need_braces;
+	uint16_t val;
+	int i;
+
+	xt_xlate_add(xl, "fib ");
+
+	if (info->source) {
+		xt_xlate_add(xl, "saddr ");
+		val = info->source;
+	} else {
+		xt_xlate_add(xl, "daddr ");
+		val = info->dest;
+	}
+
+	if (info->flags & XT_ADDRTYPE_LIMIT_IFACE_IN)
+		xt_xlate_add(xl, ". iif ");
+	else if (info->flags & XT_ADDRTYPE_LIMIT_IFACE_OUT)
+		xt_xlate_add(xl, ". oif ");
+
+	xt_xlate_add(xl, "type ");
+
+	if (info->flags & (XT_ADDRTYPE_INVERT_SOURCE | XT_ADDRTYPE_INVERT_DEST))
+			xt_xlate_add(xl, "!= ");
+
+	need_braces = multiple_bits_set(val);
+
+	if (need_braces)
+		xt_xlate_add(xl, "{ ");
+
+	for (i = 0; rtn_lnames[i]; i++) {
+		if (val & (1 << i)) {
+			xt_xlate_add(xl, "%s%s", sep, rtn_lnames[i]);
+			sep = ", ";
+		}
+	}
+
+	if (need_braces)
+		xt_xlate_add(xl, " }");
+
+	return 1;
+}
+
 static const struct xt_option_entry addrtype_opts_v0[] = {
 	{.name = "src-type", .id = O_SRC_TYPE, .type = XTTYPE_STRING,
 	 .flags = XTOPT_INVERT},
@@ -292,6 +360,7 @@ static struct xtables_match addrtype_mt_reg[] = {
 		.x6_parse      = addrtype_parse_v1,
 		.x6_fcheck     = addrtype_check,
 		.x6_options    = addrtype_opts_v1,
+		.xlate         = addrtype_xlate,
 	},
 };
 
-- 
2.11.0

