From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH iptables] extensions: libxt_hashlimit: Add translation to nft
Date: Mon, 27 Feb 2017 14:43:08 -0300
Message-ID: <20170227174308.GA14613@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:34250 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751039AbdB0RuW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Feb 2017 12:50:22 -0500
Received: by mail-qk0-f195.google.com with SMTP id s186so18816022qkb.1
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Feb 2017 09:50:21 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hashlimit has similar functionality to flow tables in nftables. Some
usage examples are:

$ iptables-translate -A OUTPUT -m tcp -p tcp --dport 443 -m hashlimit \
--hashlimit-above 20kb/s --hashlimit-burst 1mb --hashlimit-mode dstip \
--hashlimit-name https --hashlimit-dstmask 24 -m state --state NEW \
-j DROP

nft add rule ip filter OUTPUT tcp dport 443 flow table https { ip \
daddr and 255.255.255.0 timeout 60s limit rate over 20 kbytes/second \
burst 1 mbytes} ct state new  counter drop

$ iptables-translate -A OUTPUT -m tcp -p tcp --dport 443 -m hashlimit \
--hashlimit-upto 300 --hashlimit-burst 15 --hashlimit-mode \
srcip,dstip --hashlimit-name https --hashlimit-htable-expire 300000 \
-m state --state NEW -j DROP

nft add rule ip filter OUTPUT tcp dport 443 flow table https { ip \
daddr . ip saddr timeout 300s limit rate 300/second burst 15 packets} \
ct state new  counter drop

The translation isn't supported when --hashlimit-mode isn't specified.
Also, the following options don't apply to flow tables:

--hashlimit-htable-size
--hashlimit-htable-max
--hashlimit-htable-gcinterval

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 extensions/libxt_hashlimit.c | 224 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 224 insertions(+)

diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index 7a1b37a..52fc4fa 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -916,6 +916,225 @@ hashlimit_mt6_save(const void *ip, const struct xt_entry_match *match)
 	hashlimit_mt_save(&info->cfg, info->name, 128, 2);
 }
 
