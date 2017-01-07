From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH iptables] extensions: libxt_rpfilter: add translation to nft
Date: Sat,  7 Jan 2017 22:26:46 +0800
Message-ID: <1483799206-59857-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
        Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:34520 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755825AbdAGO1z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Jan 2017 09:27:55 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

For example:
  # iptables-translate -t mangle -A PREROUTING -m rpfilter
  nft add rule ip mangle PREROUTING fib saddr . iif oif != 0 counter

  # iptables-translate -t mangle -A PREROUTING -m rpfilter --validmark \
  --loose
  nft add rule ip mangle PREROUTING fib saddr . mark oif != 0 counter

  # ip6tables-translate -t mangle -A PREROUTING -m rpfilter --validmark \
  --invert
  nft add rule ip6 mangle PREROUTING fib saddr . mark . iif oif 0 counter

Finally, when the "--accept-local" option is specified, we can combine
with "fib saddr type" to simulate it.

But when it is used like this: "-m rpfilter --accept-local", it means "||"
relationship, so we cannot translate it to one single nft rule,
translation is not supported yet:
  # iptables-translate -t mangle -A PREROUTING -m rpfilter --accept-local
  nft # -t mangle -A PREROUTING -m rpfilter --accept-local

When "--accpet-local" is combined with "--invert", it means "&&"
relationship, so translation can be:
  # iptables-translate -t mangle -A PREROUTING -m rpfilter \
  --accept-local --invert
  nft add rule ip mangle PREROUTING fib saddr type != local fib saddr \
  . iif oif 0 counter

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 extensions/libxt_rpfilter.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/extensions/libxt_rpfilter.c b/extensions/libxt_rpfilter.c
index 168e703..d166baa 100644
--- a/extensions/libxt_rpfilter.c
+++ b/extensions/libxt_rpfilter.c
@@ -77,6 +77,31 @@ static void rpfilter_save(const void *ip, const struct xt_entry_match *match)
 	return rpfilter_print_prefix(ip, match->data, "--");
 }
 
+static int rpfilter_xlate(struct xt_xlate *xl,
+			  const struct xt_xlate_mt_params *params)
+{
+	const struct xt_rpfilter_info *info = (void *)params->match->data;
+	bool invert = info->flags & XT_RPFILTER_INVERT;
+
+	if (info->flags & XT_RPFILTER_ACCEPT_LOCAL) {
+		if (invert)
+			xt_xlate_add(xl, "fib saddr type != local ");
+		else
+			return 0;
+	}
+
+	xt_xlate_add(xl, "fib saddr ");
+
+	if (info->flags & XT_RPFILTER_VALID_MARK)
+		xt_xlate_add(xl, ". mark ");
+	if (!(info->flags & XT_RPFILTER_LOOSE))
+		xt_xlate_add(xl, ". iif ");
+
+	xt_xlate_add(xl, "oif %s0", invert ? "" : "!= ");
+
+	return 1;
+}
+
 static struct xtables_match rpfilter_match = {
 	.family		= NFPROTO_UNSPEC,
 	.name		= "rpfilter",
@@ -88,6 +113,7 @@ static struct xtables_match rpfilter_match = {
 	.save		= rpfilter_save,
 	.x6_parse	= rpfilter_parse,
 	.x6_options	= rpfilter_opts,
+	.xlate		= rpfilter_xlate,
 };
 
 void _init(void)
-- 
2.5.5


