From: Duncan Roe <duncan_roe@optusnet.com.au>
Subject: [PATCH v3] extensions: libxt_hashlimit: Do not insert default timeout or burst
Date: Wed,  3 Jan 2018 21:31:35 +1100
Message-ID: <20180103103135.18518-1-duncan_roe@optusnet.com.au>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:57742 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750861AbeACKbu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 05:31:50 -0500
Received: from dimstar.local.net (c220-239-53-24.eburwd6.vic.optusnet.com.au [220.239.53.24])
        by mail107.syd.optusnet.com.au (Postfix) with SMTP id E7592D4E96D
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jan 2018 21:31:37 +1100 (AEDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Do not output timeout or burst if not in original iptables command.

This version correctly translates all 3 examples in the wiki.

(This is a patch to previous commit 27de281d8aca84e3c841b3ae72a17616b1382ac4)

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 extensions/libxt_hashlimit.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index 472d8e7..64d976c 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -759,15 +759,15 @@ static void hashlimit_mt_check(struct xt_fcheck_call *cb)
 {
 	const struct hashlimit_mt_udata *udata = cb->udata;
 	struct xt_hashlimit_mtinfo3 *info = cb->data;
+	uint32_t burst = 0;
 
 	if (!(cb->xflags & (F_UPTO | F_ABOVE)))
 		xtables_error(PARAMETER_PROBLEM,
 				"You have to specify --hashlimit");
 	if (!(cb->xflags & F_HTABLE_EXPIRE))
-		info->cfg.expire = udata->mult * 1000; /* from s to msec */
+		info->cfg.expire = 0;
 
 	if (info->cfg.mode & XT_HASHLIMIT_BYTES) {
-		uint32_t burst = 0;
 		if (cb->xflags & F_BURST) {
 			if (info->cfg.burst < cost_to_bytes(info->cfg.avg))
 				xtables_error(PARAMETER_PROBLEM,
@@ -780,9 +780,9 @@ static void hashlimit_mt_check(struct xt_fcheck_call *cb)
 			if (!(cb->xflags & F_HTABLE_EXPIRE))
 				info->cfg.expire = XT_HASHLIMIT_BYTE_EXPIRE_BURST * 1000;
 		}
-		info->cfg.burst = burst;
 	} else if (info->cfg.burst > XT_HASHLIMIT_BURST_MAX)
 		burst_error();
+	info->cfg.burst = burst;
 
 	if (cb->xflags & F_RATEMATCH) {
 		if (!(info->cfg.mode & XT_HASHLIMIT_BYTES))
@@ -1209,7 +1209,7 @@ static const struct rates rates_xlate[] = {
 	{ "second", XT_HASHLIMIT_SCALE_v2 } };
 
 static void print_packets_rate_xlate(struct xt_xlate *xl, uint64_t avg,
-				     int revision)
+				     uint64_t burst, int revision)
 {
 	unsigned int i;
 	const struct rates *_rates = (revision == 1) ?
@@ -1220,8 +1220,9 @@ static void print_packets_rate_xlate(struct xt_xlate *xl, uint64_t avg,
 		    _rates[i].mult / avg < _rates[i].mult % avg)
 			break;
 
-	xt_xlate_add(xl, " %llu/%s ",
-		     _rates[i-1].mult / avg, _rates[i-1].name);
+	xt_xlate_add(xl, " %llu/%s", _rates[i-1].mult / avg, _rates[i-1].name);
+	if (burst)
+		xt_xlate_add(xl, " burst %lu packets", burst);
 }
 
 static void print_bytes_rate_xlate(struct xt_xlate *xl,
@@ -1341,7 +1342,7 @@ static int hashlimit_mt_xlate(struct xt_xlate *xl, const char *name,
 	xt_xlate_add(xl, "flow table %s {", name);
 	ret = hashlimit_mode_xlate(xl, cfg->mode, family,
 				   cfg->srcmask, cfg->dstmask);
-	if (cfg->expire != 1000)
+	if (cfg->expire)
 		xt_xlate_add(xl, " timeout %us", cfg->expire / 1000);
 	xt_xlate_add(xl, " limit rate");
 
@@ -1351,9 +1352,8 @@ static int hashlimit_mt_xlate(struct xt_xlate *xl, const char *name,
 	if (cfg->mode & XT_HASHLIMIT_BYTES)
 		print_bytes_rate_xlate(xl, cfg);
 	else
-		print_packets_rate_xlate(xl, cfg->avg, revision);
-	if (cfg->burst != 5)
-		xt_xlate_add(xl, " burst %lu packets", cfg->burst);
+		print_packets_rate_xlate(xl, cfg->avg, cfg->burst, revision);
+
 	xt_xlate_add(xl, "}");
 
 	return ret;
@@ -1368,8 +1368,7 @@ static int hashlimit_xlate(struct xt_xlate *xl,
 	xt_xlate_add(xl, "flow table %s {", info->name);
 	ret = hashlimit_mode_xlate(xl, info->cfg.mode, NFPROTO_IPV4, 32, 32);
 	xt_xlate_add(xl, " timeout %us limit rate", info->cfg.expire / 1000);
-	print_packets_rate_xlate(xl, info->cfg.avg, 1);
-	xt_xlate_add(xl, " burst %lu packets", info->cfg.burst);
+	print_packets_rate_xlate(xl, info->cfg.avg, info->cfg.burst, 1);
 	xt_xlate_add(xl, "}");
 
 	return ret;
-- 
2.9.0