+static const struct rates rates_v1_xlate[] = {
+	{ "day", XT_HASHLIMIT_SCALE * 24 * 60 * 60 },
+	{ "hour", XT_HASHLIMIT_SCALE * 60 * 60 },
+	{ "minute", XT_HASHLIMIT_SCALE * 60 },
+	{ "second", XT_HASHLIMIT_SCALE } };
+
+static const struct rates rates_xlate[] = {
+	{ "day", XT_HASHLIMIT_SCALE_v2 * 24 * 60 * 60 },
+	{ "hour", XT_HASHLIMIT_SCALE_v2 * 60 * 60 },
+	{ "minute", XT_HASHLIMIT_SCALE_v2 * 60 },
+	{ "second", XT_HASHLIMIT_SCALE_v2 } };
+
+static void print_packets_rate_xlate(struct xt_xlate *xl, uint64_t avg,
+				     uint64_t burst, int revision)
+{
+	unsigned int i;
+	const struct rates *_rates = (revision == 1) ?
+		rates_v1_xlate : rates_xlate;
+
+	for (i = 1; i < ARRAY_SIZE(rates); ++i)
+		if (avg > _rates[i].mult ||
+		    _rates[i].mult / avg < _rates[i].mult % avg)
+			break;
+
+	xt_xlate_add(xl, " %llu/%s burst %lu packets",
+		     _rates[i-1].mult / avg, _rates[i-1].name, burst);
+}
+
+static void print_bytes_rate_xlate(struct xt_xlate *xl,
+				   const struct hashlimit_cfg2 *cfg)
+{
+	unsigned int i;
+	unsigned long long r;
+
+	r = cost_to_bytes(cfg->avg);
+
+	for (i = 0; i < ARRAY_SIZE(units) -1; ++i)
+		if (r >= units[i].thresh &&
+		    bytes_to_cost(r & ~(units[i].thresh - 1)) == cfg->avg)
+			break;
+
+	xt_xlate_add(xl, " %llu %sbytes/second", r / units[i].thresh,
+		     units[i].name);
+
+	r *= cfg->burst;
+	for (i = 0; i < ARRAY_SIZE(units) -1; ++i)
+		if (r >= units[i].thresh)
+			break;
+
+	if (cfg->burst > 0)
+		xt_xlate_add(xl, " burst %llu %sbytes", r / units[i].thresh,
+			     units[i].name);
+}
+
+static void hashlimit_print_subnet_xlate(struct xt_xlate *xl,
+					 uint32_t nsub, int family)
+{
+	char sep = (family == NFPROTO_IPV4) ? '.' : ':';
+	char *fmt = (family == NFPROTO_IPV4) ? "%u" : "%04x";
+	unsigned int nblocks = (family == NFPROTO_IPV4) ? 4 : 8;
+	unsigned int nbits = (family == NFPROTO_IPV4) ? 8 : 16;
+	unsigned int acm, i;
+
+	xt_xlate_add(xl, " and ");
+	while (nblocks--) {
+		acm = 0;
+
+		for (i = 0; i < nbits; i++) {
+			acm <<= 1;
+
+			if (nsub > 0) {
+				acm++;
+				nsub--;
+			}
+		}
+
+		xt_xlate_add(xl, fmt, acm);
+		if (nblocks > 0)
+			xt_xlate_add(xl, "%c", sep);
+	}
+}
+
+static const char *const hashlimit_modes4_xlate[] = {
+	[XT_HASHLIMIT_HASH_DIP]	= "ip daddr",
+	[XT_HASHLIMIT_HASH_DPT]	= "tcp dport",
+	[XT_HASHLIMIT_HASH_SIP]	= "ip saddr",
+	[XT_HASHLIMIT_HASH_SPT]	= "tcp sport",
+};
+
+static const char *const hashlimit_modes6_xlate[] = {
+	[XT_HASHLIMIT_HASH_DIP]	= "ip6 daddr",
+	[XT_HASHLIMIT_HASH_DPT]	= "tcp dport",
+	[XT_HASHLIMIT_HASH_SIP]	= "ip6 saddr",
+	[XT_HASHLIMIT_HASH_SPT]	= "tcp sport",
+};
+
+static int hashlimit_mode_xlate(struct xt_xlate *xl,
+				uint32_t mode, int family,
+				unsigned int nsrc, unsigned int ndst)
+{
+	const char * const *_modes = (family == NFPROTO_IPV4) ?
+		hashlimit_modes4_xlate : hashlimit_modes6_xlate;
+	bool prevopt = false;
+	unsigned int mask;
+
+	mode &= ~XT_HASHLIMIT_INVERT & ~XT_HASHLIMIT_BYTES;
+
+	for (mask = 1; mode > 0; mask <<= 1) {
+		if (!(mode & mask))
+			continue;
+
+		if (!prevopt) {
+			xt_xlate_add(xl, " ");
+			prevopt = true;
+		}
+		else {
+			xt_xlate_add(xl, " . ");
+		}
+
+		xt_xlate_add(xl, "%s", _modes[mask]);
+
+		if (mask == XT_HASHLIMIT_HASH_DIP &&
+		    ((family == NFPROTO_IPV4 && ndst != 32) ||
+		     (family == NFPROTO_IPV6 && ndst != 128)))
+			hashlimit_print_subnet_xlate(xl, ndst, family);
+		else if (mask == XT_HASHLIMIT_HASH_SIP &&
+			 ((family == NFPROTO_IPV4 && nsrc != 32) ||
+			  (family == NFPROTO_IPV6 && nsrc != 128)))
+			hashlimit_print_subnet_xlate(xl, nsrc, family);
+
+		mode &= ~mask;
+	}
+
+	return prevopt;
+}
+
+static int hashlimit_mt_xlate(struct xt_xlate *xl, const char *name,
+			      const struct hashlimit_cfg2 *cfg,
+			      int revision, int family)
+{
+	int ret = 1;
+
+	xt_xlate_add(xl, "flow table %s {", name);
+	ret = hashlimit_mode_xlate(xl, cfg->mode, family,
+				   cfg->srcmask, cfg->dstmask);
+	xt_xlate_add(xl, " timeout %us limit rate", cfg->expire / 1000);
+
+	if (cfg->mode & XT_HASHLIMIT_INVERT)
+		xt_xlate_add(xl, " over");
+
+	if (cfg->mode & XT_HASHLIMIT_BYTES)
+		print_bytes_rate_xlate(xl, cfg);
+	else
+		print_packets_rate_xlate(xl, cfg->avg, cfg->burst, revision);
+
+	xt_xlate_add(xl, "}");
+
+	return ret;
+}
+
+static int hashlimit_xlate(struct xt_xlate *xl,
+			   const struct xt_xlate_mt_params *params)
+{
+	const struct xt_hashlimit_info *info = (const void *)params->match->data;
+	int ret = 1;
+
+	xt_xlate_add(xl, "flow table %s {", info->name);
+	ret = hashlimit_mode_xlate(xl, info->cfg.mode, NFPROTO_IPV4, 32, 32);
+	xt_xlate_add(xl, " timeout %us limit rate", info->cfg.expire / 1000);
+	print_packets_rate_xlate(xl, info->cfg.avg, info->cfg.burst, 1);
+	xt_xlate_add(xl, "}");
+
+	return ret;
+}
+
+static int hashlimit_mt4_xlate_v1(struct xt_xlate *xl,
+				  const struct xt_xlate_mt_params *params)
+{
+	const struct xt_hashlimit_mtinfo1 *info =
+		(const void *)params->match->data;
+	struct hashlimit_cfg2 cfg;
+
+	if (cfg_copy(&cfg, (const void *)&info->cfg, 1))
+		xtables_error(OTHER_PROBLEM, "unknown revision");
+
+	return hashlimit_mt_xlate(xl, info->name, &cfg, 1, NFPROTO_IPV4);
+}
+
+static int hashlimit_mt6_xlate_v1(struct xt_xlate *xl,
+				  const struct xt_xlate_mt_params *params)
+{
+	const struct xt_hashlimit_mtinfo1 *info =
+		(const void *)params->match->data;
+	struct hashlimit_cfg2 cfg;
+
+	if (cfg_copy(&cfg, (const void *)&info->cfg, 1))
+		xtables_error(OTHER_PROBLEM, "unknown revision");
+
+	return hashlimit_mt_xlate(xl, info->name, &cfg, 1, NFPROTO_IPV6);
+}
+
+static int hashlimit_mt4_xlate(struct xt_xlate *xl,
+			       const struct xt_xlate_mt_params *params)
+{
+	const struct xt_hashlimit_mtinfo2 *info =
+		(const void *)params->match->data;
+
+	return hashlimit_mt_xlate(xl, info->name, &info->cfg, 2, NFPROTO_IPV4);
+}
+
+static int hashlimit_mt6_xlate(struct xt_xlate *xl,
+			       const struct xt_xlate_mt_params *params)
+{
+	const struct xt_hashlimit_mtinfo2 *info =
+		(const void *)params->match->data;
+
+	return hashlimit_mt_xlate(xl, info->name, &info->cfg, 2, NFPROTO_IPV6);
+}
+
 static struct xtables_match hashlimit_mt_reg[] = {
 	{
 		.family        = NFPROTO_UNSPEC,
@@ -932,6 +1151,7 @@ static struct xtables_match hashlimit_mt_reg[] = {
 		.save          = hashlimit_save,
 		.x6_options    = hashlimit_opts,
 		.udata_size    = sizeof(struct hashlimit_mt_udata),
+		.xlate         = hashlimit_xlate,
 	},
 	{
 		.version       = XTABLES_VERSION,
@@ -948,6 +1168,7 @@ static struct xtables_match hashlimit_mt_reg[] = {
 		.save          = hashlimit_mt4_save_v1,
 		.x6_options    = hashlimit_mt_opts_v1,
 		.udata_size    = sizeof(struct hashlimit_mt_udata),
+		.xlate         = hashlimit_mt4_xlate_v1,
 	},
 	{
 		.version       = XTABLES_VERSION,
@@ -964,6 +1185,7 @@ static struct xtables_match hashlimit_mt_reg[] = {
 		.save          = hashlimit_mt6_save_v1,
 		.x6_options    = hashlimit_mt_opts_v1,
 		.udata_size    = sizeof(struct hashlimit_mt_udata),
+		.xlate         = hashlimit_mt6_xlate_v1,
 	},
 	{
 		.version       = XTABLES_VERSION,
@@ -980,6 +1202,7 @@ static struct xtables_match hashlimit_mt_reg[] = {
 		.save          = hashlimit_mt4_save,
 		.x6_options    = hashlimit_mt_opts,
 		.udata_size    = sizeof(struct hashlimit_mt_udata),
+		.xlate         = hashlimit_mt4_xlate,
 	},
 	{
 		.version       = XTABLES_VERSION,
@@ -996,6 +1219,7 @@ static struct xtables_match hashlimit_mt_reg[] = {
 		.save          = hashlimit_mt6_save,
 		.x6_options    = hashlimit_mt_opts,
 		.udata_size    = sizeof(struct hashlimit_mt_udata),
+		.xlate         = hashlimit_mt6_xlate,
 	},
 };
 
-- 
2.7.4

